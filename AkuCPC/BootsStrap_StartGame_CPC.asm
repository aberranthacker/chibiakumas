
    ld sp,&BFFF ; we are not returning, so reset the stack

    ;Border To black
    ld a,1
    ld b,0
    ld c,b
    call &bc38  ; set border 0 to black

    ifndef debug
        ld hl,RasterColors_ZeroColors
        call SetColors
    endif

    ;Load the game core - this is always in memory
    ld hl,FileName_Core
    ld de,Akuyou_CoreStart
    call BootStrap_LoadDiskFile

    call &BB57 ; TXT VDU Disable

    ld hl,FileName_Settings
    ld de,SavedSettings
    call BootStrap_LoadDiskFile

    call &BB54 ; TXT VDU enable

    ;wipe the CPC ver setting
    xor a
    ld (CPCVer),a

    ;Backup Disk operating system Vars here - Please add your own
    ;if you have special requirements
    ;please see Firmware_Restore in the core.asm file for the other half!
    ld hl,(&be7d)   ; get address where current drive number is held
    ld a,(hl)       ; get drive number
    ld (FirwareRestoreDriveNo_Plus1-1),a
    ld hl,(&BAFE)
    ld (ParadosSettings_Plus2-2),hl

    di
    ld hl,(&bd37+1)             ; Get the Restore High Jumpblock command
    ld (FirmJumpLoc_Plus2-2),hl ; it's different on 464/6128 firmware!

;test
    ;Put some strange bytes at &4000 for us to detect!
    ld hl,&6669
    ld (&4000),hl

DetectedNonPlus:
    ld a,&C0
    call Akuyou_BankSwitch_C0_SetCurrent
    ei

    ; reset location

    ld a,&c0
    ld hl,&0000
    call &bd1f  ;call mc_screen_offset

    ld a,1
    call &bc0e ;Scr_SetMode

    ifndef AllowDisk2
        ld a, &C0
        ld hl,DiskMap_LoadingScreen ; T38-SC1.D01
        ld b, DiskMap_LoadingScreen_Size
        ld c, DiskMap_LoadingScreen_Disk
        ld de,&C000
        ld ix,&C000 + &4000 - 1 ; -8523
        call Akuyou_LoadDiscSectorZ ;; ../SrcCPC/Akuyou_CPC_DiskDriver.asm:27
    endif

    ld hl,RasterColors_InitColors
    call SetColors

    ld a,&0D
    ld (SetDiskMessagePos_Plus2-1),a


    ld a,&C0
    call BankSwitch_C0_SetCurrent

    jp PlusLoad

    ld a, Font_Membank
    ld hl,DiskMap_Font      ;T07-SC1.D00
    ld c, DiskMap_Font_Disk
    ld de,Font_RegularSizePos
    ld ix,Font_RegularSizePos-1+&1000

    call Akuyou_LoadDiscSectorZ

PlusLoad:
    ei

NotAPlus:
    ld a,&C0
    call BankSwitch_C0_SetCurrent

    ifdef Debug
        ld l,12             ; Show the 'Debug mode' message
        ld bc,DebugBuild
        call ShowTextLines
    endif

    ld a,&C0
    ld hl,DiskMap_PlayerSprite
    ld b, DiskMap_PlayerSprite_Size
    ld c, DiskMap_PlayerSprite_Disk
    ld de,Akuyou_PlayerSpritePos
    ld ix,Akuyou_PlayerSpritePos+&800-1
    call Akuyou_LoadDiscSectorz

    ld a,&C7
    ld hl,DiskMap_PlayerSpriteBo
    ld c,0
    ld de,&6800
    ld ix,&6800+&1800
    call Akuyou_LoadDiscSectorz

PlayerSpritesNotNeeded:
    ld a,&C0
    ld hl,DiskMap_SFX

    ld c,DiskMap_SFX_Disk
    ld de,Akuyou_SfxPos
    push de
    call Akuyou_LoadDiscSector
    pop de
    call Akuyou_Sfx_Init;
