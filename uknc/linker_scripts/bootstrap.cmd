OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/bootstrap.o)
OUTPUT(build/bootstrap.out)

SECTIONS
{
    . = 0;
.text :
    {
        build/bootstrap.o (.text)
    }
.data :
    {
        build/bootstrap.o (.data)
    }
.bss :
    {
        build/bootstrap.o (.bss)
    }
}
