OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/ppu.o)
OUTPUT(build/ppu.out)

PPU_KeyboardScanner_P1 = KeyboardScanner_P1 / 2;
PPU_KeyboardScanner_P2 = KeyboardScanner_P2 / 2;

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
