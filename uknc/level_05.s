               .list

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level05SizeWords, (end - start) >> 1
               .global Level05SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

       .incbin "build/level_05.0.spr"
LevelSprites2:
       .incbin "build/level_05.1.spr"
ChibiSprites:
       .incbin "build/chibi_lr.spr"
LevelTiles:
       .incbin "build/level_05_tiles.spr"

EventStreamArray:
    .equiv DUMMY_SPRITE, 0

    .equiv TENTITACK,       1 #  0
    .equiv SUPERFISH,       2 #  1
    .equiv LILIFROG,        3 #  2
    .equiv SPITFISH,        4 #  3
    .equiv STARFISH_BOMBER, 5 #  4
    .equiv PAIRANAH,        6 #  5
    .equiv BUBBLE24,        7 #  6
    .equiv BUBBLE16,        8 #  7
    .equiv MINERFISH,       9 #  8
    .equiv COIN,           10 #  9
    .equiv FISHFACE_LEFT,  11 # 10 # height 24 -> 19
    .equiv FISHBONE_LEFT,  12 # 11 # height 23 -> 16
    .equiv POWERUP_POWER,  13 # 12
    .equiv POWERUP_RATE,   14 # 13
    .equiv POWERUP_DRONE,  15 # 14
    .equiv WAVE1,          16 # 15
    .equiv WAVE2,          17 # 16
    .equiv WAVE3,          18 # 17
    .equiv WEED1,          19 # 18
    .equiv WEED2,          20 # 19
    .equiv CORAL1,         21 # 20
    .equiv CORAL2,         22 # 21
    .equiv FISHFACE_RIGHT, 23 # 22
    .equiv FISHBONE_RIGHT, 24 # 23
    .equiv TUFFET,         25 # 24
    .equiv GRASS1,         26 # 25
    .equiv GRASS2,         27 # 26
    .equiv BUSH,           28 # 27
    .equiv ROCK1,          29 # 28 # height 16 -> 11
    .equiv ROCK2,          30 # 29 # height 16 ->  6

    .word 0, evtResetPowerup

# We will use 4 Paralax layers
#  ---------()- (sky)           %11001000
#  ------------ (Far)           %11000100
#  -----X---X-- (mid)           %11000010       Bank 1
#  []=====[]=== (foreground)    %11000001       Bank 0

  .word 0, evtReprogram_PowerupSprites # Define powerup sprites
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
 # Miner Fish
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireHyper | 16, mveWave | 0b0000, lifeEnemy | 20
  .word    evtSetSprite | sprTwoFrame | MINERFISH
  .word    evtSetObjectSize | 32
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 11
 # Tentitack
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireSlow | 13, mveWave | 0b0000, lifeEnemy | 6
  .word    evtSetSprite | sprTwoFrame | TENTITACK
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 2
 # Tentitack
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireSlow | 13, mveWave | 0b0001, lifeEnemy | 6
  .word    evtSetSprite | sprTwoFrame | TENTITACK
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 3
 # Starfish Bomber
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireMid | 10, mvRegular | spdNormal | 043, lifeEnemy | 7
  .word    evtSetSprite | sprTwoFrame | STARFISH_BOMBER
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 4
 # LiliFrog
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireSlow | 7, mvRegular | spdNormal | 043, lifeEnemy | 5
  .word    evtSetSprite | sprTwoFrame | LILIFROG
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 5
 # SpitFish
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireFast | 17, mvRegular | spdNormal | 043, lifeEnemy | 5
  .word    evtSetSprite | sprTwoFrame | SPITFISH
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 6
 # Bubble
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireSnail | 5, mvRegular | spdNormal | 043, lifeEnemy | 9
  .word    evtSetSprite | sprTwoFrame | BUBBLE24
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 7

 # Bubble Move
  .word 0, evtReprogramCustomMove1, CustomMove1

 # Bubble 2
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgNone, mveCustom1 | 0b0001, lifeCustom
  .word    evtSetSprite | sprTwoFrame | BUBBLE16
  .word    evtSetObjectSize | 16
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 8

 # Bubble Move 2
  .word 0, evtReprogramCustomMove2, CustomMove2

 # Super Fish
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgCustom1, mveCustom3 | 0b0010, lifeCustom
  .word    evtSetSprite | sprTwoFrame | SUPERFISH
  .word    evtSetObjectSize | 32
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 9

 # Super Fish Move
  .word 0, evtReprogramCustomMove3, CustomMove3

  .word 0, evtReprogramCustomProg1, CustomProgram1

 # Pairanah
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgCustom2, mvRegular | spdNormal | 042, lifeEnemy | 20
  .word    evtSetSprite | sprTwoFrame | PAIRANAH
  .word    evtSetObjectSize | 32
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 10

  .word 0, evtReprogramCustomProg2, CustomProgram2

 # Fish Face
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireSnail | 0b01101, mvRegular | spdNormal | 042, lifeEnemy | 30
  .word    evtSetSprite | sprTwoFrame | FISHFACE_LEFT
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 12

 # Fish Bone
  .word 0, evtMultipleCommands | 5
  .word    evtSetProgMoveLife, prgFireSlow | 0b01011, mvRegular | spdNormal | 043, lifeEnemy | 10
  .word    evtSetSprite | sprTwoFrame | FISHBONE_LEFT
  .word    evtSetObjectSize | 24
  .word    evtAddToForeground
  .word    evtSaveObjSettings | 13

 # Background Grass
  .word 0, evtMultipleCommands | 9
  .word    evtLoadObjSettings | 1
  .word    evtSingleSprite, TUFFET, (24+ 70)<<X | (24+16*7 +16)<<Y
  .word    evtSingleSprite, GRASS1, (24+120)<<X | (24+16*7 +16)<<Y
  .word    evtSingleSprite, BUSH,   (24+160)<<X | (24+16*6 + 8+16)<<Y
  .word    evtSingleSprite, ROCK1,  (24+ 20)<<X | (24+16*6 +16+16)<<Y
  .word    evtSetProg, prgNone
  .word    evtSingleSprite, sprTwoFrame | WAVE1, (24+ 50)<<X | (24+16* 9+ 4)<<Y
  .word    evtSingleSprite, sprTwoFrame | WAVE2, (24+100)<<X | (24+16*10+24)<<Y
  .word    evtSingleSprite, sprTwoFrame | WAVE3, (24+150)<<X | (24+16*10+24+8)<<Y
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

   # Spitfish
    .word 10, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 6
    .word     evtSingleSprite | 12 # Row 23, last Column, Last Sprite
   # Wave
    .word 15, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 1
    .word     evtSetProg, prgNone
    .word     evtSingleSprite, sprTwoFrame | WAVE1, (24+160)<<X | (24+16*12)<<Y
   # Lilifrog
    .word 20, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 5
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite
   # Starfish Bomber
    .word 25, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Lilifrog
    .word 30, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 5
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite
   # Starfish Bomber
    .word 35, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Lilifrog
    .word 40, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 5
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite
   # Starfish Bomber
    .word 45, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Lilifrog
    .word 50, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 5
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite
   # Bubble
    .word 50, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 7
    .word     evtSetMove, mveCustom2 | 0b0011
    .word     evtSingleSprite, sprTwoFrame | BUBBLE24, (24+40)<<X | (24+200)<<Y
   # Bubble
    .word 60, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 7
    .word     evtSetMove, mveCustom2 | 0b1001
    .word     evtSingleSprite, sprTwoFrame | BUBBLE24, (24+80)<<X | (24+200)<<Y
   # Bubble
    .word 65, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 8
    .word     evtSetMove, mveCustom1 | 0b1010
    .word     evtSingleSprite, sprTwoFrame | BUBBLE16, (24+60)<<X | (24+200)<<Y
   # Bubble
    .word 70, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 7
    .word     evtSetMove, mveCustom2 | 0b0001
    .word     evtSingleSprite, sprTwoFrame | BUBBLE16, (24+120)<<X | (24+200)<<Y
   # Powerup Rate
    .word 70, evtMultipleCommands | 4
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), lifeDeadly | 63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+ 10)<<Y
    .word     evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+ 90)<<Y
    .word     evtSingleSprite, sprTwoFrame | POWERUP_RATE, (24+160)<<X | (24+170)<<Y
   # Super Fish
    .word 75, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 9
    .word     evtSetMove, mveCustom3 | 0b1111
    .word     evtSingleSprite, sprTwoFrame | SUPERFISH, (24+80)<<X | (24+190)<<Y
   # Bubble
    .word 80, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 8
    .word     evtSetMove, mveCustom1 | 0b0010
    .word     evtSingleSprite, sprTwoFrame | BUBBLE16, (24+130)<<X | (24+200)<<Y
   # Bubble
    .word 80, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 7
    .word     evtSetMove, mveCustom2 | 0b0100
    .word     evtSingleSprite, sprTwoFrame | BUBBLE24, (24+ 30)<<X | (24+200)<<Y
   # Super Fish
    .word 90, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 9
    .word     evtSetMove, mveCustom3 | 0b1110
    .word     evtSingleSprite, sprTwoFrame | SUPERFISH, (24+ 60)<<X | (24+190)<<Y
   # Starfish Bomber
    .word 95, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Super Fish
    .word 100, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 9
    .word     evtSetMove, mveCustom3 | 0b1101
    .word     evtSingleSprite, sprTwoFrame | SUPERFISH, (24+120)<<X | (24+190)<<Y
   # Super Fish
    .word 110, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 9
    .word     evtSetMove, mveCustom3 | 0b1100
    .word     evtSingleSprite, sprTwoFrame | SUPERFISH, (24+120)<<X | (24+190)<<Y
   # Lilifrog
    .word 115, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite
   # Powerup Drone
    .word 120, evtMultipleCommands | 3
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 046), lifeDeadly | 63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+0)<<X | (24+ 50)<<Y
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE, (24+0)<<X | (24+150)<<Y
   # Super Fish
    .word 120, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 9
    .word     evtSetMove, mveCustom3 | 0b1011
    .word     evtSingleSprite, sprTwoFrame | SUPERFISH, (24+120)<<X | (24+190)<<Y
   # Starfish Bomber
    .word 125, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 3 # Row 5, last Column, Last Sprite
   # Super Fish
    .word 130, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 9
    .word     evtSetMove, mveCustom3 | 0b1100
    .word     evtSingleSprite, sprTwoFrame | SUPERFISH, (24+60)<<X | (24+190)<<Y
   # Lilifrog
    .word 135, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # Bubble 16
    .word 145, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1001
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+20)<<X | (24+200)<<Y
   # Bubble 24
    .word 150, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b0001
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+150)<<X | (24+200)<<Y
   # Bubble 16
    .word 155, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b0110
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+145)<<X | (24+200)<<Y
   # Bubble 24
    .word 160, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b0010
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+145)<<X | (24+200)<<Y
   # Bubble 16
    .word 165, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b0111
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+30)<<X | (24+200)<<Y
   # Bubble 24
    .word 160, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b0011
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+140)<<X | (24+200)<<Y
   # Bubble 16
    .word 175, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1000
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+35)<<X | (24+200)<<Y
   # Bubble 24
    .word 180, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b0100
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+135)<<X | (24+200)<<Y
   # Bubble 16
    .word 185, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1001
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+140)<<X | (24+200)<<Y

UnderwaterPart:

    .word 185, evtSetLevelSpeed, 0b00000010
    .word 185, evtCallAddress, BlackoutOn

    .word 185, evtCallAddress, CallBounce, Blackout5
    .word 186, evtCallAddress, CallBounce, Blackout4
    .word 187, evtCallAddress, CallBounce, Blackout3
    .word 187, evtCallAddress, setPaletteSink, PlusSink1
  # .word 188 set palette
    .word 188, evtCallAddress, CallBounce, Blackout2
    .word 188, evtCallAddress, setPaletteSink, PlusSink2
  # .word 189 set palette
    .word 189, evtCallAddress, CallBounce, Blackout1
    .word 189, evtCallAddress, setPaletteSink, PlusSink3
  # .word 190 set palette
    .word 189, evtCallAddress, setPaletteSink, PlusSink4
  # .word 191 set palette
    .word 191, evtCallAddress, setPaletteSink, PlusSink5
    .word 192, evtCallAddress, setPaletteUnderwater
  # .word 192 set palette
    .word 193, evtCallAddress, CallBounce, SetUnderwater
    .word 193, evtCallAddress, CallBounce, Blackout2

   # CoralAndWeeds 18-21
    .word 193, evtMultipleCommands | 6
    .word      evtLoadObjSettings | 1
    .word      evtSetProg, prgNone
    .word      evtSingleSprite, sprTwoFrame | WEED1,  (24+ 40)<<X | (24+199-24)<<Y
    .word      evtSingleSprite, sprTwoFrame | CORAL1, (24+160)<<X | (24+190-24)<<Y
    .word      evtSingleSprite, sprTwoFrame | WEED2,  (24+ 80)<<X | (24+185-24)<<Y
    .word      evtSingleSprite, sprTwoFrame | CORAL2, (24+120)<<X | (24+195-24)<<Y
   # Powerup Power
    .word 193, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 046), lifeDeadly | 63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_POWER, (24+0)<<X | (24+100)<<Y

    .word 194, evtCallAddress, CallBounce, Blackout3
    .word 195, evtCallAddress, CallBounce, Blackout4
    .word 196, evtCallAddress, CallBounce, Blackout5
    .word 197, evtCallAddress, BlackoutOff
    .word 197, evtSetLevelSpeed, 0b00000100

   # Miner Fish
    .word 197, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 11
    .word      evtSingleSprite, sprTwoFrame | MINERFISH, (24+160-16)<<X | (24+100)<<Y
   # Bubble 24
    .word 200, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b1100
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+50)<<X | (24+200)<<Y
   # Bubble 16
    .word 200, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1011
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+120)<<X | (24+200)<<Y
   # Miner Fish
    .word 205, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 11
    .word      evtSingleSprite, sprTwoFrame | MINERFISH, (24+160-16)<<X | (24+100)<<Y
   # Bubble 24
    .word 210, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b1100
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+130)<<X | (24+200)<<Y
   # Bubble 16
    .word 210, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1101
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+120)<<X | (24+200)<<Y
   # Bubble 24
    .word 215, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b1110
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+70)<<X | (24+200)<<Y
   # Bubble 16
    .word 215, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1111
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+120)<<X | (24+200)<<Y
   # Bubble 24
    .word 220, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b0001
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+120)<<X | (24+200)<<Y
   # Bubble 16
    .word 225, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b1101
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+80)<<X | (24+200)<<Y
   # Pairanah
    .word 230, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 10
    .word      evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Bubble 24
    .word 230, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 7
    .word      evtSetMove, mveCustom2 | 0b0011
    .word      evtSingleSprite, sprTwoFrame | BUBBLE24, (24+90)<<X | (24+200)<<Y
   # Bubble 16
    .word 235, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 8
    .word      evtSetMove, mveCustom1 | 0b0100
    .word      evtSingleSprite, sprTwoFrame | BUBBLE16, (24+110)<<X | (24+200)<<Y
   # Miner Fish
    .word 250, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 11
    .word      evtSingleSprite, sprTwoFrame | MINERFISH, (24+160-16)<<X | (24+100)<<Y
   # Coral and weeds
    .word 250, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 1
    .word      evtSetProg, 0
    .word      evtSingleSprite, sprTwoFrame | WEED1, (24+160)<<X | (24+190-24)<<Y
   # Starfish Bomber
    .word 255+5, evtMultipleCommands | 3
    .word        evtLoadObjSettings | 4
    .word        evtSetMove, mvRegular | spdNormal | 045
    .word        evtSingleSprite, sprTwoFrame | STARFISH_BOMBER, (24)<<X | (24+8)<<Y
   # Pairanah
    .word 255+20, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # FishFace
    .word 255+25, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 12
    .word      evtSetMove, mvRegular | spdNormal | 046
    .word      evtSingleSprite, sprTwoFrame | FISHFACE_RIGHT, (24)<<X | (24+80)<<Y
   # Miner Fish
    .word 255+30, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 11
    .word         evtSingleSprite, sprTwoFrame | MINERFISH, (24+160-16)<<X | (24+100)<<Y
   # Pairanah
    .word 255+35, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 6 # Row 11, last Column, Last Sprite
   # Coral and weeds
    .word 255+35, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 1
    .word         evtSetProg, 0
    .word         evtSingleSprite, sprTwoFrame | CORAL1, (24+160)<<X | (24+195-24)<<Y
   # Starfish Bomber
    .word 255+35, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 4
    .word         evtSetMove, mvRegular | spdNormal | 045
    .word         evtSingleSprite, sprTwoFrame | STARFISH_BOMBER, (24)<<X | (24+8)<<Y
   # Pairanah
    .word 255+40, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 9 # Row 17, last Column, Last Sprite
   # Pairanah
    .word 255+45, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Pairanah
    .word 255+50, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 6 # Row 11, last Column, Last Sprite
   # Pairanah
    .word 255+55, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 9 # Row 17, last Column, Last Sprite
   # Miner Fish
    .word 255+60, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 11
    .word         evtSingleSprite, sprTwoFrame | MINERFISH, (24+160-16)<<X | (24+100)<<Y
   # Miner Fish
    .word 255+70, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 11
    .word         evtSingleSprite, sprTwoFrame | MINERFISH, (24+160-16)<<X | (24+100)<<Y
   # FishFace
    .word 255+75, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 12
    .word         evtSetMove, mvRegular | spdNormal | 046
    .word         evtSingleSprite, sprTwoFrame | FISHFACE_RIGHT, (24)<<X | (24+80)<<Y
   # FishFace
    .word 255+75, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 12
    .word         evtSetMove, mvRegular | spdNormal | 046
    .word         evtSingleSprite, sprTwoFrame | FISHFACE_RIGHT, (24)<<X | (24+100)<<Y
   # Coral and weeds
    .word 255+75, evtMultipleCommands | 3
    .word         evtLoadObjSettings | 1
    .word         evtSetProg, 0
    .word         evtSingleSprite, sprTwoFrame | CORAL1, (24+160)<<X | (24+199-24)<<Y
   # Pairanah
    .word 255+80, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 5 # Row 9, last Column, Last Sprite
   # Pairanah
    .word 255+85, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Pairanah
    .word 255+90, evtMultipleCommands | 2
    .word         evtLoadObjSettings | 10
    .word         evtSingleSprite | 9 # Row 17, last Column, Last Sprite
   # Super Fish
    .word 255+100, evtMultipleCommands | 3
    .word          evtLoadObjSettings | 9
    .word          evtSetMove, mveCustom3 | 0b1010
    .word          evtSingleSprite, sprTwoFrame | SUPERFISH, (24+60)<<X | (24+190)<<Y
   # Pairanah
    .word 255+100, evtMultipleCommands | 2
    .word          evtLoadObjSettings | 10
    .word          evtSingleSprite | 7 # Row 13, last Column, Last Sprite
   # Coral and weeds
    .word 255+100, evtMultipleCommands | 3
    .word          evtLoadObjSettings | 1
    .word          evtSetProg, 0
    .word          evtSingleSprite, sprTwoFrame | WEED1, (24+160)<<X | (24+195-24)<<Y
   # Fish Bone
    .word 255+110, evtMultipleCommands | 4
    .word          evtLoadObjSettings | 13
    .word          evtSingleSprite, sprTwoFrame | FISHBONE_LEFT, (24+160)<<X | (24+16*1)<<Y
    .word          evtSingleSprite | 7 # Row 13, last Column, Last Sprite
    .word          evtSingleSprite | 11 # Row 21, last Column, Last Sprite
   # Fish Bone
    .word 255+110, evtMultipleCommands | 5
    .word          evtLoadObjSettings | 11
    .word          evtSetMove, mvRegular | spdNormal | 45
    .word          evtSetProg, prgFireSlow | 0b01100
    .word          evtSingleSprite, sprTwoFrame | FISHBONE_RIGHT, (24)<<X | (24+16*0)<<Y
    .word          evtSingleSprite, sprTwoFrame | FISHBONE_RIGHT, (24)<<X | (24+16*0)<<Y
   # Fish Bone
    .word 255+120, evtMultipleCommands | 3
    .word          evtLoadObjSettings | 13
    .word          evtSingleSprite | 5 # Row 9, last Column, Last Sprite
    .word          evtSingleSprite | 9 # Row 17, last Column, Last Sprite
   # Fish Bone
    .word 255+120, evtMultipleCommands | 5
    .word          evtLoadObjSettings | 11
    .word          evtSetMove, mvRegular | spdNormal | 45
    .word          evtSetProg, prgFireSlow | 0b01100
    .word          evtSingleSprite, sprTwoFrame | FISHBONE_RIGHT, (24)<<X | (24+16* 4)<<Y
    .word          evtSingleSprite, sprTwoFrame | FISHBONE_RIGHT, (24)<<X | (24+16*10)<<Y

LevelEndAnim:
    .word 255+150, evtMultipleCommands | 2
    .word          evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word          evtSingleSprite, sprTwoFrame | DUMMY_SPRITE, (24+140)<<X | (24+100)<<Y
    .word 255+150, evtCallAddress, Player_Handler_DoSmartBomb
# Start of fade out block ------------------------------------------------------
    .equiv FadeOutStartPoint, 255+152
    .word FadeOutStartPoint + 1, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 2, evtSetPalette, BluePalette

    .word 255+156, evtCallAddress, EndLevel
    .even
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
#:bpt
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

        CALL @$ScreenBuffer.Flip

        BR   LevelLoop
#-------------------------------------------------------------------------------
# Generic Background Begin -----------------------------------------------------
Background_Draw:
        MOV  $0,R0 # 0=left
        CALL @$Background_GradientScroll

        MOV  @$ScreenBuffer.ActiveScreen,R5

        CALL @$Timer.UpdateTimer # R0 = SmartBomb color or 0
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

        MOV  $16,R1
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $24,R1
        CALL @$Background_SolidFill

        MOV  $8,R1
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $16,R1
        CALL @$Background_SolidFill

        MOV  $GradientBottom,R3 # 32 lines
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
GradientTop:                                                    #
   .word 0x00FF, 0x00FF                # 1st line               # defb &0F,&0F    ; 1 first line
   .word GradientTopStart - 10, 0x00DD # 2nd line num, new word # defb GradientTopStart-10,&D0 ;2; line num, New byte
   .word GradientTopStart - 16, 0x0077                          # defb GradientTopStart-16,&70 ;3
   .word GradientTopStart - 20, 0x00AA                          # defb GradientTopStart-20,&A0 ;4
   .word GradientTopStart - 26, 0x0055                          # defb GradientTopStart-26,&50 ;5
   .word GradientTopStart - 30, 0x0088                          # defb GradientTopStart-30,&80 ;6
   .word GradientTopStart - 36, 0x0022                          # defb GradientTopStart-36,&20 ;7
   .word GradientTopStart - 40, 0x0000                          # defb GradientTopStart-40,&00 ;7
   .word GradientTopStart - 46, 0x0000                          # defb GradientTopStart-46,&00 ;7
   .word 0xFFFF                                                 # defb 255

   .equiv GradientTopStartB, 32 # lines count                   #
GradientTop32:
   .word 0xFF00, 0xFF00                 # 1st line              # defb &F0,&F0    ; 1 first line
   .word GradientTopStartB - 00, 0x00DD # 2nd line num, new word# defb GradientTopStartB-00,&D0 ;2; line num, New byte
   .word GradientTopStartB - 06, 0x0077                         # defb GradientTopStartB-06,&70 ;3
   .word GradientTopStartB - 10, 0x00AA                         # defb GradientTopStartB-10,&A0 ;4
   .word GradientTopStartB - 16, 0x0055                         # defb GradientTopStartB-16,&50 ;5
   .word GradientTopStartB - 20, 0x0088                         # defb GradientTopStartB-20,&80 ;6
   .word GradientTopStartB - 26, 0x0022                         # defb GradientTopStartB-26,&20 ;7
   .word GradientTopStartB - 28, 0x0000                         # defb GradientTopStartB-28,&00 ;8
   .word GradientTopStartB - 30, 0x0000                         # defb GradientTopStartB-30,&00 ;9
   .word 0xFFFF                                                 # defb 255

   .equiv GradientBottomStart, 32 # lines count
GradientBottom:                                                 #
   .word 0x0000, 0x0000 # 1st line                              # defb &0,&0  ; 1 first line
   .word 30, 0x0022     # 2nd line num, new word                # defb 30,&20 ;10
   .word 26, 0x0088                                             # defb 26,&80 ;11
   .word 20, 0x0055                                             # defb 20,&50 ;12
   .word 18, 0x00AA                                             # defb 18,&A0 ;13
   .word 14, 0x0077                                             # defb 14,&70 ;14
   .word 10, 0x00DD                                             # defb 10,&D0 ;15
   .word  4, 0x00FF                                             # defb 4,&F0  ;15
   .word  2, 0x00FF                                             # defb 2,&F0  ;15
   .word 0xFFFF                                                 # defb 255
#---------------------------------------------------------------#
#      # in:  R1 C = Y
#      #      R2 LSB D = move,
#      #      R2 MSB iyh = sprite
#      #      R3 LSB ixl = Life,
#      #      R3 MSB iyl = Program Code
#      #      R4 B = X
#      #
#      # out: R1 new Y
#      #      R2 unmodified
#      #      R3 LSB unmodified
#      #      R3 MSB updated program code
#      #      R4 new X
#      #      R5 unmodified
#CustomMove.Bouncer:
#        MOV  $190,R1                   # ld c,190
#        PUSH R5                        # push hl
#                                       #     ; B=X C=Y D=Move
#                                       #     ld a,b
#        CMP  R4,$24+160                #     cp 184
#        BNE  1$                        #     call z,CustomMove.Bouncer_Init
#        DEC  R4
#    1$:                                #     call Akuyou_Timer.GetTimer
#                                       #     ld h,a
#
#                                       #     ;shift the time
#                                       #     ldai
#                                       #     ld l,a
#
#        MOV  R2,R0                     #     ld a,d
#        BIC  $0xFFF0,R0                #     and %00001111
#        ADD  @$Timer.CurrentTick,R0    #     add a,l
#        MOV  R0,R5                     #     ldia
#
#        BITB $0x20,R0                  #     bit 5,a
#        BZE  CustomMove.Bouncer.Vert   #     jr z,CustomMove.Bouncer_Vert
#
#        DEC  R4                        #     dec b
#        BIC  $0xFF00,R3                #     ld iyl,0 ; Program - do nothing
#        BR   CustomMove.Bouncer.Done   #     jr CustomMove.Bouncer_Done
#CustomMove.Bouncer.Vert:
#                                       #     ;0000D111
#        BITB $0x10,R0                  #     bit 4,a
#        BZE  CustomMove.Bouncer.DoJump  #     jr z,CustomMove.Bouncer_DoJump
#
#        PUSH R0
#        MOV  $0x0F,R0
#        XOR  R0,(SP)                   #     xor %00001111
#        POP  R0
#        BR   CustomMove.Bouncer.DoJump  #     jr CustomMove.Bouncer_DoJump
#
#CustomMove.Bouncer.DoJump:
#        BIC  $0xFFF0,R0                #     and %00001111
#        ASL  R0                        #     rlca
#        ASL  R0                        #     rlca
#        ASL  R0                        #     rlca
#        COM  R0                        #     cpl
#        INC  R0                        #     inc a
#        ADD  R0,R1                     #     add c
#                                       #     ld c,a
#
#        MOV  R5,R0                     #     ldai
#        BIC  $0xFFE0,R0                #     and %00011111
#        CMPB R0,$0b00001110            #     cp  %00001110
#        BNE  CustomMove.Bouncer.FireNormal #     jp nz,CustomMove.Bouncer_FireNormal
#      # R3 MSB iyl = Program Code
#        BIC  $0xFF00,R3
#        BIS  $(prgFireFast|13)<<8,R3   #     ld iyl,prgFireFast+13 ; Program Fire
#        BR   CustomMove.Bouncer.DoSprite#     jp CustomMove.Bouncer_DoSprite
#
#CustomMove.Bouncer.FireNormal:
#        BIC  $0xFF00,R3
#        BIS  $(prgFireFast|16)<<8,R3   #     ld iyl,prgFireFast+16 ; Program Fire
#
#CustomMove.Bouncer.DoSprite:
#                                       #     ld a,h
#        BIT  $0x02,@$Timer.TicksOccured#     bit 1,a
#        BZE  CustomMove.Bouncer.Done    #     jp z,CustomMove.Bouncer_Done
#
#        MOV  @$SpriteBanksVectors+4,@$SprShow_BankAddr # call Akuyou_ObjectProgram_SpriteBankSwitch
#CustomMove.Bouncer.Done:
#        POP  R5                        # pop hl
#        RETURN                         # ret
#
#                                       # CustomMove.Bouncer_Init:
#                                       #        dec b
#                                       # ret
#
#CustomMove3:
#        MOV  $CustomMovePatternGeneric, @$dstCustomMovePatternA # ld hl,CustomMovePatternGeneric
#        MOV  $CustomMovePatternMiniWave,@$dstCustomMovePatternB # ld de,CustomMovePatternMiniWave
#        MOV  $CustomMovePattern_Init10, @$dstCustomMovePattern_Init # ld bc,CustomMovePattern_Init10
#        BR   CustomMovePattern         #   jr CustomMovePattern
#
#      # R4=B=X, R1=C=Y, R2: LSB=D=move, MSB=anything
#CustomMovePatternMiniWave:
#      # WaveSmall pattern  1010SPPP  S= Speed, PPP Position
#        MOV  R4,R1                     #        ld a,b
#        ASR  R1                        #        srl a ; rem for speedup
#        ASR  R1                        #        srl a ; rem for speedup
#        BIC  $0xFFE0,R1                #        and %00011111
#        CMP  R1,$0x10                  #        cp  %00010000
#        BLO  DoMoves_WaveSmallContinue #        jr C,DoMoves_WaveSmallContinue
#        MOV  $0x1F,R0
#        XOR  R0,R1                     #        xor %00011111
#DoMoves_WaveSmallContinue:
#        MOV  R2,R0                     #        ld C,a
#        MOV  $0x03,R0                  #        ld a,%00000011
## DoMoves_WaveEnd
#        ASH  $5,R0                     #        rrca
#                                       #        rrca
#                                       #        rrca    ; equivalent to 5 left shifts
#        BIS  $0b00011100,R0            #        or %00011100
#        ADD  R0,R1                     #        add C
#                                       #        ld C,a
#
#        DEC  R4                        #        ld a,B
#                                       #        sub 1
#                                       #        ld B,A
#        CMP  R4,$16                    #        cp 24   ; we are at the edge of the screen
#        BLO  CustomMovePatternKill     #        jp C,CustomMovePatternKill ; over the page
#        RETURN                         #        ret
#
#GetCustomRam:
#        BIC  $0xFFF0,R5                # and %00001111
#                                       # ld hl,CustomRam
#                                       #   ld d,0
#                                       #   ld e,a
#        ASL  R5                        #   add hl,de
#        ASL  R5                        #   add hl,de
#        ADD  $CustomRam,R5             #   add hl,de
#                                       #   add hl,de
#                                       # push hl
#                                       # pop ix
#        RETURN                         # ret
#
#CustomRam:
#       .space 128
#
#      # in:  R1 C = Y
#      #      R2 LSB D = move, R2 MSB = sprite
#      #      R3 LSB ixl = Life, R3 MSB iyl = Program Code
#      #      R4 B = X
#      #
#      # out: R1 new Y
#      #      R2 LSB unmodified, MSB sprite
#      #      R3 LSB life, MSB unmodified
#      #      R4 new X
#      #      R5 unmodified
#CustomMovePattern: # B=X C=Y D=Move
#        MOVB R3,@$CustomMove_LifeCustom # ld a,ixl        ;lifCustom
#        PUSH R5                        # ex af,af'
#        MOVB R2,R5                     # ld a,d
#                                       # exx
#                                       # push ix
#        CALL GetCustomRam              #         call GetCustomRam
#                                       #         call Akuyou_ Timer.GetTimer
#                                       #         ld d,a ; Timer.TicksOccured
#                                       #         ldai    ; Level time
#                                       #         ld e,a ; Timer.CurrentTick
#
#                                       #        ;dont update more than once per tick!
#                                       #         ld a,(ix+1)
#        CMPB 1(R5),@$Timer.CurrentTick #         cp e
#        BEQ  CustomMovePattern_NoTick  #         jr z,CustomMovePattern_NoTick
#                                       #         ld a,e
#        MOVB @$Timer.CurrentTick,1(R5) #         ld (ix+1),e
#
#                                       #        ;see if this is our first run
#                                       #         ex af,af'
#        CMPB R3,$0xFF                  #         cp 255
#        BLO  CustomMove_DoMove
#
#      # not used
#       .equiv dstCustomMovePattern_Init, .+2
#        CALL @$CustomMovePattern_Init  #         call nc,CustomMovePattern_Init :CustomMovePattern_Init_Plus2
#                                       #         ex af,af'
#
#                                       #        ;here is where we make some moves!
#                                       #         exx
#CustomMove_DoMove:
#       .equiv dstCustomMovePatternA, .+2
#        CALL @$CustomMovePatternGeneric#         call CustomMovePatternGeneric :CustomPatternJump_Plus2
#                                       #         exx
#                                       #        ;increment the pos
#CustomMovePattern_NoTick:
#                                       #        ; here is where we make some moves!
#                                       #        exx
#       .equiv dstCustomMovePatternB, .+2
#        CALL @$CustomMovePatternMiniWave #        call null :CustomPatternBJump_Plus2
#
#                                       #        ld a,b
#        CMP  R4,$24+160                #        cp 160+24
#        BLO  CustomMovePattern_Done    #        call NC,CustomMovePatternKill
#        CALL CustomMovePatternKill
#                                       #        exx
#                                       #        ;increment the pos
#CustomMovePattern_Done:
#      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
#        MOV  R3,R0                           # ld a,iyl
#        CLRB R0
#        CMP  R0,$prgSpecial<<8               # cp prgSpecial
#        BNE  CustomMovePattern_NotBossTarget # jr nz,CustomMovePattern_NotBossTarget
#
#      # not used
#       .equiv TargetSpriteCountdown, .+2     # ld a,0:TargetSpritecountdown_Plus1
#        TST  $0                              # or a
#        BZE  CustomMovePattern_TargetReset   # jr z,CustomMovePattern_TargetReset
#
#        DEC  @$TargetSpriteCountdown         # dec a
#                                             # ld (TargetSpritecountdown_Plus1-1),a
## CustomMovePattern_TargetSet:
#      # R2 LSB D = move, R2 MSB = sprite
#        SWAB R2
#        CLRB R2
#       .equiv HitTargetSprite, .+2
#        BISB $sprTwoFrame|9,R2               # ld a,128+9      :HitTargetSprite_Plus1
#        SWAB R2                              # ld iyh,a
#        BR   CustomMovePattern_NotBossTarget # jr CustomMovePattern_NotBossTarget
#
#      # not used
#CustomMovePattern_TargetReset:
#        SWAB R2
#        CLRB R2
#       .equiv ResetTargetSprite, .+2
#        BISB $sprTwoFrame|8,R2               # ld a,128+8      :ResetTargetSprite_Plus1
#        SWAB R2                              # ld iyh,a
#CustomMovePattern_NotBossTarget:
#        POP  R5                        #        pop ix
#                                       #        exx
#                                       #        ex af,af'
#      # R3 LSB ixl = Life, R3 MSB iyl = Program Code
#        CLRB R3
#       .equiv CustomMove_LifeCustom, .+2
#        BISB $0,R3                     #        ld ixl,a        ;lifCustom
#                                       # ei
#        RETURN                         # ret
#
#CustomMovePatternKill:
#        CLR  R4 #        ld b,0
#        CLR  R1 #        ld c,b
#        CLRB R2 #        ld D,b
#        RETURN  # ret
#
#      # not used
#CustomMovePattern_Init10:
#        CALL CustomMovePattern_Init    # call CustomMovePattern_Init
#        MOV  $lifeEnemy|10,@$CustomMove_LifeCustom # ld a,lifEnemy+10 ;New Life
#        RETURN                         # ret
#
#      # not used
#CustomMovePattern_Init:
#        PUSH R5                        #        xor a
#        CLRB (R5)+                     #        ld (ix+0),a
#        CLRB (R5)+                     #        ld (ix+1),a
#        CLRB (R5)+                     #        ld (ix+2),a
#        CLRB (R5)+                     #        ld (ix+3),a
#        POP  R5
#        MOV  $lifeEnemy|6,@$CustomMove_LifeCustom # ld a,lifEnemy+6 ;New Life
#        RETURN                         # ret
#
#CustomMovePatternGeneric:
#        INCB (R5)                      #        ld a,(ix+0)
#                                       #        inc a
#                                       #        ld (ix+0),a
#        RETURN                         # ret

CustomMove1:
CustomMove2:
CustomMove3:
CustomProgram1:
CustomProgram2:
Blackout1:
Blackout2:
Blackout3:
Blackout4:
Blackout5:
PlusSink1:
PlusSink2:
PlusSink3:
PlusSink4:
PlusSink5:
CallBounce:
setPaletteSink:
BlackoutOn:
BlackoutOff:
setPaletteUnderwater:
SetUnderwater:
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
    .byte   1, setColors, Black, brMagenta, brYellow, White
    .byte  28, setColors, Black, Magenta, brYellow, White
    .byte  80, setColors, Black, Red,     brGreen, White
    .byte 120, setColors, Black, brBlue, brCyan, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
end:
