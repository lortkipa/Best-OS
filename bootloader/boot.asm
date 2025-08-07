%ifndef BOOT
%define BOOT

; uefi loads in long mode
bits 64

%include 'efi_types.asm'

section .data
    msg: dw 'H','e','l','l','o',' ','T','o',' ','B','e','s','t','-','O','S',0

; rcx - EFI_IMG_HANDLE  
; rdx - EFI_SYS_TABLE
section .text
global efi_main
efi_main:
    ; store efi data
    mov [sys_table], rdx

    ; log msg
    mov rax, [sys_table]
    add rax, efi_sys_table.console_out_protocol
    mov rax, [rax]
    mov rcx, rax
    mov rdx, msg
    call [rax + efi_text_output_protocol.out_str]

    ; infinite loop
    jmp $
    ret

section .bss
    sys_table: resq 1

%endif ; BOOT
