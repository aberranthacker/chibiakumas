OUTPUT_FORMAT("binary")
OUTPUT_ARCH(pdp11)

INPUT(build/bootsector.o)
OUTPUT(build/bootsector.bin)

BootstrapSizeWords = ((BootstrapEnd - Bootstrap_Launch) / 2);

SECTIONS
{
    . = 0;
.text :
    {
        build/bootsector.o (.text)
    }
.data :
    {
        build/bootsector.o (.data)
    }
.bss :
    {
        build/bootsector.o (.bss)
    }
}
