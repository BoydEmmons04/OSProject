# User Input and Strings

## Overview

This section focuses on two related tasks in early operating system development:

- printing strings to the screen
- reading user input from the keyboard

## Printing Strings

A string is a sequence of characters stored in memory. In assembly, it can be printed one character at a time by repeatedly sending each character to the screen using BIOS output routines.

## Reading Input

Keyboard input can be read in real mode using BIOS services. The bootloader or early OS can wait for a keypress and then process the resulting character.

## Notes

- strings are often stored as a sequence of bytes
- each byte is usually one ASCII character
- input handling is more involved than simple output because the program must wait for and interpret keypresses

## Summary

Learning how to print strings and read keyboard input is an important step toward building more interactive bootloaders and simple operating-system programs.