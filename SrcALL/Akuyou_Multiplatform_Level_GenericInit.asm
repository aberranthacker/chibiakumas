    call AkuYou_Player_GetPlayerVars

    if buildCPCv+buildENTv  ; Turn on CPC raster flipping if allowed
        ld a,(iy-5)
        ld hl,null
        cp 64
        jp nz,LevelInitUsingRasterFlip
        ld (DisablePaletteSwitcher_Plus2-2),hl
    LevelInitUsingRasterFlip:
        call RasterColorsSetPalette1
    endif

    ld hl,EventStreamArray      ;Event Stream
    ld de,Event_SavedSettingsB  ;Saved Settings bank 2
    call AkuYou_Event_StreamInit

    ;;;;;;;;;;;;;;;;;;;;;; Restart the Music ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    call Akuyou_Music_Restart

    call Akuyou_ScreenBuffer_Init

    ;   ld (BackgroundFloodFillQuad_Minus1+1),hl
    ld (BackgroundSolidFillNextLine_Minus1+1),hl

    ifndef UseBackgroundVert
        ld (BackgroundFloodFillQuadSprite_Minus1+1),hl
    else
        ld (BackgroundFloodFillQuadSpriteV_Minus1+1),hl
    endif

    ifdef UseBackgroundFloodFillQuadSpriteColumn
        ld (BackgroundFloodFillQuadSpriteColumn_Minus1+1),hl
        ld (BackgroundFloodFillQuadSpriteColumnB_Minus1+1),hl
    endif

    ifdef UseBlackout
        ld (Background_Blackout_Minus1+1),hl
    endif
    call Akuyou_Interrupt_Init
