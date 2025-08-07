
# general settings
project := bootloader
extension := .efi
entry_point := efi_main

# paths
bin_path := bin
src_path := bootloader

# files
main_file := $(src_path)/boot.asm
ovmf_file := $(bin_path)/OVMF.fd
ovmf_sys_file := /usr/share/ovmf/x64/OVMF.4m.fd
disk_img := $(bin_path)/boot.img

# assembly
assembler := nasm
bootloader_flags := -f win64 -I$(src_path)

# linker
linker := lld-link
linker_flags := /subsystem:efi_application /entry:$(entry_point) /out:$(bin_path)/$(project)$(extension)

# virtual machine
vm := qemu-system-x86_64  
vmflags := -m 512 -bios $(ovmf_file) -drive

# run project using virtual machine
.PHONY: run
run: disk_image
	 $(vm) $(vmflags) format=raw,file=$(disk_img)

# create disk image
.PHONY: disk_image
disk_image: executable
	dd if=/dev/zero of=$(disk_img) bs=1M count=64
	mkfs.fat -F 32 $(disk_img)
	mmd -i $(disk_img) ::/EFI
	mmd -i $(disk_img) ::/EFI/BOOT
	mcopy -i $(disk_img) $(bin_path)/$(project)$(extension) ::/EFI/BOOT/BOOTX64.EFI

# produce executable
.PHONY: executable
executable: object
	$(linker) $(linker_flags) $(bin_path)/$(project).o

# produce object
.PHONY: object
object: ovmf
	$(assembler) $(bootloader_flags) $(main_file) -o $(bin_path)/$(project).o

# get ovmf binaries (it should be installed on machine)
.PHONY: ovmf
ovmf: bin
	cp $(ovmf_sys_file) $(ovmf_file)

# create folder for binaries
.PHONY: bin
bin:
	mkdir -p $(bin_path)

# remove binaries folder
.PHONY: clean
clean:
	rm -rf $(bin_path)
