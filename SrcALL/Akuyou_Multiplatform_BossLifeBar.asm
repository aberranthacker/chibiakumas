;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  CPC Ver                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    BossColor0:
        ld de,&FFFF
        ld bc,&0000
        
    ret
    BossColor1:
        ld de,&0F0F
        ld bc,&FFFF
    ret
    BossColor2:
        ld de,&F0F0
        ld bc,&0F0F
    ret
    BossColor3:
        ld de,&0000
        ld bc,&F0F0
    ret
    BossColorFlash:
        ld de,&0000
        ld bc,&0000
        xor a
        ld (BossColorFlashAction_Plus1-1),a
    jr BossLifeBarDisplayB

    BossLifeBarInit:
        ld (barinitcount_Plus1-1),a
        ld de,&0000
        ld bc,&FFFF
        jr BossLifeBarDisplay

    BossLifeBar:
        di

        call Akuyou_ScreenBuffer_GetActiveScreen
        ld hl,&2780 +72
        add h
    ld h,a

        ld ixl,4

        ld a,31:barinitcount_Plus1
        inc a
        cp 32
        jr c,BossLifeBarInit

        ld a,0 :BossColorFlashAction_Plus1
        or a
        jr nz,BossColorFlash

        ld a,(BossLife)
        and %01100000
        cp  %01100000
        call z,BossColor0
        cp  %01000000
        call z,BossColor1
        cp  %00100000
        call z,BossColor2
        cp  %00000000
        call z,BossColor3

    BossLifeBarDisplayB:
        ld a,(BossLife)
        and %00011111

    BossLifeBarDisplay:

        ld (BarFull_Plus2-2),bc

        ld (BarEmpty_Plus2-2),de

        ld b,a
        ld a,32
        sub b
        ld c,a
    BossLifeBarLineLoop:    

        push hl
            di
            ld (SpRestoreFillB_Plus2-2),sp
            ld sp,hl
            ld a, b
            cp 32
            jp z,BossLifeBarContinue

            ld de,pushde32
            ld a,e
            add b

            ld e,a

            push de

                ld de,&0F0F :BarEmpty_Plus2
                ld hl,BossLifeBarContinue

            ret ;effectively call the pushed DE
    BossLifeBarContinue:
            ld a, c
            cp 32
            jp z,BossLifeBarContinueB
            ld de,pushde32
            ld a,e
            add c

            ld e,a

            push de
        
                ld de,&F0F0     :BarFull_Plus2
                ld hl,BossLifeBarContinueB

            ret ;effectively call the pushed DE

    BossLifeBarContinueB:
            ei
            ld sp,&0000:SpRestoreFillB_Plus2

        pop hl
        ld a,8
        add h
        ld h,a

        dec ixl
        jp nz, BossLifeBarLineLoop
    ret
    align 64,&00

    pushde32:
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de

    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
Pushde16:
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
Pushde8:
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    jp (hl)

    StartBossLifeBar:
        push hl
            ld hl,BossLifeBar
            ld (BossLifeBarCall_Plus2-2),hl
        pop hl
        ret
