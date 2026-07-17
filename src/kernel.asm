[bits 32]
[org 0x1000]

global start_kernel

start_kernel:

    call clear                              ; clear the screen once

    push print_str                          ; push the variable we want
    call print                              ; call the print function
    add esp, 4                              ; clean up the stack (one 4-byte parameter)

    call read_char                          ; puts ascii in al
    mov [char_buffer], al                   ; store character in buffer
    push char_buffer                        ; push pointer to buffer
    call print                              ; call the print function
    add esp, 4                              ; clean up the stack

    jmp $

print_str:
    db "A test for how many characters I can print", 0

char_buffer:
    db 0, 0                                 ; buffer for character + null terminator

%include "stdio.asm"