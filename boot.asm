; The boot sector is how the computer knows where to boot
; it looks for a 512 byte long piece of memory ending in 55 aa

; times repeats an action a set number of times
; db means define byte, it allocates memory 

; $ is the current memory address
; $$ is the start of the memory block
; $-$$ is the length of previous code since it has to be 512 bytes
; 510 - the previous code accounts for the offset of all previous code lines
; so the total code is 510.

; 510 plus the 0x55 and the 0xaa makes 512 bytes

; jump to current memory address
jmp $

times 510-($-$$) db 0
db 0x55, 0xaa