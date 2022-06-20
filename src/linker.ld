ENTRY(_start)
OUTPUT_FORMAT(binary)
SECTIONS {
    . = 1M;

    .text : ALIGN(4096) {
        *(.text)
    }

    .rodata : ALIGN(4096) {
        *(.rodata)
    }

    .data : ALIGN(4096) {
        *(.data)
    }

    .bss : ALIGN(4096) {
        *(COMMON)
        *(.bss)
    }

    /* To avoid issues with unaligned ASM code, we put it at the end */
    .asm : ALIGN(4096) {
        *(.asm)
    }
}
