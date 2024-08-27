# Author:    Volodymyr Shymanskyy
# Created:   24.08.2024

# Location of top-level MicroPython directory
MPY_DIR ?= /opt/micropython
WABT_DIR ?= /opt/wabt-1.0.36
WASM2C = $(WABT_DIR)/bin/wasm2c

# x86, x64, armv6m, armv7m, armv7emsp, armv7emdp, xtensa, xtensawin
ARCH ?= armv6m
MOD = test
SRC += runtime.c wasm.c
SRC += wasm2c/wasm-rt-mem-impl.c wasm2c/wasm-rt-impl.c
#SRC += wasm2c/wasm-rt-exceptions-impl.c

ifeq ($(ARCH),armv6m)
SRC += thumb_case.S
endif

include $(MPY_DIR)/py/dynruntime.mk

CFLAGS += -Iwasm2c -Ibuild -Wno-unused-value -Wno-unused-function
CLEAN_EXTRA += wasm.c wasm.h

wasm.c: test.wasm
	$(Q)$(MKDIR) -p build
	$(ECHO) "W2C $<"
	$(Q)$(WASM2C) -o $@ --module-name=wasm $<
