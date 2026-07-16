[bits 32]                                   ; 32 bit mode

global print                                ; prints the string in ebx
global clear                                ; clears the screen

print:
    push ebp                                ; push the base pointer to return to                    
    mov ebp, esp                            ; set the base pointer to the previous stack ptr
    push ebx                                ; save ebx from being clobbered
    mov ebx, [ebp+8]                        ; access the value pushed to the stack

    mov edx, 0xb8000
    string_loop:
        mov al, [ebx]                       ; dereference the first letter in the string
        cmp al, 0                           ; if null, done
        je done                             ; jump done
        mov ah, 0x0f                        ; color value
        mov [edx], ax                       ; write to video memory
        inc ebx                             ; increment the string pointer
        add edx, 2                          ; increment the video memory pointer
        jmp string_loop                     ; loop

    done:                                   ; done label
        pop ebx                             ; restore ebx
        mov esp, ebp                        ; return the base ptr to the stack ptr
        pop ebp                             ; pop the old base ptr
        ret                                 ; return

clear:
    mov ecx, 2000                           ; number of times to loop
    mov edx, 0xb8000                        ; location of video memory

    loop_print:
        mov ax, 0x0720                      ; grey color and space character
        mov word [edx], ax                  ; write to video memory
        add edx, 2                          ; increment to next cell in video memory
        sub ecx, 1                          ; subtract 1 from the counter
        cmp ecx, 0                          ; check if counter is 0
        jne loop_print                      ; if not 0 loop
        ret                                 ; return if counter is 0

