[bits 32]
global _start
extern kernel_main

CODE_SEGMENT equ 0x8
DATA_SEGMENT equ 0x10

_start:
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set the stack
    mov ebp, 0x00200000
    mov esp, ebp

    ; Enable A20 address line; https://wiki.osdev.org/A20_Line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Remap the master PIC
    mov al, 00010001b
    out 0x20, al            ; Tell master PIC

    mov al, 0x20            ; Interrupt 0x20 is where master ISR should start
    out 0x21, al

    mov al, 00000001b
    out 0x21, al
    ; End remap of the master PIC

    ; Enable interrupts
    sti

    call kernel_main

    jmp $               ; Hangs

    ; The code in this file must be the first to run when the bootloader jump to 0x0100000,
    ; to avoid aligment issues when we mixup unaligned asm code with 16-bits aligned C code,
    ; we complete the sector with zeroes, so, 512 mod 16 = 0, so is 16-bit aligned like C code.
    times 512-($-$$) db 0