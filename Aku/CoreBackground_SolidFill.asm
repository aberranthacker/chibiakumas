
;Solid fill render - fill lines with DE

;Note, you must inject the correct Nextline code into this function with code like:
;call Akuyou_ScreenBuffer_Init
;ld (BackgroundSolidFillNextLine_Minus1-1),hl


;call Akuyou_ScreenBuffer_Flip
;ld (BackgroundSolidFillNextLine_Minus1+1),hl

; To add some lines to your background
;
;   ld b,16
;   ld de,&0000
;   call BackgroundFloodFillQuadSprite
;
; where B is the number of lines, HL is the right hand side of the area to fill

;QuadSprite

BackgroundSolidFill:
  di
  ld (BackgroundSolidFillSpRestore_Plus2-2),sp

BackgroundSolidFillAgain:
    ld sp,hl

    ei
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL

    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL

    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    di
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL

    ld a,h
    add a,&08
    ld h,a

    BackgroundSolidFillNextLine_Minus1:
        bit 7,h
        jp nz,BackgroundSolidFillNextLineDone
        push de
            ld de,&c050
            add hl,de
        pop de

BackgroundSolidFillNextLineDone:
    di
    djnz BackgroundSolidFillAgain

    ld sp,&0000 :BackgroundSolidFillSpRestore_Plus2
    ei

    ret
