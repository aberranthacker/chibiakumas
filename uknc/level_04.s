               .list

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level04SizeWords, (end - start) >> 1
               .global Level04SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

       .incbin "build/level_04.0.spr"
LevelSprites2:
       .incbin "build/level_04.1.spr"
ChibiSprites:
       .incbin "build/chibi_lr.spr"
LevelTiles:
       .incbin "build/level_03_tiles.spr"

EventStreamArray:
# UseBackgroundFloodFillQuadSpriteColumn equ 1
.equiv DUMMY_SPRITE, 0

.equiv BOSS_ABOVE_75_A,      1
.equiv BOSS_ABOVE_75_B,      2
.equiv BOSS_ABOVE_75_C,      3
.equiv BOSS_BELOW_75_A,      4
.equiv BOSS_BELOW_75_B,      5
.equiv BOSS_BELOW_75_C,      6
.equiv COIN,                 7 # 16
.equiv AKANBEE,              8 # 15
.equiv LAMBTRON,             9 # 17
.equiv CHU,                 10 # 19
.equiv CHU_TEXT,            11 # 20
.equiv SHOE,                12 # 18
.equiv BOSS_ABOVE_75_HIT_A, 13
.equiv BOSS_ABOVE_75_HIT_B, 14
.equiv BOSS_ABOVE_75_HIT_C, 15
.equiv BOSS_BELOW_75_HIT_A, 16
.equiv BOSS_BELOW_75_HIT_B, 17
.equiv BOSS_BELOW_75_HIT_C, 18
.equiv BOSS_DEAD_A,         19
.equiv BOSS_DEAD_B,         20
.equiv BOSS_DEAD_C,         21

# We will use 4 Paralax layers
#  ---------()- (sky)           %11001000
#  ------------ (Far)           %11000100
#  -----X---X-- (mid)           %11000010       Bank 1
#  []=====[]=== (foreground)    %11000001       Bank 0
 # Install a custom hit handler
  .word 0, evtReprogramHitHandler, CustomObjectHitHandler
 # Custom move code
  .word 0, evtReprogramCustomMove1, CustomMove.YoYo
 # Define powerup sprites
  .word 0, evtReprogram_PowerupSprites 
  .byte    sprTwoFrame | DUMMY_SPRITE
  .byte    sprTwoFrame | DUMMY_SPRITE
  .byte    sprTwoFrame | DUMMY_SPRITE
  .byte    sprTwoFrame | COIN

  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgBitShift, mveBackground | 0b0001, lifeImmortal
  .word    evtSetObjectSize | 0             # 2
  .word    evtSetAnimator | anmNone         # 3
  .word    evtAddToBackground               # 4
  .word    evtSaveObjSettings | 0           # 5

  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgBitShift, mveBackground | 0b0010, lifeImmortal
  .word    evtSetObjectSize | 0             # 2
  .word    evtSetAnimator | anmNone         # 3
  .word    evtAddToBackground               # 4
  .word    evtSaveObjSettings | 1           # 5
 # Lambtron
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife
  .word        prgFireAboveAvg | fireSingleNorthWest
  .word        mvRegular | spdFast | 041
  .word        lifeEnemy | 3
  .word    evtSetSprite | sprTwoFrame | LAMBTRON
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 2
 # Shoe!
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 074, lifeEnemy | 6
  .word    evtSetSprite | sprSingleFrame | SHOE
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 3
 # CHU!
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgNone, mveSeaker, lifeEnemy | 6
  .word    evtSetSprite | sprTwoFrame | CHU
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 4
 # CHU! Text
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgNone, mvStatic, lifeTimed | 3
  .word    evtSetSprite | sprTwoFrame | CHU_TEXT
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 5
#-------------------------------------------------------------------------------
# Start of fade in block -------------------------------------------------------
    .equiv FadeStartPoint, 0
    .word FadeStartPoint + 1, evtSetPalette, BluePalette
    .word FadeStartPoint + 2, evtSetPalette, DarkRealPalette
    .word FadeStartPoint + 3, evtSetPalette, RealPalette
# End of fade in block ---------------------------------------------------------

    #----------
   #.word 3, evtChangeStreamTime, 100, EventStreamArray_DebugPoint
    #----------
EventStreamArray_DebugPoint:
 # hit target
  .word 10, evtMultipleCommands | 3
  .word     evtSetProgMoveLife, prgSpecial, mveCustom1, lifeEnemy | 40
  .word     evtSingleSprite, sprSingleFrame | DUMMY_SPRITE, (24+160+9)<<X | (24+64+24-24+8)<<Y
  .word     evtSaveObjPointer, BossTarget
 # boss1
  .word 10, evtMultipleCommands | 6
  .word     evtAddToBackground
  .word     evtLoadObjSettings | 1
  .word     evtSetProg, prgNone
  .word     evtSetMove, mveCustom1
  .word     evtSingleSprite, sprTwoFrame | BOSS_ABOVE_75_A, (24+160)<<X | (24+64-24+8)<<Y
  .word     evtSaveObjPointer, BossObject1
 # Boss2
  .word 13, evtMultipleCommands | 6
  .word     evtAddToBackground
  .word     evtLoadObjSettings | 1
  .word     evtSetProg, prgNone
  .word     evtSetMove, mveCustom1
  .word     evtSingleSprite, sprTwoFrame | BOSS_ABOVE_75_B, (24+160)<<X | (24+64-24+8)<<Y
  .word     evtSaveObjPointer, BossObject2
 # Fire target 1
  .word 13, evtMultipleCommands | 3
  .word     evtSetProgMoveLife, prgFireSlow | fireBurst, mveCustom1, lifeImmortal
  .word     evtSingleSprite, sprSingleFrame | DUMMY_SPRITE, (24+160+3)<<X | (24+64-24+8)<<Y
  .word     evtSaveObjPointer, FireTarget1
 # Boss3
  .word 16, evtMultipleCommands | 6
  .word     evtAddToBackground
  .word     evtLoadObjSettings | 1
  .word     evtSetProg, prgNone
  .word     evtSetMove, mveCustom1
  .word     evtSingleSprite, sprTwoFrame | BOSS_ABOVE_75_C, (24+160)<<X | (24+64-24+8)<<Y
  .word     evtSaveObjPointer, BossObject3
 # akanbee
  .word 26, evtMultipleCommands | 2
  .word     evtSetProgMoveLife, prgNone, mvStatic, lifeTimed | 3
  .word     evtSingleSprite, sprTwoFrame | AKANBEE, (24+120)<<X | (24+179)<<Y

AttackLoop:
 # Lambtron
  .word 30, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Lambtron
  .word 32, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Lambtron
  .word 34, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Lambtron
  .word 36, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Shoe!
  .word 36, evtMultipleCommands | 8
  .word     evtLoadObjSettings | 3
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 1)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 3)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 5)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 7)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 9)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12*11)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12*13)<<X | (24)<<Y
 # Lambtron
  .word 50, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Lambtron
  .word 52, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Lambtron
  .word 54, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Lambtron
  .word 56, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 2
  .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
 # Shoe!
  .word 56, evtMultipleCommands | 8
  .word     evtLoadObjSettings | 3
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 0)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 2)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 4)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 6)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12* 8)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12*10)<<X | (24)<<Y
  .word     evtSingleSprite, sprSingleFrame | SHOE, (24+12*12)<<X | (24)<<Y

  .word 80, evtChangeStreamTime, 20, AttackLoop

ChuAttack:
  .word 25, evtAddToForeground

  .word 25, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 4
  .word     evtSingleSprite, sprTwoFrame | CHU
              ChuYa: .byte 24+140
              ChuXa: .byte 24+170

  .word 25, evtMultipleCommands | 2
  .word     evtLoadObjSettings | 5
  .word     evtSingleSprite, sprTwoFrame | CHU_TEXT
              ChuYb: .byte 24+140
              ChuXb: .byte 24+170

  .word 25,evtAddToBackground

  .word 25, evtChangeStreamTime
              EndChuTime: .word 20
              EndChuPointer: .word AttackLoop

LevelEndAnim:
    .word 253, evtMultipleCommands | 3
    .word      evtCallAddress, Player_Handler_DoSmartBomb
    .word      evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word      evtSingleSprite, sprTwoFrame | DUMMY_SPRITE, (24+140)<<X | (24+100)<<Y
# Start of fade out block ------------------------------------------------------
    .equiv FadeOutStartPoint, 253
    .word FadeOutStartPoint + 1, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 2, evtSetPalette, BluePalette
    .word FadeOutStartPoint + 3, evtCallAddress, EndLevel
#----------------------------------------------------------------------------}}}
EndLevel:
       .ppudo_ensure $PPU_LevelEnd
       .ppudo_ensure $PPU_MusicStop
        MOV  $0x8000,R5
        JMP  ExecuteBootstrap

LevelInit:
       .ppudo_ensure $PPU_LevelMusicRestart
        MOV  $LevelSprites,R0
        MOV  $SpriteBanksVectors,R1
        MOV  R0,(R1)+
        MOV  R0,(R1)+
        MOV  $LevelSprites2,(R1)+
        MOV  R0,(R1)+

        MOV  $EventStreamArray,R5
        CALL EventStream_Init
        MTPS $PR0
LevelLoop:
        CALL @$Background_Draw

        CALL @$EventStream_Process
        CALL @$ObjectArray_Redraw

        MOV  $ChibiSprites,@$SprShow_BankAddr
        CALL @$PlayerHandler

        CALL @$Player_StarArray_Redraw
        CALL @$StarArray_Redraw

        CALL @$ScreenBuffer_Flip

       .equiv ShowBossText_WaitOpcode, .
        WAIT # added to give PPU time to draw boss text

       .equiv FadeCommandCall, .+2
        CALL @$null

        CALL TRandW
        BICB $0b11111000,R0
        CMPB R0,$0b00000111
        BNE  LevelLoop.NoWarp
        CALL StarArrayWarp # welcome to hell!
LevelLoop.NoWarp:
       .equiv BossHurt, .+2
        TST  $0
        BZE  LevelLoop.DontReset

        DEC  @$BossHurt
        BNZ  LevelLoop.DontReset

        MOV  @$BossObject1,R5
        MOV  @$BossSpriteNum1,R0
        BIS  $sprTwoFrame,R0
        MOVB R0,3(R5)

        MOV  @$BossObject2,R5
        MOV  @$BossSpriteNum2,R0
        BIS  $sprTwoFrame,R0
        MOVB R0,3(R5)

        MOV  @$BossObject3,R5
        MOV  @$BossSpriteNum3,R0
        BIS  $sprTwoFrame,R0
        MOVB R0,3(R5)

LevelLoop.DontReset:
        BR   LevelLoop
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;;         Level specific code                                  ;;
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      # Warp the bullet array (for boss battles)
       .include "star_array_warp.s"

Background_Draw:
        MOV  $0,R0 # 0=left
        CALL @$Background_GradientScroll

        MOV  @$ScreenBuffer_ActiveScreen,R5

        CALL @$Timer_UpdateTimer # R0 = SmartBomb color or 0
        BNZ  Background_SmartBomb

       .equiv jmpBackgroundRender, .+2
        JMP  @$Background_DrawB

Background_SmartBomb:
        MOV  $200,R1
        JMP  @$Background_SolidFill

Background_DrawB:
        MOV  $GradientTop,R3 # 40 lines
        MOV  $GradientTopStart,R1
        MOV  $0b11111100,R2  # Shift on Timer Ticks
        CALL @$Background_Gradient

        CLR  R0 # sprite number
        MOV  $LevelTiles,R4
        CALL GetSpriteMempos

      # we will need the position later for Tile bitshifts
        MOV  R4,-(SP)
        MOV  $8,R1
        MOV  $1,R2
        CALL @$Background_FloodFillQuadSpriteColumn

        CLR  R0
        MOV  $4,R1
        CALL @$Background_SolidFill

        MOV  $16,R1
        MOV  $3,R2
        CALL @$Background_FloodFillQuadSpriteColumn

        CLR  R0
        MOV  $4,R1
        CALL @$Background_SolidFill

        MOV  $8,R1
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $16,R1
        CALL @$Background_SolidFill

        MOV  $GradientBottom,R3 # 40 lines
        MOV  $GradientBottomStart,R1
        MOV  $0b11111111,R2 # Shift on Timer Ticks
        MOV  R4,-(SP) # Background_Gradient corrupts R4
        CALL @$Background_Gradient
        MOV  (SP)+,R4

        MOV  $8,R1 # number of lines
        CALL @$Background_FloodFillQuadSprite
# Tile Bitshifts ---------------------------------------------------------------
      # pop de ;needed to keep this for the bitshifts
        MOV  (SP)+,R5 # ponter to the first tile

       .equiv TileWidthBytes, 8
      # we do MOV  -(R5),R0 to read words, to be able to use ASH for shifts
      # so R5 should point to next line
        ADD  $TileWidthBytes,R5

        MOV  $0b11111110,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $8,R2              # lines
        CALL @$BitShifter       #

        MOV  $0b11111100,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $16,R2             # lines
        CALL @$BitShifter       #

        MOV  $0b11111110,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $8,R2              # lines
        CALL @$BitShifter       #

        MOV  $0b11111111,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $8,R2              # lines
        CALL @$BitShifterDouble #

        RETURN
# Background Data ----------------------------------------------#
   .equiv GradientTopStart, 40 # lines count                    #
 GradientTop:                                                   #
    .word 0xFF00, 0xFF00                # 1st line              # defb &0F,&0F    ;1; first line
    .word GradientTopStart - 10, 0xDD00 # 2nd line num, new word# defb GradientTopStart-10,&0D ;2; line num, New byte
    .word GradientTopStart - 16, 0x7700                         # defb GradientTopStart-16,&07 ;3
    .word GradientTopStart - 20, 0xAA00                         # defb GradientTopStart-20,&0A ;4
    .word GradientTopStart - 26, 0x5500                         # defb GradientTopStart-26,&05 ;5
    .word GradientTopStart - 30, 0x8800                         # defb GradientTopStart-30,&08 ;6
    .word GradientTopStart - 36, 0x2200                         # defb GradientTopStart-36,&02 ;7
    .word GradientTopStart - 38, 0x0000                         # defb GradientTopStart-38,&00 ;7
    .word GradientTopStart - 40, 0x0000                         # defb GradientTopStart-40,&00 ;7
    .word 0xFFFF                                                # defb 255

    .equiv GradientBottomStart, 40 # lines count
 GradientBottom:                                                #
    .word 0x0000, 0x0000 # 1st line                             # defb &0,&0  ;1; first line
    .word 40, 0x0022     # 2nd line num, new word               # defb 40,&20 ;10
    .word 36, 0x0088                                            # defb 36,&80 ;11
    .word 30, 0x0055                                            # defb 30,&50 ;12
    .word 26, 0x00AA                                            # defb 26,&A0 ;13
    .word 20, 0x0077                                            # defb 20,&70 ;14
    .word 10, 0x00DD                                            # defb 10,&D0 ;15
    .word  4, 0x00FF                                            # defb 4,&F0  ;15
    .word  2, 0x00FF                                            # defb 2,&F0  ;15
    .word 0xFFFF                                                # defb 255
#---------------------------------------------------------------#
        BossMovingObjectsStart:

        BossSpriteNum1: .word BOSS_ABOVE_75_A
        BossSpriteNum2: .word BOSS_ABOVE_75_B
        BossSpriteNum3: .word BOSS_ABOVE_75_C

        BossObject1: .word 0x0000
        BossObject2: .word 0x0000
        BossObject3: .word 0x0000
        FireTarget1: .word 0x0000
        FireTarget2: .word 0x0000
        FireTarget3: .word 0x0000

        BossTarget: .word 0x0000

        BossMovingObjectsEnd:

      # in:  R1 C = Y
      #      R2 LSB D = move,
      #      R2 MSB iyh = sprite
      #      R3 LSB ixl = Life,
      #      R3 MSB iyl = Program Code
      #      R4 B = X
CustomObjectHitHandler:
        MOV  R3,R0
        SWAB R0
        CMPB R0,$prgSpecial
        BEQ  1$
      # just run the normal routine, if this object isn't the boss target
        JMP  @$Object_DecreaseLifeShot
    1$:
        CLRB R3
        BISB $(lifeEnemy | 40),R3
        PUSH R5

        MOV  @$BossSpriteNum1,R0
        ADD  $12,R0
        MOV  @$BossObject1,R5
        MOVB R0,3(R5)

        MOV  @$BossSpriteNum2,R0
        ADD  $12,R0
        MOV  @$BossObject2,R5
        MOVB R0,3(R5)

        MOV  @$BossSpriteNum3,R0
        ADD  $12,R0
        MOV  @$BossObject3,R5
        MOVB R0,3(R5)

        CALL TRandW                         # ld a,r
        BIC  $0xFFC0,R0                     # srl a
                                            # srl a
        ADD  $120,R0                        # add 120
        MOV  @$FireTarget1,R5               # ld hl,(FireTarget1)
        MOVB R0,(R5)                        # call SetObjectY

        CALL TRandW                         # ld a,r
        BIC  $0xFFC0,R0                     # srl a
                                            # srl a
        ADD  $120,R0                        # add 120
        MOV  @$FireTarget2,R5               # ld hl,(FireTarget2)
        MOVB R0,(R5)                        # call SetObjectY

        CALL TRandW                         # ld a,r
        BIC  $0xFFC0,R0                     # srl a
                                            # srl a
        ADD  $120,R0                        # add 120
        MOV  @$FireTarget3,R5               # ld hl,(FireTarget3)
        MOVB R0,(R5)                        # call SetObjectY

        MOV  $3,@$BossHurt

       .equiv BossLife, .+2
        DEC  $150
        MOV  @$BossLife,R0
        CMP  R0,$75
        BEQ  BossLife3
        CMP  R0,$1
        BEQ  BossLife5
        POP  R5
        RETURN

BossLife5:
      # boss is dead
      # R3 LSB ixl = Life,
        CLRB R3 # Make object immortal
        CLR  @$BossHurt

        MOV  @$FireTarget1,R5
        CLRB 5(R5) # object program
        MOV  @$FireTarget2,R5
        CLRB 5(R5)
        MOV  @$FireTarget3,R5
        CLRB 5(R5)

        MOV  @$BossObject1,R5
        MOVB $(sprSingleFrame | BOSS_DEAD_A),3(R5)
        MOV  @$BossObject2,R5
        MOVB $(sprSingleFrame | BOSS_DEAD_B),3(R5)
        MOV  @$BossObject3,R5
        MOVB $(sprSingleFrame | BOSS_DEAD_C),3(R5)

        MOV  $249,R0
        MOV  $LevelEndAnim,R5
        CALL SetLevelTime
        POP  R5
        RETURN

BossLife3:
        MOV  $BOSS_BELOW_75_A,@$BossSpriteNum1
        MOV  $BOSS_BELOW_75_B,@$BossSpriteNum2
        MOV  $BOSS_BELOW_75_C,@$BossSpriteNum3
        POP  R5
        RETURN

      # in:  R1 C = Y
      #      R2 LSB D = move,
      #      R2 MSB iyh = sprite
      #      R3 LSB ixl = Life,
      #      R3 MSB iyl = Program Code
      #      R4 B = X
CustomMove.YoYo:
        CMP  @$BossLife,$1
        BEQ  1237$ # dont mess with moves if the boss is dead

        MOV  @$Timer_TicksOccured,R0
        BZE  1237$ # Only run every two ticks on v9990

        BIT  $0b0100,R0
        BZE  CustomMove.YoYo.NoTick
      
       .equiv CustomMove.YoYo.Timer_CurrentTick, .+2
        CMP  $0,@$Timer_CurrentTick
        BZE  CustomMove.YoYo.NoTick

        MOV  @$Timer_CurrentTick,@$CustomMove.YoYo.Timer_CurrentTick
        INC  @$CustomMove.YoYo.Counter
CustomMove.YoYo.NoTick:
       .equiv CustomMove.YoYo.Counter, .+2
        MOV  $0,R0
        CMP  R0,$12
        BHIS CustomMove.YoYo.AttackRetreat

        DEC  R4 # X coordinate
1237$:  RETURN

CustomMove.YoYo.AttackRetreat:
        CMP  R0,$32
        BLO  CustomMove.YoYo.NoAttack
        CMP  R0,$32+16
        BHIS CustomMove.YoYo.NoAttack
        CMP  R0,$32+8
        BHIS CustomMove.YoYo.Retreat
        SUB  $4,R4
        BR   CustomMove.YoYo.NoAttack

CustomMove.YoYo.Retreat:
        ADD  $4,R4
CustomMove.YoYo.NoAttack:
        CMP  R0,$32+16
        BNE  CustomMove.YoYo.Vert

        MOV  @$Event_NextEventPointer,R0
        DEC  R0
        DEC  R0 # now R0 points to the next event time
        MOV  R0,@$EndChuPointer
        MOV  @$Event_NextEventTime,@$EndChuTime
        MOVB R4,@$ChuXa
        MOVB R4,@$ChuXb
        MOVB R1,@$ChuYa
        MOVB R1,@$ChuYb
        PUSH R5
        MOV  $ChuAttack,R5
        MOV  $24,R0
        CALL SetLevelTime
        POP  R5
        MOVB $12,@$CustomMove.YoYo.Counter
CustomMove.YoYo.Vert:
        BIT  $0x10,@$Timer_CurrentTick
        BZE  CustomMove.YoYo.Up
#CustomMove.YoYo.Down:
        SUB  $6,R1
        RETURN
CustomMove.YoYo.Up:
        ADD  $6,R1
        RETURN

BluePalette: #---------------------------------------------------------------{{{
    .word 0, cursorGraphic, scale320 | rgb
    .byte 1, setColors, Black, Blue, Blue, Magenta
    .word endOfScreen
#----------------------------------------------------------------------------}}}
DarkRealPalette: #-----------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | rgb
    .byte   1, setColors, Black, brBlue,  Gray, White
    .byte  65, setColors, Black, Magenta, Gray, White
    .byte 160, setColors, Black, Red,     Gray, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
RealPalette: #---------------------------------------------------------------{{{
    .byte   0, setOffscreenColors
    .word      BLACK  | BR_BLUE    << 4 | BR_GREEN  << 8 | BR_CYAN << 12
    .word      BR_RED | BR_MAGENTA << 4 | BR_YELLOW << 8 | WHITE   << 12

    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Red,     brGreen, White
    .byte 150, setColors, Black, Magenta, brGreen, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
end:
