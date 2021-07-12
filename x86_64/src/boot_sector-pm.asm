; A boot sector that enters 32-bit mode.
[org 0x7c00]

    mov bp, 0x9000              ; Set the stack.
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string

    call switch_to_pm           ; Never return from here.

    jmp $

%include "src/lib/print_string.asm"
%include "src/lib/gdt.asm"
%include "src/lib/print_string_pm.asm"
%include "src/lib/switch_to_pm.asm"

[bits 32]

; This is where we arrive after switching to and initializing protected mode.
BEGIN_PM:

    mov ebx, MSG_PROT_MODE
    call print_string_pm        ; Use the 32-bits print routine.

    jmp $                       ; Hang.

; Global variables.
MSG_REAL_MODE db "Started in 16-bit real mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit Protected Mode", 0

; Bootsector padding.

    times 510-($-$$) db 0 
    dw 0xaa55