
#*****************************************************************************#
#*                              player Handler                               *#
#*****************************************************************************#
                                        #
                                        # Player_GetHighscore:
                                        #     ld hl,HighScoreBytes
                                        #     ret
# Player_GetPlayerVars:                   # Player_GetPlayerVars:
#         MOV  $Player_Array,R5           #     ld iy,Player_Array
#         RETURN                          # ret
                                        #     ; iy = Pointer to player vars
NoSpend:                                # NoSpend:
        MOV  R0,@$SpendTimeout       #     ld (SpendTimeout_Plus1-1),a
        RETURN                          # ret
                                        #
SpendCheck:                             # SpendCheck:
       .equiv SpendTimeout, .+2
        MOV  $1,R0                      # ld a,1:SpendTimeout_Plus1 ;Dont let player continue right away!
        DEC  R0                         # dec a
        BNZ  NoSpend                    # jr nz,NoSpend
                                        #
        BIT  $Keymap_AnyFire,@$KeyboardScanner_P1 # ld a, ixl ; read the keymap
                                        # or Keymap_AnyFire
                                        # inc a
        BNZ  SpendCredit                # ret z
        RETURN                          #
SpendCredit:                            # SpendCredit:
         PUSH R5                        #  push iy
        SpendCreditSelfMod:             # SpendCreditSelfMod:
         MOV  $Player_Array,R5          #      ld iy,Player_Array ; All credits are (currently) stored in player 1's var!
         MOVB 5(R5),R0                  #      ld a,(iy+5)
         DECB R0                        #      sub 1
         POP  R4                        #  pop ix
         BMI  1237$                     #  ret c ;no credits left!

         MOVB R0,5(R5)                  #  ld (iy+5),a
                                        #  ld a,3
         MOVB $3,9(R4) # lives          #  ld (ix+9),a
                                        #  ld a,(SmartbombsReset)
         MOVB @$SmartBombsReset,3(R4)   #  ld (ix+3),a
1237$:   RETURN                         # ret

# Both players are dead, so pause the game and show the continue screen
PlayersDead:                            # Players_Dead:
        RETURN # TODO: implement PlayersDead
                                        # ld a,&3C
                                        # ld (PlayerCounter),a
                                        # ld hl,(&0039)
                                        # push hl
                                        #     ld hl,&0001
                                        #     call ExecuteBootStrap
                                        # pop hl
                                        # ld (&0039),hl
                                        # jp ScreenBuffer_Init

PlayerHandler:
        # Used to update the live player count
        CLR  R0                         # xor a

PlayerCounter:
        INC  R0 # or NOP if player 1 is dead # inc a
       #INC  R0 # or NOP if player 2 is dead # inc a
        MOVB R0,@$LivePlayers           #     ld (LivePlayers),a
                                        #     or a
        BZE  PlayersDead                #     jr z, Players_Dead

        MOV  $000240,@$PlayerCounter    #     ld hl,&0000     ;nop,nop
       #MOV  $000240,@$PlayerCounter+2  #     ld (PlayerCounter),hl
                                        #     call KeyboardScanner_Read
                                        #     ; returns
                                        #     ; ixl = Keypress bitmap Player
                                        #     ; HL Direct pointer to the keymap
                                        #     call Player_ReadControls

        MOV  $Player_Array,R5           #     ld iy,Player_Array
        TSTB 9(R5)                      #     ld a,(P1_P09)   ;See how many lives are left
                                        #     or a
        BNZ  Player1NotDead             #     jr nz,Player1NotDead
        #* if, for some reason we got here, player 1 is dead
        RETURN                          #     ;if we got here, player 1 is dead
                                        #
                                        #     call SpendCheck
                                        #     jr Player2Start
                                        #
Player1NotDead:                         # Player1NotDead:
        MOV  $0005200,@$PlayerCounter   #     ld a,&3C
                                        #     ld (PlayerCounter),a
                                        #
       #MOV  $ChibiSprites,R5           #     ld hl,Akuyou_PlayerSpritePos
                                        #     ld de,&C0C0
                                        #
                                        #     xor a
                                        #     ld b,4
                                        #     call Player_HandlerOne
                                        #     call BankSwitch_C0_SetCurrentToC0
                                        #
                                        # Player2Start:
                                        #     call Player_ReadControls2
                                        #
                                        #     ld iy,Player_Array2
                                        #     ld a,(P2_P09)
                                        #     or a
                                        #     jp z,SpendCheck
                                        #
                                        # Player2NotDead:
                                        #     ld a,&3C
                                        #     ld (PlayerCounter+1),a
                                        #
                                        #     ld de,&C0C0
                                        #     ld hl,Akuyou_PlayerSpritePos ; ChibikoPlayerSpriteBank_Plus2
                                        #
                                        ##ifdef DualChibikoHack
                                        #     jr Player2NotDead64kver
                                        ##endif
                                        #
                                        # Player2NotDead64kver:
                                        #     ld a,12
                                        #     ld b,16
                                        #     call Player_HandlerOne
                                        #
                                        #     jp BankSwitch_C0_SetCurrentToC0
Player_HandlerOne:                      # Player_HandlerOne:
       #MOV  R5,@$SprShow_BankAddr      #     ld (SprShow_BankAddr),hl
                                        #     ld a,e
                                        #     ld (PlayerSpriteBank_Plus1-1),a; call Akuyou_BankSwitch_C0_SetCurrent
                                        #     ld a,ixl
      # Check if the game is paused
        BIT  $Keymap_Pause, @$KeyboardScanner_P1
        BZE  Player_Handler_PauseCheckDone

   1$:  BIT  $Keymap_Pause, @$KeyboardScanner_P1
        BNZ  1$
        COM  @$Timer_Pause # Z=normal, NZ=paused

1237$:  RETURN

Player_Handler_PauseCheckDone:
        MOV  @$Timer_TicksOccured,R0
        BZE  1237$  # abort handler if game paused
                                       # xor a
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

        MOV  @$KeyboardScanner_P1,R0
# SelfModifyingFire1:
        BIT  $Keymap_F2,R0
        BZE  Player_Handler_KeyreadJoy1Fire2
        # fire bullets
# SelfModifyingFire2:
        BIT  $Keymap_F1,R0
        BZE  Player_Handler_KeyreadJoy1Fire1

      # Xfire is a secret feature planned for the sequel
      # it activates when both fire buttons are pressed
       #CALL Player_Handler_FireX
        BR   Player_Handler_KeyreadJoy1Up

Player_Handler_KeyreadJoy1Fire1: # Fire right
       .equiv Fire1Handler, .+2
        CALL @$SetFireDir_LEFTsave # fire bullets

       .equiv PlayerMoveSpeedSlow1, .+2
        MOV  $2,R3 # slow move speed as we're firing
        BR   Player_Handler_KeyreadJoy1Up

Player_Handler_KeyreadJoy1Fire2: # Fire left
# SelfModifyingFire1B: # supposed to be reset from bootstrap
        BIT  $Keymap_F1,R0
        BZE  Player_Handler_KeyreadJoy1Up

       .equiv Fire2Handler, .+2
        CALL @$SetFireDir_RIGHTsave # fire bullets

       .equiv PlayerMoveSpeedSlow2, .+2
        MOV  $2,R3 # Slow move speed as we're firing
Player_Handler_KeyreadJoy1Up:
        BIT  $Keymap_Up,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadJoy1Down
        CMP  R1,$24+ 24 # Check we're onscreen
        BLO  Player_Handler_KeyreadJoy1Down

        SUB  R3,R1
       .equiv FireUpHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Down:
        BIT  $Keymap_Down,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadJoy1Left

        CMP  R1,$24+ 200-16 # Check we're onscreen
        BHIS Player_Handler_KeyreadJoy1Left

        ADD  R3,R1
       .equiv FireDownHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Left:
        BIT  $Keymap_Left,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadJoy1Right

        CMP  R2,$24+ 12 # Check we're onscreen
        BLO  Player_Handler_KeyreadJoy1Right

        SUB  R3,R2
       .equiv FireLeftHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Right:
        BIT  $Keymap_Right,@$KeyboardScanner_P1
        BZE  Player_Handler_SmartBomb

        CMP  R2,$24+ 160-12 # Check we're onscreen
        BHIS Player_Handler_SmartBomb

        ADD  R3,R2
       .equiv FireRightHandler, .+2
        CALL @$null

Player_Handler_SmartBomb: # Check if we should fire the smarbomb
        BIT  $Keymap_F3,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadDone

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
        MOV  8(R5),R0 # player sprite num
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
                                     # FireSfx:
      # TODO: implement sound effect #     ld a,1
1237$:  RETURN                       #     jp SFX_QueueSFX_Generic

dodrone:
      # C = R1 = Y
      # B = R2 = X
      # ResetCore sets to add a,c
       .equiv DroneFlipFirePos3, .
        ADD  R0,R2
        CALL Stars_AddObject
       .equiv DroneFlipFirePos2, .
        SUB  R0,R2
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

                                                            # DoSmartBombCall:
                                                            #     ; a=2 All FX
                                                            #     ; a=1 no sound, screen flash
                                                            #     ; a=0 No FX
                                                            #     push af
                                                            #     call DoSmartBomb
                                                            #     pop af
                                                            #     jr DoSmartBombFX

# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;;                               Smart Bomb                                   ;;
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      # R0, R3, R4 are free to use
      # R1 player Y
      # R2 player X
      # R5 player array pointer
Player_Handler_DoSmartBomb:
        MOV  $5,@$SmartBombTimer
    # TODO: implement smartbomb SFX     #     ld a,5
                                        #     jp SFX_QueueSFX_GenericHighPri


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

       .equiv  dstCustomSmartBombEnemy, .+2
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
       .byte 0b10000111  # Seaker Fast 1000001XX XX=Speed
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
                                        # ld (PlayerHitMempointer_Plus2 - 2),hl
        MOV  R3,R0                      # ld a,iyl
        SWAB R0
        CMPB R0,$16+2                   # cp 16+2
        BNZ  1$
       .equiv  dstCustomPlayerHitter, .+2
        CALL @$null                     # call z,null :customPlayerHitter_Plus2
    1$:
        CMPB R0,$3                      # cp 3
        BNZ  Player_Hit_Injure          # jp nz,Player_Hit_Injure
                                        #
      # we hit a powerup if we got here
        CLR  R1                         # ld b,0  ; remove the powerup
                                        # ld c,b
                                        # ld d,b
                                        # ld a,iyh
       .equiv DroneSprite, .+2
        CMPB R2, $128+38                 # cp 128+38   :DroneSprite_Plus1
        BEQ  Player_Hit_PowerupDrone     # jr z,Player_Hit_PowerupDrone
       .equiv ShootSpeedSprite, .+2
        CMPB R2, $128+39                 # cp 128+39   :ShootSpeedSprite_Plus1
        BEQ  Player_Hit_PowerupShootSpeed# jr z,Player_Hit_PowerupShootSpeed
       .equiv ShootPowerSprite, .+2
        CMPB R2, $128+40                 # cp 128+40   :ShootPowerSprite_Plus1
        BEQ  Player_Hit_PowerupShootPower# jr z,Player_Hit_PowerupShootPower
       .equiv PointsSprite, .+2
        CMPB R2, $128+16                 # cp 128+16   :PointsSprite_Plus1
        BEQ  Player_Hit_Points           # jr z,Player_Hit_Points
        RETURN                           # ret

Player_Hit_Points:
        # TODO: add sfx
                                        # ld a,6
                                        # call SFX_QueueSFX_GenericHighPri
      # Object is Points for player
                                        # push bc
       #MOVB 13(R4),R0                  #     ld bc,13
       #ADD  $5,R0                      #     add hl,bc
       #MOVB R0,13(R4)                  #     ld a,(hl)
        MOVB @$P1_P13,R0                #     add 5
        ADD  $5,R0                      #     ld (hl),a
        MOVB R0,@$P1_P13                # pop bc
        RETURN                          # ret

Player_Hit_PowerupShootSpeed:
                                            # push iy
                                            # ld iy,(PlayerHitMempointer_Plus2-2)
        MOVB @$P1_P11,R0                    # ld a,(iy+11)
        RORB R0                             # srl a
                                            # or a
        BNZ  Player_Hit_PowerupShootSpeedNZ # jr nz,Player_Hit_PowerupShootSpeedNZ
        INCB R0                             # inc a ; dont let a=0
Player_Hit_PowerupShootSpeedNZ:
        MOVB R0,@$P1_P11                    # ld (iy+11),a
                                            # pop iy
        BR   PowerupPlaySfx                 # jr PowerupPlaySfx
                                            #
Player_Hit_PowerupDrone:
                                        # push iy
                                        # ld iy,(PlayerHitMempointer_Plus2-2)
                                        # ld a,(iy+4)
        CMPB @$P1_P04,$2                # cp 2
        BHIS Player_Hit_PowerupDroneFull# jr nc,Player_Hit_PowerupDroneFull
        INC  @$P1_P04                   # inc a
                                        # ld (iy+4),a
Player_Hit_PowerupDroneFull:
                                        # pop iy
        BR   PowerupPlaySfx             # jr PowerupPlaySfx
Player_Hit_PowerupShootPower:
        MOV  $0x0303,@$PlayerStarColor0
        MOV  $0x3030,@$PlayerStarColor1
                                        #         ld a,&96
                                        #         ld (PlayerStarColor_Plus1 - 1),a
                                        #
                                        #         ld a, 1
                                        # ;       power up both players
                                        #         ld (P2_P14),a
        MOVB $1,@$P1_P14                #         ld (P1_P14),a
PowerupPlaySfx:
        RETURN
                                        #         ld a,7
                                        #         jp SFX_QueueSFX_GenericHighPri
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
        BNZ  1237$

        DECB 9(R0) # lives
        BMI  1237$ # player already dead if below zero
        BZE  PlayerKilled
        MOVB $0x07,7(R0)                # ld a,4
      # TODO: play SFX                  # call SFX_QueueSFX_GenericHighPri
1237$:  RETURN

PlayerKilled:
                                           # xor a
        CLRB 3(R0)                         # ld (iy+3),a
                                           # pop iy
                                           # ld a,20
        MOV  $20,@$SpendTimeout            # ld (SpendTimeout_Plus1-1),a
                                           # ld a,100
        MOV  $100,@$ShowContinueCounter    # ld (ShowContinueCounter_Plus1-1),a
        RETURN                             # ret

#******************************************************************************#
#*                                  Player UI                                 *#
#******************************************************************************#
Player_DrawUI_DrawIcons: # Used for Health and Smartbomb icons
        TST  R0 # number of icons to draw
        BZE  1237$

        100$:
            MOVB R2,@$SprShow_ScrWord
            MOV  R1,@$SprShow_ScrLine
            PUSH R0
            PUSH R1
            PUSH R2
            CALL ShowSpriteDirect
            POP  R2
            POP  R1
            POP  R0

           .equiv Player_DrawUI_DrawIcons_IconWidth, .+2
            ADD  $4,R2
        SOB  R0,100$

1237$:  RETURN

Player1DoContinue:
       .equiv ShowContinueCounter, .+2
        TST  $0                           # ld a,(ShowContinueCounter_Plus1 - 1)
                                          # or a
        BZE  Player1_DeadUI               # call nz, Player1Continue
        CALL Player1Continue              # jr Player1_DeadUI
        BR   Player1_DeadUI

   .ifdef TwoPlayersGame
Player2DoContinue:
        TST  @$ShowContinueCounter        # ld a,100    :ShowContinueCounter_Plus1
                                          # or a
        BZE  Player2_DeadUI               # call nz,Player2Continue
        CALL Player2Continue              # jr Player2_DeadUI
        BR   Player2_DeadUI
   .endif
#-------------------------------------------------------------------------------
# We put Plus sprite anims here, as they have to be run
# after the playerhandler and mess up practically ALL registers
Player_DrawUI:
        MOV  $Player_Array,R5           # ld iy,Player_Array
        TSTB @$P1_P09                   # ld a,(P1_P09)   ;See how many lives are left
                                        # or a
        BZE  Player1DoContinue          # jr z,Player1DoContinue
        CALL Player1DrawUI              # call Player1DrawUI

Player1_DeadUI:
   .ifdef TwoPlayersGame # {{{
        MOV  $PlayerArray2,R5           # ld iy,Player_Array2
        TSTB @$P1_P09                   # ld a,(P2_P09)   ;See how many lives are left
                                        # or a
        BZE  Player2DoContinue          # jr z,Player2DoContinue
        CALL Player2DrawUI              # call Player2DrawUI

Player2_DeadUI:
        CMPB @$LivePlayers,$2           # ld a,(LivePlayers)
                                        # cp 2
        BHIS 1237$                      # ret nc
   .endif # }}}
      # 1 player or less!
        TST  @$ShowContinueCounter      # ld a,(ShowContinueCounter_Plus1-1)
                                        # or a
        BZE  1237$                      # ret z
                                        # call SpriteBank_Font2
                                        # ld l,&00;14  ; show how many credits are left
ShowContinues:
       .inform_and_hang "no ShowContinues"
       .equiv ContinuesScreenPos, .+2
        MOV  $0x0E,R3                   # ld h,&0E    :ContinuesScreenpos_Plus1
                                        # ld bc,txtCreditsMsg2
                                        # call DrawText_LocateAndPrintStringUnlimited
                                        #
                                        # ld a,(P1_P05)
                                        # call DrawText_Decimal
                                        #
ShowContinuesSelfMod:
        MOV  $'/, R0                    # ld a,"/"
                                        # call Akuyou_DrawText_CharSprite
                                        #
                                        # ld a,(P2_P05)
                                        # jp DrawText_Decimal
                                        #
Player2Continue:
                                        # ld hl,&1e01;14 ; show how many credits are left
                                        # jr Player1ContinueB
Player1Continue:
        MOV  $0x8000,R5
        JMP  @$ExecuteBootstrap
                                        # ld hl,&0101;14 ; show how many credits are left
                                        #
                                        # Player1ContinueB:
                                        #     push hl
                                        #         ld hl,ShowContinueCounter_Plus1-1
                                        #         dec (hl)
                                        #         call SpriteBank_Font2
                                        #     pop hl
                                        #     ld bc,txtPressButtonMsg2
                                        #     jp DrawText_LocateAndPrintStringUnlimited
                                        #     txtCreditsMsg2:
                                        #         db "Credits",":"+&80
                                        #     txtPressButtonMsg2:
                                        #         db "Continue","?"+&80
                                        #
Player_DrawUIDual:
        MOV  R0,@$Player_DrawUI_DrawIcons_IconWidth

        MOV  $8,R1    # Y pos, line
        MOVB 9(R5),R0 # Lives, number of icons
        MOV  $7,@$SprShow_SprNum
        PUSH R2
        PUSH R5
        CALL Player_DrawUI_DrawIcons
        POP  R5
        POP  R2

        MOV  $180,R1  # Y pos, line
        MOVB 3(R5),R0 # Smart bombs, number of icons
        MOV  $6,@$SprShow_SprNum
        JMP  Player_DrawUI_DrawIcons

1237$:  RETURN # to use with player_driver.s:831

Player1DrawUI:
        MOV  $4,R0 # icon width, bytes        # ld a,4
        CLR  R2    # Xpos, word               # ld b,0
        CALL Player_DrawUIDual                # call Player_DrawUIDual

                                              # ld a,7
                                              # ld hl,&0003
                                              # ld iy,Player_Array
                                              # ld de,Player_ScoreBytes
        BR   Player_DrawUI_PlusAsWell         # jr Player_DrawUI_PlusAsWell
Player2DrawUI:
                                        # ld a,-4
                                        # ld b,80-4
                                        #
                                        # ld de,3*4+PlusSprites_Config2+3
                                        # ld hl,PlusSprites_Config1+3
                                        #
                                        # call Player_DrawUIDual
                                        #
                                        # ld hl,&2503
                                        # ld a,40-1
                                        # ld iy,Player_Array2
                                        # ld de, Player_ScoreBytes2
Player_DrawUI_PlusAsWell:
                                        #     ld (PlayerScorePos_Plus2 - 1),a
                                        #     ld (BurstDrawPos_Plus2 - 2),hl
                                        #     push de
                                        #     push iy
                                        #
                                        #         ;Draw score digits
                                        #         ld hl,&0700:PlayerScorePos_Plus2
                                        #         call DrawText_LocateSprite
                                        #
                                        #         call SpriteBank_Font2
                                        #
                                        #         ex hl,de
                                        #
                                        # Player_DrawUI_NextDigit:
                                        #     push hl
                                        #
                                        #         ld a,(hl)
                                        #         add 48 ; Move to the correct digit (first 32 are not in font)
                                        #
                                        #         ld b,-2 ; we are drawing backwards!
                                        #
                                        #         call DrawText_CharSpriteDirect ;DrawText_DigitSprite
                                        #
                                        #     pop hl
                                        #         inc l
                                        #         ld a,%00000111
                                        #         and l
                                        #         jp nz,Player_DrawUI_NextDigit
                                        #     pop iy
                                        #     pop hl
                                        #     ; check if we need to show the continue screen
                                        #
                                        # ScoreAddRepeat: ;This does our rolling up effect on the score!
                                        #     push hl
                                        #         call Player_UpdateScore
                                        #     pop hl
                                        #     ld a,(iy+13)
                                        #     cp 30  ; if waiting score goes over 30, add faster
                                        #     jr nc,ScoreAddRepeat ; this is for the 'coffee time' effect at the
                                        #                          ; end of level 9
                                        #
                                        #     ;Show the remaining 'burst fire' power
                                        #     ld hl,&0003 : BurstDrawPos_Plus2
                                        #     call DrawText_LocateSprite
                                        #     ld a,(iy+10)
                                        #     or a
                                        #     call nz,DrawText_Decimal
       .equiv CheadMode, .
        RETURN                          #     ret: CheatMode_Plus1

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
                                        #
                                        # Player_UpdateScore:         ;Add score to the first digit
                                        #     ld a,(iy+13)
                                        #     or a
                                        #     ret z ;nothing to add
                                        #     ld b,a
                                        #     ld c,0
                                        #     dec a
                                        #     ld (iy+13),a
                                        #
                                        #     ld a,(hl)
                                        #     inc a
                                        #     ld (hl),a
                                        #     cp 10
                                        #     ret C   ; return if nothing to carry
                                        #     inc c   ; We've rolled into another digit.
                                        #
                                        # Player_AddScore_NextDigit:
                                        #     xor a
                                        #     cp c
                                        #     ret z   ; check if C is zero
                                        #
                                        #     ld c,a
                                        #     ld a,(hl)
                                        #     inc a
                                        #     cp 10
                                        #     jp C,Player_AddScore_Inc
                                        #     xor a
                                        #     inc c
                                        #
                                        # Player_AddScore_Inc:
                                        #     ld (hl),a
                                        #     inc l
                                        #     ld a,l
                                        #     and 7
                                        #     cp 3
                                        #     jp nz,NoBurstPower
                                        #     ld a,(iy+10)
                                        #     add 10
                                        #     jr nc,Player_AddScore_NoOverflow
                                        #     ld a,255
                                        # Player_AddScore_NoOverflow:
                                        #     ld (iy+10),a
                                        # NoBurstPower:
                                        #     ld a,%00000111
                                        #     or l    ; repeat until we get to 8 - if so we've run out of digits
                                        #     jr nz,Player_AddScore_NextDigit
                                        # ret
