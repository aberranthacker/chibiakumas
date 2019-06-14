/*
OUTPUT_FORMAT("a.out-pdp11")
ENTRY(start)
phys = 00001000;
SECTIONS
{
  .text phys : AT(phys) {
    code = .;
    *(.text)
    *(.rodata)
    . = ALIGN(0100);
  }
  .data : AT(phys + (data - code))
  {
    data = .;
    *(.data)
    . = ALIGN(0100);
  }
  .bss : AT(phys + (bss - code))
  {
    bss = .;
    *(.bss)
    . = ALIGN(0100);
  }
  end = .;
}
*/

OUTPUT_FORMAT("binary")
OUTPUT_ARCH(pdp11)
SEARCH_DIR("/Users/oycymbalyuk/opt/binutils-pdp11/pdp11-dec-aout/lib");
PROVIDE (__stack = 0);

SECTIONS
{
    . = 0;
.text :
    {
        *(.text)
        _etext = .;
        __etext = .;
    }
.data :
    {
        *(.data)
        _edata  =  .;
        __edata  =  .;
    }
.bss :
    {
        __bss_start = .;
        *(.bss)
        _end = . ;
        __end = . ;
    }
}
