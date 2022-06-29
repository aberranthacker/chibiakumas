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
        BNE  ObjectArray_ConfigureForSizeB
        RETURN
ObjectArray_ConfigureForSizeB:
        CLR  R0
        BISB R4,R0
        MOV  R0,@$ObjectSpriteSizeCurrent
        MOV  R0,@$SpriteSizeShiftFull
       #MOV  R0,@$SpriteSizeShiftFullB # TODO: uncomment for player 2
        MOV  R0,@$SpriteSizeShiftFullC
        ASR  R0
        MOV  R0,@$SpriteSizeShiftHalfB
       #MOV  R0,@$SpriteSizeShiftHalfD # TODO: uncomment for player 2
        BIS  $0b00000011,R0
        MOV  R0,@$SpriteSizeShiftHalfH

        # Define player 1 and 2 hitboxes
ObjectArray_ConfigureForSize:
        # We update player location in advance for fast collision detection
        # Define player 1's hitbox
        CLR  R0
        BISB @$P1_P00,R0 # PlayerY
        MOV  R0,@$PlayerY2
       .equiv SpriteSizeShiftFull, .+2
        SUB  $24,R0
        BHIS 1$

        CLR  R0
    1$:
        MOV  R0,@$PlayerY1
        CLR  R0
        BISB @$P1_P01,R0 # PlayerX
        MOV  R0,@$PlayerX2
       .equiv SpriteSizeShiftHalfB, .+2
        SUB  $12,R0
        BHIS 2$

        CLR  R0
    2$:
        MOV  R0,@$PlayerX1
      # Define player 2's hitbox # TODO uncomment for player 2
   #    CLR  R0
   #    BISB @$P2_P00,R0 # PlayerY
   #    MOV  R0,@$Player2Y2
   #   .equiv SpriteSizeShiftFullB, .+2
   #    SUB  $24,R0
   #    BHIS 3$

   #    CLR  R0
   #3$: MOV  R0,@$Player2Y1
   #    CLR  R0
   #    BISB @$P1_P01,R0 # PlayerX
   #    MOV  R0,@$Player2X2
   #   .equiv SpriteSizeShiftHalfD, .+2
   #    SUB  $12,R0
   #    BHIS 4$

   #    CLR  R0
   #4$: MOV  R0,@$Player2X1

        RETURN
# ObjectArray_ConfigureForSize ----------------------------------------------}}}
ObjectArray_Redraw:                                         # ObjectArray_Redraw:
        TST  @$Timer_TicksOccured                        #     ld a,(Timer_TicksOccured)
                                                            #     or a
        BZE  game_paused                                    #     ret z   ; see if game is paused (TicksOccurred = 0 )
        # Define player 1 and 2 hitboxes                    #
        CALL @$ObjectArray_ConfigureForSize                 #     call ObjectArray_ConfigureForSize
                                                            #
        MOV  $ObjectArraySize,R4                            #     ld B,ObjectArraySize ;00ObjectArray_Size_Plus1
        MOV  $ObjectArrayPointer,R5                         #     ld hl,ObjectArrayPointer;(ObjectArrayAddress)
                                                            #     xor a ; Zero
    object_loop:                                            # Objectloop2:
        MOV  (R5)+,R1 # Screen Y=LSB co-ordinate (one byte) #     ld c,(hl)   ; Y
        TSTB R1       # 0 means this object is unused       #     cp c
        BNZ  object_present                                 #     jr NZ,Objectloop_NotZero ;if object Y =0 the object is dead

ObjectArray_NextObject:                                     # ObjectArray_Turbo:
        ADD  $6,R5                                          #     inc l
        SOB  R4,object_loop                                 #     djnz Objectloop2

    game_paused:                                            #
        RETURN                                              #     ret

    object_present:
        PUSH R4
        PUSH R5

        MOVB R1,@$SprShow_Y
        SWAB R1
        MOVB R1,@$SprShow_X
      # R1 LSB b = X, R1 MSB c = Y
        MOV  (R5)+,R2
      # R2 LSB ixh = Move, R2 MSB iyh = Sprite
        MOV  (R5)+,R3
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        MOV  (R5),R4
      # R4 LSB = Sprite Size, R4 MSB = Animator

       .equiv ObjectSpriteSizeCurrent, .+2
        CMPB $0x00,R4
        BEQ  1$
        CALL ObjectArray_reConfigureForSize # Code to change sprite size!
    1$:
        SWAB R4
      # R4 LSB = Animator, R4 MSB = Sprite size
        TSTB R4
        BZE  2$
        CALL ObjectAnimator
   2$:
        SWAB R2                                           # ld a,iyh
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
        MOV  R2,R0
        BIC  $0xFFC0,R0                                   # and %00111111
        MOV  R0,@$SprShow_SprNum                       # ld (SprShow_SprNum),a
                                                          # ld a,iyh
        BIT  $0xC0,R2                                     # and %11000000
        BZE  Objectloop_SpriteBankSet  # one frame sprite # jr z,Objectloop_SpriteBankSet

        MOV  @$Timer_CurrentTick,R0                    # bit 6,a
        BIT  $0x40,R2                                     # ld a,(Timer_CurrentTick)
        BZE  Objectloop_TwoFrameSprite                    # jr z,Objectloop_TwoFrameSprite

      ##if we got here it's a FourFrameSprite
        BIC  $0177774,R0                                  # and %00000011
        BR   Objectloop_SpriteBankSet                     # jr Objectloop_SpriteBankSet

Objectloop_TwoFrameSprite:
        COM  R0                                           #         cpl
        BIC  $0177775,R0                                  #         and %00000010

Objectloop_SpriteBankSet:
      # R1 LSB b = X, R1 MSB c = Y
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
      # R4 LSB = Animator, R4 MSB = Sprite size

      # Life BPxxxxx
      # B=hurt by bullets,
      # P=hurts player,
      # xxxxxx = hit points (if not B then ages over time)
        BIT  0x40,R3 # R3 Life=LSB, Program=MSB #     ld a,ixl
                                                #     bit 6,a
        BZE  ObjectLoopBothPlayerSkip           #     jr z,ObjectLoopBothPlayerSkip ; Doesn't hurt player
                                                #
# used to modify this, but now we assume the player is alway vunurable
# we check anyway before deducting a life
# ;Jp Objectloop_PlayerVunrable ;Objectloop_DoPlayerCollisions_Plus2
# Objectloop_PlayerVunrable:
#  Player collisions --------------------------------------------------------{{{
      # R0 use at will
      # R1 LSB b = X, R1 MSB c = Y
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
      # R4 use at will
      # R5 ObjectArray current object last element pointer
        MOV  R1,R0                  # ld a,b
       .equiv PlayerX1, .+2
        CMPB R0,$20                 # cp 0 :PlayerX1_Plus1
        BLO  ObjectLoopP1Skip       # jr c,ObjectLoopP1Skip
       .equiv PlayerX2, .+2
        CMPB R0,$32                 # cp 0 :PlayerX2_Plus1
        BHIS ObjectLoopP1Skip       # jr nc,ObjectLoopP1Skip
        SWAB R0                     # ld a,c
       .equiv PlayerY1, .+2
        CMPB R0,$76                 # cp 0 :PlayerY1_Plus1
        BLO  ObjectLoopP1Skip       # jr c,ObjectLoopP1Skip
       .equiv PlayerY2, .+2
        CMPB R0,$100                # cp 0 :PlayerY2_Plus1
        BHIS ObjectLoopP1Skip       # jr nc,ObjectLoopP1Skip
                                    #
        TSTB @$P1_P09               # ld a,(P1_P09)
                                    # or a
        BZE  ObjectLoopP1Skip       # jr z,ObjectLoopP1Skip
                                    #
                                    # push hl
                                    #     ld hl,Player_Array
        CALL Player_Hit             #     call Player_Hit
                                    # pop hl
                                    #
                                    # ld a,b
        TST  R1                     # or a
        BZE  ObjectLoop_SaveChanges # jp z,ObjectLoop_SaveChanges

ObjectLoopP1Skip:
       # uncomment for player 2                             # ;assume we're playing 1 player!
       #                                                    # ;so check if we have a player 2.
       #                                                    # ld a,(P2_P09)
       #                                                    # or a
       #                                                    # jr z,ObjectLoopP2Skip
       #                                                    #
       #                                                    # ld a,b
       #CMPB (PC)+,R0; Player2X1: .word 0                # cp 0 :Player2X1_Plus1
       #                                                    # jr c,ObjectLoopP2Skip
       #CMPB (PC)+,R0; Player2X2: .word 0                # cp 0 :Player2X2_Plus1
       #                                                    # jr nc,ObjectLoopP2Skip
       #                                                    #
       #                                                    # ld a,c
       #CMPB (PC)+,R0; Player2Y1: .word 0                # cp 0 :Player2Y1_Plus1
       #                                                    # jr c,ObjectLoopP2Skip
       #CMPB (PC)+,R0; Player2Y2: .word 0                # cp 0 :Player2Y2_Plus1
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
        TSTB R3                                  # ld a,ixl
                                                 # or a
        BZE  ObjectLoop_NotShot                  # jr z,ObjectLoopP1StarSkip ; immortal object (background)
        BIT  $0x80,R3                            # bit 7,a
        BNZ  ObjectLoop_AgelessIXLCheck          # jr nz,ObjectLoop_AgelessIXLCheck ; If it can be shot, it doesn't auto age
                                                 #
                                                 # ld a,(Timer_TicksOccured) ; see if its time to age the sprite
        BIT  $0b00001000,@$Timer_TicksOccured    # and %00001000
        BZE  ObjectLoop_Ageless                  # jr z,ObjectLoop_Ageless
                                                 #
        CALL Object_DecreaseLife                 # call Object_DecreaseLife
                                                 # ld a,c
        TST  R1                                  # or a
        BZE  ObjectLoop_SaveChanges              # jr z,ObjectLoop_SaveChanges
ObjectLoop_Ageless:
                                                 # ld a,ixl
        BIT  $0x80,R3                            # bit 7,a
        BZE  ObjectLoop_NotShot                  # jr z,ObjectLoop_NotShot ; cant be shot
ObjectLoop_AgelessIXLCheck:
#-----------------------------------player bullet collisions---------------------------------
      # R1 LSB b = X, R1 MSB c = Y
                                                            # push bc
        PUSH R1                                             # push de
                                                            # push hl
        MOVB R1,R0                                          # ld a,b
        MOVB R0,@$ObjectHitXA                               # ld (ObjectHitXA_Plus1 - 1),a
       .equiv SpriteSizeShiftHalfH, .+2
        ADD  $12,R0                                         # add 12  :SpriteSizeShiftHalfH_Plus1
        MOVB R0,@$ObjectHitXB                               # ld (ObjectHitXB_Plus1 - 1),a
        SWAB R1
        MOVB R1,R0                                          # ld a,c
        MOVB R0,@$ObjectHitYA                               # ld (ObjectHitYA_Plus1 - 1),a
       .equiv SpriteSizeShiftFullC, .+2
        ADD  $24,R0                                         # add 24  :SpriteSizeShiftFullC_Plus1
        MOVB R0,@$ObjectHitYB                               # ld (ObjectHitYB_Plus1 - 1),a
                                                            #
# ObjectLoop_HeightNZ:
        MOV  $PlayerStarArraySize,R1    # ld b ,PlayerStarArraySize    ;36 StarArraySize_PlayerB_Plus1
        MOV  $PlayerStarArrayPointer,R4 # ld hl,PlayerStarArrayPointer ;&0000 StarArrayMemloc_Player_Plus2

        ObjectLoop_PlayerStarNext:
            MOVB (R4)+,R0
           .equiv ObjectHitYA, .+2                  # ld a,(hl)   ;check Y of star
            CMPB R0,$0x00                           # cp 00 :ObjectHitYA_Plus1
            BHIS ObjectLoop_PlayerStarScanContinue  # jr nc,ObjectLoop_PlayerStarScanContinue
        ObjectLoop_PlayerStarSkip:
            INC  R4                                 # inc l
            INC  R4
        SOB  R1,ObjectLoop_PlayerStarNext           # djnz ObjectLoop_PlayerStarNext
        BR   ObjectLoop_PlayerStarEnd               # jr ObjectLoop_PlayerStarEnd
                                                    #
    ObjectLoop_PlayerStarScanContinue:
       .equiv ObjectHitYB, .+2
        CMPB R0,$0x00                               # cp 00 :ObjectHitYB_Plus1
        BHIS ObjectLoop_PlayerStarSkip              # jr nc,ObjectLoop_PlayerStarSkip
                                                    # inc h
        MOVB (R4),R0                                # ld a,(hl)
       .equiv ObjectHitXA, .+2                      # dec h
        CMPB R0,$0x00                               # cp 00 :ObjectHitXA_Plus1
        BLO  ObjectLoop_PlayerStarSkip              # jr c,ObjectLoop_PlayerStarSkip

       .equiv ObjectHitXB, .+2
        CMPB R0,$0x00                               # cp 00 :ObjectHitXB_Plus1
        BHIS ObjectLoop_PlayerStarSkip              # jr nc,ObjectLoop_PlayerStarSkip
                                                    # inc h
        INC  R4                                     # inc h
        MOVB (R4),R0                                # ld a,(hl)
        # TODO: uncomment for two players
       #BIC  $0xFF7F,R0                             # and %10000000   ; CHeck if this is player 1's bullet or not
       #                                            # dec h
       #                                            # dec h
       #INC  R0                                     # inc a
       #MOV  R0,@$ObjectShotShooter                 # ld (ObjectShotShooter_Plus1 - 1),a
                                                    # xor a
        CLRB @$ObjectLoop_IFShot # BR .+2           # ld (ObjectLoop_IFShot_Plus1 - 1),a
        DEC  R4
        CLRB -(R4)                                  # ld (hl),0 ; star hit so lets remove it

    ObjectLoop_PlayerStarEnd:
                                                    # pop hl
        POP  R1                                     # pop de
                                                    # pop bc

ObjectLoopP1StarSkip:
       .equiv ObjectLoop_IFShot, .
        BR   ObjectLoop_NotShot          # jr $+10 :ObjectLoop_IFShot_Plus1 ; 18 08 = JR 8
       .equiv  dstObjectShotOverride, .+2
        CALL @$Object_DecreaseLifeShot    # call Object_DecreaseLifeShot :ObjectShotOverride_Plus2 ;3 bytes
                                          # ld a,8                             ;2 bytes
        MOVB $5,@$ObjectLoop_IFShot # BR ObjectLoop_NotShot # ld (ObjectLoop_IFShot_Plus1 -1 ),a ;3 bytes
#  Player collisions --------------------------------------------------------}}}
ObjectLoop_NotShot:
        SWAB R2 # SWAB back, DoMoves expects Move to be in R2 LSB
      # R2 LSB ixh = Move, R2 MSB iyh = Sprite
                                             # ld d,ixh
       .equiv dstObjectDoMovesOverride, .+2
        CALL @$DoMoves                       # call DoMoves :ObjectDoMovesOverride_Plus2
                                             # ld ixh,d
ObjectLoop_SaveChanges:
        # Animator and SpriteSize never changes
        MOV  R3,-(R5) # R3 LSB ixl = Life, R3 MSB iyl = Program code
        MOV  R2,-(R5) # R2 LSB ixh = Move, R2 MSB iyh = Sprite
        MOVB R4,-(R5) # R4 b = X
        MOVB R1,-(R5) # R1 c = Y

        CLRB R3                       # ld a,iyl
        SWAB R3                       # or a
        BZE  ObjectLoop_ShowSprite    # call nz, ObjectProgram

        CALL ObjectProgram            #
ObjectLoop_ShowSprite:
                                      # ld b,Akuyou_LevelStart_Bank;&C0
                                      # ld hl,Akuyou_LevelStart;&4000   ;ObjectSpritePointer_Plus2
                                      # ObjectLoop_ShowSprite_BankSet:
                                      #         ld a,b
                                      # ObjectLoop_ShowSprite_BankSetA:
                                      #         call BankSwitch_C0_SetCurrent
                                      #         ld (SprShow_BankAddr),hl
        CALL @$ShowSprite             #         call ShowSprite
                                      #         call BankSwitch_C0_SetCurrentToC0
        POP  R5                       #     pop hl
        POP  R4                       #     pop bc
                                      #     xor a ; Zero
        JMP  @$ObjectArray_NextObject #     jp ObjectArray_Turbo

# ObjectAnimator not implemented --------------------------------------------{{{
                                        # Animator_VectorArray:
                                        # defw ObjectAnimator_Update         ; 1
                                        # defw ObjectAnimator_Sprite         ; 2
                                        # defw ObjectAnimator_Move           ; 3
                                        # defw ObjectAnimator_Program        ; 4
                                        # defw ObjectAnimator_EndOfLoop      ; 5
                                        # defw ObjectAnimator_SpriteMoveProg ; 6
                                        # defw ObjectAnimator_Animator       ; 7
                                        # defw ObjectAnimator_CondLoop       ; 8
                                        # defw ObjectAnimator_CondJmp        ; 9
                                        # defw ObjectAnimator_Spawn          ;10
                                        # defw ObjectAnimator_Kill           ;11
                                        # defw ObjectAnimator_Call           ;12
                                        # defw ObjectAnimator_Halt           ;13
                                        #
                                        # ObjectAnimator_Spawn:
                                        #     ld a,(hl)
                                        #     push hl
                                        #         call DoObjectSpawn
                                        #     pop hl
                                        #     call ObjectAnimator_IncreaseTick
                                        #     jr ObjectAnimatorAgain
                                        #
                                        # ObjectAnimator_CondLoopTrue:
                                        #     call ObjectAnimator_IncreaseTick
                                        #
                                        #     exx
ObjectAnimator:                         # ObjectAnimator:
        .inform_and_hang "no ObjectAnimator"
                                        #     ;our animator is in A
                                        #     ;format is
                                        #     ;TTTTAAAA
                                        #     ;   AAAA = animator (1-15) ; 0 = do nothing
                                        #     ;   TTTT = time (0-15) ; loops
                                        #     ; If you need more than that use custommoves!
                                        #     di
                                        #     exx
                                        #
                                        # ObjectAnimatorAgain:
                                        #         call getAnimatorMempos
                                        #         ;check if a tick has occured
                                        #         ld a,(hl)
                                        #         ld e,a
                                        #         ld a,(Timer_TicksOccured)
                                        #         and e
                                        #         jp z,ObjectAnimator_Done    ;no tick, so end
                                        #         inc hl
                                        #
                                        # ObjectAnimator_ExecuteTick:
                                        #         ld a,b
                                        #         and %11110000   ;convert ticknum to a byte
                                        #         rrca        ;each tick's commands takes 4 bytes
                                        #         rrca
                                        #
                                        #         ld d,0
                                        #         ld e,a
                                        #         add hl,de
                                        #         ld a,(hl)
                                        #         inc hl
                                        #
                                        #         push hl         ;
                                        #         ld hl,Animator_VectorArray
                                        #         jp VectorJump_PushHlFirst
                                        #
                                        #         jr ObjectAnimator_Update
                                        #
                                        # ObjectAnimator_Sprite:
                                        #         ld a,(hl)
                                        #         ld iyh,a
                                        #         jr ObjectAnimator_Update
                                        #
                                        # ObjectAnimator_Move:
                                        #         ld a,(hl)
                                        #         ld ixh,a
                                        #         jr ObjectAnimator_Update
                                        #
                                        # ObjectAnimator_SpriteMoveProg:
                                        #         ld a,(hl)
                                        #         ld iyh,a
                                        #         inc hl
                                        #         ld a,(hl)
                                        #         ld ixh,a
                                        #         inc hl  ;Fall in to program
                                        # ObjectAnimator_Program:
                                        #         ld a,(hl)
                                        #         ld iyl,a
                                        #         jr ObjectAnimator_Update
                                        #
                                        # ObjectAnimator_Call:
                                        #             ld e,(hl)
                                        #             inc hl
                                        #             ld d,(hl)
                                        #             inc hl
                                        #             call CallDE
                                        #         jr ObjectAnimator_Update
                                        #
                                        # ObjectAnimator_Animator:
                                        #         ld a,(hl)
                                        #         or a                ;see if new animator is zero (No animator)
                                        #         jr z,ObjectAnimator_Save
                                        #         jr ObjectAnimatorAgain
                                        #
                                        # ObjectAnimator_CondJmp:
                                        #         ld e,(hl)
                                        #         ld a,(Timer_TicksOccured)
                                        #         and e
                                        #         jr z,ObjectAnimator_CondLoopTrue    ; Just read the next frame
                                        #         inc hl
                                        #         ld c,(hl)
                                        #         ;change tick if condition is true
                                        #
                                        # ObjectAnimatorNextTick:
                                        #         ld a,b
                                        #         and %00001111
                                        #         or c
                                        #         jr ObjectAnimatorAgain
                                        #
                                        # ObjectAnimator_CondLoop:
                                        #         ld e,(hl)
                                        #         ld a,(Timer_TicksOccured)
                                        #         and e
                                        #         jp nz,ObjectAnimator_CondLoopTrue   ;Fall into endofloop
                                        #
                                        # ObjectAnimator_EndOfLoop:
                                        #         ld a,b
                                        #         and %00001111
                                        #         call GetAnimatorMempos
                                        #         inc hl
                                        #         jp ObjectAnimator_ExecuteTick
                                        # ObjectAnimator_IncreaseTick:
                                        #         ld a,b
                                        #         add %00010000
                                        #         and %11110000
                                        #         ld c,a
                                        #         ld a,b
                                        #         and %00001111
                                        #         or c
                                        # ret
                                        # ObjectAnimator_Halt:
                                        #         ld a,b
                                        #         jr ObjectAnimator_Save
                                        # ObjectAnimator_Update:
                                        #         ;We're done, so update the tick
                                        #         Call ObjectAnimator_IncreaseTick
                                        # ObjectAnimator_Save:
                                        #     exx
                                        #     ei
                                        #     ld (hl),a
                                        #     ifdef Debug
                                        #         call Debug_ReleaseEXX
                                        #     endif
                                        # ret
                                        # ObjectAnimator_Kill:
                                        #     exx
                                        # ;   ei
                                        # ; *********** SHOULD THERE BE AN EI HERE?
                                        #
                                        #     xor a
                                        #     ld c,a
                                        #     ld iyl,a    ;wipe program
                                        #     ld ixh,a
                                        # ret
                                        #
                                        # ObjectAnimator_Done:
                                        #     exx
                                        #     ei
                                        #     ifdef Debug
                                        #         call Debug_ReleaseEXX
                                        #     endif
                                        # ret
                                        #
                                        # GetAnimatorMempos:
                                        #     ld b,a
                                        #     ld hl,&6969 :AnimatorPointers_Plus2
                                        #     ld d,0
                                        #     and %00001111
                                        #     dec a
                                        #     rlca
                                        #     ld e,a
                                        #     ;read the mempointer to the animator
                                        #     add hl,de
                                        #     ld a,(hl)
                                        #     inc hl
                                        #     ld h,(hl)
                                        #     ld l,a
                                        # ret
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
ObjectProgram:
                                            # ret z       ; return if zero
      # R3 R3 LSB iyl = Program code, MSB = 0, ixl = Life
        MOV  R3,R0
        CMP  R0,$0b00000001                 # cp %00000001
        BNE  1$                             # ; Used by background, sprite bank based on X co-ord
        JMP  @$ObjectProgram_BitShiftSprite # jp z,ObjectProgram_BitShiftSprite
    1$:
        BIC  $0b00000111,R0                 # and %11111000 ;00000XXX = Powerup
        BZE  ObjectProgram_PowerUps         # jr z,ObjectProgram_PowerUps
                                            # 01101011
        CMP  $0b11110000,R0                 # cp %11110000  ;11110XXX = Animate every X frames
       #BZE  ObjectProgram_FrameAnimate     # jp z,ObjectProgram_FrameAnimate
        BIC  $0b00011111,R0                 # and %11100000
        BZE  ObjectProgram_PowerUps         # jr z,ObjectProgram_PowerUps ;0001XXXX = Smartbombable Powerup

      # # 12 words
      # ASR  R0
      # ASR  R0
      # ASR  R0
      # ASR  R0
      # JMP  @ProgramFireJumpTable-2(R0)
      #.word ObjectProgram_FastFire
      #.word ObjectProgram_MidFire
      #.word ObjectProgram_SlowFire
      #.word ObjectProgram_SnailFire
      #.word ObjectProgram_HyperFire
      #.word ObjectProgram_AboveMidFire

        # 18 words
        CMP  R0,$0b001 << 5                 # cp %00100000            ;001XXXXX = fast fire
        BEQ  ObjectProgram_FastFire         # jp z,ObjectProgram_FastFire
        CMP  R0,$0b010 << 5                 # cp %01000000            ;010XXXXX = medium fire
        BEQ  ObjectProgram_MidFire          # jp z,ObjectProgram_MidFire
        CMP  R0,$0b011 << 5                 # cp %01100000            ;011XXXXX = slow fire
        BEQ  ObjectProgram_SlowFire         # jp z,ObjectProgram_SlowFire
        CMP  R0,$0b100 << 5                 # cp %10000000            ;100XXXXX = Fastfire
        BEQ  ObjectProgram_SnailFire        # jp z,ObjectProgram_SnailFire
        CMP  R0,$0b110 << 5                 # cp %11000000            ;110XXXXX = Mid2Fire
        BEQ  ObjectProgram_AboveMidFire     # jp z,ObjectProgram_AboveMidFire
        CMP  R0,$0b101 << 5                 # cp %10100000            ;101XXXXX = Fastfire
        BEQ  ObjectProgram_HyperFire        # jp z,ObjectProgram_HyperFire
       .inform_and_hang "no ObjProg"
                                            # ld a,iyl
                                            # cp %11111100            ;Custom 1
                                            # jr z,ObjectProgram_Custom1
                                            # cp %11111101            ;Custom 2
                                            # jp z,null :CustomProgram2_Plus2
                                            # cp %11111110            ;Custom 3
                                            # jp z,null :CustomProgram3_Plus2
                                            #
                                            # cp 255
                                            # ret nz  ;Only used by ep2 for a crap joke!
        RETURN
                                        # SpecialMoveChibiko:
                                        #     push iy
                                        #     jr ObjectProgram_MovePlayerB
                                        # ObjectProgram_Custom1:
                                        #     jp null :CustomProgram1_Plus2
ObjectProgram_PowerUps:
                                        #     ld a,iyl
        BIC  $0xFFF0,R3                 #     and %00001111
                                        #     cp 4
                                        #     jr z,ObjectProgram_MovePlayer
                                        #     cp 8                ;Custom 1
                                        #     jr z,ObjectProgram_Custom1
1237$:  RETURN                          #     ret
                                        # ObjectProgram_MovePlayer: ; Used by end of level code to make player fly to a point
                                        #     ;b=x ;c=y
                                        #     push iy
                                        #
                                        #         ld iy,Player_Array2
                                        #         call ObjectProgram_DoMovePlayer
                                        # ObjectProgram_MovePlayerB:
                                        #         ld iy,Player_Array
                                        #         call ObjectProgram_DoMovePlayer
                                        #     pop iy
                                        #     ret
                                        #
                                        # ObjectProgram_DoMovePlayer:
                                        #     ld a,(iy)   ;Y
                                        #     cp c
                                        #     jr z,  ObjectProgram_MovePlayerX
                                        #     jr nc, ObjectProgram_MovePlayerYUp
                                        #     add 8
                                        #     jr ObjectProgram_MovePlayerX
                                        # ObjectProgram_MovePlayerYUp:
                                        #     sub 8
                                        # ObjectProgram_MovePlayerX:
                                        #     ld (iy),a
                                        #     ld a,(iy+1) ;X
                                        #     cp b
                                        #     jr z,  ObjectProgram_MovePlayerDone
                                        #     jr nc, ObjectProgram_MovePlayerXUp
                                        #     add 6
                                        #     jr ObjectProgram_MovePlayerDone
                                        # ObjectProgram_MovePlayerXUp:
                                        #     sub 6
                                        # ObjectProgram_MovePlayerDone:
                                        #     ld (iy+1),a
                                        #
                                        #     ret
                                        # ObjectProgram_FrameAnimate: ; Used To animate spider legs in 1st boss
                                        #     push bc
                                        #         ld a,iyl
                                        #         and %00000111
                                        #         ld b,a
                                        #         inc b
                                        #         ld a,128    ; do at least 1 shift, so result is at least 1
                                        # ObjectProgram_FrameAnimate_Bitshifts:
                                        #         rlca
                                        #         djnz ObjectProgram_FrameAnimate_Bitshifts
                                        #         ld b,a
                                        #         ld a,(Timer_CurrentTick)
                                        #         and b
                                        #     pop bc
                                        #     ret

# Every other X column uses an alternate sprite - for background anim ----------
ObjectProgram_BitShiftSprite:
                                # ld a,b
       #MOV  R4,@$SprShow_X  # ld (SprShow_X),a ; Makesure sprite pos is updated for Domoves
                                # bit 0,b ;2 pixel
1237$:  RETURN                  # ret

ObjectProgram_SnailFire:
       .equiv  FireFrequencyA, .+2
        MOV  $0b00010000,R0     # ld a,%00010000  :FireFrequencyA_Plus1
        BR   ObjectProgram_Fire # jr ObjectProgram_Fire
ObjectProgram_SlowFire:
       .equiv  FireFrequencyB, .+2
        MOV  $0b00001000,R0     # ld a,%00001000  :FireFrequencyB_Plus1
        BR   ObjectProgram_Fire # jr ObjectProgram_Fire
ObjectProgram_MidFire:
       .equiv  FireFrequencyC, .+2
        MOV  $0b00001000,R0     # ld a,%00001000  :FireFrequencyC_Plus1
        BR   ObjectProgram_Fire # jr ObjectProgram_Fire
ObjectProgram_AboveMidFire:
       .equiv  FireFrequencyD, .+2
        MOV  $0b00000100,R0     # ld a,%00000100; :FireFrequencyD_Plus1
        BR   ObjectProgram_Fire # jr ObjectProgram_Fire
ObjectProgram_FastFire:
       .equiv  FireFrequencyE, .+2
        MOV  $0b00000010,R0     # ld a,%00000010; :FireFrequencyE_Plus1

ObjectProgram_Fire:
                                       # ld d,a
                                       # ei  ; Why is interrupts disabled here??
        BIT  @$Timer_TicksOccured,R0# ld a,(Timer_TicksOccured)
        BZE  1237$                     # and d
                                       # ret z
ObjectProgram_HyperFire:
        MOV  $2,R0                         # ld a,2
        # TODO: implement QueueSFX
       #CALL @$SFX_QueueSFX_Generic        # call SFX_QueueSFX_Generic
        # B=R4=X, C=R1=Y, IYL=R3=Prg       #
        MOV  @$SpriteSizeShiftHalfB,R2  # ld a,(SpriteSizeShiftHalfB_Plus1 - 1)
        ADD  R2,R1                         # ld d,a
                                           # add c
                                           # ld c,a
                                           # ld a,d
        RORB R2                            # rrca
        RORB R2                            # rrca
        ADD  R4,R2                         # add b
                                           # ld d,a
                                           # ld a,iyl
        BIC  $0xFFE0,R3                    # and %00011111
        # B = R3 = pattern (0-15)          # ld b,a  ; top left
        # C = R1 = Y pos                   #
        # D = R2 = X pos                   # FireCustomStar:
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
        CALL @$null                        # call null :CustomShotToDeathCall_Plus2
                                           # xor a
        BIC  $0xFF00,(R5)                  # ld (hl),a ;Clear object animator
                                           #
        # TODO: implement sfx              # ld a,3
                                           # call SFX_QueueSFX_Generic
      # create a coin
       .equiv PointsSpriteC, .+2
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
        MOV (PC)+,R2
       .byte 128+16     # ld iyh,128+16 :PointsSpriteC_Plus1  ; Sprite
       .byte 0b10000111 # ld ixh,%10000111 ; Seaker Fast 1000001XX XX=Speed

                        # ld a,(ObjectShotShooter_Plus1-1)    ;1=Player 1, 129 = player 2
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
