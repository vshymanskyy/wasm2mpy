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
  runtime/libc.c                \
  runtime/wasm-rt-mem-impl.c    \
  runtime/wasm-rt-impl.c
  #runtime/wasm-rt-exceptions-impl.c

SRC += $(BUILD)/wasm.c

ifeq ($(ARCH),xtensa)
  SRC += runtime/esp8266-rom.S
endif

MICROPY_LINK_RUNTIME = 1

# Wasm module to build
WASM ?= test/$(APP).wasm

include $(MPY_DIR)/py/dynruntime.mk

#-DWASM_RT_OPTIMIZE -Ofast
CFLAGS += -Os -Iruntime -I$(BUILD) -Wno-unused-value -Wno-unused-function \
          -Wno-unused-variable -Wno-unused-but-set-variable

#MPY_LD_FLAGS += -v

#CLEAN_EXTRA += $(BUILD)

$(BUILD)/wasm.c: $(WASM)
	$(Q)$(MKDIR) -p $(BUILD)
	$(ECHO) "W2C $<"
	$(Q)wasm2c -o $@ --no-debug-names --module-name="wasm" $<
	$(Q)sed -i 's/#if defined(__GNUC__) || defined(__clang__)/#if 0/' $@
	# Remove memchecks, assuming we trust the module
	#$(Q)sed -i 's/MEMCHECK(mem, addr, t1);//' $@

