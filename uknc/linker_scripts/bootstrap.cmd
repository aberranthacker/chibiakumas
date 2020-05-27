OUTPUT_FORMAT("a.out-pdp11")
OUTPUT_ARCH(pdp11)

INPUT(build/bootstrap.o)
OUTPUT(build/bootstrap.out)

GameVarsArraySize = (Akuyou_GameVarsEnd - Akuyou_GameVarsStart);
GameVarsArraySizeWords = (Akuyou_GameVarsEnd - Akuyou_GameVarsStart) / 2;

FileSizeCoreWords     = ((FileEndCore - FileBeginCore) / 2);
FileSizeSettingsWords = ((SavedSettings - SavedSettings_Last) / 2);

BootstrapBlockNum = 1;
PPUModuleBlockNum     = (BootstrapSizeWords  + 255) / 256 + BootstrapBlockNum;
LoadingScreenBlockNum = (PPU_ModuleSizeWords + 255) / 256 + PPUModuleBlockNum;
CoreBlockNum          = (8000                + 255) / 256 + LoadingScreenBlockNum;
Level00BlockNum       = (FileSizeCoreWords   + 255) / 256 + CoreBlockNum;
Ep1IntroBlockNum      = (Level00SizeWords    + 255) / 256 + Level00BlockNum;

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
