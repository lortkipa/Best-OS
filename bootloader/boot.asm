
; loaded in real mode
bits 16

; bios loads us in this address
org 0x7c00

; infinite loop
jmp $

; paddings to fill first 510 bytes
times (510 - ($ - $$)) db 0

; add magic number for bios to find
db 0x55
db 0xAA
