# 16-bit 512 Bytes
The CPU is running in 16-bit mode for this, meaning only the 16 bit registers are available. The BIOS also loads only the first 512 bytes.

This means that the bootloader code has to stay below that limit, otherwise it will hit uninitialised memory.