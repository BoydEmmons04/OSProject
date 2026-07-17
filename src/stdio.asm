[bits 32]                                   ; 32 bit mode

global print                                ; prints the string pushed to the stack
global clear                                ; clears the screen
global read_char                            ; reads character and returns in al
global scancode_table                       ; scan code lookup table

scancode_table:                         ; scan code lookup table
    db 0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8
    db 9, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 13
    db 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ' ', ' ', '`', 0
    db 0, 92, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0
    db 0, ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

read_char:
    push ebp                            ; save ebp
    mov ebp, esp                        ; put stack ptr into base ptr
    push ebx                            ; callee saved registers

.flush:
    in al, 0x64                         ; read status from standard keyboard input (0x64)
    test al, 1                          ; checks if the output buffer is full
    jz .wait                            ; jump to wait if empty
    in al, 0x60                         ; read data from standard keyboard input (0x60)
    jmp .flush                          ; try again

.wait:
    in al, 0x64                         ; read the status from the keyboard input
    test al, 1                          ; check if the buffer is empty
    jz .wait                            ; if empty, wait

    in al, 0x60                         ; read the data from the keyboard input
    test al, 0x80                       ; check if release or press
    jnz .wait                           ; if release, wait

    movzx ebx, al                       ; moves the input data to ebx and fills upper bits with 0
    mov al, [scancode_table + ebx]      ; table lookup for the corresponding ascii value and place in al
    test al, al                         ; bitwise and to check if al is 0
    jz .wait                            ; if al is 0, wait
    pop ebx                             ; restore ebx
    pop ebp                             ; restore ebp

    ret                                 ; return

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

