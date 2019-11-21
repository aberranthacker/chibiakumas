    ld b,12
    ld hl,PlusSprites_Config1+3
ZeroPlusSprites:
    ld (hl),0
    inc hl
    inc hl
    inc hl
    inc hl
djnz ZeroPlusSprites

    ld b,RasterColors_4
    ld a,b
    ld (RasterColors_4Ver_Plus1-1),a

    xor a
    ld iy,null
    call Akuyou_RasterColors_SetPointers

    ;turbo mode! - disable stuff to make the game fster
    ld hl,PLY_Play
    ld (MusicExec_PerFrame_Plus2-2),hl

    ld hl, RasterColors_TickOverrideFirm
    ld (RasterColorInterruptHandler_Plus2-2),hl

    ld hl,&CC33
    ld (StarArrayColors_Plus2-2),hl

    ld a,0
    call Akuyou_Background_SetScroll
    call AkuYou_Player_GetPlayerVars

;;;;;;;;;;;;;;;This part must be last!;;;;;;;;;;;;;;;;;;;;;
    ld a,(iy-8)
    and %00000011   ;See if we want to turn of music or rasters
    ret z
    ld hl,null
    ld (MusicExec_PerFrame_Plus2-2),hl
    and %00000010   ;See if we want to turn off rasters
    ret z
    ld (RasterColorInterruptHandler_Plus2-2),hl
