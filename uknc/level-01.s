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

    .word 0, evtSetPalette, RealPalette
#   .word 0 # Time
#   .word evtReprogram_PowerupSprites # Event_CoreReprogram_PowerupSprites
#   .byte 128+38, 128+39, 128+40, 128+16 # Define powerup sprites

#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgBitShift
#   .word         mveBackground | 0x01
#   .word         lifeImmortal
#   .word     evtSetObjectSize | 0             # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToBackground               # 4
#   .word     evtSaveObjSettings | 0           # 5

#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgBitShift
#   .word         mveBackground | 0b00000010
#   .word         lifeImmortal
#   .word     evtSetObjectSize | 0             # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToBackground               # 4
#   .word     evtSaveObjSettings | 1           # 5

#   # Rock Chick
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireSlow | fireLeftWide
#   .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
#   .word         lifeEnemy | 1
#   .word     evtSetSprite | 1                 # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 2           # 5

#   # Skull bomber
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireFast | fireSingleSouth
#   .word         mvRegular | spdNormal | 0x23 # move - direction left, slow
#   .word         lifeEnemy | 4
#   .word     evtSetSprite | 37                # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 3           # 5

#   # Ant Attacker
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireSlow | fireTopLeft
#   .word         mvRegular | spdNormal | 0x23 # move - direction left, slow
#   .word         lifeEnemy | 4
#   .word     evtSetSprite | 0                 # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 4           # 5

#   # Skeleton Crawler
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireSnail | fireLeftWide
#   .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
#   .word         lifeEnemy | 3
#   .word     evtSetSprite | 36                # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 5           # 5

#   # SpliceFace
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireSnail | fireBurst
#   .word         mvRegular | spdNormal | 0x25 # move - direction right, slow
#   .word         lifeEnemy | 4
#   .word     evtSetSprite | 34                # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 6           # 5

#   # BoniBurd
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireSnail | fireBottomLeft
#   .word         mvRegular | spdNormal | 0x22 # move - direction left, slow
#   .word         lifeEnemy | 3
#   .word     evtSetSprite | 2                 # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 7           # 5

#   # Skull Gang
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireFast | fireSingleWest
#   .word         mveWave | 0b0001
#   .word         lifeEnemy | 3
#   .word     evtSetSprite | 35                # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 8           # 5

#   # Eyeclopse
#   .word 0, evtMultipleCommands | 5
#   .word     evtSetProgMoveLife               # 1
#   .word         prgFireSlow | fireLeftWide
#   .word         mveWave | 0b1100
#   .word         lifeEnemy | 3
#   .word     evtSetSprite | 7                 # 2
#   .word     evtSetAnimator | anmNone         # 3
#   .word     evtAddToForeground               # 4
#   .word     evtSaveObjSettings | 9           # 5

    # Add To Background
    .word 0, evtAddToBackground

    .word 0, evtSetProgMoveLife
    .word        prgBitShift
    .word        mveBackground | 0b1000
    .word        lifeImmortal

    .word 0, evtSingleSprite, sprSingleFrame | 0
    .byte 24+ 8, 24+ 160 -16 # Y, X : 8, 288

    # Castle
# defb 0,evtSetMoveLife ,%11000010,0  ; Move    / dir Left Slow ... Life - immortal
    .word 0, evtSetMoveLife, mveBackground | 0b0010, lifeImmortal

    .word 0, evtSingleSprite, sprSingleFrame | 4
    .byte 24+ 50,    24+ 120  # Y, X :  50, 240

    .word 0, evtSingleSprite, sprSingleFrame | 14
    .byte 24+ 40+90, 24+ 100  # Y, X : 130, 200

    .word 0, evtSingleSprite, sprSingleFrame | 13
    .byte 24+ 40+100, 24+ 90  # Y, X : 140, 180

    .word 0, evtSingleSprite, sprSingleFrame | 13
    .byte 24+ 40+100, 24+ 162 # Y, X : 140, 324
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
       #JMP  @$EndLevel
        CALL @$AkuYou_Player_GetPlayerVars

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        MOV  $Event_SavedSettingsB,R3 # Saved Settings
        CALL @$Event_StreamInit

      #.ppudo_ensure $PPU_LoadMusic,$TitleMusic
      #.ppudo_ensure $PPU_MusicRestart

        CALL ScreenBuffer_Init
       #ld (BackgroundFloodFillQuadSprite_Minus1+1),hl
       #ld (BackgroundSolidFillNextLine_Minus1+1),hl
        MTPS $PR0
LevelLoop:
        CALL @$Background_Draw

       #CALL @$EventStream_Process

       #CALL @$ObjectArray_Redraw

       #CALL Akuyou_Player_Handler

       #CALL AkuYou_Player_StarArray_Redraw

       #CALL Akuyou_StarArray_Redraw

       #CALL AkuYou_Player_DrawUI

       #CALL Akuyou_PlaySfx

       .equiv FadeCommand, .+2
        CALL @$null

        CALL @$ScreenBuffer_Flip

       #ld (BackgroundSolidFillNextLine_Minus1+1),hl
       #ld (BackgroundFloodFillQuadSprite_Minus1+1),hl

        JMP  @$LevelLoop

################################################################################
#                          Generic Background Begin                            #
################################################################################

Background_Draw:
#:bpt
        MOV  $0,R0                           # ld a,0  ;0=left 1=right ;2=static

        CALL @$Background_GradientScroll     # call Akuyou_Background_GradientScroll

        CALL @$Timer_UpdateTimer             # call Akuyou_Timer_UpdateTimer

                                             # push af ; need to keep the smartbomb color
        # WARNING: supposed to return current timer in I
        CALL @$Timer_GetTimer                # call Akuyou_Timer_GetTimer
        MOV  R0,@$srcBitShifter_TicksOccured # ld (BitshifterTicksOccured_Plus1 - 1),a

        MOV  @$ScreenBuffer_ActiveScreen, R5 # call Akuyou_ScreenBuffer_GetActiveScreen
                                             # ld h,a
                                             ##ifdef CPC320
                                             #     ld l,&4F+1
                                             ##else
                                             #      ld l,&40
                                             ##endif

                                             # pop af

                                             # or a
                                             # jp nz,Background_SmartBomb

       .equiv jmpBackgroundRender, .+2
        JMP  @$Background_DrawB              # jp Background_DrawB :BackgroundRender_Plus2


Background_DrawB:
        MOV  $GradientTop,R3                 #    ld de,GradientTop
        MOV  $GradientTopStart,R1            #    ld b,GradientTopStart
        MOV  $0b11111100,R2                  #    ld c,%11111100 ; Shift on Timer Ticks
                                             #
        CALL @$Background_Gradient           #    call Akuyou_Background_Gradient
                                             #
                                             #    ;Bottom
                                             #    ld a,0
                                             #    ld de,LevelTiles
                                             #    call GetSpriteMempos
                                             #    push de
                                             #        ld b,16 ;Lines
                                             #        call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL
                                             #
                                             #        ld de,&0000
                                             #        ld b,32
                                             #        call BackgroundSolidFill ;need pointer to sprite in HL
                                             #    pop de
                                             #    push de
                                             #
                                             #        ex hl,de        ;Move down 16 lines
                                             #            ld bc,8*16
                                             #            add hl,bc
                                             #        ex hl,de
                                             #        push de
                                             #
                                             #            ld b,16 ;Lines
                                             #
                                             #            call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL
                                             #
                                             #            ld de,&0000
                                             ##           ifdef CPC320
                                             #                ld b,200-48-16-32-16-8-32
                                             ##           else
                                             #                ld b,192-48-16-32-16-8-32
                                             ##           endif
                                             #            call BackgroundSolidFill ;need pointer to sprite in HL
                                             #

        MOV  @$ScreenBuffer_ActiveScreen, R5
        ADD  $13440,R5

        MOV  $GradientBottom,R3              #            ld de,GradientBottom
        MOV  $GradientBottomStart,R1         #            ld b,GradientBottomStart
        MOV  $0b11111111,R2                  #            ld c,%11111111      ;Shift on Timer Ticks
        CALL @$Background_Gradient           #            call Akuyou_Background_Gradient
                                             #
                                             #        pop de
                                             #
                                             #    ex hl,de        ;Move down 16 lines
                                             #        ld bc,8*16
                                             #        add hl,bc
                                             #    ex hl,de
                                             #
                                             #    ld b,8 ;Lines
                                             #
                                             #    call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL
                                             #
                                             #;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                             #;               Spectrum & CPC Tile Bitshifts (MSX doesn't need them)
                                             #;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                             #    pop de ;needed to keep this for the bitshifts
                                             #
                                             #    ld hl,0007 ; shift to the right of the sprite
                                             #    add hl,de
                                             #    ld a,%11111100 ;Shift on Timer Ticks
                                             #    ld b,&8     ; Bytes
                                             #    ld c,16     ;lines
                                             #
                                             #    call BitShifter ;need pointer to sprite in HL
                                             #
                                             #    ;must be byte aligned
                                             #    ld a,%11111110 ;Shift on Timer Ticks
                                             #    ld b,&8     ; Bytes
                                             #    ld c,16     ;lines
                                             #
                                             #    call BitShifter ;need pointer to sprite in HL
                                             #
                                             #    ;must be byte aligned - otherwise recalc!
                                             #;   ld a,2
                                             #;   ld de,LevelTiles
                                             #;   call GetSpriteMempos
                                             #;   ld hl,0007 ; shift to the right of the sprite
                                             #;   add hl,de
                                             #
                                             #    inc h   ;Bitshifter wraps on byte align, so manually recalc, or force a move every 32 lines
                                             #
                                             #    ld a,%11111111 ;Shift on Timer Ticks
                                             #    ld b,&8     ; Bytes
                                             #    ld c,8      ;lines
                                             #
                                             #    call BitShifter ;need pointer to sprite in HL
        RETURN                               #ret
                                             #
                                             #Background_SmartBomb:
                                             #    ld e,d
                                             #    jr Background_Fill
                                             #Background_Black:
                                             #    ld de,&0000
                                             #Background_Fill:
                                             ##   ifdef CPC320
                                             #        ld b,200
                                             ##   else
                                             #        ld b,192
                                             ##   endif
                                             #
                                             #    jp BackgroundSolidFill
                                             #

# CPC Background Data -------------------------------------------------------{{{
   .equiv GradientTopStart, 48 # lines count
GradientTop:
#    defb &F0,&F0                 ;1 first line
   .word 0xFF00, 0xFF00
#    defb GradientTopStart-10,&D0 ;2 line num, New byte
   .word GradientTopStart - 10, 0xDD00
#    defb GradientTopStart-16,&70 ;3
   .word GradientTopStart - 16, 0x7700
#    defb GradientTopStart-20,&A0 ;4
   .word GradientTopStart - 20, 0xAA00
#    defb GradientTopStart-26,&50 ;5
   .word GradientTopStart - 26, 0x5500
#    defb GradientTopStart-30,&80 ;6
   .word GradientTopStart - 30, 0x8800
#    defb GradientTopStart-36,&20 ;7
   .word GradientTopStart - 36, 0x2200
#    defb GradientTopStart-40,&00 ;8
   .word GradientTopStart - 40, 0x0000
#    defb GradientTopStart-46,&00 ;9
   .word GradientTopStart - 46, 0x0000
#    defb 255
   .word 0xFFFF

   .equiv GradientBottomStart, 32 # lines count
GradientBottom:
#    defb &0,&0  ;1; first line
   .word 0x0000, 0x0000
#    defb 26,&20 ;10
   .word 26, 0x2200
#    defb 22,&80 ;11
   .word 22, 0x8800
#    defb 18,&50 ;12
   .word 18, 0x5500
#    defb 14,&A0 ;13
   .word 14, 0xAA00
#    defb 10,&70 ;14
   .word 10, 0x7700
#    defb 6,&D0  ;15
   .word 6, 0xDD00
#    defb 4,&F0  ;15
   .word 4, 0xFF00
#    defb 2,&F0  ;15
   .word 2, 0xFF00
#    defb 255
   .word 0xFFFF

       .include "bit_shifter.s"

RealPalette: #---------------------------------------------------------------{{{
    .byte 0, 0    # line number, 0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, YRGB color
    .word 0b10100 #  320 dots per line, pallete 4

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0xEE, 0xDD, 0xFF

    .byte 201     #--line number, 201 - end of the main screen params
    .even
#-------------------------------------------------------------------------------
# for some reason GAS replaces the last byte with 0
# so we add the dummy word to avoid data/code corruption
       .word 0xFFFF
end:
               .nolist
