
ExecuteBootStrap: ;Run or load the bootstrap - it takes a two part Hex command
    push hl       ;ALL Disk ops are done through the bootstrap!
    di

ExecuteBootStrapSkipPlus:
    call RasterColors_Disable
    call ply_stop

ifdef Debug
    call Debug_CheckIntOff
endif

    call ScreenBuffer_Reset ; Screenbuffer reset messes with EXX vars!
    call cls
    call Firmware_Restore
    call RasterColors_Blackout

    ;64k version - load into &4000 every time
    ld de,Akuyou_BootStrapStart

    ld hl,null
    ld (DiscDestRelocateCall_Plus2-2),hl

    ld hl, BootStrapFile
    call LoadDiskFileFromHL

    jr StartBootstrap

StartBootstrap:
    pop hl
    ei
    call Akuyou_BootStrapStart+&6 ;Bootstrap_FromHL
    di
    ld a,&80
    call CLSB

    call DoCustomRsts
    ld a,&C0:BootstrapRamRestore_Plus1
    jp BankSwitch_C0_SetCurrent
