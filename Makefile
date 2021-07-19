BUILD_DIR=build
X86_64_DIR=x86_64

.PHONY: all run clean hex

all:
	make -C $(X86_64_DIR)/

clean:
	make -C $(X86_64_DIR)/ clean

hex:
	od -t x1 -A n $(BUILD_DIR)/$(X86_64_DIR)/boot_sector.bin

run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/$(X86_64_DIR)/os-image,format=raw