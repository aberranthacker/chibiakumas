               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level01SizeWords, (end - start) >> 1
               .global Level01SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

LevelSprites.0:
       .incbin "build/level_01.0.spr"
LevelSprites.1:
       .incbin "build/level_01.1.spr"
ChibiSprites:
       .incbin "build/chibi_lr.spr"
LevelTiles:
       .incbin "build/level_01_tiles.spr"

EventStreamArray_Ep1: #----------------------------------------------------------{{{
   # We will use 4 Paralax layers
   # ---------()- (sky)        %11001000
   # ------------ (Far)        %11000100
   # -----X---X-- (mid)        %11000010   Bank 1
   # []=====[]=== (foreground) %11000001   Bank 0

.equiv DUMMY_SPRITE, 0

.equiv COIN, 1
.equiv POWERUP_DRONE, 2
.equiv POWERUP_RATE, 3
.equiv POWERUP_POWER, 4 # not used on this level

.equiv BOULDER, 5
.equiv BOULDER_SMALL, 6
.equiv BURNING_BLOKE, 7
.equiv CASTLE, 8
.equiv CLOUD_A, 9
.equiv CLOUD_B, 10
.equiv CLOUD_C, 11
.equiv CROSS, 12
.equiv CROSS_CRUCIFIED_BLOKE, 13
.equiv CROSS_IMPALED_BLOKE, 14
.equiv GRAVECROSS, 15
.equiv GRAVESTONE, 16
.equiv MOON, 17
.equiv ROCK_PT1, 18
.equiv ROCK_PT2, 19
.equiv ROCK_PT3, 20
.equiv SPIKEY_ROCK_A, 21
.equiv SPIKEY_ROCK_B, 22
.equiv SPIKEY_ROCK_C, 23

.equiv ANT_ATTACKER, 24
.equiv BONI_BURD, 25
.equiv EYE_CLOPSE, 26
.equiv ROCK_CHICK, 27
.equiv SKELETON_CRAWLER, 28
.equiv SKULL_BOMBER, 29
.equiv SKULL_GANG, 30
.equiv SPLICE_FACE, 31

    .word 0, evtReprogram_PowerupSprites  # Define powerup sprites
    .byte      sprTwoFrame | POWERUP_DRONE
    .byte      sprTwoFrame | POWERUP_RATE
    .byte      sprTwoFrame | POWERUP_POWER
    .byte      sprTwoFrame | COIN

    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0b0001
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 0           # 5

    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0b0010
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 1           # 5

   # Rock Chick
    .word 0, evtMultipleCommands | 5
    .word    evtSetProgMoveLife               # 1
    .word        prgFireSlow | fireLeftWide
    .word        mvRegular | spdNormal | 042 # move - direction left, slow
    .word        lifeEnemy | 1
    .word    evtSetSprite | sprTwoFrame | ROCK_CHICK   # 2
    .word    evtSetAnimator | anmNone         # 3
    .word    evtAddToForeground               # 4
    .word    evtSaveObjSettings | 2           # 5

   # Skull bomber
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireFast | fireSingleSouth
    .word         mvRegular | spdNormal | 043 # move - direction left, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | sprTwoFrame | SKULL_BOMBER  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 3           # 5

   # Ant Attacker
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireTopLeft
    .word         mvRegular | spdNormal | 043 # move - direction left, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | sprTwoFrame | ANT_ATTACKER   # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 4           # 5

   # Skeleton Crawler
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireLeftWide
    .word         mvRegular | spdNormal | 042 # move - direction left, slow
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | SKELETON_CRAWLER  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 5           # 5

   # SpliceFace
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireBurst
    .word         mvRegular | spdNormal | 045 # move - direction right, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | sprTwoFrame | SPLICE_FACE  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 6           # 5

   # BoniBurd
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireBottomLeft
    .word         mvRegular | spdNormal | 042 # move - direction left, slow
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | BONI_BURD   # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 7           # 5

   # Skull Gang
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireFast | fireSingleWest
    .word         mveWave | 0b0001
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | SKULL_GANG  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 8           # 5

  # Eyeclopse
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireLeftWide
    .word         mveWave | 0b1100
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | EYE_CLOPSE   # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 9           # 5
#-------------------------------------------------------------------------------
   #.word 0, evtAddToBackground
   #.word 0, evtSetProgMoveLife, prgBitShift, mveBackground | 0b0001, lifeImmortal

   # Moon
    .word 0, evtMultipleCommands | 3
    .word    evtLoadObjSettings | 0
    .word    evtSetMove, mveBackground | 0b1000
    .word    evtSingleSprite, sprSingleFrame | MOON
    .byte        24+ 8, 24+ 160 -16 # Y, X :  32, 172 : 8, 288

   # Castle
    .word 0, evtSetMove, mveBackground | 0b0010
    .word 0, evtSingleSprite, sprSingleFrame | CASTLE
    .byte        24+ 50,    24+ 120  # Y, X :  74, 144 :  50, 240
   # some boulders
    .word 0, evtSingleSprite, sprSingleFrame | BOULDER_SMALL
    .byte        24+ 40+90, 24+ 100  # Y, X : 154, 124 : 130, 200
    .word 0, evtSingleSprite, sprSingleFrame | BOULDER
    .byte        24+ 40+100, 24+ 90  # Y, X : 164, 114 : 140, 180
    .word 0, evtSingleSprite, sprSingleFrame | BOULDER
    .byte        24+ 40+100, 24+ 162 # Y, X : 164, 184 : 140, 324

   # Burning bloke
    .word 0, evtMultipleCommands | 2
    .word    evtSetProgMoveLife, prgNone, mveBackground | 0b0010, lifeImmortal
    .word    evtSingleSprite, sprTwoFrame | BURNING_BLOKE
    .byte        24+ 90, 24+ 50 # Y, X : 114, 74 : 90, 100

   # Clouds (3 wide)
    .word 0, evtMultipleCommands | 4
    .word      evtSetProgMoveLife, prgBitShift, mveBackground | 0b0100, lifeImmortal
    .word    evtSingleSprite, sprSingleFrame | CLOUD_A
    .byte        24+ 21, 24+ 159
    .word    evtSingleSprite, sprSingleFrame | CLOUD_B
    .byte        24+ 21, 24+ 159+12
    .word    evtSingleSprite, sprSingleFrame | CLOUD_C
    .byte        24+ 21, 24+ 159+24

   # Spikeyrock
    .word 0, evtMultipleCommands | 3
    .word    evtSetMove, mveBackground | 0b0001
# defb    48+2, 24+100, 24+24+128, 24, 8, 9 ; Two sprites,
    .word    evtSingleSprite, sprSingleFrame | SPIKEY_ROCK_A
    .byte        24+ 24+128, 24+ 100
    .word    evtSingleSprite, sprSingleFrame | SPIKEY_ROCK_B
    .byte        24+ 48+128, 24+ 100

# Start of fade in block -------------------------------------------------------
    .equiv FadeStartPoint, 0
    .word FadeStartPoint + 1, evtSetPalette, BluePalette
    .word FadeStartPoint + 2, evtSetPalette, DarkRealPalette
    .word FadeStartPoint + 3, evtSetPalette, RealPalette
# End of fade in block ---------------------------------------------------------

   # rock chick enemy
    .word 5, evtMultipleCommands | 2
    .word    evtLoadObjSettings | 2
    .word    evtSingleSprite | 8 # Row 15, last Column, Last Sprite

    #----------
   #.word 5, evtChangeStreamTime, 256+ 5, LevelEndAnim
    #----------

   # Rock Pt 1
    .word 10, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | ROCK_PT1
    .byte         24+ 176, 24+ 160

   # Cross, impaled bloke
    .word 13, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 1
    .word     evtSingleSprite, sprSingleFrame | CROSS_IMPALED_BLOKE
    .byte         24+ 110, 24+ 160

   # rock chick enemy
    .word 15, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # Rock Pt 2
    .word 16, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | ROCK_PT2
    .byte         24+ 176, 24+ 160

   # Powerup Rate
    .word 17, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_RATE
    .byte         24+ 50, 24+ 160

   # Rock Pt 3
    .word 22, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | ROCK_PT3
    .byte         24+ 176, 24+ 160

   # rock chick enemy
    .word 25, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # rock chick enemy
    .word 30, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # rock chick enemy
    .word 35, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # Cross, crucifix
    .word 40, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 1
    .word     evtSingleSprite, sprSingleFrame | CROSS_CRUCIFIED_BLOKE
    .byte         24+ 89, 24+ 160

   # Skull Bomber
    .word 45, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 3
    .word     evtSingleSprite | 3  # Row 5, last Column, Last Sprite
   # Ant
    .word 45, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 4
    .word     evtSingleSprite | 12  # Row 23, last Column, Last Sprite

   # Burning bloke
    .word 55, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 1
    .word     evtSetProg, prgNone
    .word     evtSingleSprite, sprTwoFrame | BURNING_BLOKE
    .byte         24+ 85, 24+ 160

   # Boniburd
    .word 65, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 7
    .word     evtSingleSprite, sprTwoFrame | BONI_BURD
    .byte         24+ 16, 24+ 160-24

   # Spikeyrock
    .word 67, evtMultipleCommands | 4
    .word     evtLoadObjSettings | 0
# defb    48+   3   ,160+24,24+ 128,24,       8,9,10 ; Three sprites,
    .word     evtSingleSprite, sprSingleFrame | SPIKEY_ROCK_A
    .byte         24+ 128, 24+ 160
    .word     evtSingleSprite, sprSingleFrame | SPIKEY_ROCK_B
    .byte         24+ 24+128, 24+ 160
    .word     evtSingleSprite, sprSingleFrame | SPIKEY_ROCK_C
    .byte         24+ 48+128, 24+ 160

   # rock chick enemy
    .word 75, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # rock chick enemy
    .word 80, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # boniburd
    .word 84, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 7
    .word     evtSingleSprite, sprTwoFrame | BONI_BURD
    .byte         24+ 16, 24+ 160-24

   # Skeleton walker
    .word 85, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 5
    .word     evtSingleSprite | 13  # Row 25, last Column, Last Sprite

   # Cross, crucifix
    .word 88, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 1
    .word     evtSingleSprite, sprSingleFrame | CROSS_CRUCIFIED_BLOKE
    .byte         24+ 89, 24+ 160

   # Powerup Drone
    .word 90, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word     evtSingleSprite, sprTwoFrame | POWERUP_DRONE
    .byte         24+ 150, 24+ 160

   # Grave
    .word 95, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | GRAVECROSS
    .byte         24+ 170, 24+ 160

   # SpliceFace
    .word 100, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite, sprTwoFrame | SPLICE_FACE
    .byte          24+ 100, 24

   # rock chick enemy
    .word 110, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # rock chick enemy
    .word 115, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # Clouds (3 wide)
    .word 120, evtMultipleCommands | 4
    .word      evtSetProgMoveLife, prgBitShift, mveBackground | 0b0100, lifeImmortal
    .word      evtSingleSprite, sprSingleFrame | CLOUD_A
    .byte          24+ 21, 24+ 159
    .word      evtSingleSprite, sprSingleFrame | CLOUD_B
    .byte          24+ 21, 24+ 159+12
    .word      evtSingleSprite, sprSingleFrame | CLOUD_C
    .byte          24+ 21, 24+ 159+24

   # rock chick enemy
    .word 120, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # Grave
    .word 122, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 0
    .word      evtSingleSprite, sprSingleFrame | GRAVECROSS
    .byte         24+ 170, 24+ 160

   # rock chick enemy
    .word 125, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # rock chick enemy
    .word 127, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # Burning bloke
    .word 129, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 1
    .word      evtSetProg, prgNone
    .word      evtSingleSprite, sprTwoFrame | BURNING_BLOKE
    .byte          24+ 90, 24+ 160

   # rock chick enemy
    .word 130, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # rock chick enemy
    .word 135, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # Cross, just a cross
    .word 143, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 1
    .word      evtSingleSprite, sprSingleFrame | CROSS
    .byte          24+ 107, 24+ 160

   # SpliceFace
    .word 150, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite, sprSingleFrame | SPLICE_FACE
    .byte          24+ 100, 24

   # Powerup Drone
    .word 150, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 042), 64+63
    .word      evtSingleSprite, sprTwoFrame | POWERUP_DRONE
    .byte          24+ 150, 24+ 160

   # Eyeclopse s
    .word 160, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 9
    .word      evtSingleSprite | 7  # Row 13, last Column, Last Sprite
    .word      evtSetMove, mveWave | 0b1111
    .word      evtSingleSprite | 12  # Row 23, last Column, Last Sprite

   # rock chick enemy
    .word 165, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # Gravestone
    .word 167, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 0
    .word      evtSingleSprite, sprSingleFrame | GRAVESTONE
    .byte          24+ 175, 24+ 160

   # rock chick enemy
    .word 170, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 8  # Row 15, last Column, Last Sprite

   # Eyeclopse s
    .word 180, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 9
    .word      evtSingleSprite | 7  # Row 13, last Column, Last Sprite
    .word      evtSetMove, mveWave | 0b1111
    .word      evtSingleSprite | 12  # Row 23, last Column, Last Sprite

   # Cross, just a cross
    .word 185, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 1
    .word      evtSingleSprite, sprSingleFrame | CROSS
    .byte          24+ 111, 24+ 160

   # Skull Gang
    .word 190, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 8
    .word      evtSingleSprite | 7  # Row 13, last Column, Last Sprite

   # Clouds (3 wide)
    .word 200, evtMultipleCommands | 4
    .word      evtSetProgMoveLife, prgBitShift, mveBackground | 0b0100, lifeImmortal
    .word      evtSingleSprite, sprSingleFrame | CLOUD_A
    .byte          24+ 21, 24+ 159
    .word      evtSingleSprite, sprSingleFrame | CLOUD_B
    .byte          24+ 21, 24+ 159+12
    .word      evtSingleSprite, sprSingleFrame | CLOUD_C
    .byte          24+ 21, 24+ 159+24

   # rock chick enemy
    .word 200, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

   # Boniburd
    .word 220, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite, sprTwoFrame | BONI_BURD
    .byte          24+ 16, 24+ 160-24

   # Skeleton walker
    .word 220, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 13  # Row 25, last Column, Last Sprite

   # Gravestone
    .word 221, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 0
    .word      evtSingleSprite, sprSingleFrame | GRAVESTONE
    .byte         24+ 176, 24+ 160

   # Skull Bomber
    .word 225, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 3
    .word      evtSingleSprite | 3  # Row 5, last Column, Last Sprite

   # Ant
    .word 225, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 12  # Row 23, last Column, Last Sprite

   # SpliceFace
    .word 230, evtMultipleCommands | 4
    .word      evtLoadObjSettings | 6
    .word      evtSetMove, mvRegular | spdNormal | 043
    .word      evtSingleSprite, sprTwoFrame | SPLICE_FACE
    .byte          24+ 50, 24+ 138
    .word      evtSingleSprite, sprTwoFrame | SPLICE_FACE
    .byte          24+ 150, 24+ 138

   # SpliceFace
    .word 232, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite, sprTwoFrame | SPLICE_FACE
    .byte          24+ 50, 24+ 138
    .word      evtSingleSprite, sprTwoFrame | SPLICE_FACE
    .byte          24+ 150, 24+ 138

   # Skull Bomber
    .word 235, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 3
    .word      evtSingleSprite | 3  # Row 5, last Column, Last Sprite

   # Ant
    .word 235, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 12  # Row 23, last Column, Last Sprite

   # Skull Bomber
    .word 245, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 3
    .word      evtSingleSprite | 3  # Row 5, last Column, Last Sprite

   # Ant
    .word 245, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 4
    .word      evtSingleSprite | 12  # Row 23, last Column, Last Sprite

   # cloud
    .word 250, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBitShift, mveBackground | 0b0100, lifeImmortal
    .word      evtSingleSprite, sprSingleFrame | CLOUD_C
    .byte          24+ 21, 24+ 160

    .word 255+ 5, evtCallAddress, Player_Handler_DoSmartBomb

LevelEndAnim:
# defb 5,evtMultipleCommands+2            ; 3 commands at the same timepoint
# defb evtSetProgMoveLife,prgMovePlayer,&24,10
# defb    0,128+  47,140+24,100+24    ;   ; Single Object sprite 11 (animated)
    .word 255+ 5, evtMultipleCommands | 2
    .word         evtSetProgMoveLife, prgMovePlayer, mvStatic, 10
    .word         evtSingleSprite, sprTwoFrame | DUMMY_SPRITE, (24+140)<<X | (24+100)<<Y

# Start of fade out block ------------------------------------------------------
    .equiv FadeOutStartPoint, 255+ 5
    .word FadeOutStartPoint + 1, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 2, evtSetPalette, BluePalette

    .word 255+ 8, evtCallAddress, EndLevel
#----------------------------------------------------------------------------}}}

EndLevel:
       .ppudo_ensure $PPU_LevelEnd
        MOV  $2,R5
        JMP  ExecuteBootstrap

LevelInit:
       .ppudo_ensure $PPU_LevelMusicRestart

        MOV  $LevelSprites.0,R0
        MOV  $SpriteBanksVectors,R1
        MOV  R0,(R1)+
        MOV  R0,(R1)+
        MOV  $LevelSprites.1,(R1)+
        MOV  R0,(R1)+

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        CALL EventStream_Init
        CALL ScreenBuffer_Init
        MTPS $PR0
#-------------------------------------------------------------------------------
LevelLoop:
        CALL @$EventStream_Process

        CALL @$Background_Draw
        CALL @$ObjectArray_Redraw

        MOV  $ChibiSprites,@$SprShow_BankAddr
        CALL @$PlayerHandler

        CALL @$Player_StarArray_Redraw
        CALL @$StarArray_Redraw

        CALL @$Player_DrawUI

        CALL @$ScreenBuffer_Flip

        BR   LevelLoop
#-------------------------------------------------------------------------------
# Generic Background Begin -----------------------------------------------------
Background_Draw:
        MOV  $0,R0 # 0=left
        CALL @$Background_GradientScroll

        MOV  @$ScreenBuffer_ActiveScreen, R5

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
        MOV  R4,-(SP) # we will need the position later for Tile bitshifts
        MOV  $16,R1
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $32,R1
        CALL @$Background_SolidFill

        MOV  $16,R1 # number of lines
        CALL @$Background_FloodFillQuadSprite

        CLR  R0
        MOV  $48,R1
        CALL @$Background_SolidFill

        MOV  R4,-(SP) # Background_Gradient corrupts R4
        MOV  $GradientBottom,R3 # 32 lines
        MOV  $GradientBottomStart,R1
        MOV  $0b11111111,R2 # Shift on Timer Ticks
        CALL @$Background_Gradient

        MOV  $8,R1 # number of lines
        MOV  (SP)+,R4
        CALL @$Background_FloodFillQuadSprite

# Tile Bitshifts ---------------------------------------------------------------
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

        RETURN

# Background Data -------------------------------------------------------{{{
   .equiv GradientTopStart, 48 # lines count
GradientTop:
   .word 0x00FF, 0x00FF                # 11111111 # 1st line
   .word GradientTopStart - 10, 0x00DD # 11011101 # 2nd line num, new word
   .word GradientTopStart - 16, 0x0077 # 01110111
   .word GradientTopStart - 20, 0x00AA # 10101010
   .word GradientTopStart - 26, 0x0055 # 01010101
   .word GradientTopStart - 30, 0x0088 # 10001000
   .word GradientTopStart - 36, 0x0022 # 00100010
   .word GradientTopStart - 40, 0x0000 # 00000000
   .word GradientTopStart - 46, 0x0000 # 00000000
   .word 0xFFFF

   .equiv GradientBottomStart, 32 # lines count
GradientBottom:
   .word 0x0000, 0x0000 # 1st line
   .word 26, 0x0022     # 2nd line num, new word
   .word 22, 0x0088
   .word 18, 0x0055
   .word 14, 0x00AA
   .word 10, 0x0077
   .word  6, 0x00DD
   .word  4, 0x00FF
   .word  2, 0x00FF
   .word 0xFFFF
#----------------------------------------------------------------------------}}}
BluePalette: #---------------------------------------------------------------{{{
    .word 0, cursorGraphic, scale320 | rgb
    .byte 1, setColors, Black, Blue, Blue, Magenta
    .word endOfScreen
#----------------------------------------------------------------------------}}}
DarkRealPalette: #-----------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | rgb
    .byte   1, setColors, Black, brBlue,  brYellow, White
    .byte  49, setColors, Black, Magenta, Blue,     White
    .byte 129, setColors, Black, brRed,   brCyan,   White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
RealPalette: #---------------------------------------------------------------{{{
    .byte   0, setOffscreenColors
    .word      BLACK  | BR_BLUE    << 4 | BR_GREEN  << 8 | BR_CYAN << 12
    .word      BR_RED | BR_MAGENTA << 4 | BR_YELLOW << 8 | WHITE   << 12
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, brBlue,  brYellow, White
    .word  32, cursorGraphic, scale320 | RGb
    .byte  40, setColors, Black, brBlue,  Magenta,  White
    .word  64, cursorGraphic, scale320 | RGB
    .byte  65, setColors, Black, Magenta, Blue,     White
    .byte 122, setColors, Black, Magenta, Cyan,     White
    .word 142, cursorGraphic, scale320 | rGB
    .byte 143, setColors, Black, brRed,   brCyan,   White
    .word 178, cursorGraphic, scale320 | RGB
    .word endOfScreen
#----------------------------------------------------------------------------}}}
    .even
end:
    .nolist
