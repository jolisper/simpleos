; Bootloader code is loaded (by BIOS) and running in memory at physical addresses 0x7C00 through 0x7DFF. 
; https://wiki.osdev.org/Memory_Map_(x86)

[org 0x7c00]
[bits 16]

CODE_SEGMENT equ gdt_code - gdt_start
DATA_SEGMENT equ gdt_data - gdt_start

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

    jmp 0x000:start

start:
    ; Take control of segment registers is important because we don't know what the registers are going to be 
    ; when the BIOS load the boot record:
    
    cli                 ; We disable interrupts here because executing an interrupt code may use segment
                        ; registers specially the stack.

    mov ax, 0x000       ; Points data and extra segments to the beginning of the boot loader (0x7c00)
    mov ds, ax
    mov es, ax

    mov ax, 0x00        
    mov ss, ax          ; Stack grow downwards, so we set stack segment at 0x0000 but stack pointer to 0x7c00
    mov sp, 0x7c0

    sti                 ; Enables interrupts 

.load_protected:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEGMENT:load32

; GDT
; The Global Descriptor Table tells to the CPU about memory segments. We are using
; just default values because we want to use memory paging, so, is not very important
; the details of this configuration, but is mandatory to jump to 32-bits protected mode.
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0
gdt_code:               ; CS should point here
    dw 0xffff           ; Segment limit first 0-15 bits
    dw 0                ; Base first 0-15 bits
    db 0                ; Base 10-23 bits
    db 0x9a             ; Access byte 
    db 11001111b        ; High 4 bits flags and the low 4 bit flags
    db 0                ; Base 24-31 bits
gdt_data:               ; DS, SS, ES, FS, GS should point here
    dw 0xffff           ; Segment limit first 0-15 bits
    dw 0                ; Base first 0-15 bits
    db 0                ; Base 10-23 bits
    db 0x92             ; Access byte 
    db 11001111b        ; High 4 bits flags and the low 4 bit flags
    db 0                ; Base 24-31 bits
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[bits 32]
load32:
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set the stack
    mov ebp, 0x00200000
    mov esp, ebp

    jmp $               ; Hangs

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55