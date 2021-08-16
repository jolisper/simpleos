[bits 32]
global _start

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

    jmp $               ; Hangs