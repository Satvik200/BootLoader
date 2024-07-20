bits 16                                     ; Set code generation to 16-bit mode
org 0x7c00                                  ; Origin, tells the assembler that the code will be loaded at address 0x7c00

boot:
	mov si, msg                             ; Load the address of the message into SI register
	mov ah, 0x0e                            ; Set AH to 0x0E, the BIOS teletype function for printing characters to the screen

.loop:
	lodsb                                   ; Load the next byte from SI into AL and increment SI
	or al, al                               ; OR AL with itself to set the Zero Flag if AL is zero (end of string)
	jz halt                                 ; If Zero Flag is set (end of string), jump to halt
    int 0x10                                ; Call BIOS interrupt 0x10 to print the character in AL
	jmp .loop                               ; Repeat the loop to print the next character

halt:
	cli                                     ; Clear interrupts
	hlt                                     ; Halt the CPU

msg: db "16-bit BootLoader with 512 bytes limit loaded successfully...", 0  ; Define the message to be printed, null-terminated

times 510 - ($-$$) db 0                     ; Fill the rest of the boot sector with zeros
dw 0xaa55                                   ; Boot sector signature (must be 0xAA55 to be recognized as bootable)