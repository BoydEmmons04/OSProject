global irq1
global irq0

;extern keyboard_handler

irq0:
    pusha                               ; save all gp registers

    call pic_send_eoi                   ; end interrupt

    popa                                ; restore all gp reg
    iret

irq1:

    pusha                               ; save registers

    push ds                             ; push data segment register
    push es                             ; push extra segment reg
    push fs                             ; push misc segment reg
    push gs                             ; same thing

    call keyboard_handler               ; call the keyboard_handler on interrupt signal

    pop gs                              ; reverse the push
    pop fs
    pop es
    pop ds                              
    popa                                ; pop all gp reg

    iret                                ; interrupt return

