bits 16
org 0x7c00

boot:
  mov ax, 0x2401 ; BIOS function that enables accesss to memory beyond 1Mb
  int 0x15 ; calls BIOS interrupt and enters protected mode so addresses don't wrap around

  mov ax, 0x3 ; sets VGA text mode to 3
  int 0x10 ; calls display interrupt

  mov [disk], dl

  mov ah, 0x2    ;read sectors
  mov al, 1      ;sectors to read
  mov ch, 0      ;cylinder idx
  mov dh, 0      ;head idx
  mov cl, 2      ;sector idx
  mov dl, [disk] ;disk idx
  mov bx, copy_target;target pointer
  int 0x13
  cli
  lgdt [gdt_pointer] ; loads the gdt structure that tells CPU where GDT is located in memory

  mov eax, cr0      ; cr0 is CPU control register: bit 0-> PE (protection enable)
  or eax, 0x1       ; set eax to 1
  mov cr0, eax      ; set cr0 to eax so CPU is now in protection 16bit mode

  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  jmp CODE_SEG:boot32    ; enters 32bit environment

gdt_start:
  dq 0x0           ; NULL descriptor
gdt_code:          ; code segment
  dw 0xFFFF        ; limit low (full 16 bits)
  dw 0x0           ; base (low 16)
  db 0x0           ; Base (middle 8)
  db 10011010b     ; access byte: present, ring 0, executable, readable
  db 11001111b     ; flags: 32-bit segment, granularity 4KB, upper limit
  db 0x0           ; base (high 8 bits)
gdt_data:
    dw 0xFFFF        ; limit low (full 16 bits)
    dw 0x0           ; base (low 16)
    db 0x0           ; base (middle 8)
    db 10010010b     ; access byte: present, ring 0, data, writable
    db 11001111b     ; flags: 32-bit segment, granularity 4KB, upper limit
    db 0x0           ; base (high 8)
gdt_end:

gdt_pointer:
  dw gdt_end - gdt_start
  dd gdt_start
disk:
  db 0x0
  CODE_SEG equ gdt_code - gdt_start
  DATA_SEG equ gdt_data - gdt_start

times 510 - ($-$$) db 0
dw 0xaa55

copy_target:

bits 32
  msg: db "Never gonna run around and desert you!",0
boot32:
  mov esi, msg
  mov ebx, 0xb8000 ; VGA text buffer address
.loop:
    lodsb               ; load current byte from [esi] and increment esi to go to next byte
    or al,al            ; c`hecks for if we reached the null terminator
    jz halt
    or eax,0x0100       ; sets character color to blue (or'd because ax stores character, upper byte stores color attributes
    mov word [ebx], ax  ; stores ax at [ebx], which writes the character + color into VGA memory.
    add ebx,2           ; move to next position of buffer (each character takes up 2 bytes in VGA buffer to store color attributes too
    jmp .loop
halt:
    cli 
    hlt

times 1024 - ($-$$) db 0
