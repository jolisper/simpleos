SRC_DIR=src
BUILD_DIR=build
BIN_DIR=bin
X86_64_DIR=x86_64

.PHONY: all outdir run clean hex

all: outdir boot.bin

boot.bin: src/boot/boot.asm
	nasm -f bin $(SRC_DIR)/boot/boot.asm -o $(BIN_DIR)/boot.bin

outdir:
	mkdir -p $(BUILD_DIR) 
	mkdir -p $(BIN_DIR) 

clean:
	rm -rf $(BUILD_DIR); rm -rf $(BIN_DIR)

hex:
	od -t x1 -A n $(BIN_DIR)/boot.bin

disasm:
	ndisasm $(BIN_DIR)/boot.bin

run:
	qemu-system-x86_64 -drive file=$(BIN_DIR)/boot.bin,format=raw
