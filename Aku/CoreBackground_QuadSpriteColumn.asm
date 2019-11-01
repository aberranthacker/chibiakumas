; Quad Sprite render - This is MUCH faster than a tilestrip, but all the tiles
; must be identical!

; Note, you must inject the correct Nextline code into this function with code like:
; call Akuyou_ScreenBuffer_Init
; ld (BackgroundFloodFillQuadSprite_Minus1-1),hl


; call Akuyou_ScreenBuffer_Flip
; ld (BackgroundFloodFillQuadSprite_Minus1+1),hl


; To add some lines to your background
;
;   ld b,16
;   ld de,Tile_Start
;   call BackgroundFloodFillQuadSpriteColumn
;
; where B is the number of lines, DE is the start of a 32px (8 byte) wide sprite
; and HL is the right hand side of the area to fill

;QuadSprite

BackgroundFloodFillQuadSpriteColumn:
    ld (ColumnBlackLines_Plus1-1),a

BackgroundFloodFillQuadSpriteColumnb:
    di

    ld (BackgroundFloodFillQuadSpriteColumnDeBak_Plus2-2),de
    ld (BackgroundFloodFillQuadSpriteColumnSpRestore_Plus2-2),sp
    ld sp,hl

    exx
    ld hl,&0000 :BackgroundFloodFillQuadSpriteColumnDeBak_Plus2
    ld a,(hl)

    ld ixl,a
    inc l
    ld a,(hl)
    ld ixh,a
    inc l
    ld c,(hl)
    inc l
    ld b,(hl)
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)
    inc l
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a

    ; we move IX to AF to save time, so the first tile is differeng
    push hl
    push de
    push bc
    push ix
    pop af
    dec sp
    dec sp

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

    push hl
    push de
    push bc
    push af

exx

    ld a,h
    add a,&08
    ld h,a

BackgroundFloodFillQuadSpriteColumnB_Minus1:
    bit 7,h
    jp nz,BackgroundFloodFillQuadSpriteColumnNextLineDoneB
    push de
        ld de,&c050
        add hl,de
    pop de

BackgroundFloodFillQuadSpriteColumnNextLineDoneB:
    ld c,3  :ColumnBlackLines_Plus1

BackgroundFloodFillQuadSpriteColumn_MoreBlanks:
    ld sp,hl
    exx

    ld hl,&0000

    ; we move IX to AF to save time, so the first tile is differeng
    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    push hl
    push hl
    push hl
    push hl

    exx
    ei
    ld sp,&0000 :BackgroundFloodFillQuadSpriteColumnSpRestore_Plus2
    di


    ld a,h
    add a,&08
    ld h,a

BackgroundFloodFillQuadSpriteColumn_Minus1:
    bit 7,h
    jp nz,BackgroundFloodFillQuadSpriteColumnNextLineDone
    push de
        ld de,&c050
        add hl,de
    pop de

BackgroundFloodFillQuadSpriteColumnNextLineDone:
    dec c
    jp nz,BackgroundFloodFillQuadSpriteColumn_MoreBlanks

    ld a,8
    add e
    ld e,a
    dec b
    jp nz, BackgroundFloodFillQuadSpriteColumnb
    ei

    ret

