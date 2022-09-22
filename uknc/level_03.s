               .nolist

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

    .word 0, evtResetPowerup

# We will use 4 Paralax layers
#  ---------()- (sky)           %11001000
#  ------------ (Far)           %11000100
#  -----X---X-- (mid)           %11000010       Bank 1
#  []=====[]=== (foreground)    %11000001       Bank 0

    .word 0, evtReprogram_PowerupSprites  # Define powerup sprites
    .byte    sprTwoFrame | POWERUP_DRONE
    .byte    sprTwoFrame | POWERUP_RATE
    .byte    sprTwoFrame | POWERUP_POWER
    .byte    sprTwoFrame | COIN

    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife               # 1
    .word        prgBitShift
    .word        mveBackground | 0b0001
    .word        lifeImmortal
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
   # Mukadebachi
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgNone, mveCustom3 | 0b0100, lifeEnemy | 9
    .word    evtSetSprite | sprTwoFrame | MUKADE_BACHI_2
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 2
   # mukadebachi
    .word 0, evtReprogramCustomMove3, CustomMove3
   # Kamisagi
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgNone, mveCustom1 | 0b0000, lifeEnemy | 5
    .word    evtSetSprite | sprSingleFrame | KAMISAGI
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 3
   # Kamisagi program code
    .word 0, evtReprogramCustomMove1, CustomMoveBouncer
   # GnatPack
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireFast | 16, mveWave | 0b0001, lifeEnemy | 3
    .word    evtSetSprite | sprTwoFrame | GNAT_PACK
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 4
   # Biterfly
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireSlow | 13, mveWave | 0b0000, lifeEnemy | 6
    .word    evtSetSprite | sprTwoFrame | BITERFLY
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 5
   # Zombie Salaryman
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireSlow | 1, mvRegular | spdNormal | 043, lifeEnemy | 6
    .word    evtSetSprite | sprTwoFrame | ZOMBIE_SALARYMAN
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 6
   # Zombie Capybara
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireSnail | 5, mvRegular | spdNormal | 043, lifeEnemy | 9
    .word    evtSetSprite | sprTwoFrame | ZOMBIE_CAPYBARA
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 7
   # Shroom Bomber
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife, prgFireMid | 6, mvRegular | spdNormal | 043, lifeEnemy | 2
    .word    evtSetSprite | sprTwoFrame | SHROOM_BOMBER
    .word    evtSetObjectSize | 24
    .word    evtAddToForeground
    .word    evtSaveObjSettings | 8
#-------------------------------------------------------------------------------
   # Grass Tuft
    .word 0, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 1
    .word    evtSingleSprite, GRASS_TUFT_BIG, (24+70)<<X | (12*16)<<Y
   # Grass Tuft
    .word 0, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 1
    .word    evtSingleSprite, GRASS_TUFT_B, (24+30)<<X | (11*16)<<Y
   # Grass Tuft
    .word 0, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 1
    .word    evtSingleSprite, GRASS_TUFT_C, (24+110)<<X | (11*16)<<Y

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

   # GnatPack
    .word 5, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 4
    .word    evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Zombie Salaryman
    .word 9, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 6
    .word    evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Zombie Salaryman
    .word 24, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # drone
    .word 25, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+160)<<X | (24+50)<<Y
   # GnatPack
    .word 28, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Grass
    .word 30, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_BIG
    .word     evtSingleSprite | 13 # Row 25, last Column, Last Sprite
   # Shroom Bomber
    .word 38, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 8
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Grass
    .word 40, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_A
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Zombie Salaryman
    .word 45, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # GnatPack
    .word 50, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Shroom Bomber
    .word 60, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 8
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # drone
    .word 65, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+160)<<X | (24+50)<<Y
   # Grass
    .word 70, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_BIG
    .word     evtSingleSprite | 13 # Row 25, last Column, Last Sprite
   # Zombie Capybara
    .word 70, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 7
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Grass
    .word 80, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_B
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Grass
    .word 90, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 0
    .word     evtSetSprite | sprSingleFrame | GRASS_TUFT_C
    .word     evtSingleSprite | 11 # Row 21, last Column, Last Sprite
   # Zombie Salaryman
    .word 95, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Grass
    .word 100, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_A
    .word      evtSingleSprite | 13 # Row 25, last Column, Last Sprite
   # MukadeBachi1
    .word 100, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_1
    .word      evtSetProg, prgFireSlow | 11
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # MukadeBachi2
    .word 103, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_2
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Powerup Rate
    .word 105, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+50)<<Y
   # MukadeBachi3
    .word 106, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_3
    .word      evtSetProg, prgFireSnail | 13
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # MukadeBachi4
    .word 109, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_3
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # MukadeBachi5
    .word 112, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_5
    .word      evtSetProg, prgFireSlow | 12
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Shroom Bomber
    .word 118, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 8
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Grass
    .word 120, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_B
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Zombie Salaryman
    .word 130, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Grass
    .word 140, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_D
    .word      evtSingleSprite | 11 # Row 21, last Column, Last Sprite
   # Kamisagi
    .word 145, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 3
    .word      evtSetMove, mveCustom1 | 0b1000
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Bitterfly
    .word 146, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # drone
    .word 150, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+160)<<X | (24+50)<<Y
   # Bitterfly
    .word 160, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Grass
    .word 170, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_A
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Zombie Capybara
    .word 175, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # GnatPack
    .word 190, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Grass
    .word 190, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_B
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Powerup Rate
    .word 195, evtMultipleCommands | 3
    .word      evtAddToForeground
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+50)<<Y
   # Zombie Salaryman
    .word 198, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # MukadeBachi1
    .word 200, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_1
    .word      evtSetProg, prgFireMid | 11
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # GnatPack
    .word 201, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Shroom Bomber
    .word 202, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 8
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # MukadeBachi2
    .word 203, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_2
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Kamisagi
    .word 205, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 3
    .word      evtSetMove, mveCustom1 | 0b1000
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # MukadeBachi3
    .word 206, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_3
    .word      evtSetProg, prgFireSlow | 13
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # GnatPack
    .word 207, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Zombie Salaryman
    .word 208, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # MukadeBachi4
    .word 209, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_3
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # MukadeBachi5
    .word 212, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 2
    .word      evtSetSprite | sprTwoFrame | MUKADE_BACHI_5
    .word      evtSetProg, prgFireMid | 12
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Zombie Salaryman
    .word 214, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # GnatPack
    .word 215, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Grass
    .word 220, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_BIG
    .word      evtSingleSprite | 13 # Row 25, last Column, Last Sprite
   # Bitterfly
    .word 220, evtMultipleCommands | 4
    .word      evtAddToForeground
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0000
    .word      evtSingleSprite | 5 # Row 9, last Column, Last Sprite
   # Bitterfly
    .word 225, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0001
    .word      evtSingleSprite | 9 # Row 9, last Column, Last Sprite
   # Zombie Capybara
    .word 227, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Grass
    .word 230, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_C
    .word      evtSingleSprite | 11 # Row 21, last Column, Last Sprite
   # Zombie Salaryman
    .word 235, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Grass
    .word 240, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 0
    .word      evtSetSprite | sprSingleFrame | GRASS_TUFT_D
    .word      evtSingleSprite | 11 # Row 21, last Column, Last Sprite
   # Zombie Salaryman
    .word 245, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Bitterfly
    .word 250, evtMultipleCommands | 4
    .word      evtAddToForeground
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0001
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Bitterfly
    .word 250, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 5
    .word      evtSetMove, mveWave | 0b0010
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite
   # Zombie Capybara
    .word 254, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Kamisagi
    .word 255+5, evtMultipleCommands | 3
    .word        evtLoadObjSettings | 3
    .word        evtSetMove, mveCustom1 | 0b1000
    .word        evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Kamisagi
    .word 255+7, evtMultipleCommands | 3
    .word        evtLoadObjSettings | 3
    .word        evtSetMove, mveCustom1 | 0b1001
    .word        evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Bitterfly
    .word 255+10, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 5
    .word         evtSetMove, mveWave | 0b0000
    .word         evtSingleSprite | 5 # Row 9, last Column, Last Sprite
   # Bitterfly
    .word 255+15, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 5
    .word         evtSetMove, mveWave | 0b0001
    .word         evtSingleSprite | 9 # Row 17, last Column, Last Sprite

LevelEndAnim:
    .word 255+30, evtMultipleCommands | 2
    .word         evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word         evtSingleSprite, sprTwoFrame | DUMMY_SPRITE, (24+140)<<X | (24+100)<<Y

    .word 255+30, evtCallAddress, Player_Handler_DoSmartBomb
# Start of fade out block ------------------------------------------------------
    .equiv FadeOutStartPoint, 255+31
    .word FadeOutStartPoint + 1, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 2, evtSetPalette, BluePalette

    .word 255+35, evtCallAddress, EndLevel
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

        BR   LevelLoop
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
      # in:  R1 C = Y
      #      R2 LSB D = move,
      #      R2 MSB iyh = sprite
      #      R3 LSB ixl = Life,
      #      R3 MSB iyl = Program Code
      #      R4 B = X
      #
      # out: R1 new Y
      #      R2 unmodified
      #      R3 LSB unmodified
      #      R3 MSB updated program code
      #      R4 new X
      #      R5 unmodified
CustomMoveBouncer:
        MOV  $190,R1                   # ld c,190
        PUSH R5                        # push hl
                                       #     ; B=X C=Y D=Move
                                       #     ld a,b
        CMP  R4,$24+160                #     cp 184
        BNE  1$                        #     call z,CustomMoveBouncer_Init
        DEC  R4
    1$:                                #     call Akuyou_Timer_GetTimer
                                       #     ld h,a

                                       #     ;shift the time
                                       #     ldai
                                       #     ld l,a

        MOV  R2,R0                     #     ld a,d
        BIC  $0xFFF0,R0                #     and %00001111
        ADD  @$Timer_CurrentTick,R0    #     add a,l
        MOV  R0,R5                     #     ldia

        BITB $0x20,R0                  #     bit 5,a
        BZE  CustomMoveBouncer_Vert    #     jr z,CustomMoveBouncer_Vert

        DEC  R4                        #     dec b
        BIC  $0xFF00,R3                #     ld iyl,0 ; Program - do nothing
        BR   CustomMoveBouncer_Done    #     jr CustomMoveBouncer_Done
CustomMoveBouncer_Vert:
                                       #     ;0000D111
        BITB $0x10,R0                  #     bit 4,a
        BZE  CustomMoveBouncer_DoJump  #     jr z,CustomMoveBouncer_DoJump

        PUSH R0
        MOV  $0x0F,R0
        XOR  R0,(SP)                   #     xor %00001111
        POP  R0
        BR   CustomMoveBouncer_DoJump  #     jr CustomMoveBouncer_DoJump

CustomMoveBouncer_DoJump:
        BIC  $0xFFF0,R0                #     and %00001111
        ASL  R0                        #     rlca
        ASL  R0                        #     rlca
        ASL  R0                        #     rlca
        COM  R0                        #     cpl
        INC  R0                        #     inc a
        ADD  R0,R1                     #     add c
                                       #     ld c,a

        MOV  R5,R0                     #     ldai
        BIC  $0xFFE0,R0                #     and %00011111
        CMPB R0,$0b00001110            #     cp  %00001110
        BNE  CustomMoveBouncer_FireNormal #     jp nz,CustomMoveBouncer_FireNormal
      # R3 MSB iyl = Program Code
        BIC  $0xFF00,R3
        BIS  $(prgFireFast|13)<<8,R3   #     ld iyl,prgFireFast+13 ; Program Fire
        BR   CustomMoveBouncer_DoSprite#     jp CustomMoveBouncer_DoSprite

CustomMoveBouncer_FireNormal:
        BIC  $0xFF00,R3
        BIS  $(prgFireFast|16)<<8,R3   #     ld iyl,prgFireFast+16 ; Program Fire

CustomMoveBouncer_DoSprite:
                                       #     ld a,h
        BIT  $0x02,@$Timer_TicksOccured#     bit 1,a
        BZE  CustomMoveBouncer_Done    #     jp z,CustomMoveBouncer_Done

        MOV  @$SpriteBanksVectors+4,@$SprShow_BankAddr # call Akuyou_ObjectProgram_SpriteBankSwitch
CustomMoveBouncer_Done:
        POP  R5                        # pop hl
        RETURN                         # ret

                                       # CustomMoveBouncer_Init:
                                       #        dec b
                                       # ret

CustomMove3:
        MOV  $CustomMovePatternGeneric, @$dstCustomMovePatternA # ld hl,CustomMovePatternGeneric
        MOV  $CustomMovePatternMiniWave,@$dstCustomMovePatternB # ld de,CustomMovePatternMiniWave
        MOV  $CustomMovePattern_Init10, @$dstCustomMovePattern_Init # ld bc,CustomMovePattern_Init10
        BR   CustomMovePattern         #   jr CustomMovePattern

      # R4=B=X, R1=C=Y, R2: LSB=D=move, MSB=anything
CustomMovePatternMiniWave:
      # WaveSmall pattern  1010SPPP  S= Speed, PPP Position
        MOV  R4,R1                     #        ld a,b
        ASR  R1                        #        srl a ; rem for speedup
        ASR  R1                        #        srl a ; rem for speedup
        BIC  $0xFFE0,R1                #        and %00011111
        CMP  R1,$0x10                  #        cp  %00010000
        BLO  DoMoves_WaveSmallContinue #        jr C,DoMoves_WaveSmallContinue
        MOV  $0x1F,R0
        XOR  R0,R1                     #        xor %00011111
DoMoves_WaveSmallContinue:
        MOV  R2,R0                     #        ld C,a
        MOV  $0x03,R0                  #        ld a,%00000011
# DoMoves_WaveEnd
        ASH  $5,R0                     #        rrca
                                       #        rrca
                                       #        rrca    ; equivalent to 5 left shifts
        BIS  $0b00011100,R0            #        or %00011100
        ADD  R0,R1                     #        add C
                                       #        ld C,a

        DEC  R4                        #        ld a,B
                                       #        sub 1
                                       #        ld B,A
        CMP  R4,$16                    #        cp 24   ; we are at the edge of the screen
        BLO  CustomMovePatternKill     #        jp C,CustomMovePatternKill ; over the page
        RETURN                         #        ret

GetCustomRam:
        BIC  $0xFFF0,R5                # and %00001111
                                       # ld hl,CustomRam
                                       #   ld d,0
                                       #   ld e,a
        ASL  R5                        #   add hl,de
        ASL  R5                        #   add hl,de
        ADD  $CustomRam,R5             #   add hl,de
                                       #   add hl,de
                                       # push hl
                                       # pop ix
        RETURN                         # ret

CustomRam:
       .space 128

      # in:  R1 C = Y
      #      R2 LSB D = move, R2 MSB = sprite
      #      R3 LSB ixl = Life, R3 MSB iyl = Program Code
      #      R4 B = X
      #
      # out: R1 new Y
      #      R2 LSB unmodified, MSB sprite
      #      R3 LSB life, MSB unmodified
      #      R4 new X
      #      R5 unmodified
CustomMovePattern: # B=X C=Y D=Move
        MOVB R3,@$CustomMove_LifeCustom # ld a,ixl        ;lifCustom
        PUSH R5                        # ex af,af'
        MOVB R2,R5                     # ld a,d
                                       # exx
                                       # push ix
        CALL GetCustomRam              #         call GetCustomRam
                                       #         call Akuyou_ Timer_GetTimer
                                       #         ld d,a ; Timer_TicksOccured
                                       #         ldai    ; Level time
                                       #         ld e,a ; Timer_CurrentTick

                                       #        ;dont update more than once per tick!
                                       #         ld a,(ix+1)
        CMPB 1(R5),@$Timer_CurrentTick #         cp e
        BEQ  CustomMovePattern_NoTick  #         jr z,CustomMovePattern_NoTick
                                       #         ld a,e
        MOVB @$Timer_CurrentTick,1(R5) #         ld (ix+1),e

                                       #        ;see if this is our first run
                                       #         ex af,af'
        CMPB R3,$0xFF                  #         cp 255
        BLO  CustomMove_DoMove

      # not used
       .equiv dstCustomMovePattern_Init, .+2
        CALL @$CustomMovePattern_Init  #         call nc,CustomMovePattern_Init :CustomMovePattern_Init_Plus2
                                       #         ex af,af'

                                       #        ;here is where we make some moves!
                                       #         exx
CustomMove_DoMove:
       .equiv dstCustomMovePatternA, .+2
        CALL @$CustomMovePatternGeneric#         call CustomMovePatternGeneric :CustomPatternJump_Plus2
                                       #         exx
                                       #        ;increment the pos
CustomMovePattern_NoTick:
                                       #        ; here is where we make some moves!
                                       #        exx
       .equiv dstCustomMovePatternB, .+2
        CALL @$CustomMovePatternMiniWave #        call null :CustomPatternBJump_Plus2

                                       #        ld a,b
        CMP  R4,$24+160                #        cp 160+24
        BLO  CustomMovePattern_Done    #        call NC,CustomMovePatternKill
        CALL CustomMovePatternKill
                                       #        exx
                                       #        ;increment the pos
CustomMovePattern_Done:
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        MOV  R3,R0                           # ld a,iyl
        CLRB R0
        CMP  R0,$prgSpecial<<8               # cp prgSpecial
        BNE  CustomMovePattern_NotBossTarget # jr nz,CustomMovePattern_NotBossTarget

      # not used
       .equiv TargetSpriteCountdown, .+2     # ld a,0:TargetSpritecountdown_Plus1
        TST  $0                              # or a
        BZE  CustomMovePattern_TargetReset   # jr z,CustomMovePattern_TargetReset

        DEC  @$TargetSpriteCountdown         # dec a
                                             # ld (TargetSpritecountdown_Plus1-1),a
# CustomMovePattern_TargetSet:
      # R2 LSB D = move, R2 MSB = sprite
        SWAB R2
        CLRB R2
       .equiv HitTargetSprite, .+2
        BISB $sprTwoFrame|9,R2               # ld a,128+9      :HitTargetSprite_Plus1
        SWAB R2                              # ld iyh,a
        BR   CustomMovePattern_NotBossTarget # jr CustomMovePattern_NotBossTarget

      # not used
CustomMovePattern_TargetReset:
        SWAB R2
        CLRB R2
       .equiv ResetTargetSprite, .+2
        BISB $sprTwoFrame|8,R2               # ld a,128+8      :ResetTargetSprite_Plus1
        SWAB R2                              # ld iyh,a
CustomMovePattern_NotBossTarget:
        POP  R5                        #        pop ix
                                       #        exx
                                       #        ex af,af'
      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
        CLRB R3
       .equiv CustomMove_LifeCustom, .+2
        BISB $0,R3                     #        ld ixl,a        ;lifCustom
                                       # ei
        RETURN                         # ret

CustomMovePatternKill:
        CLR  R4 #        ld b,0
        CLR  R1 #        ld c,b
        CLRB R2 #        ld D,b
        RETURN  # ret

      # not used
CustomMovePattern_Init10:
        CALL CustomMovePattern_Init    # call CustomMovePattern_Init
        MOV  $lifeEnemy|10,@$CustomMove_LifeCustom # ld a,lifEnemy+10 ;New Life
        RETURN                         # ret

      # not used
CustomMovePattern_Init:
        PUSH R5                        #        xor a
        CLRB (R5)+                     #        ld (ix+0),a
        CLRB (R5)+                     #        ld (ix+1),a
        CLRB (R5)+                     #        ld (ix+2),a
        CLRB (R5)+                     #        ld (ix+3),a
        POP  R5
        MOV  $lifeEnemy|6,@$CustomMove_LifeCustom # ld a,lifEnemy+6 ;New Life
        RETURN                         # ret

CustomMovePatternGeneric:
        INCB (R5)                      #        ld a,(ix+0)
                                       #        inc a
                                       #        ld (ix+0),a
        RETURN                         # ret

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
