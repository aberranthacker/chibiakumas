    di
    call    ScreenFirmwareReset

    ld hl,EventStreamArray
    ld de,Event_SavedSettings   ;Saved Settings
    call AkuYou_Event_StreamInit

    call Akuyou_RasterColors_Init
    call    Clear4000
        call AkuYou_Player_GetPlayerVars
        ld a,(iy-5)
        ld hl,null
        cp 64
        jp nz,LevelInitUsingRasterFlip
        ld (DisablePaletteSwitcher_Plus2-2),hl
    LevelInitUsingRasterFlip:
        call RasterColorsSetPalette1
        ld a,&C0
        call Akuyou_BankSwitch_C0_SetCurrent
;       call Akuyou_RasterColors_Init
    call Akuyou_Interrupt_Init  ;   call Akuyou_RasterColors_Init

    ld a,2
    call Akuyou_SpriteBank_Font

    call Akuyou_Music_Restart
    call Akuyou_ScreenBuffer_Reset
    call Akuyou_Interrupt_Init  ;   call Akuyou_RasterColors_Init
