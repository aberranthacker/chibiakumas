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

       .incbin "resources/level01.spr"
LevelTiles:
       .incbin "resources/level01-tiles.spr"

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

################################################################################
#                             Data Allocations                                 #
################################################################################
Event_SavedSettingsB:   # 2nd bank Saved settings array
    .byte 128, 0x00

EventStreamArray_Ep1: #----------------------------------------------------------{{{
        # ; We will use 4 Paralax layers
        # ;  ---------()- (sky)        %11001000
        # ;  ------------ (Far)        %11000100
        # ;  -----X---X-- (mid)        %11000010   Bank 1
        # ;  []=====[]=== (foreground) %11000001   Bank 0
    .word 0 # Time
    .word evtReprogram_PowerupSprites # Event_CoreReprogram_PowerupSprites
    .byte 128+38, 128+39, 128+40, 128+16 # Define powerup sprites

    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0x01
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 0           # 5

    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0b00000010
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 1           # 5

    # Rock Chick
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireLeftWide
    .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
    .word         lifeEnemy | 1
    .word     evtSetSprite | 1                 # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 2           # 5

    # Skull bomber
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireFast | fireSingleSouth
    .word         mvRegular | spdNormal | 0x23 # move - direction left, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | 37                # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 3           # 5

    # Ant Attacker
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireTopLeft
    .word         mvRegular | spdNormal | 0x23 # move - direction left, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | 0                 # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 4           # 5

    # Skeleton Crawler
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireLeftWide
    .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
    .word         lifeEnemy | 3
    .word     evtSetSprite | 36                # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 5           # 5

    # SpliceFace
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireBurst
    .word         mvRegular | spdNormal | 0x25 # move - direction right, slow
    .word         lifeEnemy | 4
    .word     evtSetSprite | 34                # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 6           # 5

    # BoniBurd
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSnail | fireBottomLeft
    .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
    .word         lifeEnemy | 3
    .word     evtSetSprite | 2                 # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 7           # 5

    # Skull Gang
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireFast | fireSingleWest
    .word         mveWave | 0b0001
    .word         lifeEnemy | 3
    .word     evtSetSprite | 35                # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 8           # 5

    # Eyeclopse
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgFireSlow | fireLeftWide
    .word         mveWave | 0b1100
    .word         lifeEnemy | 3
    .word     evtSetSprite | 7                 # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToForeground               # 4
    .word     evtSaveObjSettings | 9           # 5

    # Add To Background
    .word 0, evtAddToBackground
    .word 0, evtSetProgMoveLife
    .word        prgBitShift
    .word        mveBackground | 0b1000
    .word        lifeImmortal

    .word 0, evtSetProgMoveLife
    .word        prgBitShift
    .word        mveBackground | 0b1000
    .word        lifeImmortal

# defb 0,0,   3,24+ 160 -16 ,24+ 8 ; single sprite
#
# ;Castle
#

# defb 51,evtSingleSprite, TwoFrameSprite + 6, 24+160-12-6, 24+40-10
#     .word     evtSingleSprite, sprTwoFrame | 6
#     .byte         24+40-10,      24+160-12-6


# defb 0,evtSetMoveLife ,%11000010,0  ; Move    / dir Left Slow ... Life - immortal
# defb 0,0,   4,24+ 120  ,24+ 50      ; single sprite
#
# defb 0,0,   14,24+ 100  ,24+ 40+80  ; single sprite
#
# defb 0,0,   13,24+ 90  ,24+ 40+100  ; single sprite
# defb 0,0,   13,24+ 162  ,24+ 40+100 ; single sprite
#
# ;Burning bloke
# defb 0,evtMultipleCommands+3       ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1     ; Load Settings from bank 1
# defb    129,0                      ; Change to program 0 (normal)
# defb    0,128+  11,50+24,90+24  ;  ; Single Object sprite 11 (animated)
#
# ;Clouds (3 wide)
# defb 0,evtMultipleCommands+6       ; 2 commands at the same timepoint
# defb    evtAddToBackground
# defb    evtSetProgMoveLife, 0, %11000100, 0 ; Move / dir Left Slow ... Life - immortal
# defb    0, 41, 159+24, 10+28      ;  ; Single Object /
# defb    0, 42, 159+24+12, 10+28   ;  ; Single Object /
# defb    0, 43, 159+24+24, 10+28   ;  ; Single Object /
# defb    evtAddToForeground
#
# ;Spikeyrock
# defb 0,evtMultipleCommands+2       ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+0     ; Load Settings from bank 0
# defb    48+2, 24+100, 24+24+128, 24, 8, 9 ; Three sprites,

# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;               Start of fade in block
# FadeStartPoint equ 0    ;Start of fade point
#             ; Fade lasts two timers - ends FadeStartPoint+2
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#
#     defb FadeStartPoint+1,evtCallAddress
#     defw     EnablePlusPalette
#
#     ;BLUE COLORS - 6128
#     defb FadeStartPoint+1,evtMultipleCommands+4 ; 4 Commands
#     defb 240,0,6         ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&54,&44,&40
#
#     defb 240,26*0+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 1
#     defb 1
#     defb &54,&54,&44,&40
#
#     defb 240,26*1+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 0
#     defb 1
#     defb &54,&54,&44,&40
#
#     defb 240,26*2+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&54,&44,&40
#
#     ;REAL LEVEL PALETTE
#
#     defb FadeStartPoint+2,evtMultipleCommands+4         ; 4 Commands
#     defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&55,&4A,&4B  ; Black,DkBlue,LtYellow,White
#
#     defb 240,26*0+6,5*2+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 2  ; Switches
#     defb 16 ;delay
#     defb &54,&5D,&59,&4B
#     defb 16 ;delay
#     defb &54,&58,&5F,&4B
#
#     defb 240,26*1+6,1     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 0
#
#     defb 240,26*2+6,5*2+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 2 ; no of switches
#     defb 0  ;delays
#     defb &54,&58,&53,&4B  ; Black,Red,Grey,White
#     defb 32
#     defb &54,&4C,&53,&4B  ; 5b
#
#     defb FadeStartPoint+2,evtCallAddress
#     defw RasterColorsStartPalleteFlip
#
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;;              End of fade in block
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#
# ; rock chick enemy
# defb 5,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2 ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ; Rock Pt 1
# defb 10,evtMultipleCommands+2  ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+0 ; Load Settings from bank 0
# defb    0,  22,160+24,172+28   ; Single Object /
#
# ;Cross
# defb 13,evtMultipleCommands+2  ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1 ; Load Settings from bank 1
# defb    0,17,160+24,110+24     ; Single Object sprite 11 (animated)
#
# ; rock chick enemy
# defb 15,evtMultipleCommands+3  ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2 ; Load Settings from bank 2
# defb    0+6                    ; Row 16, last Column, Last Sprite
# defb    0+10                   ; Row 16, last Column, Last Sprite
#
# ; Rock Pt 2
# defb 16,evtMultipleCommands+2  ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+0 ; Load Settings from bank 0
# defb    0,  23,160+24,172+28   ; Single Object /
#
# ; Powerup Rate
# defb 17,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSetProgMoveLife ,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb    0,128+ 39,160+24,50+24  ;   ; Single Object sprite 11 (animated)
#
# ; Rock Pt 3
# defb 22,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+0  ; Load Settings from bank 0
# defb    0,  24,160+24,172+28    ; Single Object /
#
# ; rock chick enemy
# defb 25,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2  ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ;; rock chick enemy
# defb 30,evtMultipleCommands+3   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2  ; Load Settings from bank 2
# defb    0+6                     ; Row 16, last Column, Last Sprite
# defb    0+10                    ; Row 16, last Column, Last Sprite
#
# ; rock chick enemy
# defb 35,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2  ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ;Cross
# defb 40,evtMultipleCommands+2   ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1  ; Load Settings from bank 1
# defb    0,18,160+24,85+24   ;   ; Single Object sprite 11 (animated)
#
# ;Skull Bomber
# defb 45,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+3  ; Load Settings from bank 3
# defb    0+3             ; Row 16, last Column, Last Sprite
#
# ;Ant
# defb 45,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+4  ; Load Settings from bank 4
# defb    0+12                    ; Row 16, last Column, Last Sprite
#
# ;Burning bloke
# defb 55,evtMultipleCommands+3   ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1  ; Load Settings from bank 1
# defb    129,0                   ; Change to program 0 (normal)
# defb    0,128+  11,160+24,90+24 ;   ; Single Object sprite 11 (animated)
#
# ; Boniburd
# defb 65,evtMultipleCommands+2   ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+7  ; Load Settings from bank 5
# defb    evtSingleSprite,TwoFrameSprite+ 2,160+24-24,24+16
#
# ;  SpikyRock
# defb 67,evtMultipleCommands+2    2 commands at the same timepoint
# defb    evtSettingsBank_Load+0   Load Settings from bank 0
# defb    48+   3   ,160+24,24+ 128,24,       8,9,10 ; Three sprites,
#
# ; rock chick enemy
# defb 75,evtMultipleCommands+2           ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ; rock chick enemy
# defb 80,evtMultipleCommands+3           ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+6             ; Row 16, last Column, Last Sprite
# defb    0+10                ; Row 16, last Column, Last Sprite
#
# ; boniburd
# defb 84,evtMultipleCommands+2           ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+7              ; Load Settings from bank 5
# defb    evtSingleSprite,TwoFrameSprite+ 2,160+24-24,24+16
#
# ;Skeleton walker
# defb 85,evtMultipleCommands+2           ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+5              ; Load Settings from bank 5
# defb    0+13                ; Row 16, last Column, Last Sprite
#
# ;Cross
# defb 88,evtMultipleCommands+2           ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
# defb    0,18,160+24,85+24   ;   ; Single Object sprite 11 (animated)
#
# ; Powerup Drone
# defb 90,evtMultipleCommands+2           ; 2 commands at the same timepoint
# defb    evtSetProgMoveLife ,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb    0,128+ 38,160+24,150+24 ;   ; Single Object sprite 11 (animated)
#
# ;Grave
# defb 95,evtMultipleCommands+2       ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+0              ; Load Settings from bank
# defb    0,21,160+24,170+24  ;   ; Single Object sprite 11 (animated)
#
# ; SpliceFace
# defb 100,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+6              ; Load Settings from bank 6
# defb    0,128+34,24,100+24  ;   ; Single Object /
#
# ; rock chick enemy
# defb 110,evtMultipleCommands+3          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+6             ; Row 16, last Column, Last Sprite
# defb    0+10                ; Row 16, last Column, Last Sprite
#
# ; rock chick enemy
# defb 115,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ;Clouds (3 wide)
# defb 120,evtMultipleCommands+4          ; 2 commands at the same timepoint
# defb    evtSetProgMoveLife ,0,%11000100,0           ; Move    / dir Left Slow ... Life - immortal
# defb    0, 41,159+24,10+28  ;   ; Single Object /
# defb    0, 42,159+24+12,10+28   ;   ; Single Object /
# defb    0, 43,159+24+24,10+28   ;   ; Single Object /
#
# ; rock chick enemy
# defb 120,evtMultipleCommands+3          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+6             ; Row 16, last Column, Last Sprite
# defb    0+10                ; Row 16, last Column, Last Sprite
#
# ;Grave
# defb 122,evtMultipleCommands+2          ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+0              ; Load Settings from bank
# defb    0,21,160+24,170+24  ;   ; Single Object sprite 11 (animated)
#
# ; rock chick enemy
# defb 125,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ; rock chick enemy
# defb 127,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ;Burning bloke
# defb 129,evtMultipleCommands+3          ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
# defb    129,0                   ; Change to program 0 (normal)
# defb    0,128+  11,160+24,90+24 ;   ; Single Object sprite 11 (animated)
#
# ; rock chick enemy
# defb 130,evtMultipleCommands+3          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+6             ; Row 16, last Column, Last Sprite
# defb    0+10                ; Row 16, last Column, Last Sprite
#
# ; rock chick enemy
# defb 135,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ;Cross
# defb 140,evtMultipleCommands+2          ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
# defb    0,19,160+24,103+24  ;   ; Single Object sprite 11 (animated)
#
# ; SpliceFace
# defb 150,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+6              ; Load Settings from bank 6
# defb    0,128+34,24,100+24  ;   ; Single Object /
#
# ; Powerup Drone
# defb 150,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSetProgMoveLife ,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
# defb    0,128+ 38,160+24,150+24 ;   ; Single Object sprite 11 (animated)
#
# ; Eyeclopse s
# defb 160,evtMultipleCommands+4          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+9              ; Load Settings from bank 5
# defb    0+7
# defb    131,%10101111               ; change Move
# defb    0+12
#
# ; rock chick enemy
# defb 165,evtMultipleCommands+3          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+6             ; Row 16, last Column, Last Sprite
# defb    0+10                ; Row 16, last Column, Last Sprite
#
# ;Grave
# defb 167,evtMultipleCommands+2          ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+0              ; Load Settings from bank
# defb    0,20,160+24,173+24  ;   ; Single Object sprite 11 (animated)
#
# ; rock chick enemy
# defb 170,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
# defb    0+8             ; Row 16, last Column, Last Sprite
#
# ; Eyeclopse s
# defb 180,evtMultipleCommands+4          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+9              ; Load Settings from bank 5
# defb    0+7
# defb    131,%10101111               ; change Move
# defb    0+12
#
# ;Cross
# defb 185,evtMultipleCommands+2          ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
# defb    0,19,160+24,107+24  ;   ; Single Object sprite 11 (animated)
#
# ; Skull Gang
# defb 190,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+8              ; Load Settings from bank 5
# defb    0+7
#
# ;Clouds (3 wide)
# defb 200,evtMultipleCommands+4  ; 2 commands at the same timepoint
# defb    evtSetProgMoveLife ,0,%11000100,0 ; Move / dir Left Slow ... Life - immortal
# defb    0, 41,159+24,10+28  ;   ; Single Object /
# defb    0, 42,159+24+12,10+28   ;   ; Single Object /
# defb    0, 43,159+24+24,10+28   ;   ; Single Object /
#
# ; rock chick enemy
# defb 200,evtMultipleCommands+3 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+2 ; Load Settings from bank 2
# defb    0+6                    ; Row 16, last Column, Last Sprite
# defb    0+10                   ; Row 16, last Column, Last Sprite
#
# ; boniburd
# defb 220,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+7 ; Load Settings from bank 5
# defb    evtSingleSprite,TwoFrameSprite+ 2,160+24-24,24+16
#
# ;Skeleton walker
# defb 220,evtMultipleCommands+2          ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+5              ; Load Settings from bank 5
# defb    0+13                ; Row 16, last Column, Last Sprite
#
# ;Grave
# defb 221,evtMultipleCommands+2 ; 3 commands at the same timepoint
# defb    evtSettingsBank_Load+0 ; Load Settings from bank
# defb    0,20,160+24,176+24  ;  ; Single Object sprite 11 (animated)
#
# ;Skull Bomber
# defb 225,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+3 ; Load Settings from bank 3
# defb    0+3                    ; Row 16, last Column, Last Sprite
#
# ;Ant
# defb 225,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+4 ; Load Settings from bank 4
# defb    0+12                   ; Row 16, last Column, Last Sprite
#
# ; SpliceFace
# defb 230,evtMultipleCommands+4 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+6 ; Load Settings from bank 6
# defb    %10000011,&23          ; Change Move
# defb    0,128+34,24,50+24   ;  ; Single Object /
# defb    0,128+34,24,150+24  ;  ; Single Object /
#
# ; SpliceFace
# defb 232,evtMultipleCommands+3 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+6 ; Load Settings from bank 6
# defb    0,128+34,24,50+24   ;  ; Single Object /
# defb    0,128+34,24,150+24  ;  ; Single Object /
#
# ;Skull Bomber
# defb 235,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+3 ; Load Settings from bank 3
# defb    0+3                    ; Row 16, last Column, Last Sprite
#
# ;Ant
# defb 235,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+4 ; Load Settings from bank 4
# defb    0+12                   ; Row 16, last Column, Last Sprite
#
# ;Skull Bomber
# defb 245,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+3 ; Load Settings from bank 3
# defb    0+3                    ; Row 16, last Column, Last Sprite
#
# ;Ant
# defb 245,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSettingsBank_Load+4 ; Load Settings from bank 4
# defb    0+12                   ; Row 16, last Column, Last Sprite
#
# defb 250,evtMultipleCommands+2 ; 2 commands at the same timepoint
# defb    evtSetProgMoveLife ,0,%11000100,0           ; Move    / dir Left Slow ... Life - immortal
# defb    0, 43,160+24,10+28  ;   ; Single Object /
#
# defb 5,%10001001            ;Call a memory location
# defw    ClearBadguys
# ;Palette Change
# LevelEndAnim:
# defb 5,evtMultipleCommands+2            ; 3 commands at the same timepoint
# defb evtSetProgMoveLife,prgMovePlayer,&24,10
# defb    0,128+  47,140+24,100+24    ;   ; Single Object sprite 11 (animated)
#
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# FadeOutStartPoint equ 5
# ;               Start of fade out block
# ;               Fade out ends at FadeutStart+2, eg if FadeOut=5 then ends at 7
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#
#     ;CPC Plus
#     defb FadeOutStartPoint,evtCallAddress
#     defw FadeOut
#
#     ;Blue 6128
#
#     defb FadeOutStartPoint+1,evtMultipleCommands+4          ; 4 Commands
#     defb 240,0,6                ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&54,&44,&40
#
#     defb 240,26*0+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 1
#     defb 1
#     defb &54,&54,&44,&40
#
#     defb 240,26*1+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 0
#     defb 1
#     defb &54,&54,&44,&40
#
#     defb 240,26*2+6,6               ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&54,&44,&40
#
#     ;Black 6128
#     defb FadeOutStartPoint+2,evtMultipleCommands+4          ; 4 Commands
#     defb 240,0,6                ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&54,&54,&54
#
#     defb 240,26*0+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 1
#     defb 1
#     defb &54,&54,&54,&54
#
#     defb 240,26*1+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
#     defb 0
#     defb 1
#     defb &54,&54,&54,&54
#
#     defb 240,26*2+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
#     defb 1
#     defb 1
#     defb &54,&54,&54,&54
#
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
# ;               End of fade out block
# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#
# defb 8,evtCallAddress           ;Call a memory location
# defw    EndLevel


#----------------------------------------------------------------------------}}}

EndLevel:
        MOV  $0x8000,R5
        JMP  @$ExecuteBootstrap

LevelInit:
        JMP  @$EndLevel
        call AkuYou_Player_GetPlayerVars

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        MOV  $Event_SavedSettingsB,R3  # Saved Settings
        CALL @$Event_StreamInit

      #.ppudo_ensure $PPU_LoadMusic,$TitleMusic
      #.ppudo_ensure $PPU_MusicRestart

       #CALL ScreenBuffer_Init
       #ld (BackgroundFloodFillQuadSprite_Minus1+1),hl
       #ld (BackgroundSolidFillNextLine_Minus1+1),hl
LevelLoop:
       #CALL Background_Draw

        CALL EventStream_Process

        CALL ObjectArray_Redraw

       #CALL Akuyou_Player_Handler

       #CALL AkuYou_Player_StarArray_Redraw

       #CALL Akuyou_StarArray_Redraw

       #CALL AkuYou_Player_DrawUI

       #CALL Akuyou_PlaySfx

       .equiv FadeCommand, .+2
        CALL @$null

       #CALL Akuyou_ScreenBuffer_Flip

       #ld (BackgroundSolidFillNextLine_Minus1+1),hl
       #ld (BackgroundFloodFillQuadSprite_Minus1+1),hl

        JMP  @$LevelLoop

#-------------------------------------------------------------------------------
# for some reason GAS replaces the last byte with 0
# so we add the dummy word to avoid data/code corruption
       .word 0xFFFF
end:
