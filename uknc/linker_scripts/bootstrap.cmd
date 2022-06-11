OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/bootstrap.o)
OUTPUT(build/bootstrap.out)

FileSizeCoreWords     = ((FileEndCore - FileBeginCore) / 2);
FileSizeSettingsWords = ((SavedSettings - SavedSettings_Last) / 2);

LoadingScreenSizeWords = 8000;

BootstrapBlockNum = 1;
PPUModuleBlockNum      = (BootstrapSizeWords      + 255) / 256 + BootstrapBlockNum;
LoadingScreenBlockNum  = (PPU_ModuleSizeWords     + 255) / 256 + PPUModuleBlockNum;
CoreBlockNum           = (LoadingScreenSizeWords  + 255) / 256 + LoadingScreenBlockNum;

Ep1IntroBlockNum       = (FileSizeCoreWords       + 255) / 256 + CoreBlockNum;
Ep1IntroSlidesBlockNum = (Ep1IntroSizeWords       + 255) / 256 + Ep1IntroBlockNum;

Level00BlockNum        = (Ep1IntroSlidesSizeWords + 255) / 256 + Ep1IntroSlidesBlockNum;
Level01BlockNum        = (Level00SizeWords        + 255) / 256 + Level00BlockNum;

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
