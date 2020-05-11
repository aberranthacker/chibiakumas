nolist

BuildLevel equ 1 ; We're building a level!

Read "..\Aku\Build.asm"

NoPaletteDest equ 1

read "Eventstreamdefinitions.asm"
read "CoreDefs.asm"

LevelDataStart equ &0000 ;Start of the data which is stored on disk

org Akuyou_LevelStart
;LevelOrigin
FileBeginLevel: incbin "Sprites\TITLETEX.SPR"

CustomRam: defs 64 ; Pos-Tick-Pos-Tick ; enough memory for 16 enemies!

ifdef CompileEP2 ; {{{
EventStreamArray_EP2:
    ; Load Palette
    defb 0,%01110000+4          ; 4 Commands
    defb 240,0,6                ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&4F,&59,&4B

    defb 240,26*0+6,5*2+1       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 2  ; Switches
    defb 190;delay
    defb &54,&58,&5F,&4B
    defb 88;90;delay
    defb &54,&47,&5F,&4B

    defb 240,26*1+6,5*2+1       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 2
    defb 22
    defb &54,&58,&5F,&4B
    defb 215
    defb &54,&47,&4D,&4B

    defb 240,26*2+6,5*3+1       ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 3 ; no of switches
    defb 0  ;delays
    defb &54,&47,&4D,&4B
    defb 255    ;delays
    defb &54,&47,&4D,&4B
    defb 50     ;delays
    defb &54,&47,&4A,&4B

defb 4
    defb 136        ; Jump to a different level point
    defw PauseLoop  ; pointer
    defb 60         ; new time
endif ; }}}

EventStreamArray_EP1: ;------------------------------------------------------{{{
    ; Load Palette
    defb 0,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&55,&4C,&4B

    defb 240,26*0+6,5*2+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 2     ; Switches
    defb 0     ; delay
    defb &54,&55,&4C,&4B
    defb 64+16 ; delay
    defb &54,&58,&5F,&4B

    defb 240,26*1+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 48
    defb &54,&56,&5B,&4B

    defb 240,26*2+6,5*3+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 3   ; no of switches
    defb 0   ; delays
    defb &54,&56,&5B,&4B
    defb 255 ; delays
    defb &54,&4C,&4D,&4B
    defb 36  ; delays
    defb &54,&56,&5B,&4B

defb 4
    defb 136        ; Jump to a different level point
    defw PauseLoop  ; pointer
    defb 60         ; new time
;----------------------------------------------------------------------------}}}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                          CPC Raster Pallete                                ;;
;;        The core is full, so this is now stored in the level block          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PaletteInit:        ;The palette when the level starts (black) {{{
         ;0GRB
    defb 15
    defw &0000
    defw &000F
    defw &08F8
    defw &0FFB
    defb 30
    defw &0000
    defw &003F
    defw &02F2
    defw &0EEB
    defb 45
    defw &0000
    defw &006B
    defw &00D0
    defw &0DDF
    defb 100
    defw &0000
    defw &0077
    defw &0F4F
    defw &0EEE
    defb 140
    defw &0000

    defw &0608
    defw &0E2C

    defw &0EEE
    defb 200-16-2
    defw &0000

    defw &0408
    defw &0b2f

    defw &FFFF
    defb 200-8-2
    defw &0000
    defw &00F0
    defw &0FF0
    defw &FFFF
    defb 200
    defw &0000

    defw &0408
    defw &0b2f

    defw &FFFF

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
    defb &54,&55,&4C,&4B
RasterColors_ColorArray2Alt:
    defb 2  ; Switches
    defb 32 ; delay
    defb &54,&58,&5C,&4B
    defb 64+16-32 ; delay
    defb &54,&5D,&53,&4B
RasterColors_ColorArray3Alt:
    defb 2
    defb 48
    defb &54,&46,&5B,&4B
    defb 128
    defb &54,&46,&5a,&4B
RasterColors_ColorArray4Alt:
    defb 3  ; no of switches
    defb 0  ; delays
    defb &54,&46,&5A,&4B
    defb 255    ;delays
    defb &54,&4C,&4D,&4B
    defb 36 ; delays
    defb &54,&46,&5A,&4B
; }}}

ifdef CompileEP1 ; {{{
    EventStreamArray_Menu_EP1:

    ;defb 1,128,&24,128+64+60       ; Move Static

    defb 0,%01110000+4          ; 4 Commands
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

        defb 0,evtCallAddress
        defw SetFaderEP1Menu

    ; We will use 4 Paralax layers
    ;  ---------()- (sky)        %11001000
    ;  ------------ (Far)        %11000100
    ;  -----X---X-- (mid)        %11000010   Bank 1
    ;  []=====[]=== (foreground) %11000001   Bank 0

    ; Background L
    defb 0,128+4,1,%11000001,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
    defb 0,%10010000+15,0      ; Save Object settings to Bank 0

    defb 0,128+4,1,%11000010,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
    defb 0,%10010000+15,1      ; Save Object settings to Bank 1

    defb 0,128+4,0,&24,0       ; Static object
    defb 0,%10010000+15,2      ; Save Object settings to Bank 2

    ;Title
    defb 0,%01110000+7          ; 3 commands at the same timepoint
    defb %10010000+0+2          ; Load Settings from bank 2
    defb 0,12,12*0+ 24+44,24+16 ; Single Object sprite 11 (animated)
    defb 0,13,12*1+ 24+44,24+16 ; Single Object sprite 11 (animated)
    defb 0,14,12*2+ 24+44,24+16 ; Single Object sprite 11 (animated)
    defb 0,15,12*3+ 24+44,24+16 ; Single Object sprite 11 (animated)
    defb 0,16,12*4+ 24+44,24+16 ; Single Object sprite 11 (animated)
    defb 0,17,12*5+ 24+44,24+16 ; Single Object sprite 11 (animated)

    ;Chibiko
    defb 0,%01110000+3      ; 3 commands at the same timepoint
    defb %10010000+0+2      ; Load Settings from bank 2
    defb 0,0,12*0+ 24,24+64 ; Single Object sprite 11 (animated)
    defb 0,1,12*1+ 24,24+64 ; Single Object sprite 11 (animated)

    ;Bochan!
    defb 0,%01110000+3                 ; 3 commands at the same timepoint
    defb %10010000+0+2                 ; Load Settings from bank 2
    defb 0,2,12*0+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)
    defb 0,3,12*1+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)

    ;Palette Change
    defb 1,%01110000+4      ; 4 Commands
        defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
        defb 1
        defb 1
        defb &54,&54,&44,&40

        defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
        defb 1
        defb 1
        defb &54,&54,&44,&40

        defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
        defb 0
        defb 1
        defb &54,&54,&44,&40

        defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
        defb 1
        defb 1
        defb &54,&54,&44,&40
endif ; }}}
ifdef CompileEP2 ; {{{
YumiYume_Menu_EP2:

defb 0,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54


; We will use 4 Paralax layers
;  ---------()- (sky)        %11001000
;  ------------ (Far)        %11000100
;  -----X---X-- (mid)        %11000010   Bank 1
;  []=====[]=== (foreground) %11000001   Bank 0

; Background L
defb 0,evtMultipleCommands+5
; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000001,0
defb evtSetObjectSize,0
defb evtSetAnimator,0
defb evtAddToBackground
defb evtSettingsBank_Save,0

defb 0,evtMultipleCommands+5 ; Save Object settings to Bank 0
; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
defb evtSetProgMoveLife,PrgBitShift,mveBackground+%00000010,0
defb evtSetObjectSize,0
defb evtSetAnimator,0
defb evtAddToBackground
defb evtSettingsBank_Save,1  ; Save Object settings to Bank 1

defb 0,128+4,0,&24,0         ; Static object
defb 0,%10010000+15,2        ; Save Object settings to Bank 2

;Title
defb 0,%01110000+7 ; 3 commands at the same timepoint
defb %10010000+0+2 ; Load Settings from bank 2
defb 0,6+12,12*0+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+13,12*1+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+14,12*2+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+15,12*3+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+16,12*4+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+17,12*5+ 24+44,24+16 ; Single Object sprite 11 (animated)

;Yumi
defb 0,%01110000+3 ; 3 commands at the same timepoint
defb %10010000+0+2 ; Load Settings from bank 2
defb 0,4,12*0+ 24,24+64+8 ; Single Object sprite 11 (animated)
defb 0,5,12*1+ 24,24+64+8 ; Single Object sprite 11 (animated)

;Yume
defb 0,%01110000+3 ; 3 commands at the same timepoint
defb %10010000+0+2 ; Load Settings from bank 2
defb 0,6,12*0+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)
defb 0,7,12*1+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)

;Palette Change
defb 1,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    ; Load Palette
    defb 2,%01110000+4   ; 4 Commands
    defb 240,0,6         ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&43,&47,&4B ;Black,DkBlue,LtYellow,White

    defb 240,26*0+6,5*4+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 4  ; Switches
    defb 16 ;delay
    defb &54,&4A,&4F,&4B
    defb 96;delay
    defb &54,&5E,&4F,&4B
    defb 64;delay
    defb &54,&47,&5F,&4B
    defb 100;delay
    defb &54,&47,&5F,&4B

    defb 240,26*1+6,5*2+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 2
    defb 32;delay
    defb &54,&47,&5F,&4B
    defb 245
    defb &54,&47,&4D,&4B

    defb 240,26*2+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0 ; no of switches
    defb 0  ;delays
    defb &54,&47,&4D,&4B

defb 4
    defb 136              ; Jump to a different level point
    defw PauseLoop        ; pointer
    defb 60


EventStreamArray_Menu_EP2: ;-------------------------------------------------{{{
defb 0,%01110000+4        ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*0+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54


; We will use 4 Paralax layers
;  ---------()- (sky)        %11001000
;  ------------ (Far)        %11000100
;  -----X---X-- (mid)        %11000010   Bank 1
;  []=====[]=== (foreground)     %11000001   Bank 0

; Background L
defb 0,128+4,1,%11000001,0          ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
defb 0,%10010000+15,0               ; Save Object settings to Bank 0

defb 0,128+4,1,%11000010,0          ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
defb 0,%10010000+15,1               ; Save Object settings to Bank 1

defb 0,128+4,0,&24,0                ; Static object
defb 0,%10010000+15,2               ; Save Object settings to Bank 2

;Title
defb 0,%01110000+7 ; 3 commands at the same timepoint
defb %10010000+0+2 ; Load Settings from bank 2
defb 0,6+12,12*0+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+13,12*1+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+14,12*2+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+15,12*3+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+16,12*4+ 24+44,24+16 ; Single Object sprite 11 (animated)
defb 0,6+17,12*5+ 24+44,24+16 ; Single Object sprite 11 (animated)

;Chibiko
defb 0,%01110000+3 ; 3 commands at the same timepoint
defb %10010000+0+2 ; Load Settings from bank 2
defb 0,0,12*0+ 24+12,24+65 ; Single Object sprite 11 (animated)
defb 0,1,12*1+ 24+12,24+65 ; Single Object sprite 11 (animated)

;Bochan!
defb 0,%01110000+3 ; 3 commands at the same timepoint
defb %10010000+0+2 ; Load Settings from bank 2
defb 0,2,12*0+ 24+160-24-12,24+200-64 ; Single Object sprite 11 (animated)
defb 0,3,12*1+ 24+160-24-12,24+200-64 ; Single Object sprite 11 (animated)

;Palette Change
defb 1,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

; Load Palette
    defb 2,%01110000+4  ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&43,&47,&4B ;Black,DkBlue,LtYellow,White

    defb 240,26*0+6,5*4+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 4  ; Switches
    defb 16 ;delay
    defb &54,&4A,&4F,&4B
    defb 128;delay
    defb &54,&5E,&4F,&4B
    defb 24;delay
    defb &54,&58,&4C,&4B
    defb 110;140;delayw
    defb &54,&58,&5B,&4B

    defb 240,26*1+6,5*4+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 4
    defb 18
    defb &54,&58,&5B,&4B
    defb 72
    defb &54,&40,&5B,&4B
    defb 60
    defb &54,&40,&5F,&4B
    defb 70
    defb &54,&40,&47,&59  ;Black,Red,Grey,White

    defb 240,26*2+6,5*3+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 3 ; no of switches
    defb 0  ;delays
    defb &54,&40,&47,&59  ;Black,Red,Grey,White
    defb 255
    defb &54,&40,&47,&59
    defb 32
    defb &54,&40,&4E,&4A  ;defb &54,&4C,&4E,&49

defb 4
    defb 136              ; Jump to a different level point
    defw PauseLoop        ; pointer
    defb 60
endif ; ifdef CompileEP2 }}}

; Load Palette
    defb 2,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&4D,&4A,&4B  ; Black, DkBlue, LtYellow, White

    defb 240,26*0+6,5*4+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 4   ; Switches
    defb 16  ; delay
    defb &54,&4C,&5B,&4B
    defb 128 ; delay
    defb &54,&5C,&5B,&4B
    defb 32  ; delay
    defb &54,&58,&4C,&4B
    defb 100 ; delay
    defb &54,&58,&5B,&4B

    defb 240,26*1+6,5*3+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 3
    defb 18
    defb &54,&58,&5B,&4B
    defb 72
    defb &54,&40,&5B,&4B
    defb 60
    defb &54,&40,&5F,&4B

    defb 240,26*2+6,5*3+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 3                ; no of switches
    defb 0                ; delays
    defb &54,&40,&47,&59  ; Black,Red,Grey,White
    defb 255
    defb &54,&40,&47,&59
    defb 32
    defb &54,&40,&4E,&4A

defb 4
    defb 136       ; Jump to a different level point
    defw PauseLoop ; pointer
    defb 60        ; new time
;----------------------------------------------------------------------------}}}

Safepalette: ;---------------------------------------------------------------{{{
defb 1,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 1,evtCallAddress
    defw SetFaderRegular

;Palette Change
defb 2,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

defb 3,%01110000+4       ; 4 Commands
    defb 240,0,6         ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&5D,&5B,&4B

    defb 240,26*0+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&5D,&5B,&4B

    defb 240,26*1+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&5D,&5B,&4B

    defb 240,26*2+6,6    ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&5D,&5B,&4B

defb 4
    defb 136       ; Jump to a different level point
    defw PauseLoop ; pointer
    defb 60        ; new time
;----------------------------------------------------------------------------}}}

PauseLoop:
defb 4
    defb 136       ; Jump to a different level point
    defw PauseLoop ; pointer
    defb 60        ; new time

EventStreamFadeOut: ;-------------------------------------------------------{{{
;Palette Change
defb 1,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 1,evtCallAddress
    defw SetFaderBlack

defb 2,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

defb 8,%10001001            ;Call a memory location
    defw    EndLevel
;----------------------------------------------------------------------------}}}
EndLevel:
    call &6969 :FadeOutJump_Plus2

ResetEventStream:
    push hl

        ld de,StarArrayPointer+1
        ld hl,StarArrayPointer
        ld bc,256*4
        ld (hl),0
    ldir
    pop hl

    ld de,Event_SavedSettings   ;Saved Settings
    call AkuYou_Event_StreamInit

ret

EventStreamArray_ContentWarning: ;-------------------------------------------{{{
defb 0,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&54,&54

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&54,&54

defb 1,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 1
    defb &54,&54,&44,&40

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&54,&44,&40

    defb 1,evtCallAddress
    defw SetFaderBlack

defb 2,%01110000+4      ; 4 Commands
    defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&47,&4D,&4B

    defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 1
    defb &54,&47,&4D,&4B

    defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 1
    defb 64
    defb &54,&55,&5F,&4B

    defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 1
    defb &54,&55,&5F,&4B

defb 4
    defb 136       ; Jump to a different level point
    defw PauseLoop ; pointer
    defb 60
;----------------------------------------------------------------------------}}}

ifdef CompileEP2 ; {{{
    ContentWarning0:
        db  3,""," "+&80
;                  .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                  .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db  2,"Welcome to Chibi Akumas Episode 2!"," "+&80
        db  3,""," "+&80

        db  5,"This game is an ADULT COMEDY,"," "+&80
        db  3,""," "+&80
        db  253,"It contains Explicit language, Violence"," "+&80
        db  253,"Black Comedy, and all kinds of Nastiness!"," "+&80
        db  3,""," "+&80
        db  1,"It is suitable for those over 18 years"," "+&80
        db  13,"of age only"," "+&80
        db  3,""," "+&80
        db 8, "Press Fire to Continu","e"+&80
        db &0
    ContentWarning1:
;                  .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                  .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db  4,"As it's your first time playing,"," "+&80
        db  253,"To confirm you are over 18 years of age"," "+&80

        db  4,"We have prepared the latest in"," "+&80
        db  253,"Psychometric testing to ensure you are"," "+&80
        db  1,"of the maturity and mental acumen to"," "+&80
        db  1,"handle the challenging themes of this"," "+&80
        db  11,"game responsibly!"," "+&80
;                  .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                  .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db  3,""," "+&80
        db  12,"Are you ready?"," "+&80

        db  4,"Answer the following Questions!"," "+&80
        db  3,""," "+&80
        db 8, "Press Fire to Continu","e"+&80
        db &0
    ContentWarning2:
;                      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db  3,"1. The meaning of life is..."," "+&80
        db  3,"   "," "+&80
        db  3," "," "+&80
;                  .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                  .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db  1,"A. Be nice to people... So you can get"," "+&80
        db  1,"   close enough to see their shock"," "+&80
        db  1,"   as you stab them in the back","!"+&80
        db  1,"B. There is only happiness in the"," "+&80
        db  1,"   afterlife! So you must collect souls"," "+&80
        db  1,"   who will be your slaves for eternity","!"+&80
        db  1,"C. ME! you are all puny puppets in my"," "+&80
        db  1,"   presence, who should dance and"," "+&80
        db  1,"   die for my amusement!"," "+&80
        db &0
    ContentWarning3:
        db  3,"2. Killing someone, and Drinking "," "+&80
        db  3,"   their Blood is... "," "+&80
        db  3," "," "+&80
        db  1,"A. The reason I have to take my my"," "+&80
        db  1,"   laundry to the Chinese laundrette"," "+&80
        db  1,"   across town"," "+&80
        db  1,"B. Something I would NEVER do again"," "+&80
        db  1,"   your honor!"," "+&80
        db  1,"   Not now I done found religion!"," "+&80
        db  1,"C. Stupid! everyone knows your victims"," "+&80
        db  1,"   need to be alive for the blood to"," "+&80
        db  1,"   give you eternal life!"," "+&80
        db &0
    ContentWarning4:
;                  .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                  .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db  3,"3. If someone betrayed me,"," "+&80
        db  3,"   I would... "," "+&80
        db  3," "," "+&80
        db  1,"A. Kill them, and put their head on"," "+&80
        db  1,"   a spike as a warning to others"," "+&80
        db  1,"   not to fuck with me"," "+&80
        db  1,"B. Take them apart an inch at a time"," "+&80
        db  1,"   so they feel as much pain as life"," "+&80
        db  1,"   could offer before they saw Hell"," "+&80
        db  1,"C. Spare them... So they could live to"," "+&80
        db  1,"   see me take out my brutal revenge"," "+&80
        db  1,"   on those they care about","!"+&80
        db &0
    ContentWarning5:
        db  3,""," "+&80
        db  1,"Uh, you got all those questions wrong!"," "+&80

        db  3,""," "+&80

        db  6,"Oh my god! you're a monster!"," "+&80
        db  4,"I'm glad you don't live near me."," "+&80

        db  1,""," "+&80
        db  7,"Seriously, You need help!"," "+&80
        db  1,""," "+&80

        db  1,"Well, I guess this game can't do YOU"," "+&80
        db  6,"any harm, so what the heck!"," "+&80
        db  3,""," "+&80
;                  .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;                  .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db 6, "Press Fire to play the game","!"+&80
        db &0

    ContentWarning:
        call AkuYou_Player_GetPlayerVars
        ld a,(iy-10)
        or %01000000
        ld (iy-10),a

        call Akuyou_RasterColors_Disable
        call Akuyou_ScreenBuffer_Reset
        call Akuyou_Firmware_Restore

        ld a,&C0
        ld hl,&08C8
        ld c,1
        ld de,&8000
        ld ix,&8000+&2000
        call Akuyou_LoadDiscSectorZ

        call Akuyou_Firmware_kill
        call Akuyou_RasterColors_Init
        call Akuyou_Music_Restart

        ld hl,EventStreamArray_ContentWarning       ;Event Stream
        call ResetEventStream

    ContentWarningAgain:
        ld a,0  :ContentWarningVer_Plus1

        ld hl,null
        ld bc,ContentWarning0
        cp 0
        jr z,ContentWarningApply

        ld bc,ContentWarning1
        cp 1
        jr z,ContentWarningApply

        ld hl,onscreencursor
        ld bc,ContentWarning2
        cp 2
        jr z,ContentWarningApply

        ld bc,ContentWarning3
        cp 3
        jr z,ContentWarningApply

        ld bc,ContentWarning4
        cp 4
        jr z,ContentWarningApply

        ld hl,&8003
        ld (ContentWarningShowScreen_Plus2-2),hl
        ld hl,null

        ld bc,ContentWarning5
        cp 5
        jr z,ContentWarningApply

    ;   ld bc,ContentWarning6

    ;   cp 6
    ;   jr z,ContentWarningApply

        jp SaveShowMenu

    ContentWarningApply:
        inc a
        ld (ContentWarningVer_Plus1-1),a
        ld (ContentWarning_ShowCursor_Plus2-2),hl
        push bc
            call Akuyou_Cls
            call &8000  :ContentWarningShowScreen_Plus2

            ld l,13
        pop bc
        call ShowText


        ld hl,&0010 ;hl = startpos
        ld bc,&0003 ;bc = movespeed
        ld ix,&2604 ;ix = MinX,MaxX
        ld iy,&1610 ;iy = MinY,MaxY
        call OnscreenCursorDefine

    ContentWarning_Loop:
        call Akuyou_Timer_UpdateTimer

        call Akuyou_EventStream_Process
        ei
        halt
        call AkuYou_Player_ReadControls

        ld a,ixl
        and ixh
        or Keymap_AnyFire ; %11001111
        cp 255
        jp nz,ContentWarningAgain

        push hl
            call Null :ContentWarning_ShowCursor_Plus2;OnscreenCursor
        pop ix

        ;call Akuyou_ScreenBuffer_Flip
        jp ContentWarning_Loop
endif ; }}}

LevelInit:
    call AkuYou_Player_GetPlayerVars
    ld a,(iy-5)
    ld hl,null
    cp 64
    jp nz,LevelInitUsingRasterFlip
    ld (DisablePaletteSwitcher_Plus2-2),hl
LevelInitUsingRasterFlip:
    call RasterColorsSetPalette1 ; ../SrcCPC/Akuyou_CPC_Level_GenericRasterSwitcher.asm:321

    ld a,&C0
    call Akuyou_BankSwitch_C0_SetCurrent

ld a,2
call Akuyou_SpriteBank_Font

ifdef CompileEP2
    ld hl,EventStreamArray_Ep2 ; Event Stream
else
    ld hl,EventStreamArray_Ep1 ; Event Stream
endif
    ld de,Event_SavedSettings  ; Saved Settings
    call AkuYou_Event_StreamInit

    call Akuyou_Music_Restart
    call Akuyou_ScreenBuffer_Reset
    call Akuyou_Interrupt_Init

ShowTitlePic:
    call EnablePlusPalette
    call RasterColorsStartPalleteFlip

ifdef CompileEP2
    ld hl,EventStreamArray_Ep2 ; Event Stream
else
    ld hl,EventStreamArray_Ep1 ; Event Stream
endif
    ld de,Event_SavedSettings  ; Saved Settings
    call ResetEventStream

    ld a,2
    call Akuyou_SpriteBank_Font

    ld a,255
    ld i,a        ; show up to 255 chars

ifdef CompileEP2
    ld l,&18    ;ep2
else
    ld l,&17
endif
    ld bc,TitleText1
    call ShowText

    call Akuyou_Timer_UpdateTimer
    call Akuyou_EventStream_Process
    call Akuyou_ObjectArray_Redraw

    call Keys_WaitForRelease

ShowTitlePic_Loop:
    call Akuyou_Timer_UpdateTimer
    call Akuyou_EventStream_Process
    ei
    halt
    call AkuYou_Player_ReadControls

    ld a,ixl
    or Keymap_AnyFire ; %11001111
    cp 255
    jr nz,ShowMenu    ; Check for any of the 3 fires being pressed (1UP)

    ld a,ixh
    or Keymap_AnyFire ; %11001111
    cp 255
    jr nz,ShowMenu    ; Check for any of the 3 fires being pressed (2UP)

    call CallFade

    jr ShowTitlePic_Loop

ShowMenu:
ifdef CompileEP2
    call AkuYou_Player_GetPlayerVars
    ld a,(iy-10)
    and %01000000
    jp z,ContentWarning
endif

    ld hl,PlusPalette_Black
    call PlusPaletteSet

    call Akuyou_RasterColors_Init
     ;Turn on Plus raster switch
    ld a,1
    call Akuyou_CPCGPU_CommandNum

    ld a,64
    ld (PaletteNo_Plus1-1),a

    call Keys_WaitForRelease
ifdef CompileEP2
    ld hl,EventStreamArray_Menu_EP2 ; Event Stream
else
    ld hl,EventStreamArray_Menu_EP1 ; Event Stream
endif
    call ResetEventStream

    call Akuyou_CLS

    ld a,2
    call Akuyou_SpriteBank_Font

    ld a,255
    ld i,a        ; show up to 255 chars

    ld l,10
    ld bc,MenuText1
    call ShowText

    call CallFade

        ld hl,&1518
        call Akuyou_DrawText_LocateSprite ; SrcCPC/Akuyou_CPC_TextDriver.asm:104
        call Akuyou_Player_GetHighscore ; SrcALL/Akuyou_Multiplatform_PlayerDriver.asm:6
        ld de,7
        add hl,de
        ld b,8
        call MenuScore_NextDigit

    call Akuyou_Timer_UpdateTimer
    call Akuyou_EventStream_Process
    call Akuyou_ObjectArray_Redraw

    ld hl,&090C ; hl = startpos
    ld bc,&0001 ; bc = movespeed
    ld ix,&2602 ; ix = MinX,MaxX
ifdef CompileEP2
    ld iy,&120C ; iy = MinY,MaxY
else
    ld iy,&110C ; iy = MinY,MaxY
endif
    call OnscreenCursorDefine

ShowMenu_Loop:
    call Akuyou_Timer_UpdateTimer

    call Akuyou_EventStream_Process
    ei
    halt
    call AkuYou_Player_ReadControls

    ld a,ixl
    and ixh
    or Keymap_AnyFire ; %11001111 ;%11110001

    cp 255
    jp nz,MainMenuSelection

    push hl
        call OnscreenCursor
    pop ix
    ld a,(ix+8)
    bit 2,a
    jp z,ConfigureControls

ifdef Debug_ShowLevelTime
    call ShowLevelTime
endif
    call CallFade

    jp ShowMenu_Loop

ifdef Debug_ShowLevelTime
    read "..\SrcALL\Akuyou_Multiplatform_Level_GenericDebuggingTools.asm"
endif

CallFade:
    jp null :FadeCommand_Plus2

FadeDone:
    ld hl,null
    ld (FadeCommand_Plus2-2),hl
ret

SetFaderRegular:
    push hl
        ld hl,PlusPalette_Regular
        call SetFader
    pop hl
ret

SetFaderBlack:
    push hl
        ld hl,PlusPalette_Black
        call SetFader
    pop hl
ret

SetFaderEP1Menu:
    push hl
        ld hl,PlusPalette_EP1Menu
        call SetFader
    pop hl
ret

PlusPalette_Black: ; {{{
        defb 30
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 50
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 65
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 85
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 132
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 160
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 200-8-3
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
        defb 200
    defw &0000 ; 1  -GRB
    defw &0000 ; 5  -GRB
    defw &0000 ; 6  -GRB
    defw &0000 ; 4  -GRB
; }}}
PlusPalette_Regular: ; {{{
        defb 25
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 50
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 75
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 100
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 125
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 150
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 175
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
        defb 200
    defw &0000 ; 1  -GRB
    defw &0088 ; 5  -GRB
    defw &0F8F ; 6  -GRB
    defw &0FFF ; 4  -GRB
; }}}
PlusPalette_EP1Menu: ; {{{
    defb 30
    defw &0000
    defw &03F8
    defw &0FF0
    defw &0FFF
    defb 50
    defw &0000
    defw &00F0
    defw &02F2
    defw &0FFF
    defb 65
    defw &0000
    defw &00B4
    defw &0F0F
    defw &0FFF
    defb 85
    defw &0000
    defw &0077
    defw &00F0
    defw &0FFF
    defb 132
    defw &0000
    defw &0077
    defw &0F0C
    defw &0FFF
    defb 160
    defw &0000
    defw &0666
    defw &03F3
    defw &0F44
    defb 200-8-3
    defw &0000
    defw &0666
    defw &08E8
    defw &0F44
    defb 200
    defw &0000
    defw &0666
    defw &06F0
    defw &0FF0
; }}}

MainMenuSelection:
    ld a,(CursorCurrentPosXY_Plus2-2)
    cp &0C
    jp z,StartGame_1UP
    cp &0D
    jp z,StartGame_2UP
    cp &0E
    jp z,StartGame_2P
    cp &0F
    jp z,Introduction
    cp &10
    jp z,doGameplaySettings
ifdef CompileEP2
    cp &11
    jp z,EyeCatches
    cp &12
    jp z,DoShowCredits
else
    cp &11
    jp z,DoShowCredits
endif

ShowMenu_NoCredits:
    ld a,(ix+7)
    bit 4,a
    jp z,GameplaySettings

    ld a,(ix+4)
    bit 3,a
    jp z,Introduction
DoShowCredits:
    ld hl,ShowCredits
    ld (FadeOutJump_Plus2-2),hl
    ld hl,EventStreamFadeOut
    call ResetEventStream
    jp ShowMenu_Loop
OnscreenCursorDefineTest:
    ld hl,&0F0F
    ld bc,&0101
    ld ix,&2602
    ld iy,&1802
OnscreenCursorDefine:
        ld (CursorCurrentPosXY_Plus2-2),hl ; hl = startpos
        ld (CursorMoveSpeedXY_Plus2-2),bc  ; bc = movespeed
        ld a,ixl
        ld (CursorMinX_Plus1-1),a          ; ixl = MinX
        ld a,ixh
        ld (CursorMaxX_Plus1-1),a          ; ixh = MaxX
        ld a,iyl
        ld (CursorMinY_Plus1-1),a          ; iyl = MinY
        ld a,iyh
        ld (CursorMaxY_Plus1-1),a          ; iy = MaxY
    ret

OnscreenCursor:
        ld hl,&0101 :CursorCurrentPosXY_Plus2   ;current pos
        push hl
            call ClearChar
        pop hl

        ld bc,&0202 :CursorMoveSpeedXY_Plus2
        ld a,ixh
        and ixl
        ld e,a

        bit Keymap_D,e
        jr nz,OnscreenCursorNotDown

        ld a,l

        cp 24       :CursorMaxY_Plus1
        jr nc,OnscreenCursorAbandon
        add c
        ld l,a
OnscreenCursorNotDown:
        bit Keymap_U,e
        jr nz,OnscreenCursorNotUp

        ld a,l
        sub c
        cp 2        :CursorMinY_Plus1
        jr c,OnscreenCursorAbandon

        ld l,a
OnscreenCursorNotUp:
        bit Keymap_R,e
        jr nz,OnscreenCursorNotRight

        ld a,h

        cp 39       :CursorMaxX_Plus1
        jr nc,OnscreenCursorAbandon
        add b
        ld h,a
OnscreenCursorNotRight:
        bit Keymap_L,e
        jr nz,OnscreenCursorNotLeft

        ld a,h
        sub b
        cp 2        :CursorMinX_Plus1
        jr c,OnscreenCursorAbandon

        ld h,a
OnscreenCursorNotLeft:
OnscreenCursorAbandon:
        ld (CursorCurrentPosXY_Plus2-2),hl

        push hl
            ld a,2
            call Akuyou_SpriteBank_Font
        pop hl

        call ShowCursorPos

        call Akuyou_DrawText_LocateSprite

        ld hl,OnscreenCursor_anim :OnscreenCursor_animNext_Plus2
        ld a,(hl)
        or a
        jr nz,OnscreenCursorOK
        ld hl,OnscreenCursor_anim
        ld a,(hl)
OnscreenCursorOk:
        inc hl
        ld (OnscreenCursor_animNext_Plus2-2),hl
        call Akuyou_DrawText_CharSprite ; SrcCPC/Akuyou_CPC_TextDriver.asm:119
        ei
        halt
        halt
        halt
ifdef BuildCPC
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
        halt
endif
        ret

OnscreenCursor_anim: defb 129,130,131,130,0
ClearChar:
    ld a,l
    add a
    add a
    add a
    ld c,a
    ld a,h
    add a
    ld b,a

    call Akuyou_GetMemPos
    ld b,8
ClearCharMoreLines:
    ld (hl),0
    inc hl
    ld (hl),0
    dec hl
    call Akuyou_ScreenBuffer_GetNxtLin
    djnz ClearCharMoreLines
ret

ShowCursorPos: ;for debugging
ret

ifdef Debug_ShowLevelTime
    push hl
        ld hl,&1002
        call Akuyou_DrawText_LocateSprite
    pop hl
    ld a,h
    push hl
        call ShowHex
    pop hl
    ld a,l
    push hl
        call ShowHex
    pop hl
ret
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MenuScore_NextDigit:
    push bc
    push hl
        ld a,(hl)
        add 48
        call Akuyou_DrawText_CharSprite
    pop hl
    pop bc
    dec hl
    dec b
    jp nz,MenuScore_NextDigit
    ret

    TitleText1:
        db 8, "Press Fire to Continu","e"+&80
        db &0
    MenuText1:
        db  10,"Hit ESC to set control","s"+&80

    db  10,""," "+&80
    db  11,"Start Game as Chibik","o"+&80
    db  11,"Start Game as Bocha","n"+&80
    db  11,"Start 2 Player gam","e"+&80
    db  11,"Watch the Intr","o"+&80
    db  11,"Configure Setting","s"+&80
    ifdef CompileEP1
        db  11,""," "+&80
    endif
    ifdef CompileEP2
        db  11,"Special Conten","t"+&80
    endif
    db  11,"Credits & Thank","s"+&80

    db  10,"", " "+&80
    db  10," "," "+&80
    db  10," "," "+&80

    db  10, "www.chibiakumas.com"," "+&80
    db  10,""," "+&80
    db  9,"HighScore",":"+&80
    db &0

CheatsOn: db &0
Introduction:
    call Akuyou_CLS
ifdef CompileEP1
    ld hl,  &01FC               ;load Intro
endif
ifdef CompileEP2
    ld hl,  &01F0               ;load Intro
endif
    jp  Akuyou_ExecuteBootStrap ; Start the game, no return

txtContinues:     db "Continues",":"+&80
txtSmartbombs:    db "Smartbombs",":"+&80
txtContinueMode:  db "2P Continue Mode",":"+&80
txtContinueMode0: db "Co-Existance"," "+&80

txtContinueMode1: db "Brood Reduction"," "+&80;fratricide

txtGameplayMode: db "Gameplay Mode",":"+&80
txtGameplayMode0: db "Normal"," "+&80
txtGameplayMode128: db "4-Direction"," "+&80
txtGameplayMode128b: db "Win first","."+&80

txtDifficulty:   db "Difficulty",":"+&80
txtDifficulty0:  db "Chibi Akum","a"+&80
txtDifficulty0b: db "Hyper Akum","a"+&80
txtDifficulty1:  db "Gringo Puss","y"+&80
txtDifficulty1b: db "Baby Akum","a"+&80
txtDifficulty2:  db "I am Death","!"+&80

txtGameOptions:  db "ScreenShake",":"+&80
txtGameOptions0: db "Off"," "+&80
txtGameOptions1: db "On"," "+&80
txtMultiplay:    db "Use TotO Multiplay",":"+&80
txtMultiplay0:   db "Off"," "+&80
txtMultiplay1:   db "On"," "+&80
txtMultiplay3:   db "On+SwapFires"," "+&80

txtRasterColor:  db "RasterColor Flicker",":"+&80
txtPlusSprite:   db "PlusSprite Flicker",":"+&80
txtPlusSprite0:  db "On"," "+&80
txtPlusSprite1:  db "Off"," "+&80

txtMainMenu:     db "Back to Main Menu"," "+&80
txtConfigTitle:  db "Gameplay Options"," "+&80

lstContinueMode:
    defb 0
    defw txtContinueMode0
    defb 1
    defw txtContinueMode1
    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstContinueMode

lstGameplayMode:
    defb 0
    defw txtGameplayMode0
    defb 1
    defw txtGameplayMode128b
    defb 128
    defw txtGameplayMode128
    defb 0
    defw 00
    defw lstGameplayMode
lstGameplayModeC:
    defb 0
    defw txtGameplayMode0
    defb 128
    defw txtGameplayMode128
    defb 0
    defw 00
    defw lstGameplayModeC

lstGameplayModeN:
    defb 0
    defw txtGameplayMode0
    defb 1
    defw txtGameplayMode128b
    defb 0
    defw 00
    defw lstGameplayModeN

lstDifficulty:
    defb 0
    defw txtDifficulty0
    defb 0+64
    defw txtDifficulty0b
    defb 2+64
    defw txtDifficulty2
    defb 1+128
    defw txtDifficulty1
    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstDifficulty

lstGameOptions:
    defb 0
    defw txtGameOptions0
    defb 1
    defw txtGameOptions1
    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstGameOptions

lstMultiplay:
    defb 0
    defw txtMultiplay0
    defb 1
    defw txtMultiplay1
    defb 3
    defw txtMultiplay3
    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstMultiplay

lstPlusSprite:
    defb 0
    defw txtPlusSprite0
    defb 64
    defw txtPlusSprite1
    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstPlusSprite

AddAndLocate:
    add h
    ld h,a

    ld a,255
    ld i,a ; show up to 255 chars

    jp Akuyou_DrawText_LocateSprite
DrawTextFromLookup:
    ld b,a
DrawTextFromLookupAgain:
    ld a,(hl)
    inc hl
    cp b
    jr z,DrawTextFromLookupFound
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    or d
    ret z   ; 0 0 lookup means couldn't find a match
    jr DrawTextFromLookupAgain
DrawTextFromLookupFound:
    ld c,(hl)
    inc hl
    ld b,(hl)
    jp Akuyou_DrawText_PrintString

ToggleFromLookup:
    ld b,a
ToggleFromLookupAgain:
    ld a,(hl)
    inc hl
    cp b
    jr z,ToggleFromLookupFound
    ld d,(hl)
    inc hl
    ld a,(hl)
    inc hl
    or d
    ret z   ; 0 0 lookup means couldn't find a match
    jr ToggleFromLookupAgain
ToggleFromLookupFound:
    inc hl
    inc hl
    ld b,(hl)
    inc hl
zzxpxc
    ld a,b
    ret

posMultiplay     equ &09
posPlusSprite    equ &11
posRasterFlicker equ &13
posGameOptions   equ &0F

posConfigTitle  equ &02
posContinues    equ &05
posDifficulty   equ &07
posContinueMode equ &0B
posGameMode     equ &0D
posSmartBomb    equ &15
posMainMenu     equ &17

doGameplaySettings:
    ld hl,GameplaySettings
    ld (FadeOutJump_Plus2-2),hl
    ld hl,EventStreamFadeOut
    call ResetEventStream
    jp ShowMenu_Loop

GameplaySettings:
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-15)
    and %10000000
    ld (IY-15),a

    ld a,(IY-4)
    cp 64
    jr z,ResetPlusSprite
    xor a
ResetPlusSprite:
    ld (IY-4),a

    ld a,(IY-5)
    cp 64
    jr z,ResetFlickerColors
    xor a
ResetFlickerColors:
    ld (IY-5),a

    call Keys_WaitForRelease

    ld hl,Safepalette
    call ResetEventStream

    ld hl,&0305 ; hl = startpos
    ld bc,&0002 ; bc = movespeed
    ld ix,&2602 ; ix = MinX,MaxX
    ld iy,&1705 ; iy = MinY,MaxY

    call OnscreenCursorDefine;test

GameplaySettingsRedraw:
    call Akuyou_CLS
    TxtMidpoint equ 20

    ld a,2
    call Akuyou_SpriteBank_Font

    ld a,255
    ld i,a      ; show up to 255 chars

    ;Smartbombs
    ld hl,&0A00+posConfigTitle
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtConfigTitle
        call Akuyou_DrawText_PrintString
    pop hl

    ;Continues
    ld hl,&0500+posContinues
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtContinues
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-12)
    call Akuyou_DrawText_Decimal

    ;Difficulty
    ld hl,&0500+posDifficulty
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtDifficulty
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-11)
    ld hl,lstDifficulty
    call DrawTextFromLookup

ifdef posMultiplay
    ;Multiplay
    ld hl,&0500+posMultiplay
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtMultiplay
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-9)
    ld hl,lstMultiplay
    call DrawTextFromLookup
endif

    ld hl,&0500+posContinueMode
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtContinueMode
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-14)
    ld hl,lstContinueMode
    call DrawTextFromLookup

ifdef posGameOptions
    ;GameplayOptions
    ld hl,&0500+posGameOptions
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtGameOptions
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-16)
    ld hl,lstGameOptions
    call DrawTextFromLookup
endif

    ;Gameplay Mode Regular / 4D
    ld hl,&0500+posGameMode
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtGameplayMode
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-15)
    ld hl,lstGameplayMode
    call DrawTextFromLookup

ifdef posPlusSprite
    ;Plus Sprite Flicker
    ld hl,&0500+posPlusSprite
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtPlusSprite
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-4)
    ld hl,lstPlusSprite
    call DrawTextFromLookup
endif

ifdef posRasterFlicker
    ld hl,&0500+posRasterFlicker
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtRasterColor
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-5)
    ld hl,lstPlusSprite
    call DrawTextFromLookup
endif

    ;Continues
    ld hl,&0500+posSmartBomb
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtSmartbombs
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,TxtMidpoint
    call AddAndLocate
    call AkuYou_Player_GetPlayerVars
    ld a,(IY-13)
    call Akuyou_DrawText_Decimal

;MainMenu
    ld hl,&0A00+posMainMenu
        call Akuyou_DrawText_LocateSprite
        ld bc,txtMainMenu
        call Akuyou_DrawText_PrintString

GameplaySettings_Loop:
    call Akuyou_Timer_UpdateTimer
    call Akuyou_EventStream_Process
    call Akuyou_ObjectArray_Redraw

    call AkuYou_Player_ReadControls
    ld a,ixl
    and ixh
    or Keymap_AnyFire ; %11001111
    cp 255
    jp nz,GameplaySettings_Apply

    call OnscreenCursor

    call CallFade
    jp GameplaySettings_Loop
GameplaySettings_Apply:
    call AkuYou_Player_GetPlayerVars

    ld a,(CursorCurrentPosXY_Plus2-2)
    cp posContinues ;&05
    jp z,GameplaySettings_ApplyContinues
    cp posDifficulty;&07
    jr z,GameplaySettings_ApplyDifficulty
ifdef posMultiplay
    cp posMultiplay ;&09
    jp z,GameplaySettings_ApplyMultiplay
endif
    cp posContinueMode;&0B
    jp z,GameplaySettings_ApplyContinueMode
    cp posGameMode;&0D
    jr z,GameplaySettings_ApplyGameMode
ifdef posPlusSprite
    cp posPlusSprite;&0F
    jr z,GameplaySettings_ApplyPlusSprite
endif
ifdef posRasterFlicker
    cp posRasterFlicker;&11
    jr z,GameplaySettings_ApplyRasterFlicker
endif
    cp posSmartBomb; &13
    jp z,GameplaySettings_ApplySmartbombs
ifdef posGameOptions
    cp posGameOptions
    jp z,GameplaySettings_GameOptions
endif
    cp posMainMenu
    jp nc,GameplaySettings_ShowMenu
    jp GameplaySettingsRedraw
GameplaySettings_ShowMenu:
    jp SaveShowMenu
GameplaySettings_ApplyGameMode:
    ld a,(iy-10)
    and %10000000
    jr nz,GameplaySettings_ApplyGameModeComplete

    ld a,(IY-15)
    ld hl,lstGameplayModeN
    call ToggleFromLookup
    ld (IY-15),a
    jp GameplaySettingsRedraw
GameplaySettings_GameOptions:
    ld a,(IY-16)
    ld hl,lstGameOptions
    call ToggleFromLookup
    ld (IY-16),a
    jp GameplaySettingsRedraw
GameplaySettings_ApplyRasterFlicker:
    ld a,(IY-5)
    ld hl,lstPlusSprite
    call ToggleFromLookup
    ld (IY-5),a
    jp GameplaySettingsRedraw
GameplaySettings_ApplyPlusSprite:
    ld a,(IY-4)
    ld hl,lstPlusSprite
    call ToggleFromLookup
    ld (IY-4),a
    jp GameplaySettingsRedraw

GameplaySettings_ApplyGameModeComplete:
    ld a,(IY-15)
    ld hl,lstGameplayModeC
    call ToggleFromLookup
    ld (IY-15),a
    jp GameplaySettingsRedraw

GameplaySettings_ApplyDifficulty:
    ld a,(IY-11)
    ld hl,lstDifficulty
    call ToggleFromLookup
    ld (IY-11),a
    jp GameplaySettingsRedraw
GameplaySettings_ApplyContinueMode:
    ld a,(IY-14)
    ld hl,lstContinueMode
    call ToggleFromLookup
    ld (IY-14),a
    jp GameplaySettingsRedraw
GameplaySettings_ApplyMultiplay:
    ld a,(IY-9)
    ld hl,lstMultiplay
    call ToggleFromLookup
    ld (IY-9),a
    jp GameplaySettingsRedraw
GameplaySettings_ApplySmartbombs:
    ld a,(IY-13)
    inc a
    cp 4
    jr nz,GameplaySettings_ApplyContinuesB
    xor a
GameplaySettings_ApplyContinuesB:
    ld (IY-13),a
    jp GameplaySettingsRedraw
GameplaySettings_ApplyContinues:
    ld a,(IY-12)
    cp 250
    jr c,GameplaySettings_ApplyContinuesZero
    xor a
GameplaySettings_ApplyContinuesZero:
    add 10
    ld (IY-12),a
    jp GameplaySettingsRedraw

BlankMsg: db 4,""," "+&80,0

StartGame_1UP:
    call Akuyou_CLS
    ld hl,  &0005;7;5           ; load level 11 (Episode 2 start)
    jp  Akuyou_ExecuteBootStrap ; Start the game, no return
StartGame_2UP:
    call Akuyou_CLS
    ld hl,  &0006               ; load level 11 (Episode 2 start)
    jp  Akuyou_ExecuteBootStrap ; Start the game, no return

StartGame_2P:
    call Akuyou_CLS
    ld hl,  &0007               ; load level 11 (Episode 2 start)
    jp  Akuyou_ExecuteBootStrap ; Start the game, no return

ShowCredits:
    call Keys_WaitForRelease
    call Akuyou_CLS
    xor a
    ld (CheatsOn),a

    ld hl,Safepalette
    call ResetEventStream

    ld a,2
    call Akuyou_SpriteBank_Font

    ld a,255
    ld i,a        ; show up to 255 chars

    ld l,2
    ld bc,Credits_TextString
    call ShowText

ShowCredits_Loop:
    call Akuyou_Timer_UpdateTimer
    call Akuyou_EventStream_Process
    call Akuyou_ObjectArray_Redraw
    ei
    halt
ifdef BuildCPC
    halt
    halt
    halt
    halt
endif
    call CallFade

    call AkuYou_Player_ReadControls
    ld a,ixl
    and ixh
    or Keymap_AnyFire ; %11001111
    cp 255
    jp nz,ShowMenu

    ; Cheatmenu, Press F6 on credits, then 6 twice
    push hl
    pop ix

    ld a,(CheatsOn)
    cp 0
    jr z,cheatStage0 ; cheating isnt armed
    cp 1
    jr z,cheatStage1 ; cheating isnt armed
    cp 2
    jr z,cheatStage2 ; cheating isnt armed
    cp 3
    jp z,ShowCheats  ; Cheat!

; EP keyboard matrix &B5

;         b7     b6     b5    b4     b3     b2     b1     b0
; Row    80H    40H    20H   10H    08H    04H    02H    01H
;  0   L.SH.      Z      X     V      C      B      \      N
;  1    CTRL      A      S     F      D      G   LOCK      H
;  2     TAB      W      E     T      R      Y      Q      U
;  3     ESC      2      3     5      4      6      1      7
;  4      F1     F2     F7    F5     F6     F3     F8     F4
;  5          ERASE      ^     0      -      9             8
;  6              ]  colon     L      ;      K             J
;  7     ALT  ENTER   LEFT   HOLD    UP    RIGHT  DOWN   STOP
;  8     INS  SPACE  R.SH.     .      /      ,    DEL      M
;  9                     [     P      @      0             I

cheatStage0:
    ld a,(ix+0)
    bit 4,a
    call z,Cheater
    jr ShowCredits_Loop
cheatStage1:
    ld a,(ix+6)
    bit 0,a
    call z,Cheater
    jr ShowCredits_Loop
cheatStage2:
    ld a,(ix+0)
    bit 4,a
    call z,Cheater
    jr ShowCredits_Loop

Cheater:
    call Keys_WaitForRelease
    ld a,(CheatsOn)
    inc a
    ld (CheatsOn),a
    ret

Credits_TextString:
    ifdef CompileEP2
        db 8,"Chibi Akumas Episode 2","!"+&80
    else
        db 8,"Chibi Akumas Episode 1","!"+&80
    endif
    db 17,"V1.666"," "+&80
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db 7, "http://www.ChibiAkumas.co","m"+&80
    db 5, " "," "+&80

    db 7, "Written By Keith Sear 201","8"+&80
    db 5,""," "+&80
    db 5,""," "+&80
    db 254
    db 4,  "This Game was developed with the following free software",":"+&80
    db 5,  "WinApe, ConvImgCpc, Krita, ArkosTracker, ArnoldEmu, OpenMSX"," "+&80
    ;      .1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    ;      .9 9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0

    db 7,  "FUSE,EP128 and roudoudou's LZ48Decrunc compresso","r"+&80
    db 5,""," "+&80
    db 4,  "Thanks to My Patreon backers, who's support and encouragement"," "+&80
    db 13,  "made this game possible",":"+&80
    db 4,  "Alejandro Perez, Dimitris Topouzis, Ervin Pajor, Ivar Fiske,"," "+&80
    db 9,  "James Ford, krt17, Laurens Holst, Remax,"," "+&80
    db 5,  "Michael Steil, Peter Jones, Rajasekaran Senthil Kumaran,"," "+&80
    db 7 , "Rob Uttley, Shane O'Brien & Themistocles/Gryzor"," "+&80

    db 5,""," "+&80

    ;      .1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    ;      .9 9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0 9 9 8 8 7 7 6 6 5 5 4 4 3 3 2 2 1 1 0 0
    db 252,9,"Press Fire to Continu","e"+&80
    db &00

Keys_WaitForRelease:
    ld b,10

    push bc
    call AkuYou_Player_ReadControls
    pop bc
Keys_WaitForRelease_More:
    ld a,(hl)
    inc hl
    cp 255
    jr c,Keys_WaitForRelease
    djnz Keys_WaitForRelease_More
ret

LevelLoop:
    ;jp ShowCheats
    jp ShowMenu

LevelShutdown:

ret

;-------------------------------------------------------------------------------
;                   Cheat For Victory!
;-------------------------------------------------------------------------------

CheatsText: db 6,"Tools for Cheating Bastards","!"+&80
intCheat:   db 0
txtCheat:   db "Cheat","s"+&80
txtCheat1:  db "O","n"+&80
txtCheat0:  db "Of","f"+&80

intPlayersNum: db 0
txtPlayersNum: db "Player","s"+&80

txtPlayers0: db "Chibik","o"+&80
txtPlayers1: db "Bocha","n"+&80
txtPlayers2: db "Two Playe","r"+&80

intGameEngineMode: db 0

txtGameEngineMode: db "Game Engin","e"+&80
txtEngine0:  db   "464", " "+&80
txtEngine1:  db  "464+", " "+&80
txtEngine2:  db  "6128", " "+&80
txtEngine3:  db "6128+", " "+&80
txtEngine4:  db  "7256", " "+&80
txtEngine5:  db "7256+", " "+&80

txtGameEngineApply: db "Apply Game Engine","e"+&80

txtCheatMainMenu: db "Main Men","u"+&80

txtLevelJump: db "Jump to Level","l"+&80
txtLevelJumpApply: db "Make Level Jum","p"+&80
txtLevel0: db "0 - Men","u"+&80

ifdef CompileEP1
    txtLevel1: db "1.1 - Ep", "1"+&80
    txtLevel2: db "1.2 - Ep", "1"+&80
    txtLevel3: db "2.1 - Ep", "1"+&80
    txtLevel4: db "2.2 - Ep", "1"+&80
    txtLevel5: db "3.1 - Ep", "1"+&80
    txtLevel6: db "3.2 - Ep", "1"+&80
    txtLevel7: db "4.1 - Ep", "1"+&80
    txtLevel8: db "4.2 - Ep", "1"+&80
    txtLevel9: db "4.3 - Ep", "1"+&80

    txtLevel250: db "EndIntro - Ep", "1"+&80
    txtLevel251: db "EndOutro - Ep", "1"+&80
    txtLevel252: db "Intro - Ep",    "1"+&80
endif

txtLevel11: db "1.1 - Ep", "2"+&80
txtLevel12: db "1.2 - Ep", "2"+&80
txtLevel13: db "2.1 - Ep", "2"+&80
txtLevel14: db "2.2 - Ep", "2"+&80
txtLevel15: db "3.1 - Ep", "2"+&80
txtLevel16: db "3.2 - Ep", "2"+&80
txtLevel17: db "4.1 - Ep", "2"+&80
txtLevel18: db "4.2 - Ep", "2"+&80
txtLevel19: db "5.1 - Ep", "2"+&80
txtLevel20: db "5.2 - Ep", "2"+&80

txtLevel240: db "Intro - Ep",    "2"+&80
txtLevel241: db "EndIntro - Ep", "2"+&80
txtLevel242: db "EndOutro - Ep", "2"+&80

lstGameEngineMode:
    defb 0
    defw txtEngine0
    defb 1
    defw txtEngine1
    defb 0+128
    defw txtEngine2
    defb 1+128
    defw txtEngine3
    defb 0+128+64
    defw txtEngine4
    defb 1+128+64
    defw txtEngine5
    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstGameEngineMode

lstPlayers:
    defb 0
    defw txtPlayers0
    defb 1
    defw txtPlayers1
    defb 2
    defw txtPlayers2

    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstPlayers

lstCheats:
    defb 0
    defw txtCheat0
    defb 1
    defw txtCheat1


    defb 0  ;First one again - this is the loop
    defw 00 ;Command to show end of list
    defw lstCheats


intJumpToLevel: db 0

posLevelJump  equ 7
posPlayersNum equ 9
posCheats     equ 11
posLevelJumpApply  equ 13
posGameEngineMode  equ 15
posGameEngineApply equ 17
posCheatMainMenu   equ 19

lstLevelJump:
    defb 0
    defw txtLevel0

ifdef CompileEP1
    defb 1
    defw txtLevel1
    defb 2
    defw txtLevel2
    defb 3
    defw txtLevel3
    defb 4
    defw txtLevel4
    defb 5
    defw txtLevel5
    defb 6
    defw txtLevel6
    defb 7
    defw txtLevel7
    defb 8
    defw txtLevel8
    defb 9
    defw txtLevel9
    defb 250
    defw txtLevel250
    defb 251
    defw txtLevel251
    defb 252
    defw txtLevel252
endif

ifdef CompileEP2
    defb 11
    defw txtLevel11
    defb 12
    defw txtLevel12
    defb 13
    defw txtLevel13
    defb 14
    defw txtLevel14
    defb 15
    defw txtLevel15
    defb 16
    defw txtLevel16
    defb 17
    defw txtLevel17
    defb 18
    defw txtLevel18
    defb 19
    defw txtLevel19
    defb 20
    defw txtLevel20
    defb 240
    defw txtLevel240
    defb 241
    defw txtLevel241
    defb 242
    defw txtLevel242
endif

    defb 0  ; First one again - this is the loop
    defw 00 ; Command to show end of list
    defw lstLevelJump

ShowCheats:
    ld hl,&0407 ; hl = startpos
    ld bc,&0002 ; bc = movespeed
    ld ix,&2602 ; ix = MinX,MaxX
    ld iy,&1206 ; iy = MinY,MaxY
    call OnscreenCursorDefine;test

ShowCheatsAgain:
    ei
    halt
    halt
    halt
    halt
    halt
    halt
    ld a,255
    ld i,a        ; show up to 255 chars
    call Akuyou_CLS
    ld l,4
    ld bc,CheatsText
    call ShowText

    ;LevelJump
    ld hl,&0600+posLevelJump
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtLevelJump
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,20
    call AddAndLocate
    ld a,(intJumpToLevel)
    ld hl,lstLevelJump
    call DrawTextFromLookup

    ;PlayerNum
    ld hl,&0600+posPlayersNum
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtPlayersNum
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,20
    call AddAndLocate
    ld a,(intPlayersNum)
    ld hl,lstPlayers
    call DrawTextFromLookup

    ;Cheats
    ld hl,&0600+posCheats
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtCheat
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,20
    call AddAndLocate
    ld a,(intCheat)
    ld hl,lstCheats
    call DrawTextFromLookup

    ;LevelJump
    ld hl,&0600+posLevelJumpApply
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtLevelJumpApply
        call Akuyou_DrawText_PrintString
    pop hl

    ;GameEngine
    ld hl,&0600+posGameEngineMode
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtGameEngineMode
        call Akuyou_DrawText_PrintString
    pop hl
    ld a,20
    call AddAndLocate
    ld a,(intGameEngineMode)
    ld hl,lstGameEngineMode
    call DrawTextFromLookup

    ;GameEngineApply
    ld hl,&0600+posGameEngineApply
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtGameEngineApply
        call Akuyou_DrawText_PrintString
    pop hl

    ;GameEngineApply
    ld hl,&0600+posCheatMainMenu
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtCheatMainMenu
        call Akuyou_DrawText_PrintString
    pop hl

    ;MainMenu
    ld hl,&0600+posCheatMainMenu
    push hl
        call Akuyou_DrawText_LocateSprite
        ld bc,txtCheatMainMenu
        call Akuyou_DrawText_PrintString
    pop hl

ShowCheats2:
    call Akuyou_Timer_UpdateTimer
    call Akuyou_EventStream_Process
    call Akuyou_ObjectArray_Redraw

    call AkuYou_Player_ReadControls

    ld a,ixl
    and ixh
    or Keymap_AnyFire ; %11001111
    cp 255
    jp nz,Cheats_Apply

    call OnscreenCursor

jp ShowCheats2
Cheats_Apply:
    ld a,(CursorCurrentPosXY_Plus2-2)
    cp posLevelJump
    jr z,Cheats_ApplyLevel
    cp posLevelJumpApply
    jr z,Cheats_LevelJump
    cp posPlayersNum
    jr z,Cheats_ApplyPlayersNum
    cp posCheats
    jr z,Cheats_Cheats

    cp posGameEngineMode
    jr z,Cheats_ChangeGameEngineMode
    cp posGameEngineApply
    jr z,Cheats_ApplyGameEngineMode

    cp posCheatMainMenu
    jp z,showmenu

jp ShowCheats2

Cheats_ChangeGameEngineMode:
    ld a,(intGameEngineMode)
    ld hl,lstGameEngineMode
    call ToggleFromLookup
    ld (intGameEngineMode),a
jp ShowCheatsAgain

Cheats_ApplyGameEngineMode:
    call AkuYou_Player_GetPlayerVars
    ld a,(intGameEngineMode)
    ld (iy-1),a
jp ShowCheatsAgain

Cheats_ApplyPlayersNum:
    ld a,(intPlayersNum)
    ld hl,lstPlayers
    call ToggleFromLookup
    ld (intPlayersNum),a
jp ShowCheatsAgain

Cheats_Cheats:
    ld a,(intCheat)
    ld hl,lstCheats
    call ToggleFromLookup
    ld (intCheat),a
jp ShowCheatsAgain

Cheats_ApplyLevel:
    ld a,(intJumpToLevel)
    ld hl,lstLevelJump
    call ToggleFromLookup
    ld (intJumpToLevel),a
jp ShowCheatsAgain

Cheats_LevelJump:
    ;level
    ld a,1
    ld h,a
    ld a,(intJumpToLevel)
    ld l,a
    push hl

    ;cheats n bits
    ld a,(intPlayersNum)
    ld h,a
    ld a,(intCheat)
    ld l,a
    push hl

    ld hl,  &0008               ;load EndSetquence
    jp  Akuyou_ExecuteBootStrap ; Start the game, no return

Turbomode:
    call AkuYou_Player_GetPlayerVars
    ld a,(iy-8)
    inc a
    ld (iy-8),a

db &0

;-------------------------------------------------------------------------------

ShowText:
    call SetFont2b

ShowText_MoreText:
    ld a,255
    ld i,a    ; show up to 255 chars

    ld a,(bc)
    cp 252
    call z,SetFont2
    cp 254
    call z,SetFont1
    cp 253
    call z,ZeroPos ; bugfix!

    ld h,a
    inc bc

    push hl
        call Akuyou_DrawText_LocateSprite ; SrcCPC/Akuyou_CPC_TextDriver.asm:104
    pop hl

    inc l
    ld a,i
    dec a
    ld i,a
    inc bc

    ld a,(bc)
    or a
    jp nz,ShowText_MoreText
ret

ZeroPos:
    xor a
    ret

SetFont1:

    ld a,1
    call SetFontA
    jr SetFontFinish

SetFont2:
    call SetFont2b
SetFontFinish:
    inc bc
    ld a,(bc)
    ret

SetFont2b:
    ld a,2
SetFontA:
    push bc
    push hl
        call Akuyou_SpriteBank_Font
    pop hl
    pop bc
ret

;*******************************************************************************
;                   Eye Catches
;*******************************************************************************

ifdef CompileEP2 ; {{{
    EyeCatches_Menu:
        db  12,"Unlocked Bonuses","!"+&80
        db  10,""," "+&80
    ;           .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    ;               .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    Eyecatch0text_minus3:
        db  15,"1.Chibiko"," "+&80
    Eyecatch1text_minus3:
        db  15,"2.Bochan "," "+&80
    Eyecatch2text_minus3:
        db  15,"3.Yumi   "," "+&80
    Eyecatch3text_minus3:
        db  15,"4.Yume   "," "+&80
    Eyecatch4text_minus3:
        db  15,"5.Sakuya "," "+&80
        db  15,"Main Menu"," "+&80
        db &0
    EyeCatchesKill:
        push af
            ld bc,EyeCatches_Loop
            ld (hl),c
            inc hl
            ld (hl),b
            ex hl,de
            ld a,'?'
            ld b,7
    EyeCatchQwipe:
            ld (hl),a
            inc hl
            djnz EyeCatchQwipe

        pop af
        ret
    EyeCatches:

        call Akuyou_CLS

        call AkuYou_Player_GetPlayerVars
        ld a,(iy-10)

        bit 0,a
        ld hl,Eyecatch0Jump_Plus2-2
        ld de,Eyecatch0text_minus3+3
        call z,EyeCatchesKill

        bit 1,a
        ld hl,Eyecatch1Jump_Plus2-2
        ld de,Eyecatch1text_minus3+3
        call z,EyeCatchesKill

        bit 2,a
        ld hl,Eyecatch2Jump_Plus2-2
        ld de,Eyecatch2text_minus3+3
        call z,EyeCatchesKill

        bit 3,a
        ld hl,Eyecatch3Jump_Plus2-2
        ld de,Eyecatch3text_minus3+3
        call z,EyeCatchesKill

        bit 4,a
        ld hl,Eyecatch4Jump_Plus2-2
        ld de,Eyecatch4text_minus3+3
        call z,EyeCatchesKill

        call Keys_WaitForRelease
        ld hl,YumiYume_Menu_EP2     ;Event Stream
        call ResetEventStream


        call Akuyou_CLS
        ld a,2
        call Akuyou_SpriteBank_Font

        ld a,255
        ld i,a        ; show up to 255 chars

        ld l,10
        ld bc,EyeCatches_Menu
        call ShowText

        call Akuyou_Timer_UpdateTimer
        call Akuyou_EventStream_Process
        call Akuyou_ObjectArray_Redraw

        ld hl,&0D0C     ;hl = startpos
        ld bc,&0001     ;bc = movespeed
        ld ix,&2602     ;ix = MinX,MaxX
        ld iy,&110C     ;iy = MinY,MaxY
        call OnscreenCursorDefine;test

    EyeCatches_Loop:
        call Akuyou_Timer_UpdateTimer
        call Akuyou_EventStream_Process
        ei
        halt
        call AkuYou_Player_ReadControls

        ld a,ixl
        and ixh
        or Keymap_AnyFire ; %11001111
        cp 255
        jp nz,EyeCatches_Selection
        call OnscreenCursor

        jp EyeCatches_Loop
    EyeCatches_Selection:
        ld a,(CursorCurrentPosXY_Plus2-2)
        cp &0C
        jp z,EyeCatches_Chibiko :Eyecatch0Jump_Plus2
        cp &0D
        jp z,EyeCatches_Bochan  :Eyecatch1Jump_Plus2
        cp &0E
        jp z,EyeCatches_Yumi    :Eyecatch2Jump_Plus2
        cp &0F
        jp z,EyeCatches_Yume    :Eyecatch3Jump_Plus2
        cp &10
        jp z,EyeCatches_Sakuya  :Eyecatch4Jump_Plus2
        cp &11
        jp z,ShowMenu

    EyeCatches_Chibiko:
        ld hl,&33C1
        ld c,2
        push bc
        push hl
            ld hl,TimeColorsChibiko
            jr EyeCatchesExecute

    EyeCatches_Bochan:
        ld hl,&33C2
        ld c,2
        push bc
        push hl
            ld hl,TimeColorsBochan
            jr EyeCatchesExecute

    EyeCatches_Yumi:
        ld hl,&33C3
        ld c,2
        push bc
        push hl
            ld hl,TimeColorsYumi
            jr EyeCatchesExecute

    EyeCatches_Yume:
        ld hl,&33C4
        ld c,2
        push bc
        push hl
            ld hl,TimeColorsYume
            jr EyeCatchesExecute

    EyeCatches_Sakuya:
        ld hl,&33C5
        ld c,2
        push bc
        push hl
            ld hl,TimeColorsSakuya
            jr EyeCatchesExecute

    EyeCatchesExecute:
        ld a,0
        call Akuyou_SetLevelTime

        ld b,10
    EyeCatches_ColorRefresh:
        push bc
            call Akuyou_Timer_UpdateTimer
            call Akuyou_EventStream_Process
        pop bc
        djnz EyeCatches_ColorRefresh

                call Akuyou_RasterColors_Disable
                call Akuyou_ScreenBuffer_Reset
                call Akuyou_CLS
                call Akuyou_Firmware_Restore

                ld a,&C0        :EyeCatchBankA_Plus1
                ld de,&C000     :EyeCatchMemA_Plus2
                ld ix,&FF00     :EyeCatchMem2A_Plus2
            pop hl
            pop bc
            call Akuyou_LoadDiscSectorZ

            call Akuyou_Firmware_kill
            ld de,&8000
            ld hl,&C000         :EyeCatchMemB_Plus2
            ld bc,&3F00
            ld a,&C0            :EyeCatchBankB_Plus1
            call Akuyou_BankSwitch_C0_BankCopy

            call Akuyou_RasterColors_Init
            call Akuyou_Music_Restart
            ei

            Call &8000


    EyeCatches_Pause:
        call Akuyou_Timer_UpdateTimer
        call Akuyou_EventStream_Process
        call AkuYou_Player_ReadControls
        ld a,ixl
    ;   or iyl
        or Keymap_AnyFire
        cp 255
        jp nz,EyeCatches_ShowBio
        jr EyeCatches_Pause
    EyeCatches_ShowBio:
            call Akuyou_CLS
            Call &8003
            ld l,0
        call ShowText
        ei
        halt
        call Keys_WaitForRelease
        ld hl,TimeColorsEyeCatches :EyecatchSecondColor_Plus2
        ld a,0
        call Akuyou_SetLevelTime
    EyeCatches_Pause2:
        call Akuyou_Timer_UpdateTimer
        call Akuyou_EventStream_Process
        call AkuYou_Player_ReadControls
        ld a,ixl
    ;   or iyl
        or Keymap_AnyFire
        cp 255
        jp nz,EyeCatches
        jr EyeCatches_Pause2
endif ; }}}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           CPC Raster Switcher
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

read "..\SrcCPC\Akuyou_CPC_Level_GenericRasterSwitcher.asm"

ConfigureControls:
    ld hl,  &0002                ; Set Controls
    call Akuyou_ExecuteBootStrap ; Start the game, no return
SaveShowMenu:
    call Akuyou_CLS
    ld hl,  &0003                ; Save Settings
    call Akuyou_ExecuteBootStrap ; Start the game, no return
    jp ShowMenu

TimeColorsYumi:
    defb 1,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 0
    defb &54,&47,&5F,&4B

    defb 240,26*0+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 0
    defb 0
    defb &54,&54,&54,&54

defb 10
defb evtJumpToNewTime
defw PauseLoop
defb 100

TimeColorsSakuya:
    defb 1,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 0
    defb &54,&5F,&59,&4B

    defb 240,26*0+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 0
    defb 0
    defb &54,&54,&54,&54

defb 10
defb evtJumpToNewTime
defw PauseLoop
defb 100

TimeColorsYume:
    defb 1,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 0
    defb &54,&47,&4D,&4B

    defb 240,26*0+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 0
    defb 0
    defb &54,&54,&54,&54

defb 10
defb evtJumpToNewTime
defw PauseLoop
defb 100

TimeColorsChibiko:
    defb 1,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 0
    defb &54,&58,&5F,&4B

    defb 240,26*0+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 0
    defb 0
    defb &54,&54,&54,&54

defb 10
defb evtJumpToNewTime
defw PauseLoop
defb 100

TimeColorsBochan:
    defb 1,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 0
    defb &54,&47,&52,&40

    defb 240,26*0+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 0
    defb 0
    defb &54,&54,&54,&54

defb 10
defb evtJumpToNewTime
defw PauseLoop
defb 100

TimeColorsEyeCatches:
    defb 1,%01110000+4    ; 4 Commands
    defb 240,0,6          ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 1
    defb 0
    defb &54,&57,&5B,&4B

    defb 240,26*0+6,5*1+1 ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*1+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    defb 0
    defb 0
    defb &54,&54,&54,&54

    defb 240,26*2+6,6     ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    defb 0
    defb 0
    defb &54,&54,&54,&54

defb 10
defb evtJumpToNewTime
defw PauseLoop
defb 100

null:ret

LevelJumpBlock:
    defs FileBeginLevel+&3FF0-LevelJumpBlock

    jp LevelInit ; - Level start
    jp LevelLoop ; - Level loop

FileEndLevel:
    limit &FFFF
    ;;save file_name, address, size...} [,exec_address]
    ;;save "Z:\ResCPC\T08-SC1.D01",FileBeginLevel,FileEndLevel-FileBeginLevel
    save direct "T08-SC1 .D01", FileBeginLevel, FileEndLevel-FileBeginLevel
    ;;save direct "T08-SC1.D01", LevelOrigin+LevelDataStart, &3ff8-LevelDataStart
