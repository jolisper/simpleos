ASM=nasm
SRC=src
OUTDIR=../build/x86_64
BOOT_SECTOR_SRC=boot_sector-print_string.asm

.PHONY: all outdir clean

all: outdir boot_sector.bin

boot_sector.bin: $(SRC)/$(BOOT_SECTOR_SRC)
	$(ASM) $(SRC)/$(BOOT_SECTOR_SRC) -f bin -o $(OUTDIR)/boot_sector.bin

outdir:
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)
