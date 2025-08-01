
; loaded in real mode
bits 16

; bios loads us in this address
org 0x7c00

; log hello msg
mov si, msg
mov dx, [msgl]
call print_str

; infinite loop
jmp $

%include 'io/print.asm'

msg: db 'Hello To Best-OS'
msgl: dw ($ - msg)

; paddings to fill first 510 bytes
times (510 - ($ - $$)) db 0

; add magic number for bios to find
db 0x55
db 0xAA
