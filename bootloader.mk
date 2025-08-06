# general settings
project := bootloader
extension := .efi
entry_point := efi_main
# paths
bin_path := bin
src_path := bootloader
ovmf_path := $(bin_path)/OVMF.fd
ovmf_sys_path := /usr/share/ovmf/x64/OVMF.4m.fd
disk_img := $(bin_path)/boot.img
# files
main_file := $(src_path)/boot.asm
# assembly
assembler := nasm
assembly_flags := -f win64
# linker
linker := lld-link
linker_flags := /subsystem:efi_application /entry:$(entry_point) /out:$(bin_path)/$(project)$(extension)

.PHONY: run
run: disk_image
	qemu-system-x86_64 -m 512 -bios $(ovmf_path) -drive format=raw,file=$(disk_img)

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
	$(assembler) $(assembly_flags) $(main_file) -o $(bin_path)/$(project).o

# get ovmf binaries (it should be installed on machine)
.PHONY: ovmf
ovmf: bin
	cp $(ovmf_sys_path) $(ovmf_path)

# create folder for binaries
.PHONY: bin
bin:
	mkdir -p $(bin_path)

# remove binaries folder
.PHONY: clean
clean:
	rm -rf $(bin_path)
