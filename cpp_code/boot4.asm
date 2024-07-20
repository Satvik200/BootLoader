section .boot                       ; Boot section
bits 16                             ; Set code generation to 16-bit mode
global boot                         ; Make the boot label globally accessible
boot:
	mov ax, 0x2401                  ; Set video mode 80x25 color text mode
	int 0x15                        ; BIOS interrupt call to set video mode

	mov ax, 0x3                     ; Set video mode to 80x25 text mode (mode 3)
	int 0x10                        ; BIOS interrupt call to set video mode

	mov [disk], dl                  ; Save the disk identifier in the 'disk' variable

	mov ah, 0x2                     ; BIOS read sectors function
	mov al, 6                       ; Number of sectors to read
	mov ch, 0                       ; Cylinder index
	mov dh, 0                       ; Head index
	mov cl, 2                       ; Sector index
	mov dl, [disk]                  ; Load disk index from 'disk' variable
	mov bx, copy_target             ; Load target address into BX
	int 0x13                        ; BIOS interrupt call to read sectors

	cli                             ; Clear interrupts
	lgdt [gdt_pointer]              ; Load the GDT (Global Descriptor Table)
	mov eax, cr0                    ; Move the contents of control register CR0 to EAX
	or eax, 0x1                     ; Set the PE (Protection Enable) bit in CR0 to enable protected mode
	mov cr0, eax                    ; Move the modified value back to CR0
	mov ax, DATA_SEG                ; Load data segment selector into AX
	mov ds, ax                      ; Set DS (Data Segment)
	mov es, ax                      ; Set ES (Extra Segment)
	mov fs, ax                      ; Set FS (F Segment)
	mov gs, ax                      ; Set GS (G Segment)
	mov ss, ax                      ; Set SS (Stack Segment)
	jmp CODE_SEG:boot2              ; Far jump to switch to the new code segment

gdt_start:
	dq 0x0                          ; Null descriptor

gdt_code:                           ; Code segment descriptor
	dw 0xFFFF                       ; Limit low (16 bits)
	dw 0x0                          ; Base low (16 bits)
	db 0x0                          ; Base middle (8 bits)
	db 10011010b                    ; Access byte: present, ring 0, code segment, executable, readable
	db 11001111b                    ; Granularity byte: 4K granularity, 32-bit op size, limit high (4 bits)
	db 0x0                          ; Base high (8 bits)

gdt_data:                           ; Data segment descriptor
	dw 0xFFFF                       ; Limit low (16 bits)
	dw 0x0                          ; Base low (16 bits)
	db 0x0                          ; Base middle (8 bits)
	db 10010010b                    ; Access byte: present, ring 0, data segment, writable
	db 11001111b                    ; Granularity byte: 4K granularity, 32-bit op size, limit high (4 bits)
	db 0x0                          ; Base high (8 bits)

gdt_end:

gdt_pointer:
	dw gdt_end - gdt_start          ; Size of the GDT
	dd gdt_start                    ; Address of the GDT

disk:
	db 0x0                          ; Placeholder for disk identifier

CODE_SEG equ gdt_code - gdt_start   ; Code segment offset
DATA_SEG equ gdt_data - gdt_start   ; Data segment offset

times 510 - ($-$$) db 0             ; Fill the rest of the boot sector with zeros
dw 0xaa55                           ; Boot sector signature (must be 0xAA55 to be recognized as bootable)

copy_target:

bits 32                             ; Switch to 32-bit mode

hello: db "Hello more than 512 bytes world!!", 0  ; Define the message to be printed, null-terminated

boot2:
	mov esi, hello                  ; Load address of the message into ESI
	mov ebx, 0xb8000                ; Load the address of the video memory into EBX

.loop:
	lodsb                           ; Load the next byte from ESI into AL and increment ESI
	or al, al                       ; OR AL with itself to set the Zero Flag if AL is zero (end of string)
	jz halt                         ; If Zero Flag is set (end of string), jump to halt
	or eax, 0x0F00                  ; Set the high byte of EAX to 0x0F (attribute for yellow text color)
	mov word [ebx], ax              ; Move the word in EAX to the location in EBX (video memory)
	add ebx, 2                      ; Move to the next character location in video memory
	jmp .loop                       ; Repeat the loop to print the next character

halt:
	mov esp, kernel_stack_top       ; Set the stack pointer to the top of the kernel stack
	extern main                    ; Declare external symbol kmain
	call main                      ; Call the C kernel main function
	cli                             ; Clear interrupts
	hlt                             ; Halt the CPU

section .bss                        ; BSS section for uninitialized data
align 4
kernel_stack_bottom: equ $          ; Bottom of the kernel stack
	resb 16384                      ; Reserve 16 KB for the stack
kernel_stack_top:                   ; Top of the kernel stack
