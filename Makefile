# Author:    Volodymyr Shymanskyy
# Created:   24.08.2024

# Location of top-level MicroPython directory
MPY_DIR ?= /opt/micropython
APP ?= wat

BUILD ?= build

# x86, x64, armv6m, armv7m, armv7emsp, armv7emdp, xtensa, xtensawin
ARCH ?= armv6m
MOD ?= $(APP)
SRC += runtime/runtime.c        \
  runtime/wasm-rt-mem-impl.c    \
  runtime/wasm-rt-impl.c
  #runtime/wasm-rt-exceptions-impl.c

SRC += $(BUILD)/wasm.c

# Wasm module to build
WASM ?= test/$(APP).wasm

ifeq ($(ARCH),armv6m)
SRC += runtime/thumb_case.S
endif

include $(MPY_DIR)/py/dynruntime.mk

CFLAGS += -Iruntime -I$(BUILD) -Wno-unused-value -Wno-unused-function \
          -Wno-unused-variable -Wno-unused-but-set-variable
#CLEAN_EXTRA += $(BUILD)

$(BUILD)/wasm.c: $(WASM)
	$(Q)$(MKDIR) -p build
	$(Q)$(MKDIR) -p $(BUILD)
	$(ECHO) "W2C $<"
	$(Q)wasm2c -o $@ --no-debug-names --module-name="wasm" $<
	$(Q)sed -i 's/#if defined(__GNUC__) || defined(__clang__)/#if 0/' $@
