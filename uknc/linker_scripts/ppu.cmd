OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/ppu.o)
OUTPUT(build/ppu.out)

CPU_Event_LevelTime = Event_LevelTime / 2;
CPU_Player_ScoreBytes = Player_ScoreBytes / 2;
CPU_P1_P03 = P1_P03 / 2;
CPU_P1_P09 = P1_P09 / 2;
CPU_P1_P13 = P1_P13 / 2;

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
