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

```bash nasm -f bin kernel.asm -o kernel.bin```

* Copy files to a bootable image

```bash cmd /c "copy /b boot.bin+kernel.bin os.img" ```

* Boot from the binary in qemu:

```bash qemu-system-i386 -drive format=raw,file=os.img```

* Close the vm on arch

Ctrl + Alt + Q