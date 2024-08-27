/**
 * Author:    Volodymyr Shymanskyy
 * Created:   24.08.2024
 **/

#include "py/dynruntime.h"
#include "wasm.h"

// Declare an instance of the WASM module
w2c_wasm module;

static mp_obj_t add(mp_obj_t a_obj, mp_obj_t b_obj) {
    mp_int_t a = mp_obj_get_int(a_obj);
    mp_int_t b = mp_obj_get_int(b_obj);

    mp_int_t result = w2c_wasm_add(&module, a, b);

    return mp_obj_new_int(result);
}

static MP_DEFINE_CONST_FUN_OBJ_2(add_obj, add);


void* calloc( size_t num, size_t size ) {
    void *ptr = m_malloc(num * size);
    // memory already cleared by conservative GC
    return ptr;
}

void free( void *ptr ) {
    m_free(ptr);
}

void *realloc( void *ptr, size_t new_size ) {
    os_print_last_error("Notimpl: realloc");  // TODO
    return 0;
}

//__attribute__((weak))
void *memset( void *dest, int ch, size_t count ) {
    os_print_last_error("Notimpl: memset");   // TODO
    return dest;
}

//__attribute__((weak))
void* memcpy(void* dest, const void* src, size_t n) {
    unsigned char* d = dest;
    const unsigned char* s = src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
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
    wasm2c_wasm_instantiate(&module);

    w2c_app_0x5Finitialize(&module);
    w2c_app_0x5Fstart(&module);

    // Make the function available in the module's namespace
    mp_store_global(MP_QSTR_add, MP_OBJ_FROM_PTR(&add_obj));

    // This must be last, it restores the globals dict
    MP_DYNRUNTIME_INIT_EXIT
}
