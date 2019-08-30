# ../../AkuCPC/BootsStrap_StartGame_CPC.asm

        MOV  @$SPReset,SP # we are not returning, so reset the stack

        # Load the game core - this is always in memory
        MOV  $CoreBinRadix50, @$LookupFileName      # ld hl,FileName_Core
        MOV  $FileBeginCore, @$ReadBuffer           # ld de,Akuyou_CoreStart
        MOV  $FileSizeCoreWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile                 # call BootStrap_LoadDiskFile

        MOV  $SavSetBinRadix50, @$LookupFileName    # ld hl,FileName_Settings
        MOV  $SavedSettings, @$ReadBuffer           # ld de,SavedSettings
        MOV  $FileSizeSettingsWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile                 # call BootStrap_LoadDiskFile

                                       #    di
                                       #    ld hl,(&bd37+1)             ; Get the Restore High Jumpblock command
                                       #    ld (FirmJumpLoc_Plus2-2),hl ; it's different on 464/6128 firmware!
                                       #
                                       #    ;Put some strange bytes at &4000 for us to detect!
                                       #    ld hl,&6669
                                       #    ld (&4000),hl
                                       #
                                       #DetectedNonPlus:
                                       #    ei
                                       #
                                       #    ld hl,RasterColors_InitColors
                                       #    call SetColors
                                       #
                                       #    ld a,&0D
                                       #    ld (SetDiskMessagePos_Plus2-1),a
                                       #
                                       #    ld a,&C0
                                       #    call BankSwitch_C0_SetCurrent
                                       #
                                       #    jp PlusLoad
                                       #
                                       #    ld a,Font_Membank
                                       #    ld hl,DiskMap_Font      ;T07-SC1.D00
                                       #    ld c,DiskMap_Font_Disk
                                       #    ld de,Font_RegularSizePos
                                       #    ld ix,Font_RegularSizePos-1+&1000
                                       #
                                       #    call Akuyou_LoadDiscSectorZ
                                       #
                                       #PlusLoad:
                                       #    ei
                                       #
                                       #NotAPlus:
                                       #    ld a,&C0
                                       #    call BankSwitch_C0_SetCurrent
                                       #
                                       ##   ifdef Debug
                                       #        ld l,12             ; Show the 'Debug mode' message
                                       #        ld bc,DebugBuild
                                       #        call ShowTextLines
                                       ##   endif
                                       #
                                       #    ld a,&C0
                                       #    ld hl,DiskMap_PlayerSprite
                                       #    ld b,DiskMap_PlayerSprite_Size
                                       #    ld c,DiskMap_PlayerSprite_Disk
                                       #    ld de,Akuyou_PlayerSpritePos
                                       #    ld ix,Akuyou_PlayerSpritePos+&800-1
                                       #    call Akuyou_LoadDiscSectorz

# ../../SrcCPC/Akuyou_CPC_DiskDriver.asm:27
# 30:LoadDiscSectorZ: ;Load Compressed Disk sector

                                       #    ;DiskMap_PlayerSpriteUD         equ &06C3 ;T06-SC3.D00
                                       #    ld a,&C7
                                       #    ld hl,DiskMap_PlayerSpriteBo
                                       #    ld c,0
                                       #    ld de,&6800
                                       #    ld ix,&6800+&1800
                                       #    call Akuyou_LoadDiscSectorz
                                       #
                                       #PlayerSpritesNotNeeded:
                                       #    ld a,&C0
                                       #    ld hl,DiskMap_SFX
                                       #
                                       #    ld c,DiskMap_SFX_Disk
                                       #    ld de,Akuyou_SfxPos
                                       #    push de
                                       #    call Akuyou_LoadDiscSector
                                       #    pop de
                                       #    call Akuyou_Sfx_Init;
