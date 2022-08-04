#******************************************************************************#
#                                  Star Array                                  #
#******************************************************************************#
Player_StarArray_Redraw:
       .equiv PlayerBulletColor, 0x0003
       .equiv PlayerStarColor0, .+2
        MOV  $PlayerBulletColor,   @$StarColor0
       .equiv PlayerStarColor1, .+2
        MOV  $PlayerBulletColor<<2,@$StarColor1
        MOV  $PlayerBulletColor<<4,@$StarColor2
        MOV  $PlayerBulletColor<<6,@$StarColor3
      # configure the loop for the player star array
        MOV  $null,@$dstCurrentStarArrayCollisionsB2
   .ifdef TwoPlayersGame
        MOV  $null,@$dstCurrentStarArrayCollisions2B2
   .endif

        MOV  $PlayerStarArraySize,R1
        MOV  $PlayerStarArrayPointer,R5
        BR   Starloop_Start

StarArray_Redraw:
        TST  @$Timer_TicksOccured
        BNZ  1$ # see if game is not paused (TicksOccurred != 0 )
        RETURN
    1$:
      # Redraw the enemy star array
        MOV  $StarArraySize,R1
       .equiv EnemyBulletColor, 0x0303
        MOV  $EnemyBulletColor,   @$StarColor0
        MOV  $EnemyBulletColor<<2,@$StarColor1
        MOV  $EnemyBulletColor<<4,@$StarColor2
        MOV  $EnemyBulletColor<<6,@$StarColor3

      #;;;;;;;;;;;;;;;;;;;;; Player 1 handler
      # configure the loop for the enemy star array
      # TODO: implement Player_Hit_Injure_1
        MOV  $Player_Hit_Injure_1,R5
        TSTB @$P1_P07
        BZE  StarArray_PlayerVulnerable

        MOV  $null,R5 # player invincible

    StarArray_PlayerVulnerable:
      # load player 1 location - do it in advance to save time during the loop
        MOVB @$P1_P01,R0
        DECB R0 # SUB  $2,R0
        DECB R0
        MOVB R0,@$Player1LocX
        ADD  $4,R0
        MOVB R0,@$Player1LocXB

        MOVB @$P1_P00,R0
        DECB R0 # SUB  $2,R0
        DECB R0
        MOVB R0,@$Player1LocY
        ADD  $4,R0
        MOVB R0,@$Player1LocYB

        MOV  R5,@$dstCurrentStarArrayCollisionsB2

        # Player 2 handler --------------------------------------------------{{{
   .ifdef TwoPlayersGame
      # configure the loop for the enemy star array
        MOV  $Player_Hit_Injure_2,R5
        TSTB @$P2_P07
        BZE  StarArray_Player2Vulnerable

        MOV  $null,R5 # player invincible

    StarArray_Player2Vulnerable:
        # load player 2 location - do it in advance to save time during the loop
        MOVB @$P2_P01,R0
        DECB R0 # SUB  $2,R0
        DECB R0
        MOV  R0,@$Player2LocX
        ADD  $4,R0
        MOV  R0,@$Player2LocXB

        MOVB @$P1_P00,R0
        DECB R0 # SUB  $2,R0
        DECB R0
        MOV  R0,@$Player2LocY
        ADD  $4,R0
        MOVB R0,@$Player2LocYB

        MOV  R5,@$dstCurrentStarArrayCollisions2B2
   .endif
        #--------------------------------------------------------------------}}}

        MOV  $StarArrayPointer,R5

       .equiv opcStarSlowdown, .+2
        MOV  $0006200,R3 # ASR  R0
       .equiv SlowdownFreq, .+2
        BIT  $0b10,@$Timer_TicksOccured
        BZE  Starloop_Start2

Starloop_Start:
       .equiv PlayerFireSpeed, .+2
        MOV  $0000240,R3

Starloop_Start2:
        MOV  R3,@$opcStarSlowdownB
        MOV  R3,@$opcStarSlowdownA
      # Reset the star array to allow more stars to be added
        CLR  @$StarArrayFullMarker

Starloop:
        CLR  R2
        BISB (R5)+,R2 # Y
        BNZ  StarArray_FoundOne # Y=0 means a dead object in the array
        INC  R5
    StarArray_Loop_AfterKill:
        INC  R5
        SOB  R1,Starloop
        RETURN

    StarArray_Loop_AfterDraw:
        ADD  $3,R5
        SOB  R1,Starloop
        RETURN
#-------------------------------------------------------------------------------
DoMovesStars_Kill:
        CLRB -2(R5)
        BR   StarArray_Loop_AfterKill

StarArray_FoundOne:
        CLR  R3
        BISB (R5)+,R3 # X
        MOVB (R5),R4  # Move

      # DoMovesStars moves for stars
      # C=R2=Y; B=R3=X; D=R4=Move
        MOV  R4,R0
        BIC  $0177707,R0 # 0b11000111
        ASR  R0
        ASR  R0
        SUB  $8,R0
        BIT  $spdFast,R4
        BZE  DoMovesStars_spdNormalY
        ASL  R0
    DoMovesStars_spdNormalY:
       .equiv opcStarSlowdownA, .
        ASR  R0
        ADD  R0,R2

        CMP  R2,$24+ 199
        BHIS DoMovesStars_Kill
        CMP  R2,$24
        BLO  DoMovesStars_Kill

        MOV  R4,R0
        BIC  $0177770,R0 # 0b11111000
        SUB  $4,R0
        BIT  $spdFast,R4
        BZE  DoMovesStars_spdNormalX

        ASL  R0
    DoMovesStars_spdNormalX:
       .equiv opcStarSlowdownB, .
        ASR  R0
        ADD  R0,R3

        MOV  $24,R4 # we will use the value 3 times below

        CMP  R3,$24+ 160
        BHIS DoMovesStars_Kill
        CMP  R3,R4 # R4=24
        BLO  DoMovesStars_Kill

      # check for collisions with player 1
       .equiv Player1LocX, .+2
        CMP  R3,$30
        BLO  StarLoopP1Skip
       .equiv Player1LocXB, .+2
        CMP  R3,$34
        BHIS StarLoopP1Skip
       .equiv Player1LocY, .+2
        CMP  R2,$98
        BLO  StarLoopP1Skip
       .equiv Player1LocYB, .+2
        CMP  R2,$102
        BHIS StarLoopP1Skip

       .equiv dstCurrentStarArrayCollisionsB2, .+2
        CALL @$null # or Player_Hit_Injure_1

StarLoopP1Skip:
        # check for collisions with player 2 (commented out) ----------------{{{
      #.equiv Player2LocX, .+2
      # CMP  R3,$30
      # BLO  StarCollisionsDone
      #.equiv Player2LocXB, .+2
      # CMP  R3,$34
      # BHIS StarCollisionsDone
      #.equiv Player2LocY, .+2
      # CMP  R2,$148
      # BLO  StarCollisionsDone
      #.equiv Player2LocYB, .+2
      # CMP  R2,$152
      # BHIS StarCollisionsDone

      #.equiv dstCurrentStarArrayCollisions2B2, .+2
      # CALL @$null # or Player_Hit_Injure_2
        #--------------------------------------------------------------------}}}

StarCollisionsDone:
        MOVB R3,-(R5) # X
        MOVB R2,-(R5) # Y

        SUB  R4,R3 # R4=24
        SUB  R4,R2 # R4=24

      # calculating screen memory address
        MOV  R3,R4
        ASR  R3    # X: calculate word offset
   .ifdef DebugMode
        PUSH R3
        MUL  $80,R2
        ADD  $384,R3
        ADD  (SP)+,R3
   .else
        ASL  R2
        ADD  scr_addr_table(R2),R3 # Y: add line offset from the table
   .endif
       .equiv StarArray_ActiveScreenBit14, .+2
        BIS  $0x4000,R3

        BIC  $0xFFFC,R4 # 0b11111100
        BZE  DotOffset0
        DEC  R4
        BZE  DotOffset1
        DEC  R4
        BZE  DotOffset2
DotOffset3:
        MOV  $0xC0C0,R2
       .equiv StarColor3, .+2
        MOV  $0xC0C0,R4
        BIC  R2,(R3)
        BIS  R4,(R3)
        ADD  $80,R3
        BIC  R2,(R3)
        BIS  R4,(R3)
        BR   StarArray_Loop_AfterDraw
DotOffset2:
        MOV  $0x3030,R2
       .equiv StarColor2, .+2
        MOV  $0x3030,R4
        BIC  R2,(R3)
        BIS  R4,(R3)
        ADD  $80,R3
        BIC  R2,(R3)
        BIS  R4,(R3)
        BR   StarArray_Loop_AfterDraw
DotOffset1:
        MOV  $0x0C0C,R2
       .equiv StarColor1, .+2
        MOV  $0x0C0C,R4
        BIC  R2,(R3)
        BIS  R4,(R3)
        ADD  $80,R3
        BIC  R2,(R3)
        BIS  R4,(R3)
        BR   StarArray_Loop_AfterDraw
DotOffset0:
        MOV  $0x0303,R2
       .equiv StarColor0, .+2
        MOV  $0x0303,R4
        BIC  R2,(R3)
        BIS  R4,(R3)
        ADD  $80,R3
        BIC  R2,(R3)
        BIS  R4,(R3)
        BR   StarArray_Loop_AfterDraw
