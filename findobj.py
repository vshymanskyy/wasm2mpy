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
        self.archive = Archive(open(fn, "rb"))
        info = self.load_symbols()
        self.objs = info["objs"]
        self.symbols = info["symbols"]

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
        for entry in self.archive:
            obj_name = entry.name
            elf = elffile.ELFFile(self.archive.open(obj_name, "rb"))
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


def find_dependencies(target_symbol):
    visited = set()

    def traverse(symbol):
        if symbol in visited:
            return set()
        visited.add(symbol)

        objs = sym_def[symbol]
        if len(objs) == 0:
            print(f"Symbol {symbol} is undefined.")
            return set()

        if len(objs) > 1:
            print(f"Symbol {symbol} has multiple definitions: {list(objs)}.")
            return set()

        obj = list(objs)[0]
        dependencies = {obj}

        if obj in obj_undef:
            for undef_sym in obj_undef[obj]:
                dependencies.update(traverse(undef_sym))

        return dependencies

    return traverse(target_symbol)


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

    archives = {}

    for fn in archive_files:
        archive = CachedArFile(fn)

"""
        load_symbols(fn, archive)
        archives[fn] = archive

    for entry in find_dependencies(target_symbols[0]):
        ar, obj = entry.rsplit(":", maxsplit=1)
        content = archives[ar].open(obj, "rb").read()
        with open("runtime/libgcc-armv6m/" + obj, "wb") as output:
            output.write(content)
"""
