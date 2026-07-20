[bits 32]

global keyboard_handler
global keyboard_getchar
global scancode_table

extern pic_send_eoi

scancode_table:
    db 0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8
    db 9, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 13
    db 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 39, '`', 0
    db 92, 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' '
    times (128 - ($ - scancode_table)) db 0

keyboard_buffer:                    ; buffer can hold up to 256 chars at once
    times 256 db 0

buffer_head:                        ; tracks first element added to buffer
    dd 0

buffer_tail:                        ; tracks most recent element added to buffer
    dd 0

keyboard_handler:
    in al, 0x60                     ; get input from port 0x60

    test al, 0x80                   ; check if release
    jnz .done   

    movzx ebx, al                   ; mov al and scale to 32 bits
    mov al, [scancode_table + ebx]  ; convert to ascii

    test al, al                     ; ignore unsupported keys
    jz .done

    mov ecx, [buffer_head]          ; increase buffer pointer by input size
    mov [keyboard_buffer + ecx], al

    inc ecx                         ; increment ecx
    and ecx, 0xFF                   ; ensure it stays inside the buffer
    mov [buffer_head], ecx          ; set ecx to the buffer head

.done:
    call pic_send_eoi               ; send EOI
    ret

keyboard_getchar:
    mov ecx, [buffer_tail]          ; put buffer tail in ecx

    cmp ecx, [buffer_head]          ; if head = tail, buffer is empty
    je .empty

    mov al, [keyboard_buffer + ecx] ; offset the keyboard buffer

    inc ecx                         ; increment ecx
    and ecx, 0xFF                   ; keep in the 256 byte buffer
    mov [buffer_tail], ecx          ; move the tail

    ret

.empty:
    xor al, al                      ; ensure al is empty
    ret