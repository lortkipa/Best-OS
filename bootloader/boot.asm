
; uefi loads in long mode
bits 64

; rcx - EFI_IMG_HANDLE  
; rdx - EFI_SYS_TABLE
section .text
global efi_main
efi_main:
    ; infinite loop
    jmp $
