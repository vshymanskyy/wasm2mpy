# <img height="48px" src="/logo.png"> wasm2mpy

[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md) 
[![Build status](https://img.shields.io/github/actions/workflow/status/vshymanskyy/wasm2mpy/build.yml?branch=main&style=flat-square&logo=github&label=build)](https://github.com/vshymanskyy/wasm2mpy/actions) 
[![GitHub license](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/vshymanskyy/wasm2mpy) 
[![Support vshymanskyy](https://img.shields.io/static/v1?label=support&message=%E2%9D%A4&color=%23fe8e86)](https://quicknote.io/da0a7d50-bb49-11ec-936a-6d7fd5a2de08) 

Compile `WebAssembly` binary into a `MicroPython` module and load it dynamically on ESP32, Raspberry Pi Pico, STM32, nRF52 etc.

## Status

| App \ Target      | x86/x64   | armv6m[^3]  | armv7m/+s/+d | esp8266[^2]  | esp32      | rv32imc  |
|-------------------|-----------|----------|---------|----------|------------|----------|
| 🚀 TypeScript[^1] | ✅✅    | ✅       | ✅✅✅      | ⚠️[^4]   | ✅         | 🚧       |
| 🤩 C++            | ✅✅    | ✅       | ✅✅✅      | 🟡       | ✅         | 🚧       |
| 🦀 Rust           | ✅✅    | ✅       | 🟡🟡✅      | ⚠️[^4]   | ✅         | 🚧       |
| 🤖 TinyGo         | ✅✅    | ✅       | 🟡🟡✅      | ⚠️[^4]   | ✅         | 🚧       |
| ⚡ Zig            | ✅✅    | ✅       | ✅✅✅      | ⚠️[^4]   | ✅         | 🚧       |
| ✨ Virgil         | ✅✅    | ✅       | ✅✅✅      | 🟡       | ✅         | 🚧       |
| ⚙ WAT            | ✅✅    | ✅       | ✅✅✅      | 🟡       | ✅         | 🚧       |
| 🇨 Coremark       | ✅✅    | 🚧       | ✅✅✅      | 🟡       | ✅         | 🚧       |

✅ builds and runs OK  
🟡 builds OK, doesn't run  
🚧 work in progress  

[^1]: [AssemblyScript](https://www.assemblyscript.org)
[^2]: `esp8266` requires the use of [`esp.set_native_code_location`](https://github.com/micropython/micropython/issues/14430#issuecomment-2332648018), and setting `WASM_PAGE_SIZE` to `8192` (or need to wait for [`WASM Custom Page Sizes`][1])
[^3]: `armv6m` depends on [jumping more than 2k](https://github.com/micropython/micropython/pull/15812)
[^4]: not enough memory to run, need to wait for [`WASM Custom Page Sizes`][1]

## CoreMark results

- **STM32F405** 168MHz: `233.918`
- **ESP32** 240MHz: `228.363`
- **ESP32-S3** 240MHz: `271.573`
- **iMXRT1062** 600MHz: `1911.437`
- **i5-8250U** 1.6GHz: `18696.248`

## Compile

> [!IMPORTANT]
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

## Access WASM module memory

```py
>>> import cpp
>>> cpp.setup()
🤩 C++ is running!
>>> cpp._memory[4096:4096+32]
bytearray(b' Blink\x00\xf0\x9f\xa4\xa9 C++ is running!\x00\n\x00\x00\x00')
>>> new_data = b"Hello C++ world"
>>> cpp._memory[4096+12:4096+12+len(new_data)] = new_data
>>> cpp.setup()
🤩 Hello C++ world
```

## TODO

- [x] Support exports
  - [ ] Auto-generate exports bindings
- [x] Support imports
- [x] Support memory
- [x] [Support `.a` inputs for `mpy_ld`](https://github.com/micropython/micropython/pull/15838)
- [ ] TBD: Support globals
- [ ] Add RISC-V support: https://github.com/micropython/micropython/pull/15603
- [ ] Optimize codegen
  - [ ] Use `u32` instead of `u64` for mem addresses
  - [ ] Use a directly addressable `.bss` section as memory (skip indirection)

## Future Work

- [XIP for native modules](https://github.com/orgs/micropython/discussions/12811#discussioncomment-7399671)
- Implement [WASM Custom Page Sizes][1]
- Implement WASM Exceptions 
- Implement [WASM Stack Switching](https://github.com/WebAssembly/stack-switching/blob/main/proposals/stack-switching/Explainer.md)

## Further reading

- `wasm2mpy` discussion: https://github.com/orgs/micropython/discussions/15702
- https://github.com/wasm3/embedded-wasm-apps
- https://github.com/WebAssembly/wabt/blob/main/wasm2c/README.md
- https://github.com/turbolent/w2c2
- https://docs.micropython.org/en/latest/develop/natmod.html
- https://github.com/micropython/micropython/issues/15270#issuecomment-2280942885

[1]: https://github.com/WebAssembly/custom-page-sizes/blob/main/proposals/custom-page-sizes/Overview.md
