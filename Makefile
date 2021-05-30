BUILD_DIR=build
X86_64_DIR=x86_64

.PHONY: all run

all:
	make -C $(X86_64_DIR)/

run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/$(X86_64_DIR)/boot_sector.bin,format=raw