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

OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)
SEARCH_DIR("/Users/oycymbalyuk/opt/binutils-pdp11/pdp11-dec-aout/lib");

ENTRY(FileBeginCore)

SECTIONS
{
    . = 0;
.text :
    {
        *(.text)
        . = ALIGN(2);
        _etext = .;
        __etext = .;
    }
.data :
    {
        *(.data)
        . = ALIGN(2);
        _edata  =  .;
        __edata  =  .;
    }
.bss :
    {
        __bss_start = .;
        *(.bss)
        . = ALIGN(2);
        _end = . ;
        __end = . ;
    }
}
