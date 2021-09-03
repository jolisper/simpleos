section .asm

global insb
global insw
global outb
global outw

; https://stackoverflow.com/questions/3215878/what-are-in-out-instructions-in-x86-used-for

insb:
    push ebp
    mov ebp, esp 

    xor eax, eax            ; Just to blank EAX 
    mov edx, [ebp+8]        ; Get the port number into EDX
    in al, dx               ; EAX is where C expects the return value, so it's ok

    pop ebp
    ret

insw:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov edx, [ebp+8]
    in ax, dx

    pop ebp
    ret

outb:
    push ebp
    mov ebp, esp

    mov eax, [ebp+12] 
    mov edx, [ebp+8]
    out dx, al

    pop ebp
    ret

outw:
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]
    mov edx, [ebp+8]
    out dx, ax

    pop ebp
    ret
