extern "C" void kmain()

{
	const short color = 0x0F00;
	const char* text = "cpp function called from bootloader";
	short* vga = (short*)0xb8000;
	for (int i = 0; i<16;++i)
		vga[i+80] = color | text[i];
}