; Bootloader code is loaded (by BIOS) and running in memory at physical addresses 0x7C00 through 0x7DFF. 
; https://wiki.osdev.org/Memory_Map_(x86)

[org 0x0]
[bits 16]

bpb:
    ; The boot record contains both code and data, mixed together. The data that isn't code is known as the 
    ; BIOS Parameter Block (BPB). Some BIOS assume that BPB is at the beginning of the boot record.
    ; https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29

    jmp short _start     ; The reason for this is jump over the disk format information, the BPB. Since 
                        ; the first sector of the disk is loaded into ram at location 0x0000:0x7c00 and 
                        ; executed, without this jump, the processor would attempt to execute data that 
                        ; isn't code.
    nop                 ; This is required by the BPB.
    times 33 db 0       ; We just fill the rest of the BPB with default values (0x0).

_start:
    ; You can't assume the BIOS jumped to your code setting the correct code segment
    ; CS, since there are many combinations of segment:offset that map to same physical 
    ; address. The far jump to 'start' forces a change in CS to 0x7c0. 

    jmp 0x7c0:start

start:
    ; Take control of segment registers is important because we don't know what the registers are going to be 
    ; when the BIOS load the boot record:
    
    cli                 ; We disable interrupts here because executing an interrupt code may use segment
                        ; registers specially the stack.

    mov ax, 0x7c0       ; Points data and extra segments to the beginning of the boot loader (0x7c00)
    mov ds, ax
    mov es, ax

    mov ax, 0x00        ; Stack grow downwards, so we set stack segment at 0x0000 but stack pointer to 0x7c00
    mov ss, ax
    mov sp, 0x7c0

    sti                 ; Enables interrupts 

    call load_buffer_from_disk

    mov si, buffer
    call print

   jmp $               ; Hangs

load_buffer_from_disk:
    mov ah, 2           ; read sector command
    mov al, 1           ; one sector to read
    mov ch, 0           ; cylinder low eight bits
    mov cl, 2           ; read from sector 2
    mov dh, 0           ; head number 0
                        ; DL with disk number is already set for BIOS
                        ; pointing to the same disk of the boot sector.
    mov bx, buffer      ; ES:BX points to 
    int 0x13
    jc .error          ; print error message if any error
    ret
.error:
    mov si, error_message
    call print
    ret

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'Failed to laod sector', 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

buffer: