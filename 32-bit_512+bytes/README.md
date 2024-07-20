# 32-bit 512+ Bytes
The BIOS only loads the first 512 bytes of the bootsector. For writing programs larger than 512 bytes we have to load more off the disk. We achieve this by using the `int 0x13` interrupts which provide disk services. 

The disk number is implicitly placed into `dl` by the BIOS on startup. Earlier on we stashed it into memory with `mov [disk], dl`.