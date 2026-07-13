mov ah, 0x0e            ; code needed for teletype mode
mov al, 'A'             ; letter we want to type
int 0x10                ; bios interupt code

loop:                   ; begin loop label
    inc al              ; increment al register
    int 0x10            ; call the bios interupt
    cmp al, 90          ; compare al to 90 (Z) and set status register
    jne loop            ; branch to loop unless we hit Z

jmp $                   ; repeat nothing forever

times 510-($-$$) db 0   ; define the boot sector
db 0x55, 0xaa