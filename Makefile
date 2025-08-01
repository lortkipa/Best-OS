
# general paths
bin_p := bin

# project settings
project := best-os

# assembly
ac := nasm
aflags := -f bin

# virtual machine
vt := qemu-system-x86_64
vtflags :=

# bootloader
loader_p := bootloader
loader_src := $(loader_p)/boot.asm
aflags += -I$(loader_p)

# scripts
.PHONY: run
run: build
	$(vt) $(vtflags) $(bin_p)/$(project).bin

.PHONY: build
build: bin
	$(ac) $(aflags) $(loader_src) -o $(bin_p)/$(project).bin

.PHONY: bin
bin:
	mkdir -p $(bin_p)
