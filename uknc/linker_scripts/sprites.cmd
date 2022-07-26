OUTPUT_FORMAT("binary")
OUTPUT_ARCH(pdp11)

SECTIONS
{
    . = 0;
.text :
    {
        *(.text)
    }
.data :
    {
        *(.data)
    }
.bss :
    {
        *(.bss)
    }
}
