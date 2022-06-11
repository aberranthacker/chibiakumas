
;Quad Sprite render - This is MUCH faster than a tilestrip, but all the tiles must be identical!

;Note, you must inject the correct Nextline code into this function with code like:
;call Akuyou_ScreenBuffer_Init
;ld (BackgroundFloodFillQuadSprite_Minus1-1),hl


;call Akuyou_ScreenBuffer_Flip
;ld (BackgroundFloodFillQuadSprite_Minus1+1),hl


; To add some lines to your background
;
;   ld b,16
;   ld de,Tile_Start
;   call BackgroundFloodFillQuadSprite
;

; where B is the number of lines, DE is the start of a 32px (8 byte) wide sprite and HL is the right hand side of the area to fill

;QuadSprite

BackgroundFloodFillQuadSprite:

BackgroundFloodFillQuadSpriteb:
    ld (BackgroundFloodFillQuadSpriteDeBak_Plus2-2),de
    di
    ld (BackgroundFloodFillQuadSpriteSpRestore_Plus2-2),sp
    ld sp,hl

    exx
    ld hl,&0000 :BackgroundFloodFillQuadSpriteDeBak_Plus2
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
    push ix;push af
    pop af
    dec sp
    Dec sp

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
ei
ld sp,&0000 :BackgroundFloodFillQuadSpriteSpRestore_Plus2

    ld a,h
    add a,&08
    ld h,a

BackgroundFloodFillQuadSprite_Minus1:
    bit 7,h
    jp nz,BackgroundFloodFillQuadSpriteNextLineDone
    push de
        ld de,&c050
        add hl,de
    pop de

BackgroundFloodFillQuadSpriteNextLineDone:
    ld a,8
    add e
    ld e,a

    djnz BackgroundFloodFillQuadSpriteb

    ei
    ret
