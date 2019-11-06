OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/ppu.o)
OUTPUT(build/ppu.out)

PPU_KeyboardScanner_KeyPresses = KeyboardScanner_KeyPresses / 2;

SECTIONS
{
    . = 0;
.text :
    {
        build/ppu.o (.text)
    }
.data :
    {
        build/ppu.o (.data)
    }
.bss :
    {
        build/ppu.o (.bss)
    }
}
