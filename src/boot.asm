[bits 16]                                   ; define that it is 16 bit mode
[org 0x7c00]                                ; 0x7c00 is the location that the bios loads the boot sector

jmp start                                   ; jump over the GDT data so the BIOS lands on real code

%include "gdt.asm"

start:
    cli                                     ; disable all interrupts

    xor ax, ax                              ; zero ax
    mov es, ax                              ; set extra segment to 0
    mov bx, 0x1000                          ; load start address of kernel

    mov ah, 0x02                            ; BIOS read sectors
    mov al, 6                               ; number of sectors (size of kernel)
    mov ch, 0                               ; cylinder number
    mov cl, 2                               ; sector number (1 is bootloader)
    mov dh, 0                               ; head number

    int 0x13                                ; calls a bios interrupt to load the kernel into memory

    lgdt [GDT_Descriptor]                   ; load the GDT
    mov eax, cr0                            ; move the special register we need to eax
    or eax, 1                               ; change the last bit to 1
    mov cr0, eax                            ; move it back to the special register

    ; we are now in 32 bit protected mode and need to far jump to another segment

    jmp CODE_SEG:start_protected_mode       ; far jump to CODE_SEG

[bits 32]                                   ; define 32 bit mode

start_protected_mode:                       ; protected mode code
    ; set up the stack for protected mode
    mov ax, DATA_SEG                        ; load the data segment
    mov ds, ax                              ; data segment register
    mov es, ax                              ; extra segment register
    mov fs, ax                              ; gp segment register
    mov gs, ax                              ; gp segment register
    mov ss, ax                              ; stack segment register
    mov esp, 0x90000                        ; sets the stack to a high value that wont collide with video memory

    jmp CODE_SEG:0x1000                     ; far jump tot he code seg

jmp $                                       ; stay here after writing to video memory

times 510-($-$$) db 0                       ; creates the boot sector to the right size
dw 0xaa55                                   ; adds the necessary characters to the boot sector
