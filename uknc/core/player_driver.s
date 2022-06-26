
#*****************************************************************************#
#*                              player Handler                               *#
#*****************************************************************************#
                                        #
                                        # Player_GetHighscore:
                                        #     ld hl,HighScoreBytes
                                        #     ret
Player_GetPlayerVars:                   # Player_GetPlayerVars:
        MOV  $Player_Array,R5           #     ld iy,Player_Array
        RETURN                          # ret
                                        #     ; iy = Pointer to player vars
NoSpend:                                # NoSpend:
        MOV  R0,@$srcSpendTimeout       #     ld (SpendTimeout_Plus1-1),a
        RETURN                          # ret
                                        #
SpendCheck:                             # SpendCheck:
       .equiv srcSpendTimeout, .+2
        MOV  $1,R0                      #     ld a,1:SpendTimeout_Plus1   ;Dont let player continue right away!
        DEC  R0                         #     dec a
        BNZ  NoSpend                    #     jr nz,NoSpend
                                        #
        # TODO:                         #     ld a, ixl ; read the keymap
                                        #     or Keymap_AnyFire
        INC  R0                         #     inc a
        BNE  SpendCredit                #     ret z
        RETURN                          #
SpendCredit:                            # SpendCredit:
         PUSH R5                        #     push iy
         SpendCreditSelfMod:
             MOV  $Player_Array,R5      # SpendCreditSelfMod: ld iy,Player_Array ; All credits are (currently) stored in player 1's var!
         MOVB 5(R5),R0                  #         ld a,(iy+5)
         DECB R0                        #         sub 1
         POP  R4                        #     pop ix
         BMI  1$                        #     ret c ;no credits left!
         MOVB R0,5(R5)                  #     ld (iy+5),a
                                        #
                                        #     ld a,3
         MOVB $3,9(R4) # lives          #     ld (ix+9),a
                                        #     ld a,(SmartbombsReset)
         MOVB @$SmartBombsReset,3(R4)   #     ld (ix+3),a
1$:      RETURN                         # ret
                                        #
# Both players are dead, so pause the game and show the continue screen
PlayersDead:                            # Players_Dead:
        RETURN # TODO: implement PlayersDead
                                        #     ld a,&3C
                                        #     ld (PlayerCounter),a
                                        #
                                        #     ld hl,(&0039)
                                        #     push hl
                                        #
                                        #     ld hl,&0001
                                        #     call ExecuteBootStrap
                                        #
                                        #     pop hl
                                        #     ld (&0039),hl
                                        #     jp ScreenBuffer_Init
                                        #
PlayerHandler:
        # Used to update the live player count
        CLR  R0                         #         xor a
                                        #
PlayerCounter:
        INC  R0 # or NOP if player 1 is dead #         inc a
        INC  R0 # or NOP if player 2 is dead #         inc a
        MOVB R0,@$LivePlayers           #     ld (LivePlayers),a
                                        #         or a
        BZE  PlayersDead                #         jr z, Players_Dead
                                        #
                                        #     ld hl,&0000     ;nop,nop
        MOV  $000240,@$PlayerCounter    #     ld (PlayerCounter),hl
        MOV  $000240,@$PlayerCounter+2
                                        #     call KeyboardScanner_Read
                                        #

                                        #     ; returns
                                        #     ; ixl = Keypress bitmap Player
                                        #     ; HL Direct pointer to the keymap
                                        #     call Player_ReadControls

        MOV  $Player_Array,R4           #     ld iy,Player_Array
        TSTB @$P1_P09                   #     ld a,(P1_P09)   ;See how many lives are left
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
       #MOV  R5,@$srcSprShow_BankAddr   #     ld (SprShow_BankAddr),hl
                                        #
                                        #     ld a,e
                                        #     ld (PlayerSpriteBank_Plus1-1),a;    call Akuyou_BankSwitch_C0_SetCurrent
                                        #
                                        #     ld a,ixl
                                        #
                                        #     ;Check if the game is paused
                                        #     Player_Handler_Pause:
        BIT  $Keymap_Pause, @$KeyboardScanner_P1 #     bit Keymap_Pause,a
        BZE  Player_Handler_PauseCheckDone      #     jr nz,Player_Handler_PauseCheckDone
        # Z=normal; NZ=paused
        COM  @$srcTimer_Pause           #     ld hl,Timer_Pause_Plus1-1
                                        #     ld a,(hl)
                                        #     cpl
                                        #     ld (hl),a

        MOV  $12,R1                     #     ld b,12
        WaitLoop:                       # WaitLoop:halt ; KeyboardScanner_ScanForOne
            WAIT
        SOB  R1,WaitLoop                #     djnz WaitLoop
                                        #     pop af ; wtf???
1237$:  RETURN                          # ret

Player_Handler_PauseCheckDone:          # Player_Handler_PauseCheckDone:
        MOV  @$srcTimer_TicksOccured,R0 #     ld hl,Timer_TicksOccured
                                        #     ld a,(hl)
                                        #     or a
        BZE  1237$                      #     ret z ;abort handler if game paused
                                        #     xor a
        CLR  @$srcPlayerSaveShot        #     ld (PlayerSaveShot_Plus1 - 1),a
        CLR  @$srcPlayerDoFire          #     ld (PlayerDoFire_Plus1 - 1),a
                                        #     ld a,(hl)
        BITB 11(R4),R0 # fire speed     #     and (iy+11)
        BZE  Player_Handler_Start       #     jr z,Player_Handler_Start
                                        #
        CLRB 2(R4)                      #     ld (iy+2),0
                                        #
        # Move the drones depending if the player is shooting
Player_Handler_Start:                   # Player_Handler_Start:
        CLR  R0
        BISB 6(R4),R0                   #     ld a,(iy+6) ;D1
       #INC  R0                         #     inc a
        CMP  R0,$15                     #     cp 16
        BHIS Player_Handler_DronePosOk  #     jr c,Player_Handler_DronePosOk
       #DEC  R0                         #     dec a
        INC  R0
Player_Handler_DronePosOk:              # Player_Handler_DronePosOk:
        MOVB R0,6(R4)                   #     ld (iy+6),a ;D1 - shots and drones
        ADD  R0,R0                      #     add a
        MOV  R0,@$srcPlayer_DroneOffset1#     ld (Player_DroneOffset1_Plus1 - 1),a

        MOV  (R4),R1                    #     ld c,(iy)   ;Y
        CLR  R2                         #     ld b,(iy+1) ;X
        BISB R1,R2                      #     ld e,8  :PlayerMoveSpeedFast_Plus1 ; Fast move speed - will be overriden if we're firing
        CLRB R1
        SWAB R1 # R2=Y, R1=X
       .equiv srcPlayerMoveSpeedFast, .+2
        MOV  $8,R3 # Fast move speed - will be overriden if we're firing

        MOV  @$KeyboardScanner_P1,R0
# SelfModifyingFire1:
        BIT  $Keymap_F1,R0
        BZE  Player_Handler_KeyreadJoy1Fire2
        # fire bullets
# SelfModifyingFire2:
        BIT  $Keymap_F2,R0
        BZE  Player_Handler_KeyreadJoy1Fire1

      # Xfire is a secret feature planned for the sequel
      # it activates when both fire buttons are pressed
       #CALL Player_Handler_FireX
        BR   Player_Handler_KeyreadJoy1Up

Player_Handler_KeyreadJoy1Fire1: # Fire right
       .equiv dstFire1Handler, .+2
        CALL @$SetFireDir_RIGHTsave # fire bullets
# Player_ShootSkip
       .equiv srcPlayerMoveSpeedSlow1, .+2
        MOV  $2,R3 # slow move speed as we're firing
        BR   Player_Handler_KeyreadJoy1Up

Player_Handler_KeyreadJoy1Fire2: # Fire left
# SelfModifyingFire1B:
        BIT  $Keymap_F2,R0
        BZE  Player_Handler_KeyreadJoy1Up

       .equiv dstFire2Handler, .+2
        CALL @$SetFireDir_LEFTsave # fire bullets
                                                            #
# Player_ShootSkip2
       .equiv srcPlayerMoveSpeedSlow2, .+2
        MOV  $2,R3 # Slow move speed as we're firing
Player_Handler_KeyreadJoy1Up:
        BIT  $Keymap_Up,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadJoy1Down
        CMP  R2,$24+ 24 # Check we're onscreen
        BLO  Player_Handler_KeyreadJoy1Down

        SUB  R3,R2
       .equiv dstFireUpHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Down:
        BIT  $Keymap_Down,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadJoy1Left

        CMP  R2,$24+ 200-16 # Check we're onscreen
        BHIS Player_Handler_KeyreadJoy1Left

        ADD  R3,R2
       .equiv dstFireDownHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Left:
        BIT  $Keymap_Left,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadJoy1Right

        CMP  R1,$24+ 12 # Check we're onscreen
        BLO  Player_Handler_KeyreadJoy1Right

        SUB  R3,R1
       .equiv dstFireLeftHandler, .+2
        CALL @$null

Player_Handler_KeyreadJoy1Right:
        BIT  $Keymap_Right,@$KeyboardScanner_P1
        BZE  Player_Handler_SmartBomb

        CMP  R1,$24+ 160-12 # Check we're onscreen
        BHIS Player_Handler_SmartBomb

        ADD  R3,R1
       .equiv dstFireRightHandler, .+2
        CALL @$null

Player_Handler_SmartBomb: # Check if we should fire the smarbomb
        BIT  $Keymap_F3,@$KeyboardScanner_P1
        BZE  Player_Handler_KeyreadDone

        TST  @$srcSmartBomb # smartbomb active?
        BNZ  Player_Handler_KeyreadDone

        TSTB 3(R4) # see if we've got any smartbombs left
        BZE  Player_Handler_KeyreadDone

        DEC  3(R4)
        # call DoSmartBomb
        # ld a,3
        # call DoSmartBombFX

Player_Handler_KeyreadDone:
       .equiv srcPlayerSaveShot, .+2
        TST  $0                        # ld a,0 :PlayerSaveShot_Plus1
        BZE  Player_Handler_NoSaveFire # or a
                                       # jr z,Player_Handler_NoSaveFire

                                       # ld a,0 :PlayerThisSprite_Plus1
       .equiv srcPlayerThisSprite, .+2
        MOVB $0,8(R4)                  # ld (iy+8),a
                                       #
                                       # ld a,0 :PlayerThisShot_Plus1
       .equiv srcPlayerThisShot, .+2
        MOVB $0,15(R4)                 # ld (iy+15),a
                                       #
Player_Handler_NoSaveFire:
        MOVB 8(R4),R0                  # ld a,(iy+8)
        BIC  $0xFF7F,R0                # and %10000000
       .equiv cmpDroneFlipCurrent, .+2
        CMP  R0,$1                     # cp 1 :DroneFlipCurrent_Plus1
      #.CALL NE, DroneFlip             # call nz,DroneFlip
                                       #
       .equiv srcPlayerDoFire, .+2
        TST  $0                        # ld a,0 :PlayerDoFire_Plus1
                                       # or a
      #.CALL NZ, Player_Fire4D         # call nz,Player_Fire4D
                                       #
                                       # push bc
                                       #     ld a,PlusSprite_ExtBank :PlayerSpriteBank_Plus1
                                       #     call BankSwitch_C0_SetCurrent
                                       # pop bc
                                       #
       #SWAB R1
       #CLRB R1
       #BISB R2,R1
       #MOV  R1,(R4)

        MOVB R2,(R4)  # Y              # ld (iy),c   ;Y
        MOVB R1,1(R4) # X              # ld (iy+1),b ;X
                                       #
        CLR  R3                        # ld e,0
                                       # ld a,(Timer_CurrentTick_Plus1-1)
       .equiv srcPlayerSpriteAnim, .+2 # and %00000010 :PlayerSpriteAnim_Plus1
        BIT  $0b00000010,@$srcTimer_CurrentTick
        BZE  Player_Handler_Frame1     # jr z,Player_Handler_Frame1
        INC  R3                        # inc e

Player_Handler_Frame1:
        PUSH R3                         # push de ;save the frame no
       .equiv opcDroneDirPos8, .
        MOV  R1,R0 # or MOV  R2,R0      # ld a,B  :DroneDirPos8_Plus1
        SUB  $4,R0                      # sub 4
       .equiv dstDroneDirPos1, .+2
        MOV  R0,@$srcSprShow_X          # ld (SprShow_X),a :DroneDirPos1_Plus2
        TSTB 4(R4)                      # ld a,(iy+4)
                                        # or a
        BZE  Player_Handler_NoDrones    # jp z,Player_Handler_NoDrones
                                        #
                                        # push iy
                                        # push bc
                                        #
        ADD  $4,R3                      # ld a,4
                                        # add e
        MOV  R3,@$srcSprShow_SprNum     # ld (SprShow_SprNum),a
                                        #
        BITB $0b10,4(R4)                # bit 1,(iy+4)
        BZE  Player_Handler_OneDrone    # jr z,Player_Handler_OneDrone
                                        #
        MOV  $-12,R0                    # ld a,-12
       .equiv srcPlayer_DroneOffset1, .+2
        SUB  $16,R0                     # sub 16:Player_DroneOffset1_Plus1
        CALL @$SetDronePos              # call SetDronePos
                                        #
# Drone2NoPlus:
        PUSH R1
        PUSH R2
        PUSH R4
        CALL @$ShowSprite               # call ShowSprite
                                        # Drone2Plus:
                                        #         pop bc
                                        #         push bc
                                        #         jr Player_Handler_OneDroneSkip
                                        #
Player_Handler_OneDrone:
Player_Handler_OneDroneSkip:
        MOV  @$srcPlayer_DroneOffset1,R0# ld a,(Player_DroneOffset1_Plus1 - 1) ; 16Player_DroneOffset2_Plus1
        CALL SetDronePos                # call SetDronePos
                                        #
# Drone1NoPlus:
        CALL @$ShowSprite               # call ShowSprite
# Drone1PlusRet:
        POP  R4
        POP  R2                         # pop bc
        POP  R1                         # pop iy
Player_Handler_NoDrones:
        MOV  R1,R0                      # ld a,B
        SUB  $7,R0                      # sub 7
        MOV  R0,@$srcSprShow_X          # ld (SprShow_X),a
        POP  R3                         # pop de  ;get back the frame num
        TSTB 7(R4)                      #     ld a,(iy+7) ;invincibility
                                        #
                                        #     or a
        BR   Player_NotInvincible       #     jr z,Player_NotInvincible
        MOV  @$srcTimer_TicksOccured,R0 #     ld a,(Timer_TicksOccured)
        BIT  $0b0010,R0                 #  bit 1,a
        BZE  Player_NotInvincible       #     jr z,Player_NotInvincible   ;invincible flash
                                        #
        BIT  $0b0100,R0                 #     bit 2,a
        BZE  Player_SpriteSkip          #     jr z,Player_SpriteSkip
                                        #
        DEC  7(R4)                      #     dec (iy+7)  ;invincibility
                                        #
Player_SpriteSkip:
        RETURN                          # ret
                                        #
Player_NotInvincible:
                                        # push bc
                                        #     ;draw the player
        MOV  8(R4),R0                   #     ld a,(iy+8)
        BIC  $0xFFF0,R0                 #     and %00001111
        ADD  R3,R0                      #     add e
        MOV  R0,@$srcSprShow_SprNum     #     ld (SprShow_SprNum),a
                                        #
                                        # ShowPlayer_NoPlus:
                                        #     ld a,c
        SUB  $18,R2                     #     sub 18
        MOV  R2,@$srcSprShow_Y          #     ld (SprShow_Y),a
                                        #
        CALL @$ShowSprite               #     call ShowSprite
                                        # pop bc
        RETURN                          # ret
                                        #
SetDronePos:
       .equiv DroneDirPos5, .
        NOP                             # nop              :DroneDirPos5_Plus2 ; sra a
       .equiv DroneDirPos2, .
        ADD  R2,R0                      # add c            :DroneDirPos2_Plus1 ; add b
       .equiv DroneDirPos6, .+2
        MOV  R0,@$srcSprShow_Y          # ld (SprShow_Y),a :DroneDirPos6_Plus2 ; ld (SprShow_X),a;ld (SprShow_Y),a
        RETURN                          # ret
                                        #
                                        # Player_Fire_OneBurst:
                                        #     push de
                                        #     push bc
                                        #         or 0:PlayerNumBurst_Plus1
                                        #         call Stars_AddObjectFromA
                                        #     pop bc
                                        #     pop de
                                        # ret
                                        #
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
                                                            #
                                                            # Xfire:
                                                            #     defb &7C,&4C,&67,&61
                                                            # XfireSml:
                                                            #     defb &49,&4F,&79,&7F,0
                                                            #
Player_Fire4D:                                              # Player_Fire4D:  ; Fire bullets!
        MOVB 8(R5),R0                                       #     ld a,(iy+8)
        BIC  $!0x80,R0                                      #     and %10000000
       .equiv cmpDroneFlipFireCurrent, .+2
        CMP  R0,$0                                          #     cp 0 :DroneFlipFireCurrent_Plus1
       .CALL NE, DroneFlipFire                              #     call nz,DroneFlipFire
                                                            #
                                                            #     ld a,(iy+15)
                                                            # Player_Fire:    ; Fire bullets!
                                                            #     push bc
                                                            #     push de
                                                            #
                                                            #         ld d,(iy+12)
                                                            #         or d
                                                            #         ld (StarObjectMoveToAdd_Plus1-1),a
                                                            #
                                                            #         ld a,(iy+6) ;D1 Move the drones in when fire is held
                                                            #         dec a
                                                            #         dec a
                                                            #         jr nz,Player_Handler_KeyreadJoy1Fire2_DroneLimit
                                                            #         inc a   ; Drone at Max 'innness'!
                                                            #
                                                            #     Player_Handler_KeyreadJoy1Fire2_DroneLimit:
                                                            #         ld (iy+6),a ;D1
                                                            #
                                                            #     pop de
                                                            #     pop bc
                                                            #     ld a,(iy+2) ;D1
                                                            #     bit 7,a ; check if player is allowed to fire
                                                            #     ret nz
                                                            #     or %10000000
                                                            #     ld (iy+2),a ;D1
                                                            #
                                                            #     push bc
                                                            #
                                                            #         call Stars_AddToPlayer
                                                            #         ld d,b
                                                            #         push bc
                                                            #
                                                            #             call Stars_AddObject
                                                            #
                                                            #     ;drone1
                                                            #         pop bc
                                                            #
                                                            #         ld a,(Player_DroneOffset1_Plus1-1)
                                                            #         add 4
                                                            #         rrca    :DroneFlipFirePos5_Plus1    ;disable these for X
                                                            #         ld ixh,a
                                                            #
                                                            #         ; Add extra stars depending on how many drones we have
                                                            #         ld a,(iy+4)
                                                            #         or a
                                                            #         jr z,Player_NoDrones
                                                            #         dec a
                                                            #         jr z,Player_OneDrone
                                                            #         xor a
                                                            #         sub ixh
                                                            #         call dodrone
                                                            #     ;drone2
                                                            #
                                                            # Player_OneDrone:
                                                            #     ld a,ixh
                                                            #     call dodrone
                                                            #
                                                            # Player_NoDrones:
                                                            #     pop bc
                                                            # FireSfx:
                                                            #     ld a,1
                                                            #     jp SFX_QueueSFX_Generic
                                                            #
                                                            # dodrone:
                                                            #     push bc
                                                            #         ld d,b
                                                            #
                                                            #         ; ResetCore sets to add a,c
                                                            #         add a,d :DroneFlipFirePos3_Plus1
                                                            #
                                                            #         ld d,a  :DroneFlipFirePos2_Plus1;ld c,a ;Flip for X
                                                            #         call Stars_AddObject
                                                            #     pop bc
                                                            # ret
                                                            #
DroneFlipFire:                                              # DroneFlipFire:
        MOV  R0,@$cmpDroneFlipFireCurrent                   #     ld (DroneFlipFireCurrent_Plus1 - 1),a
        PUSH R2                                             #     push de
                                                            #     or a
                                                            #     ld a,&82
                                                            #     jr z,DroneFlipFire_HorizontalMove
                                                            #
                                                            #         ld de,&570F
                                                            #         jr DroneFlipFireApply
                                                            # DroneFlipFire_HorizontalMove:
                                                            #         dec a
                                                            #         ld de,&4F00  ; ld c,a nop
                                                            # DroneFlipFireApply:
                                                            #     ld (DroneFlipFirePos3_Plus1 - 1),a
                                                            #     ld a,d
                                                            #     ld (DroneFlipFirePos2_Plus1 - 1),a
                                                            #     ld a,e
                                                            #     ld (DroneFlipFirePos5_Plus1 - 1),a
        POP  R2                                             # jr DroneFlipFinish
        RETURN                                              #
DroneFlip:                                                  # DroneFlip:
                                                            #     ld (DroneFlipCurrent_Plus1-1),a
        PUSH R3                                             #     push de
                                                            #     push hl
                                                            #     push bc
                                                            #     push ix
                                                            #
                                                            #     LD DE,SprShow_X
                                                            #     LD HL,SprShow_Y
                                                            #     or a
                                                            #     LD A,&80
                                                            #     ld ixl,&79
                                                            #
                                                            #     jr z,DroneFlip_HorizontalMove
                                                            #
                                                            #     ld bc,&2FCB
                                                            #     jp DroneFlip_Apply
                                                            #     DroneFlip_HorizontalMove:
                                                            #         ex hl,de
                                                            #         dec ixl
                                                            #         inc a
                                                            #         ld bc,&0000
                                                            #     DroneFlip_Apply:
                                                            #     ld (DroneDirPos1_Plus2-2),hl
                                                            #     ld (DroneDirPos2_Plus1-1),a
                                                            #     ld (DroneDirPos5_Plus2-2),bc
                                                            #     ld (DroneDirPos6_Plus2-2),de
                                                            #     ld a,ixl
                                                            #     ld (DroneDirPos8_Plus1-1),a
                                                            #
                                                            #     pop ix
                                                            #     pop bc
                                                            #
                                                            #     pop hl
    DroneFlipFinish:                                        # DroneFlipFinish:
        POP  R3                                             #     pop de
        RETURN                                              # ret
                                                            #
SetFireDir_UP:                                              # SetFireDir_UP:
       #MOV  $0x82,@$srcPlayerThisSprite                    #     push bc
       #MOV  $0x4C,@$srcPlayerThisShot                      #     ld bc,&4C82
        RETURN                                              #     jr SetFireDir_Any
                                                            #
 SetFireDir_DOWN:                                           # SetFireDir_DOWN:
       #MOV  $0x80,@$srcPlayerThisSprite                    #     push bc
       #MOV  $0x7C,@$srcPlayerThisShot                      #     ld bc,&7C80
        RETURN                                              #     jr SetFireDir_Any
                                                            #
SetFireDir_LEFTsave:                                        # SetFireDir_LEFTsave:
        CALL SetFireDir_FireAndSave                         #     call SetFireDir_FireAndSave
SetFireDir_LEFT:                                            # SetFireDir_LEFT:
        MOV  $0x02,@$srcPlayerThisSprite                    #     push bc
        MOV  $0x61,@$srcPlayerThisShot                      #     ld bc,&6102
        RETURN                                              #     jr SetFireDir_Any
                                                            #
SetFireDir_RIGHTsave:                                       # SetFireDir_RIGHTsave:
        CALL SetFireDir_FireAndSave                         #     call SetFireDir_FireAndSave
                                                            #
SetFireDir_RIGHT:                                           # SetFireDir_RIGHT:
        MOV  $0x00,@$srcPlayerThisSprite                    #     push bc
        MOV  $0x67,@$srcPlayerThisShot                      #     ld bc,&6700
        RETURN                                              #
                                                            # SetFireDir_Any:
                                                            #     ld a,b
                                                            #     ld (PlayerThisShot_Plus1 - 1),a
                                                            #     ld a,c
                                                            #     ld (PlayerThisSprite_Plus1 - 1),a
                                                            #     pop bc
                                                            # ret
                                                            #
SetFireDir_FireAndSaveRestore:                              # SetFireDir_FireAndSaveRestore:
                                                            #     ld a,(iy+8)
        MOVB 8(R5), @$srcPlayerThisSprite                   #     ld (PlayerThisSprite_Plus1 - 1),a
                                                            #
        MOVB 15(R5),@$srcPlayerThisShot                     #     ld a,(iy+15)
                                                            #     ld (PlayerThisShot_Plus1 - 1),a
                                                            #
SetFireDir_FireAndSave:                                     # SetFireDir_FireAndSave:
        MOV  $0x67,R0                                       #     ld a,&67
        MOV  R0,@$srcPlayerSaveShot                         #     ld (PlayerSaveShot_Plus1 - 1),a
                                                            #
SetFireDir_Fire:                                            # SetFireDir_Fire:
        MOV  R0,@$srcPlayerDoFire                           #     ld (PlayerDoFire_Plus1 - 1),a

        RETURN                                              # ret
                                                            #
                                                            # DoSmartBombCall:
                                                            #     ; a=2 All FX
                                                            #     ; a=1 no sound, screen flash
                                                            #     ; a=0 No FX
                                                            #     push af
                                                            #     call DoSmartBomb
                                                            #     pop af
                                                            #     jr DoSmartBombFX
                                                            #
                                                            # MemoryFlushLDIR:
                                                            #     ld b,0
                                                            #     ld c,a
                                                            #
                                                            #     ld d,h
                                                            #     ld e,l
                                                            #     inc de
                                                            #     ld (hl),b
                                                            #     ldir
                                                            #     ret
                                                            #
                                                            # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                            # ;;                               Smart Bomb                                   ;;
                                                            # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                            #
                                                            # DoSmartBomb:
                                                            #     push de
                                                            #     push bc
                                                            #
                                                            #     ld a,StarArraySize-1;(StarArraySize_Enemy)
                                                            #     ld hl,StarArrayPointer;(StarArrayMemloc_Enemy)
                                                            #
                                                            #     call MemoryFlushLDIR
                                                            #
       .equiv  dstSmartBombSpecial, .+2
        CALL @$null                                         #     call null :SmartBombSpecial_Plus2 ; We can hack in our own smartbomb handler
                                                            #                                       ; this is needed to wipe omega array for
                                                            #                                       ; final boss as it's not handled by
                                                            #                                       ; normal core code
                                                            #     ld b,ObjectArraySize
                                                            #     ld hl,ObjectArrayPointer
                                                            #
                                                            # Player_Handler_SmartBombObjLoop: ; we need special code because we don't want to wipe
                                                            #                                  ; bg objects and boss sprites
                                                            #     push hl
                                                            #         ;y
                                                            #         inc h
                                                            #         ;x
                                                            #         inc h
                                                            #         ;m
                                                            #         inc h
                                                            #         ;s
                                                            #         set 6,l
                                                            #         ld a,(hl)   ;life (0 is background)
                                                            #         or a
                                                            #
                                                            #         jr z,Player_Handler_SmartBombObjMoveNext
                                                            #         inc a
                                                            #         jr z,Player_Handler_SmartBombObjMoveNext
                                                            #
                                                            #         dec h
                                                            #
       .equiv  dstCustomSmartBombEnemy, .+2
        CALL @$null                                         #         call null : CustomSmartBombEnemy_Plus2
                                                            #
                                                            #         ld a,(hl)
                                                            #         or a
                                                            #         jr z,SmartBombKill
                                                            #
                                                            #         cp 16           ;Program 1-31 are protected from smartbomb
                                                            #         jr C,Player_Handler_SmartBombObjMoveNext
                                                            #
                                                            # SmartBombKill
                                                            #         ;if we got here we need to kill this object
                                                            #         pop hl
                                                            #         push hl
                                                            #
                                                            #         inc h ;y
                                                            #         inc h ;X
                                                            #
                                                            #         ld (hl),%10001011
                                                            #
                                                            #         inc h
       .equiv srcPointsSpriteB, .+2
        MOVB $128+16, (R5)                                  #         ld (hl),128+16  :PointsSpriteB_Plus1; Sprite
                                                            #
                                                            #         set 6,l
                                                            #         ld (hl),64+63   ; Life ; must "hurt" player for hit to be detected
                                                            #         dec h
                                                            #         ld (hl),3   ; Program
                                                            #         dec h
                                                            #         dec h
                                                            #         ld (hl),0
                                                            #
                                                            # Player_Handler_SmartBombObjMoveNext:
                                                            #     pop hl
                                                            #     inc l
                                                            #     djnz Player_Handler_SmartBombObjLoop
                                                            #
                                                            #     pop bc
                                                            #     pop de
                                                            #
                                                            # ret
                                                            #
                                                            # DoSmartBombFX:
                                                            #     push af;
                                                            #
                                                            #     or a
                                                            #     ret z
                                                            #
                                                            #     ld a,5
                                                            #     ld(SmartBomb_Plus1-1),a
                                                            #
                                                            #     pop af
                                                            #     dec a
                                                            #     ret z
                                                            #
                                                            #     ld a,5
                                                            #     jp SFX_QueueSFX_GenericHighPri
                                                            #
                                                            # ; ------------------ Player Hit ---------------
                                                            # Player_Hit:
                                                            #         ld (PlayerHitMempointer_Plus2-2),hl
                                                            #
                                                            #         ld a,iyl
                                                            #         cp 16+2
       .CALL EQ,null; CustomPlayerHitter_Plus2:             #         call z,null :customPlayerHitter_Plus2
       .equiv  dstCustomPlayerHitter, CustomPlayerHitter_Plus2 - 2
                                           #
                                           #         cp 3
                                           #         jp nz,Player_Hit_Injure
                                           #
                                           #         ; if we got here we hit a powerup
                                           #         ld b,0  ; remove the powerup
                                           #         ld c,b
                                           #         ld d,b
                                           #
                                           #         ld a,iyh
      .equiv cmpDroneSprite, .+2
       CMP  R0, $128+38                    #         cp 128+38   :DroneSprite_Plus1
       # jr z,Player_Hit_PowerupDrone      #         jr z,Player_Hit_PowerupDrone
      .equiv cmpShootSpeedSprite, .+2
       CMP  R0, $128+39                    #         cp 128+39   :ShootSpeedSprite_Plus1
       # jr z,Player_Hit_PowerupShootSpeed #         jr z,Player_Hit_PowerupShootSpeed
      .equiv cmpShootPowerSprite, .+2
       CMP  R0, $128+40                    #         cp 128+40   :ShootPowerSprite_Plus1
       # jr z,Player_Hit_PowerupShootPower #         jr z,Player_Hit_PowerupShootPower
      .equiv cmpPointsSprite, .+2
       CMP  R0, $128+16                    #         cp 128+16   :PointsSprite_Plus1
       # jr z,Player_Hit_Points            #         jr z,Player_Hit_Points
                                           #     ret
                                           #
                                           # Player_Hit_Points:
                                           #         ld a,6
                                           #         call SFX_QueueSFX_GenericHighPri
                                           #
                                           #         ; Object is Points for player
                                           # ;       push iy
                                           # ;           ld iy,(PlayerHitMempointer_Plus2-2)
                                           # ;           ld a,(iy+13)
                                           # ;               add 5
                                           # ;           ld (iy+13),a
                                           # ;       pop iy
                                           #         push bc
                                           #             ld bc,13
                                           #             add hl,bc
                                           #             ld a,(hl)
                                           #             add 5
                                           #             ld (hl),a
                                           #         pop bc
                                           #
                                           #         ret
                                           #
                                           # Player_Hit_PowerupShootSpeed:
                                           #         push iy
                                           #             ld iy,(PlayerHitMempointer_Plus2-2)
                                           #             ld a,(iy+11)
                                           #
                                           #             srl a
                                           #             or a
                                           #             jr nz,Player_Hit_PowerupShootSpeedNZ
                                           #                 inc a ;dont let a=0
                                           # Player_Hit_PowerupShootSpeedNZ:
                                           #             ld (iy+11),a
                                           #
                                           #         pop iy
                                           #         jr PowerupPlaySfx
                                           #
                                           # Player_Hit_PowerupDrone:
                                           #         push iy
                                           #             ld iy,(PlayerHitMempointer_Plus2-2)
                                           #             ld a,(iy+4)
                                           #             cp 2
                                           #             jr nc,Player_Hit_PowerupDroneFull
                                           #             inc a
                                           #             ld (iy+4),a
                                           # Player_Hit_PowerupDroneFull:
                                           #             pop iy
                                           #         jr PowerupPlaySfx
                                           # Player_Hit_PowerupShootPower:
                                           #         ld a,&96
                                           #         ld (PlayerStarColor_Plus1-1),a
                                           #
                                           #         ld a, 1
                                           # ;       power up both players
                                           #         ld (P2_P14),a
                                           #         ld (P1_P14),a
                                           # ;       power up only one player
                                           # ;       push iy
                                           # ;           ld iy,(PlayerHitMempointer_Plus2-2)
                                           # ;           ld (iy+14),a
                                           # ;       pop iy
                                           # PowerupPlaySfx:
                                           #         ld a,7
                                           #         jp SFX_QueueSFX_GenericHighPri
                                           # Player_Hit_Injure_2
                                           #         push hl
                                           #             ld hl,Player_Array2
                                           #             jp Player_Hit_Injure_X
                                           # Player_Hit_Injure_1
                                           #         push hl
                                           #             ld hl,Player_Array
                                           # Player_Hit_Injure_X
                                           #             ld (PlayerHitMempointer_Plus2-2),hl
                                           #         pop hl
                                           # Player_Hit_Injure:
                                           #     push iy
                                           #     ld iy,Player_Array :PlayerHitMempointer_Plus2
                                           #
                                           #     ld a,(iy+7) ;invincibility
                                           #     or a
                                           #     jr nz,Player_Hit_Done       ;>0 if player invincible
                                           #
                                           #         ld (iy+7),%00000111     ;invincibility
                                           #
                                           #         ld a,(iy+9)
                                           #         sub 1
                                           #         jr c,Player_Hit_Done    ; We are below zero!
                                           #         ld (iy+9),a
                                           #
                                           #         jr z,PlayerKilled
                                           #         ld a,4
                                           #         call SFX_QueueSFX_GenericHighPri
                                           # Player_Hit_Done:
                                           #     pop iy
                                           #     ret
                                           #
PlayerKilled:
                                           # xor a
        CLRB 3(R4)                         # ld (iy+3),a
        POP  R4                            # pop iy
                                           # ld a,20
        MOV  $20,@$srcSpendTimeout         # ld (SpendTimeout_Plus1-1),a
                                           # ld a,100
        MOV  $100,@$srcShowContinueCounter # ld (ShowContinueCounter_Plus1-1),a
        RETURN                             # ret

#******************************************************************************#
#*                                  Player UI                                 *#
#******************************************************************************#
Player_DrawUI_DrawIcons: # Used for Health and Smartbomb icons
        TST  R0 # number of icons to draw
        BZE  1237$

        100$:
            MOVB R1,@$srcSprShow_ScrWord
            MOV  R2,@$srcSprShow_ScrLine
            PUSH R0
            PUSH R1
            PUSH R2
            CALL ShowSpriteDirect
            POP  R2
            POP  R1
            POP  R0

           .equiv srcPlayer_DrawUI_DrawIcons_IconWidth, .+2
            ADD  $4,R1
        SOB  R0,100$

1237$:  RETURN

Player1DoContinue:
        TST  @$srcShowContinueCounter     # ld a,(ShowContinueCounter_Plus1 - 1)
                                          # or a
        BZE  Player1_DeadUI               # call nz, Player1Continue
        CALL Player1Continue              # jr Player1_DeadUI
Player2DoContinue:
       .equiv srcShowContinueCounter, .+2 # ld a,100    :ShowContinueCounter_Plus1
        TST  $100                         # or a
        BZE  Player2_DeadUI               # call nz,Player2Continue
        CALL Player2Continue              # jr Player2_DeadUI
#-------------------------------------------------------------------------------
# We put PLus sprite anims here, as they have to be run
# after the playerhandler and mess up practically ALL registers
Player_DrawUI:
#:bpt
# TwoDronesOnscreen:
        MOV  $Player_Array,R4           # ld iy,Player_Array
        TSTB @$P1_P09                   # ld a,(P1_P09)   ;See how many lives are left
                                        # or a
        BZE  Player1DoContinue          # jr z,Player1DoContinue
        CALL Player1DrawUI              # call Player1DrawUI

Player1_DeadUI:
        # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Player 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        # ld iy,Player_Array2
                                        # ld a,(P2_P09)   ;See how many lives are left
                                        # or a
                                        #
                                        # jr z,Player2DoContinue
                                        # call Player2DrawUI
                                        #
Player2_DeadUI:
                                        # ld a,(LivePlayers)
                                        # cp 2
        RETURN                          # ret nc
                                        # ;1 player or less!
                                        # ld a,(ShowContinueCounter_Plus1-1)
                                        # or a
                                        # ret z
                                        # call SpriteBank_Font2
                                        # ld l,&00;14  ; show how many credits are left
ShowContinues:
       .inform_and_hang "no ShowContinues"
       .equiv  srcContinuesScreenPos, .+2
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
                                        # ld hl,&0101;14 ; show how many credits are left
                                        #
                                        # Player1ContinueB:
       .inform_and_hang "no PlayerContinue"
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
        MOV  R0,@$srcPlayer_DrawUI_DrawIcons_IconWidth

        MOV  $8,R2    # Y pos, line
        MOVB 9(R4),R0 # Lives, number of icons
        MOV  $7,@$srcSprShow_SprNum
        PUSH R1
        PUSH R4
        CALL Player_DrawUI_DrawIcons
        POP  R4
        POP  R1

        MOV  $180,R2  # Y pos, line
        MOVB 3(R4),R0 # Smart bombs, number of icons
        MOV  $6,@$srcSprShow_SprNum
        JMP  Player_DrawUI_DrawIcons

Player1DrawUI:
        MOV  $4,R0 # icon width, bytes        # ld a,4
        CLR  R1    # Xpos, word               # ld b,0
        CALL Player_DrawUIDual                # call Player_DrawUIDual

                                              # ld a,7
                                              # ld hl,&0003
                                              # ld iy,Player_Array
                                              # ld de,Player_ScoreBytes
                                              # jr Player_DrawUI_PlusAsWell
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
                                        #     ld (PlayerScorePos_Plus2-1),a
                                        #     ld (BurstDrawPos_Plus2-2),hl
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
