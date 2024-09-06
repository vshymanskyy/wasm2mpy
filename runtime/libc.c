/**
 * Author:    Volodymyr Shymanskyy
 * Created:   24.08.2024
 **/

#include "py/dynruntime.h"

#include <stddef.h>
#include <stdlib.h>
#include <string.h>

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

int strncmp(const char *_l, const char *_r, size_t n) {
    const unsigned char *l=(void *)_l, *r=(void *)_r;
    if (!n--) return 0;
    for (; *l && *r && n && *l == *r ; l++, r++, n--);
    return *l - *r;
}

void abort() {
    mp_printf(&mp_plat_print, "Aborting\n");
    for(;;) {}  // Wait forever
}

#if defined(__ARM_EABI__)
int __aeabi_idiv0(int ret) {
    return ret;
}

long long __aeabi_ldiv0(long long ret) {
    return ret;
}
#endif
