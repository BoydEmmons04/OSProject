; TODO: initialize the Interrupt Descriptor Table and add a keyboard ISR

; Need 2 bytes for offset low
; 2 bytes for GDT code selector
; 1 bytes for the IST
; 1 byte for the attribute P, DPL, R, TYPE ( 8 bits )
; 2 bytes for offset mid
; 4 bytes for offset high
; 4 bytes 0

; call similar to the gdt by giving the start and the size. 4096 bytes

global idt_init
global idt_load

;extern irq1

idt:
    times 256 dq 0                          ; allocate 8 bytes for each entry
idt_end:

idt_descriptor:
    dw idt_end - idt - 1                    ; size of the idt
    dd idt                                  ; location of the idt in memory

set_idt_gate:

    lea edi, [idt + ebx*8]                  ; this stuff is similar to the gdt

    mov word [edi], ax
    mov word [edi+2], CODE_SEG
    mov byte [edi+4], 0
    mov byte [edi+5], 10001110b

    shr eax, 16
    mov word [edi+6], ax

    ret

idt_init:

    mov eax, irq0               ; system timer
    mov ebx, 32                 ; remap to interrupt 32
    call set_idt_gate
    
    mov eax, irq1               ; keyboard input
    mov ebx, 33                 ; remap to int 33
    call set_idt_gate           ; call the set gate for irq1

    ret

idt_load:

    lidt [idt_descriptor]       ; load idt into register with idt_descriptor

    ret
