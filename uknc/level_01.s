               .list

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

       .incbin "resources/level01.spr"
ChibiSprites:
       .incbin "resources/chibi_lr.spr"
LevelTiles:
       .incbin "resources/level01_tiles.spr"

################################################################################
#                                  Animators                                   #
################################################################################
AnimatorPointers:
    .word AnimatorData
AnimatorData:
    # First byte is the 'Tick map' which defines when the animation should
    # update
    .byte 0b00000010    # Anim Freq
    # all remaining bytes are anim frames in the form Command-Var-Var-Var
    .byte 01,128+01,0,0 # Sprite Anim
    .byte 01,128+02,0,0 # Sprite Anim
    .byte 00            # End of loop
    .even

################################################################################
#                             Data Allocations                                 #
################################################################################
Event_SavedSettingsB:   # 2nd bank Saved settings array
    .byte 128, 0x00
    .even

EventStreamArray_Ep1: #----------------------------------------------------------{{{
        # ; We will use 4 Paralax layers
        # ;  ---------()- (sky)        %11001000
        # ;  ------------ (Far)        %11000100
        # ;  -----X---X-- (mid)        %11000010   Bank 1
        # ;  []=====[]=== (foreground) %11000001   Bank 0

#   .word 0 # Time
#   .word evtReprogram_PowerupSprites # Event_CoreReprogram_PowerupSprites
#   .byte 128+38, 128+39, 128+40, 128+16 # Define powerup sprites

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
    .word        mvRegular | spdNormal | 0x22 # move - direction left, slow
    .word        lifeEnemy | 1
    .word    evtSetSprite | sprTwoFrame | 1                 # 2
    .word    evtSetAnimator | anmNone         # 3
    .word    evtAddToForeground               # 4
    .word    evtSaveObjSettings | 2           # 5

    # Skull bomber
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireFast | fireSingleSouth
    .word         mvRegular | spdNormal | 0x23 # move - direction left, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | sprTwoFrame | 37  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 3           # 5

    # Ant Attacker
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireTopLeft
    .word         mvRegular | spdNormal | 0x23 # move - direction left, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | sprTwoFrame | 0   # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 4           # 5

    # Skeleton Crawler
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireLeftWide
    .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | 36  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 5           # 5

    # SpliceFace
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireBurst
    .word         mvRegular | spdNormal | 0x25 # move - direction right, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | sprTwoFrame | 34  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 6           # 5

    # BoniBurd
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireBottomLeft
    .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | 2   # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 7           # 5

    # Skull Gang
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireFast | fireSingleWest
    .word         mveWave | 0b0001
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | 35  # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 8           # 5

    # Eyeclopse
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireLeftWide
    .word         mveWave | 0b1100
    .word         lifeEnemy | 3
    .word     evtSetSprite | sprTwoFrame | 7   # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 9           # 5

   #.word 0, evtAddToBackground
   #.word 0, evtSetProgMoveLife, prgBitShift, mveBackground | 0b0001, lifeImmortal

    # Moon
    .word 0, evtMultipleCommands | 3
    .word    evtLoadObjSettings | 0
    .word    evtSetMove, mveBackground | 0b1000
    .word    evtSingleSprite, sprSingleFrame | 3
    .byte        24+ 8, 24+ 160 -16 # Y, X :  32, 172 : 8, 288

    # Castle
    .word 0, evtSetMove, mveBackground | 0b0010
    .word 0, evtSingleSprite, sprSingleFrame | 4
    .byte        24+ 50,    24+ 120  # Y, X :  74, 144 :  50, 240
    # some boulders
    .word 0, evtSingleSprite, sprSingleFrame | 14
    .byte        24+ 40+90, 24+ 100  # Y, X : 154, 124 : 130, 200
    .word 0, evtSingleSprite, sprSingleFrame | 13
    .byte        24+ 40+100, 24+ 90  # Y, X : 164, 114 : 140, 180
    .word 0, evtSingleSprite, sprSingleFrame | 13
    .byte        24+ 40+100, 24+ 162 # Y, X : 164, 184 : 140, 324

    # Burning bloke
    .word 0, evtMultipleCommands | 2
    .word    evtSetProgMoveLife, prgNone, mveBackground | 0b0010, lifeImmortal
    .word    evtSingleSprite, sprTwoFrame | 11
    .byte        24+ 90, 24+ 50 # Y, X : 114, 74 : 90, 100

    # Clouds (3 wide)
    .word 0, evtMultipleCommands | 4
    .word    evtSetMove, mveBackground | 0b0100
    .word    evtSingleSprite, sprSingleFrame | 41
    .byte        24+ 14, 24+ 159
    .word    evtSingleSprite, sprSingleFrame | 42
    .byte        24+ 14, 24+ 159+12
    .word    evtSingleSprite, sprSingleFrame | 43
    .byte        24+ 14, 24+ 159+24

    # Spikeyrock
    .word 0, evtMultipleCommands | 3
    .word    evtSetMove, mveBackground | 0b0001
# defb    48+2, 24+100, 24+24+128, 24, 8, 9 ; Two sprites,
    .word    evtSingleSprite, sprSingleFrame | 8
    .byte        24+ 24+128, 24+ 100
    .word    evtSingleSprite, sprSingleFrame | 9
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

    # Rock Pt 1
    .word 10, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | 22
    .byte         24+ 176, 24+ 160

    # Cross
    .word 13, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 1
    .word     evtSingleSprite, sprSingleFrame | 17
    .byte         24+ 110, 24+ 160

    # rock chick enemy
    .word 15, evtMultipleCommands | 3
    .word     evtLoadObjSettings | 2
    .word     evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word     evtSingleSprite | 10 # Row 19, last Column, Last Sprite

    # Rock Pt 2
    .word 16, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | 23
    .byte         24+ 176, 24+ 160

    # Powerup Rate
    .word 17, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 0x22), 64+63
    .word     evtSingleSprite, sprTwoFrame | 39
    .byte         24+ 50, 24+ 160

    # Rock Pt 3
    .word 22, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | 24
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

    # Cross
    .word 40, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 1
    .word     evtSingleSprite, sprSingleFrame | 18
    .byte         24+ 85, 24+ 160

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
    .word     evtSingleSprite, sprTwoFrame | 11
    .byte         24+ 85, 24+ 160

    # Boniburd
    .word 65, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 7
    .word     evtSingleSprite, sprTwoFrame | 2
    .byte         24+ 16, 24+ 160-24

    # Spikeyrock
    .word 67, evtMultipleCommands | 4
    .word     evtLoadObjSettings | 0
# defb    48+   3   ,160+24,24+ 128,24,       8,9,10 ; Three sprites,
    .word     evtSingleSprite, sprSingleFrame | 8
    .byte         24+ 128, 24+ 160
    .word     evtSingleSprite, sprSingleFrame | 9
    .byte         24+ 24+128, 24+ 160
    .word     evtSingleSprite, sprSingleFrame | 10
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
    .word     evtSingleSprite, sprTwoFrame | 2
    .byte         24+ 16, 24+ 160-24

    # Skeleton walker
    .word 85, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 5
    .word     evtSingleSprite | 13  # Row 25, last Column, Last Sprite

    # Cross
    .word 88, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 1
    .word     evtSingleSprite, sprSingleFrame | 18
    .byte         24+ 85, 24+ 160

    # Powerup Drone
    .word 90, evtMultipleCommands | 2
    .word     evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 0x22), 64+63
    .word     evtSingleSprite, sprTwoFrame | 38
    .byte         24+ 150, 24+ 160

    # Grave
    .word 95, evtMultipleCommands | 2
    .word     evtLoadObjSettings | 0
    .word     evtSingleSprite, sprSingleFrame | 21
    .byte         24+ 170, 24+ 160

    # SpliceFace
    .word 100, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite, sprTwoFrame | 34
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
    .word      evtSetProgMoveLife, prgNone, mveBackground | 0b0100, lifeImmortal
    .word      evtSingleSprite, sprSingleFrame | 41
    .byte          24+ 14, 24+ 159
    .word      evtSingleSprite, sprSingleFrame | 42
    .byte          24+ 14, 24+ 159+12
    .word      evtSingleSprite, sprSingleFrame | 43
    .byte          24+ 14, 24+ 159+24

    # rock chick enemy
    .word 120, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

    # Grave
    .word 122, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 0
    .word      evtSingleSprite, sprSingleFrame | 21
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
    .word      evtSingleSprite, sprTwoFrame | 11
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

    # Cross
    .word 140, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 1
    .word      evtSingleSprite, sprSingleFrame | 19
    .byte          24+ 103, 24+ 160

    # SpliceFace
    .word 150, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite, sprSingleFrame | 34
    .byte          24+ 100, 24

    # Powerup Drone
    .word 150, evtMultipleCommands | 2
    .word      evtSetProgMoveLife, prgBonus, (mvRegular | spdNormal | 0x22), 64+63
    .word      evtSingleSprite, sprTwoFrame | 38
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

    # Grave
    .word 167, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 0
    .word      evtSingleSprite, sprSingleFrame | 20
    .byte          24+ 173, 24+ 160

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

    # Cross
    .word 185, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 1
    .word      evtSingleSprite, sprSingleFrame | 19
    .byte          24+ 107, 24+ 160

    # Skull Gang
    .word 190, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 8
    .word      evtSingleSprite | 7  # Row 13, last Column, Last Sprite

    # Clouds (3 wide)
    .word 200, evtMultipleCommands | 4
    .word      evtSetProgMoveLife, prgNone, mveBackground | 0b0100, lifeImmortal
    .word      evtSingleSprite, sprSingleFrame | 41
    .byte          24+ 14, 24+ 159
    .word      evtSingleSprite, sprSingleFrame | 42
    .byte          24+ 14, 24+ 159+12
    .word      evtSingleSprite, sprSingleFrame | 43
    .byte          24+ 14, 24+ 159+24

    # rock chick enemy
    .word 200, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 2
    .word      evtSingleSprite | 6  # Row 11, last Column, Last Sprite
    .word      evtSingleSprite | 10 # Row 19, last Column, Last Sprite

    # Boniburd
    .word 220, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 7
    .word      evtSingleSprite, sprTwoFrame | 2
    .byte          24+ 16, 24+ 160-24

    # Skeleton walker
    .word 220, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 5
    .word      evtSingleSprite | 13  # Row 25, last Column, Last Sprite

    # Grave
    .word 221, evtMultipleCommands | 2
    .word      evtLoadObjSettings | 0
    .word      evtSingleSprite, sprSingleFrame | 20
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
    .word      evtSetMove, mvRegular | spdNormal | 0x23
    .word      evtSingleSprite, sprTwoFrame | 34
    .byte          24+ 50, 24+ 138
    .word      evtSingleSprite, sprTwoFrame | 34
    .byte          24+ 150, 24+ 138

    # SpliceFace
    .word 232, evtMultipleCommands | 3
    .word      evtLoadObjSettings | 6
    .word      evtSingleSprite, sprTwoFrame | 34
    .byte          24+ 50, 24+ 138
    .word      evtSingleSprite, sprTwoFrame | 34
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
    .word      evtSetProgMoveLife, prgNone, mveBackground | 0b0100, lifeImmortal
    .word      evtSingleSprite, sprSingleFrame | 43
    .byte          24+ 14, 24+ 160

   #.word, 256+ 5, evtCallAddress, DoSmartBombCall

# LevelEndAnim:
# defb 5,evtMultipleCommands+2            ; 3 commands at the same timepoint
# defb evtSetProgMoveLife,prgMovePlayer,&24,10
# defb    0,128+  47,140+24,100+24    ;   ; Single Object sprite 11 (animated)

# Start of fade out block ------------------------------------------------------
    .equiv FadeOutStartPoint, 256+ 5
    .word FadeOutStartPoint + 1, evtSetPalette, DarkRealPalette
    .word FadeOutStartPoint + 2, evtSetPalette, BluePalette

    .word 256+ 8, evtCallAddress, EndLevel
#----------------------------------------------------------------------------}}}

EndLevel:
        TST  (SP)+ # remove return address from the stack
        MOV  $0x8000,R5
        JMP  @$ExecuteBootstrap

LevelInit:
        CALL @$Player_GetPlayerVars

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        MOV  $Event_SavedSettingsB,R3 # Saved Settings
        CALL @$EventStream_Init

        CALL ScreenBuffer_Init
        MTPS $PR0

        MOVB $3,@$Player_Array+9 # set number of lives for the first player
LevelLoop:
        CALL ShowKeysBitmap

        CALL @$Background_Draw

        CALL @$EventStream_Process

        MOV  $LevelSprites,@$srcSprShow_BankAddr  
        CALL @$ObjectArray_Redraw

        MOV  $ChibiSprites,@$srcSprShow_BankAddr

        CALL @$PlayerHandler

        MOV  $ChibiSprites,@$srcSprShow_BankAddr  
        CALL @$Player_StarArray_Redraw

        CALL @$StarArray_Redraw

        CALL @$Player_DrawUI

       #CALL @$PlaySfx

        CALL @$ScreenBuffer_Flip

        BR   LevelLoop

ShowKeysBitmap: # -----------------------------------------------------------{{{
        MOV  @$KeyboardScanner_P1,R3
       .equiv LastKeysBitmap, .+2
        CMP  R3,$0b00000000
       #BEQ  1237$
        MOV  R3,@$LastKeysBitmap

        MOV  $ScanCodeStr+2,R1
        CALL @$NumToStr
       .ppudo_ensure $PPU_DebugPrintAt, $ScanCodeStr
1237$:  RETURN

NumToStr: #------------------------------------------------------------------{{{
        MOV  $8,R0      # R0 - length of the number
                        # R1 - position of number in str (first argument)
                        # R3 - number (second argument)
        ADD  R0,R1

100$:   CLR  R2         # R2 - most, R3 - least significant word
        DIV  $2,R2
                        # R2 contains quotient, R3 - remainder
        ADD  $'0,R3 # add ASCII code for "0" to the remainder
        MOVB R3,-(R1)
        MOV  R2,R3

        SOB  R0,100$

        RETURN
#----------------------------------------------------------------------------}}}
ScanCodeStr:
        .byte 0,4
        .asciz "76543210"
        .even
#----------------------------------------------------------------------------}}}
# Generic Background Begin -----------------------------------------------------
Background_Draw:
        MOV  $0,R0 # 0=left
        CALL @$Background_GradientScroll

        CALL @$Timer_UpdateTimer
        PUSH R0 # need to keep the smartbomb color

        CALL @$Timer_GetTimer
        MOV  R0,@$srcBitShifter_TicksOccured

        MOV  @$ScreenBuffer_ActiveScreen, R5

        POP  R0
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
   .word 0x00FF, 0x00FF                # 1st line
   .word GradientTopStart - 10, 0x00DD # 2nd line num, new word
   .word GradientTopStart - 16, 0x0077
   .word GradientTopStart - 20, 0x00AA
   .word GradientTopStart - 26, 0x0055
   .word GradientTopStart - 30, 0x0088
   .word GradientTopStart - 36, 0x0022
   .word GradientTopStart - 40, 0x0000
   .word GradientTopStart - 46, 0x0000
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
# 9 br.     # A br.     # B br.     # C br.     # D br.     # E br.     # F white
# 1 blue    # 2 green   # 3 cyan    # 4 red     # 5 magenta # 6 yellow  # 7 gray
BluePalette: #---------------------------------------------------------------{{{
    .byte 0, 0    # line number, set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10000 #  320 dots per line, pallete 0

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0x11, 0x11, 0x55
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
DarkRealPalette: #---- ------------------------------------------------------{{{
    .byte 0, 0    # line number, 0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, YRGB color
    .word 0b10000 #  320 dots per line, palette 0

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0x99, 0xEE, 0xFF
    .byte 49, 1    # line number, set colors
    .byte 0x00, 0x55, 0x11, 0xFF
    .byte 129, 1    # line number, set colors
    .byte 0x00, 0xCC, 0xBB, 0xFF

    .byte 201       # --line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
RealPalette: #---------------------------------------------------------------{{{
    .byte 0, 0    # line number, 0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, YRGB color
    .word 0b10111 #  320 dots per line, palette 7

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0x99, 0xEE, 0xFF
    .byte 41, 1    # line number, set colors
    .byte 0x00, 0x55, 0x11, 0xFF
    .byte 143, 1    # line number, set colors
    .byte 0x00, 0xCC, 0xBB, 0xFF

    .byte 201       # --line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
# 9 br.     # A br.     # B br.     # C br.     # D br.     # E br.     # F white
# 1 blue    # 2 green   # 3 cyan    # 4 red     # 5 magenta # 6 yellow  # 7 gray

    .even
end:
    .nolist
