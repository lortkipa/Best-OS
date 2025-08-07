
# general settings
bt_name := bootloader
bt_ext := .efi
bt_entry := efi_main

# paths
bin_path := bin
src_path := bootloader
root_path := $(bin_path)/root

# files
main_file := $(src_path)/boot.asm
ovmf_file := $(bin_path)/OVMF.fd
ovmf_sys_file := /usr/share/ovmf/x64/OVMF.4m.fd
disk_img := $(bin_path)/boot.img

# assembly
assembler := nasm
btflags := -f win64 -I$(src_path)

# linker
linker := lld-link
linker_flags := /subsystem:efi_application /entry:$(bt_entry) /out:$(bin_path)/$(bt_name)$(bt_ext)

# virtual machine
vm := qemu-system-x86_64  
vmflags := -m 512 -bios $(ovmf_file) -drive

# run bt_name using virtual machine
.PHONY: run
run: file_system
	$(vm) $(vmflags) format=raw,file=fat:rw:$(root_path)

.PHONY: file_system
file_system: executable
	mkdir -p $(root_path)/EFI/BOOT
	cp $(bin_path)/$(bt_name)$(bt_ext) $(root_path)/EFI/BOOT/BOOTX64.EFI

# produce executable
.PHONY: executable
executable: object
	$(linker) $(linker_flags) $(bin_path)/$(bt_name).o

# produce object
.PHONY: object
object: ovmf
	$(assembler) $(btflags) $(main_file) -o $(bin_path)/$(bt_name).o

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
