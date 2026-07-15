# Boot Sector Basics

## What a Boot Sector Is

A boot sector is the first 512-byte block of a bootable disk. The BIOS looks for a sector that ends with the signature `0x55AA` so it knows it is a valid bootable sector.

## Why It Must Be 512 Bytes

A boot sector is fixed at 512 bytes because that is the standard size of a disk sector.

## Key NASM Concepts

### `times`

`times` repeats a directive a specified number of times.

### `db`

`db` defines a byte in memory.

### `$` and `$$`

- `$` refers to the current location counter
- `$$` refers to the start of the current section or program
- `$ - $$` gives the size of the code generated so far

## Boot Sector Size Calculation

To make the boot sector exactly 512 bytes:

- the code area must fill the first 510 bytes
- the final two bytes are reserved for the boot signature

This is why the file often ends with:

```asm
times 510-($-$$) db 0
dw 0xAA55
```

## Build and Run Commands

```bash
nasm -f bin boot.asm -o boot.bin
qemu-system-x86_64 boot.bin
```

## Summary

The boot sector is the entry point for OS startup. It must be small, correctly formatted, and end with the boot signature so the BIOS can execute it.
 