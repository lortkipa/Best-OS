%ifndef EFI_TYPES
%define EFI_TYPES

struc efi_sys_table
    .header resb 24
    .firmware_vendor resq 1
    .firmware_revision resd 1
    resd 1 ; padding for c struct
    .console_in_handle resq 1
    .console_in_protocol resq 1
    .console_out_handle resq 1
    .console_out_protocol resq 1
    .standart_error_handle resq 1
    .standart_error_protocol resq 1
    .runtime_services resq 1
    .boot_services resq 1
    .config_table_count resq 1
    .config_tables resq 1
endstruc

struc efi_table_header
    .signature resq 1
    .revision resd 1
    .sizeb resd 1
    .crc32 resd 1
    .reserved resd 1
endstruc

struc efi_text_output_protocol
    .reset resq 1
    .out_str resq 1
    .test_str resq 1
    .query_mode resq 1
    .set_mode resq 1
    .set_attribute resq 1
    .clear_screen resq 1
    .cursor_pos_set resq 1
    .cursor_mode_set resq 1
    .mode resq 1
endstruc

%endif ; EFI_TYPES
