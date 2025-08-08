%ifndef IO_CONSOLE
%define IO_CONSOLE

%include 'efi_types.asm'

%define CONSOLE_FG_COLOR_BLACK                   0x0
%define CONSOLE_FG_COLOR_BLUE                    0x1
%define CONSOLE_FG_COLOR_GREEN                   0x2
%define CONSOLE_FG_COLOR_CYAN                    0x3
%define CONSOLE_FG_COLOR_RED                     0x4
%define CONSOLE_FG_COLOR_MAGENTA                 0x5
%define CONSOLE_FG_COLOR_BROWN                   0x6
%define CONSOLE_FG_COLOR_LIGHTGRAY               0x7
%define CONSOLE_FG_COLOR_BRIGHT                  0x8
%define CONSOLE_FG_COLOR_DARKGRAY                0x8
%define CONSOLE_FG_COLOR_LIGHTBLUE               0x9
%define CONSOLE_FG_COLOR_LIGHTGREEN              0xA
%define CONSOLE_FG_COLOR_LIGHTCYAN               0xB
%define CONSOLE_FG_COLOR_LIGHTRED                0xC
%define CONSOLE_FG_COLOR_LIGHTMAGENTA            0xD
%define CONSOLE_FG_COLOR_YELLOW                  0xE
%define CONSOLE_FG_COLOR_WHITE                   0xF

%define CONSOLE_BG_COLOR_BLACK                   0x0
%define CONSOLE_BG_COLOR_BLUE                    0x1
%define CONSOLE_BG_COLOR_GREEN                   0x2
%define CONSOLE_BG_COLOR_CYAN                    0x3
%define CONSOLE_BG_COLOR_RED                     0x4
%define CONSOLE_BG_COLOR_MAGENTA                 0x5
%define CONSOLE_BG_COLOR_BROWN                   0x6
%define CONSOLE_BG_COLOR_LIGHTGRAY               0x7

; %1 - where to load
; %2 - foreground
; %3 - background
%macro console_color_load 3
    ; store background and shift it
    mov %1, %3
    shl %1, 4

    ; store foreground
    or %1, %2
%endmacro

section .data
    console_fg_color: db 0x0F ; white
    console_bg_color: db 0x00 ; black

section .text
    ; cl - foreground
    ; al - background
    _console_state_set:
        push rdx
        push rcx

        ; store state
        mov [console_fg_color], cl
        mov [console_bg_color], al

        ; load color
        console_color_load dl, cl, al
        movzx rdx, dl

        ; load protocol
        efi_sys_table_prot_load rcx, console_out_protocol

        ; setup new state
        call [rcx + efi_text_output_protocol.set_attribute]

        pop rcx
        pop rdx
        ret

    ; cl - color
    _console_state_fg_set:
        push rax

        ; leave background as is
        mov al, [console_bg_color]

        ; update state
        call _console_state_set

        pop rax
        ret

    ; al - color
    _console_state_bg_set:
        push rcx

        ; leave foreground as is
        mov cl, [console_fg_color]

        ; update state
        call _console_state_set

        pop rcx
        ret

    ; al - color to clear
    console_clear:
        ; update console state
        call _console_state_bg_set

        ; load protocol
        efi_sys_table_prot_load rcx, console_out_protocol

        ; clear the console buffer
        call [rcx + efi_text_output_protocol.clear_screen]

        ret

    ; rdx - ptr to msg
    ; cl - foreground
    ; al - background
    console_out:
        ; update console state
        call _console_state_set

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
