%ifndef IO_CONSOLE
%define IO_CONSOLE

%include 'efi_types.asm'

; %1 - register to load into
; %2 - protocol name (that is provided in efi_sys_table struct)
%macro efi_sys_table_prot_load 2
    mov %1, [sys_table]
    add %1, efi_sys_table.%2
    mov %1, [rcx]
%endmacro

console_clear:
    ; load protocol
    efi_sys_table_prot_load rcx, console_out_protocol

    ; clear the console buffer
    call [rcx + efi_text_output_protocol.clear_screen]

    ret

; rdx - ptr to msg
console_out:
    ; load protocol
    efi_sys_table_prot_load rcx, console_out_protocol

    ; output string
    call [rcx + efi_text_output_protocol.out_str]

    ret

; rdx - enable or disable (boolean)
console_cursor_set:
    ; load protocol
    efi_sys_table_prot_load rcx, console_out_protocol

    ; set cursor mode
    call [rcx + efi_text_output_protocol.cursor_mode_set]

    ret

%endif ; IO_CONSOLE
