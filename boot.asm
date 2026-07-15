[bits 16]                                   ; define that it is 16 bit mode
[org 0x7c00]                                ; 0x7c00 is the location that the bios loads the boot sector

jmp start                                   ; jump over the GDT data so the BIOS lands on real code

%include "gdt.asm"

print_str:
    db "Hello World", 0

start:
    cli                                     ; disable all interrupts

    lgdt [GDT_Descriptor]                   ; load the GDT
    mov eax, cr0                            ; move the special register we need to eax
    or eax, 1                               ; change the last bit to 1
    mov cr0, eax                            ; move it back to the special register

    ; we are now in 32 bit protected mode and need to far jump to another segment

    jmp CODE_SEG:start_protected_mode       ; far jump to CODE_SEG

[bits 32]                                   ; define 32 bit mode
%include "clearScreen.asm"
%include "printString.asm"

start_protected_mode:                       ; protected mode code
    ; set up the stack for protected mode
    mov ax, DATA_SEG                        ; load the data segment
    mov ds, ax                              ; data segment register
    mov es, ax                              ; extra segment register
    mov fs, ax                              ; gp segment register
    mov gs, ax                              ; gp segment register
    mov ss, ax                              ; stack segment register
    mov esp, 0x90000                        ; sets the stack to a high value that wont collide with video memory

    call clear_screen                       ; clear the screen once

    mov al, 'A'                             ; letter to print
    mov ah, 0x04                            ; color to print
    mov word [0xb8000], ax                  ; write to video memory
    mov al, 'B'
    mov ah, 0x04
    mov word [0xb8002], ax
    mov al, 'C'
    mov ah, 0x04
    mov word [0xb8004], ax

    mov ebx, print_str
    call print_string

jmp $                                       ; stay here after writing to video memory

times 510-($-$$) db 0                       ; creates the boot sector to the right size
dw 0xaa55                                   ; adds the necessary characters to the boot sector
