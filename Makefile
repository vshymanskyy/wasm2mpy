# Author:    Volodymyr Shymanskyy
# Created:   24.08.2024

# Location of top-level MicroPython directory
MPY_DIR ?= /opt/micropython

# x86, x64, armv6m, armv7m, armv7emsp, armv7emdp, xtensa, xtensawin
ARCH ?= armv6m
MOD = test
SRC += runtime/runtime.c        \
  runtime/wasm-rt-mem-impl.c    \
  runtime/wasm-rt-impl.c
  #runtime/wasm-rt-exceptions-impl.c

SRC += wasm/wasm.c

ifeq ($(ARCH),armv6m)
SRC += runtime/thumb_case.S
endif

include $(MPY_DIR)/py/dynruntime.mk

CFLAGS += -Iruntime -Iwasm -Wno-unused-value -Wno-unused-function
CLEAN_EXTRA += wasm

wasm/wasm.c: test.wasm
	$(Q)$(MKDIR) -p build
	$(Q)$(MKDIR) -p wasm
	$(ECHO) "W2C $<"
	$(Q)wasm2c -o $@ --no-debug-names --module-name="wasm" $<
