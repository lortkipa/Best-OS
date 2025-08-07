%ifndef BOOT
%define BOOT

; uefi loads in long mode
bits 64

%include 'efi_types.asm'
%include 'io/console.asm'

section .data
    msg: dw 'H','e','l','l','o',' ','T','o',' ','B','e','s','t','O','S',0

; rcx - EFI_IMG_HANDLE  
; rdx - EFI_SYS_TABLE
section .text
global efi_main
efi_main:
    ; store efi data
    mov [sys_table], rdx

    ; clear screen
    call console_clear

    ; set cursor
    mov rdx, 0
    call console_cursor_set

    ; log welcome msg
    mov rdx, msg
    call console_out

    ; infinite loop
    jmp $
    ret

section .bss
    sys_table: resq 1

%endif ; BOOT
