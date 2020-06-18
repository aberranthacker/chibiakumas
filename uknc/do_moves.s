/*
  See EventStreamDirections for details of how DoMoves works
*/
DoMoves: .global DoMoves
        # SDYYYXXX
        # S - 'special move'
        # D - Doubler (speed up move)
        # YYY - Y movement bits
        # XXX - X movement bits
        # B =X, C =Y, D =Move
        # R4=X, R1=Y, R2 - LSB=Move, MSB=Sprite
        CLR  R4
        BISB R1,R4 # R4 = X
        CLRB R1
        SWAB R1    # R1 = Y

        BIT  $0x80,R2                                       #     bit 7,d         ; See if we are using a SPECIAL move pattern
        BNZ  DoMoves_Spec$                                  #     jr nz,DoMoves_Spec
                                                            # ;DoMovesStars
        # Y move ---------------------------------------------------------------
        MOV  R2,R0                                          #     ld a,D
        BIC  $0177707,R0                                    #     and %00111000
        ASR  R0                                             #     rrca
        ASR  R0                                             #     rrca
                                                            #
        SUB  $8,R0                                          #     sub 8
        BIT  $0x40,R2 # fast move?                          #     bit 6,d
        BZE  DoMoves_NoMultY$                               #     jp z,DoMoves_NoMult2
        ASL  R0                                             #          rlca
    DoMoves_NoMultY$:                                       #     DoMoves_NoMult2:
        ADD  R1,R0                                          #     add C
                                                            #
        CMP  R0,$199+24                                     #     cp 199+24       ;we are at the bottom of the screen
        BHIS DoMoves_Kill$                                  #     jr NC,DoMoves_Kill  ;over the page
        MOV  R0,R1                                          #     ld c,a
        # X move ---------------------------------------------------------------
        MOV  R2,R0                                          #     ld a,D
        BIC  $0177770,R0                                    #     and %00000111
        SUB  $4,R0                                          #     sub 4
        BIT  $0x40,R2 # fast move?                          #     bit 6,d
        BZE  DoMoves_NoMultX$                               #     jp z,DoMoves_NoMult
        ASL  R0                                             #          rlca
    DoMoves_NoMultX$:                                       #     DoMoves_NoMult:
        ADD  R4,R0                                          #     add b
                                                            #
        CMP  R0,$160+24                                     #     cp 160+24          ;we are at the bottom of the screen
        BHIS DoMoves_Kill$                                  #     jr NC,DoMoves_Kill ;over the page
        MOV  R0,R4                                          #     ld b,a
                                                            #
RETURN                                                      #     ret
    DoMoves_Kill$:                                          # DoMoves_Kill:          ; Object has gone offscreen
        CLR  R1                                             #     ld C,0
RETURN                                                      #     ret
                                                            # DoMoves_Background: ; Background sprites move much more slowly, and only in 1 direction
                                                            #     ld a,d
                                                            #     and %00001111
                                                            #     rla
                                                            #     ld e,a
                                                            #     ;----XXXX
                                                            #     ;XXXX tick point
                                                            #     ld a,(Timer_TicksOccured)
                                                            #     and e
                                                            #     ret z
                                                            #     ; time for a left move
                                                            #     dec b       :DoMovesBGShift_Plus1   ;check xpos
                                                            #     ld a,b
                                                            #     cp 160+24+24        ;we are offscreen
                                                            #     jr NC,DoMoves_Kill  ;over the page
                                                            #     ret
DoMoves_Spec$:                                              # DoMoves_Spec:   ;Special moves - various kinds
       .inform_and_hang "no DoMoves_Spec"                   #     ld a,(Timer_TicksOccured)
                                                            #     and %11111111           :SpecialMoveSlowdown_Plus1
                                                            #     ret z
                                                            #     ld a,d
                                                            #     and %11110000   ;
                                                            #     cp %11000000    ;1100XXXX ; Background
                                                            #     jr z,DoMoves_Background
                                                            #
                                                            #     cp %10100000    ;1010XXXX ; Wave
                                                            #     jr z,DoMoves_Wave ;Wave pattern - pretty naff, but it seemed a good idea at the time
                                                            #
                                                            #     ; Level specifics are overriden by the code in the level
                                                            #     cp %10110000    ;1011XXXX ; Level Specific 4
                                                            #     jp z,null   :LevelSpecificMoveD_Plus2
                                                            #     cp %11010000    ;1101XXXX ; Level Specific 3
                                                            #     jp z,null   :LevelSpecificMoveC_Plus2
                                                            #     cp %11100000    ;1110XXXX ; Level Specific 2
                                                            #     jp z,null   :LevelSpecificMoveB_Plus2
                                                            #     cp %11110000    ;1111XXXX ; Level Specific 1
        BNE  .+6
        JMP  @$null; LevelSpecificMove_Plus2:               #     jp z,null   :LevelSpecificMove_Plus2
       .equiv  dstLevelSpecificMove, LevelSpecificMove_Plus2 - 2
                                                            #
                                                            #     ld a,d        ;1000XXXX
                                                            #     and %11111100 ;101111XX
                                                            #     cp  %10010000               ; P2 Used by 'Chu attack' - and also coins!
                                                            #     jr z,DoMoves_Seekerp2           ; Used by 'Chu attack' - and also coins!
                                                            #     cp  %10000100
                                                            #     jr z,DoMoves_Seeker         ; Used by 'Chu attack' - and also coins!
                                                            #     cp  %10001000
                                                            #     jr z,DoMoves_SeekerAuto         ; Pick a live player to target!
                                                            #     ret
                                                            # DoMoves_Wave:
                                                            #     ;           3210
                                                            #     ; wave pattern  1010DSPP    D = Depth bit, S= Speed, PP Position
                                                            #
                                                            #     ld a,b
                                                            #     bit 3,d
                                                            #     jr nz,DoMoves_TwoShifts
                                                            #     srl a
                                                            #     srl a
                                                            # DoMoves_TwoShifts:
                                                            #     ;srl a  ; unrem for speedup
                                                            #     and %00011111
                                                            #     cp  %00010000
                                                            #     jr C,DoMoves_WaveContinue
                                                            #     xor %00011111
                                                            # DoMoves_WaveContinue:
                                                            #     bit 2,d
                                                            #     jr nz,DoMoves_WaveSlowSpeed
                                                            #     sll a
                                                            #
                                                            # DoMoves_WaveSlowSpeed
                                                            #     sll a
                                                            #     sll a ; rem to reduce wave depth
                                                            #
                                                            #     ld C,a
                                                            #     ld a,d
                                                            #     and %0000011
                                                            # DoMoves_WaveEnd
                                                            #     rrca
                                                            #     rrca
                                                            #     rrca  ; equivalent to 5 left shifts
                                                            #     or %00011100
                                                            #
                                                            #     add C
                                                            #     ld C,a
                                                            #
                                                            #     dec B
                                                            #     ld a,b
                                                            #     cp 24 ; we are at the bottom of the screen
                                                            #     jr C,DoMoves_Kill ; over the page
                                                            #     ret
                                                            #
                                                            # DoMoves_SeekerAuto:
                                                            #         push bc
                                                            #
                                                            #             ld c,%10010000  ;p2
                                                            #
                                                            #             ld a,(P1_P09)   ;See how many lives are left
                                                            #             or a
                                                            #             jr z,SeakChoosePlayerDone
                                                            #             ;if player 1 is dead, always home on player 2
                                                            #
                                                            #             ld a,(P2_P09)   ;See how many lives are left
                                                            #             or a
                                                            #             jr z,SeakChoosePlayerP1
                                                            #             ;if player 2 is dead, always home on player 1
                                                            #
                                                            #             ld a,0 :SeakChoosePlayer_Plus1
                                                            #             or a
                                                            #             cpl
                                                            #             ld (SeakChoosePlayer_Plus1-1),a
                                                            #
                                                            #             jr nz,SeakChoosePlayerDone
                                                            #
                                                            # SeakChoosePlayerP1:
                                                            #             ld c,%10000100; p1
                                                            # SeakChoosePlayerDone:
                                                            #
                                                            #             ld a,d
                                                            #             and %00000011
                                                            #             or c
                                                            #             ld d,a
                                                            #         pop bc
                                                            #
                                                            #         jp DoMoves_Spec
                                                            #
                                                            # DoMoves_Seekerp2:       ;Home in on player 2
                                                            #     push iy
                                                            #         ld iy,Player_Array2
                                                            #     jr DoMoves_SeekerContinue
                                                            # DoMoves_Seeker:         ;Home in on player 1
                                                            #
                                                            #     push iy
                                                            #         ld iy,Player_Array
                                                            #
                                                            # DoMoves_SeekerContinue:
                                                            #     push de
                                                            #     ld a,d
                                                            #     and %00000011 ; Speed
                                                            #     sll a
                                                            #     inc a
                                                            #     ld d,a
                                                            #     ld a,r        ; Crude randomizer, as we move so fast the object may never hit the player otherwise
                                                            #     bit 0,a
                                                            #     jr z,DoMoves_SeekerS
                                                            #     inc d
                                                            # DoMoves_SeekerS:
                                                            #         ; B=X C=Y D=Move speed
                                                            #         ld a,(iy) ; Y
                                                            #         sub 8
                                                            #         cp C
                                                            #         jr NC,DoMoves_Seeker_Ylower
                                                            #         ld a,C
                                                            #         sub d
                                                            #         jr DoMoves_Seeker_CheckX
                                                            #     DoMoves_Seeker_Ylower:
                                                            #         ld a,C
                                                            #         add d
                                                            #     DoMoves_Seeker_CheckX:
                                                            #         ld C,a
                                                            #         ld a,(iy+1) ;X
                                                            #         sub 3
                                                            #         cp B
                                                            #         jr NC,DoMoves_Seeker_Xlower
                                                            #         ld a,B
                                                            #         sub d
                                                            #         jr DoMoves_Seeker_Done
                                                            #     DoMoves_Seeker_Xlower:
                                                            #         ld a,B
                                                            #         add d
                                                            #     DoMoves_Seeker_Done:
                                                            #         ld B,a
                                                            #
                                                            #     pop de
                                                            #     pop iy
                                                            #
                                                            #     ret
