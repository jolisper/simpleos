;
; A boot sector that prints a string using an included function.
;

[org 0x7c00]                        ; Tell the assembler where this code will be loaded

    mov bx, HELLO_STRING            ; Use BX as a parameter to print function, so
    call print_string               ; we can specify the address of a string.

    mov bx, GOODBYE_STRING
    call print_string

    jmp $                           ; Hang

%include "src/lib/print_string.asm"

; Data
HELLO_STRING:
    db 'Hello, World!', 0xa, 0xd, 0 ; 0xa = New line, 0xd = Carrier return
    
GOODBYE_STRING:
    db 'Goodbye!', 0xa, 0xd, 0

; Padding and magic BIOS number.

    times 510-($-$$) db 0 
    dw 0xaa55