
;-------------------------------------------------------------------------------
;|*****************************************************************************|
;|*                               Text Driver                                 *|
;|*****************************************************************************|
;-------------------------------------------------------------------------------

;DrawText_SetPen equ &bb90 ;set pen to A
;DrawText_Locate equ &bb75 ; set location to X=L , Y=H
;DrawText_PrintChar equ &bb5a

; These were designed to mimic firmware functions
DrawText_LocateAndPrintStringUnlimited:
    call DrawText_LocateSprite
DrawText_PrintStringUnlimited:
    ld a,(bc)
    cp a,&80
    jr nc,DrawText_PrintLastChar
    push bc
        call DrawText_CharSprite; draw char
    pop bc

    inc bc
    jp DrawText_PrintStringUnlimited

;DrawText_LocateAndPrintString
;   call DrawText_LocateSprite
DrawText_PrintString:
    ; I Limits the number of characters to be show,
    ; used for 'typing' effect during the boss sequences, and intro
    ld a,i
    dec a
    ret z
    ld i,a
    ld a,(bc)
    cp a,&80
    jr nc,DrawText_PrintLastChar

    call DrawText_CharSpriteProtectBC
    inc bc
    jp DrawText_PrintString
DrawText_PrintLastChar:
    and %01111111
DrawText_CharSpriteProtectBC:
    push bc
        call DrawText_CharSprite; draw char
    pop bc
    ret

DrawText_Decimal:
    ld c,0
    ld b,a
    ld a,&C4
    ld (DrawTextForceZeroCall_Plus3-3),a
    ld a,b
    cp 100
    jr c,SkipDigit100

    ld a,&CD
    ld (DrawTextForceZeroCall_Plus3-3),a
    ld a,b
DrawText_DecimalSub100:
    cp 100
    jr c,DrawText_DecimalLessThan100
    inc c
    sub 100
    jr DrawText_DecimalSub100

DrawText_DecimalLessThan100:
    ld b,a
    ld a,c
    or a
    call nz,DrawText_CharSprite48
SkipDigit100:
    ld a,b
    ld c,0
DrawText_DecimalSubTen:
    cp 10
    jr c,DrawText_DecimalLessThanTen
    inc c
    sub 10
    jr DrawText_DecimalSubTen
DrawText_DecimalLessThanTen:
    ld b,a
    ld a,c
    or a
    call nz,DrawText_CharSprite48   :DrawTextForceZeroCall_Plus3
SkipDigit10:
    ld a,b
DrawText_CharSprite48:
    add 48
    push bc
        call DrawText_CharSprite
    pop bc
ret
;end of drawtext decimal


DrawText_CarriageReturnSprite:
    ld hl,&0000 :DrawText_CarriageReturnSpritePos_Plus2
    inc l
DrawText_LocateSprite4CR:
    ld (DrawText_CarriageReturnSpritePos_Plus2-2),hl
DrawText_LocateSprite:  ; this mimics the way the firmare functions work  (DrawText_Locate)
    ld a,l
    add a
    add a
    add a
    ld (SprShow_Y),a
    ld a,h
ifndef CPC320
    sub TextScreen_MinX
endif
    add a
    ld (SprShow_X),a
ret

; equiv of DrawText_PrintChar
DrawText_CharSprite:        ; Must have already set the correct bank!
    ld b,2  :DrawText_CharSpriteMoveSize_Plus1
    cp 13
    jr z,DrawText_CarriageReturnSprite

DrawText_CharSpriteDirect:
    sub 33
    ld (SprShow_SprNum),a
    ld e,a
        ld a,(SprShow_X)
ifdef CPC320
        cp 80
else
        cp 64
endif
        ret nc
        ld (SprShow_TempX),a        ; move the cursor along for next char
        ld d,a
        add b
        ld (SprShow_X),a

        ld a,(SprShow_Y)
        ld (SprShow_TempY),a
        ld c,a

    ld a,e
    cp 192
    ret NC  ; Our font has no space! so dont draw anything below 32 (above 192)

DrawText_CharFirmwareFont:
    ld b,d
    push de
        call GetMemPos
    pop de
    push hl
        ld hl,33*8+&3800

        ld d,0

        rl e
        rl d
        rl e
        rl d
        rl e
        rl d
        add hl,de
        ld d,h
        ld e,l
    di
    exx
        ld bc,DrawText_CharFirmwareFont_GetCharEnd-DrawText_CharFirmwareFont_GetChar+1
        ld hl,DrawText_CharFirmwareFont_GetChar
        ld de,&FFD0
        ldir

        ld bc,&7f00+%10001101  ;10AIRRMM ... A asic exclusive / RR UpperLower Rom (1= off) / MM screen mode
    exx

    pop hl


    push hl
    ex hl,de

        ld de,&F7D0
        call &FFD0  ; Our temp destination for the fontcode
    pop hl

    ld b,9
    ld de,&F7D0
    jr DrawText_DicharSprite_NextLine2B

DrawText_DicharSprite_NextLineMini:
    ld a,(de)
    ld c,a
    xor a
    rl c
    rla
    sll c
    rl c
    rla
    sll c
    rl c
    rla
    sll c
    rl c
    rla
    sll c
    ld (hl),a
    jr DrawText_DicharSprite_NextLine2
DrawText_DicharSprite_NextLine:
    and &0F
    inc hl
    ld (hl),a
    dec hl
    ld a,c
    and &F0
    rrca
    rrca
    rrca
    rrca
    ld (hl),a

    ld a,(de)
    ld c,a
    and &0F
    inc hl
    ld (hl),a
    dec hl
    ld a,c
    and &F0
    rrca
    rrca
    rrca
    rrca
    ld (hl),a

DrawText_DicharSprite_NextLine2:
    push de
        call GetNxtLin
    pop de
    inc de
DrawText_DicharSprite_NextLine2B:
    djnz DrawText_DicharSprite_NextLine :DrawText_DicharSprite_Font_Plus1

    ei
    ret

DrawText_CharFirmwareFont_GetChar:
    ld bc,&7f00+%10001001  ;10AIRRMM ... A asic exclusive / RR UpperLower Rom (1= off) / MM screen mode
    out (c),c
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ld a,&8D    ; Reset the firmware to OFF
    out (c),a
DrawText_CharFirmwareFont_GetCharEnd:
ret
