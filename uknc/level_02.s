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

LevelSprites2:
       .incbin "build/level_02.0.spr"
ChibiSprites:
       .incbin "build/chibi_lr.spr"
LevelTiles:
       .incbin "build/level_02_tiles.spr"

EventStreamArray:
.word 0, evtReprogram_PowerupSprites
.byte      128+DummySprite, 128+DummySprite, 128+DummySprite, 128+31 # Define powerup sprites


# ;We will use 4 Paralax layers
# ; ---------()- (sky)        %11001000
# ; ------------ (Far)        %11000100
# ; -----X---X-- (mid)        %11000010   Bank 1
# ; []=====[]=== (foreground)     %11000001   Bank 0
#
# defb 0,%11110010                ;Install a custom hit handler
# defw CustomObjectHitHandler

# Background L

# defb 0,evtMultipleCommands+5
# defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000001,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
# defb evtSetObjectSize,0
# defb evtSetAnimator,0
# defb evtAddToBackground
# defb evtSettingsBank_Save,0
.word 0, evtMultipleCommands | 5
.word    evtSetProgMoveLife, prgBitShift, mveBackground | 0b0001, lifeImmortal
.word    evtSetObjectSize | 0
.word    evtSetAnimator | anmNone
.word    evtAddToBackground
.word    evtSaveObjSettings | 0

# defb 0,evtMultipleCommands+5
# defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000009,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
# defb evtSetObjectSize,0
# defb evtSetAnimator,0
# defb evtAddToBackground
# defb evtSettingsBank_Save,1 ; Save Object settings to Bank 1
.word 0, evtMultipleCommands | 5
.word    evtSetProgMoveLife, prgBitShift, mveBackground | 0b0010, lifeImmortal
.word    evtSetObjectSize | 0
.word    evtSetAnimator | anmNone
.word    evtAddToBackground
.word    evtSaveObjSettings | 1

# ; Hand Up
# defb 0,%01110000+3              ; 3 commands at the same timepoint
# defb    128+4,0,&4C,%11000000+6 ; Program -None... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb evtSetObjectSize,24
# defb    %10010000+15,3
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 014, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 3

# ; Hand Down
# defb 0,%01110000+3              ; 3 commands at the same timepoint
# defb    128+4,0,&7C,%11000000+6 ; Program -None... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb evtSetObjectSize,24
# defb    %10010000+15,4
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 074, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 4

# ; Hand left
# defb 0,%01110000+3              ; 3 commands at the same timepoint
# defb    128+4,0,&61,%11000000+6 ; Program -None... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb evtSetObjectSize,24
# defb    %10010000+15,5
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 041, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 5

# ; Hand right
# defb 0,%01110000+3              ; 3 commands at the same timepoint
# defb    128+4,0,&67,%11000000+6 ; Program -None... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb evtSetObjectSize,24
# defb    %10010000+15,6
.word 0, evtMultipleCommands | 3
.word    evtSetProgMoveLife, prgNone, mvRegular | spdFast | 047, lifeEnemy | 6
.word    evtSetObjectSize | 24
.word    evtSaveObjSettings | 6

# ;HandLeft1
# defb 0,evtMultipleCommands+6     ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1   ; Load Settings from bank 1
# defb    129,%11110101            ; Program
# defb    evtSetLife,0
# defb evtAddToBackground          ; Add To Background
# defb    0,  18,160+24,90+24+48+8 ; Single Object sprite 11 (animated)
# defb    138                      ; save Object pointer
# defw        HandObject1          ; save Object pointer
.word 0, evtMultipleCommands | 6
.word    evtLoadObjSettings | 1
.word    evtSetProg, prgFrameAnimate | 0b101
.word    evtSetLife, lifeImmortal
.word    evtAddToBackground
.word    evtSingleSprite, sprSingleFrame | 18, (24+160)<<X | (24+90+48+8)<<Y
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

.equiv DummySprite, 31

# ;HandLeft2
# defb 1+12,%01110000+5            ; 3 commands at the same timepoint
# defb    %10010000+0+1            ; Load Settings from bank 1
# defb evtAddToBackground          ; Add To Background
# defb    129,%11110011            ; Program
# defb    0,  19,160+24,90+24+48+8 ; Single Object sprite 11 (animated)
# defb    138                      ; save Object pointer
# defw        HandObject2          ; save Object pointer
.word 13, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b011
.word     evtSingleSprite, sprSingleFrame | 19, (24+160)<<X | (24+90+48+8)<<Y
.word     evtSaveObjPointer, HandObject2

# ; hit target
# defb 20,%01110000+3                    ; 2 commands at the same timepoint;
# defb    128+4,2,%11000010,%11000000+40 ; Program - Starburst ... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4;
# defb    0,DummySprite,160+27,90+24+24  ; Single Object sprite 11 (animated)
# defb    138                            ; save Object pointer
# defw        SkullTarget                ; save Object pointer
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgSpecial, mvSpecial | spdFast | 002, lifeEnemy | 40
.word     evtSingleSprite, DummySprite, (24+160+3)<<X | (24+90+24)<<Y
.word     evtSaveObjPointer, SkullTarget

DebugStartPoint:
# ; Fire target 1
# defb 20,%01110000+3                   ; 2 commands at the same timepoint;
# defb    128+4,%01100000+7,%11000010,0 ; Program - Starburst ... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4;
# defb    0,DummySprite,160+27,90+24+48 ; Single Object sprite 11 (animated)
# defb    138                           ; save Object pointer
# defw        FireTarget1               ; save Object pointer
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgFireSlow | fireLeft, mvSpecial | spdFast | 002, lifeImmortal
.word     evtSingleSprite, DummySprite, (24+160+3)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, FireTarget1

# ; Fire target 2
# defb 20,%01110000+3                    ; 2 commands at the same timepoint;
# defb    128+4,%10000000+13,%11000010,0 ; Program - Starburst ... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4;
# defb    0,DummySprite,160+27,90+24+48  ; Single Object sprite 11 (animated)
# defb    138                            ; save Object pointer
# defw        FireTarget2                ; save Object pointer
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgFireSnail | fireBurst, mvSpecial | spdFast | 002, lifeImmortal
.word     evtSingleSprite, DummySprite, (24+160+3)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, FireTarget2

# ; Fire target 3
# defb 20,%01110000+3                   ; 2 commands at the same timepoint;
# defb    128+4,%01100000+7,%11000010,0 ; Program - Starburst ... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4;
# defb    0,DummySprite,160+27,90+24    ; Single Object sprite 11 (animated)
# defb    138                           ; save Object pointer
# defw        FireTarget3               ; save Object pointer
.word 20, evtMultipleCommands | 3
.word     evtSetProgMoveLife, prgFireSnail | fireBurst, mvSpecial | spdFast | 002, lifeImmortal
.word     evtSingleSprite, DummySprite, (24+160+3)<<X | (24+90)<<Y
.word     evtSaveObjPointer, FireTarget3

# ;Skull1
# defb 20,%01110000+5                 ; 3 commands at the same timepoint
# defb    %10010000+0+1               ; Load Settings from bank 1
# defb evtAddToForeground             ; Add To Foreground
# defb    129,0                       ; Change to program 0 (normal)
# defb    0,128+  0,160+24,90+24      ; Single Object sprite 11 (animated)
# defb    138                         ; save Object pointer
# defw        SkullObject1            ; save Object pointer
.word 20, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToForeground
.word     evtSetProg, prgNone
.word     evtSingleSprite, sprTwoFrame | 0, (24+160)<<X | (24+90)<<Y
.word     evtSaveObjPointer, SkullObject1

# ;HandLeft3
# defb 1+24,%01110000+5            ; 3 commands at the same timepoint
# defb    %10010000+0+1            ; Load Settings from bank 1
# defb evtAddToBackground          ; Add To Background
# defb    129,%11110100            ; Program
# defb    0,  20,160+24,90+24+48+8 ; Single Object sprite 11 (animated)
# defb    138                      ; save Object pointer
# defw        HandObject3          ; save Object pointer
.word 25, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b100
.word     evtSingleSprite, sprSingleFrame | 20, (24+160)<<X | (24+90+48+8)<<Y
.word     evtSaveObjPointer, HandObject3

# ;Skull2
# defb 20+12,%01110000+5         ; 3 commands at the same timepoint
# defb    %10010000+0+1          ; Load Settings from bank 1
# defb evtAddToForeground        ; Add To Foreground
# defb    129,0                  ; Change to program 0 (normal)
# defb    0,128+  1,160+24,90+24 ; Single Object sprite 11 (animated)
# defb    138                    ; save Object pointer
# defw        SkullObject2       ; save Object pointer
.word 32, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToForeground
.word     evtSetProg, prgNone
.word     evtSingleSprite, sprTwoFrame | 1, (24+160)<<X | (24+90)<<Y
.word     evtSaveObjPointer, SkullObject2
# ;HandRight1
# defb 20+18,%01110000+5         ; 3 commands at the same timepoint
# defb    %10010000+0+1          ; Load Settings from bank 1
# defb evtAddToBackground        ; Add To Background
# defb    129,%11110011          ; Program
# defb    0,  15,160+24,90+24+48 ; Single Object sprite 11 (animated)
# defb    138                    ; save Object pointer
# defw        HandObject4        ; save Object pointer
.word 38, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b011
.word     evtSingleSprite, sprSingleFrame | 15, (24+160)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, HandObject4
# ;Skull3
# defb 20+24,%01110000+5         ; 3 commands at the same timepoint
# defb    %10010000+0+1          ; Load Settings from bank 1
# defb evtAddToForeground        ; Add To Foreground
# defb    129,0                  ; Change to program 0 (normal)
# defb    0,  2,160+24,90+24     ; Single Object sprite 11 (animated)
# defb    138                    ; save Object pointer
# defw        SkullObject3       ; save Object pointer
.word 44, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToForeground
.word     evtSetProg, prgNone
.word     evtSingleSprite, sprSingleFrame | 2, (24+160)<<X | (24+90)<<Y
.word     evtSaveObjPointer, SkullObject3
# ;HandRight2
# defb 20+18+12,%01110000+5      ; 3 commands at the same timepoint
# defb    %10010000+0+1          ; Load Settings from bank 1
# defb evtAddToBackground        ; Add To Background
# defb    129,%11110100          ; Program
# defb    0,  16,160+24,90+24+48 ; Single Object sprite 11 (animated)
# defb    138                    ; save Object pointer
# defw        HandObject5        ; save Object pointer
.word 50, evtMultipleCommands | 5
.word     evtLoadObjSettings | 1
.word     evtAddToBackground
.word     evtSetProg, prgFrameAnimate | 0b100
.word     evtSingleSprite, sprSingleFrame | 16, (24+160)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, HandObject5
# ;HandRight3
# defb 20+18+24,%01110000+4      ; 3 commands at the same timepoint
# defb    %10010000+0+1          ; Load Settings from bank 1
# defb    129,%11110101          ; Program
# defb    0,  17,160+24,90+24+48 ; Single Object sprite 11 (animated)
# defb    138                    ; save Object pointer
# defw        HandObject6        ; save Object pointer
.word 62, evtMultipleCommands | 4
.word     evtLoadObjSettings | 1
.word     evtSetProg, prgFrameAnimate | 0b101
.word     evtSingleSprite, sprSingleFrame | 17, (24+160)<<X | (24+90+48)<<Y
.word     evtSaveObjPointer, HandObject6

.word 70, evtCallAddress, StopBossMovement

HandAttack1:
   .word 75, evtMultipleCommands | 7
   .word     evtLoadObjSettings | 3
   .word     evtSingleSprite, sprTwoFrame | 22, (24+ 12* 1)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22, (24+ 12* 3)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22, (24+ 12* 5)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22, (24+ 12* 7)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22, (24+ 12* 9)<<X | (160)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22, (24+ 12*11)<<X | (160)<<Y

   .word 77, evtMultipleCommands | 8
   .word     evtLoadObjSettings | 4
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12* 0)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12* 2)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12* 4)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12* 6)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12* 8)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12*10)<<X | (24)<<Y
   .word     evtSingleSprite, sprTwoFrame | 22+7, (24+ 12*12)<<X | (24)<<Y

   .word 79, evtMultipleCommands | 6
   .word     evtLoadObjSettings | 6
   .word     evtSingleSprite, sprTwoFrame | 21+9, (24)<<X | (24+ 24*0)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21+9, (24)<<X | (24+ 24*2)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21+9, (24)<<X | (24+ 24*4)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21+9, (24)<<X | (24+ 24*6)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21+9, (24)<<X | (24+ 24*8)<<Y

   .word 81, evtMultipleCommands | 6
   .word     evtLoadObjSettings | 5
   .word     evtSingleSprite, sprTwoFrame | 21, (160)<<X | (24+ 24*1)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21, (160)<<X | (24+ 24*3)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21, (160)<<X | (24+ 24*5)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21, (160)<<X | (24+ 24*7)<<Y
   .word     evtSingleSprite, sprTwoFrame | 21, (160)<<X | (24+ 24*9)<<Y

   .word 82, evtChangeStreamTime, 60, HandAttack1

LevelEndAnim:
# defb 253,%01110000+2              ; 3 commands at the same timepoint
# defb evtSetProgMoveLife,prgMovePlayer,&24,10
# defb    0,21+128+11,140+24,100+24 ; Single Object sprite 11 (animated)
    .word 253, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word      evtSingleSprite, sprTwoFrame | DummySprite, (24+140)<<X | (24+100)<<Y
#
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# FadeOutStartPoint equ 254
# ;               Start of fade out block
# ;               Fade out ends at FadeutStart+2, eg if FadeOut=5 then ends at 7
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#     defb FadeOutStartPoint+1,evtMultipleCommands+4          ; 4 Commands
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;               End of fade out block
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# defb 2,evtCallAddress           ;Call a memory location
# defw    EndLevel

EndLevel:
        MOV  $3,R5
        JMP  ExecuteBootstrap # Start the game, no return

LevelInit:                                  # read "..\SrcALL\Akuyou_Multiplatform_Level_GenericInit.asm"
       .ppudo_ensure $PPU_BossMusicRestart

        MOV  $LevelSprites,R0
        MOV  $SpriteBanksVectors,R1
        MOV  R0,(R1)+
        MOV  R0,(R1)+
   .ifdef ExtMemCore
        MOV  $LevelSprites2,(R1)+
   .else
        MOV  R0,(R1)+
   .endif
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

                                            #     ld a,r
                                            #     xor 0 :Randomizer_Plus1
                                            #     ld (Randomizer_Plus1-1),a
                                            #     and %00001100;%00001110
                                            #     call z,StarArrayWarp ; welcome to hell!
                                            #
                                            #     ld a,(BossHurt)
                                            #     cp 0
                                            #     jp z,DontReset
                                            #     dec a
                                            #     ld (BossHurt),a
                                            #
                                            #     jp nz,DontReset
                                            #     ld a,128+0
                                            #     ld hl,(SkullObject1)
                                            #     call SetObjectSprite
                                            # DontReset:
                                            #
                                            #     call ShowBossText
                                            #
      #.include "level_levelloop_flip.s"    # read "..\SrcALL\Akuyou_Multiplatform_Level_Levelloop_Flip.asm"
                                            #
        BR   LevelLoop                      #     jp LevelLoop
#
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;           Level specific code
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;Allow objects to be reprogrammed
# read "Core_ObjectReprogrammers.asm"
#
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
    .word 0, cursorGraphic, scale320 | 0b000
    .byte 1, setColors, Black, Blue, Blue, Magenta
    .word endOfScreen
#----------------------------------------------------------------------------}}}
DarkRealPalette: #---- ------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | 0b000
    .byte   1, setColors, Black, brBlue, brYellow, White
    .byte  49, setColors, Black, Magenta, Blue, White
    .byte 129, setColors, Black, brRed, brCyan, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
RealPalette: #---------------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | 0b111
    .byte   1, setColors, Black, brBlue, brYellow, White
    .word  32, cursorGraphic, scale320 | 0b110
    .byte  40, setColors, Black, brBlue, Magenta, White
    .word  64, cursorGraphic, scale320 | 0b111
    .byte  65, setColors, Black, Magenta, Blue, White
    .word 142, cursorGraphic, scale320 | 0b011
    .byte 143, setColors, Black, brRed, brCyan, White
    .word 178, cursorGraphic, scale320 | 0b111
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

#BossLife:     .word 0x0000                  # BossLife: defb 100
#BossHurt:     .word 0x0000                  # BossHurt: defb &0

CustomObjectHitHandler:
                                            # ld a,iyl
                                            # cp 2
                                            # jp nz,Akuyou_Object_DecreaseLifeShot    ; if this object isn't the boss target, just run the normal routine
                                            #
                                            # ld ixl,%11000000+40 ; Make object immortal
                                            # push de
                                            # push hl
                                            #     ld a,128+3
                                            #     ld hl,(SkullObject1)
                                            #     call SetObjectSprite
                                            #
                                            #
                                            #     ld a,r
                                            #     srl a
                                            #     srl a
                                            #     add 120
                                            #     ld hl,(FireTarget1)
                                            #     call SetObjectY
                                            #
                                            #     ld a,r
                                            #     srl a
                                            #     srl a
                                            #     add 120
                                            #     ld hl,(FireTarget2)
                                            #     call SetObjectY
                                            #
                                            #     ld a,r
                                            #     srl a
                                            #     srl a
                                            #     add 120
                                            #     ld hl,(FireTarget3)
                                            #     call SetObjectY
                                            #
                                            #     ld a,2
                                            #     ld (BossHurt),a
                                            #
                                            #     ld a,(BossLife)
                                            #     dec a
                                            #     cp 80
                                            #     jp z,BossLife1
                                            #     cp 60
                                            #     jp z,BossLife2
                                            #     cp 40
                                            #     jp z,BossLife3
                                            #     cp 20
                                            #     jp z,BossLife4
                                            #     cp 1
                                            #     jp z,BossLife5
                                            #     jp UpdateBossLife
                                            # BossLife5:
                                            #     push af
                                            #         ld ixl,0    ; Make object immortal
                                            #
                                            #         ld a,0
                                            #         ld (BossHurt),a
                                            #
                                            #         ld a,0
                                            #         ld hl,(FireTarget1)
                                            #         call SetObjectProgram
                                            #         ld a,0
                                            #         ld hl,(FireTarget2)
                                            #         call SetObjectProgram
                                            #         ld a,0
                                            #         ld hl,(FireTarget3)
                                            #         call SetObjectProgram
                                            #
                                            #         ld a,12
                                            #         ld hl,(SkullObject1)
                                            #         call SetObjectSprite
                                            #         ld a,128+13
                                            #         ld hl,(SkullObject2)
                                            #         call SetObjectSprite
                                            #         ld a,128+14
                                            #         ld hl,(SkullObject3)
                                            #         call SetObjectSprite
                                            #         ld a,2
                                            #         call Akuyou_DoSmartBombCall
                                            #
                                            #         ld hl,LevelEndAnim
                                            #         ld a,249
                                            #         call Akuyou_SetLevelTime
                                            #     pop af
                                            #     jp UpdateBossLife
                                            # BossLife4:
                                            # push af
                                            #         ld a,128+10
                                            #         ld hl,(SkullObject2)
                                            #         call SetObjectSprite
                                            #         ld a,128+11
                                            #         ld hl,(SkullObject3)
                                            #         call SetObjectSprite
                                            #     pop af
                                            #     jp UpdateBossLife
                                            # BossLife3:
                                            # push af
                                            #         ld a,128+8
                                            #         ld hl,(SkullObject2)
                                            #         call SetObjectSprite
                                            #         ld a,128+9
                                            #         ld hl,(SkullObject3)
                                            #         call SetObjectSprite
                                            #     pop af
                                            #     jp UpdateBossLife
                                            # BossLife2:
                                            #     push af
                                            #         ld a,128+6
                                            #         ld hl,(SkullObject2)
                                            #         call SetObjectSprite
                                            #         ld a,128+7
                                            #         ld hl,(SkullObject3)
                                            #         call SetObjectSprite
                                            #     pop af
                                            #     jp UpdateBossLife
                                            # BossLife1:
                                            #     push af
                                            #         ld a,128+4
                                            #         ld hl,(SkullObject2)
                                            #         call SetObjectSprite
                                            #         ld a,128+5
                                            #         ld hl,(SkullObject3)
                                            #         call SetObjectSprite
                                            #     pop af
                                            #     jp UpdateBossLife
                                            # UpdateBossLife:
                                            #     ld (BossLife),a
                                            #
                                            #     pop hl
                                            #     pop de
                                            # ret

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
