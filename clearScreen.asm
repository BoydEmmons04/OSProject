[bits 32]                                   ; 32 bit mode

global clear_screen                         ; define a global variable

clear_screen:
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