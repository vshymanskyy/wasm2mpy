/**
 * Author:    Volodymyr Shymanskyy
 * Created:   24.08.2024
 **/

#include "py/dynruntime.h"
#include "wasm.h"

/***************************************
 * Basic runtime
 ***************************************/

void* calloc( size_t num, size_t size ) {
    void *ptr = m_malloc(num * size);
    // memory already cleared by conservative GC
    return ptr;
}

void free( void *ptr ) {
    m_free(ptr);
}

void *realloc( void *ptr, size_t new_size ) {
    return m_realloc(ptr, new_size);
}

void *memcpy(void *dst, const void *src, size_t n) {
    return mp_fun_table.memmove_(dst, src, n);
}

void *memset(void *s, int c, size_t n) {
    return mp_fun_table.memset_(s, c, n);
}

void *memmove(void *dest, const void *src, size_t n) {
    return mp_fun_table.memmove_(dest, src, n);
}

int memcmp(const void *vl, const void *vr, size_t n) {
    const unsigned char *l=vl, *r=vr;
    for (; n && *l == *r; n--, l++, r++);
    return n ? *l-*r : 0;
}

size_t strlen(const char *str) {
    const char *s;
    for (s = str; *s; ++s);
    return (s - str);
}

void abort() {
    mp_printf(&mp_plat_print, "Aborting");
    for(;;) {}  // Wait forever
}


void os_print_last_error(const char* msg) {
    mp_printf(&mp_plat_print, "Error: %s\n", msg);
    abort();
}

void wasm_rt_trap_handler(wasm_rt_trap_t code) {
    mp_printf(&mp_plat_print, "Trap: %d\n", code);
    abort();
}


/***************************************
 * WASM module runtime
 ***************************************/

// Instance of the WASM module
w2c_wasm module;

// Exported Functions

static mp_obj_t setup(void) {
    w2c_wasm_setup(&module);
    return mp_const_none;
}

static MP_DEFINE_CONST_FUN_OBJ_0(setup_obj, setup);

static mp_obj_t loop(void) {
    w2c_wasm_loop(&module);
    return mp_const_none;
}

static MP_DEFINE_CONST_FUN_OBJ_0(loop_obj, loop);

// Imported Functions

void w2c_wiring_stopWdt(struct w2c_wiring* wiring) {
}

void w2c_wiring_delay(struct w2c_wiring* wiring, u32 t) {
    // TODO: delay(t);
}

u32 w2c_wiring_millis(struct w2c_wiring* wiring) {
    return 0; //millis();
}

void w2c_wiring_pinMode(struct w2c_wiring* wiring, u32 pin, u32 mode) {
    /*switch (mode) {
    case 0: pinMode(pin, INPUT);        break;
    case 1: pinMode(pin, OUTPUT);       break;
    case 2: pinMode(pin, INPUT_PULLUP); break;
    }*/
}

void w2c_wiring_digitalWrite(struct w2c_wiring* wiring, u32 pin, u32 value) {
    //digitalWrite(pin, value);
}

void w2c_wiring_print(struct w2c_wiring* wiring, u32 offset, u32 len) {
    mp_printf(&mp_plat_print, "%.*s", len, (const uint8_t*)module.w2c_memory.data + offset);
}

// Module Initialization

__attribute__((weak))
void w2c_app_0x5Finitialize(w2c_wasm* module) {}

__attribute__((weak))
void w2c_app_0x5Fstart(w2c_wasm* module) {}

mp_obj_t mpy_init(mp_obj_fun_bc_t *self, size_t n_args, size_t n_kw, mp_obj_t *args) {
    // This must be first, it sets up the globals dict and other things
    MP_DYNRUNTIME_INIT_ENTRY

    // Initialize the Wasm runtime
    wasm_rt_init();

    // Construct the module instance
    wasm2c_wasm_instantiate(&module, NULL);

    w2c_app_0x5Finitialize(&module);
    w2c_app_0x5Fstart(&module);

    // Make the function available in the module's namespace
    mp_store_global(MP_QSTR_setup, MP_OBJ_FROM_PTR(&setup_obj));
    mp_store_global(MP_QSTR_loop, MP_OBJ_FROM_PTR(&loop_obj));

    // This must be last, it restores the globals dict
    MP_DYNRUNTIME_INIT_EXIT
}
