# OS Project

* The purpose of this project is to learn how operating systems are created and
solidify my knowledge of how computers work.

### Environment
* OS: Windows 10
* Editor: VSCode
* Architecture: x86_64

### Requirements
* QEMU 11.0.50
* NASM 3.02

### Commands
* Compile a bootable binary:

```bash nasm -f bin boot.asm -o boot.bin```

* Boot from the binary in qemu:

```bash qemu-system-x86_64 boot.bin```

* Close the vm on arch

Ctrl + Alt + Q