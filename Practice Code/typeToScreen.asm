; output puts ASCII character is al and scan code in ah
; this program is an example of taking user input character in asm

char:
    db 0                        ; allocate a byte for the character

loop:
    mov ah, 0                       ; to accept user input you have to do interrup 0x16 with 0 in ah
    int 0x16                        ; sends the 0x16 interrupt

    mov [char], al                  ; put the read character into char for storage

    mov al, [char]                  ; now put char into al for print
    mov ah, 0x0e                    ; teletype mode
    int 0x10                        ; call print interrupt

    cmp al, '0'                     ; compare to 0
    jne loop                        ; if not 0 repeat

end:
    jmp $                           ; pause here until os closes

    times 510-($-$$) db 0           ; creates the boot sector to the right size
    dw 0xaa55                       ; adds the necessary characters to the boot sector
