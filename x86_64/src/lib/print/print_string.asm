print_string:
    pusha
    mov ah, 0x0e
    print_tring_loop:
        cmp [bx], byte 0
        je print_string_loop_end
        mov al, [bx]
        int 0x10
        inc bx
        jmp print_tring_loop
    print_string_loop_end:
    popa
    ret

print_hex:
    pusha

    push dx
    and dx, 0x000f
    mov bx, HEX_SYMBOLS
    add bx, dx
    mov al, [bx]
    mov [HEX_OUT + 5], al
    pop dx

    push dx
    and dx, 0x00f0
    shr dx, 4 
    mov bx, HEX_SYMBOLS
    add bx, dx
    mov al, [bx]
    mov [HEX_OUT + 4], al
    pop dx

    push dx
    and dx, 0x0f00
    shr dx, 8 
    mov bx, HEX_SYMBOLS
    add bx, dx
    mov al, [bx]
    mov [HEX_OUT + 3], al
    pop dx

    and dx, 0xf000
    shr dx, 12 
    mov bx, HEX_SYMBOLS
    add bx, dx
    mov al, [bx]
    mov [HEX_OUT + 2], al

    mov bx, HEX_OUT
    call print_string

    popa
    ret

HEX_OUT: db '0x0000', 0
HEX_SYMBOLS: db '0123456789abcdef'