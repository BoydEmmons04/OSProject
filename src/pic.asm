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

    ; Start initialization
    mov al, 0x11
    out 0x20, al
    out 0xA0, al

    ; Master PIC vector offset = 32
    mov al, 0x20
    out 0x21, al

    ; Slave PIC vector offset = 40
    mov al, 0x28
    out 0xA1, al

    ; Tell master there is a slave on IRQ2
    mov al, 0x04
    out 0x21, al

    ; Tell slave its cascade identity
    mov al, 0x02
    out 0xA1, al

    ; 8086 mode
    mov al, 0x01
    out 0x21, al
    out 0xA1, al

    ; Unmask only IRQ0 and IRQ1
    mov al, 11111100b
    out 0x21, al

    ; Mask all slave IRQs
    mov al, 11111111b
    out 0xA1, al

    ret

pic_send_eoi:
    mov al, 0x20                    ; end of interrupt code
    out 0x20, al                    ; send it out
    ret