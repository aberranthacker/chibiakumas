OUTPUT_FORMAT("binary")
OUTPUT_ARCH(pdp11)

INPUT(build/bootstrap.o)
OUTPUT(build/AKU.SAV)

FileSizeCoreWords = ((FileEndCore - FileBeginCore) / 2);
FileSizeSettingsWords = ((SavedSettings - SavedSettings_Last) / 2);

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
