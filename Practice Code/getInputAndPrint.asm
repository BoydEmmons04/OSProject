[org 0x7c00]                                            ; apply correct offset for strings and chars
jmp start                                               ; code has to start executing before the data segment

inputBuffer:                                            ; define a buffer for the user input
    times 20 db 0

prompt:                                                 ; define a string to print
    db "Enter a string to print to the screen: ", 0

start:
    mov ah, 0x0e                                        ; set ttype mode
    mov bx, prompt                                      ; pointer to prompt in bx

printPrompt:                                            ; print string loop
    mov al, [bx]                                        ; dereference the label
    cmp al, 0                                           ; compare al to the null character
    je endPrint                                         ; if null, end loop
    int 0x10                                            ; bios interrupt to print to screen
    inc bx                                              ; increment the string pointer
    jmp printPrompt                                     ; jump to print next char
endPrint:                                               ; end print

mov ah, 0x0e                                            ; set ttype mode
mov bx, inputBuffer                                     ; put pointer to buffer in bx
inputLoop:                                              ; start input loop
    mov ah, 0x00                                        ; read key bios        
    int 0x16                                            ; bios interrupt
    cmp al, 0x0D                                        ; check if al is Enter key
    je endInput                                         ; jump if Enter was pressed
    mov [bx], al                                        ; put the char into bx
    inc bx                                              ; increment the buffer pointer
    jmp inputLoop                                       ; loop
endInput:
    inc bx                                              ; increment bx from where it ended
    mov [bx], 0                                         ; add null terminate at the end

mov ah, 0x0e                                            ; set ttype mode
mov bx, inputBuffer                                     ; put pointer to buffer in bx
printString:
    mov al, [bx]                                        ; put the letter read into al
    cmp al, 0                                           ; compare to null character
    je end                                              ; if null jump to end
    int 0x10                                            ; call bios print interrupt
    inc bx                                              ; increment to next char
    jmp printString                                     ; jump to loop start
end:

jmp $                           ; pause here until os closes

times 510-($-$$) db 0           ; creates the boot sector to the right size
dw 0xaa55                       ; adds the necessary characters to the boot sector
