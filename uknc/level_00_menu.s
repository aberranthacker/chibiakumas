               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker
               .global Level00Size
               .global Level00SizeWords

               .equiv  Level00Size, (end - start)
               .equiv  Level00SizeWords, Level00Size >> 1

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

       .incbin "build/menu.spr"

EventStreamArray_Menu_EP1: #-------------------------------------------------{{{
    .word 0 # time
    .word evtSetPalette, MenuPalette # Event_CoreReprogram_Palette

    .word 0, evtSetProgMoveLife, prgNone, mvStatic, lifeImmortal
    .word 0, evtSaveObjSettings | 0 # Save Object settings to the Slot 0

        # Title
    .word 0 # time
    .word evtMultipleCommands | 7 # Event_CoreMultipleEventsAtOneTime; 7 -> Event_MultipleEventCount
    .word evtLoadObjSettings | 0  # Load Object settings from the Slot 2
    .word evtSingleSprite, 12     # sprite
    .byte 24+16, 12*0 + 24+44     # Y, X : 16,  88
    .word evtSingleSprite, 13     # sprite
    .byte 24+16, 12*1 + 24+44     # Y, X : 16, 112
    .word evtSingleSprite, 14     # sprite
    .byte 24+16, 12*2 + 24+44     # Y, X : 16, 136
    .word evtSingleSprite, 15     # sprite
    .byte 24+16, 12*3 + 24+44     # Y, X : 16, 160
    .word evtSingleSprite, 16     # sprite
    .byte 24+16, 12*4 + 24+44     # Y, X : 16, 184
    .word evtSingleSprite, 17     # sprite
    .byte 24+16, 12*5 + 24+44     # Y, X : 16, 208

        # Chibiko
    .word 0 # time
    .word evtMultipleCommands | 3 # Event_CoreMultipleEventsAtOneTime; 7 -> Event_MultipleEventCount
    .word evtLoadObjSettings | 0  # Load Object settings from the Slot 2
    .word evtSingleSprite, 0      # sprite
    .byte 24+64, 12*0 + 24        # Y, X : 64,  0
    .word evtSingleSprite, 1      # sprite
    .byte 24+64, 12*1 + 24        # Y, X : 64, 24

        # Bochan!
    .word 0 # time
    .word evtMultipleCommands | 3     # Event_CoreMultipleEventsAtOneTime; 7 -> Event_MultipleEventCount
    .word evtLoadObjSettings | 0      # Load Object settings from the Slot 2
    .word evtSingleSprite, 2          # sprite
    .byte 24+200-64, 12*0 + 24+160-24 # Y, X 136, 272
    .word evtSingleSprite, 3          # sprite
    .byte 24+200-64, 12*1 + 24+160-24 # Y, X 160, 296
#----------------------------------------------------------------------------}}}
PauseLoop:
    # Jump to a different level point
    .word 4, evtChangeStreamTime, 60, PauseLoop

LevelInit:
        MTPS $PR0 # enable interrupts
       .ppudo_ensure $PPU_TitleMusicRestart
        CLR  @$KeyboardScanner_P1 # call Keys_WaitForRelease

ShowMenu:
      # CALL CallFade # Aku/Level00-Menu.asm:1170
        CALL Fader

    .ifdef CompileEP2
        MOV  $EventStreamArray_Menu_EP2, R5
    .else
        MOV  $EventStreamArray_Menu_EP1, R5
    .endif
        MOV  $Event_SavedSettings,R3  # Saved Settings
        CALL @$EventStream_Init
        # TODO: show hiscore value
        CALL @$Timer.UpdateTimer # Aku/Level00-Menu.asm:1180
        CALL @$EventStream_Process
        CALL TRandW
        WAIT

       .ppudo_ensure $PPU_PrintAt,$MenuText

        MOV  $8,R1
        MOV  $HighScoreBytes+8,R4
        MOV  $HighScoreText+2,R5
        ScoreToStrLoop:
            CLRB R0
            BISB -(R4),R0
            ADD  $'0,R0
            MOVB R0,(R5)+
        SOB  R1,ScoreToStrLoop

       .ppudo_ensure $PPU_PrintAt,$HighScoreText
        CALL @$ObjectArray_Redraw

        JSR  R5,@$OnscreenCursorDefine
       .byte 0x0A,0x0C # startpos  X,Y
       .byte 0x00,0x01 # movespeed X,Y
       .byte 0x02,0x26 # MinX,MaxX
    .ifdef CompileEP2
       .byte 0x0C,0x12 # MinY,MaxY
    .else
      #.byte 0x0C,0x11 # MinY,MaxY
       .byte 0x0C,0x0F # disable settings and credits menu entries
    .endif

ShowMenu_Loop: #-------------------------------------------------------------{{{
    .ifdef DebugMode
        CALL @$ShowKeysBitmap
    .endif
        CALL @$Timer.UpdateTimer
        CALL @$EventStream_Process

        WAIT

        BIT  $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
        BNZ  MainMenuSelection

        CALL OnscreenCursor

        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}

MainMenuSelection: #---------------------------------------------------------{{{
        MOV  @$CursorCurrentPosY,R0
        CMP  R0,$0x0C
        BEQ  StartGame_1UP
        CMP  R0,$0x0D
        BEQ  StartGame_2UP
        CMP  R0,$0x0E
        BEQ  StartGame_2P
        CMP  R0,$0x0F
        BEQ  Introduction
        CMP  R0,$0x10
        BEQ  doGameplaySettings
   .ifdef CompileEP2
        CMP  R0,$0x11
        BEQ  EyeCatches
        CMP  R0,$0x12
        BEQ  DoShowCredits
   .else
        CMP  R0,$0x11
        BEQ  DoShowCredits
   .endif

        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}

Introduction: #--------------------------------------------------------------{{{
       .ppudo_ensure $PPU_MusicStop
        MOV  $0,R5
        CALL ExecuteBootstrap
#----------------------------------------------------------------------------}}}
StartGame_1UP: #-------------------------------------------------------------{{{
       .ppudo_ensure $PPU_MusicStop
        CALL Fader

       .ppudo $PPU_SetPalette,$Level01_TitlePalette
        MOV  $level_01_title.bin.lzsa1,R1
        MOV  $FB0,R2
        CALL @$unlzsa1

       .ppudo $PPU_PrintAt,$Level1_TitleText
        MOV  $FB0,R1
        MOV  $FB1+(12*2),R2
        MOV  $96,R3
        96$:
           .rept 16
            MOV  (R1)+,(R2)+
           .endr
        ADD  $24*2,R2
        SOB  R3,96$

        MOV  $1,R5
        CALL ExecuteBootstrap_NoCLS
#----------------------------------------------------------------------------}}}
StartGame_2UP: #-------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
StartGame_2P: #--------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
doGameplaySettings: #--------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
DoShowCredits: #-------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}

OnscreenCursorDefine: #------------------------------------------------------{{{
        MOVB (R5)+,@$CursorCurrentPosX
        MOVB (R5)+,@$CursorCurrentPosY

        MOVB (R5)+,@$CursorMoveSpeedX
        MOVB (R5)+,@$CursorMoveSpeedY

        MOVB (R5)+,@$CursorMinX
        MOVB (R5)+,@$CursorMaxX

        MOVB (R5)+,@$CursorMinY
        MOVB (R5)+,@$CursorMaxY

        RTS  R5
#----------------------------------------------------------------------------}}}
OnscreenCursor: #------------------------------------------------------------{{{
       .equiv CursorCurrentPosX, .+2
        MOV  $0x09,R3
       .equiv CursorCurrentPosY, .+2
        MOV  $0x0C,R4

        CALL ClearChar

        MOVB (PC)+,R1; CursorMoveSpeedX: .word 0x00
        MOVB (PC)+,R2; CursorMoveSpeedY: .word 0x01

        MOV  @$KeyboardScanner_P1,R0
       .equiv LastKeyMapChange, .+2
        CMP  R0,$0x00
        BEQ  draw_cursor$

        MOV  R0,@$LastKeyMapChange
      # is down pressed?
        BITB $KEYMAP_DOWN,R0
        BZE  not_down$

       .equiv CursorMaxY, .+2
        CMP  R4,$0x11
        BHIS draw_cursor$
        ADD  R2,R4

        CMP  R4,$0x0D # Start as Bochan?
        BNE  not_down$
        INC  R4 # skip "Start as Bochan"
        INC  R4 # skip "Start 2 Players Game"

    not_down$:
        BITB $KEYMAP_UP,R0
        BZE  not_up$

       .equiv CursorMinY, .+2
        CMP  R4,$0x0C
        BLOS draw_cursor$
        SUB  R2,R4

        CMP  R4,$0x0E # Start 2 Player Game?
        BNE  not_up$
        DEC  R4 # skip "Start 2 Player Game"
        DEC  R4 # skip "Start as Bochan"

    not_up$:
        BITB $KEYMAP_RIGHT,R0
        BZE  not_right$

       .equiv CursorMaxX, .+2
        CMP  R3,$0x26
        BHIS draw_cursor$
        ADD  R1,R3

    not_right$:
        BITB $KEYMAP_LEFT,R0
        BZE  not_left$

       .equiv CursorMinX, .+2
        CMP  R3,$0x02
        BLOS draw_cursor$
        SUB  R1,R3

    not_left$:
    draw_cursor$:
        MOV  R3,@$CursorCurrentPosX
        MOV  R4,@$CursorCurrentPosY

        CALL @$GetMemPos

        INC  @$CursorFrame
       .equiv CursorFrame, .+2
        MOV  $0,R1
        BIC  $0xFFF3,R1
        ASL  R1
        ASL  R1
        ADD  $CursorSpr,R1

        MOV  $8,R0
        100$:
            MOV  (R1)+,(R5)
            ADD  $80,R5
        SOB  R0,100$

        RETURN
#----------------------------------------------------------------------------}}}
ClearChar: #-----------------------------------------------------------------{{{
        CALL @$GetMemPos
        MOV  $8,R0

    100$:
        CLR  (R5)
        ADD  $80,R5
        SOB  R0,100$
RETURN
#----------------------------------------------------------------------------}}}
GetMemPos:
      # input R3 = X char column
      #       R4 = Y char row
      # output R5 = screen mem pos
        MOV  R4,R5
        MUL  $80*8,R5
        ADD  @$ScreenBuffer.ActiveScreen,R5
        MOV  R3,R0
        ASL  R0
        ADD  R0,R5
        RETURN

Fader: #---------------------------------------------------------------------{{{
        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R2,-(SP)
        MOV  R3,-(SP)
        MOV  R5,-(SP)

        CLR  R0
        MOV  $FB1+16000,R5
        MOV  $8,R3
        8$:
            SUB  $16000+80,R5
           .rept 1
            WAIT
           .endr
            MOV  $25,R2
            25$:
                ADD  $80*9,R5
                MOV  $4,R1
                4$:
                   .rept 10
                    MOV  R0,-(R5)
                   .endr
                 SOB  R1,4$
            SOB  R2,25$
        SOB  R3,8$

        MOV  (SP)+,R5
        MOV  (SP)+,R3
        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0
RETURN
#----------------------------------------------------------------------------}}}

    .ifdef DebugMode
ShowKeysBitmap: # -----------------------------------------------------------{{{
        MOV  @$KeyboardScanner_P1,R3
        CMP  R3,(PC)+; LastKeysBitmap: .word 0
        BEQ  1237$
        MOV  @$KeyboardScanner_P1,@$LastKeysBitmap

        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R2,-(SP)
        MOV  R3,-(SP)
        MOV  R5,-(SP)

        MOV  $FB1,R5
        MOV  $40*8>>2,R1
    100$:
       .rept 4
        CLR  (R5)+
       .endr
        SOB  R1,100$

        MOV  $ScanCodeStr+2,R1
        CALL @$NumToStr
       .ppudo_ensure $PPU_DebugPrintAt, $ScanCodeStr
        MOV  (SP)+,R5
        MOV  (SP)+,R3
        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0
       .wait_ppu
1237$:
        RETURN

NumToStr: #---------------------------------------------------------------------
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
#-------------------------------------------------------------------------------
ScanCodeStr:
        .byte 0,4
        .asciz "76543210"
        .even
#----------------------------------------------------------------------------}}}
    .endif

MenuPalette: #---------------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, brMagenta, brYellow, White
    .byte  40, setColors, Black, brRed,     brCyan, White
    .byte  60, setColors, Black, Red,       brCyan, White
    .byte  67, setColors, Black, Magenta,   brRed, White
    .byte  88, setColors, Black, Magenta,   brCyan, White
    .byte 105, setColors, Black, Magenta,   Cyan, White
    .byte 117, setColors, Black, Gray,      Cyan, White
    .word 120, cursorGraphic, scale320 | rGB
    .byte 121, setColors, Black, Gray,      brMagenta, White
    .byte 129, setColors, Black, Gray,      Magenta, White
    .word 137, cursorGraphic, scale320 | RGB
    .byte 138, setColors, Black, Gray,      Red, brGreen
    .byte 145, setColors, Black, Gray,      brRed, brGreen
    .word 190, cursorGraphic, scale320 | RgB
    .byte 191, setColors, Black, Yellow,    brYellow, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}
Level01_TitlePalette: #------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | RGb
    .byte   1, setColors, Black, Magenta, brCyan,    White
    .byte  96, setColors, Black, Magenta, Gray, White
    .byte 104, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen
#----------------------------------------------------------------------------}}}

                         #0---------1---------2---------3---------
MenuText:                #0123456789012345678901234567890123456789
    .byte 10, 10; .ascii           "Hit ESC to set controls"        ; .byte -1 ; .even

    .byte 11, 12; .ascii           "Start Game as Chibiko"          ; .byte -1 ; .even
    .byte 11, 13; .ascii           "Start Game as Bochan"           ; .byte -1 ; .even
    .byte 11, 14; .ascii           "Start 2 Player game"            ; .byte -1 ; .even
    .byte 11, 15; .ascii           "Watch the Intro"                ; .byte -1 ; .even
    .byte 11, 16; .ascii           "Configure Settings"             ; .byte -1 ; .even
  .ifdef CompileEP2
    .byte 11, 17; .ascii           "Special Content"                ; .byte -1 ; .even
    .byte 11, 18; .ascii           "Credits & Thanks"               ; .byte -1 ; .even
  .else
    .byte 11, 17; .ascii           "Credits & Thanks"               ; .byte -1 ; .even
  .endif

    .byte 10, 22; .ascii           "www.chibiakumas.com"            ; .byte -1 ; .even

    .byte 10, 24; .ascii           "HighScore:"                     ; .byte 0  ; .even

                         #0---------1---------2---------3---------
HighScoreText:           #0123456789012345678901234567890123456789
    .byte 21, 24; .ascii                      "--------"            ; .byte  0; .even

CursorSpr: .incbin "build/menu_cursor.spr"

level_01_title.bin.lzsa1:
    .incbin "build/level_01_title.bin.lzsa1"
    .even
                         #0---------1---------2---------3---------
Level1_TitleText:        #0123456789012345678901234567890123456789
    .byte  2, 13; .ascii   "After a hard nights work massacring"    ; .byte 0xFF ; .even
    .byte  2, 14; .ascii   "villagers and harvesting their blood"   ; .byte 0xFF ; .even
    .byte  1, 15; .ascii  "Chibico is having a well earned day's"   ; .byte 0xFF ; .even
    .byte  2, 16; .ascii   "sleep... Suddenly she is awoken by a"   ; .byte 0xFF ; .even
    .byte  2, 17; .ascii   "commotion. A swarm of noisy, stupid,"   ; .byte 0xFF ; .even
    .byte  1, 18; .ascii  "ill concieved and badly drawn monsters"  ; .byte 0xFF ; .even
    .byte  1, 19; .ascii  "are being drawn to her castle, and are"  ; .byte 0xFF ; .even
    .byte  4, 20; .ascii     "seriously disturbing the peace!"      ; .byte 0xFF ; .even
    .byte  5, 21; .ascii      "No self respecting vampire can"      ; .byte 0xFF ; .even
    .byte  3, 22; .ascii    "overlook this insult! It's time to"    ; .byte 0xFF ; .even
    .byte  3, 23; .ascii    "'rise from your grave' and unleash"    ; .byte 0xFF ; .even
    .byte  7, 24; .ascii        "hell on whoever sent them!"        ; .byte 0x00 ; .even
    .even
end:
