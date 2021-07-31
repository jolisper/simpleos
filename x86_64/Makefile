ASM=nasm
SRC=src
OUTDIR=../build/x86_64
BOOT_SECTOR_SRC=boot_sector.asm
CC=gcc
CFLAGS=-ffreestanding -m32 -fno-pie
LDFLAGS=-m elf_i386

.PHONY: all outdir clean

all: outdir os-image 

boot_sector.bin: $(SRC)/$(BOOT_SECTOR_SRC)
	$(ASM) $(SRC)/$(BOOT_SECTOR_SRC) -f bin -o $(OUTDIR)/boot_sector.bin

kernel.bin: $(SRC)/kernel.c kernel_entry.o
	$(CC) $(CFLAGS) -c $(SRC)/kernel.c -o $(OUTDIR)/kernel.o
	ld $(LDFLAGS) -o $(OUTDIR)/kernel.bin -Ttext 0x1000 $(OUTDIR)/kernel_entry.o $(OUTDIR)/kernel.o --oformat binary

kernel_entry.o: $(SRC)/kernel_entry.asm
	$(ASM) $(SRC)/kernel_entry.asm -f elf -o $(OUTDIR)/kernel_entry.o

os-image: boot_sector.bin kernel.bin
	cat $(OUTDIR)/boot_sector.bin $(OUTDIR)/kernel.bin > $(OUTDIR)/os-image

outdir:
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)
