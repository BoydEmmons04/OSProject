What is the IDT

The IDT is an Interrupt Descriptor Table which acts as a lookup table that
maps interrupt or exception vectors (0-255) to specific handler routines (ISR) 

The IDT stores up to 256 descriptors which are 8 bytes long in 32 bit protected mode
Each descriptor contains the segment selector which points to a code segment in the GDT
or LDT and the offset of the handler along with the attributes like the gate type
and privilege level.

When an event is detected, the processor uses the IDT as a lookup table to determine
what to do next. It locates the corresponding descriptor and transfers control to the
specific handler.

How does the processor know where the IDT is in memory. 
- x86 provides a special register for the base address of the IDT called IDTR
- IDTR is loaded using the LIDT (Load IDT) instruction

Only vectors 32-255 are available for hardware interrupts (from the hardware like keyboard)
And software interrupts via the INT instruction.