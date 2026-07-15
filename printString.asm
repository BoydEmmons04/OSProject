[bits 32]                                   ; 32 bit mode

global print_string                         ; define a global variable

print_string:
    ; expect the string to be in ebx
    mov edx, 0xb8000
    string_loop:
        mov al, [ebx]                       ; dereference the first letter in the string
        cmp al, 0                           ; if null, done
        je done                             ; jump done
        mov ah, 0x0f                        ; color value
        mov [edx], ax                       ; write to video memory
        inc bx                              ; increment the string pointer
        add edx, 2                          ; increment the video memory pointer
        jmp string_loop                     ; loop

    done:                                   ; done label
        ret                                 ; return