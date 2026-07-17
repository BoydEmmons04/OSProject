GDT_Start:                                  ; GDT is the Global Descriptor Table
    null_descriptor:
        dd 0                                ; GDT must have 8 empty bytes defined
        dd 0

    code_descriptor:
        dw 0xffff                           ; first define the first 16 bits of the limit
        dw 0                                ; then we need 24 bits of the base
        db 0                                ; dw is 16 bits, db is 8 bits
        db 10011010b                         ; pres, priv, type, and type flags make a byte
        db 11001111b                         ; other flags + the last 4 bits of the limit (f)
        db 0                                ; last 8 bits of the base

    data_descriptor:
        dw 0xffff                           ; first 16 bits of the limit
        dw 0                                ; 16 bits of the base as 0
        db 0                                ; 8 bits of the base as 0
        db 10010010b                         ; pres, priv, type and type flags
        db 11001111b                         ; other flags and the last f (1111)
        db 0                                ; lasat 8 bits of base
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1              ; the size of the GDT
    dd GDT_Start                            ; the starting location of the GDT

CODE_SEG equ code_descriptor - GDT_Start    ; equ is used to set constants for the size of the segments
DATA_SEG equ data_descriptor - GDT_Start