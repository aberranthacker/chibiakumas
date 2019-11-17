;*******************************************************************************
;                                  Star Array
;*******************************************************************************

SetStarArrayPalette:
    ld (StarArrayColors_Plus2-2),hl
ret

Stars_Color2a equ Stars_Color2a_Plus1-1
Stars_Color1a equ Stars_Color1a_Plus1-1

Player_StarArray_Redraw:
    ; Redraw the enemy star array
;   ld B,a ;StarLastGood_Plus1

    ld a,&06 :PlayerStarColor_Plus1 ;&12 ;6f
    call StarArray_InitColorsOne

    ;configure the loop for the player star array
    ld hl,null
    ld (CurrentStarArrayCollisionsB2_Plus2-2),hl
    ld (CurrentStarArrayCollisions2B2_Plus2-2),hl

    
    ld hl,PlayerStarArrayPointer;(StarArrayMemloc_Player)
    ld b,PlayerStarArraySize;36 StarArraySize_Player_Plus1

    jp Starloop2_Start

    StarArray_InitColorsOne:
        ld d,a
        ld e,a

StarArray_InitColors:
    ld a,e
    ld (Stars_Color1a),a
    ld a,d
    ld (Stars_Color2a),a
ret

StarArray_Redraw:
    ld a,(Timer_TicksOccured)
    or a
    ret z   ; see if game is paused (TicksOccurred = 0 )
push af

    ; Redraw the enemy star array
    ld B,StarArraySize; 255 StarArraySize_Enemy_Plus1
    ;ld B,a ;StarLastGood_Plus1
    ld de,&CC33 :StarArrayColors_Plus2
    call StarArray_InitColors

;;;;;;;;;;;;;;;;;;;;; Player 1 handler
    ;configure the loop for the enemy star array
    ld hl,Player_Hit_Injure_1
    ld a,(P1_P07)   ;invincibility
    or a
    jp z,StarArray_PlayerVunrable

    ; player invincible
    ld hl,null

StarArray_PlayerVunrable:
    ; load player 1 location - do it in advance to save time during the loop
    ld a,(P1_P01)   
    sub 2
    ld (Player1LocX_Plus1-1),a
    add 4
    ld (Player1LocXB_Plus1-1),a
    ld a,(P1_P00)   
    sub 2
    ld (Player1LocY_Plus1-1),a
    add 4
    ld (Player1LocYB_Plus1-1),a

    ld (CurrentStarArrayCollisionsB2_Plus2-2),hl

;;;;;;;;;;;;;;;;;;;;; Player 2 handler
    ;configure the loop for the enemy star array
    ld hl,Player_Hit_Injure_2
    ld a,(P2_P07) ;invincibility  
    or a
    jp z,StarArray_PlayerVunrable2

    ; player invincible
    ld hl,null
StarArray_PlayerVunrable2:
    ; load player 2 location - do it in advance to save time during the loop
    ld a,(P2_P01)   
    dec a
    dec a
    ld (Player2LocX_Plus1-1),a
    add 4
    ld (Player2LocXB_Plus1-1),a
    ld a,(P2_P00)   
    dec a
    dec a
    ld (Player2LocY_Plus1-1),a
    add 4
    ld (Player2LocYB_Plus1-1),a

    ld (CurrentStarArrayCollisions2B2_Plus2-2),hl

    ld hl,StarArrayPointer;&0000 StarArrayMemloc_Enemy_Plus2

    pop af ;get back time
    ld de,&2FCB :StarSlowdown_Plus2 ; CB 2F == SRA A / C6 00 == ADD A,0
    and %00000010   :SlowdownFreq_Plus1
    jr z,Starloop2_Start2


Starloop2_Start:
    ld de,&00C6 :PlayerFireSpeed_Plus2

Starloop2_StartA:

Starloop2_Start2:

    ld (StarSlowdownB_Plus2-2),de
    ld (StarSlowdownA_Plus2-2),de

    ;Reset the star array to allow more stars to be added
    xor a 
    ld (StarArrayFullMarker_Plus1-1),a
Starloop2:

    ld a,(hl)   ; Y
    or a
    jr NZ,StarArray_FoundOne    ;Y=0 means a dead object in the array
StarArray_Turbo:
    inc l
    djnz starloop2
    ret
DoMovesStars_Kill:
    pop hl
    ld (hl),0
    pop bc
    jp StarArray_Turbo

StarArray_FoundOne:
push bc
    ld c,a
    push hl
        inc h
        ld b,(hl) ; X
        inc h
        ld d,(hl) ; M
        ;call DoMovesStars  ; Slightly quicker than domoves  - also remember firsy bit in stars notes player!
    ld a,D
    and %00111000       :StarFlipperB_Plus1
    rrca
    rrca

    sub 8           :StarVerticalMove_Plus1 ;Used for Particle array
    bit 6,d
    jp z,DoMovesStars_NoMult2
     rlca
    DoMovesStars_NoMult2:
    sra a           :StarSlowdownA_Plus2 ; CB 2F == SRA A / C6 00 == ADD A,0 
    add C

ifdef CPC320
    cp 199+24       ;we are at the bottom of the screen
else
    cp 191+24       ;we are at the bottom of the screen
endif
    jr NC,DoMovesStars_Kill ;over the page
ifdef CPC320
    cp 24
else
    cp 32
endif
    jr C,DoMovesStars_Kill

    ld c,a

    ld a,D
    and %00000111       :StarFlipperA_Plus1
    sub 4           
    bit 6,d
    jp z,DoMovesStars_NoMult
         rlca
    DoMovesStars_NoMult:
    sra a           :StarSlowdownB_Plus2 ; CB 2F == SRA A / C6 00 == ADD A,0
    add b
ifdef CPC320
    cp 160+24       ;we are at the bottom of the screen
else
    cp 168
endif
    jr NC,DoMovesStars_Kill ;over the page
ifdef CPC320
    cp 24
else
    cp 41
endif

    jr C,DoMovesStars_Kill

    ld b,a

PlayerCollisions:
        cp 0:Player1LocX_Plus1
        jr c,StarLoopP1Skip
        cp 0:Player1LocXB_Plus1
        jr nc,StarLoopP1Skip

        ld a,c
        cp 0:Player1LocY_Plus1
        jr c,StarLoopP1Skip
        cp 0:Player1LocYB_Plus1

        call C,Player_Hit_Injure_1 :CurrentStarArrayCollisionsB2_Plus2
        
StarLoopP1Skip:
        ld a,c
        cp 0:Player2LocY_Plus1
        jr c,StarLoopP2Skip
        cp 0:Player2LocYB_Plus1
        jr nc,StarLoopP2Skip

        ld a,B
        cp 0:Player2LocX_Plus1
        jr c,StarLoopP2Skip
        cp 0:Player2LocXB_Plus1

        call C,Player_Hit_Injure_2 :CurrentStarArrayCollisions2B2_Plus2
        
StarLoopP2Skip:
StarCollisionsDone:
        dec h
        ld (hl),b ;X
StarCollisionsStardead:
        dec h
        ld (hl),c ;Y
        ld a,c  
ifdef CPC320
        sub 24  
else
        sub 32
endif
        ld l,A
        ld a,b
ifdef CPC320
        sub 24
else
        sub 40
endif

read "..\SrcCPC\Akuyou_CPC_StarDraw.asm"

StarArray_Next:
    pop hl
    pop bc
    jp StarArray_Turbo
