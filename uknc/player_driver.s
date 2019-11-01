
                .include "./player_driver.h.s"

                                                            # ;*****************************************************************************;
                                                            # ;*                              player Handler                               *;
                                                            # ;*****************************************************************************;
                                                            #
                                                            # Player_GetHighscore:
                                                            #     ld hl,HighScoreBytes
                                                            #     ret
Player_GetPlayerVars:                                       # Player_GetPlayerVars:
        MOV  $Player_Array,R5                               #     ld iy,Player_Array
        RETURN                                              # ret
                                                            #
                                                            #     ; iy = Pointer to player vars
NoSpend:                                                    # NoSpend:
        MOV  R0,@$srcSpendTimeout                           #     ld (SpendTimeout_Plus1-1),a
        RETURN                                              # ret
                                                            #
SpendCheck:                                                 # SpendCheck:
        MOV  $1,R0                                          #     ld a,1:SpendTimeout_Plus1   ;Dont let player continue right away!
        SpendTimeout_Plus2:
        DEC  R0                                             #     dec a
        BNE  NoSpend                                        #     jr nz,NoSpend
                                                            #
        # TODO:                                             #     ld a, ixl ; read the keymap
                                                            #     or Keymap_AnyFire
        INC  R0                                             #     inc a
        BNE  SpendCredit                                    #     ret z
        RETURN                                              #
SpendCredit:                                                # SpendCredit:
         PUSH R5                                            #     push iy
         SpendCreditSelfMod:
             MOV  $Player_Array,R5                          # SpendCreditSelfMod: ld iy,Player_Array ; All credits are (currently) stored in player 1's var!
                                                            #         ld a,(iy+5)
                                                            #         sub 1
         POP  R4                                            #     pop ix
         DECB 5(R5)
         BCS  1$                                            #     ret c ;no credits left!
                                                            #     ld (iy+5),a
                                                            #
                                                            #     ld a,3
         MOVB $3,9(R4) # lives                              #     ld (ix+9),a
                                                            #     ld a,(SmartbombsReset)
         MOVB @$SmartbombsReset,3(R4)                       #     ld (ix+3),a
1$:      RETURN                                             # ret
                                                            #
Players_Dead:                                               # Players_Dead:       ;Both players are dead, so pause the game and show the continue screen
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
                                                            # Player_Handler:
                                                            #         ;Used to update the live player count
                                                            #         xor a
                                                            #
                                                            # PlayerCounter:  inc a
                                                            #         inc a
                                                            #     ld (LivePlayers),a
                                                            #         or a
                                                            #         jr z, Players_Dead
                                                            #
                                                            #     ld hl,&0000     ;nop,nop
                                                            #     ld (PlayerCounter),hl
                                                            #
                                                            #     call KeyboardScanner_Read
                                                            #
                                                            #     call Player_ReadControls
                                                            #     ld iy,Player_Array
                                                            #     ld a,(P1_P09)   ;See how many lives are left
                                                            #     or a
                                                            #     jr nz,Player1NotDead
                                                            #
                                                            #     ;if we got here, player 1 is dead
                                                            #
                                                            #     call SpendCheck
                                                            #     jr Player2Start
                                                            #
                                                            # Player1NotDead:
                                                            #     ld a,&3C
                                                            #     ld (PlayerCounter),a
                                                            #
                                                            #     ld hl,Akuyou_PlayerSpritePos
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
                                                            # ifdef DualChibikoHack
                                                            #     jr Player2NotDead64kver
                                                            # endif
                                                            #
                                                            # Player2NotDead64kver:
                                                            #     ld a,12
                                                            #     ld b,16
                                                            #     call Player_HandlerOne
                                                            #
                                                            #     jp BankSwitch_C0_SetCurrentToC0
                                                            # Player_HandlerOne:
                                                            #     ld (SprShow_BankAddr),hl
                                                            #
                                                            #     ld a,e
                                                            #     ld (PlayerSpriteBank_Plus1-1),a;    call Akuyou_BankSwitch_C0_SetCurrent
                                                            #
                                                            #     ld a,ixl
                                                            #
                                                            #     ;Check if the game is paused
                                                            #     Player_Handler_Pause:
                                                            #     bit Keymap_Pause,a
                                                            #     jr nz,Player_Handler_PauseCheckDone
                                                            #     ;0=normal nz=paused
                                                            #
                                                            #     ld hl,Timer_Pause_Plus1-1
                                                            #
                                                            #     ld a,(hl)
                                                            #     cpl
                                                            #     ld (hl),a
                                                            #     ld b,12
                                                            #
                                                            # WaitLoop:halt ; KeyboardScanner_ScanForOne
                                                            #     djnz WaitLoop
                                                            #     pop af
                                                            # ret
                                                            #
                                                            # Player_Handler_PauseCheckDone:
                                                            #     ld hl,Timer_TicksOccured
                                                            #     ld a,(hl)
                                                            #     or a
                                                            #     ret z               ;abort handler if game paused
                                                            #     xor a
                                                            #     ld (PlayerSaveShot_Plus1-1),a
                                                            #     ld (PlayerDoFire_Plus1-1),a
                                                            #
                                                            #     ld a,(hl)
                                                            #
                                                            #     and (iy+11)
                                                            #
                                                            #     jr z,Player_Handler_Start
                                                            #
                                                            #     ld (iy+2),0
                                                            #
                                                            #     ;Move the drones depending if the player is shooting
                                                            # Player_Handler_Start:
                                                            #     ld a,(iy+6) ;D1
                                                            #     inc a
                                                            #     cp 16
                                                            #     jr c,Player_Handler_DronePosOk
                                                            #     dec a
                                                            #
                                                            # Player_Handler_DronePosOk:
                                                            #     ld (iy+6),a ;D1 - shots and drones
                                                            #     add a
                                                            #     ld (Player_DroneOffset1_Plus1-1),a
                                                            #
                                                            #     ld c,(iy)   ;Y
                                                            #     ld b,(iy+1) ;X
                                                            #
                                                            #     ld e,8  :PlayerMoveSpeedFast_Plus1 ; Fast move speed - will be overriden if we're firing
                                                            #
                                                            # Player_Handler_KeyreadJoy1Fire2:
                                                            #     ld a,ixl
                                                            # SelfModifyingFire2: bit Keymap_F2,a
                                                            #     jr nz,Player_Handler_KeyreadJoy1Fire1
                                                            #     ;fire bullets
                                                            # SelfModifyingFire1: bit Keymap_F1,a
                                                            #     jr nz,Player_Handler_NoFireX
                                                            #
                                                            #     call Player_Handler_FireX       ; Xfire is a secret feature planned for the sequel
                                                            #     jr Player_Handler_KeyreadJoy1Up ; it activates when both fire buttons are pressed
                                                            #
 Player_Handler_NoFireX:                                    # Player_Handler_NoFireX:
        CALL SetFireDir_RIGHTsave; Fire2Handler_Plus2:      #     call SetFireDir_RIGHTsave :Fire2Handler_Plus2
                                                            #
                                                            # ;Player_ShootSkip
                                                            #     ld e,2  :PlayerMoveSpeedSlow1_Plus1 ; slow move speed as we're firing
                                                            #     ld a,ixl
                                                            #     jr Player_Handler_KeyreadJoy1Up
                                                            #
                                                            # Player_Handler_KeyreadJoy1Fire1:
                                                            #     ; Shoot left
                                                            # SelfModifyingFire1B:    bit Keymap_F1,a
                                                            #     jr nz,Player_Handler_KeyreadJoy1Up
                                                            #
                                                            #     ;fire bullets
        CALL SetFireDir_LEFTsave; Fire1Handler_Plus2:       #     call SetFireDir_LEFTsave    :Fire1Handler_Plus2
                                                            #
                                                            # ;Player_ShootSkip2
                                                            #     ld e,2  :PlayerMoveSpeedSlow2_Plus1; Slow move speed as we're firing
                                                            # Player_Handler_KeyreadJoy1Up:
                                                            #     ld a,e
                                                            #     ld a,ixl
                                                            #     bit Keymap_U,a
                                                            #     jr nz,Player_Handler_KeyreadJoy1Down
                                                            #     ld a,C
                                                            #     cp 24+16                ;Check we're onscreen
                                                            #     jr C,Player_Handler_KeyreadJoy1DownPre
                                                            #
                                                            #     sub e
                                                            #     ld C,a
                                                            #
        CALL NULL; FireUpHandler_Plus2:                     #     call null  :FireUpHandler_Plus2
                                                            #
                                                            # Player_Handler_KeyreadJoy1DownPre:
                                                            #     ld a,ixl
                                                            #
                                                            # Player_Handler_KeyreadJoy1Down:
                                                            #     bit Keymap_D,a
                                                            #     jr nz,Player_Handler_KeyreadJoy1Left
                                                            #     ld a,C
                                                            #
                                                            #     cp 200-16+24                ;Check we're onscreen
                                                            #     jr NC,Player_Handler_KeyreadJoy1LeftPre
                                                            #
                                                            #     add e
                                                            #     ld C,a
                                                            #
        CALL NULL; FireDownHandler_Plus2:                   #     call null   :FireDownHandler_Plus2
                                                            #
                                                            # Player_Handler_KeyreadJoy1LeftPre:
                                                            #     ld a,ixl
                                                            #
                                                            # Player_Handler_KeyreadJoy1Left:
                                                            #     bit Keymap_L,a
                                                            #     jr nz,Player_Handler_KeyreadJoy1Right
                                                            #     ld a,B
                                                            # ifdef CPC320
                                                            #     cp 12+24                ;Check we're onscreen
                                                            # else
                                                            #     cp 24+24                ;Check we're onscreen
                                                            # endif
                                                            #     jr C,Player_Handler_KeyreadJoy1RightPre
                                                            #
                                                            #     sub e
                                                            #     ld B,a
                                                            #
        CALL NULL; FireLeftHandler_Plus2:                   #     call null   :FireLeftHandler_Plus2
                                                            #
                                                            # Player_Handler_KeyreadJoy1RightPre:
                                                            #     ld a,ixl
                                                            #
                                                            # Player_Handler_KeyreadJoy1Right:
                                                            #     bit Keymap_R,a
                                                            #     jr nz,Player_Handler_SmartBomb
                                                            #     ld a,B
                                                            # ifdef CPC320
                                                            #     cp 160-12+24                ;Check we're onscreen
                                                            # else
                                                            #     cp 160-24+24                ;Check we're onscreen
                                                            # endif
                                                            #     jr NC,Player_Handler_SmartBombPre
                                                            #
                                                            #     add e
                                                            #     ld B,a
                                                            #
        CALL NULL; FireRightHandler_Plus2:                  #     call null   :FireRightHandler_Plus2
                                                            #
                                                            # Player_Handler_SmartBombPre:
                                                            #     ld a,ixl
                                                            #
                                                            # Player_Handler_SmartBomb:           ;Check if we should fire the smarbomb
                                                            #     bit Keymap_F3,a
                                                            #     jr nz,Player_Handler_KeyreadDone
                                                            #     ld a,(SmartBomb_Plus1-1)
                                                            #     or a
                                                            #     jr nz,Player_Handler_KeyreadDone
                                                            #
                                                            #     ld a,(iy+3) ; see if we've got any smartbombs left
                                                            #     sub 1
                                                            #     jr c,Player_Handler_KeyreadDone
                                                            #     ld (iy+3),a
                                                            #
                                                            #     call DoSmartBomb
                                                            #     ld a,3
                                                            #     call DoSmartBombFX
                                                            #
Player_Handler_KeyreadDone:                                 # Player_Handler_KeyreadDone:
        MOV  $0,R0; PlayerSaveShot_Plus2:                   #     ld a,0 :PlayerSaveShot_Plus1
        BEQ  Player_Handler_NoSaveFire                      #     or a
                                                            #     jr z,Player_Handler_NoSaveFire
                                                            #
        MOV  $0,R0; PlayerThisSprite_Plus2:                 #     ld a,0 :PlayerThisSprite_Plus1
        MOVB R0,8(R5)                                       #     ld (iy+8),a
                                                            #
        MOV  $0,R0; PlayerThisShot_Plus2:                   #     ld a,0 :PlayerThisShot_Plus1
        MOVB R0,15(R5)                                      #     ld (iy+15),a
                                                            #
Player_Handler_NoSaveFire:                                  # Player_Handler_NoSaveFire:
        MOV  8(R5),R0                                       #     ld a,(iy+8)

        BITB 0b100000000,8(R5)                              #     and %10000000
                                                            #     cp 1 :DroneFlipCurrent_Plus1
                                                            #     call nz,DroneFlip
                                                            #
                                                            #     ld a,0 :PlayerDoFire_Plus1
                                                            #     or a
                                                            #     call nz,Player_Fire4D
                                                            #
                                                            #     push bc
                                                            #         ld a,PlusSprite_ExtBank :PlayerSpriteBank_Plus1
                                                            #         call BankSwitch_C0_SetCurrent
                                                            #     pop bc
                                                            #
                                                            #     ld (iy),c   ;Y
                                                            #     ld (iy+1),b ;X
                                                            #
                                                            #     ld e,0
                                                            #     ld a,(Timer_CurrentTick_Plus1-1)
                                                            #     and %00000010           :PlayerSpriteAnim_Plus1
                                                            #     jr z,Player_Handler_Frame1
                                                            #     inc e
                                                            #
                                                            # Player_Handler_Frame1:
                                                            #     push de     ;save the frame no
                                                            #     ld a,B  :DroneDirPos8_Plus1;    ld a,c;ld a,B
                                                            #     sub 4
                                                            #     ld (SprShow_X),a    :DroneDirPos1_Plus2;    ld (SprShow_Y),a;ld (SprShow_X),a
                                                            #     ld a,(iy+4)
                                                            #     or a
                                                            #     jp z,Player_Handler_NoDrones
                                                            #
                                                            #     push iy
                                                            #     push bc
                                                            #
                                                            #     ld a,4
                                                            #
                                                            #         add e
                                                            #         ld (SprShow_SprNum),a
                                                            #
                                                            #         bit 1,(iy+4)
                                                            #         jr z,Player_Handler_OneDrone
                                                            #
                                                            #         ld a,-12
                                                            #         sub 16:Player_DroneOffset1_Plus1
                                                            #         call SetDronePos
                                                            #
                                                            # Drone2NoPlus:
                                                            #         call ShowSprite
                                                            #
                                                            # Drone2Plus:
                                                            #         pop bc
                                                            #         push bc
                                                            #         jr Player_Handler_OneDroneSkip
                                                            #
                                                            # Player_Handler_OneDrone:
                                                            # Player_Handler_OneDroneSkip:
                                                            #         ld a,(Player_DroneOffset1_Plus1-1);16Player_DroneOffset2_Plus1
                                                            #         call SetDronePos
                                                            #
                                                            # Drone1NoPlus:
                                                            #         call ShowSprite
                                                            # Drone1PlusRet:
                                                            #     pop bc
                                                            #     pop iy
                                                            # Player_Handler_NoDrones:
                                                            #     ld a,B
                                                            #     sub 7
                                                            #
                                                            #     ld (SprShow_X),a
                                                            #
                                                            # pop de  ;get back the frame num
                                                            #
                                                            #     ld a,(iy+7) ;invincibility
                                                            #
                                                            #     or a
                                                            #     jr z,Player_NotInvincible
                                                            #     ld a,(Timer_TicksOccured)
                                                            #     bit 1,a
                                                            #     jr z,Player_NotInvincible   ;invincible flash
                                                            #
                                                            #     bit 2,a
                                                            #     jr z,Player_SpriteSkip
                                                            #
                                                            #     dec (iy+7)  ;invincibility
                                                            #
                                                            # Player_SpriteSkip:
                                                            # ret
                                                            #
                                                            # Player_NotInvincible:
                                                            #
                                                            # push bc
                                                            #     ;draw the player
                                                            #     ld a,(iy+8)
                                                            #     and %00001111
                                                            #     add e
                                                            #     ld (SprShow_SprNum),a
                                                            #
                                                            # ShowPlayer_NoPlus:
                                                            #     ld a,c
                                                            #     sub 18
                                                            #     ld (SprShow_Y),a
                                                            #
                                                            #     call ShowSprite
                                                            # pop bc
                                                            # ret
                                                            #
                                                            # SetDronePos:
                                                            #     nop
                                                            #     nop              :DroneDirPos5_Plus2 ; sra a
                                                            #     add c            :DroneDirPos2_Plus1 ; add b
                                                            #     ld (SprShow_Y),a :DroneDirPos6_Plus2 ; ld (SprShow_X),a;ld (SprShow_Y),a
                                                            # ret
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
                                                            # Player_Fire4D:  ; Fire bullets!
        MOVB 8(R5),R0                                       #     ld a,(iy+8)
        BIC  $!0b10000000,R0                                #     and %10000000
        CMP  R0,$0; DroneFlipFireCurrent_Plus2:             #     cp 0 :DroneFlipFireCurrent_Plus1
                                                            #     call nz,DroneFlipFire
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
                                                            #         add d :DroneFlipFirePos3_Plus1
                                                            #
                                                            #         ld d,a  :DroneFlipFirePos2_Plus1;ld c,a ;Flip for X
                                                            #         call Stars_AddObject
                                                            #     pop bc
                                                            # ret
                                                            #
                                                            # DroneFlipFire:
                                                            #     ld (DroneFlipFireCurrent_Plus1-1),a
                                                            #     push de
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
                                                            #     ld (DroneFlipFirePos3_Plus1-1),a
                                                            #     ld a,d
                                                            #     ld (DroneFlipFirePos2_Plus1-1),a
                                                            #     ld a,e
                                                            #     ld (DroneFlipFirePos5_Plus1-1),a
                                                            # jr DroneFlipFinish
                                                            #
                                                            # DroneFlip:
                                                            #     ld (DroneFlipCurrent_Plus1-1),a
                                                            #     push de
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
                                                            # DroneFlipFinish:
                                                            #     pop de
                                                            # ret
                                                            #
                                                            # SetFireDir_UP:
                                                            #     push bc
                                                            #     ld bc,&4C82
                                                            #     jr SetFireDir_Any
                                                            #
                                                            # SetFireDir_DOWN:
                                                            #     push bc
                                                            #     ld bc,&7C80
                                                            #     jr SetFireDir_Any
                                                            #
SetFireDir_LEFTsave:                                        # SetFireDir_LEFTsave:
        call SetFireDir_FireAndSave                         #     call SetFireDir_FireAndSave
                                                            # SetFireDir_LEFT:
                                                            #     push bc
                                                            #     ld bc,&6102
                                                            #     jr SetFireDir_Any
                                                            #
SetFireDir_RIGHTsave:                                       # SetFireDir_RIGHTsave:
        CALL SetFireDir_FireAndSave                         #     call SetFireDir_FireAndSave
                                                            #
                                                            # SetFireDir_RIGHT:
                                                            #     push bc
                                                            #     ld bc,&6700
                                                            #
                                                            # SetFireDir_Any:
                                                            #     ld a,b
                                                            #     ld (PlayerThisShot_Plus1-1),a
                                                            #
                                                            #     ld a,c
                                                            #
                                                            #     ld (PlayerThisSprite_Plus1-1),a
                                                            #     pop bc
                                                            # ret
                                                            #
                                                            # SetFireDir_FireAndSaveRestore:
                                                            #     ld a,(iy+8)
                                                            #     ld (PlayerThisSprite_Plus1-1),a
                                                            #
                                                            #     ld a,(iy+15)
                                                            #     ld (PlayerThisShot_Plus1-1),a
                                                            #
SetFireDir_FireAndSave:                                     # SetFireDir_FireAndSave:
        MOV  $0x67,R0                                       #     ld a,&67
        MOV  R0,@$srcPlayerSaveShot                         #     ld (PlayerSaveShot_Plus1-1),a
                                                            #
                                                            # SetFireDir_Fire:
                                                            #     ld (PlayerDoFire_Plus1-1),a
                                                            # ret
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
                                                            #     call null :SmartBombSpecial_Plus2 ; We can hack in our own smartbomb handler
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
                                                            #         call null : CustomSmartBombEnemy_Plus2
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
                                                            #         ld (hl),128+16  :PointsSpriteB_Plus1; Sprite
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
                                                            #         ; check player isn't dead!
                                                            #         ;push iy
                                                            # ;           push hl
                                                            # ;           pop iy
                                                            # ;           ld a,(iy+9)
                                                            # ;           or a
                                                            # ;       pop iy
                                                            # ;       ret z
                                                            #
                                                            #         ld a,iyl
                                                            #         cp 16+2
                                                            #         call z,null :customPlayerHitter_Plus2
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
                                                            #         cp 128+38   :DroneSprite_Plus1
                                                            #         jr z,Player_Hit_PowerupDrone
                                                            #         cp 128+39   :ShootSpeedSprite_Plus1
                                                            #         jr z,Player_Hit_PowerupShootSpeed
                                                            #         cp 128+40   :ShootPowerSprite_Plus1
                                                            #         jr z,Player_Hit_PowerupShootPower
                                                            #         cp 128+16   :PointsSprite_Plus1
                                                            #         jr z,Player_Hit_Points
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
PlayerKilled:                                               # PlayerKilled:
                                                            #     xor a
        CLRB 3(R5)                                          #     ld (iy+3),a
                                                            #
        POP  R5                                             #     pop iy
                                                            #         ld a,20
        MOV  $20,@$srcSpendTimeout                          #         ld (SpendTimeout_Plus1-1),a
                                                            #
                                                            #         ld a,100
        MOV  $100,@$srcShowContinueCounter                  #         ld (ShowContinueCounter_Plus1-1),a
RETURN                                                      # ret
                                                            #
                                                            # ;******************************************************************************;
                                                            # ;*                                  Player UI                                 *;
                                                            # ;******************************************************************************;
                                                            #
                                                            # Player_DrawUI_IconLoop:     ; Used for Health and Smartbomb icons
                                                            #     ld a,b
                                                            #     or a
                                                            #     ret z
                                                            #
                                                            #     ld a,(SprShow_Y)
                                                            #     ld (SprShow_TempY),a
                                                            #
                                                            #     ld a,c
                                                            #     ld (SprShow_TempX),a
                                                            #
                                                            #     push bc
                                                            #         call ShowSpriteDirect
                                                            #     pop bc
                                                            #     dec b
                                                            #     ld a,c
                                                            #     add a,4 :Player_DrawUI_IconLoop_MoveSize_Plus1
                                                            #     ld c,a
                                                            #
                                                            #     jr Player_DrawUI_IconLoop
                                                            # Player1DoContinue:
                                                            #     ld a,(ShowContinueCounter_Plus1-1)
                                                            #     or a
                                                            #     call nz, Player1Continue
                                                            #     jr Player1_DeadUI
Player2DoContinue:                                          # Player2DoContinue:
        MOV  $100,R0                                        #     ld a,100    :ShowContinueCounter_Plus1
    ShowContinueCounter_Plus2:
        # MOV sets flags as well                            #     or a
        BEQ  1$
        CALL Player2Continue                                #     call nz,Player2Continue
1$:     JMP  Player2_DeadUI                                 #     jr Player2_DeadUI
                                                            #
Player_DrawUI:                                              # Player_DrawUI: ; We put PLus sprite anims here, as they
                                                            #                ; have to be run after the playerhandler
                                                            #                ; and mess up practically ALL registers
                                                            #
                                                            # TwoDronesOnscreen:
                                                            #     ld iy,Player_Array
                                                            #     ld a,(P1_P09)   ;See how many lives are left
                                                            #     or a
                                                            #     jr z,Player1DoContinue
                                                            #     call Player1DrawUI
                                                            #
                                                            # Player1_DeadUI:
                                                            # ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Player 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                            #     ld iy,Player_Array2
                                                            #     ld a,(P2_P09)   ;See how many lives are left
                                                            #     or a
                                                            #
                                                            #     jr z,Player2DoContinue
                                                            #     call Player2DrawUI
                                                            #
Player2_DeadUI:                                             # Player2_DeadUI:
                                                            #     ld a,(LivePlayers)
                                                            #     cp 2
                                                            #     ret nc
                                                            #     ;1 player or less!
                                                            #     ld a,(ShowContinueCounter_Plus1-1)
                                                            #     or a
                                                            #     ret z
                                                            #     call SpriteBank_Font2
                                                            #     ld l,&00;14  ; show how many credits are left
                                                            #
ShowContinues:                                              # ShowContinues:
        MOV  $0x0E,R3; ContinuesScreenPos_Plus2:            #     ld h,&0E    :ContinuesScreenpos_Plus1
                                                            #     ld bc,txtCreditsMsg2
                                                            #     call DrawText_LocateAndPrintStringUnlimited
                                                            #
                                                            #     ld a,(P1_P05)
                                                            #     call DrawText_Decimal
                                                            #
ShowContinuesSelfMod:                                       # ShowContinuesSelfMod:
        MOV  $'/, R0                                        #     ld a,"/"
                                                            #     call Akuyou_DrawText_CharSprite
                                                            #
                                                            #     ld a,(P2_P05)
                                                            #     jp DrawText_Decimal
                                                            #
Player2Continue:                                            # Player2Continue:
                                                            # ifdef CPC320
                                                            #     ld hl,&1e01;14              ; show how many credits are left
                                                            # else
                                                            #     ld hl,&1a01;14              ; show how many credits are left
                                                            # endif
                                                            #     jr Player1ContinueB
                                                            #
                                                            # Player1Continue:
                                                            # ifdef CPC320
                                                            #     ld hl,&0101;14              ; show how many credits are left
                                                            # else
                                                            #     ld hl,&0501;14              ; show how many credits are left
                                                            # endif
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
                                                            # Player_DrawUIDual:
                                                            #     ld (Player_DrawUI_IconLoop_MoveSize_Plus1-1),a
                                                            #     ld a,b
                                                            #     ld (Player_DrawUI_IconLoop_XPos_Plus1-1),a
                                                            #
                                                            #     ld hl,Akuyou_PlayerSpritePos
                                                            #     ld (SprShow_BankAddr),hl
                                                            #
                                                            #     xor a
                                                            #     ld (SprShow_Xoff),a
                                                            #
                                                            #     ld b,(iy+9) ;LIves
                                                            #
                                                            #     ld a,7
                                                            #
                                                            #     ld (SprShow_SprNum),a
                                                            #
                                                            #     ld a,8
                                                            #     ld (SprShow_Y),a
                                                            #     ;lives
                                                            #     ld c,0 :Player_DrawUI_IconLoop_XPos_Plus1
                                                            #     push bc
                                                            #         push iy
                                                            #             call Player_DrawUI_IconLoop
                                                            #         pop iy
                                                            #
                                                            #         ld a,6
                                                            #         ld (SprShow_SprNum),a
                                                            #
                                                            #     ifdef CPC320
                                                            #         ld a,180
                                                            #     else
                                                            #         ld a,192-16
                                                            #     endif
                                                            #         ld (SprShow_Y),a
                                                            #
                                                            #     pop bc
                                                            #     ;smart bombs
                                                            #
                                                            #     ld b,(iy+3) ;D1
                                                            #     jp Player_DrawUI_IconLoop
                                                            #
                                                            # Player1DrawUI:
                                                            #     ld a,4
                                                            #     ld b,0
                                                            #     ld de,3*4+PlusSprites_Config1+3
                                                            #     ld hl,PlusSprites_Config2+3
                                                            #
                                                            #     call Player_DrawUIDual
                                                            # ifdef CPC320
                                                            #     ld a,7
                                                            #     ld hl,&0003
                                                            # else
                                                            #     ld a,7+4
                                                            #     ld hl,&0403     ;Burst postition
                                                            # endif
                                                            #     ld iy,Player_Array
                                                            #     ld de, Player_ScoreBytes
                                                            #
                                                            #     jr Player_DrawUI_PlusAsWell
                                                            #
                                                            # Player2DrawUI:
                                                            #     ld a,-4
                                                            #
                                                            #     ifdef CPC320
                                                            #         ld b,80-4
                                                            #     else
                                                            #         ld b,64-4
                                                            #     endif
                                                            #
                                                            #     ld de,3*4+PlusSprites_Config2+3
                                                            #     ld hl,PlusSprites_Config1+3
                                                            #
                                                            #     call Player_DrawUIDual
                                                            #
                                                            # ifdef CPC320
                                                            #     ld hl,&2503
                                                            #     ld a,40-1
                                                            # else
                                                            #     ld hl,&2103 ;Burst postition
                                                            #     ld a,36-1
                                                            # endif
                                                            #     ld iy,Player_Array2
                                                            #     ld de, Player_ScoreBytes2
                                                            #
                                                            # Player_DrawUI_PlusAsWell:
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
                                                            # ScoreAddRepeat:             ;This does our rolling up effect on the score!
                                                            #     push hl
                                                            #         call Player_UpdateScore
                                                            #     pop hl
                                                            #     ld a,(iy+13)
                                                            #     cp 30               ; if waiting score goes over 30, add faster
                                                            #     jr nc,ScoreAddRepeat        ; this is for the 'coffee time' effect at the
                                                            #                     ; end of level 9
                                                            #
                                                            #     ;Show the remaining 'burst fire' power
                                                            #     ld hl,&0003 : BurstDrawPos_Plus2
                                                            #     call DrawText_LocateSprite
                                                            #     ld a,(iy+10)
                                                            #     or a
                                                            #     call nz,DrawText_Decimal
                                                            #
                                                            #     ret: CheatMode_Plus1
                                                            #
                                                            #     ; CHEAT MODE!           Sssh, we set cheats here - as some levels steal our powerups,
                                                            #     ;           done During the level not before
                                                            # ;   ld iy,Player_Array
                                                            # ;   ld hl,
                                                            # ;   ld a,(hl)
                                                            # ;
                                                            # ;   or %00011000
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
