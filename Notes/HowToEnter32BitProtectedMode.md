# Entering 32-bit Protected Mode

## Overview

The bootloader starts in real mode, which is limited to 16-bit instructions and BIOS services. To do more advanced work, such as using more than 512 bytes of code or accessing a larger memory range, the CPU must switch to protected mode.

## Why Protected Mode?

Protected mode allows:

- access to a much larger memory space
- 32-bit execution
- better memory management features such as paging and multitasking
- the ability to write more complex OS code in languages like C or C++

## How the Switch Works

1. Define the Global Descriptor Table (GDT).
2. Load the GDT using the `lgdt` instruction.
3. Set the lowest bit of `CR0` to `1`.
4. Perform a far jump to a 32-bit code segment.

## Key Concept: The GDT

The Global Descriptor Table is a data structure that describes memory segments used by the CPU in protected mode.

Each segment descriptor must define:

- the base address
- the segment limit
- access flags
- privilege level
- whether it is code or data

## Important Segment Descriptors

### Code Segment

A code descriptor must specify:

- the segment limit
- the base address
- the code-readability bit
- the accessed bit
- the 32-bit flag
- the granularity flag

### Data Segment

A data descriptor is similar, but it is used for data access. In this case, the flags indicate whether the segment is writable and whether it grows downward.

## Writing to the Screen in Protected Mode

Once the CPU is in protected mode, BIOS interrupts are no longer the normal way to interact with hardware. To display text, the OS writes directly to video memory at address `0xB8000`.

- the first byte is the character
- the second byte is the color attribute

## Summary

Switching to protected mode is a fundamental step in bootloader development because it unlocks the features needed for a real operating system.
