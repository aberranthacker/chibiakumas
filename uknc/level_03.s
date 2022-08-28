               .list

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level03SizeWords, (end - start) >> 1
               .global Level03SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

       .incbin "build/level_03.0.spr"
LevelSprites2:
       .incbin "build/level_03.1.spr"
ChibiSprites:
       .incbin "build/chibi_lr.spr"
LevelTiles:
       .incbin "build/level_03_tiles.spr"

EventStreamArray:
# UseBackgroundFloodFillQuadSpriteColumn equ 1

# .equiv BITERFLY, 5
# .equiv COIN, 24
# .equiv GNAT_PACK, 11
# .equiv GRASS_TUFT_A, 16
# .equiv GRASS_TUFT_B, 17
# .equiv GRASS_TUFT_BIG, 20
# .equiv GRASS_TUFT_C, 18
# .equiv GRASS_TUFT_D, 19
# .equiv KAMISAGI, 0
# .equiv MUKADE_BACHI_1, 1
# .equiv MUKADE_BACHI_2, 2
# .equiv MUKADE_BACHI_3, 29
# .equiv MUKADE_BACHI_4, 2
# .equiv MUKADE_BACHI_5, 3
# .equiv POWERUP_DRONE, 27
# .equiv POWERUP_POWER, 25
# .equiv POWERUP_RATE, 26
# .equiv SHROOM_BOMBER, 21
# .equiv ZOMBIE_CAPYBARA, 6
# .equiv ZOMBIE_SALARYMAN, 4

.equiv DUMMY_SPRITE, 0

.equiv BITERFLY,          1
.equiv COIN,              2
.equiv GNAT_PACK,         3
.equiv GRASS_TUFT_A,      4
.equiv GRASS_TUFT_B,      5
.equiv GRASS_TUFT_BIG,    6
.equiv GRASS_TUFT_C,      7
.equiv GRASS_TUFT_D,      8
.equiv KAMISAGI,          9
.equiv MUKADE_BACHI_1,   10
.equiv MUKADE_BACHI_2,   11 # and MUKADE_BACHI_4
.equiv MUKADE_BACHI_3,   12
.equiv MUKADE_BACHI_5,   13
.equiv POWERUP_DRONE,    14
.equiv POWERUP_POWER,    15
.equiv POWERUP_RATE,     16
.equiv SHROOM_BOMBER,    17
.equiv ZOMBIE_CAPYBARA,  18
.equiv ZOMBIE_SALARYMAN, 19

# defb 0,evtResetPowerup

# We will use 4 Paralax layers
#  ---------()- (sky)           %11001000
#  ------------ (Far)           %11000100
#  -----X---X-- (mid)           %11000010       Bank 1
#  []=====[]=== (foreground)    %11000001       Bank 0

# defb 0,evtReprogram_PowerupSprites,128+27,128+26,128+25,128+24 ; Define powerup sprites
    .word 0, evtReprogram_PowerupSprites  # Define powerup sprites
    .byte    sprTwoFrame | POWERUP_DRONE
    .byte    sprTwoFrame | POWERUP_RATE
    .byte    sprTwoFrame | POWERUP_POWER
    .byte    sprTwoFrame | COIN

# defb 0,evtMultipleCommands+5
# defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000001,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
# defb evtSetObjectSize,0
# defb evtSetAnimator,0
# defb evtAddToBackground
# defb evtSettingsBank_Save,0 ; Save Object settings to Bank 0
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife               # 1
    .word        prgBitShift
    .word        mveBackground | 0b0001
    .word        lifeImmortal
    .word    evtSetObjectSize | 0             # 2
    .word    evtSetAnimator | anmNone         # 3
    .word    evtAddToBackground               # 4
    .word    evtSaveObjSettings | 0           # 5

# defb 0,evtMultipleCommands+5
# defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000010,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
# defb evtSetObjectSize,0
# defb evtSetAnimator,0
# defb evtAddToBackground
# defb evtSettingsBank_Save,1 ; Save Object settings to Bank 1
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife               # 1
    .word        prgBitShift
    .word        mveBackground | 0b0010
    .word        lifeImmortal
    .word    evtSetObjectSize | 0             # 2
    .word    evtSetAnimator | anmNone         # 3
    .word    evtAddToBackground               # 4
    .word    evtSaveObjSettings | 1           # 5

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,0,mveCustom3+4,lifEnemy+9 ; Program - Fire Left... Move - wave... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,TwoFrameSprite+2 ; Sprite 1 Frame animater
# defb evtAddToForeground
# defb evtSetObjectSize,24
# defb   evtSettingsBank_Save,2
   # Mukadebachi
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgNone, mveCustom3 | 0b0100, lifeEnemy | 9
    .word    evtSetSprite | sprTwoFrame | MUKADE_BACHI_2
    .word    evtAddToForeground
    .word    evtSetObjectSize | 24
    .word    evtSaveObjSettings | 2

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,0,mveCustom1,lifEnemy+5 ; Program - Fire Left... Move - wave... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,0 ; Sprite 1 Frame animater
# defb   evtSetObjectSize,24
# defb   evtAddToForeground
# defb   evtSettingsBank_Save,3
   # Kamisagi
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgNone, mveCustom1 | 0b0000, lifeEnemy | 5
    .word    evtSetSprite | sprTwoFrame | KAMISAGI
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 3

# defb 0,evtReprogramCustomMove1
# defw CustomMoveBouncer
   # Kamisagi program code
    .word 0, evtReprogramCustomMove1, CustomMoveBouncer

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,prgFireFast+16,mveWave+%00000001,lifEnemy+3 ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,TwoFrameSprite+11
# defb   evtSetObjectSize,24
# defb   evtAddToForeground
# defb   evtSettingsBank_Save,4
   # GnatPack
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireFast | 16, mveWave | 0b0001, lifeEnemy | 3
    .word    evtSetSprite | sprTwoFrame | GNAT_PACK
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 4

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,prgFireSlow+13,mveWave+%00000000,lifEnemy+6 ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,TwoFrameSprite+5
# defb evtSetObjectSize,24
# defb evtAddToForeground
# defb   evtSettingsBank_Save,5
   # Biterfly
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireSlow | 13, mveWave | 0b0000, lifeEnemy | 6
    .word    evtSetSprite | sprTwoFrame | BITERFLY
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 5

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,prgFireSlow+1,&23,lifEnemy+3 ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,TwoFrameSprite+4
# defb evtSetObjectSize,24
# defb evtAddToForeground
# defb   evtSettingsBank_Save,6
   # Zombie Salaryman
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireSlow | 1, mvRegular | spdNormal | 043, lifeEnemy | 6
    .word    evtSetSprite | sprTwoFrame | ZOMBIE_SALARYMAN
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 6

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,prgFireSnail+5,&23,lifEnemy+9 ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,TwoFrameSprite+6
# defb evtSetObjectSize,24
# defb evtAddToForeground
# defb   evtSettingsBank_Save,7
   # Zombie Capybara
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireSnail | 5, mvRegular | spdNormal | 043, lifeEnemy | 9
    .word    evtSetSprite | sprTwoFrame | ZOMBIE_CAPYBARA
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 7

# defb 0,evtMultipleCommands+5 ; 3 commands at the same timepoint
# defb   evtSetProgMoveLife,prgFireMid+6,&23,lifEnemy+2 ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
# defb   evtSetSprite,TwoFrameSprite+21
# defb evtSetObjectSize,24
# defb evtAddToForeground
# defb   evtSettingsBank_Save,8
   # Shroom Bomber
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireMid | 6, mvRegular | spdNormal | 043, lifeEnemy | 2
    .word    evtSetSprite | sprTwoFrame | SHROOM_BOMBER
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 8
#-------------------------------------------------------------------------------

# defb 0,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +1 ; Load Settings from bank 2
# defb   evtSingleSprite,20,70+24,12*16
   # Grass Tuft
    .word 0, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 1
    .word    evtSingleSprite, GRASS_TUFT_BIG, (24+70)<<X | (12*16)<<Y

# defb 0,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +1 ; Load Settings from bank 2
# defb   evtSingleSprite,17,30+24,11*16
   # Grass Tuft
    .word 0, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 1
    .word    evtSingleSprite, GRASS_TUFT_B, (24+30)<<X | (11*16)<<Y

# defb 0,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +1 ; Load Settings from bank 2
# defb   evtSingleSprite,18,110+24,11*16
   # Grass Tuft
    .word 0, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 1
    .word    evtSingleSprite, GRASS_TUFT_C, (24+110)<<X | (11*16)<<Y

# defb 0,evtReprogramCustomMove3
# defw CustomMove3
   # mukadebachi
    .word 0, evtReprogramCustomMove3, CustomMove3

# Start of fade in block -------------------------------------------------------
    .equiv FadeStartPoint, 0
    .word FadeStartPoint + 1, evtSetPalette, BluePalette
    .word FadeStartPoint + 2, evtSetPalette, DarkRealPalette
    .word FadeStartPoint + 3, evtSetPalette, RealPalette
# End of fade in block ---------------------------------------------------------

# defb 3,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4 ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 5, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 4
    .word    evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 9,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12     ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 9, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 6
    .word    evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 24,evtMultipleCommands +2
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12
   # Zombie Salaryman
    .word 24, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 25,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb   evtSetProgMoveLife,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb   evtSingleSprite,128+ 27,160+24,50+24 ; Single Object sprite 11 (animated)
   # drone
    .word 25, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+160)<<X | (24+50)<<Y

# defb 28,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4 ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 28, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 30,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0 ; Load Settings from bank 2
# defb   evtSetSprite,20
# defb   evtSingleSprite+13
   # Grass
    .word 30, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_BIG
    .word     evtSingleSprite | 13 # Row 25, last Column, Last Sprite

# defb 38,evtMultipleCommands +2
# defb   evtSettingsBank_Load +8
# defb   evtSingleSprite+3
   # Shroom Bomber
    .word 38, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 8
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite

# defb 40,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0 ; Load Settings from bank 2
# defb   evtSetSprite,16
# defb   evtSingleSprite+12
   # Grass
    .word 40, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_A
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 45,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12      ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 45, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 50,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4 ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 50, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 60,evtMultipleCommands +2
# defb   evtSettingsBank_Load +8
# defb   evtSingleSprite+3
   # Shroom Bomber
    .word 60, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 8
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite

# defb 65,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb   evtSetProgMoveLife,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb   evtSingleSprite,128+ 27,160+24,50+24 ; Single Object sprite 11 (animated)
   # drone
    .word 65, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+160)<<X | (24+50)<<Y

# defb 70,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0 ; Load Settings from bank 2
# defb   evtSetSprite,20
# defb   evtSingleSprite+13
   # Grass
    .word 70, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_BIG
    .word     evtSingleSprite | 13 # Row 25, last Column, Last Sprite

# defb 70,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +7
# defb   evtSingleSprite+12      ; Row 16, last Column, Last Sprite
   # Zombie Capybara
    .word 70, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 7
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 80,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0 ; Load Settings from bank 2
# defb   evtSetSprite,17
# defb   evtSingleSprite+12
   # Grass
    .word 80, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_B
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 90,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0 ; Load Settings from bank 2
# defb   evtSetSprite,18
# defb   evtSingleSprite+11
   # Grass
    .word 90, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_C
    .word     evtSingleSprite | 11 # Row 21, last Column, Last Sprite

# defb 95,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12      ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 95, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 100,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,16
# defb   evtSingleSprite+13
   # Grass
    .word 100, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_A
    .word      evtSingleSprite | 13 # Row 25, last Column, Last Sprite

# defb 100,evtMultipleCommands + 5 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +2   ; Load Settings from bank 2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+1
# defb   evtSetProg,prgFireSlow+11
# defb   evtSingleSprite+7
   # MukadeBachi1
    .word 100, evtMultipleCommands | 5
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_1
    .word      evtSetProg, prgFireSlow | 11
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 103,evtMultipleCommands+4 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +2 ; Load Settings from bank 2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+2
# defb   evtSingleSprite+7
   # MukadeBachi2
    .word 103, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_2
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 105,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb   evtSetProgMoveLife,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb   evtSingleSprite,128+ 26,160+24,50+24 ; Single Object sprite 11 (animated)
   # Powerup Rate
    .word 105, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+50)<<Y

# defb 106,evtMultipleCommands+5
# defb   evtSettingsBank_Load +2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+29
# defb   evtSetProg,prgFireSnail+13
# defb   evtSingleSprite+7
   # MukadeBachi3
    .word 106, evtMultipleCommands | 5
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_3
    .word      evtSetProg, prgFireSnail | 13
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 109,evtMultipleCommands+4 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +2 ; Load Settings from bank 2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+2
# defb   evtSingleSprite+7
   # MukadeBachi4
    .word 109, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_3
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 112,evtMultipleCommands+5
# defb   evtSettingsBank_Load +2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+3
# defb   evtSetProg,prgFireSlow+12
# defb   evtSingleSprite+7
   # MukadeBachi5
    .word 112, evtMultipleCommands | 5
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_5
    .word      evtSetProg, prgFireSlow | 12
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 118,evtMultipleCommands +2
# defb   evtSettingsBank_Load +8
# defb   evtSingleSprite+3
   # Shroom Bomber
    .word 118, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 8
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite

# defb 120,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,17
# defb   evtSingleSprite+12
   # Grass
    .word 120, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_B
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 130,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 130, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 140,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,19
# defb   evtSingleSprite+11
   # Grass
    .word 140, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_D
    .word      evtSingleSprite | 11 # Row 21, last Column, Last Sprite

# defb 145,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +3  ; Load Settings from bank 2
# defb   evtSetMove,mveCustom1+8
# defb   evtSingleSprite+12
   # Kamisagi
    .word 145, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 3
    .word      evtSetMove, mveCustom1 | 0b1000
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 146,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +5  ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # Bitterfly
    .word 146, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 150,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb   evtSetProgMoveLife,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb   evtSingleSprite,128+ 27,160+24,50+24 ; Single Object sprite 11 (animated)
   # drone
    .word 150, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+160)<<X | (24+50)<<Y

# defb 160,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +5  ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # Bitterfly
    .word 160, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

   # Grass
# defb 170,evtMultipleCommands +3
# defb   evtSettingsBank_Load +0
# defb   evtSetSprite,16
# defb   evtSingleSprite+12
    .word 170, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_A
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 175,evtMultipleCommands +2
# defb   evtSettingsBank_Load +7
# defb   evtSingleSprite+12 ; Row 16, last Column, Last Sprite
   # Zombie Capybara
    .word 175, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 190,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4  ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 190, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 190,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,17
# defb   evtSingleSprite+12
   # Grass
    .word 190, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_B
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 195,evtMultipleCommands+3 ; 2 commands at the same timepoint
# defb evtAddToForeground
# defb   evtSetProgMoveLife,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb   evtSingleSprite,128+ 25,160+24,50+24 ; Single Object sprite 11 (animated)
   # Powerup Rate
    .word 195, evtMultipleCommands | 3
    .word      evtAddToForeground
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+50)<<Y

# defb 198,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 198, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 200,evtMultipleCommands + 5 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +2   ; Load Settings from bank 2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+1
# defb   evtSetProg,prgFireMid+11
# defb   evtSingleSprite+7
   # MukadeBachi1
    .word 200, evtMultipleCommands | 5
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_1
    .word      evtSetProg, prgFireMid | 11
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 201,evtMultipleCommands +2  ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4   ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 201, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 202,evtMultipleCommands +2
# defb   evtSettingsBank_Load +8
# defb   evtSingleSprite+3
   # Shroom Bomber
    .word 202, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 8
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite

# defb 203,evtMultipleCommands+4   ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +2   ; Load Settings from bank 2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+2
# defb   evtSingleSprite+7
   # MukadeBachi2
    .word 203, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_2
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 205,evtMultipleCommands +3  ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +3   ; Load Settings from bank 2
# defb   evtSetMove,mveCustom1+8
# defb   evtSingleSprite+12
   # Kamisagi
    .word 205, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 3
    .word      evtSetMove, mveCustom1 | 0b1000
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 206,evtMultipleCommands+5
# defb   evtSettingsBank_Load +2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+29
# defb   evtSetProg,prgFireSlow+13
# defb   evtSingleSprite+7
   # MukadeBachi3
    .word 206, evtMultipleCommands | 5
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_3
    .word      evtSetProg, prgFireSlow | 13
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 207,evtMultipleCommands +2  ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4   ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 207, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 208,evtMultipleCommands +2  ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12        ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 208, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 209,evtMultipleCommands+4   ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +2   ; Load Settings from bank 2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+2
# defb   evtSingleSprite+7
   # MukadeBachi4
    .word 209, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_3
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 212,evtMultipleCommands+5
# defb   evtSettingsBank_Load +2
# defb   evtSetMove,mveCustom3+4
# defb   evtSetSprite,TwoFrameSprite+3
# defb   evtSetProg,prgFireMid+12
# defb   evtSingleSprite+7
   # MukadeBachi5
    .word 212, evtMultipleCommands | 5
    .word      evtLoadObjSettings | 2
    .word      evtSetMove, mveCustom3 | 0b0100
    .word      evtSetSprite, sprTwoFrame | MUKADE_BACHI_5
    .word      evtSetProg, prgFireMid | 12
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 214,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 214, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 215,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +4  ; Load Settings from bank 2
# defb   evtSingleSprite+7
   # GnatPack
    .word 215, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite

# defb 220,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,20
# defb   evtSingleSprite+13
   # Grass
    .word 220, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_BIG
    .word      evtSingleSprite | 13 # Row 25, last Column, Last Sprite

# defb 220,evtMultipleCommands +4 ; 2 commands at the same timepoint
# defb evtAddToForeground
# defb   evtSettingsBank_Load +5  ; Load Settings from bank 2
# defb evtSetMove,mveWave+%00000000
# defb   evtSingleSprite+5
   # Bitterfly
    .word 220, evtMultipleCommands | 4
    .word      evtAddToForeground
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0000
    .word      evtSingleSprite | 5 # Row 9, last Column, Last Sprite

# defb 225,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +5  ; Load Settings from bank 2
# defb evtSetMove,mveWave+%0000001
# defb   evtSingleSprite+9
   # Bitterfly
    .word 225, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0001
    .word      evtSingleSprite | 9 # Row 9, last Column, Last Sprite

# defb 227,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +7
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Capybara
    .word 227, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 230,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,18
# defb   evtSingleSprite+11
   # Grass
    .word 230, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_C
    .word      evtSingleSprite | 11 # Row 21, last Column, Last Sprite

# defb 235,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 235, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

   # Grass
# defb 240,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +0  ; Load Settings from bank 2
# defb   evtSetSprite,19
# defb   evtSingleSprite+11
    .word 240, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_D
    .word      evtSingleSprite | 11 # Row 21, last Column, Last Sprite

# defb 245,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +6
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Salaryman
    .word 245, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 250,evtMultipleCommands +4 ; 2 commands at the same timepoint
# defb evtAddToForeground
# defb   evtSettingsBank_Load +5  ; Load Settings from bank 2
# defb evtSetMove,mveWave+%00000001
# defb   evtSingleSprite+3
   # Bitterfly
    .word 250, evtMultipleCommands | 4
    .word      evtAddToForeground
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0001
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite

# defb 250,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +5  ; Load Settings from bank 2
# defb evtSetMove,mveWave+%00000010
# defb   evtSingleSprite+10
   # Bitterfly
    .word 250, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0010
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

# defb 254,evtMultipleCommands +2 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +7
# defb   evtSingleSprite+12       ; Row 16, last Column, Last Sprite
   # Zombie Capybara
    .word 254, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 5,evtMultipleCommands +3  ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +3 ; Load Settings from bank 2
# defb   evtSetMove,mveCustom1+8
# defb   evtSingleSprite+12
   # Kamisagi
    .word 255+5, evtMultipleCommands | 3
    .word        evtLoadObjSettings | 3
    .word        evtSetMove, mveCustom1 | 0b1000
    .word        evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 7,evtMultipleCommands +3  ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +3 ; Load Settings from bank 2
# defb   evtSetMove,mveCustom1+9
# defb   evtSingleSprite+12
   # Kamisagi
    .word 255+7, evtMultipleCommands | 3
    .word        evtLoadObjSettings | 3
    .word        evtSetMove, mveCustom1 | 0b1001
    .word        evtSingleSprite | 12 # Row 23, last Column, Last Sprite

# defb 10,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +5 ; Load Settings from bank 2
# defb evtSetMove,mveWave+%00000000
# defb   evtSingleSprite+5
   # Bitterfly
    .word 255+10, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 5
    .word         evtSetMove, mveWave | 0b0000
    .word         evtSingleSprite | 5 # Row 9, last Column, Last Sprite

# defb 15,evtMultipleCommands +3 ; 2 commands at the same timepoint
# defb   evtSettingsBank_Load +5 ; Load Settings from bank 2
# defb evtSetMove,mveWave+%0000001
# defb   evtSingleSprite+9
   # Bitterfly
    .word 255+15, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 5
    .word         evtSetMove, mveWave | 0b0001
    .word         evtSingleSprite | 9 # Row 17, last Column, Last Sprite

# defb 30,%01110000+2             ; 3 commands at the same timepoint
# defb evtSetProgMoveLife,prgMovePlayer,&24,10
# defb   0,128+  30,140+24,100+24 ; Single Object sprite 11 (animated)
LevelEndAnim:
    .word 255+30, evtMultipleCommands | 2
    .word         evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word         evtSingleSprite, sprTwoFrame | DUMMY_SPRITE, (24+140)<<X | (24+100)<<Y

# defb 30,%10001001               ; Call a memory location
# defw   ClearBadguys
    .word 255+30, evtCallAddress, Player_Handler_DoSmartBomb
# Start of fade out block ------------------------------------------------------
    .equiv FadeOutStartPoint, 255+31
    .word FadeOutStartPoint + 1, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 2, evtSetPalette, BluePalette

    .word 255+35, evtCallAddress, EndLevel
#----------------------------------------------------------------------------}}}
EndLevel:
        MOV  $0x8000,R5
        JMP  ExecuteBootstrap

LevelInit: # read "..\SrcALL\Akuyou_Multiplatform_Level_GenericInit.asm"
       .ppudo_ensure $PPU_LevelMusicRestart

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
                                       # LevelInit:
                                       #        read "..\SrcALL\Akuyou_Multiplatform_Level_GenericInit.asm"
LevelLoop:
        CALL @$Background_Draw

        CALL @$EventStream_Process
        CALL @$ObjectArray_Redraw

        MOV  $ChibiSprites,@$SprShow_BankAddr
        CALL @$PlayerHandler

        CALL @$Player_StarArray_Redraw
        CALL @$StarArray_Redraw

        CALL @$ScreenBuffer_Flip

        BR   LevelLoop
                                       # LevelLoop:
                                       # read "..\SrcALL\Akuyou_Multiplatform_Level_Levelloop_PreFlip.asm"
                                       # read "..\SrcALL\Akuyou_Multiplatform_Level_Levelloop_Flip.asm"
                                       #        jp LevelLoop

                                       # ;Warp the bullet array (for boss battles)
                                       # read "Core_StarArrayWarp.asm"

                                       # read "CoreBackground_QuadSpriteColumn.asm"
#-------------------------------------------------------------------------------
# Generic Background Begin -----------------------------------------------------
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
                                                  # ;Bottom
        CLR  R0 # sprite number                   # ld a,0
        MOV  $LevelTiles,R4                       # ld de,LevelTiles
        CALL GetSpriteMempos                      # call GetSpriteMempos
                                                  # push de
      # we will need the position later for Tile bitshifts
        MOV  R4,-(SP)                             #     push de
        MOV  $8,R1                                #         ld b,16/2 ;Lines
        CALL @$Background_FloodFillQuadSprite     #         ld a,1 ;(1/1=2) Black lines
                                                  #         call BackgroundFloodFillQuadSpriteColumn ;need pointer to sprite in HL
                                                  #     pop de
                                                  #     ex hl,de                ;Move down 8 lines
                                                  #         ld bc,8*8
                                                  #         add hl,bc
                                                  #     ex hl,de
                                                  #     push de
                                                  #     push de
        CLR  R0                                   #         ld de,&0000
        MOV  $4,R1                                #         ld b,4
        CALL @$Background_SolidFill               #         call BackgroundSolidFill ;need pointer to sprite in HL
                                                  #     pop de

                                                  #     ld b,64/4 ;************ COLUMN WORKS IN MULTIPLES OF 4, so DEVIDE BY 4 and put result in B! ******************
        MOV  $16,R1                               #     ld a,3 ;Black lines (3/1=4)
        CALL @$Background_FloodFillQuadSprite     #     call BackgroundFloodFillQuadSpriteColumn ;need pointer to sprite in HL

                                                  #     pop de
                                                  #     ex hl,de ;Move down 16 lines
                                                  #         ld bc,8*16
                                                  #         add hl,bc
                                                  #     ex hl,de
                                                  #     push de
        CLR  R0                                   #         ld de,&0000
        MOV  $4,R1                                #         ld b,4
        CALL @$Background_SolidFill               #         call BackgroundSolidFill ;need pointer to sprite in HL
                                                  #     pop de
                                                  #     push de
        MOV  $8,R1                                #         ld b,8 ;Lines
        CALL @$Background_FloodFillQuadSprite     #         call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL


        CLR  R0                                   #         ld de,&0000
       #MOV  $16,R1                               #         ld b,16
        MOV  $16+54,R1
        CALL @$Background_SolidFill               #         call BackgroundSolidFill ;need pointer to sprite in HL

        MOV  R4,-(SP) # Background_Gradient corrupts R4
                                                  #         GradientBottomStart equ 40
        MOV  $GradientBottom,R3 # 40 lines        #         ld de,GradientBottom
        MOV  $GradientBottomStart,R1              #         ld b,GradientBottomStart
        MOV  $0b11111111,R2 # Shift on Timer Ticks#         ld c,%11111111          ;Shift on Timer Ticks
        CALL @$Background_Gradient                #         call Akuyou_Background_Gradient
                                                  #     pop de

                                                  #     ex hl,de                ;Move down 16 lines
                                                  #         ld bc,8*8
                                                  #         add hl,bc
                                                  #     ex hl,de

        MOV  $8,R1 # number of lines              #     ld b,8 ;Lines
        MOV  (SP)+,R4
        CALL @$Background_FloodFillQuadSprite     #     call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL
# Tile Bitshifts ---------------------------------------------------------------
      # pop de ;needed to keep this for the bitshifts
        MOV  (SP)+,R5 # ponter to the first tile
                                       #        pop de ;needed to keep this for the bitshifts
       .equiv TileWidthBytes, 8        #        ld hl,0007 ; shift to the right of the sprite
      # we do MOV  -(R5),R0 to read words, to be able to use ASH for shifts
      # so R5 should point to next line
        ADD  $TileWidthBytes,R5        #        add hl,de

        MOV  $0b11111110,R0     # shift on timer ticks # ld a,%11111110 ;Shift on Timer Ticks
        MOV  $TileWidthBytes,R1 # bytes                # ld b,&8         ; Bytes
        MOV  $8,R2              # lines                # ld c,8          ;lines
        CALL @$BitShifter       #                      # call BitShifter ;need pointer to sprite in HL

                                       # ;must be byte aligned
        MOV  $0b11111100,R0     # shift on timer ticks # ld a,%11111100 ;Shift on Timer Ticks
        MOV  $TileWidthBytes,R1 # bytes                # ld b,&8         ; Bytes
        MOV  $16,R2             # lines                # ld c,16         ;lines
        CALL @$BitShifter       #                      # call BitShifter ;need pointer to sprite in HL

                                       # ;must be byte aligned - otherwise recalc!
        MOV  $0b11111110,R0     # shift on timer ticks # ld a,%11111110 ;Shift on Timer Ticks
        MOV  $TileWidthBytes,R1 # bytes                # ld b,&8         ; Bytes
        MOV  $8,R2              # lines                # ld c,8          ;lines
        CALL @$BitShifter       #                      # call BitShifter ;need pointer to sprite in HL

                                                       # inc h   ;Bitshifter wraps on byte align, so manually recalc, or force a move every 32 lines

                                                       # ld a,%11111111 ;Shift on Timer Ticks
        MOV  $0b11111111,R0     # shift on timer ticks # ld b,&8         ; Bytes
        MOV  $TileWidthBytes,R1 # bytes                # ld c,8          ;lines
        MOV  $8,R2              # lines
        CALL @$BitShifterDouble #                      # call BitShifterDouble ;need pointer to sprite in HL
        RETURN                         # ret

                                       # Background_SmartBomb:
                                       #        ld e,d
                                       #        jr Background_Fill
                                       # Background_Black:
                                       #        ld de,&0000
                                       # Background_Fill:
                                       #                ld b,200
                                       #                jp BackgroundSolidFill
# Background Data ----------------------------------------------#
   .equiv GradientTopStart, 40 # lines count                    #
 GradientTop:                                                   # GradientTop:
    .word 0x00FF, 0x00FF                # 1st line              #        defb &0F,&0F    ;1; first line
    .word GradientTopStart - 10, 0x00DD # 2nd line num, new word#        defb GradientTopStart-10,&0D    ;2; line num, New byte
    .word GradientTopStart - 16, 0x0077                         #        defb GradientTopStart-16,&07    ;3
    .word GradientTopStart - 20, 0x00AA                         #        defb GradientTopStart-20,&0A    ;4
    .word GradientTopStart - 26, 0x0055                         #        defb GradientTopStart-26,&05    ;5
    .word GradientTopStart - 30, 0x0088                         #        defb GradientTopStart-30,&08    ;6
    .word GradientTopStart - 36, 0x0022                         #        defb GradientTopStart-36,&02    ;7
    .word GradientTopStart - 38, 0x0000                         #        defb GradientTopStart-38,&00    ;7
    .word GradientTopStart - 40, 0x0000                         #        defb GradientTopStart-40,&00    ;7
    .word 0xFFFF                                                #        defb 255

    .equiv GradientBottomStart, 40 # lines count
 GradientBottom:                                                # GradientBottom:
    .word 0x0000, 0x0000 # 1st line                             #        defb &0,&0      ;1; first line
    .word 40, 0x0022     # 2nd line num, new word               #        defb 40,&20     ;10
    .word 36, 0x0088                                            #        defb 36,&80     ;11
    .word 30, 0x0055                                            #        defb 30,&50     ;12
    .word 26, 0x00AA                                            #        defb 26,&A0     ;13
    .word 20, 0x0077                                            #        defb 20,&70     ;14
    .word 10, 0x00DD                                            #        defb 10,&D0     ;15
    .word  4, 0x00FF                                            #        defb 4,&F0      ;15
    .word  2, 0x00FF                                            #        defb 2,&F0      ;15
    .word 0xFFFF                                                #        defb 255
#---------------------------------------------------------------#

CustomMoveBouncer:
                                       #        ld c,190
                                       #        push hl

                                       #                ; B=X C=Y D=Move
                                       #                ld a,b
                                       #                cp 184
                                       #                call z,CustomMoveBouncer_Init

                                       #                call Akuyou_Timer_GetTimer
                                       #                ld h,a

                                       #                ;shift the time
                                       #                ldai
                                       #                ld l,a

                                       #                ld a,d
                                       #                and %00001111
                                       #                add a,l
                                       #                ldia

                                       #                bit 5,a
                                       #                jr z,CustomMoveBouncer_Vert
                                       #                dec b
                                       #                ld iyl,0                        ; Program - do nothing
                                       #                jr CustomMoveBouncer_Done
                                       # CustomMoveBouncer_Vert
                                       #                ;0000D111
                                       #                bit 4,a
                                       #                jr z,CustomMoveBouncer_DoJump
                                       #                xor %00001111
                                       #                jr CustomMoveBouncer_DoJump
                                       # CustomMoveBouncer_DoJump
                                       #                and %00001111
                                       #                rlca
                                       #                rlca
                                       #                rlca
                                       #                cpl
                                       #                inc a
                                       #                add c
                                       #                ld c,a

                                       #                ldai
                                       #                and %00011111
                                       #                cp  %00001110
                                       #                jp nz,CustomMoveBouncer_FireNormal
                                       #                ld iyl,prgFireFast+13           ; Program Fire
                                       #                jp CustomMoveBouncer_DoSprite

                                       # CustomMoveBouncer_FireNormal
                                       #                ld iyl,prgFireFast+16           ; Program Fire

                                       # CustomMoveBouncer_DoSprite
                                       #                ld a,h
                                       #                bit 1,a
                                       #                jp z,CustomMoveBouncer_Done
                                       #                call Akuyou_ObjectProgram_SpriteBankSwitch
                                       # CustomMoveBouncer_Done:
                                       #        pop hl
        RETURN                         # ret

                                       # CustomMoveBouncer_Init:
                                       #        dec b
                                       # ret

CustomMove3:
                                       #        di
                                       #        exx
                                       #        ld hl,CustomMovePatternGeneric
                                       #        ld de,CustomMovePatternMiniWave
                                       #        ld bc,CustomMovePattern_Init10

                                       # jr CustomMovePattern

                                       # CustomMovePatternMiniWave:
                                       #        ; WaveSmall pattern  1010SPPP   S= Speed, PPP Position
                                       #        ld a,b
                                       #        srl a   ; unrem for speedup
                                       #        srl a   ; unrem for speedup
                                       #        and %00011111
                                       #        cp  %00010000
                                       #        jr C,DoMoves_WaveSmallContinue
                                       #        xor %00011111
                                       # DoMoves_WaveSmallContinue:
                                       #        ld C,a
                                       #        ld a,%00000011
                                       # DoMoves_WaveEnd
                                       #        rrca
                                       #        rrca
                                       #        rrca            ; equivalent to 5 left shifts
                                       #        or %00011100

                                       #        add C
                                       #        ld C,a

                                       #        ld a,B
                                       #        sub 1
                                       #        ld B,A
                                       #        cp 24                   ;we are at the bottom of the screen
                                       #        jp C,CustomMovePatternKill      ;over the page
                                       #        ret

                                       # GetCustomRam:
                                       #        and %00001111
                                       #                ld hl,CustomRam

                                       #                        ld d,0
                                       #                        ld e,a
                                       #                        add hl,de
                                       #                        add hl,de
                                       #                        add hl,de
                                       #                        add hl,de
                                       #                push hl
                                       #                pop ix
        RETURN                         # ret

                                       # CustomMovePattern:             ; B=X C=Y D=Move
                                       #        ld (CustomPatternJump_Plus2-2),hl
                                       #        ld (CustomPatternbJump_Plus2-2),de
                                       #        ld (CustomMovePattern_Init_Plus2-2),bc
                                       #        exx

                                       #        ld a,ixl        ;lifCustom
                                       #        ex af,af'

                                       #        ld a,d
                                       #        exx
                                       #        push ix

                                       #                call GetCustomRam

                                       #                call Akuyou_Timer_GetTimer
                                       #                ld d,a
                                       #                ldai    ; Level time
                                       #                ld e,a


                                       #                ;dont update more than once per tick!
                                       #                ld a,(ix+1)
                                       #                cp e
                                       #                jr z,CustomMovePattern_NoTick
                                       #                ld a,e
                                       #                ld (ix+1),e

                                       #                ;see if this is our first run
                                       #                ex af,af'
                                       #                        cp 255
                                       #                        call nc,CustomMovePattern_Init :CustomMovePattern_Init_Plus2
                                       #                ex af,af'

                                       #                ; here is where we make some moves!
                                       #                exx
                                       #                call CustomMovePatternGeneric :CustomPatternJump_Plus2
                                       #                exx
                                       #                ;increment the pos

                                       # CustomMovePattern_NoTick:
                                       #                ; here is where we make some moves!
                                       #                exx
                                       #                call null :CustomPatternbJump_Plus2

                                       #                ld a,b
                                       #                cp 160+24
                                       #                call NC,CustomMovePatternKill
                                       #                exx
                                       #                ;increment the pos

                                       # CustomMovePattern_Done:
                                       #        ld a,iyl
                                       #        cp prgSpecial
                                       #        jr nz,CustomMovePattern_NotBossTarget
                                       #        ld a,0:TargetSpritecountdown_Plus1
                                       #        or a
                                       #        jr z,CustomMovePattern_TargetReset
                                       #        dec a
                                       #        ld (TargetSpritecountdown_Plus1-1),a
                                       # CustomMovePattern_TargetSet:
                                       #        ld a,128+9      :HitTargetSprite_Plus1
                                       #        ld iyh,a
                                       #        jr CustomMovePattern_NotBossTarget
                                       # CustomMovePattern_TargetReset:
                                       #        ld a,128+8      :ResetTargetSprite_Plus1
                                       #        ld iyh,a
                                       # CustomMovePattern_NotBossTarget:
                                       #        pop ix
                                       #        exx

                                       #        ex af,af'

                                       #        ld ixl,a        ;lifCustom

                                       # ei
                                       # ret

                                       # CustomMovePatternKill:
                                       #        ;ex af,af'
                                       #        ;xor a

                                       #        ld b,0
                                       #        ld c,b
                                       #        ld D,b
                                       #        ;ex af,af'
                                       # ret

                                       # CustomMovePattern_Init10:
                                       #        call CustomMovePattern_Init
                                       #        ld a,lifEnemy+10                ;New Life
                                       # ret

                                       # CustomMovePattern_Init:
                                       #        xor a

                                       #        ld (ix+0),a
                                       #        ld (ix+1),a
                                       #        ld (ix+2),a
                                       #        ld (ix+3),a

                                       #        ld a,lifEnemy+6                 ;New Life
                                       # ret

                                       # CustomMovePatternGeneric:
                                       #        ld a,(ix+0)
                                       #        inc a
                                       #        ld (ix+0),a
                                       # ret

                                       # null:          ;NULL COMMAND MUST BE IN SPECTRUM BLOCK!
                                       # ret
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
    .byte   1, setColors, Black, Red, brGreen, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
end:
