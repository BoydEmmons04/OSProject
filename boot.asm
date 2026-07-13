[org 0x7c00]                    ; required for memory offset

mov ah, 0x0e                    ; teletype mode
mov bx, printString             ; put the label pointer in bx

printLoop:
    mov al, [bx]                ; dereference pointer and put it in al
    cmp al, 0                   ; check if we reached the end of the string
    je end                      ; if null, jump to the end
    int 0x10                    ; bios interupt
    inc bx                      ; increment the pointer
    jmp printLoop               ; loop
end:

jmp $                           ; continuous loop the os

printString:                    ; defines a variable in memory with label
    db "Hello World!", 0        ; allocates sequential memory with null terminate


times 510-($-$$) db 0           ; creates the boot sector to the right size
dw 0xaa55                       ; adds the necessary characters to the boot sector
