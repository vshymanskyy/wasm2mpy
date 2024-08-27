# wasm2mpy

A bare-bones example demonstrating how to convert a `WASM` file into a `MPY` module and run it dynamically on a Raspberry Pi Pico, ESP8266, ESP32, etc.

> [!IMPORTANT]
> **This is purely a Proof-of-Concept, not optimized or ready for actual use.**

## Compile

You'll need:

- Python 3 + `pyelftools`
- [WABT](https://github.com/WebAssembly/wabt/releases/tag/1.0.36)
- [MicroPython v1.23.0](https://github.com/micropython/micropython) source code
- Target architecture toolchain

Set up the environment an build the `.mpy` module from `.wasm`:

```sh
export MPY_DIR=/path/to/micropython
export WABT_DIR=/path/to/wabt
export PATH=/opt/toolchain-xtensa/bin:$PATH
export PATH=/opt/toolchain-xtensa-esp32/bin:$PATH
pip install -U pyelftools
make ARCH=armv6m   # x86, x64, armv6m, armv7m, armv7emsp, armv7emdp, xtensa, xtensawin
```

Output:

```log
W2C test.wasm
GEN build/test.config.h
CC runtime.c
CC wasm.c
CC wasm2c/wasm-rt-mem-impl.c
CC wasm2c/wasm-rt-impl.c
AS thumb_case.S
LINK build/runtime.o
arch:         EM_ARM
text size:    1388
bss size:     108
GOT entries:  5
GEN test.mpy
```

## Upload to the board

```sh
mpremote cp test.mpy :lib/
```

## Run

In this example, `test.wasm` just adds 2 numbers:

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
>>> import test
>>> test.add(3, 4)
7
>>> test.add(10, 6)
16
```

## TODO

- [x] Support exports
- [ ] Support imports
- [ ] Support memory
- [ ] Auto-generate python bindings
- [ ] TBD: Support globals
- [ ] TBD: Optimize runtime
- [ ] Add RISC-V support: https://github.com/micropython/micropython/pull/15603

## Further reading

- https://github.com/wasm3/embedded-wasm-apps
- https://github.com/WebAssembly/wabt/blob/main/wasm2c/README.md
- https://github.com/turbolent/w2c2
- https://docs.micropython.org/en/latest/develop/natmod.html
- https://github.com/micropython/micropython/issues/15270#issuecomment-2280942885
