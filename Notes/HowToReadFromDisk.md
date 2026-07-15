# Reading from Disk with BIOS

## Overview

Hard drives are organized into cylinders, heads, and sectors. Each sector is 512 bytes long, and BIOS interrupt `0x13` is commonly used to read sectors from disk during boot.

## CHS Addressing

CHS stands for Cylinder, Head, and Sector.

- **Cylinder**: selects the concentric track
- **Head**: selects the disk surface
- **Sector**: selects the specific 512-byte block

## Typical Bootloader Reading Steps

When the system boots, the first sector (the boot sector) is already loaded into memory. To read the next sector, the bootloader uses CHS values to locate the correct data.

### Common Values

- the first boot sector is sector `1`
- the next sector to read is usually sector `2`
- cylinders and heads start at `0`
- sectors start at `1`

## BIOS Interrupt `0x13`

To read from disk, the bootloader uses BIOS interrupt `0x13` with the following register setup:

- `ah = 0x02` for disk read
- `al = number of sectors to read`
- `ch = cylinder number`
- `cl = starting sector`
- `dh = head number`
- `dl = drive number`

The destination buffer is passed in the form `es:bx`:

- `es = 0`
- `bx = 0x7e00`

## Notes

- the boot disk is the same disk that was used to boot the system
- the drive number is originally stored in `DL` when the BIOS jumps to the boot sector
- `0x7e00` is a common destination because it is immediately after the boot sector in memory

## Summary

Reading from disk in a bootloader is a fundamental task. BIOS interrupt `0x13` provides a simple way to load additional sectors into memory so the kernel or second-stage bootloader can continue execution.