bits 16 ; cpu is running in 16 bit mode
org 0x7c00

boot:
  mov si, msg ; si register points to msg (string)
  mov ah, 0x0e ; write character in teletype mode
.loop:
  lodsb
  or al, al ; checks if al is a null byte
  jz halt   ; if yes then jump to end
  int 0x10  ; run interrupt which prints the character in al
  jmp .loop
halt:
  cli   ; clear interrupt flag
  hlt   ; halts execution

msg: db "never gonna give you up, never gonna let you down.",0

times 510 - ($-$$) db 0 ; pad remaining bytes with zeroes till size becomes 510
dw 0xaa55 ; bootloader signature


