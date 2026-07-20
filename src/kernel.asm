[bits 32]
[org 0x1000]

global start_kernel

start_kernel:

    call clear                              ; clear the screen once

    call pic_remap                          ; remaps the Programmable Interrupt controller
    call idt_init                           ; initializes the IDT for interrupts
    call idt_load                           ; loads the keyboard driver currently

    sti                                     ; enable hardware interrupts

main_loop:

    call keyboard_getchar                   ; each tick, get char from the buffer

    test al, al                             ; if nothing returns or 0
    jz main_loop                            ; looop

    mov [char_buffer], al                   ; else put the letter in the char buffer

    push char_buffer                        ; push char buffer to the stack
    call print                              ; call print function that prints the char buffer
    add esp, 4                              ; increment the stack pointer

    jmp main_loop                           ; loop
    

print_str:
    db "A test for how many characters I can print", 0

char_buffer:
    db 0, 0                                 ; buffer for character + null terminator

; include for flat bindary instead of ELF file
%include "gdt.asm"                          
%include "stdio.asm"
%include "pic.asm"
%include "idt.asm"
%include "isr.asm"
%include "keyboard.asm"