/*
  See EventStreamDirections for details of how DoMoves works
*/
DoMoves:
        # SDYYYXXX
        # S - 'special move'
        # D - Doubler (speed up move)
        # YYY - Y movement bits
        # XXX - X movement bits
        # B =X, C =Y, D =Move
        #
        # in:  R1 LSB=X MSB=Y
        #      R2 LSB=Move, MSB=anything
        #
        # out: R1 new Y
        #      R2 unmodified
        #      R3 unmodified
        #      R4 new X
        #      R5 unmodified
        CLR  R4
        BISB R1,R4 # R4 = X
        CLRB R1
        SWAB R1    # R1 = Y

        # Check if we are using a SPECIAL move pattern
        BIT  $0x80,R2
        BNZ  DoMoves_Spec

        # Y move ---------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177707,R0
        ASR  R0
        ASR  R0
        SUB  $8,R0
        BIT  $0x40,R2 # fast move?
        BZE  DoMoves_NoMultY

        ASL  R0
    DoMoves_NoMultY:
        ADD  R1,R0
        CMP  R0,$199+24    # we are at the bottom of the screen
        BHIS DoMoves_Kill  # over the page

        MOV  R0,R1
        # X move ---------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177770,R0
        SUB  $4,R0
        BIT  $0x40,R2 # fast move?
        BZE  DoMoves_NoMultX

        ASL  R0
    DoMoves_NoMultX:
        ADD  R4,R0
        CMP  R0,$160+24   # we are at the bottom of the screen
        BHIS DoMoves_Kill # over the page

        MOV  R0,R4

        RETURN

    DoMoves_Kill: # Object has gone offscreen
        CLR  R1
        RETURN

DoMoves_Background: # Background sprites move much more slowly, and only in 1 direction
        MOV  R2,R0
        BIC  $0xFFF0,R0 # ----XXXX tick point
        ASL  R0
        BITB R0,@$srcTimer_TicksOccured
        BNZ  1$
        RETURN

    1$: # it's time for a left move
       .equiv opcDoMovesBGShift, . # check Xpos
        DEC  R4 # X
        CMP  R4, $24+160+24 # we are offscreen
        BHIS DoMoves_Kill # over the page
        RETURN

DoMoves_Spec: # Special moves - various kinds
       .equiv srcSpecialMoveSlowdown, .+2
        BITB $0xFF,@$srcTimer_TicksOccured
        BNZ  1$
        RETURN

    1$: # R2 - LSB=Move, MSB=Sprite
        MOV  R2,R0
        BICB $0b00001111,R0
        CMPB R0,$0b11000000 # 1100xxxx Background
        BEQ  DoMoves_Background

        CMPB R0,$0b10100000 # 1010xxxx Wave
        BEQ  DoMoves_Wave # Wave pattern - pretty naff, but it seemed a good idea at the time

        # Level specifics are overriden by the code in the level
        CMPB R0,$0b10110000 # 1011xxxx Custom4
        BNE  2$
       .equiv jmpLevelSpecificMoveD, .+2
        JMP  @$null

    2$: CMPB R0,$0b11010000 # 1101xxxx Custom3
        BNE  3$
       .equiv jmpLevelSpecificMoveC, .+2
        JMP  @$null

    3$: CMPB R0,$0b11100000 # 1110xxxx Custom2
        BNE  4$
       .equiv jmpLevelSpecificMoveB, .+2
        JMP  @$null

    4$: CMPB R0,$0b11110000 # 1111xxxx Custom 1
        BNE  5$
       .equiv jmpLevelSpecificMoveA, .+2
        JMP  @$null

    5$: MOV  R2,R0          # 1000xxxx
        BICB $0b00000011,R0 # 101111xx
        CMPB R0,$0b10010000
        BEQ  DoMoves_SeekerP2   # Used by 'Chu attack' - and also coins!

        CMPB R0,$0b10000100
        BEQ  DoMoves_SeekerP1   # Used by 'Chu attack' - and also coins!

        CMPB R0,$0b10001000
        BEQ  DoMoves_SeekerAuto # Pick a live player to target!

        RETURN

DoMoves_Wave:
        .inform_and_hang "no DoMoves_Wave"
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
DoMoves_SeekerAuto:
         .inform_and_hang "no DoMoves_SeekerAuto"
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
DoMoves_SeekerP2: # Home in on player 2
         .inform_and_hang "no DoMoves_SeekerP2"
                                                            #     push iy
                                                            #         ld iy,Player_Array2
                                                            #     jr DoMoves_SeekerContinue
DoMoves_SeekerP1: # Home in on player 1
         .inform_and_hang "no DoMoves_SeekerP1"
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
