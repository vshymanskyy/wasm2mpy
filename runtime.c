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
    return 0;
}

void free( void *ptr ) {

}

void *realloc( void *ptr, size_t new_size ) {
    return 0;
}

void *memset( void *dest, int ch, size_t count ) {
    return dest;
}

void* memcpy( void* dest, const void* src, size_t count ) {
    return dest;
}

void abort() {
    for(;;);
}

mp_obj_t mpy_init(mp_obj_fun_bc_t *self, size_t n_args, size_t n_kw, mp_obj_t *args) {
    // This must be first, it sets up the globals dict and other things
    MP_DYNRUNTIME_INIT_ENTRY

    // Initialize the Wasm runtime
    wasm_rt_init();

    // Construct the module instance
    wasm2c_wasm_instantiate(&module);

    // Make the function available in the module's namespace
    mp_store_global(MP_QSTR_add, MP_OBJ_FROM_PTR(&add_obj));

    // This must be last, it restores the globals dict
    MP_DYNRUNTIME_INIT_EXIT
}
