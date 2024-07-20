# 32-bit 512 Bytes
The CPU is running in 32-bit mode for this, meaning all the 32 bit registers are available. This is done by entering into `Protected Mode`. 

We achieve this by setting-up a Global Descriptor Table which defines a 32-bit code segment, load it with the `lgdt` instruction and then do a long jump to that code segment. Since we are in Protected Mode, we cannot write on the screen from the bootloader directly, hence we write to the VGA text buffer.

This bootloader code still has to stay below 512 bytes limit, otherwise it will hit uninitialised memory.