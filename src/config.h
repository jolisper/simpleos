#ifndef CONFIG_H
#define CONFIG_H

#define OS_TOTAL_INTERRUPTS 512
#define KERNEL_CODE_SELECTOR 0x08
#define KERNEL_DATA_SElECTOR 0x10

#define OS_HEAP_SIZE_BYTES 104857600        // 100MB heap size
#define OS_HEAP_BLOCK_SIZE 4096
#define OS_HEAP_ADDRESS 0x01000000 
#define OS_HEAP_TABLE_ADDRESS 0x00007E00

#endif