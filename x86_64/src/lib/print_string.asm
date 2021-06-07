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
