 ;Level fixes
; get rid of ORG statements
; apply new Init
;       call Akuyou_Interrupt_Init  instead of  call Akuyou_RasterColors_Init
;replace ld i,a

nolist

BuildLevel equ 1    ;We're building a level!
Read "..\Aku\Build.asm"

read "Eventstreamdefinitions.asm"
read "CoreDefs.asm"

;LevelDataStart equ &0000   ;Start of the data which is stored on disk

ZXS_CopiedBlockStart equ &F800
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                Start writing to disk for ZXS and MSX (Cpc ver is at EOF)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org Akuyou_LevelStart
list
;;;;;;;;;;;;;;;;;;; Sprite data must be at top of level code block
FileBeginLevel:
        incbin "..\ResCPC\LEVEL1A.SPR"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Animators
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AnimatorPointers:
    defw AnimatorData
AnimatorData:
    ; First byte is the 'Tick map' which defines when the animation should update
    defb %00000010     ;Anim Freq
    ; all remaining bytes are anim frames in the form Command-Var-Var-Var
    defb 01,128+01,0,0 ;Sprite Anim
    defb 01,128+02,0,0 ;Sprite Anim
    defb 00            ;End of loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Data Allocations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Event_SavedSettingsB:   ;2nd bank Saved settings array
    defs 128,&00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   EVENT STREAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EventStreamArray:

;defb 1,128,&24,128+64+60       ; Move Static

;We will use 4 Paralax layers
; ---------()- (sky)        %11001000
; ------------ (Far)        %11000100
; -----X---X-- (mid)        %11000010   Bank 1
; []=====[]=== (foreground)     %11000001   Bank 0

defb 0,evtReprogram_PowerupSprites,128+38,128+39,128+40,128+16 ; Define powerup sprites

defb 0,evtMultipleCommands+5
defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000001,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
defb evtSetObjectSize,0
defb evtSetAnimator,0
defb evtAddToBackground
defb evtSettingsBank_Save,0
                                ; Save Object settings to Bank 0
defb 0,evtMultipleCommands+5
defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000010,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
defb evtSetObjectSize,0
defb evtSetAnimator,0
defb evtAddToBackground
defb evtSettingsBank_Save,1    ; Save Object settings to Bank 1

; Rock Chick
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%01100000+11,&22,%11000000+1 ; Program - Fire Burst... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    evtSetSprite,128+   1  ; Sprite 1 Frame animater
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSettingsBank_Save,2 ; Save Object settings to Bank 2

; Skull bomber
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%00100000+22,&23,%11000000+4 ; Program - Fire Down Fast... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    evtSetSprite,128+   37 ; Sprite 1 Frame animater
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSettingsBank_Save,3 ; Save Object settings to Bank 2

; Ant Attacker
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%01100000+1,&23,%11000000+4 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSetSprite,128+   0  ; Sprite 1 Frame animater
defb    evtSettingsBank_Save,4 ; Save Object settings to Bank 2

; Skeleton Crawler
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%10000000+11,&22,%11000000+3    ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSetSprite,128+   36 ; Sprite 1 Frame animater
defb    evtSettingsBank_Save,5 ; Save Object settings to Bank 5

; SpliceFace
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%10000000+13,&25,%11000000+4    ; Program - Starburst ... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSetSprite,128+   34 ; Sprite 1 Frame animater
defb    evtSettingsBank_Save,6 ; Save Object settings to Bank 6

; BoniBurd
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%10000000+2,&22,%11000000+3 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSetSprite,128+   2  ; Sprite 1 Frame animater
defb    evtSettingsBank_Save,7

; Skull Gang
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%00100000+16,%10100001,%11000000+3  ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSetSprite,128+   35 ; Sprite 1 Frame animater
defb    evtSettingsBank_Save,8

; Eyeclopse
defb 0,evtMultipleCommands+5   ; 3 commands at the same timepoint
defb    evtSetProgMoveLife ,%01100000+11,%10101100,%11000000+3  ; Program - Fire Left... Move - wave 10101100 ... Hurt by bullets, hurts player, life 4
defb    evtSetAnimator,0
defb    evtAddToForeground
defb    evtSetSprite,128+   7  ; Sprite 1 Frame animater
defb    evtSettingsBank_Save,9

;Add To Background
defb 0,134

defb 0,evtSetProgMoveLife ,1,%11001000,0 ; Program - Bitshift Sprite... Move - dir Left Slowest ... Life - immortal
defb 0,0,   3,24+ 160 -16 ,24+ 8 ; single sprite

;Castle

defb 0,evtSetMoveLife ,%11000010,0  ; Move    / dir Left Slow ... Life - immortal
defb 0,0,   4,24+ 120  ,24+ 50      ; single sprite

defb 0,0,   14,24+ 100  ,24+ 40+80  ; single sprite

defb 0,0,   13,24+ 90  ,24+ 40+100  ; single sprite
defb 0,0,   13,24+ 162  ,24+ 40+100 ; single sprite

;Burning bloke
defb 0,evtMultipleCommands+3       ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1     ; Load Settings from bank 1
defb    129,0                      ; Change to program 0 (normal)
defb    0,128+  11,50+24,90+24  ;  ; Single Object sprite 11 (animated)

;Clouds (3 wide)
defb 0,evtMultipleCommands+6       ; 2 commands at the same timepoint
defb    evtAddToBackground
defb    evtSetProgMoveLife, 0, %11000100, 0 ; Move / dir Left Slow ... Life - immortal
defb    0, 41, 159+24, 10+28      ;  ; Single Object /
defb    0, 42, 159+24+12, 10+28   ;  ; Single Object /
defb    0, 43, 159+24+24, 10+28   ;  ; Single Object /
defb    evtAddToForeground

;Spikeyrock
defb 0,evtMultipleCommands+2       ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+0     ; Load Settings from bank 0
defb    48+2, 24+100, 24+24+128, 24, 8, 9 ; Three sprites,

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               Start of fade in block
FadeStartPoint equ 0    ;Start of fade point
            ; Fade lasts two timers - ends FadeStartPoint+2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    defb FadeStartPoint+1,evtCallAddress
    defw     EnablePlusPalette

    ;BLUE COLORS - 6128
    defb FadeStartPoint+1,evtMultipleCommands+4 ; 4 Commands
    defb 240,0,6         ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    ;REAL LEVEL PALETTE

    defb FadeStartPoint+2,evtMultipleCommands+4         ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&55,&4A,&4B  ; Black,DkBlue,LtYellow,White

    defb 240,26*0+6,5*2+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 2  ; Switches
    defb 16 ;delay
    defb &54,&5D,&59,&4B
    defb 16 ;delay
    defb &54,&58,&5F,&4B

    defb 240,26*1+6,1     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0

    defb 240,26*2+6,5*2+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 2 ; no of switches
    defb 0  ;delays
    defb &54,&58,&53,&4B  ; Black,Red,Grey,White
    defb 32
    defb &54,&4C,&53,&4B  ; 5b

    defb FadeStartPoint+2,evtCallAddress
    defw RasterColorsStartPalleteFlip

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              End of fade in block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; rock chick enemy
defb 5,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2 ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

; Rock Pt 1
defb 10,evtMultipleCommands+2  ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+0 ; Load Settings from bank 0
defb    0,  22,160+24,172+28   ; Single Object /

;Cross
defb 13,evtMultipleCommands+2  ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1 ; Load Settings from bank 1
defb    0,17,160+24,110+24     ; Single Object sprite 11 (animated)

; rock chick enemy
defb 15,evtMultipleCommands+3  ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2 ; Load Settings from bank 2
defb    0+6                    ; Row 16, last Column, Last Sprite
defb    0+10                   ; Row 16, last Column, Last Sprite

; Rock Pt 2
defb 16,evtMultipleCommands+2  ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+0 ; Load Settings from bank 0
defb    0,  23,160+24,172+28   ; Single Object /

; Powerup Rate
defb 17,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSetProgMoveLife ,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    0,128+ 39,160+24,50+24  ;   ; Single Object sprite 11 (animated)

; Rock Pt 3
defb 22,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+0  ; Load Settings from bank 0
defb    0,  24,160+24,172+28    ; Single Object /

; rock chick enemy
defb 25,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2  ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

;; rock chick enemy
defb 30,evtMultipleCommands+3   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2  ; Load Settings from bank 2
defb    0+6                     ; Row 16, last Column, Last Sprite
defb    0+10                    ; Row 16, last Column, Last Sprite

; rock chick enemy
defb 35,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2  ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

;Cross
defb 40,evtMultipleCommands+2   ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1  ; Load Settings from bank 1
defb    0,18,160+24,85+24   ;   ; Single Object sprite 11 (animated)

;Skull Bomber
defb 45,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+3  ; Load Settings from bank 3
defb    0+3             ; Row 16, last Column, Last Sprite

;Ant
defb 45,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+4  ; Load Settings from bank 4
defb    0+12                    ; Row 16, last Column, Last Sprite

;Burning bloke
defb 55,evtMultipleCommands+3   ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1  ; Load Settings from bank 1
defb    129,0                   ; Change to program 0 (normal)
defb    0,128+  11,160+24,90+24 ;   ; Single Object sprite 11 (animated)

; Boniburd
defb 65,evtMultipleCommands+2   ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+7  ; Load Settings from bank 5
defb    evtSingleSprite,TwoFrameSprite+ 2,160+24-24,24+16

;  SpikyRock
defb 67,evtMultipleCommands+2    2 commands at the same timepoint
defb    evtSettingsBank_Load+0   Load Settings from bank 0
defb    48+   3   ,160+24,24+ 128,24,       8,9,10 ; Three sprites,

; rock chick enemy
defb 75,evtMultipleCommands+2           ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

; rock chick enemy
defb 80,evtMultipleCommands+3           ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+6             ; Row 16, last Column, Last Sprite
defb    0+10                ; Row 16, last Column, Last Sprite

; boniburd
defb 84,evtMultipleCommands+2           ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+7              ; Load Settings from bank 5
defb    evtSingleSprite,TwoFrameSprite+ 2,160+24-24,24+16

;Skeleton walker
defb 85,evtMultipleCommands+2           ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+5              ; Load Settings from bank 5
defb    0+13                ; Row 16, last Column, Last Sprite

;Cross
defb 88,evtMultipleCommands+2           ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
defb    0,18,160+24,85+24   ;   ; Single Object sprite 11 (animated)

; Powerup Drone
defb 90,evtMultipleCommands+2           ; 2 commands at the same timepoint
defb    evtSetProgMoveLife ,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    0,128+ 38,160+24,150+24 ;   ; Single Object sprite 11 (animated)

;Grave
defb 95,evtMultipleCommands+2       ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+0              ; Load Settings from bank
defb    0,21,160+24,170+24  ;   ; Single Object sprite 11 (animated)

; SpliceFace
defb 100,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+6              ; Load Settings from bank 6
defb    0,128+34,24,100+24  ;   ; Single Object /

; rock chick enemy
defb 110,evtMultipleCommands+3          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+6             ; Row 16, last Column, Last Sprite
defb    0+10                ; Row 16, last Column, Last Sprite

; rock chick enemy
defb 115,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

;Clouds (3 wide)
defb 120,evtMultipleCommands+4          ; 2 commands at the same timepoint
defb    evtSetProgMoveLife ,0,%11000100,0           ; Move    / dir Left Slow ... Life - immortal
defb    0, 41,159+24,10+28  ;   ; Single Object /
defb    0, 42,159+24+12,10+28   ;   ; Single Object /
defb    0, 43,159+24+24,10+28   ;   ; Single Object /

; rock chick enemy
defb 120,evtMultipleCommands+3          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+6             ; Row 16, last Column, Last Sprite
defb    0+10                ; Row 16, last Column, Last Sprite

;Grave
defb 122,evtMultipleCommands+2          ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+0              ; Load Settings from bank
defb    0,21,160+24,170+24  ;   ; Single Object sprite 11 (animated)

; rock chick enemy
defb 125,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

; rock chick enemy
defb 127,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

;Burning bloke
defb 129,evtMultipleCommands+3          ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
defb    129,0                   ; Change to program 0 (normal)
defb    0,128+  11,160+24,90+24 ;   ; Single Object sprite 11 (animated)

; rock chick enemy
defb 130,evtMultipleCommands+3          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+6             ; Row 16, last Column, Last Sprite
defb    0+10                ; Row 16, last Column, Last Sprite

; rock chick enemy
defb 135,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

;Cross
defb 140,evtMultipleCommands+2          ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
defb    0,19,160+24,103+24  ;   ; Single Object sprite 11 (animated)

; SpliceFace
defb 150,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+6              ; Load Settings from bank 6
defb    0,128+34,24,100+24  ;   ; Single Object /

; Powerup Drone
defb 150,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSetProgMoveLife ,3,&22,64+63 ; Program - Bitshift Sprite... Move - dir Left Slow ... Hurt by bullets, hurts player, life 4
defb    0,128+ 38,160+24,150+24 ;   ; Single Object sprite 11 (animated)

; Eyeclopse s
defb 160,evtMultipleCommands+4          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+9              ; Load Settings from bank 5
defb    0+7
defb    131,%10101111               ; change Move
defb    0+12

; rock chick enemy
defb 165,evtMultipleCommands+3          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+6             ; Row 16, last Column, Last Sprite
defb    0+10                ; Row 16, last Column, Last Sprite

;Grave
defb 167,evtMultipleCommands+2          ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+0              ; Load Settings from bank
defb    0,20,160+24,173+24  ;   ; Single Object sprite 11 (animated)

; rock chick enemy
defb 170,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2              ; Load Settings from bank 2
defb    0+8             ; Row 16, last Column, Last Sprite

; Eyeclopse s
defb 180,evtMultipleCommands+4          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+9              ; Load Settings from bank 5
defb    0+7
defb    131,%10101111               ; change Move
defb    0+12

;Cross
defb 185,evtMultipleCommands+2          ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+1              ; Load Settings from bank 1
defb    0,19,160+24,107+24  ;   ; Single Object sprite 11 (animated)

; Skull Gang
defb 190,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+8              ; Load Settings from bank 5
defb    0+7

;Clouds (3 wide)
defb 200,evtMultipleCommands+4  ; 2 commands at the same timepoint
defb    evtSetProgMoveLife ,0,%11000100,0 ; Move / dir Left Slow ... Life - immortal
defb    0, 41,159+24,10+28  ;   ; Single Object /
defb    0, 42,159+24+12,10+28   ;   ; Single Object /
defb    0, 43,159+24+24,10+28   ;   ; Single Object /

; rock chick enemy
defb 200,evtMultipleCommands+3 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+2 ; Load Settings from bank 2
defb    0+6                    ; Row 16, last Column, Last Sprite
defb    0+10                   ; Row 16, last Column, Last Sprite

; boniburd
defb 220,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+7 ; Load Settings from bank 5
defb    evtSingleSprite,TwoFrameSprite+ 2,160+24-24,24+16

;Skeleton walker
defb 220,evtMultipleCommands+2          ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+5              ; Load Settings from bank 5
defb    0+13                ; Row 16, last Column, Last Sprite

;Grave
defb 221,evtMultipleCommands+2 ; 3 commands at the same timepoint
defb    evtSettingsBank_Load+0 ; Load Settings from bank
defb    0,20,160+24,176+24  ;  ; Single Object sprite 11 (animated)

;Skull Bomber
defb 225,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+3 ; Load Settings from bank 3
defb    0+3                    ; Row 16, last Column, Last Sprite

;Ant
defb 225,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+4 ; Load Settings from bank 4
defb    0+12                   ; Row 16, last Column, Last Sprite

; SpliceFace
defb 230,evtMultipleCommands+4 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+6 ; Load Settings from bank 6
defb    %10000011,&23          ; Change Move
defb    0,128+34,24,50+24   ;  ; Single Object /
defb    0,128+34,24,150+24  ;  ; Single Object /

; SpliceFace
defb 232,evtMultipleCommands+3 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+6 ; Load Settings from bank 6
defb    0,128+34,24,50+24   ;  ; Single Object /
defb    0,128+34,24,150+24  ;  ; Single Object /

;Skull Bomber
defb 235,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+3 ; Load Settings from bank 3
defb    0+3                    ; Row 16, last Column, Last Sprite

;Ant
defb 235,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+4 ; Load Settings from bank 4
defb    0+12                   ; Row 16, last Column, Last Sprite

;Skull Bomber
defb 245,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+3 ; Load Settings from bank 3
defb    0+3                    ; Row 16, last Column, Last Sprite

;Ant
defb 245,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSettingsBank_Load+4 ; Load Settings from bank 4
defb    0+12                   ; Row 16, last Column, Last Sprite

defb 250,evtMultipleCommands+2 ; 2 commands at the same timepoint
defb    evtSetProgMoveLife ,0,%11000100,0           ; Move    / dir Left Slow ... Life - immortal
defb    0, 43,160+24,10+28  ;   ; Single Object /

defb 5,%10001001            ;Call a memory location
defw    ClearBadguys
;Palette Change
LevelEndAnim:
defb 5,evtMultipleCommands+2            ; 3 commands at the same timepoint
defb evtSetProgMoveLife,prgMovePlayer,&24,10
defb    0,128+  47,140+24,100+24    ;   ; Single Object sprite 11 (animated)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FadeOutStartPoint equ 5
;               Start of fade out block
;               Fade out ends at FadeutStart+2, eg if FadeOut=5 then ends at 7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;CPC Plus
    defb FadeOutStartPoint,evtCallAddress
    defw FadeOut

    ;Blue 6128

    defb FadeOutStartPoint+1,evtMultipleCommands+4          ; 4 Commands
    defb 240,0,6                ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6               ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    ;Black 6128
    defb FadeOutStartPoint+2,evtMultipleCommands+4          ; 4 Commands
    defb 240,0,6                ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*0+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*1+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*2+6,6       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               End of fade out block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

defb 8,evtCallAddress           ;Call a memory location
defw    EndLevel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               Level Init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LevelInit:
    call AkuYou_Player_GetPlayerVars

    ld a,(iy-5)
    ld hl,null
    cp 64
    jp nz,LevelInitUsingRasterFlip
    ld (DisablePaletteSwitcher_Plus2-2),hl
LevelInitUsingRasterFlip:
    call RasterColorsSetPalette1

    ld hl,EventStreamArray      ;Event Stream
    ld de,Event_SavedSettingsB  ;Saved Settings bank 2
    call AkuYou_Event_StreamInit

    ;;;;;;;;;;;;;;;;;;;;;; Restart the Music ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    call Akuyou_Music_Restart

    call Akuyou_ScreenBuffer_Init

    ld (BackgroundFloodFillQuadSprite_Minus1+1),hl
    ld (BackgroundSolidFillNextLine_Minus1+1),hl

    call Akuyou_Interrupt_Init

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               Level Loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LevelLoop:
    call Background_Draw

    call Akuyou_EventStream_Process

    call Akuyou_ObjectArray_Redraw

    call Akuyou_Player_Handler

    call AkuYou_Player_StarArray_Redraw

    call Akuyou_StarArray_Redraw

    call AkuYou_Player_DrawUI

    call Akuyou_PlaySfx

ifdef Debug_ShowLevelTime
    call ShowLevelTime
endif

    call null   :FadeCommand_Plus2  ; also MSX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    call Akuyou_ScreenBuffer_Flip

    ld (BackgroundSolidFillNextLine_Minus1+1),hl
    ld (BackgroundFloodFillQuadSprite_Minus1+1),hl

    jp LevelLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           Level Shutdown code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearBadguys:
    ld a,64
    ld (PaletteNo_Plus1-1),a    ; turn off the alternate palette

    ld a,1
    ld i,a
    push hl
    call Akuyou_DoSmartBombCall
    pop hl
ret

EndLevel:
    pop hl  ;
    ld hl,  &0102               ;load level 2
    jp  Akuyou_ExecuteBootStrap ; Start the game, no return
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           Level specific code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ifdef Debug_ShowLevelTime
    read "..\SrcALL\Akuyou_Multiplatform_Level_GenericDebuggingTools.asm"
endif

    read "..\SrcCPC\Akuyou_CPC_Level_GenericRasterSwitcher.asm"
    read "CoreBackground_SolidFill.asm"
    read "CoreBackground_QuadSprite.asm"
    read "CoreBackground_bitshifter.asm"
    read "CoreBackground_GetSpriteMemPos.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This block is copied to bank 7 on the speccy, and contains graphics for the background
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    align 256
LevelTiles:
    incbin "..\ResCPC\Level01-Tiles.SPR"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Generic Background Begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Background_Draw:
    ld a,0  ;0=left 1=right ;2=static
    call Akuyou_Background_GradientScroll

    call Akuyou_Timer_UpdateTimer

    push af ; need to keep the smartbomb color

    call Akuyou_Timer_GetTimer
    ld (BitshifterTicksOccured_Plus1-1),a

    call Akuyou_ScreenBuffer_GetActiveScreen
    ld h,a
    ifdef CPC320
        ld l,&4F+1
    else
         ld l,&40
    endif

    pop af

    or a
    jp nz,Background_SmartBomb

    jp Background_DrawB :BackgroundRender_Plus2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               SPECCY and CPC background
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    GradientTopStart equ 48

Background_DrawB:
    ld de,GradientTop
    ld b,GradientTopStart
    ld c,%11111100      ;Shift on Timer Ticks

    call Akuyou_Background_Gradient

    ;Bottom
    ld a,0
    ld de,LevelTiles
    call GetSpriteMempos
    push de
        ld b,16 ;Lines
        call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL

        ld de,&0000
        ld b,32
        call BackgroundSolidFill ;need pointer to sprite in HL
    pop de
    push de

        ex hl,de        ;Move down 16 lines
            ld bc,8*16
            add hl,bc
        ex hl,de
        push de

            ld b,16 ;Lines

            call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL

            ld de,&0000
            ifdef CPC320
                ld b,200-48-16-32-16-8-32
            else
                ld b,192-48-16-32-16-8-32
            endif
            call BackgroundSolidFill ;need pointer to sprite in HL

            GradientBottomStart equ 32
            ld de,GradientBottom
            ld b,GradientBottomStart
            ld c,%11111111      ;Shift on Timer Ticks
            call Akuyou_Background_Gradient

        pop de

    ex hl,de        ;Move down 16 lines
        ld bc,8*16
        add hl,bc
    ex hl,de

    ld b,8 ;Lines

    call BackgroundFloodFillQuadSprite ;need pointer to sprite in HL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               Spectrum & CPC Tile Bitshifts (MSX doesn't need them)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    pop de ;needed to keep this for the bitshifts

    ld hl,0007 ; shift to the right of the sprite
    add hl,de
    ld a,%11111100 ;Shift on Timer Ticks
    ld b,&8     ; Bytes
    ld c,16     ;lines

    call BitShifter ;need pointer to sprite in HL

    ;must be byte aligned
    ld a,%11111110 ;Shift on Timer Ticks
    ld b,&8     ; Bytes
    ld c,16     ;lines

    call BitShifter ;need pointer to sprite in HL

    ;must be byte aligned - otherwise recalc!
;   ld a,2
;   ld de,LevelTiles
;   call GetSpriteMempos
;   ld hl,0007 ; shift to the right of the sprite
;   add hl,de

    inc h   ;Bitshifter wraps on byte align, so manually recalc, or force a move every 32 lines

    ld a,%11111111 ;Shift on Timer Ticks
    ld b,&8     ; Bytes
    ld c,8      ;lines

    call BitShifter ;need pointer to sprite in HL
ret

Background_SmartBomb:
    ld e,d
    jr Background_Fill
Background_Black:
    ld de,&0000
Background_Fill:
    ifdef CPC320
        ld b,200
    else
        ld b,192
    endif

    jp BackgroundSolidFill

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   CPC Background Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GradientTop:
    defb &F0,&F0    ;1; first line
    defb GradientTopStart-10,&D0    ;2; line num, New byte
    defb GradientTopStart-16,&70    ;3
    defb GradientTopStart-20,&A0    ;4
    defb GradientTopStart-26,&50    ;5
    defb GradientTopStart-30,&80    ;6
    defb GradientTopStart-36,&20    ;7
    defb GradientTopStart-40,&00    ;8
    defb GradientTopStart-46,&00    ;9
    defb 255

GradientBottom:
    defb &0,&0  ;1; first line
    defb 26,&20 ;10
    defb 22,&80 ;11
    defb 18,&50 ;12
    defb 14,&A0 ;13
    defb 10,&70 ;14
    defb 6,&D0  ;15
    defb 4,&F0  ;15
    defb 2,&F0  ;15
    defb 255

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;          CPC Raster Pallete
;;  The core is full, so this is now stored in the level block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RasterColors_ColorArray1:
    defb 1
    defb 1
    defb &54,&54,&54,&54
RasterColors_ColorArray2:
    defb 1
    defb 1
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 12
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
RasterColors_ColorArray3:
    defb 1
    defb 1
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
RasterColors_ColorArray4:
    defb 1
    defb 1
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54
    defb 0
    defb &54,&54,&54,&54

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   2nd page flipped palette used on regular CPC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RasterColors_ColorArray1Alt:
    defb 1
    defb 1
    defb &54,&55,&4A,&4B        ;Black,DkBlue,LtYellow,White
RasterColors_ColorArray2Alt:
    defb 2  ; Switches
    defb 16 ;delay
    defb &54,&5D,&59,&4B
    defb 16 ;delay
    defb &54,&58,&5F,&4B
RasterColors_ColorArray3Alt:
    defb 0
;   defb 1
;   defb &54,&54,&54,&54         :IlluminatedPaletteCAlt_Plus2
RasterColors_ColorArray4Alt:
    defb 2 ; no of switches
    defb 0  ;delays
    defb &54,&58,&51,&4B        ;Black,Red,Grey,White
    defb 32
    defb &54,&4C,&51,&4B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   CPC Plus Palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PaletteInit:        ;The palette when the level starts (black)
         ;0GRB
    defb 25
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 50
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 75
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 100
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 125
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 150
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 175
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 200
    defw &0000
    defw &0000
    defw &0000
    defw &0000
         ;0GRB

PaletteDest:    ;The 'Normal' level palette
         ;0GRB
    defb 25
    defw &0000
    defw &004C
    defw &0CC0
    defw &0FFB
    defb 50
    defw &0000
    defw &000F
    defw &0FF0
    defw &0FFD
    defb 75
    defw &0000
    defw &002B
    defw &0BB4
    defw &0FFF
    defb 100
    defw &0000
    defw &0059
    defw &0998
    defw &0EFF
    defb 125
    defw &0000
    defw &0077
    defw &088F
    defw &0EFF
    defb 150
    defw &0000
    defw &0088
    defw &090F
    defw &0EFF
    defb 175
    defw &0000
    defw &00B4
    defw &0A0A
    defw &0FCF
    defb 200
    defw &0000
    defw &00F4
    defw &0A0B
    defw &0FBF
         ;0GRB

    FadeDone:
        ld hl,null
        ld (FadeCommand_Plus2-2),hl
    ret
    FadeOut:    ;Need to protect everything - as this is called from the main Event loop
        push hl
            ld hl,PaletteInit
            call SetFader
        pop hl
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           LEVEL JUMPBLOCK - Don't mess with anything here!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LevelJumpBlock:
    defs FileBeginLevel+&3FF0-LevelJumpBlock
        jp LevelInit; - Level Start &3ff0
        jp LevelLoop; - Level loop &3ff3
    FileEndLevel:

limit &FFFF

save direct "T10-SC1.D01",FileBeginLevel,FileEndLevel-FileBeginLevel    ;address,size...}[,exec_address]
