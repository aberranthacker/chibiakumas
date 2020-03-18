OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/bootstrap.o)
OUTPUT(build/bootstrap.out)

FileSizeCoreWords = ((FileEndCore - FileBeginCore) / 2);
FileSizeSettingsWords = ((SavedSettings - SavedSettings_Last) / 2);
BootstrapSize = (BootstrapEnd - Bootstrap_Launch);

BootstrapBlockNum = 1;
PPUModuleBlockNum     = (BootstrapSize       + 511) / 512 + BootstrapBlockNum;
LoadingScreenBlockNum = (PPU_ModuleSizeWords + 255) / 256 + PPUModuleBlockNum;
CoreBlockNum          = (8000                + 255) / 256 + LoadingScreenBlockNum;
Level00BlockNum       = (FileSizeCoreWords   + 255) / 256 + CoreBlockNum;

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
