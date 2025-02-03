# Simple x86 kernel
A simple x86 floppy disk bootloader written in NASM x86 assembly and emulated using QEMU.

# Running the kernel
- Prerequisites: NASM and QEMU in a linux environment.
- Run ```make boot``` which creates the bootloader binary  to print a message in real 16bit mode and tells QEMU to boot off of a floppy disk using this binary.
- Run ```make boot32``` which prints the message in 32 bit protected mode using directly mapped VGA memory
- Run ```make bootbeyond``` which prints the message in 32 bit protected mode from beyond the first 512 bytes of the disk. 

Currently working on ```bootcpp.asm``` to call a C++ function from the bootloader using a cross compiler and custom linker ```linker.ld```.
