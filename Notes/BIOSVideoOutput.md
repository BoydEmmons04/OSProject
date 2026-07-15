# BIOS Text Output

## Overview

In real mode, one simple way to print text to the screen is to use BIOS interrupt `0x10` in teletype mode.

## Teletype Mode

To print a single character:

- set `AH = 0x0E`
- set `AL` to the ASCII character you want to print
- call BIOS interrupt `0x10`

## Example

```asm
mov ah, 0x0e
mov al, 'A'
int 0x10
```

## ASCII Characters

Characters are stored as ASCII values. This means that letters, digits, and symbols can be printed by placing the appropriate byte in `AL`.

## Printing a Sequence

A loop can be used to print multiple characters, such as the alphabet:

- start with `'A'`
- increment the value until it reaches `'Z'`

## Summary

BIOS text output is one of the easiest ways to display characters during early bootloader development. It does not require a full graphics driver, just a simple interrupt and a character value.