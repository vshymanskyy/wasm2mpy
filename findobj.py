#!/usr/bin/env python3

import os
import hashlib
import functools
import pickle

from ar import Archive
from elftools.elf import elffile
from collections import defaultdict

class PickleCache:
    def __init__(self, path=".cache", prefix=""):
        self.path = path
        self._get_fn = lambda key: os.path.join(path, prefix + key[:24])
    def store(self, key, data):
        os.makedirs(self.path, exist_ok=True)
        with open(self._get_fn(key), "wb") as f:
            pickle.dump(data, f)
    def load(self, key):
        with open(self._get_fn(key), "rb") as f:
            return pickle.load(f)

def cached(key, cache):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            cache_key = key(*args, **kwargs)
            try:
                d = cache.load(cache_key)
                if d["key"] != cache_key:
                    raise Exception("Cache key mismatch")
                return d["data"]
            except Exception as e:
                res = func(*args, **kwargs)
                try:
                    cache.store(cache_key, {
                        "key": cache_key,
                        "data": res,
                    })
                except Exception as e:
                    pass
                return res
        return wrapper
    return decorator


class CachedArFile:
    def __init__(self, fn):
        self.fn = fn
        self._archive = Archive(open(fn, "rb"))
        info = self.load_symbols()
        self.objs = info["objs"]
        self.symbols = info["symbols"]

    def open(self, obj):
        return self._archive.open(obj, "rb")

    def _cache_key(self):
        with open(self.fn, "rb") as f:
            digest = hashlib.file_digest(f, "sha3_256")
            # Change this salt if the cache data format changes
            digest.update(bytes.fromhex("45155db4bc868fa78cb99c3448b2bf2b"))
        return digest.hexdigest()

    @cached(key=_cache_key, cache=PickleCache(prefix="ar_"))
    def load_symbols(self):
        print("Loading", self.fn)
        objs = defaultdict(lambda: {"def": set(), "undef": set(), "weak": set()})
        symbols = {}
        for entry in self._archive:
            obj_name = entry.name
            elf = elffile.ELFFile(self.open(obj_name))
            symtab = elf.get_section_by_name(".symtab")
            if not symtab:
                continue

            obj = objs[obj_name]

            for symbol in symtab.iter_symbols():
                sym_name = symbol.name
                sym_bind = symbol["st_info"]["bind"]
                #info = symbol["st_info"]["type"]

                if sym_bind in ("STB_GLOBAL", "STB_WEAK"):
                    if symbol.entry["st_shndx"] != "SHN_UNDEF":
                        obj["def"].add(sym_name)
                        symbols[sym_name] = obj_name
                    else:
                        obj["undef"].add(sym_name)

                    if sym_bind == "STB_WEAK":
                        #print("Weak", sym_name, symbol.entry["st_shndx"])
                        obj["weak"].add(sym_name)

        return {"objs": dict(objs), "symbols": symbols}


def resolve(archives, symbols):
    resolved_objs = []          # Object files needed to resolve symbols
    unresolved_symbols = set()
    provided_symbols = {}       # Which symbol is provided by which object
    symbol_stack = list(symbols)

    # A helper function to handle symbol resolution from a particular object
    def add_obj(archive, symbol):
        obj_name = archive.symbols[symbol]
        obj_info = archive.objs[obj_name]

        obj_tuple = (archive, obj_name)
        if obj_tuple in resolved_objs:
            return  # Already processed this object

        resolved_objs.append(obj_tuple)

        # Add the symbols this object defines
        for defined_symbol in obj_info['def']:
            if defined_symbol in provided_symbols:
                raise RuntimeError(f"Multiple non-weak definitions for symbol: {defined_symbol}")
            provided_symbols[defined_symbol] = obj_name  # TODO: save if week

        # Recursively add undefined symbols from this object
        for undef_symbol in obj_info['undef']:
            if undef_symbol in obj_info['weak']:
                print(f"Skippping weak dependency: {undef_symbol}")
                continue
            if undef_symbol not in provided_symbols:
                symbol_stack.append(undef_symbol)  # Add undefined symbol to resolve

    while symbol_stack:
        symbol = symbol_stack.pop(0)

        if symbol in provided_symbols:
            continue  # Symbol is already resolved

        found = False
        for archive in archives:
            if symbol in archive.symbols:
                add_obj(archive, symbol)
                found = True
                break

        if not found:
            unresolved_symbols.add(symbol)

    # At this point, all resolvable symbols are resolved
    if unresolved_symbols:
        raise RuntimeError(f"Unresolved symbols: {', '.join(unresolved_symbols)}")

    return resolved_objs

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='Resolve dependencies from archive files.')
    parser.add_argument('--arch',            help='Target architecture to extract objects to')
    parser.add_argument('-v', '--verbose',   help='increase output verbosity', action='store_true')
    parser.add_argument('inputs', nargs='+', help='AR archive files and symbols to resolve')
    args = parser.parse_args()

    # Separate files and symbols
    archives = [CachedArFile(item) for item in args.inputs if item.endswith('.a')]
    symbols = [item for item in args.inputs if not item.endswith('.a')]

    result = resolve(archives, symbols)

    # Extract files
    for ar, obj in result:
        print(os.path.basename(ar.fn) + ':' + obj)
        if args.verbose:
            print('  def:', ','.join(ar.objs[obj]['def']))
            print('  req:', ','.join(ar.objs[obj]['undef']))
        if args.arch:
            content = ar.open(obj).read()
            with open(f'runtime/libgcc-{args.arch}/{obj}', 'wb') as output:
                output.write(content)
