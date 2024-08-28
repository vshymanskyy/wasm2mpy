# wasm2mpy

Convert `WebAssembly` binary into a `MicroPython` module and run it dynamically on a Raspberry Pi Pico, ESP8266, ESP32, etc.

> [!IMPORTANT]
> **This is purely a Proof-of-Concept, not optimized or ready for actual use.**  
> Some builds currently fail because ABI libraries are not being linked.  
> 🚧 This is Work-In-Progress 🚧

| App \ Target   | x86   | x64   | arm-m0   | arm-m3  | arm-m4      | arm-m7       | esp8266  | esp32      |
|----------------|-------|-------|----------|---------|-------------|--------------|----------|------------|
| AssemblyScript | 🟢    | 🟢    | 🟥       | 🟢      | 🟢          | 🟢          | 🟥       | 🟢         |
| C++            | 🟢    | 🟢    | 🟥       | 🟢      | 🟢          | 🟢          | 🟥       | 🟢         |
| Rust           | 🟢    | 🟢    | 🟥       | 🟢      | 🟢          | 🟢          | 🟥       | ⏳         |
| TinyGo         | 🟢    | 🟢    | 🟥       | 🟢      | 🟢          | 🟢          | 🟥       | 🟢         |
| Virgil         | 🟢    | 🟢    | ⏳       | 🟢      | 🟢          | 🟢          | 🟢       | 🟢         |
| WAT            | 🟢    | 🟢    | ⏳       | 🟢      | 🟢          | 🟢          | 🟢       | 🟢         |
| Zig            | 🟢    | 🟢    | ⏳       | 🟢      | 🟢          | 🟢          | 🟥       | 🟢         |
| C99 Coremark   | 🟢    | 🟢    | 🟥       | 🟢      | 🟢          | 🟢          | 🟥       | 🟢         |

## Compile

You'll need:

- Python 3 + `pyelftools`
- [WABT](https://github.com/WebAssembly/wabt/releases/tag/1.0.36)
- [MicroPython v1.23.0](https://github.com/micropython/micropython) source code
- Target architecture toolchain

Set up the environment and build the `.mpy` module from `.wasm`:

```sh
export MPY_DIR=/path/to/micropython
export WABT_DIR=/path/to/wabt
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

## Upload and Run

```sh
mpremote cp zig.mpy :lib/
mpremote exec "import zig; zig.setup()"
⚡ Zig is running!
```

## Run any exported function

> [!NOTE]
> This requires adding some glue code to the runtime.  
> Glue code can be auto-generated, but for now it's a manual process.

For example, `test/simple.wasm` just adds 2 numbers:

```wat
(module
    (func (export "add") (param i32 i32) (result i32)
        (i32.add (local.get 0) (local.get 1))
    )
)
```

```log
MicroPython v1.24.0-preview.224.g6c3dc0c0b on 2024-08-22; Raspberry Pi Pico W with RP2040
Type "help()" for more information.
>>> import simple
>>> simple.add(3, 4)
7
>>> simple.add(10, 6)
16
```

## TODO

- [ ] Fix linking with native toolchain ABI
- [x] Support exports
  - [ ] Auto-generate exports bindings
- [x] Support imports
  - [ ] Use functions of other modules like `time`, `machine` etc.
  - [ ] Implement `millis()`, run Coremark
- [x] Support memory
  - [ ] Expose memory to Python
- [ ] TBD: Support globals
- [ ] Add RISC-V support: https://github.com/micropython/micropython/pull/15603

## Future Work

- [XIP for native modules](https://github.com/orgs/micropython/discussions/12811#discussioncomment-7399671)
- Support `.a` inputs for `mpy_ld`
- `mpy_ld` to perform optimizations, i.e. removing unreferenced code and data

## Further reading

- `wasm2mpy` discussion: https://github.com/orgs/micropython/discussions/15702
- https://github.com/wasm3/embedded-wasm-apps
- https://github.com/WebAssembly/wabt/blob/main/wasm2c/README.md
- https://github.com/turbolent/w2c2
- https://docs.micropython.org/en/latest/develop/natmod.html
- https://github.com/micropython/micropython/issues/15270#issuecomment-2280942885
