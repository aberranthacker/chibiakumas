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
        BIT  $mvSpecial,R2
        BNZ  DoMoves_Spec

      # Y move -----------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177707,R0
        ASR  R0
        ASR  R0
        SUB  $8,R0
        TSTB R2 # fast move? (bit 7)
        BPL  DoMoves_NoMultY

        ASL  R0
    DoMoves_NoMultY:
        ADD  R0,R1
        CMP  R1,$199+24    # we are at the bottom of the screen
        BHIS DoMoves_Kill  # over the page

      # X move -----------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177770,R0
        SUB  $4,R0
        TSTB R2 # fast move? (bit 7)
        BPL  DoMoves_NoMultX

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
        CMPB R0,$mveBackground # 1100xxxx Background
        BEQ  DoMoves_Background

        CMPB R0,$mveWave # 1010xxxx Wave
        BEQ  DoMoves_Wave # Wave pattern - pretty naff, but it seemed a good idea at the time

        # Level specifics are overriden by the code in the level
        CMPB R0,$mveCustom4 # 1011xxxx Custom4
        BNE  2$
       .equiv jmpLevelSpecificMoveD, .+2
        JMP  @$null
    2$:
        CMPB R0,$mveCustom3 # 1101xxxx Custom3
        BNE  3$
       .equiv jmpLevelSpecificMoveC, .+2
        JMP  @$null
    3$:
        CMPB R0,$mveCustom2 # 1110xxxx Custom2
        BNE  4$
       .equiv jmpLevelSpecificMoveB, .+2
        JMP  @$null
    4$:
        CMPB R0,$mveCustom1 # 1111xxxx Custom 1
        BNE  5$
       .equiv jmpLevelSpecificMoveA, .+2
        JMP  @$null
    5$:
        MOV  R2,R0          # 1000xxxx
        BICB $0b00000011,R0 # 101111xx

   .ifdef TwoPlayersGame
        CMPB R0,$mveSeaker_P2
        BEQ  DoMoves_SeekerP2   # Used by 'Chu attack' - and also coins!
   .endif
        CMPB R0,$mveSeaker_P1
        BEQ  DoMoves_SeekerP1   # Used by 'Chu attack' - and also coins!

        CMPB R0,$mveSeaker
        BEQ  DoMoves_SeekerAuto # Pick a live player to target!

        RETURN

      # R4=X, R1=Y, R2: LSB=move, MSB=anything
DoMoves_Wave:
      # wave pattern  1010DSPP D Depth bit, S Speed, PP Position
        MOV  R4,R1
        BIT  $0b1000,R2
        BNZ  DoMoves_Wave_TwoShifts
        ASR  R1
        ASR  R1
  DoMoves_Wave_TwoShifts:
       #ASR  R1 # unrem for speedup
        BIC  $0xFFE0,R1
        CMP  R1,$0x10
        BLO  DoMoves_Wave_Continue

        MOV  $0x001F,R0
        XOR  R0,R1
  DoMoves_Wave_Continue:
        BIT  $0b100,R2
        BNZ  DoMoves_Wave_SlowSpeed

        ASLB R1
  DoMoves_Wave_SlowSpeed:
        ASLB R1
        ASLB R1 # rem to reduce wave depth
        MOV  R2,R0
        BIC  $0xFFFC,R0
        ASH  $5,R0
        BIS  $0b00011100,R0
        ADD  R0,R1
        DEC  R4
        CMP  R4,$24       # we are at the bottom of the screen
        BLO  DoMoves_Kill # over the page

        RETURN

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
        PUSH R3
        MOV  R2,R3
        BIC  $0xFFFC,R3 # 0b00000011 Speed
        ASL  R3
        INC  R3
      # Use randomizer, as we move so fast the object may never hit the player
      # otherwise
        CALL TRandW
        ROR  R0
        ADC  R3

        MOVB @$P1_P00,R0 # Y
        SUB  $8,R0
        CMPB R0,R1
        BHIS DoMoves_Seeker_Ylower

        SUB  R3,R1
        BR   DoMoves_Seeker_CheckX
DoMoves_Seeker_Ylower:
        ADD  R3,R1

DoMoves_Seeker_CheckX:
        MOVB  @$P1_P01,R0 # X
        SUB   $3,R0
        CMPB  R0,R4
        BHIS  DoMoves_Seeker_Xlower

        SUB  R3,R4
        BR   DoMoves_Seeker_Done

DoMoves_Seeker_Xlower:
        ADD  R3,R4
DoMoves_Seeker_Done:
        POP  R3
        RETURN
