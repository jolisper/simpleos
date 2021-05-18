ASM=nasm
SRC=src
OUTDIR=build

.PHONY: all outdir clean

all: outdir boot_sector.bin

boot_sector.bin: $(SRC)/boot_sector.asm
	$(ASM) $(SRC)/boot_sector.asm -f bin -o $(OUTDIR)/boot_sector.bin

outdir:
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)
