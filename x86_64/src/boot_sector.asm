; A simple boot sector program that loops forever
loop:                       ; Define a label, "loop", that will allow 
                            ; us to jump back to it, forever.

    jmp loop                ; Use a simple CPU intruction that jumps
                            ; to a new memory address in continue execution.
                            ; In out case, jump to the address of the current
                            ; instruction.

times 510-($-$$) db 0       ; When compiled, our program must fir into 512 bytes.
                            ; with the last two bytes being the magic number,
                            ; so here, tell our assembly compiler to pad out our
                            ; program with enough zero bytes (db 0) to bring us to
                            ; the 510th byte.

dw 0xaa55                   ; Last two bytes (one word) form the magic number,
                            ; so BIOS knows we are a boot sector.