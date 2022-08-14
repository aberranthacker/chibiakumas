               .list

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level02SizeWords, (end - start) >> 1
               .global Level02SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

       .incbin "build/level_02.0.spr"
LevelSprites2:
       .incbin "build/level_02.1.spr"
ChibiSprites:
       .incbin "build/chibi_lr.spr"
LevelTiles:
       .incbin "build/level_02_tiles.spr"

EventStreamArray:
.equiv DUMMY_SPRITE, 0
.equiv COIN, 1

.equiv SKULL_100_A, 2
.equiv SKULL_100_B, 3

.equiv LEGS_LEFT_A,  4
.equiv LEGS_LEFT_B,  5
.equiv LEGS_LEFT_C,  6

.equiv LEGS_RIGHT_A, 7
.equiv LEGS_RIGHT_B, 8
.equiv LEGS_RIGHT_C, 9

.equiv HAND_UP,     10
.equiv HAND_DOWN,   11
.equiv HAND_LEFT,   12
.equiv HAND_RIGHT,  13

.equiv SKULL_80_A, 14
.equiv SKULL_80_B, 15
.equiv SKULL_60_B, 16
.equiv SKULL_40_B, 17
.equiv SKULL_20_B, 18
.equiv SKULL_0_A,  19
.equiv SKULL_0_B,  20

.equiv SKULL_100_C, 21
.equiv SKULL_80_C,  22
.equiv SKULL_60_C,  23
.equiv SKULL_40_C,  24
.equiv SKULL_20_C,  25
.equiv SKULL_0_C,   26

.word 0, evtReprogram_PowerupSprites
.byte      sprTwoFrame | DUMMY_SPRITE
.byte      sprTwoFrame | DUMMY_SPRITE
.byte      sprTwoFrame | DUMMY_SPRITE
.byte      sprTwoFrame | COIN

# ;We will use 4 Paralax layers
# ; ---------()- (sky)        %11001000
# ; ------------ (Far)        %11000100
# ; -----X---X-- (mid)        %11000010   Bank 1
# ; []=====[]=== (foreground)     %11000001   Bank 0
#
 .word 0, evtReprogramHitHandler, CustomObjectHitHandler

# Background L

.word 0, evtMultipleCommands | 5
.word    evtSetProgMoveLife, prgBitShift, mveBackground | 0b0001, lifeImmortal
.word    evtSetObjectSize | 0
.word    evtSetAnimator | anmNone
.word    evtAddToBackground
.word    evtSaveObjSettings | 0

.word 0, evtMultipleCommands | 5
.word    evtSetProgMoveLife, prgBitShift, mveBackground | 0b0010, lifeImmortal
.word    evtSetObjectSize | 0
.word    evtSetAnimator | anmNone
.word    evtAddToBackground
.word    evtSaveObjSettings | 1

# Hand Up
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 014, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 3

# Hand Down
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 074, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 4

# Hand left
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 041, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 5

# Hand right
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 047, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 6

# HandLeft1
.word 0, evtMultipleCommands | 6
.word    evtLoadObjSettings | 1
.word    evtSetProg, prgFrameAnimate | 0b101
.word    evtSetLife, lifeImmortal
.word    evtAddToBackground
.word    evtSingleSprite, sprSingleFrame | LEGS_LEFT_A, (24+160)<<X | (24+90+48+8)<<Y
.word    evtSaveObjPointer, HandObject1

# Start of fade in block -------------------------------------------------------
.equiv FadeStartPoint, 0
.word FadeStartPoint + 1, evtSetPalette, BluePalette
.word FadeStartPoint + 2, evtSetPalette, DarkRealPalette
.word FadeStartPoint + 3, evtSetPalette, RealPalette
# Start of fade in block -------------------------------------------------------
    #----------
#   .word 3, evtChangeStreamTime, 60, HandAttack1
    #----------

# HandLeft2
.word 13, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b011
.word     evtSingleSprite, sprSingleFrame | LEGS_LEFT_B, (24+160)<<X | (24+90+48+8)<<Y
.word     evtSaveObjPointer, HandObject2

# hit target
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgSpecial, mvSpecial | spdFast | 002, lifeEnemy | 40
.word     evtSingleSprite, DUMMY_SPRITE, (24+160+3)<<X | (24+90+16)<<Y
.word     evtSaveObjPointer, SkullTarget

DebugStartPoint:
# Fire target 1
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgFireSlow | fireLeft, mvSpecial | spdFast | 002, lifeImmortal
.word     evtSingleSprite, DUMMY_SPRITE, (24+160+3)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, FireTarget1

# Fire target 2
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgFireSnail | fireBurst, mvSpecial | spdFast | 002, lifeImmortal
.word     evtSingleSprite, DUMMY_SPRITE, (24+160+3)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, FireTarget2

# Fire target 3
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgFireSnail | fireBurst, mvSpecial | spdFast | 002, lifeImmortal
.word     evtSingleSprite, DUMMY_SPRITE, (24+160+3)<<X | (24+90)<<Y
.word     evtSaveObjPointer, FireTarget3

# Skull1
.word 20, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToForeground
.word     evtSetProg, prgNone
.word     evtSingleSprite, sprTwoFrame | SKULL_100_A, (24+160)<<X | (24+90)<<Y
.word     evtSaveObjPointer, SkullObject1

# HandLeft3
.word 25, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b100
.word     evtSingleSprite, sprSingleFrame | LEGS_LEFT_C, (24+160)<<X | (24+90+48+8)<<Y
.word     evtSaveObjPointer, HandObject3

# Skull2
.word 32, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToForeground
.word     evtSetProg, prgNone
.word     evtSingleSprite, sprTwoFrame | SKULL_100_B, (24+160)<<X | (24+90)<<Y
.word     evtSaveObjPointer, SkullObject2

# HandRight1
.word 38, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b011
.word     evtSingleSprite, sprSingleFrame | LEGS_RIGHT_A, (24+160)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, HandObject4

# Skull3
.word 44, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToForeground
.word     evtSetProg, prgNone
.word     evtSingleSprite, sprSingleFrame | SKULL_100_C, (24+160)<<X | (24+90)<<Y
.word     evtSaveObjPointer, SkullObject3

# HandRight2
.word 50, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b100
.word     evtSingleSprite, sprSingleFrame | LEGS_RIGHT_B, (24+160)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, HandObject5

# HandRight3
.word 62, evtMultipleCommands | 4
.word     evtLoadObjSettings | 1
.word     evtSetProg, prgFrameAnimate | 0b101
.word     evtSingleSprite, sprSingleFrame | LEGS_RIGHT_C, (24+160)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, HandObject6

.word 70, evtCallAddress, StopBossMovement

HandAttack1:
   .word 75, evtMultipleCommands | 7
   .word     evtLoadObjSettings | 3
   .word     evtSingleSprite, sprTwoFrame | HAND_UP, (24+ 12* 1)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_UP, (24+ 12* 3)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_UP, (24+ 12* 5)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_UP, (24+ 12* 7)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_UP, (24+ 12* 9)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_UP, (24+ 12*11)<<X | (160)<<Y

   .word 77, evtMultipleCommands | 8
   .word     evtLoadObjSettings | 4
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12* 0)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12* 2)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12* 4)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12* 6)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12* 8)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12*10)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_DOWN, (24+ 12*12)<<X | (24)<<Y

   .word 79, evtMultipleCommands | 6
   .word     evtLoadObjSettings | 6
   .word     evtSingleSprite, sprTwoFrame | HAND_RIGHT, (24)<<X | (24+ 24*0)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_RIGHT, (24)<<X | (24+ 24*2)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_RIGHT, (24)<<X | (24+ 24*4)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_RIGHT, (24)<<X | (24+ 24*6)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_RIGHT, (24)<<X | (24+ 24*8)<<Y

   .word 81, evtMultipleCommands | 6
   .word     evtLoadObjSettings | 5
   .word     evtSingleSprite, sprTwoFrame | HAND_LEFT, (160)<<X | (24+ 24*1)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_LEFT, (160)<<X | (24+ 24*3)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_LEFT, (160)<<X | (24+ 24*5)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_LEFT, (160)<<X | (24+ 24*7)<<Y
   .word     evtSingleSprite, sprTwoFrame | HAND_LEFT, (160)<<X | (24+ 24*9)<<Y

   .word 82, evtChangeStreamTime, 60, HandAttack1

LevelEndAnim:
    .word 253, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word      evtSingleSprite, sprTwoFrame | DUMMY_SPRITE, (24+140)<<X | (24+100)<<Y

    .equiv FadeOutStartPoint, 254
    .word FadeOutStartPoint, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 1, evtSetPalette, BluePalette

    .word 256, evtCallAddress, EndLevel

EndLevel:
        MOV  $0x8000,R5
        JMP  ExecuteBootstrap # Start the game, no return

LevelInit: # read "..\SrcALL\Akuyou_Multiplatform_Level_GenericInit.asm"
       .ppudo_ensure $PPU_BossMusicRestart

        MOV  $LevelSprites,R0
        MOV  $SpriteBanksVectors,R1
        MOV  R0,(R1)+
        MOV  R0,(R1)+
        MOV  $LevelSprites2,(R1)+
        MOV  R0,(R1)+

        MOV  $EventStreamArray,R5     # Event Stream
        CALL EventStream_Init
        CALL ScreenBuffer_Init
        MTPS $PR0
#-------------------------------------------------------------------------------
LevelLoop:
      #.include "level_levelloop_preflip.s" # read "..\SrcALL\Akuyou_Multiplatform_Level_Levelloop_PreFlip.asm"

       .equiv Background_Call, .+2
        CALL @$Background_Draw

        CALL @$EventStream_Process
        CALL @$ObjectArray_Redraw

        MOV  $ChibiSprites,@$SprShow_BankAddr
        CALL @$PlayerHandler

        CALL @$Player_StarArray_Redraw
        CALL @$StarArray_Redraw

        CALL @$ScreenBuffer_Flip

       .equiv FadeCommandCall, .+2
        CALL @$null

                                            # ld a,r
                                            # xor 0 :Randomizer_Plus1
                                            # ld (Randomizer_Plus1-1),a
                                            # and %00001100
                                            # call z,StarArrayWarp ; welcome to hell!
        TST  @$BossHurt
        BZE  DontReset

        DEC  @$BossHurt
        BNZ  DontReset

        MOV  @$SkullObject1,R5
        MOVB $(sprTwoFrame | SKULL_100_A),3(R5)
DontReset:
                                            #
                                            #     call ShowBossText
                                            #
      #.include "level_levelloop_flip.s"    # read "..\SrcALL\Akuyou_Multiplatform_Level_Levelloop_Flip.asm"
                                            #
        BR   LevelLoop                      #     jp LevelLoop
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;           Level specific code
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;Warp the bullet array (for boss battles)
# read "Core_StarArrayWarp.asm"

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
        MOV  $GradientTop,R3 # 48 lines
        MOV  $GradientTopStart,R1
        MOV  $0b11111100,R2  # Shift on Timer Ticks
        CALL @$Background_Gradient

        CLR  R0 # sprite number
        MOV  $LevelTiles,R4
        CALL GetSpriteMempos
      # we will need the position later for Tile bitshifts
        MOV  R4,-(SP)
        MOV  $16,R1
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $32,R1
        CALL @$Background_SolidFill

        MOV  $16,R1 # number of lines
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $40,R1
        CALL @$Background_SolidFill

        MOV  $8,R1 # number of lines
        CALL @$Background_FloodFillQuadSprite

        MOV  R4,-(SP) # Background_Gradient corrupts R4
        MOV  $GradientBottom,R3 # 32 lines
        MOV  $GradientBottomStart,R1
        MOV  $0b11111111,R2 # Shift on Timer Ticks
        CALL @$Background_Gradient

        MOV  $8,R1 # number of lines
        MOV  (SP)+,R4
        CALL @$Background_FloodFillQuadSprite

# Tile Bitshifts ---------------------------------------------------------------
      # pop de ;needed to keep this for the bitshifts
        MOV  (SP)+,R5 # ponter to the first tile

       .equiv TileWidthBytes, 8
      # we do MOV  -(R5),R0 to read words, to be able to use ASH for shifts
      # so R5 should point to next line
        ADD  $TileWidthBytes,R5

        MOV  $0b11111100,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $16,R2             # lines
        CALL @$BitShifter       #

        MOV  $0b11111110,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $16,R2             # lines
        CALL @$BitShifter       #

        MOV  $0b11111111,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $8,R2              # lines
        CALL @$BitShifter       #

        MOV  $0b11111111,R0     # shift on timer ticks
        MOV  $TileWidthBytes,R1 # bytes
        MOV  $8,R2              # lines
        CALL @$BitShifterDouble #

        RETURN
# Background Data ----------------------------------------------#
   .equiv GradientTopStart, 48 # lines count                    #
GradientTop:                                                    # GradientTop:
   .word 0x00FF, 0x00FF                # 1st line               # defb &F0,&F0                 ;1; first line
   .word GradientTopStart - 10, 0x00DD # 2nd line num, new word # defb GradientTopStart-10,&D0 ;2; line num, New byte
   .word GradientTopStart - 16, 0x0077                          # defb GradientTopStart-16,&70 ;3
   .word GradientTopStart - 20, 0x00AA                          # defb GradientTopStart-20,&A0 ;4
   .word GradientTopStart - 26, 0x0055                          # defb GradientTopStart-26,&50 ;5
   .word GradientTopStart - 30, 0x0088                          # defb GradientTopStart-30,&80 ;6
   .word GradientTopStart - 36, 0x0022                          # defb GradientTopStart-36,&20 ;7
   .word GradientTopStart - 40, 0x0000                          # defb GradientTopStart-40,&00 ;8
   .word GradientTopStart - 46, 0x0000                          # defb GradientTopStart-46,&00 ;9
   .word 0xFFFF                                                 # defb 255
                                                                #
   .equiv GradientBottomStart, 32 # lines count                 #
GradientBottom:                                                 # GradientBottom:
   .word 0x0000, 0x0000 # 1st line                              # defb &0,&0  ;1; first line
   .word 26, 0x0022     # 2nd line num, new word                # defb 30,&20 ;10
   .word 22, 0x0088                                             # defb 26,&80 ;11
   .word 18, 0x0055                                             # defb 20,&50 ;12
   .word 14, 0x00AA                                             # defb 18,&A0 ;13
   .word 10, 0x0077                                             # defb 14,&70 ;14
   .word  6, 0x00DD                                             # defb 10,&D0 ;15
   .word  4, 0x00FF                                             # defb 4,&F0  ;15
   .word  2, 0x00FF                                             # defb 2,&F0  ;15
   .word 0xFFFF                                                 # defb 255
#---------------------------------------------------------------#
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
    .byte   1, setColors, Black, brBlue,  Gray, White
    .byte  65, setColors, Black, Magenta, Gray, White
    .byte 160, setColors, Black, Red,     Gray, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
                                            # SmartBombColorMap:      ;Smartbomb colors (all white)
                                            #     defs 24,64+7
                                            #
                                            #     FadeDone:
                                            #         ld hl,null
                                            #         ld (FadeCommand_Plus2-2),hl
                                            #     ret

                                            #     FadeOut:    ;Need to protect everything - as this is called from the main Event loop
                                            #         push hl
                                            #             ld hl,PaletteInit
                                            #             call SetFader
                                            #         pop hl
                                            #     ret

                                            # BossText:
                                            # if BuildLang=''
                                            # ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
                                            # ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
                                            # db  11,"W A R N I N G ! ! ","!"+&80
                                            # db  06,"A Big Enemy is approaching","!"+&80
                                            # db  07,"Skull + Spider = Skullder","!"+&80
                                            # db  05,""," "+&80
                                            # db  05,""," "+&80
                                            # db  06,"(Or Spill, if you prefer!",")"+&80
                                            # ;b  "12345678901234567890123456789","0"+&80
                                            # db &0
                                            # endif

                                            # if BuildLang='r'
                                            #      ;      19      18      17      16      15      14      13      12      11      10       9       8       7       6       5       4       3       2       1   0
                                            # db  9,  111," ",112," ",97," ",114," ",110," ",111," ",114," ",115," ",125," ","!"," ","!"," ","!",255
                                            # db  6,  110,134,152,147,143," ",143,132,145,143,141,142,143,134," ",144,145,137,130,140,137,135,129,134,147,146,160,"!",255
                                            # db  11, 114," ",107," ",116," ",108," ",108," ",101," ",102," ",113," ","!",255
                                            # db  05,""," ",255
                                            # db  05,""," ",255
                                            # db  7,  "(",137,140,137," ",114,139,148,140,140,137,","," ",133,140,160," ",139,143,132,143," ",139,129,139,")",255
                                            # db &0
                                            # endif

BossLife:     .word 100                     # BossLife: defb 100
BossHurt:     .word 0                       # BossHurt: defb &0

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

        MOV  $(sprTwoFrame | SKULL_80_A),R0
        MOV  @$SkullObject1,R5
        MOVB R0,3(R5)

        CALL TRandW                         # ld a,r
        BIC  $0xFF00,R0
        ASR  R0                             # srl a
        ASR  R0                             # srl a
        ADD  $120,R0                        # add 120
        MOV  @$FireTarget1,R5               # ld hl,(FireTarget1)
        MOVB R0,(R5)                        # call SetObjectY

        CALL TRandW                         # ld a,r
        BIC  $0xFF00,R0
        ASR  R0                             # srl a
        ASR  R0                             # srl a
        ADD  $120,R0                        # add 120
        MOV  @$FireTarget2,R5               # ld hl,(FireTarget2)
        MOVB R0,(R5)                        # call SetObjectY

        CALL TRandW                         # ld a,r
        BIC  $0xFF00,R0
        ASR  R0                             # srl a
        ASR  R0                             # srl a
        ADD  $120,R0                        # add 120
        MOV  @$FireTarget3,R5               # ld hl,(FireTarget3)
        MOVB R0,(R5)                        # call SetObjectY

        MOV  $2,@$BossHurt

        MOV  @$BossLife,R0
        DEC  R0
        CMP  R0,$80
        BEQ  BossLife80
        CMP  R0,$60
        BEQ  BossLife60
        CMP  R0,$40
        BEQ  BossLife40
        CMP  R0,$20
        BEQ  BossLife20
        CMP  R0,$1
        BEQ  BossLife1
        BR   UpdateBossLife

BossLife80:
        MOV  @$SkullObject2,R5
        MOVB $(sprTwoFrame | SKULL_80_B),3(R5)
        MOV  @$SkullObject3,R5
        MOVB $(sprSingleFrame | SKULL_80_C),3(R5)
        BR   UpdateBossLife

BossLife60:
        MOV  @$SkullObject2,R5
        MOVB $(sprTwoFrame | SKULL_60_B),3(R5)
        MOV  @$SkullObject3,R5
        MOVB $(sprSingleFrame | SKULL_60_C),3(R5)
        BR   UpdateBossLife

BossLife40:
        MOV  @$SkullObject2,R5
        MOVB $(sprTwoFrame | SKULL_40_B),3(R5)
        MOV  @$SkullObject3,R5
        MOVB $(sprSingleFrame | SKULL_40_C),3(R5)
        BR   UpdateBossLife

BossLife20:
        MOV  @$SkullObject2,R5
        MOVB $(sprTwoFrame | SKULL_20_B),3(R5)
        MOV  @$SkullObject3,R5
        MOVB $(sprSingleFrame | SKULL_20_C),3(R5)
        BR   UpdateBossLife

BossLife1:
        CLRB R3 # Make object immortal
        CLR  @$BossHurt

        MOV  @$FireTarget1,R5
        CLRB 5(R5) # object program
        MOV  @$FireTarget2,R5
        CLRB 5(R5)
        MOV  @$FireTarget3,R5
        CLRB 5(R5)

        MOV  @$SkullObject1,R5
        MOVB $(sprSingleFrame | SKULL_0_A),3(R5)
        MOV  @$SkullObject2,R5
        MOVB $(sprSingleFrame | SKULL_0_B),3(R5)
        MOV  @$SkullObject3,R5
        MOVB $(sprSingleFrame | SKULL_0_C),3(R5)

        PUSH R0
        MOV  $249,R0
        MOV  $LevelEndAnim,R5
        CALL SetLevelTime
        POP  R0

UpdateBossLife:
        MOV  R0,@$BossLife
        POP  R5
        RETURN

StopBossMovement:
        MOV  $044,R0
       .equiv BossNumberOfMovingObjects, (BossMovingObjectsEnd - BossMovingObjectsStart) >> 1
        MOV  $BossNumberOfMovingObjects,R1
        MOV  $BossMovingObjectsStart,R2
        100$:
            MOV  (R2),R3  # object attributes pointer
            BZE  2$       # zero, no pointer saved, skip
            MOVB R0,2(R3) # set object move
        2$:
            INC  R2
            INC  R2
        SOB  R1,100$

        RETURN

        BossMovingObjectsStart:

        SkullObject1: .word 0x0000
        SkullObject2: .word 0x0000
        SkullObject3: .word 0x0000
        HandObject1:  .word 0x0000
        HandObject2:  .word 0x0000
        HandObject3:  .word 0x0000
        HandObject4:  .word 0x0000
        HandObject5:  .word 0x0000
        HandObject6:  .word 0x0000
        SkullTarget:  .word 0x0000
        FireTarget1:  .word 0x0000
        FireTarget2:  .word 0x0000
        FireTarget3:  .word 0x0000

        BossMovingObjectsEnd:

   .even
end:
