; Program interrupt controller is the hardware that gets interrupts from devices and
; forwards them to the CPU

; We have to override the PIC because the bios initializes:
; Timer - 8
; Keyboard - 9
; COM2 - 10
; COM1 - 11
; This does not work because 0-31 are reserved by Intel for CPU exceptions

; EOI is the End of Interrupt command

global pic_remap
global pic_send_eoi

pic_remap:

    ; save current masks
    in al, 0x21                 ; take input from port 0x21
    push eax                    ; save to the stack

    in al, 0xa1                 ; another port
    push eax                    ; save again on the stack

    mov al, 0x11                ; start initialization
    out 0x21, al                
    out 0xa0, al

    ; new interrupt offsets
    mov al, 0x20                ; Master interrupt 32
    out 0x21, al

    mov al, 0x28                ; Slave interrupt 40
    out 0xa1, al

    mov al, 0x04                ; Tell master there is a slave at IRQ2
    out 0x21, al            

    mov al, 0x02                ; Tell slave
    out 0xa1, al

    mov al, 0x01                ; 8086/88 mode
    out 0x21, al
    out 0xa1, al

    pop eax                     ; restore masks
    out 0xa1, al

    pop eax
    out 0x21, al

    ret

pic_send_eoi:
    mov al, 0x20
    out 0x20, al
    ret