#ifndef KHEAP_H
#define KHEAP_H

#include <stddef.h>

void kheap_init();

void* kmalloc(size_t size);

void kfree(void* ptr);

#endif