
#*****************************************************************************#
#*                              player Handler                               *#
#*****************************************************************************#
                                        #
                                        # Player_GetHighscore:
                                        #     ld hl,HighScoreBytes
                                        #     ret
# Player_GetPlayerVars:                 # Player_GetPlayerVars:
#         MOV  $Player_Array,R5         #     ld iy,Player_Array
#         RETURN                        # ret
                                        #     ; iy = Pointer to player vars

# Both players are dead, so pause the game and show the continue screen
PlayersDead:
        MOV  $0x8001,R5
        JMP  ExecuteBootstrap

PlayerHandler:
      # Used to update the live player count
        CLR  R0                         # xor a

PlayerCounter:
        INC  R0 # or NOP if player 1 is dead # inc a
                # bootstrap StartANewGame writes INC R0
   .ifdef TwoPlayersGame
        INC  R0 # or NOP if player 2 is dead # inc a
   .endif
        MOVB R0,@$LivePlayers
        BZE  PlayersDead

        MOV  $NOP_OPCODE,@$PlayerCounter
   .ifdef TwoPlayersGame
        MOV  $NOP_OPCODE,@$PlayerCounter+2
   .endif

        MOV  $Player_Array,R5
        TSTB 9(R5)

        BNZ  Player1NotDead
      # player 1 is dead if for some reason we got here
        RETURN

Player1NotDead:
        MOV  $INC_R0_OPCODE,@$PlayerCounter

Player_HandlerOne:
      # Check if the game is paused
        TSTB @$KeyboardScanner_P1
        BPL  Player_Handler_PauseCheckDone

        CheckIfPauseKeyReleased:
            TSTB @$KeyboardScanner_P1
        BMI  CheckIfPauseKeyReleased

        COM  @$Timer_Pause # Z=normal, NZ=paused

1237$:  RETURN

Player_Handler_PauseCheckDone:
        MOV  @$Timer_TicksOccured,R0
        BZE  1237$  # abort handler if game paused

        CLR  @$PlayerSaveShot
        CLR  @$PlayerDoFire

        BITB 11(R5),R0 # fire speed
        BZE  Player_Handler_Start

        CLRB 2(R5) # shoot delay

      # Move the drones depending if the player is shooting
Player_Handler_Start:
        MOVB 6(R5),R0 # drone pos
        CMPB R0,$16
        BHIS Player_Handler_DronePosOk
        INCB R0
Player_Handler_DronePosOk:
        MOVB R0,6(R5) # D1 - shots and drones
        ASLB R0
        MOVB R0,@$Player_DroneOffset1

        MOV  (R5),R2
        CLR  R1
        BISB R2,R1
        CLRB R2
        SWAB R2 # R1=Y, R2=X
       .equiv PlayerMoveSpeedFast, .+2
        MOV  $8,R3 # Fast move speed - will be overriden if we're firing

        MOV  @$KeyboardScanner_P1,R4
        ROLB R4 # push out pause bit

        ROLB R4 # push out fire left bit
        BCC  Player_Handler_KeyreadJoy1Fire2

        ROLB R4 # push out fire right bit
        BCC  Player_Handler_KeyreadJoy1Fire1

      # Xfire is a secret feature planned for the sequel
      # it activates when both fire buttons are pressed
       #CALL Player_Handler_FireX
        BR   Player_Handler_KeyreadJoy1Left

Player_Handler_KeyreadJoy1Fire1: # Fire right
       .equiv Fire1Handler, .+2
        CALL @$SetFireDir_LEFTsave # fire bullets

       .equiv PlayerMoveSpeedSlow1, .+2
        MOV  $2,R3 # slow move speed as we're firing
        BR   Player_Handler_KeyreadJoy1Left

Player_Handler_KeyreadJoy1Fire2: # Fire left
        ROLB R4 # push out fire right bit
        BCC  Player_Handler_KeyreadJoy1Left

       .equiv Fire2Handler, .+2
        CALL @$SetFireDir_RIGHTsave # fire bullets

       .equiv PlayerMoveSpeedSlow2, .+2
        MOV  $2,R3 # Slow move speed as we're firing

Player_Handler_KeyreadJoy1Left:
        ROLB R4 # push out move left bit
        BCC  Player_Handler_KeyreadJoy1Right

        CMP  R2,$24+ 12 # Check we're onscreen
        BLO  Player_Handler_KeyreadJoy1Right

        SUB  R3,R2
       .equiv FireLeftHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Right:
        ROLB R4 # push out move right bit
        BCC  Player_Handler_KeyreadJoy1Up

        CMP  R2,$24+ 160-12 # Check we're onscreen
        BHIS Player_Handler_KeyreadJoy1Up

        ADD  R3,R2
       .equiv FireRightHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Up:
        ROLB R4 # push out move up bit
        BCC  Player_Handler_KeyreadJoy1Down

        CMP  R1,$24+ 24 # Check we're onscreen
        BLO  Player_Handler_KeyreadJoy1Down

        SUB  R3,R1
       .equiv FireUpHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Down:
        ROLB R4 # push out move down bit
        BCC  Player_Handler_SmartBomb

        CMP  R1,$24+ 200-16 # Check we're onscreen
        BHIS Player_Handler_SmartBomb

        ADD  R3,R1
       .equiv FireDownHandler, .+2
        CALL @$null

Player_Handler_SmartBomb: # Check if we should fire the smarbomb
        ROLB R4 # push out smartbomb bit
        BCC  Player_Handler_KeyreadDone

        TST  @$SmartBombTimer # smartbomb active?
        BNZ  Player_Handler_KeyreadDone

        TSTB 3(R5) # see if we've got any smartbombs left
        BZE  Player_Handler_KeyreadDone

        DECB 3(R5)
        CALL Player_Handler_DoSmartBomb

Player_Handler_KeyreadDone:
       .equiv PlayerSaveShot, .+2
        TST  $0
        BZE  Player_Handler_NoSaveFire
       .equiv PlayerThisSprite, .+2
        MOVB $0,8(R5) # player sprite num
       .equiv PlayerThisShot, .+2
        MOVB $0,15(R5) # fire direction
Player_Handler_NoSaveFire:
        MOVB 8(R5),R0 # player sprite num
        BIC  $0xFF7F,R0
       .equiv DroneFlipCurrent, .+2
        CMP  R0,$1 # ResetCore sets it to 0x69 ../bootstrap.s:370
        BZE  1$
        CALL DroneFlip
   1$:
       .equiv PlayerDoFire, .+2
        TST  $0
        BZE  2$
        CALL Player_Fire4D
   2$:
        MOVB R1,(R5)+ # Y
        MOVB R2,(R5)  # X
        DEC  R5
        CLR  R3
       .equiv PlayerSpriteAnim, .+2
        BIT  $0b00000010,@$Timer_CurrentTick
        BZE  Player_Handler_Frame1

        INC  R3
Player_Handler_Frame1:
       .equiv DroneDirPos8, .
        MOV  R2,R0 # or MOV  R1,R0
        SUB  $4,R0
       .equiv dstDroneDirPos1, .+2
        MOV  R0,@$SprShow_X # or SprShow_Y
        TSTB 4(R5)
        BZE  Player_Handler_NoDrones

        MOV  $4,R0
        ADD  R3,R0
        MOV  R0,@$SprShow_SprNum

        PUSH R5 # player array pointer
        PUSH R3 # frame number
        PUSH R2 # X
        PUSH R1 # Y
        BITB $0b10,4(R5)
        BZE  Player_Handler_OneDrone

        MOV  $-12,R0
       .equiv Player_DroneOffset1, .+2
        SUB  $16,R0
        CALL @$SetDronePos
        CALL @$ShowSprite

Player_Handler_OneDrone:
        MOV  @$Player_DroneOffset1,R0
       .equiv DroneDirPos7, .
        MOV  (SP),R1 # or MOV  2(SP),R2
        NOP
        CALL @$SetDronePos
        CALL @$ShowSprite
        POP  R1
        POP  R2
        POP  R3
        POP  R5

Player_Handler_NoDrones:
        MOV  R2,R0 # X
        SUB  $7,R0
        MOV  R0,@$SprShow_X
        TSTB 7(R5) # invincibility
        BZE  Player_NotInvincible

        MOV  @$Timer_TicksOccured,R0
        BIT  $0b0010,R0
        BZE  Player_NotInvincible # invincible flash

        BIT  $0b0100,R0
        BZE  Player_SpriteSkip

        DECB 7(R5) # invincibility

Player_SpriteSkip:
        RETURN

Player_NotInvincible:
      # draw the player
        MOVB 8(R5),R0 # player sprite num
        BIC  $0xFFF0,R0
        ADD  R3,R0 # add frame number
        MOV  R0,@$SprShow_SprNum
        SUB  $18,R1
        MOV  R1,@$SprShow_Y
        CALL @$ShowSprite

        RETURN

SetDronePos:
      # C = R1 = Y
      # B = R2 = X
       .equiv DroneDirPos5, .
        NOP # or ASR R0
       .equiv DroneDirPos2, .
        ADD  R1,R0 # or ADD R2,R0
       .equiv DroneDirPos6, .+2
        MOV  R0,@$SprShow_Y # or SprShow_X
        RETURN

                                        # Player_Fire_OneBurst:
                                        #     push de
                                        #     push bc
                                        #         or 0:PlayerNumBurst_Plus1
                                        #         call Stars_AddObjectFromA
                                        #     pop bc
                                        #     pop de
                                        # ret

                                        # Player_Handler_FireX:
                                        # ;   ret     ;disable this firemode
                                        #     ld a,(iy+2) ;D1
                                        #     or a;   bit 7,a ; check if player is allowed to fire
                                        #     ret nz
                                        #     ld (iy+2),255   ; Set player can't fire
                                        #
                                        #     call Stars_AddToPlayer
                                        #
                                        #     ld a,(iy+10) ; Burst Fire counter
                                        #     sub 1
                                        #     ret c
                                        #
                                        #     ld (iy+10),a ; Burst Fire counter
                                        #     ld hl,Xfire
                                        #     cp 50
                                        #     jr NC,NotSmallBurst
                                        #         ld hl,XfireSml
                                        # NotSmallBurst:
                                        #     ld a,(iy+12)
                                        #     ld (PlayerNumBurst_Plus1-1),a
                                        #     push iy
                                        #         ld d,b
                                        #
                                        #         ld iy,Player_Fire_OneBurst
                                        #         call OuterBurstPatternLoop
                                        #
                                        #     pop iy
                                        #
                                        #     ld e,2
                                        #     jr FireSfx

        # Xfire:
        #     defb &7C,&4C,&67,&61
        # XfireSml:
        #     defb &49,&4F,&79,&7F,0

      # input  C = R1 = Y
      #        B = R2 = X
      #        IY = R5 = Player_Array pointer
      #        R0, R3, R4 free
Player_Fire4D: # Fire bullets!
        MOVB 8(R5),R0 # player sprite num
        BIC  $0xFF7F,R0
       .equiv DroneFlipFireCurrent, .+2
        CMP  R0,$0 # drones placement Z=vertical, NZ=horizontal
        BEQ  1$
        CALL DroneFlipFire
   1$:
        MOVB 15(R5),R0 # fire dir
# Player_Fire: Fire bullets!
        BISB 12(R5),R0 # player num
        MOV  R0,@$StarObjectMoveToAdd

        MOVB 6(R5),R0 # Move the drones in when fire is held
        DECB R0
        DECB R0
        BNZ  Player_Handler_KeyreadJoy1Fire2_DroneLimit
        INCB R0 # Drone at Max 'innness'!

Player_Handler_KeyreadJoy1Fire2_DroneLimit:
        MOVB R0,6(R5)    # drone pos
        BITB $0x80,2(R5) # check if player is allowed to fire
        BNZ  1237$

        BISB $0x80,2(R5)

        CALL Stars_AddToPlayer
      # input C = R1 = Y
      #       D = R2 = X
        CALL Stars_AddObject

      # drone1
        MOV  @$Player_DroneOffset1,R3
        ADD  $4,R3
       .equiv DroneFlipFirePos5, .
        NOP # or ROR R3 for horizontal drones placement

      # Add extra stars depending on how many drones we have
        MOVB 4(R5),R0 # number of drones
        BZE  Player_NoDrones

        DEC  R0
        BZE  Player_OneDrone

        PUSH R3
        MOV  R3,R0
        NEG  R0
        CALL dodrone
        POP  R3
      # drone2
Player_OneDrone:
        MOV  R3,R0
        CALL dodrone
Player_NoDrones:

       .ppudo $PPU_PlaySoundEffect1
1237$:  RETURN

dodrone:
      # C = R1 = Y
      # B = R2 = X
      # ResetCore sets to add a,c
       .equiv DroneFlipFirePos3, .
        ADD  R0,R1
        CALL Stars_AddObject
       .equiv DroneFlipFirePos2, .
        SUB  R0,R1
        RETURN

DroneFlipFire:
        MOV  R0,@$DroneFlipFireCurrent
        BNZ  1$
      # vertical drones placement
        MOV  $0060001,@$DroneFlipFirePos3 # ADD R0,R1
        MOV  $0160001,@$DroneFlipFirePos2 # SUB R0,R1
        MOV  $0000240,@$DroneFlipFirePos5 # NOP
        RETURN
   1$:# horizontal drones placement
        MOV  $0060002,@$DroneFlipFirePos3 # ADD R0,R2
        MOV  $0160002,@$DroneFlipFirePos2 # SUB R0,R2
        MOV  $0006003,@$DroneFlipFirePos5 # R0R R3
        RETURN

DroneFlip:
      # C = R1 = Y
      # B = R2 = X
        MOV  R0,@$DroneFlipFireCurrent
        BNZ  1$
      # vertical drones placement
        MOV  $SprShow_X,@$dstDroneDirPos1
        MOV  $0060100,@$DroneDirPos2     # ADD R1,R0
        MOV  $0000240,@$DroneDirPos5     # NOP
        MOV  $SprShow_Y,@$DroneDirPos6
        MOV  $0011601,@$DroneDirPos7     # MOV (SP),R1
        MOV  $0000240,@$DroneDirPos7+2   # NOP
        MOV  $0010200,@$DroneDirPos8     # MOV R2,R0
        RETURN
   1$:# horizontal drones placement
        MOV  $SprShow_Y,@$dstDroneDirPos1
        MOV  $0060200,@$DroneDirPos2    # ADD R2,R0
        MOV  $0006200,@$DroneDirPos5    # ASR R0
        MOV  $SprShow_X, @$DroneDirPos6
        MOV  $0016602,@$DroneDirPos7    # MOV 2(SP),R2
        MOV  $2,@$DroneDirPos7+2
        MOV  $0010100,@$DroneDirPos8    # MOV R1,R0
        RETURN

SetFireDir_UP:
        MOV  $0x82,@$PlayerThisSprite
        MOV  $0x4C,@$PlayerThisShot
        RETURN

 SetFireDir_DOWN:
        MOV  $0x80,@$PlayerThisSprite
        MOV  $0x7C,@$PlayerThisShot
        RETURN

SetFireDir_LEFTsave:
        CALL SetFireDir_FireAndSave
SetFireDir_LEFT:
        MOV  $0x02,@$PlayerThisSprite
        MOV  $0x61,@$PlayerThisShot
        RETURN

SetFireDir_RIGHTsave:
        CALL SetFireDir_FireAndSave
SetFireDir_RIGHT:
        MOV  $0x00,@$PlayerThisSprite
        MOV  $0x67,@$PlayerThisShot
        RETURN

SetFireDir_FireAndSaveRestore:
        MOVB 8(R5), @$PlayerThisSprite
        MOVB 15(R5),@$PlayerThisShot
SetFireDir_FireAndSave:
        MOV  $0x67,R0
        MOV  R0,@$PlayerSaveShot
SetFireDir_Fire:
        MOV  R0,@$PlayerDoFire

        RETURN

# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;;                               Smart Bomb                                   ;;
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      # R0, R3, R4 are free to use
      # R1 player Y
      # R2 player X
      # R5 player array pointer
Player_Handler_DoSmartBomb:
        MOV  $5,@$SmartBombTimer
       .ppudo $PPU_PlaySoundEffect5

        MOV  $StarArraySizeBytes >> 2,R3
        MOV  $StarArrayPointer,R4
        100$:
            CLR  (R4)+
            CLR  (R4)+
        SOB  R3,100$

      # We can hack in our own smartbomb handler this is needed to wipe omega
      # array for final boss as it's not handled by normal core code
       .equiv dstSmartBombSpecial, .+2
        CALL @$null

        MOV  $ObjectArraySize,R3
        MOV  $ObjectArrayPointer,R4
      # we need special code because we don't want to wipe
      # bg objects and boss sprites
Player_Handler_SmartBomb_ObjLoop:
        MOVB 4(R4),R0    # Life
        BZE  Player_Handler_SmartBomb_NextObj # life (0 is background)
        INCB R0
        BZE  Player_Handler_SmartBomb_NextObj # ???

       .equiv dstCustomSmartBombEnemy, .+2
        CALL @$null

        MOVB 5(R4),R0    # Program
        BZE  Player_Handler_SmartBomb_Kill

        CMPB R0,$16      # Program 1-31 are protected from smartbomb
        BLO  Player_Handler_SmartBomb_NextObj

Player_Handler_SmartBomb_Kill:
      # we need to kill this object if we got here
        INC  R4
        INC  R4
       .equiv PointsSpriteB, .+3
        MOV  (PC)+,(R4)+
       .byte mveSeaker_P1 | 0b11 # Seaker Fast 1000001XX XX=Speed
       .byte 128+16      # Sprite
        MOV  (PC)+,(R4)+
       .byte 64+63       # Life, must "hurt" player for hit to be detected
       .byte 3           # Program
        INC  R4
        CLRB (R4)+       # Animator

        SOB  R3,Player_Handler_SmartBomb_ObjLoop
        RETURN

Player_Handler_SmartBomb_NextObj:
        ADD  $8,R4
        SOB  R3,Player_Handler_SmartBomb_ObjLoop
        RETURN
#-------------------------------------------------------------------------------
Player_Hit: #-------------------------------------------------------------------
      # R0 use at will
      # R1 LSB b = X, R1 MSB c = Y
      # R2 LSB ixh = Sprite, R2 MSB iyh = Move
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
      # R4 use at will
      # R5 points to Player_Array
        MOV  R3,R0
        SWAB R0
        CMPB R0,$16+2
        BNZ  Player_Hit_SkipCustomPlayerHitter

       .equiv dstCustomPlayerHitter, .+2
        CALL @$null

Player_Hit_SkipCustomPlayerHitter:
        CMPB R0,$3
        BNZ  Player_Hit_Injure

      # we hit a powerup if we got here
        CLR  R1 # remove the powerup
       .equiv DroneSprite, .+2
        CMPB R2, $128+38
        BEQ  Player_Hit_PowerupDrone

       .equiv ShootSpeedSprite, .+2
        CMPB R2, $128+39
        BEQ  Player_Hit_PowerupShootSpeed

       .equiv ShootPowerSprite, .+2
        CMPB R2, $128+40
        BEQ  Player_Hit_PowerupShootPower

       .equiv PointsSpriteA, .+2
        CMPB R2, $128+16
        BEQ  Player_Hit_Points

        RETURN

Player_Hit_Points:
       .ppudo $PPU_PlaySoundEffect6
      # Object is Points for player
       #MOVB 13(R5),R0
       #ADD  $5,R0
       #MOVB R0,13(R5)
        MOVB @$P1_P13,R0
        ADD  $COIN_COST,R0
        MOVB R0,@$P1_P13
        RETURN

Player_Hit_PowerupShootSpeed:
        MOVB @$P1_P11,R0
        RORB R0
        BNZ  Player_Hit_PowerupShootSpeedNZ

        INCB R0
Player_Hit_PowerupShootSpeedNZ:
        MOVB R0,@$P1_P11
        BR   PowerupPlaySfx

Player_Hit_PowerupDrone:
        CMPB @$P1_P04,$2
        BHIS Player_Hit_PowerupDroneFull
        INC  @$P1_P04

Player_Hit_PowerupDroneFull:
        BR   PowerupPlaySfx

Player_Hit_PowerupShootPower:
        MOV  $0x0303,@$PlayerStarColor0
        MOV  $0x3030,@$PlayerStarColor1
   .ifdef TwoPlayersGame
        MOVB $1,@$P2_P14 # power up both players
   .endif
        MOVB $1,@$P1_P14
PowerupPlaySfx:
       .ppudo $PPU_PlaySoundEffect7
        RETURN

Player_Hit_Injure:
        MOV  R5,R0
        BR   Player_Hit_Process

   .ifdef TwoPlayersGame
Player_Hit_Injure_2:
        MOV  $Player_Array2,R0
        BR   Player_Hit_Process
   .endif

Player_Hit_Injure_1:
        MOV  $Player_Array,R0

Player_Hit_Process:
        TSTB 7(R0) # invincible?
   .ifdef PlayerInvincible
        BR   1237$
   .else
        BNZ  1237$
   .endif

      # negative number of lives causes PPU's Player_DrawUI to crash
      # check if the player already dead before subtracting
        TSTB 9(R0) # lives
        BZE  1237$ # player already dead, do nothing
        DECB 9(R0) # lives
        BZE  1237$ # player killed
        MOVB $0x07,7(R0)
       .ppudo $PPU_PlaySoundEffect4
1237$:  RETURN
#-------------------------------------------------------------------------------
# Continue Screen messes all registers
# so we have to call this after PlayerHandler
Player_DrawUI:
      # Bootstrap_ContinueScreen expects Player_Array pointer in R4
        MOV  $Player_Array,R4
        TSTB 9(R4) # see how many lives are left
        BNZ  1237$

        TSTB 5(R4) # see how many credits are left
        BZE  Player_GameOver

        MOV  $0x8001,R5 # Continue Screen
        CALL @$ExecuteBootstrap

1237$:  RETURN

Player_GameOver:
        MOV  $0x8001,R5 # Game Over Screen
        JMP  @$ExecuteBootstrap

      # CHEAT MODE!
      # Sssh, we set cheats here - as some levels steal our powerups,
      # done During the level not before
                                        #     ld a,2
                                        #     ld (P1_P04),a
                                        #     ld a,&96
                                        #     ld (PlayerStarColor_Plus1-1),a
                                        #     ld a, 1 ;(Dec A)
                                        #     ld (P1_P14),a
                                        #     ld a,%00000001
                                        #     ld (P1_P11),a
                                        # ret
