#!/usr/bin/env python3

import os
import hashlib
import functools
import pickle

from ar import Archive
from elftools.elf import elffile
from collections import defaultdict

def pickle_cache(key, cache_path=".cache", prefix=""):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            cache_key = key(*args, **kwargs)
            cache_fn = os.path.join(cache_path, prefix + cache_key[:24])
            try:
                with open(cache_fn, "rb") as f:
                    d = pickle.load(f)
                if d["key"] != cache_key:
                    raise Exception("Cache key mismatch")
                return d["data"]
            except Exception as e:
                res = func(*args, **kwargs)
                try:
                    os.makedirs(cache_path, exist_ok=True)
                    with open(cache_fn, "wb") as f:
                        pickle.dump({
                            "key": cache_key,
                            "data": res,
                        }, f)
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

    @pickle_cache(key=_cache_key, prefix="ar_")
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
                        obj["weak"].add(sym_name)

        return {"objs": dict(objs), "symbols": symbols}


def resolve(archives, symbols):
    resolved_objs = set()       # Object files needed to resolve symbols
    unresolved_symbols = set()
    provided_symbols = {}       # Which symbol is provided by which object
    symbol_stack = list(symbols)

    # A helper function to handle symbol resolution from a particular object
    def add_obj(archive, symbol):
        obj_name = archive.symbols[symbol]
        obj_info = archive.objs[obj_name]

        if obj_name in resolved_objs:
            return  # Already processed this object

        resolved_objs.add((archive, obj_name))

        # Add the symbols this object defines
        for defined_symbol in obj_info['def']:
            if defined_symbol in provided_symbols:
                raise RuntimeError(f"Multiple non-weak definitions for symbol: {defined_symbol}")
            provided_symbols[defined_symbol] = obj_name

        # Recursively add undefined symbols from this object
        for undef_symbol in obj_info['undef']:
            if undef_symbol not in provided_symbols:
                symbol_stack.append(undef_symbol)  # Add undefined symbol to resolve

    while symbol_stack:
        symbol = symbol_stack.pop()

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

    return list(resolved_objs)

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <archive-files> <symbols>")
        sys.exit(1)

    archive_files = []
    target_symbols = []

    for arg in sys.argv[1:]:
        if arg.endswith(".a"):
            archive_files.append(arg)
        else:
            target_symbols.append(arg)

    archives = [ CachedArFile(fn) for fn in archive_files ]
    result = resolve(archives, target_symbols)
    for ar, obj in result:
        print(ar.fn, obj)
        content = ar.open(obj).read()
        with open("runtime/libgcc-armv6m/" + obj, "wb") as output:
            output.write(content)

