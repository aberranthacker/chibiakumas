# ../../AkuCPC/BootsStrap_StartGame_CPC.asm

        MOV  @$SPReset,SP # we are not returning, so reset the stack

        # Load the game core - this is always in memory
        MOV  $CoreBinRad50, @$LookupFileName      # ld hl,FileName_Core
        MOV  $FileBeginCore, @$ReadBuffer           # ld de,Akuyou_CoreStart
        MOV  $FileSizeCoreWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile                 # call BootStrap_LoadDiskFile
        # Load saved settings
        MOV  $SavSetBinRad50, @$LookupFileName    # ld hl,FileName_Settings
        MOV  $SavedSettings, @$ReadBuffer           # ld de,SavedSettings
        MOV  $FileSizeSettingsWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile                 # call BootStrap_LoadDiskFile

# ../../SrcCPC/Akuyou_CPC_DiskDriver.asm:27
# 30:LoadDiscSectorZ: ;Load Compressed Disk sector

