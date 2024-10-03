/**
 * Author:    Volodymyr Shymanskyy
 * Created:   24.08.2024
 **/

#if !defined(__riscv)
// define errno before any includes so it gets into BSS
int errno;
#endif

#include "py/dynruntime.h"

#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

void *calloc(size_t num, size_t size) {
    void *ptr = m_malloc(num * size);
    // memory already cleared by conservative GC
    return ptr;
}

void free(void *ptr) {
    m_free(ptr);
}

void *realloc(void *ptr, size_t new_size) {
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

int strcmp(const char *l, const char *r)
{
    for (; *l==*r && *l; l++, r++);
    return *(unsigned char *)l - *(unsigned char *)r;
}

int strncmp(const char *_l, const char *_r, size_t n) {
    const unsigned char *l=(void *)_l, *r=(void *)_r;
    if (!n--) return 0;
    for (; *l && *r && n && *l == *r ; l++, r++, n--);
    return *l - *r;
}

#if !defined(__riscv)
int *__errno(void) {
    return &errno;
}

int *__errno_location(void) {
    return &errno;
}
#endif

__attribute__ ((noreturn))
void abort(void) {
    //mp_printf(&mp_plat_print, "WASM: Aborting\n");
    //__builtin_trap();
    mp_raise_msg(&mp_type_RuntimeError, "WASM: Aborted");
    for(;;) {}  // Should not reach here
}

__attribute__ ((noreturn))
void __stack_chk_fail(void) {
    abort();
}

__attribute__ ((noreturn))
void __stack_chk_fail_local(void) {
    abort();
}

#if defined(__x86_64__) || defined(__i386__)
// Allocate memory for cpu_features struct
const char _dl_x86_cpu_features[80];
#endif
