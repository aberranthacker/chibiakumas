################################################################################
#                               Object Driver                                  #
################################################################################
#
# We walk up 00XXXXXX then back down 01XXXXXX - this means the system needs half
# of 256*4, and has an upper limit of 64 items!
# YYYYYXXXXMMMMSSS LLLLPPPRRRAAAA
#
# Y = object Y       (1)
# X = object X       (2)
# M = object Move    (3)
# S = Object Sprite  (4)
# L = Object Life    (5)
# P = Object Program (6)
# R = Resolution     (7) bytes #XXXX1111
# A = Animator       (8)

# ObjectArray_ConfigureForSize ----------------------------------------------{{{
ObjectArray_reConfigureForSize:
        TSTB R4
        BNZ  ObjectArray_ConfigureForSizeB
        RETURN

ObjectArray_ConfigureForSizeB:
        CLR  R0
        BISB R4, R0
        MOV  R0, @$ObjectSpriteSizeCurrent
        MOV  R0, @$SpriteSizeShiftFull
   .ifdef TwoPlayersGame
        MOV  R0, @$SpriteSizeShiftFullB
   .endif
        MOV  R0, @$SpriteSizeShiftFullC
        ASR  R0
        MOV  R0, @$SpriteSizeShiftHalfB
   .ifdef TwoPlayersGame
        MOV  R0, @$SpriteSizeShiftHalfD
   .endif
        BIS  $0b00000011, R0
        MOV  R0, @$SpriteSizeShiftHalfH

      # Define player 1 and 2 hitboxes
ObjectArray_ConfigureForSize:
      # We update player location in advance for fast collision detection
      # Define player 1's hitbox
        CLR  R0
        BISB @$P1_P00, R0 # PlayerY
        MOV  R0, @$PlayerY2
       .equiv SpriteSizeShiftFull, .+2
        SUB  $24, R0
        BHIS 1$

        CLR  R0
    1$:
        MOV  R0, @$PlayerY1
        CLR  R0
        BISB @$P1_P01, R0 # PlayerX
        MOV  R0, @$PlayerX2
       .equiv SpriteSizeShiftHalfB, .+2
        SUB  $12, R0
        BHIS 2$

        CLR  R0
    2$:
        MOV  R0, @$PlayerX1

   .ifdef TwoPlayersGame # {{{
      # Define player 2's hitbox
        CLR  R0
        BISB @$P2_P00,R0 # PlayerY
        MOV  R0,@$Player2Y2
       .equiv SpriteSizeShiftFullB, .+2
        SUB  $24,R0
        BHIS 3$

        CLR  R0
    3$: MOV  R0,@$Player2Y1
        CLR  R0
        BISB @$P1_P01,R0 # PlayerX
        MOV  R0,@$Player2X2
       .equiv SpriteSizeShiftHalfD, .+2
        SUB  $12,R0
        BHIS 4$

        CLR  R0
    4$: MOV  R0,@$Player2X1
   .endif # }}}

        RETURN
# ObjectArray_ConfigureForSize ----------------------------------------------}}}
ObjectArray_Redraw:
        TST  @$Timer.TicksOccured # see if game is paused (TicksOccurred = 0)
        BZE  game_paused
      # Define player 1 and 2 hitboxes
        CALL @$ObjectArray_ConfigureForSize

        MOV  $ObjectArraySize,R4
        MOV  $ObjectArrayPointer,R5

    object_loop:
        MOV  (R5)+,R1 # object Y=LSB, X=MSB
        TSTB R1       # if object Y=0 the object is dead
        BNZ  object_present

ObjectArray_NextObject:
        ADD  $6,R5
        SOB  R4,object_loop

    game_paused:
        RETURN

    object_present:
        PUSH R4
        PUSH R5

        MOVB R1,@$SprShow_Y
        SWAB R1       # R1 LSB b = X, R1 MSB c = Y
        MOVB R1,@$SprShow_X
        MOV  (R5)+,R2 # R2 LSB ixh = Move, R2 MSB iyh = Sprite
        MOV  (R5)+,R3 # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        MOV  (R5),R4  # R4 LSB = Sprite Size, R4 MSB = Animator

       .equiv ObjectSpriteSizeCurrent, .+2
        CMPB $0x00,R4
        BEQ  1$
        CALL ObjectArray_reConfigureForSize # Code to change sprite size!
    1$:
        SWAB R4 # R4 LSB = Animator, R4 MSB = Sprite size
        TSTB R4
        BZE  2$
        CALL ObjectAnimator
   2$:
        SWAB R2 # R2 LSB iyh = Sprite, R2 MSB ixh = Move
        MOV  R2,R0
        BIC  $0xFFC0,R0
        MOV  R0,@$SprShow_SprNum

        BIT  $0xC0,R2
        BZE  Objectloop_OneFrameSprite

        MOV  @$Timer.CurrentTick,R0
        BIT  $0x40,R2
        BZE  Objectloop_TwoFrameSprite

      # it's a FourFrameSprite if we got here
        BIC  $0177774,R0 # ------XX
        BR   Objectloop_SpriteBankSet

Objectloop_OneFrameSprite:
        CLR  R0
        BR   Objectloop_SpriteBankSet

Objectloop_TwoFrameSprite:
        COM  R0
        BIC  $0177775,R0 # ------X-

Objectloop_SpriteBankSet:
      # R1 LSB b = X, R1 MSB c = Y
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
      # R4 LSB = Animator, R4 MSB = Sprite size
        ASL  R0
        MOV  SpriteBanksVectors(R0), @$SprShow_BankAddr

      # Life BPxxxxxx
      # B=hurt by bullets,
      # P=hurts player,
      # xxxxxx = hit points (if not B then ages over time)
        BIT  $0x40, R3 # R3 Life=LSB, Program=MSB
        BZE  ObjectLoopBothPlayerSkip # Doesn't hurt player

# used to modify this, but now we assume the player is alway vunurable
# we check anyway before deducting a life
# Objectloop_PlayerVunrable:
#  Player collisions --------------------------------------------------------{{{
      # R0 use at will
      # R1 LSB b = X, R1 MSB c = Y
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
      # R4 use at will
      # R5 ObjectArray current object last element pointer
        MOV  R1, R0
       .equiv PlayerX1, .+2
        CMPB R0, $20
        BLO  ObjectLoopP1Skip

       .equiv PlayerX2, .+2
        CMPB R0, $32
        BHIS ObjectLoopP1Skip

        SWAB R0
       .equiv PlayerY1, .+2
        CMPB R0, $76
        BLO  ObjectLoopP1Skip

       .equiv PlayerY2, .+2
        CMPB R0, $100
        BHIS ObjectLoopP1Skip

        TSTB @$P1_P09
        BZE  ObjectLoopP1Skip

        PUSH R5
        MOV  $Player_Array, R5
        CALL Player_Hit
        POP  R5

        TST  R1
        BZE  ObjectLoop_SaveChanges

ObjectLoopP1Skip:
       # uncomment for player 2                             # ;assume we're playing 1 player!
       #                                                    # ;so check if we have a player 2.
       #                                                    # ld a,(P2_P09)
       #                                                    # or a
       #                                                    # jr z,ObjectLoopP2Skip
       #                                                    #
       #                                                    # ld a,b
       #CMPB (PC)+,R0; Player2X1: .word 0                   # cp 0 :Player2X1_Plus1
       #                                                    # jr c,ObjectLoopP2Skip
       #CMPB (PC)+,R0; Player2X2: .word 0                   # cp 0 :Player2X2_Plus1
       #                                                    # jr nc,ObjectLoopP2Skip
       #                                                    #
       #                                                    # ld a,c
       #CMPB (PC)+,R0; Player2Y1: .word 0                   # cp 0 :Player2Y1_Plus1
       #                                                    # jr c,ObjectLoopP2Skip
       #CMPB (PC)+,R0; Player2Y2: .word 0                   # cp 0 :Player2Y2_Plus1
       #                                                    # jr nc,ObjectLoopP2Skip
       #                                                    #
       #                                                    # push hl
       #                                                    #    ld hl,Player_Array2
       #                                                    #    call Player_Hit
       #                                                    # pop hl
       #                                                    #
       #                                                    # ld a,b
       #                                                    # or a
       #                                                    # ; check if we killed object
       #                                                    # jr z,ObjectLoop_SaveChanges
       #                                                    #
       #                                                    # ObjectLoopP2Skip:
ObjectLoopBothPlayerSkip:                                   # ObjectLoopBothPlayerSkip:
      # when the object is dead, there is no point checking if its shot
      # Life BPxxxxx B=hurt by bullets, P=hurts player,
      #        xxxxx = hit points (if not B then ages over time)
        TSTB R3
        BZE  ObjectLoop_NotShot # immortal object (background)

        TSTB R3
        BMI  ObjectLoop_AgelessIXLCheck # If it can be shot, it doesn't auto age

        BIT  $0b00001000,@$Timer.TicksOccured # see if its time to age the sprite
        BZE  ObjectLoop_Ageless

        CALL Object_DecreaseLife

        TST  R1
        BZE  ObjectLoop_SaveChanges
ObjectLoop_Ageless:
        TSTB R3
        BPL  ObjectLoop_NotShot # cant be shot
ObjectLoop_AgelessIXLCheck:
#-----------------------------------player bullet collisions---------------------------------
      # R1 LSB b = X, R1 MSB c = Y
        PUSH R1
        MOVB R1,R0
        MOVB R0,@$ObjectHitXA
       .equiv SpriteSizeShiftHalfH, .+2
        ADD  $12,R0
        MOVB R0,@$ObjectHitXB
        SWAB R1
        MOVB R1,R0
        MOVB R0,@$ObjectHitYA
       .equiv SpriteSizeShiftFullC, .+2
        ADD  $24,R0
        MOVB R0,@$ObjectHitYB

# ObjectLoop_HeightNZ:
        MOV  $PlayerStarArraySize,R1
        MOV  $PlayerStarArrayPointer,R4

        ObjectLoop_PlayerStarNext:
            MOVB (R4)+,R0
           .equiv ObjectHitYA, .+2
            CMPB R0,$0x00
            BHIS ObjectLoop_PlayerStarScanContinue

        ObjectLoop_PlayerStarSkip:
            INC  R4
            INC  R4
        SOB  R1,ObjectLoop_PlayerStarNext
        BR   ObjectLoop_PlayerStarEnd

    ObjectLoop_PlayerStarScanContinue:
       .equiv ObjectHitYB, .+2
        CMPB R0,$0x00
        BHIS ObjectLoop_PlayerStarSkip

        MOVB (R4),R0
       .equiv ObjectHitXA, .+2
        CMPB R0,$0x00
        BLO  ObjectLoop_PlayerStarSkip

       .equiv ObjectHitXB, .+2
        CMPB R0,$0x00
        BHIS ObjectLoop_PlayerStarSkip

        INC  R4
        MOVB (R4),R0
      # TODO: uncomment for two players
       #BIC  $0xFF7F,R0                             # and %10000000   ; CHeck if this is player 1's bullet or not
       #                                            # dec h
       #                                            # dec h
       #INC  R0                                     # inc a
       #MOV  R0,@$ObjectShotShooter                 # ld (ObjectShotShooter_Plus1 - 1),a
                                                    # xor a
        CLRB @$ObjectLoop_IFShot # BR .+2           # ld (ObjectLoop_IFShot_Plus1 - 1),a
        DEC  R4
        CLRB -(R4) # star hit so lets remove it

    ObjectLoop_PlayerStarEnd:
                                                    # pop hl
        POP  R1                                     # pop de
                                                    # pop bc

ObjectLoopP1StarSkip:
       .equiv ObjectLoop_IFShot, .
        BR   ObjectLoop_NotShot          # jr $+10 :ObjectLoop_IFShot_Plus1 ; 18 08 = JR 8
       .equiv dstObjectShotOverride, .+2  # resets by bootstrap
        CALL @$Object_DecreaseLifeShot    # call Object_DecreaseLifeShot :ObjectShotOverride_Plus2 ;3 bytes
                                          # ld a,8                             ;2 bytes
        MOVB $5,@$ObjectLoop_IFShot # BR ObjectLoop_NotShot # ld (ObjectLoop_IFShot_Plus1 -1 ),a ;3 bytes
#  Player collisions --------------------------------------------------------}}}
ObjectLoop_NotShot:
        SWAB R2 # SWAB back, DoMoves expects Move to be in R2 LSB
      # R2 LSB ixh = Move, R2 MSB iyh = Sprite
       .equiv dstObjectDoMovesOverride, .+2
        CALL @$DoMoves

ObjectLoop_SaveChanges:
        # Animator and SpriteSize never changes
        MOV  R3,-(R5) # R3 LSB ixl = Life, R3 MSB iyl = Program code
        MOV  R2,-(R5) # R2 LSB ixh = Move, R2 MSB iyh = Sprite
        MOVB R4,-(R5) # R4 b = X
        MOVB R1,-(R5) # R1 c = Y

        CLRB R3
        SWAB R3
        BZE  ObjectLoop_ShowSprite

        CALL ObjectProgram
ObjectLoop_ShowSprite:
        CALL @$ShowSprite
        POP  R5
        POP  R4

        JMP  @$ObjectArray_NextObject

# ObjectAnimator not implemented --------------------------------------------{{{
#Animator_VectorArray:
#       .word ObjectAnimator_Update         #  0
#       .word ObjectAnimator_Sprite         #  1
#       .word ObjectAnimator_Move           #  2
#       .word ObjectAnimator_Program        #  3
#       .word ObjectAnimator_EndOfLoop      #  4
#       .word ObjectAnimator_SpriteMoveProg #  5
#       .word ObjectAnimator_Animator       #  6
#       .word ObjectAnimator_CondLoop       #  7
#       .word ObjectAnimator_CondJmp        #  8
#       .word ObjectAnimator_Spawn          #  9
#       .word ObjectAnimator_Kill           # 10
#       .word ObjectAnimator_Call           # 11
#       .word ObjectAnimator_Halt           # 12
#
#ObjectAnimator_Spawn:
#                                        # ld a,(hl)
#                                        # push hl
#                                        #    call DoObjectSpawn
#                                        # pop hl
#                                        # call ObjectAnimator_IncreaseTick
#                                        # jr ObjectAnimatorAgain
#
#ObjectAnimator_CondLoopTrue:
#                                        # call ObjectAnimator_IncreaseTick
#                                        # exx
ObjectAnimator:
       .inform_and_hang "no ObjectAnimator"
#      # our animator is in A
#      # format is
#      # TTTTAAAA
#      #     AAAA = animator (1-15) ; 0 = do nothing
#      #     TTTT = time (0-15) ; loops
#      # If you need more than that use custommoves!
#                                        # di
#                                        # exx
#        PUSH R5
#      # R2 LSB ixh = Move, R2 MSB iyh = Sprite
#      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
#      # R4 LSB = Animator, R4 MSB = Sprite size
#ObjectAnimatorAgain:
#        MOV  R4,R0
#        CALL GetAnimatorMempos          # call getAnimatorMempos
#                                        # ;check if a tick has occured
#                                        # ld a,(hl)
#                                        # ld e,a
#                                        # ld a,(Timer.TicksOccured)
#        BITB (R5)+,@$Timer.TicksOccured # and e
#        BZE  ObjectAnimator_Done        # jp z,ObjectAnimator_Done    ;no tick, so end
#                                        # inc hl
#
#ObjectAnimator_ExecuteTick:
#        MOV  R4,R0                      # ld a,b
#        BIC  $0xFF0F,R0                 # and %11110000 ;convert ticknum to a byte
#        ASR  R0                         # rrca          ;each tick's commands takes 4 bytes
#        ASR  R0                         # rrca
#                                        #
#                                        # ld d,0
#                                        # ld e,a
#        ADD  R0,R5                      # add hl,de
#        MOVB (R5)+,R0                   # ld a,(hl)
#                                        # inc hl
#                                        #
#        ASL  R0                         # push hl         ;
#                                        # ld hl,Animator_VectorArray
#        JMP  @Animator_VectorArray(R0)  # jp VectorJump_PushHlFirst
#                                        # jr ObjectAnimator_Update
#
#ObjectAnimator_Sprite:
#        SWAB R2
#        CLRB R2                         # ld a,(hl)
#        BISB (R5),R2                    # ld iyh,a
#        SWAB R2
#        BR   ObjectAnimator_Update      # jr ObjectAnimator_Update
#
#ObjectAnimator_Move:
#        CLRB R2                         # ld a,(hl)
#        BISB (R5),R2                    # ld ixh,a
#        BR   ObjectAnimator_Update      # jr ObjectAnimator_Update
#
#ObjectAnimator_SpriteMoveProg:
#        CLR  R2                         # ld a,(hl)
#        BISB (R5)+,R2                   # ld iyh,a
#                                        # inc hl
#        SWAB R2                         # ld a,(hl)
#        BISB (R5)+,R2                   # ld ixh,a
#                                        # inc hl  ;Fall in to program
#ObjectAnimator_Program:
#        SWAB R3
#        CLRB R3                         # ld a,(hl)
#        BISB (R5),R3                    # ld iyl,a
#        SWAB R3
#        BR   ObjectAnimator_Update      # jr ObjectAnimator_Update
#
#ObjectAnimator_Call:
#        CLR  R0                         # ld e,(hl)
#        BISB (R5)+,R0                   # inc hl
#        SWAB R0                         # ld d,(hl)
#        BISB (R5)+,R0                   # inc hl
#        SWAB R0
#        CALL (R0)                       # call CallDE
#        BR   ObjectAnimator_Update      # jr ObjectAnimator_Update
#
#ObjectAnimator_Animator:
#                                        # ld a,(hl)
#                                        # or a      ;see if new animator is zero (No animator)
#                                        # jr z,ObjectAnimator_Save
#                                        # jr ObjectAnimatorAgain
#                                        #
#ObjectAnimator_CondJmp:
#                                        # ld e,(hl)
#                                        # ld a,(Timer.TicksOccured)
#                                        # and e
#                                        # jr z,ObjectAnimator_CondLoopTrue    ; Just read the next frame
#                                        # inc hl
#                                        # ld c,(hl)
#                                        # ;change tick if condition is true
#
#ObjectAnimatorNextTick:
#                                        # ld a,b
#                                        # and %00001111
#                                        # or c
#                                        # jr ObjectAnimatorAgain
#
#ObjectAnimator_CondLoop:
#                                        # ld e,(hl)
#                                        # ld a,(Timer.TicksOccured)
#                                        # and e
#                                        # jp nz,ObjectAnimator_CondLoopTrue   ;Fall into endofloop
#
#ObjectAnimator_EndOfLoop:
#                                        # ld a,b
#                                        # and %00001111
#                                        # call GetAnimatorMempos
#                                        # inc hl
#                                        # jp ObjectAnimator_ExecuteTick
#ObjectAnimator_IncreaseTick:
#        MOV  R4,R0                      # ld a,b
#        ADD  $0b00010000,R0             # add %00010000
#        BIC  $0xFF0F,R0                 # and %11110000
#                                        # ld c,a
#                                        # ld a,b
#        BICB $0xF0,R4                   # and %00001111
#        BIS  R0,R4                      # or c
#        RETURN                          # ret
#
#ObjectAnimator_Halt:
#                                        # ld a,b
#                                        # jr ObjectAnimator_Save
#ObjectAnimator_Update:
#      # We're done, so update the tick
#        CALL @$ObjectAnimator_IncreaseTick # Call ObjectAnimator_IncreaseTick
#ObjectAnimator_Save:
#        POP  R5                         # exx
#        SWAB R4                         # ei
#        MOV  R4,(R5)                    # ld (hl),a
#        RETURN                          # ret
#ObjectAnimator_Kill:
#                                        #     exx
#                                        # ;   ei
#                                        # ; *********** SHOULD THERE BE AN EI HERE?
#                                        #
#                                        #     xor a
#                                        #     ld c,a
#                                        #     ld iyl,a    ;wipe program
#                                        #     ld ixh,a
#                                        # ret
#                                        #
#ObjectAnimator_Done:
#        POP  R5                         #     exx
#                                        #     ei
#        RETURN                          # ret
#                                        #
#GetAnimatorMempos:
#                                        #     ld b,a
#                                        #     ld hl,&6969 :AnimatorPointers_Plus2
#                                        #     ld d,0
#        BIC  $0xFFF0,R0                 #     and %00001111
#        DEC  R0                         #     dec a
#        ASL  R0                         #     rlca
#                                        #     ld e,a
#                                        #     ;read the mempointer to the animator
#                                        #     add hl,de
#                                        #     ld a,(hl)
#                                        #     inc hl
#                                        #     ld h,(hl)
       .equiv ObjectAnimator_AnimatorPointers, .+2
        MOV  0(R0),R5                   #     ld l,a
        RETURN                          # ret
                                        # DoObjectSpawn:
                                        # push de
                                        # push bc
                                        # push iy
                                        #
                                        #     ld iy,LdAFromHLIncHL    ; Set RST 6 to do our bidding
                                        #
                                        #     ld hl,Event_SavedSettings ;Event_SavedSettings_Plus2
                                        #     ld (Event_SavedSettingsFinal_Plus2-2),hl
                                        #
                                        #     call SettingsGetLocation
                                        #     Call DoSettingsLoad
                                        #     exx
                                        #     push bc
                                        #     exx
                                        #     pop bc
                                        #     ld d,b
                                        #     call Event_AddObject    ;C=y ;d=x
                                        # pop iy
                                        # pop bc
                                        # pop de
                                        # ld hl,(Objects_LastAdded_Plus2-2)
                                        # ret
# ObjectAnimator end --------------------------------------------------------}}}
ObjectProgram:                          # ret z       ; return if zero
      # R3 LSB iyl = Program code, MSB = 0, ixl = Life
        MOV  R3,R0
        CMP  R0,$0b00000001         # Used by background, sprite bank based on X co-ord
        BEQ  ObjectProgram.BitShiftSprite
        BIC  $0b00000111,R0         # 00000xxx = Powerup
        BZE  ObjectProgram.Misc
        CMP  $0b11110000,R0         # 11110xxx = Animate every X frames
        BZE  ObjectProgram.FrameAnimate
        BIC  $0b00011111,R0         # 0001xxxx = Smartbombable Powerup
        BZE  ObjectProgram.Misc

        ASR  R0
        ASR  R0
        ASR  R0
        ASR  R0
        JMP  @ObjectProgram.Fire_JumpTable-2(R0)
ObjectProgram.Fire_JumpTable:
       .word ObjectProgram.FastFire       # 001xxxxx
       .word ObjectProgram.MidFire        # 010xxxxx
       .word ObjectProgram.SlowFire       # 011xxxxx
       .word ObjectProgram.SnailFire      # 100xxxxx
       .word ObjectProgram.HyperFire      # 101xxxxx
       .word ObjectProgram.AboveMidFire   # 110xxxxx
       .word ObjectProgram.CustomPrograms

ObjectProgram.CustomPrograms:
        BIC  $0xFFFC,R3 # 0b11111100
        ASL  R3
        JMP  @ObjectProgram.CustomPrograms_JumpTable(R3)
ObjectProgram.CustomPrograms_JumpTable:
        ObjectProgram.Custom1: .word null # jp null   :CustomProgram1_Plus2
        ObjectProgram.Custom2: .word null # jp z,null :CustomProgram2_Plus2
        ObjectProgram.Custom3: .word null # jp z,null :CustomProgram3_Plus2
                               .word SpecialMoveChibiko # Only used by ep2 for a crap joke!

ObjectProgram.Misc:
                                        # ld a,iyl
        BIC  $0xFFF0,R3                 # and %00001111
        CMP  R3,$4                      # cp 4
        BEQ  ObjectProgram.MovePlayer   # jr z,ObjectProgram_MovePlayer
       #CMP  R3,$8                      # cp 8                ;Custom 1
       #BEQ  ObjectProgram.Custom1      # jr z,ObjectProgram_Custom1
1237$:  RETURN                          # ret

ObjectProgram.MovePlayer: # Used by end of level code to make player fly to a point
      # R4 b = X, R1 c = Y, R3 iyl = Program
   .ifdef TwoPlayersGame
        MOV  $Player_Array2,R5
        CALL ObjectProgram.DoMovePlayer
   .endif
SpecialMoveChibiko:
        MOV  $Player_Array,R5

ObjectProgram.DoMovePlayer:
        MOVB (R5),R0
        CMPB R0,R1
        BEQ  ObjectProgram.MovePlayerX
        BHIS ObjectProgram.MovePlayerYUp

        ADD  $8,R0
        BR   ObjectProgram.MovePlayerX
ObjectProgram.MovePlayerYUp:
        SUB  $8,R0
ObjectProgram.MovePlayerX:
        MOVB R0,(R5)+

        MOVB (R5),R0
        CMPB R0,R4
        BEQ  ObjectProgram.MovePlayerDone
        BHIS ObjectProgram.MovePlayerXUp

        ADD  $6,R0
        BR   ObjectProgram.MovePlayerDone
ObjectProgram.MovePlayerXUp:
        SUB  $6,R0
ObjectProgram.MovePlayerDone:
        MOVB R0,(R5)

        RETURN

# ObjectProgram.SpriteBankSwitch:        ; an object which uses sprite bank 2
#       ld a,2                           ; this is to split one sprite into 2 non animated
#                                        ; for basic background objects / enemies
# ObjectProgram.SpriteBankSwitchCustomB: ; an object which uses sprite bank 2
#       ld (ObjectSpriteBank_Plus1-1),a  ; second anim frame
#
#       ret

ObjectProgram.FrameAnimate: # Used To animate spider legs in 1st boss
      # R3 LSB iyl = Program code, MSB = 0
        BIC  $0xFFF8,R3 # -----XXX
        CLR  R0
        INC  R0 # MOV $1,R0
        ASH  R3,R0
        BIT  R0,@$Timer.CurrentTick
        BZE  1237$

        MOV  @$SpriteBanksVectors+4,@$SprShow_BankAddr
1237$:  RETURN

# Every other X column uses an alternate sprite - for background anim ----------
ObjectProgram.BitShiftSprite:
      # R4 b = X
        MOV  R4,@$SprShow_X # Makesure sprite pos is updated for Domoves
        BIT  $2,R4          # 4 pixel
        BNZ  1237$

        MOV  @$SpriteBanksVectors+4,@$SprShow_BankAddr
1237$:  RETURN

ObjectProgram.SnailFire:
       .equiv  FireFrequencyA, .+2
        MOV  $0b00010000,R0
        BR   ObjectProgram.Fire
ObjectProgram.SlowFire:
       .equiv  FireFrequencyB, .+2
        MOV  $0b00001000,R0
        BR   ObjectProgram.Fire
ObjectProgram.MidFire:
       .equiv  FireFrequencyC, .+2
        MOV  $0b00001000,R0
        BR   ObjectProgram.Fire
ObjectProgram.AboveMidFire:
       .equiv  FireFrequencyD, .+2
        MOV  $0b00000100,R0
        BR   ObjectProgram.Fire
ObjectProgram.FastFire:
       .equiv  FireFrequencyE, .+2
        MOV  $0b00000010,R0

ObjectProgram.Fire:
                                     # ld d,a
                                     # ei  ; Why is interrupts disabled here??
        BIT  R0,@$Timer.TicksOccured # ld a,(Timer_TicksOccured)
        BZE  1237$                   # and d
                                     # ret z
ObjectProgram.HyperFire:
       .ppudo $PPU_PlaySoundEffect2
      # R4 B = X
      # R1 C = Y
      # R3 IYL = Prg
        MOV  @$SpriteSizeShiftHalfB,R2     # ld a,(SpriteSizeShiftHalfB_Plus1 - 1)
        ADD  R2,R1                         # ld d,a
                                           # add c
                                           # ld c,a
                                           # ld a,d
        RORB R2                            # rrca
        RORB R2                            # rrca
        ADD  R4,R2                         # add b
                                           # ld d,a
                                           # ld a,iyl
        BIC  $0xFFE0,R3 # ---XXXXX         # and %00011111
      # R3 B = pattern (0-15)              # ld b,a  ; top left
      # R1 C = Y pos                       #
      # R2 D = X pos                       # FireCustomStar:
        JMP  @$Stars_AddObjectBatchDefault #     jp Stars_AddObjectBatchDefault
                                           #
                                           # Object_DecreaseShot_Player2:
                                           #     ld iy,Player_Array2
                                           #     jr Object_DecreaseShot_Start
Object_DecreaseLifeShot: #------------------------------------------------------
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        MOV  R3,R0                         # ld a,ixl
        BIC  $0xFFC0,R0 # MM = life mode, LLLLLL = life qty # and %00111111
        BZE  1237$                         # ret z ; if life is zero drop out (For custom hit code callback)
                                           # push bc
                                           # push IY
      # see if player has POWERSHOT!
      # Uhh, this was soo much easier before 2 player support!
                                           # ld b,a
      #.equiv ObjectShotShooter, .+2
                                           # ld a,0:ObjectShotShooter_Plus1  ;1=Player 1, 129 = player 2
                                           # dec a
                                           # jr nz,Object_DecreaseShot_Player2
        MOV  $Player_Array,R4              # ld iy,Player_Array
Object_DecreaseShot_Start:
                                           # ld a,(IY+14)
                                           # or a
        TSTB 14(R4)                        # ld a,b
        BZE  Object_DecreaseShot_OnlyOne   # jp z,Object_DecreaseShot_OnlyOne
        DEC  R0                            # dec a
        BZE  Object_DecreaseShotToDeath    # jr z, Object_DecreaseShotToDeath
Object_DecreaseShot_OnlyOne:
                                           # pop IY
                                           # pop bc
        DEC  R0                            # dec a
        BNZ  Object_DecreaseLife_AgeUpdate # jr nz,Object_DecreaseLife_AgeUpdate
                                           #
        BR   Object_DecreaseShotToDeathB   # jr Object_DecreaseShotToDeathB
Object_DecreaseShotToDeath:
                                           # pop IY
                                           # pop bc
Object_DecreaseShotToDeathB:
      # object has been shot to death
       .equiv dstCustomShotToDeathCall, .+2
        CALL @$null
        BIC  $0xFF00,(R5) # Clear object animator
       .ppudo $PPU_PlaySoundEffect3
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
      # create a coin
       .equiv PointsSpriteC, .+2
        MOV (PC)+,R2
       .byte 128+16     # Sprite
       .byte mveSeaker_P1 | 0b11 # Seaker Fast 1000001XX XX=Speed

                        # ld a,(ObjectShotShooter_Plus1-1) ;1=Player 1, 129 = player 2
                        # dec a
                        # jr z,Object_DecreaseShotToDeath_Player1
                        # ld ixh,%10010011; Seaker Fast P2 1000100XX XX=Speed
Object_DecreaseShotToDeath_Player1:
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        MOV  (PC)+,R3
       .byte 64+63 # Life, must "hurt" player for hit to be detected
       .byte 3     # Program
1237$:  RETURN
#-------------------------------------------------------------------------------
Object_DecreaseLife:
      # R1 LSB b = X, R1 MSB c = Y
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        MOVB R3,R0
        BIC  $0xFFC0,R0 # 0b00111111
        DEC  R0
        BNZ  Object_DecreaseLife_AgeUpdate
      # object has died of old age
        CLR  R1
        CLRB R3
        RETURN

Object_DecreaseLife_AgeUpdate:
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        BICB $0x3F,R3 # Keep the 1st 2 bytes, format is ;MMLLLLLL
        BISB R0,R3    # MM = life mode, LLLLLL = life qty
        RETURN
