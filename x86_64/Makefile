ASM=nasm
SRC=src
OUTDIR=../build/x86_64
BOOT_SECTOR_SRC=boot_sector.asm

.PHONY: all outdir clean

all: outdir os-image 

boot_sector.bin: $(SRC)/$(BOOT_SECTOR_SRC)
	$(ASM) $(SRC)/$(BOOT_SECTOR_SRC) -f bin -o $(OUTDIR)/boot_sector.bin

kernel.bin: 
	gcc -ffreestanding -c $(SRC)/kernel.c -o $(OUTDIR)/kernel.o
	ld -o $(OUTDIR)/kernel.bin -Ttext 0x1000 $(OUTDIR)/kernel.o --oformat binary

os-image: boot_sector.bin kernel.bin
	cat $(OUTDIR)/boot_sector.bin $(OUTDIR)/kernel.bin > $(OUTDIR)/os-image

outdir:
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)
