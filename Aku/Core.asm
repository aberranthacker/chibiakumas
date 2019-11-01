read "BootStrap.asm"
;Changes you MUST make for a level to work with the new core
; RasterColorsSetPalette1  MUST set IY,null if nothing else
; Player sprites have moved
; Level data must now be at &4000, and start with sprites
; SpriteBank_Font now needs..  ld a,2  ... also note it now corrupts BC
; 128k bank ops are deprecated, now use C0 vers, add &C0 to last A
; LoadDiscSector also now needs C0
; Structure and size of level vars have changed
; Event_CoreReprogram_Paralax is obsolete
; Event_BackgroundScrollDirection is obsolete use Akuyou_Background_SetScroll
; CustomProgram4_Plus2 is obsolete
; Star and object Array Init is oblsolete
;setting Event_SavedSettings_Plus2 is depricated for Event_StreamInit
;defining backgrounds in the event stream is deprecated

;coredefined equ 1

Arkos_VarsDefined equ 1

ifdef CPC320
    TextScreen_MaxX equ 39
    TextScreen_MinX equ 0
    TextScreen_MaxY equ 24
    TextScreen_MinY equ 0
else
    TextScreen_MaxX equ 36 ;40
    TextScreen_MinX equ 4  ;0
    TextScreen_MaxY equ 23 ;24
    TextScreen_MinY equ 0  ;0
endif

ifndef Support128k      ;Check some Obakasan didn't ignore my warning above!
    ifndef Support64k
        Support64k equ 1
    endif
endif

ScreenBuffer2Pos equ &80

;                                                  ``.......`  ```...;;;;.
;                                     `#@@@@@@@###++';;;;;;;;;;;.....`
;                                      `             ''`     .`
;                                                   `+'     ;'.
;                                            `'##';`.++`  ;#@@@#@#+';,
;                                           +,      .##`    '+.    `;@@;
;                                          '@'      `++`   `++.,'#@@@@;
;                                          ,'#@@@@@@@@@@@@@@@@@@@#'.
;                                                   #@'    ,#'
;                                               ,#@@@; .+@@@#`
;                                     .;'#@@@@@@@@@@@@@@@@+;;;,...,;;'+++'.
;                             `;;;;''+##++'''''''';;;;'';;;;;;,,,,..`
;                                             +@@@#.     ,.
;                                           '@;`#@;     `;#;         ..
;                                         `#+` '@@;      ;@+          ,;+.
;                                        ;@;   ;@@#`    ;@@#.           ;@'
;                                      ,@'      '@@'    ,',     ,#+`    '@@.
;                                  `;;.          ;#@@#;..;'#@@@@#.     ,#@+`
;                       `;,      ;+.              ;'#@@@@+;,,`
;                       ,+;     ++,;;;'###+'+###+,
;                       '@;    .+@@@@###',`,#,
;                      ;@+`                '#,
;                 `+@##@@@@@@@@@#`         +@;
;                      ;@'   `+@@,        .@@+`              Akuyou Game Engine
;                     `+@;   ,@@@,        ,@@+`              Version 1.5
;                     .@@;  `#@@+'@@@@@@@#'@@+```
;                    `#@;   `#@@;        `;@@#....,.``
;                   `#@+    .@@@;         +@@#,
;                   '@#`    '@@#,        ;@@#@+`      Akuyou@ChibiAkumas.com
;                  `+@@@#;`;@@@;         +@@;+@+
;                   ..;'+@@@@@+`        `@@+ .'@@,
;                        `#@@@@@;`      #@#`   ;+@+`                     ````
;                       .@@@'`.,;,`   .@@#.     `;+@;             .+@@@@#+'+#@@#,';
;                     `#@@@;       `+@@@;          ;;#;       `#@@@'` .@@@@'``'@++@@@'
;                 `+@@@@@@#,    ;@@@@;               `,.` `'@@@@;     +@@@#,  `;`;@@@#.
;               `#@@@@@#';....'@@#;                   ,#@@@@;         +@''#@@#@@@@;;##`
;            .;;,.`           `;'+#@@@@@@@@@@##@@@@@@@#'.             +@;  ;'@+`   ,##`
;                                       `........`                    +@;   ;@+`   ,##`
;                                                                     +@@;  ;@+`  ,@@+`
;                                                                      ;+@@@'@##@@@;
;                                                                        `;+@@@;`

;The source code to this game is Creative Commons Licenced under
; "Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)" license
; Please see creativecommons.org/licenses/by-sa/4.0/

;You are free to use or modify the code in any way you wish - provided no charge is ma

;The games main "Hero" characters "Chibiko Akuma" "Bochan Akuma" "Yumi Yuusha" "Yume Yuusha"
;and "Sakya Chan" are Copyright 2016 Keith Sear

;You are permitted to use these characters in any of your own works without permission,
;provided all the following conditions are met

;1. You provide a link in your creative work to the ChibiAkumas.com or ChibiAkuma.com official website
;2. You state that I am the creator of the characters
;3. You state that your work is not officially endorsed

;If you make a Game / Comic etc with the Chibi Akumas characters, you are welcome to send it to me,
;and I will consider linking it on the official website if I feel it is in keeping with the 'brand
;image'* of the Chibi Akumas games and the characters contained in them.
;Just to reiterate - you can use the characters without any such endorsement by myself!

;You are welcome to remove the "hero characters" and the "Chibi Akumas" name and distribute your
;own alternate version of the game if you wish.

;Note this does not apply to the level enemies or boss characters , these are all licensed with the same Creative commons
;license as the source code.

; Akuyou means 'Misuse' in japanese - it refers to a total misuse of time, such as writing games for a 30 year old computer!
; the game engine name should be written in japanese with the Kanji Aku (bad) You (from yousei - fairy spirit)

;* (Is it really possible to do anything WORSE than is already in the official games!!
;   go on, create a doujinshi nscc-sakuya... I dare ya!)

SprShow_X equ SprShow_X_Plus1-1
SprShow_Y equ SprShow_Y_Plus1-1
SprShow_BankAddr equ SprShow_BankAddr_Plus2-2
SprShow_SprNum   equ SprShow_SprNum_Plus1-1

Timer_TicksOccured equ Timer_TicksOccured_Plus1-1

;***************************************************************************************************
;                   Main Project Code
;***************************************************************************************************
org Akuyou_CoreStart    ;&450

FileBeginCore:
    jp ShowSprite       ;8000
    jp ExecuteBootStrap ;8003
    jp LoadDiscSector   ;8006
    jp StarArray_Redraw ;8009
    jp SetLevelTime ;   ;800C
    jp Player_Handler   ;800F

    jp DoMovesBackground_SetScroll ;8012

    jp objectArray_Redraw      ;8015
    jp Event_Stream            ;8018
    jp Player_StarArray_Redraw ;801B

    jp PLY_Init     ;801E
    jp PLY_Stop     ;8021
    jp PLY_Play     ;8024
    jp PLY_SFX_Init ;8027
    jp PLY_SFX_Play ;802A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp RasterColors_Init      ;802D
    jp RasterColors_Reset     ;8030
    jp RasterColors_Disable   ;8033
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp ScreenBuffer_Init      ;8036 Init the double buffer
    jp ScreenBuffer_Flip      ;8039 Flip the buffer
    jp ScreenBuffer_Reset     ;803C
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp BankSwitch_C0          ;803F
    jp BankSwitch_C0_Reset    ;8042
    jp BankSwitch_C0_CallHL   ;8045
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp get_scr_addr_table     ;8048
    jp CLS;null               ;804B
    jp ShowSpriteReconfigureEnableDisable ;804E
    jp Event_StreamInit       ;8051
    jp Player_DrawUI          ;8054
    jp GetLevelTime           ;8057
    jp Firmware_Kill          ;805A
    jp Firmware_Restore       ;805D
    jp DrawText_LocateSprite  ;8060
    jp DrawText_CharSprite    ;8063
    jp BankSwitch_C0_BankCopy ;8066

    jp DrawText_PrintString     ;8069
    jp ShowSprite_SetBankAddr   ;806C
    jp Player_ReadControlsClassic ;806F
    jp Music_Restart            ;8072
    jp SFX_PlaySfx              ;8075
    jp Object_DecreaseLifeShot  ;8078
    jp Event_Stream_ForceNow    ;807B
    jp DoSmartBombCall          ;807E
    jp ScreenBuffer_GetActiveScreen ;8081
    jp Timer_UpdateTimer        ;8084
    jp null;Player_CheatMode    ;8087
    jp Timer_GetTimer           ;808A
    jp null                     ;808D
    jp SpriteBank_Font          ;8090
    jp ObjectProgram_HyperFire  ;8093
    jp Player_GetPlayerVars     ;8096
    jp DoMoves                  ;8099
    jp RasterColors_SetPointers ;809C
    jp Player_Hit_Injure_1      ;809F
    jp RasterColors_MusicOnly   ;80A2
    jp RasterColors_StopMusic   ;80A5
    jp ShowCompiledSprite       ;80A8
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp CPCGPU_CommandNum        ;80AB
    jp null                     ;80AE
    jp null                     ;80B1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp ScreenBuffer_Alt         ;80B4
    jp BankSwitch_C0_SetCurrent ;80B7
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp Player_GetHighscore      ;80BA
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp RasterColors_Blackout    ;80BD
    jp RasterColors_DefaultSafe ;80C0
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jp Background_GradientScroll;00C3
    jp Timer_SetCurrentTick     ;00C6
    jp Background_Gradient      ;00C9
    jp DrawText_LocateSprite4CR ;00CC
    jp LoadDiscSectorZ          ;00CF
    jp GetNxtLin                ;00D2
    jp DoObjectSpawn            ;00D5
    jp Player2Start             ;00D8
    jp Player_Hit_Injure_2      ;80DB
    jp GetMemPos                ;00DE
    jp DrawText_Decimal         ;00E1
    jp GetSpriteXY              ;00E4
    jp null                     ;00E7
    jp SetStarArrayPalette      ;00EA
    jp Aku_CommandNum           ;00ED
;*******************************************************************************
;                   Aligned Code
;*******************************************************************************
SavedSettings:
        defb 255         ;pos -20 spare
        defb 0           ;pos -19 spare
        defb 0           ;pos -18 spare
        defb 0           ;pos -17 spare
        defb %00000001   ;pos -16 GameOptions (xxxxxxxS) Screen shake
        defb 0           ;pos -15 playmode 0 normal / 128 - 4D
ContinueMode:    defb 0  ;pos -14 Continue Sharing (0/1)
SmartbombsReset: defb 3  ;pos -13 SmartbombsReset
ContinuesReset:  defb 60 ;pos -12 Continues Reset
GameDifficulty:  defb 0  ;pos -11 Game difficulty
                         ;        (enemy Fire Speed 0=normal, ;1=easy, 2=hard)
                         ;        +128 = heaven mode , +64 = star Speedup
                 defb %00000000 ;pos -10 Achievements (WPx54321) (W=Won P=Played)
MultiplayConfig: defb %00000000 ;pos  -9 Joy Config   (xxxxxxFM)
                ;M=Multiplay
                ;F=Swap Fire 1/2
TurboMode:       defb %00000000       ;pos -8 ------XX = Turbo mode [NoInsults/NoBackground/NoRaster/NoMusic]
LivePlayers:     defb 1               ;pos -7 Number of players currently active in the game [2/1/0]
TimerTicks:      defb 0               ;pos -6 ;used for benchmarking
BlockHeavyPageFlippedColors: defb 64  ;pos -5 0/255=on  64=off
BlockPageFlippedColors:      defb 255 ;pos -4 0/255=on  64=off
ScreenBuffer_ActiveScreen:   defb &c0 ;pos -3
ScreenBuffer_VisibleScreen:  defb &c0 ;pos -2
CPCVer: defb 00

;CPC 0  =464 , 128=128 ; 129 = 128 plus ; 192 = 128 plus with 512k; 193 = 128 plus with 512k pos -1
;MSX 1=V9990  4=turbo R
;ZX  0=TAP 1=TRD 2=DSK   128= 128k ;192 = +3 or black +2

Player_Array:
    P1_P00: defb 100;Y     ; 0
    P1_P01: defb 32 ;X     ; 1
    P1_P02: defb 0         ; 2 - shoot delay
    P1_P03: defb 2         ; 3 - smartbombs
    P1_P04: defb 0         ; 4 - drones (0/1/2)
    P1_P05: defb 60        ; 5 - continues
    P1_P06: defb 0         ; 6 - drone pos
    P1_P07: defb %00000111 ; 7 - Invincibility
    P1_P08: defb 0         ; 8 - Player SpriteNum
    P1_P09: defb 3         ; 9 - Lives
    P1_P10: defb 100       ;10 - Burst Fire (Xfire)
    P1_P11: defb %00000100 ;11 - Fire Speed - PlayerShootSpeed_Plus1
    P1_P12: defb 0         ;12 - Player num (0=1, 1=2)
    P1_P13: defb 0         ;13 - Points to add to player 1 - used to make score 'roll up'
    P1_P14: defb 0         ;14 - PlayerShootPower_Plus1
    P1_P15: defb &67       ;15 - FireDir

Player_Array2:             ;Player 2 is 16 bytes after player 1
    P2_P00: defb 150;Y     ; 0
    P2_P01: defb 32 ;X     ; 1
    P2_P02: defb 0         ; 2 - Shoot delay
    P2_P03: defb 2         ; 3 - smartbombs
    P2_P04: defb 0         ; 4 - Drones (0/1/2)
    P2_P05: defb 60        ; 5 - continues
    P2_P06: defb 0         ; 6 - Drone Pos
    P2_P07: defb %00000111 ; 7 - Invincibility
    P2_P08: defb 0         ; 8 - Player SpriteNum
    P2_P09: defb 0         ; 9 - Lives
    P2_P10: defb 0         ;10 - Burst Fire
    P2_P11: defb %00000100 ;11 - Fire speed
    P2_P12: defb 128       ;12 - Player num (0=1,1=2)
    P2_P13: defb 0         ;13 - Points to add to player 2 - used to make score 'roll up'
    P2_P14: defb 0         ;14 - PlayerShootPower_Plus1
    P2_P15: defb &67       ;15 - FireDir

KeyMap2:
    defb &FF,       &00 ;Pause
    defb %01111111, &05 ;Fire3
    defb %10111111, &06 ;Fire2R
    defb %01111111, &06 ;Fire1L
    defb %11011111, &07 ;Right
    defb %11011111, &08 ;Left
    defb %11101111, &07 ;Down
    defb %11110111, &07 ;Up

KeyMap:
    defb &F7,       &03 ;Pause bit 20
    defb %11111011, &02 ;Fire3     19
    defb %11111011, &04 ;Fire2R    18
    defb %11110111, &04 ;Fire1L    17
    defb &FD,       &00 ;Right     16
    defb &FE,       &01 ;Left      15
    defb &FB,       &00 ;Down      14
    defb &FE,       &00 ;Up        13

KeyboardScanner_KeyPresses ds 10 ;Player1

;This is the raw keypress data

align 8,0
Player_ScoreBytes  defb &00,&00,&00,&00,&00,&00,&00,&00 ; Player 2 current score
Player_ScoreBytes2 defb &00,&00,&00,&00,&00,&00,&00,&00 ; Player 1 current score
            ;25
HighScoreBytes defb    &00,&00,&00,&00,&00,&00,&00,&00  ; Highscore

;&80 bytes
SavedSettings_Last:

;X,X,Y,Y,S,[0,0,0] - [] not used
PlusSprites_Config1:
    ;These go at &6030
    defb &60-&00, &02, &08, &00
    defb &60-&20, &02, &08, &00
    defb &60-&40, &02, &08, &00
    defb &00+&00, &00, &08, &00
    defb &00+&20, &00, &08, &00
    defb &00+&40, &00, &08, &00
PlusSprites_Config2:
    defb &00+&00, &00, &B4, &00
    defb &00+&20, &00, &B4, &00
    defb &00+&40, &00, &B4, &00
    defb &60-&00, &02, &B4, &00
    defb &60-&20, &02, &B4, &00
    defb &60-&40, &02, &B4, &00

  ;   Z change to zero
;MusicRestoredefw 0000 ; pointer to the function to call to bring back the music
                       ; needed by 64k where music is wiped by firmware

;*******************************************************************************
;                   Rastercolors Aligned Code
;*******************************************************************************
; Some template rastercolors to use for blackout (when using the screen for
; temp space) and continue screens and the like with basic colors
align 256, &00

DiskRemap:
    ifdef DiskMap_SingleDisk
        defb 1, 1, 1, 1, 1
    else
        defb 0, 1, 2, 3, 4
    endif

RasterColors_Safe_ForInterrupt: defb 1, 1
RasterColors_Safe:              defb &54, &58, &5F, &4B
RasterColors_Black_ForInterrupt: defb 1, 1
RasterColors_Black:              defb &54, &54, &54, &54

; These are the default memory locations for the rastercolors - note they are
; memory aligned - they are often overrided by the Level code
RasterColors_ColorArray1:
RasterColors_ColorArray3:
RasterColors_ColorArray4:
RasterColors_ColorArray2:
    defb 1
    defb 1
    defb 64+20, 64+24, 64+29, 64+11

PlusRasterPalette: ; {{{
    defb 50 ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 100    ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 120    ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 200    ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 0      ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 0      ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 0      ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 200    ;next split
    defw &0000
    defw &0000
    defw &0000
    defw &0000
    defb 0      ;next split }}}

; Transparent colors are used by the sprite, if the byte matches it is skipped
; to effect transparency without an 'alpha map'
TranspColors:   defb &00, &F0, &0F, &FF, &AC, &53
; Smartbomb effect shows a flashing background, these are the bytes used
Background_SmartBombColors: defb &FF, &0, &FF, &0, &FF

; table/array for screen addresses for each scan line
ifdef MinimizeCore
    scr_addr_tableMajor: ; BYTES -XXXX--- %01111000
        defw &0000,&0050,&00A0,&00F0,&0140,&0190,&01E0,&0230,&0280,&02D0,&0320,&0370,&03C0,&0410,&0460,&04B0
    scr_addr_tableMinor: ; BYTES -----XXX ; do not need aligning
        defb &00,&08,&10,&18,&20,&28,&30,&38
endif

;These are used by Arkostracker
;There are two holes in the l ist, because the Volume registers are set relatively to the Frequency of the same Channel (+7, always).
;Also, the Reg7 is passed as a register, so is not kept in the memory.
PLY_PSGRegistersArray:
    PLY_PSGReg0  db 0 ; +0
    PLY_PSGReg1  db 0 ; +1
    PLY_PSGReg2  db 0 ; +2
    PLY_PSGReg3  db 0 ; +3
    PLY_PSGReg4  db 0 ; +4
    PLY_PSGReg5  db 0 ; +5
    PLY_PSGReg6  db 0 ; +6
    PLY_PSGReg8  db 0 ; +7
                 db 0 ; +8
    PLY_PSGReg9  db 0 ; +9
                 db 0 ;+10
    PLY_PSGReg10 db 0 ;+11
    PLY_PSGReg11 db 0 ;+12
    PLY_PSGReg12 db 0 ;+13
    PLY_PSGReg13 db 0 ;+14
PLY_PSGRegistersArray_End:

StarsOneByteDirs:
    defb &21,&09,&0C,&0F,&27,&3F,&3C,&39,&61,&49,&4c,&4f,&67,&7f,&7c,&79

Event_ReprogramVector:
    defw Event_CoreReprogram_Palette          ; 0
    defw null;Event_CoreReprogram_PlusPalette ; 1      ; Obsolete - Reserver for Plus Palette
    defw Event_CoreReprogram_ObjectHitHandler ; 2
    defw Event_CoreReprogram_ShotToDeath      ; 3
    defw Event_CoreReprogram_CustomMove1      ; 4
    defw Event_CoreReprogram_CustomMove2      ; 5
    defw Event_CoreReprogram_PowerupSprites   ; 6
    defw Event_CoreReprogram_CustomMove3      ; 7
    defw Event_CoreReprogram_CustomMove4      ; 8
    defw Event_CustomProgram1                 ; 9
    defw Event_CustomProgram2                 ;10
    defw Event_CustomPlayerHitter             ;11
    defw Event_CustomSmartBomb                ;12
    defw Event_ReprogramObjectBurstPosition   ;13
    defw Event_ObjectFullCustomMoves          ;14
    defw Event_SmartBombSpecial               ;15

Event_MoveVector:               ;128+
    defw Event_MoveLifeSwitch_0000               ; 0
    defw Event_ProgramSwitch_0001                ; 1
    defw Event_LifeSwitch_0010                   ; 2
    defw Event_MoveSwitch_0011                   ; 3
    defw Event_ProgramMoveLifeSwitch_0100        ; 4
    defw Event_SpriteSwitch_0101                 ; 5
    defw Event_AddFront_0110                     ; 6
    defw Event_AddBack_0111                      ; 7
    defw Event_ChangeStreamTime_1000             ; 8
    defw Event_Call_1001                         ; 9
    defw Event_LoadLastAddedObjectToAddress_1010 ;10
    defw Event_ClearPowerups                     ;11
    defw Event_ChangeStreamSpeed_1100            ;12
    defw Event_SpriteSizeSwitch_1101             ;13
    defw Event_AnimatorSwitch_1110               ;14
    defw Event_CoreReprogram_AnimatorPointer     ;15

; These are the jump-pointes used by the raster color interrupt routine - to
; try to save time only one byte is altered, so it must be byte aligned!
Event_VectorArray:
    defw Event_OneObj                      ;  0
    defw Event_MultiObj                    ; 16
    defw Event_ObjColumn                   ; 32
    defw Event_ObjStrip                    ; 48
    defw Event_StarBust                    ; 64
    defw null                              ; 80
    defw null                              ; 96
    defw Event_CoreMultipleEventsAtOneTime ;112
    defw Event_MoveSwitch                  ;128
    defw Event_CoreSaveLoadSettings        ;144
    defw null;Event_MoveSwitchMore         ;160
    defw Event_CoreSaveLoadSettings2       ;176
    defw null                              ;192
    defw null                              ;208
    defw null                              ;224
    defw Event_CoreReprogram               ;240

read "..\SrcCPC\Akuyou_CPC_InterruptHandler.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; End of aligned code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PLY_FrequencyTable:
    dw 3822, 3608, 3405, 3214, 3034, 2863, 2703, 2551, 2408, 2273, 2145, 2025
    dw 1911, 1804, 1703, 1607, 1517, 1432, 1351, 1276, 1204, 1136, 1073, 1012
    dw  956,  902,  851,  804,  758,  716,  676,  638,  602,  568,  536,  506
    dw  478,  451,  426,  402,  379,  358,  338,  319,  301,  284,  268,  253
    dw  239,  225,  213,  201,  190,  179,  169,  159,  150,  142,  134,  127
    dw  119,  113,  106,  100,   95,   89,   84,   80,   75,   71,   67,   63
    dw   60,   56,   53,   50,   47,   45,   42,   40,   38,   36,   34,   32
    dw   30,   28,   27,   25,   24,   22,   21,   20,   19,   18,   17,   16
    dw   15,   14,   13,   13,   12,   11,   11,   10,    9,    9,    8,    8
    dw    7,    7,    7,    6,    6,    6,    5,    5,    5,    4,    4,    4
    dw    4,    4,    3,    3,    3,    3,    3,    2,    2,    2,    2,    2
    dw    2,    2,    2,    2,    1,    1,    1,    1,    1,    1,    1,    1

ifdef CPC320
    read "..\SrcCPC\Akuyou_CPC_VirtualScreenPos_320.asm"
else
    read "..\SrcCPC\Akuyou_CPC_VirtualScreenPos_256.asm"
endif
read "..\SrcCPC\Akuyou_CPC_ShowSprite.asm"

read "..\SrcALL\Akuyou_Multiplatform_Stararray.asm"
read "..\SrcALL\Akuyou_Multiplatform_Stararray_Add.asm"
read "..\SrcALL\Akuyou_Multiplatform_DoMoves.asm"

;;;;;;;;;;;;;;;;;;;;Input Driver;;;;;;;;;;;;;;;;;;;;;;;;
read "..\SrcCPC\Akuyou_CPC_KeyboardDriver.asm"
;;;;;;;;;;;;;;;;;;;;Disk Driver;;;;;;;;;;;;;;;;;;;;;;;;
read "..\SrcCPC\Akuyou_CPC_DiskDriver.asm"
read "..\SrcCPC\Akuyou_CPC_ExecuteBootstrap.asm"
read "..\SrcCPC\Akuyou_CPC_TextDriver.asm"

read "..\SrcALL\Akuyou_Multiplatform_SFX.asm"

read "..\SrcCPC\Akuyou_CPC_CompiledSpriteViewer.asm"    ;also includes CLS
read "..\SrcCPC\Akuyou_CPC_BankSwapper.asm"

read "..\SrcALL\Akuyou_Multiplatform_PlayerDriver.asm"
read "..\SrcALL\Akuyou_Multiplatform_Timer.asm"

read "..\SrcCPC\Akuyou_CPC_Gradient.asm"

read "..\SrcALL\Akuyou_Multiplatform_ObjectDriver.asm"
read "..\SrcALL\Akuyou_Multiplatform_EventStream.asm"
read "..\SrcCPC\Akuyou_CPC_CpcPlus.asm"
read "..\SrcALL\Akuyou_Multiplatform_ArkosTrackerLite.asm"
read "..\SrcCPC\Akuyou_CPC_ScreenMemory.asm"
read "..\SrcALL\Akuyou_Multiplatform_AkuCommandVectorArray.asm"

ifdef Debug_Monitor
;   read "..\SrcALL\Multiplatform_Monitor.asm"
;   read "..\SrcALL\Multiplatform_MonitorMemdump.asm"
;   read "..\SrcALL\Multiplatform_MonitorSimple.asm"
endif

list
Null:ret
FileEndCore:
    save direct "CORE    .AKU",Akuyou_CoreStart,&3000   ;address,size...}[,exec_address]
nolist
