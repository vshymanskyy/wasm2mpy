# wasm2mpy

Convert `WebAssembly` binary into a `MicroPython` module and load it dynamically on a Raspberry Pi Pico, ESP8266, ESP32, etc.

<img width="30%" src="/logo.png">

> [!IMPORTANT]
> **This is a Proof-of-Concept, not optimized or ready for actual use.**

| App \ Target      | x86   | x64   | armv6m³  | armv7m/+s/+d | esp8266²  | esp32      | rv32imc  |
|-------------------|-------|-------|----------|---------|----------|------------|----------|
| 🚀 TypeScript¹    | 📦    | ✅    | ✅       | ✅✅✅      | ⚠️⁴      | ✅         | 🚧       |
| 🤩 C++            | 📦    | ✅    | ✅       | ✅✅✅      | ☠       | ✅         | 🚧       |
| 🦀 Rust           | 📦    | ✅    | ✅       | ☠☠✅      | ⚠️⁴      | ✅         | 🚧       |
| 🤖 TinyGo         | 📦    | ☠    | ☠       | ☠☠☠      | ⚠️⁴      | ☠         | 🚧       |
| ⚡ Zig            | 📦    | ✅    | ✅       | ✅✅✅      | ⚠️⁴      | ✅         | 🚧       |
| ✨ Virgil         | 📦    | ✅    | ✅       | ✅✅✅      | ☠       | ✅         | 🚧       |
| ⚙ WAT            | 📦    | ✅    | ✅       | ✅✅✅      | ☠       | ✅         | 🚧       |
| 🇨 Coremark       | 📦    | ✅    | ☠       | ✅✅✅      | ☠       | ✅         | 🚧       |

✅ - builds and runs OK  
📦 - builds OK  
☠ - issues in runtime  
🚧 - work in progress  
¹ AssemblyScript  
² ESP8266 requires the use of [`esp.set_native_code_location`](https://github.com/micropython/micropython/issues/14430#issuecomment-2332648018), and setting `WASM_PAGE_SIZE` to `8192`  
³ armv6m depends on [Support modules larger than 4KiB](https://github.com/micropython/micropython/pull/12241)  
⁴ not enough memory to run, requires `WASM Custom Page Sizes`  

## Compile

You'll need:

- Python 3 + `pip install --upgrade pyelftools ar`
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

## CoreMark results

| ESP32 `240MHz` | iMXRT1062 `600MHz` | STM32F405 `168MHz` |
|----------------|--------------------|--------------------|
| 271.573        | 1911.437           | 233.918            |

## TODO

- [x] Support exports
  - [ ] Auto-generate exports bindings
- [x] Support imports
- [x] Support memory
- [ ] [Support `.a` inputs for `mpy_ld`](https://github.com/micropython/micropython/pull/15838)
- [ ] TBD: Support globals
- [ ] Add RISC-V support: https://github.com/micropython/micropython/pull/15603
- [ ] Optimize codegen
  - [ ] Use `u32` instead of `u64` for mem addresses
  - [ ] Use a directly addressable `.bss` section as memory (skip indirection)

## Future Work

- [XIP for native modules](https://github.com/orgs/micropython/discussions/12811#discussioncomment-7399671)
- Implement [WASM Custom Page Sizes](https://github.com/WebAssembly/custom-page-sizes/blob/main/proposals/custom-page-sizes/Overview.md)
- Implement WASM Exceptions 
- Implement [WASM Stack Switching](https://github.com/WebAssembly/stack-switching/blob/main/proposals/stack-switching/Explainer.md)

## Further reading

- `wasm2mpy` discussion: https://github.com/orgs/micropython/discussions/15702
- https://github.com/wasm3/embedded-wasm-apps
- https://github.com/WebAssembly/wabt/blob/main/wasm2c/README.md
- https://github.com/turbolent/w2c2
- https://docs.micropython.org/en/latest/develop/natmod.html
- https://github.com/micropython/micropython/issues/15270#issuecomment-2280942885
