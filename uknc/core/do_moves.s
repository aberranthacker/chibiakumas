/*
  See EventStreamDirections for details of how DoMoves works
*/
DoMoves:
        # SDYYYXXX
        # S - 'special move'
        # D - Doubler (speed up move)
        # YYY - Y movement bits
        # XXX - X movement bits
        # B=X, C=Y, D=Move
        #
        # in:  R1 LSB b = X, R1 MSB c = Y
        #      R2 LSB d = Move, R2 MSB=anything
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
        ADD  R0,R1
        CMP  R1,$199+24    # we are at the bottom of the screen
        BHIS DoMoves_Kill  # over the page

        # X move ---------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177770,R0
        SUB  $4,R0
        BIT  $0x40,R2 # fast move?
        BZE  DoMoves_NoMultX

        ASL  R0
    DoMoves_NoMultX:
        ADD  R0,R4
        CMP  R4,$160+24   # we are at the bottom of the screen
        BHIS DoMoves_Kill # over the page

        RETURN

    DoMoves_Kill: # Object has gone offscreen
        CLR  R1
        RETURN

DoMoves_Background: # Background sprites move much more slowly, and only in 1 direction
        MOV  R2,R0
        BIC  $0xFFF0,R0 # ----XXXX tick point
        ASL  R0
        BITB R0,@$Timer_TicksOccured
        BNZ  1$
        RETURN

    1$: # it's time for a left move
       .equiv opcDoMovesBGShift, . # check Xpos
        DEC  R4 # X
        CMP  R4, $24+ 160+24 # we are offscreen
        BHIS DoMoves_Kill # over the page
        RETURN

DoMoves_Spec: # Special moves - various kinds
       .equiv SpecialMoveSlowdown, .+2
        BITB $0xFF,@$Timer_TicksOccured
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
    2$: 
        CMPB R0,$0b11010000 # 1101xxxx Custom3
        BNE  3$
       .equiv jmpLevelSpecificMoveC, .+2
        JMP  @$null
    3$: 
        CMPB R0,$0b11100000 # 1110xxxx Custom2
        BNE  4$
       .equiv jmpLevelSpecificMoveB, .+2
        JMP  @$null
    4$: 
        CMPB R0,$0b11110000 # 1111xxxx Custom 1
        BNE  5$
       .equiv jmpLevelSpecificMoveA, .+2
        JMP  @$null
    5$: 
        MOV  R2,R0          # 1000xxxx
        BICB $0b00000011,R0 # 101111xx
        # TODO: uncomment for player 2
       #CMPB R0,$0b10010000
       #BEQ  DoMoves_SeekerP2   # Used by 'Chu attack' - and also coins!

        CMPB R0,$0b10000100
        BEQ  DoMoves_SeekerP1   # Used by 'Chu attack' - and also coins!

        CMPB R0,$0b10001000
        BEQ  DoMoves_SeekerAuto # Pick a live player to target!

        RETURN

        # R4=X, R1=Y, R2: LSB=move, MSB=anything
DoMoves_Wave:
        # wave pattern  1010DSPP D Depth bit, S Speed, PP Position
        MOV  R4,R1                  #     ld a,b
        BIT  $0b1000,R2             #     bit 3,d
        BNZ  DoMoves_Wave_TwoShifts #     jr nz,DoMoves_TwoShifts
        ASLB R1                     #     srl a
        ASLB R1                     #     srl a
DoMoves_Wave_TwoShifts:
                                    #     ;srl a  ; unrem for speedup
        BIC  $0xFFE0,R1             #     and %00011111
        CMP  R1,$0x10               #     cp  %00010000
        BLO  DoMoves_Wave_Continue  #     jr C,DoMoves_WaveContinue

        MOV  $0x1F,R0
        XOR  R0,R1                  #     xor %00011111
DoMoves_Wave_Continue:              # DoMoves_WaveContinue:
        BIT  $0b100,R2              #     bit 2,d
        BNZ  DoMoves_Wave_SlowSpeed #     jr nz,DoMoves_WaveSlowSpeed

        ASLB R1                     #     sll a
                                    #
DoMoves_Wave_SlowSpeed:             # DoMoves_WaveSlowSpeed
        ASLB R1                     #     sll a
                                    #     sll a ; rem to reduce wave depth
                                    #
                                    #     ld C,a
        MOV  R2,R0                  #     ld a,d
        BIC  $0xFFFC,R0             #     and %00000011
        ASH  $5,R0                  #     rrca
                                    #     rrca
                                    #     rrca
                                    #     rrca  ; equivalent to 5 left shifts
        BIS  $0b00011100,R0         #     or %00011100
                                    #
        ADD  R0,R1                  #     add C
                                    #     ld C,a
                                    #
        DEC  R4                     #     dec B
                                    #     ld a,b
        CMP  R4,$24                 #     cp 24 ; we are at the bottom of the screen
        BLO  DoMoves_Kill           #     jr C,DoMoves_Kill ; over the page
        RETURN                      #     ret

DoMoves_SeekerAuto:
                                        # push bc
                                        #
                                        # ld c,%10010000  ;p2
                                        #
                                        # ld a,(P1_P09)   ;See how many lives are left
                                        # or a
                                        # jr z,SeakChoosePlayerDone
                                        # ;if player 1 is dead, always home on player 2
                                        #
                                        # ld a,(P2_P09)   ;See how many lives are left
                                        # or a
                                        # jr z,SeakChoosePlayerP1
                                        # ;if player 2 is dead, always home on player 1
                                        #
                                        # ld a,0 :SeakChoosePlayer_Plus1
                                        # or a
                                        # cpl
                                        # ld (SeakChoosePlayer_Plus1-1),a
                                        #
                                        # jr nz,SeakChoosePlayerDone
                                        #
# SeakChoosePlayerP1:
                                        # ld c,%10000100; p1
# SeakChoosePlayerDone:
                                        # ld a,d
                                        # and %00000011
                                        # or c
                                        # ld d,a
                                        # pop bc
                                        #
                                        # jp DoMoves_Spec

#DoMoves_SeekerP2: # Home in on player 2
#                                       # push iy
#                                       #     ld iy,Player_Array2
#        BR   DoMoves_Seeker            # jr DoMoves_Seeker
DoMoves_SeekerP1: # Home in on player 1
                                        # push iy
                                        #     ld iy,Player_Array
DoMoves_Seeker:
        # R1 c = Y, R4 b = X
        # R2 LSB d = Move, R2 MSB=anything
        PUSH R3                     # push de
        MOV  R2,R3                  # ld a,d
        BIC  $0xFFFC,R3             # and %00000011 ; Speed
        ASL  R3                     # sll a
        INC  R3                     # inc a
                                    # ld d,a
                                    # ld a,r ; Crude randomizer, as we move so fast the object may never hit the player otherwise
                                    # bit 0,a
                                    # jr z,DoMoves_SeekerS
        INC  R3                     # inc d
DoMoves_SeekerS:
        MOVB @$P1_P00,R0            # ld a,(iy) ; Y
        SUB  $8,R0                  # sub 8
        CMPB R0,R1                  # cp C
        BHIS DoMoves_Seeker_Ylower  # jr NC,DoMoves_Seeker_Ylower
                                    # ld a,C
        SUB  R3,R1                  # sub d
        BR   DoMoves_Seeker_CheckX  # jr DoMoves_Seeker_CheckX
DoMoves_Seeker_Ylower:
                                    # ld a,C
        ADD  R3,R1                  # add d
DoMoves_Seeker_CheckX:
                                    # ld C,a
        MOVB  @$P1_P01,R0           # ld a,(iy+1) ;X
        SUB   $3,R0                 # sub 3
        CMPB  R0,R4                 # cp B
        BHIS  DoMoves_Seeker_Xlower # jr NC,DoMoves_Seeker_Xlower
                                    # ld a,B
        SUB  R3,R4                  # sub d
        BR   DoMoves_Seeker_Done    # jr DoMoves_Seeker_Done
DoMoves_Seeker_Xlower:
                                    # ld a,B
        ADD  R3,R4                  # add d
DoMoves_Seeker_Done:
                                    # ld B,a
        POP  R3                     # pop de
                                    # pop iy
        RETURN                      # ret
