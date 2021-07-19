[bits 32]
; Video constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminaed string pointed to by EDX
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY        ; Set edx to the start of vis mem.

    .loop:
    mov al, [ebx]               ; Store the char as EDX in AL
    mov ah, WHITE_ON_BLACK      ; Store the attributes in AH

    cmp al, 0                   ; if (AL == 0), at end of string, so
    je .done                    ; jmp to .done

    mov [edx], ax               ; Store char and atributes at current 
                                ; character cell.
    add ebx, 1                  ; EBX points to the next char in string.
    add edx, 2                  ; Move to the next character cell in video mem.

    jmp .loop                   ; Print the next char

    .done:
    popa
    ret