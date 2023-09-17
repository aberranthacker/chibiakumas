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
        BITB $mvSpecial,R2
        BNZ  DoMoves.SpecialMove # special move? (bit 6)

      # Y move -----------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177707,R0
        ASR  R0
        ASR  R0
        SUB  $8,R0
        TSTB R2 # fast move?
        BPL  DoMoves_NoMultY

        ASL  R0
    DoMoves_NoMultY:
        ADD  R0,R1
        CMP  R1,$199+24    # we are at the bottom of the screen
        BHIS DoMoves.Kill  # over the page

      # X move -----------------------------------------------------------------
        MOV  R2,R0
        BIC  $0177770,R0
        SUB  $4,R0
        TSTB R2 # fast move?
        BPL  DoMoves_NoMultX

        ASL  R0
    DoMoves_NoMultX:
        ADD  R0,R4
        CMP  R4,$160+24   # we are outside of the screen
        BHIS DoMoves.Kill # over the page

        RETURN

    DoMoves.Kill: # Object has gone offscreen
        CLR  R1
        RETURN

DoMoves.SpecialMove: # Special moves - various kinds
       .equiv SpecialMoveSlowdown, .+2
        BITB $0xFF,@$Timer.TicksOccured
        BZE  1237$

      # R2 - LSB=Move, MSB=Sprite
        MOV  R2,R0
        BIC  $0xFF4F,R0
        BZE  DoMoves.Background
        ASR  R0
        ASR  R0
        ASR  R0
        JMP  @DoMoves.SpecialMove_Vectors-2(R0)
DoMoves.SpecialMove_Vectors:
       .word DoMoves.Wave
    LevelSpecificMoveA: .word null
    LevelSpecificMoveB: .word null
       .word null
       .word null
       .word null
       .word null
    LevelSpecificMoveC: .word null
       .word DoMoves.SeekerAuto
       .word DoMoves.SeekerP1
   .ifdef TwoPlayersGame
       .word DoMoves.SeekerP2
   .endif

1237$:  RETURN

DoMoves.Background: # Background sprites move much more slowly, and only in 1 direction
        MOV  R2,R0
        BIC  $0xFFF0,R0 # ----XXXX tick point
        ASL  R0
        BITB R0,@$Timer.TicksOccured
        BZE  1237$

      # it's time for a left move
       .equiv opcDoMovesBGShift, . # check Xpos
        DEC  R4 # X
        CMP  R4, $24+ 160+24 # we are offscreen
        BHIS DoMoves.Kill # over the page
1237$:  RETURN

      # R4=B=X, R1=C=Y, R2: LSB=D=move, MSB=anything
DoMoves.Wave:
      # wave pattern  1010DSPP D Depth bit, S Speed, PP Position
        MOV  R4,R1
        BIT  $0b1000,R2
        BNZ  DoMoves.Wave_TwoShifts
        ASR  R1
        ASR  R1
  DoMoves.Wave_TwoShifts:
       #ASR  R1 # unrem for speedup
        BIC  $0xFFE0,R1
        CMP  R1,$0x10
        BLO  DoMoves.Wave_Continue

        MOV  $0x001F,R0
        XOR  R0,R1
  DoMoves.Wave_Continue:
        BIT  $0b100,R2
        BNZ  DoMoves.Wave_SlowSpeed

        ASLB R1
  DoMoves.Wave_SlowSpeed:
        ASLB R1
        ASLB R1 # rem to reduce wave depth
        MOV  R2,R0
        BIC  $0xFFFC,R0
# DoMoves.Wave_End
        ASH  $5,R0
        BIS  $0b00011100,R0
        ADD  R0,R1

        DEC  R4
        CMP  R4,$24       # we are at the bottom of the screen
        BLO  DoMoves.Kill # over the page

        RETURN

DoMoves.SeekerAuto:
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
DoMoves.SeekerP1: # Home in on player 1
                                        # push iy
                                        #     ld iy,Player_Array
DoMoves.Seeker:
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
        BHIS DoMoves.Seeker_Ylower

        SUB  R3,R1
        BR   DoMoves.Seeker_CheckX
DoMoves.Seeker_Ylower:
        ADD  R3,R1

DoMoves.Seeker_CheckX:
        MOVB  @$P1_P01,R0 # X
        SUB   $3,R0
        CMPB  R0,R4
        BHIS  DoMoves.Seeker_Xlower

        SUB  R3,R4
        BR   DoMoves.Seeker_Done

DoMoves.Seeker_Xlower:
        ADD  R3,R4
DoMoves.Seeker_Done:
        POP  R3
        RETURN
