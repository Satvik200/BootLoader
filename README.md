# Bootloader
A bootloader is a special type of software program that is responsible for loading the operating system or other system software from a storage device (like a hard disk, SSD, or USB drive) into the computer's main memory (RAM) when the computer is powered on or reset. It plays a critical role in the startup process of a computer system.

Examples of some bootloaders are GRUB(Grand Unified Bootloader), LILO (Linux Loader), Windows Boot Manager, U-Boot(Universal Bootloader), etc.

We write a floppy disk bootloader because it doesn’t require us to mess about with the file systems which helps keep things simple as possible.


## Software Required
To run this code on any machine, one requires NASM Assembler and QEMU emulator to be installed on their machine.

For Mac OS, use homebrew to install these by using the commands `brew install nasm` and `brew install qemu`.

For Windows Subsystem for Linux or Ubuntu, use command `sudo apt-get install nasm qemu` for installing them.


## Run Locally on Machine

1. Clone the project
```bash
    git clone https://<project-link>
```

2. Go to the directory of the bootloader that you want to run
```bash
    cd <directory_name>
```


For bootloaders that donot call any cpp function, 

1. Create a bin file
```bash
    nasm -f <file_name>.asm -o <file_name>.bin
```
2. Emulate the boot sector using QEMU
```bash
    qemu-system-x86_64 -fda <file_name>.bin
```


For bootloaders that call the the cpp function,
1. Compile and link it all together
```bash
    nasm -f elf32 boot4.asm -o boot4.o

    i386-elf-_g++ x86_64-elf-g++ -m64 kmain.cpp boot4.o -o kernel.bin -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -Werror -T linker.ld
```

2. Emulate the boot sector using QEMU
```bash
    qemu-system-x86_64 -fda kernel.bin
```