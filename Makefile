SRC_DIR=src
BUILD_DIR=build
BIN_DIR=bin
X86_64_DIR=x86_64
FILES = $(BUILD_DIR)/kernel.asm.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/idt/idt.asm.o $(BUILD_DIR)/idt/idt.o $(BUILD_DIR)/memory/memory.o $(BUILD_DIR)/io/io.asm.o
INCLUDES=-I./src
FLAGS=-g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -fno-builtin -Wno-unused-function -Werror -Wno-unused-label -Wno-unused-parameter -Wno-cpp -Wall -nostdlib -nostartfiles -nodefaultlibs -O0 -Iinc 

.PHONY: all outdir run clean hex

all: outdir $(BIN_DIR)/boot.bin $(BIN_DIR)/kernel.bin 
	rm -rf $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/boot.bin >> $(BIN_DIR)/os.bin
	dd if=$(BIN_DIR)/kernel.bin >> $(BIN_DIR)/os.bin
	dd if=/dev/zero bs=512 count=100 >> $(BIN_DIR)/os.bin

$(BIN_DIR)/kernel.bin: $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o $(BUILD_DIR)/kernelfull.o
	i686-elf-gcc $(FLAGS) -T $(SRC_DIR)/linker.ld -o $(BIN_DIR)/kernel.bin $(BUILD_DIR)/kernelfull.o

$(BIN_DIR)/boot.bin: $(SRC_DIR)/boot/boot.asm
	nasm -f bin $(SRC_DIR)/boot/boot.asm -o $(BIN_DIR)/boot.bin

$(BUILD_DIR)/kernel.asm.o: $(SRC_DIR)/kernel.asm
	nasm -f elf -g $(SRC_DIR)/kernel.asm -o $(BUILD_DIR)/kernel.asm.o

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c $(SRC_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o

$(BUILD_DIR)/idt/idt.asm.o: $(SRC_DIR)/idt/idt.asm
	nasm -f elf -g $(SRC_DIR)/idt/idt.asm -o $(BUILD_DIR)/idt/idt.asm.o

$(BUILD_DIR)/idt/idt.o: $(SRC_DIR)/idt/idt.c
	i686-elf-gcc $(INCLUDES) -I$(SRC_DIR)/idt $(FLAGS) -std=gnu99 -c $(SRC_DIR)/idt/idt.c -o $(BUILD_DIR)/idt/idt.o

$(BUILD_DIR)/memory/memory.o: $(SRC_DIR)/memory/memory.c
	i686-elf-gcc $(INCLUDES) -I$(SRC_DIR)/memory $(FLAGS) -std=gnu99 -c $(SRC_DIR)/memory/memory.c -o $(BUILD_DIR)/memory/memory.o

$(BUILD_DIR)/io/io.asm.o: $(SRC_DIR)/io/io.asm
	nasm -f elf -g $(SRC_DIR)/io/io.asm -o $(BUILD_DIR)/io/io.asm.o

outdir:
	mkdir -p $(BUILD_DIR) 
	mkdir -p $(BUILD_DIR)/idt 
	mkdir -p $(BUILD_DIR)/memory 
	mkdir -p $(BUILD_DIR)/io
	mkdir -p $(BIN_DIR) 

clean:
	rm -rf $(BUILD_DIR); rm -rf $(BIN_DIR)

hex:
	od -t x1 -A n $(BIN_DIR)/boot.bin

disasm:
	ndisasm $(BIN_DIR)/boot.bin

run:
	qemu-system-x86_64 -drive file=$(BIN_DIR)/os.bin,format=raw
