OUTPUT_FORMAT("binary")
OUTPUT_ARCH(pdp11)

INPUT(bootstrap.o)
OUTPUT(AKU.SAV)

FileSizeCoreWords = ((FileEndCore - FileBeginCore) / 2);
FileSizeSettingsWords = ((SavedSettings - SavedSettings_Last) / 2);

SECTIONS
{
    . = 0;
.text :
    {
        bootstrap.o (.text)
    }
.data :
    {
        bootstrap.o (.data)
    }
.bss :
    {
        bootstrap.o (.bss)
    }
}
