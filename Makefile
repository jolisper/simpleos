BUILD_DIR=build
X86_64_DIR=x86_64

.PHONY: all outdir run clean hex

all: outdir boot.bin

boot.bin: boot.asm
	nasm -f bin ./boot.asm -o $(BUILD_DIR)/boot.bin

outdir:
	mkdir -p build

clean:
	rm -rf $(BUILD_DIR)

hex:
	od -t x1 -A n $(BUILD_DIR)/boot.bin

disasm:
	ndisasm $(BUILD_DIR)/boot.bin

run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/boot.bin,format=raw
