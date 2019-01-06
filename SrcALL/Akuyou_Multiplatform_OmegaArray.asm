OmegaMovesDummy: dw &0000

OmegaArray_Redraw:
    call Akuyou_Timer_GetTimer
    or a
    ret z

    call OmegaArray_Init
    
    ld hl,OmegaArrayPointer1
    call OmegaArray_RedrawChunk
    
    ld hl,OmegaArrayPointer2
    call OmegaArray_RedrawChunk
    
    ld hl,OmegaArrayPointer3
    call OmegaArray_RedrawChunk
    
    ld hl,OmegaArrayPointer4
    call OmegaArray_RedrawChunk
ret

OmegaArray_Init:
    call Akuyou_ScreenBuffer_GetActiveScreen 
    ld (GetMemPos_ScreenOffset_Plus1-1),a

    call AkuYou_Player_GetPlayerVars

    ;configure the loop for the enemy star array
    ld hl,Player_Hit_Injure_1

    ld a,(iy+4) ;invincibility
    and %11100000   
    jp z,StarArray_PlayerVunrable

    ; player invincible
    ld hl,StarLoopP1Skip
StarArray_PlayerVunrable:
    ; load player 1 location - do it in advance to save time during the loop
    ld a,(iy+1) 
    sub 2
    ld (Player1LocX_Plus1-1),a
    add 4
    ld (Player1LocXB_Plus1-1),a
    ld a,(iy+0) 
    sub 2
    ld (Player1LocY_Plus1-1),a
    add 4
    ld (Player1LocYB_Plus1-1),a

    ld (CurrentStarArrayCollisionsB2_Plus2-2),hl

;;;;;;;;;;;;;;;;;;;;; Player 2 handler
    ;configure the loop for the enemy star array
    ld hl,Player_Hit_Injure_2
    ld a,(iy+4+Akuyou_PlayerSeparator)
    
    and %11100000   
    jp z,StarArray_PlayerVunrable2

    ; player invincible
    ld hl,StarLoopP2Skip

StarArray_PlayerVunrable2:
    ; load player 2 location - do it in advance to save time during the loop
    ld a,(iy+1+Akuyou_PlayerSeparator)
    dec a
    dec a
    ld (Player2LocX_Plus1-1),a
    add 4
    ld (Player2LocXB_Plus1-1),a
    ld a,(iy+0+Akuyou_PlayerSeparator)
    dec a
    dec a
    ld (Player2LocY_Plus1-1),a
    add 4
    ld (Player2LocYB_Plus1-1),a

    ld (CurrentStarArrayCollisions2B2_Plus2-2),hl
ret

OmegaArray_RedrawChunk:
    ld bc,OmegaArraySize
    ld (SpRestore_Plus2-2),sp
    di

Starloop2:
    ld a,(hl)   ; MX
    or a
    jp Z,StarArray_Turbo
    
    ld (Hlrestore_Plus2-2),hl
    inc h

    ld (MovePointer_Plus2-2),a

    ld B,(hl) ; X
    inc h
    ld C,(hl) ; Y
    
Starloop_NotZero:

PlayerCollisions:
    ld a,B
    cp 0:Player1LocX_Plus1
    jr c,StarLoopP1Skip
    cp 0:Player1LocXB_Plus1
    jr nc,StarLoopP1Skip

    ld a,c
    cp 0:Player1LocY_Plus1
    jr c,StarLoopP1Skip
    cp 0:Player1LocYB_Plus1

    jp C,AkuYou_Player_Hit_Injure_1 :CurrentStarArrayCollisionsB2_Plus2
        
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

    jp C,Player_Hit_Injure_2 :CurrentStarArrayCollisions2B2_Plus2
        
StarLoopP2Skip:
StarCollisionsDone:
    ld de,(MoveArray1) :MovePointer_Plus2
    ld (OmegaMoves),de :OmegaMovesSet_Plus2

OmegaMoves: nop
    nop
    ld (hl),c
    dec h
    ld (hl),b 

read "..\SrcCPC\Akuyou_CPC_OmegaArray_Draw.asm"

StarArray_Next:

StarArray_Finish:
    ld hl,&0000 :Hlrestore_Plus2
StarArray_Turbo:
    ei
    ld sp,&1234 :SpRestore_Plus2
    di

    inc l

    jp nz,starloop2

    ld sp,(SpRestore_Plus2-2)
    ei
    ret

DoMoves_Kill
    ld hl,(Hlrestore_Plus2-2)

    xor a
    ld (hl),a ;MX

    jp StarArray_Turbo

Player_Hit_Injure_2:
    ld sp,(SpRestore_Plus2-2)
    call AkuYou_Player_Hit_Injure_2
    di
    jp StarLoopP2Skip

Player_Hit_Injure_1:
    ld sp,(SpRestore_Plus2-2)
    call AkuYou_Player_Hit_Injure_1
    di
    jp StarLoopP1Skip

align 256,&00

MoveArray1:
;   inc c ; Zero marks a dead command
    nop ;L
    dec b   ;L

    dec c   ;UL
    dec b   ;DL

    dec c   ;U
    nop ;U

    dec c   ;UR
    inc b   ;UR

    nop ;R
    inc b   ;R

    inc c   ;DR
    inc b   ;DR 

    inc c   ;D
    nop ;D

    inc c   ;DL
    dec b   ;DL

MoveArray4:
    inc c   ;DL
    dec b   ;DL
    
    nop ;L
    dec b   ;L

    dec c   ;UL
    dec b   ;DL

    dec c   ;U
    nop ;U

    dec c   ;UR
    inc b   ;UR

    nop ;R
    inc b   ;R

    inc c   ;DR
    inc b   ;DR 

    inc c   ;D
    nop ;D
;17 bytes later 1

MoveArray6:
    dec c   ;UL
    dec b   ;DL

    dec c   ;U
    nop ;U

    dec c   ;UR
    inc b   ;UR

    nop ;R
    inc b   ;R

    inc c   ;DR
    inc b   ;DR 

    inc c   ;D
    nop ;D

    inc c   ;DL
    dec b   ;DL

    nop ;L
    dec b   ;L

MoveArrayLR:
    dec b   ;DL
    dec b   ;DL

    nop
    dec b

    inc b   ;UR
    inc b   ;UR

    inc b   ;R
    inc b   ;R

    inc b   ;DR 
    inc b   ;DR 

    nop
    inc b

    dec b   ;DL
    dec b   ;DL

    dec b   ;L
    dec b   ;L

MoveArrayUD:
    dec c   ;UL
    dec c   ;UL

    dec c   ;U
    dec c   ;U

    dec c   ;U
    dec c   ;U

    dec c
    nop;

    inc c   ;DR
    inc c   ;DR

    inc c   ;D
    inc c   ;D

    inc c   ;DL
    inc c   ;DL

    nop
    inc c

MoveArray2:
    nop ;L
    dec b   ;L

    dec c   ;UL
    dec b   ;DL

    dec c   ;U
    nop ;U

    dec c   ;UR
    inc b   ;UR

    nop ;R
    inc b   ;R

    inc c   ;DR
    inc b   ;DR 

    inc c   ;D
    nop ;D

    inc c   ;DL
    dec b   ;DL
MoveArray7:
    inc c   ;DL
    dec b   ;DL

    nop ;L
    dec b   ;L

    dec c   ;UL
    dec b   ;DL

    dec c   ;U
    nop ;U

    dec c   ;UR
    inc b   ;UR

    nop ;R
    inc b   ;R

    inc c   ;DR
    inc b   ;DR 

    inc c   ;D
    nop ;D

MoveArray8:
    dec c   ;UL
    dec b   ;DL

    dec c   ;U
    nop ;U

    dec c   ;UR
    inc b   ;UR

    nop ;R
    inc b   ;R

    inc c   ;DR
    inc b   ;DR 

    inc c   ;D
    nop ;D

    inc c   ;DL
    dec b   ;DL

    nop ;L
    dec b   ;L
