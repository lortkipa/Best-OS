
; al - char to print
print_char:
    ; setup mode and call bios interupt
    mov ah, 0xE
    int 0x10
    ret

; si - ptr to string
; dx - char count to print
print_str:
    ; setup mode once
    mov ah, 0xE

    ; setup counter
    xor cx, cx

    ; log current char
    .next_char:
    mov al, [si]
    int 0x10

    ; advance
    inc cx
    inc si

    ; check if str is fully logged and if not, log next char
    cmp cx, dx
    jne .next_char

    ret
