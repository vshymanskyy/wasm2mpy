
# Build `wasm2mpy`

> [!WARNING]
> **This is a Proof-of-Concept, not optimized or ready for actual use.**

You'll need:

- Python 3
  - `pip install --upgrade pyelftools ar`
- `wasm2c` from [WABT](https://github.com/WebAssembly/wabt/releases/tag/1.0.36)
- Latest [MicroPython](https://github.com/micropython/micropython) source code
- Target architecture toolchain

Set up the environment and build the `.mpy` module from `.wasm`:

```sh
export MPY_DIR=/path/to/micropython
export PATH=/opt/wabt/bin:$PATH
export PATH=/opt/xtensa-lx106-elf/bin:$PATH
export PATH=/opt/xtensa-esp32-elf/bin:$PATH
pip install -U pyelftools
make ARCH=xtensawin APP=zig   # x86, x64, armv6m, armv7m, armv7emsp, armv7emdp, xtensa, xtensawin
```

Output:

```log
W2C test/zig.wasm
GEN build/zig.config.h
CC runtime/runtime.c
CC runtime/wasm-rt-mem-impl.c
CC runtime/wasm-rt-impl.c
CC .wasm/wasm.c
LINK build/runtime/runtime.o
arch:         EM_XTENSA
text size:    3524
rodata size:  850
bss size:     144
GOT entries:  57
GEN zig.mpy
```
