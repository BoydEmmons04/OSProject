[bits 16]                                   ; define that it is 16 bit mode
[org 0x7c00]                                ; 0x7c00 is the location that the bios loads the boot sector

jmp start                                   ; jump over the GDT data so the BIOS lands on real code

%include "gdt.asm"
global scancode_table                       ; scan code lookup table

print_str:
    db "A test for how many characters I can print", 0

char_buffer:
    db 0, 0                                 ; buffer for character + null terminator

start:
    cli                                     ; disable all interrupts

    lgdt [GDT_Descriptor]                   ; load the GDT
    mov eax, cr0                            ; move the special register we need to eax
    or eax, 1                               ; change the last bit to 1
    mov cr0, eax                            ; move it back to the special register

    ; we are now in 32 bit protected mode and need to far jump to another segment

    jmp CODE_SEG:start_protected_mode       ; far jump to CODE_SEG

[bits 32]                                   ; define 32 bit mode
%include "stdio.asm"

start_protected_mode:                       ; protected mode code
    ; set up the stack for protected mode
    mov ax, DATA_SEG                        ; load the data segment
    mov ds, ax                              ; data segment register
    mov es, ax                              ; extra segment register
    mov fs, ax                              ; gp segment register
    mov gs, ax                              ; gp segment register
    mov ss, ax                              ; stack segment register
    mov esp, 0x90000                        ; sets the stack to a high value that wont collide with video memory

    call clear                              ; clear the screen once

    push print_str                          ; push the variable we want
    call print                              ; call the print function
    add esp, 4                              ; clean up the stack (one 4-byte parameter)

    call read_char                          ; puts ascii in al
    mov [char_buffer], al                   ; store character in buffer
    push char_buffer                        ; push pointer to buffer
    call print                              ; call the print function
    add esp, 4                              ; clean up the stack

jmp $                                       ; stay here after writing to video memory

times 510-($-$$) db 0                       ; creates the boot sector to the right size
dw 0xaa55                                   ; adds the necessary characters to the boot sector
