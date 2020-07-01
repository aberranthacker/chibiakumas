               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level00SizeWords, (end - start) >> 1
               .global Level00SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

TITLETEX: .incbin "resources/titletex.spr"

CustomRam: .space 64 # Pos-Tick-Pos-Tick # enough memory for 16 enemies!

EventStreamArray_Ep1: #------------------------------------------------------{{{
    .word 0, evtSetPalette, TitleScreenPalette

    .word 4, evtChangeStreamTime, 60, PauseLoop
#----------------------------------------------------------------------------}}}

EventStreamArray_Menu_EP1: #-------------------------------------------------{{{
        # defb 0,evtCallAddress
        # defw SetFaderEP1Menu

        # ; We will use 4 Paralax layers
        # ;  ---------()- (sky)        %11001000
        # ;  ------------ (Far)        %11000100
        # ;  -----X---X-- (mid)        %11000010   Bank 1
        # ;  []=====[]=== (foreground) %11000001   Bank 0

    .word 0 # time
    .word evtSetPalette  # Event_CoreReprogram_Palette
    .word     MenuPalette # palette data address

        # ; Background L
        # defb 0
        # defb 128+4     ; SrcALL/Akuyou_Multiplatform_EventStream.asm:182
        #                ; CALL Event_ProgramMoveLifeSwitch_0100
        # defb 1         ; Program - Bitshift Sprite
        # defb %11000001 ; Move - dir Left Slow
        # defb 0         ; Life - immortal
    .word 0 # time
    .word evtSetProgMoveLife # CALL Event_ProgramMoveLifeSwitch
    .word prgBitShift # program - bitshift sprite
    .word 0b11000001  # move    - dir left, slow
    .word lifeImmortal
        # defb 0,%10010000+15,0      ; Save Object settings to Bank 0
    .word 0 # time
    .word evtSaveObjSettings | 0 # Save Object settings to the Slot 0

        # defb 0
        # defb 128+4      ; SrcALL/Akuyou_Multiplatform_EventStream.asm:182
        #                 ; CALL Event_ProgramMoveLifeSwitch_0100
        # defb 1          ; Program - Bitshift Sprite
        # defb %11000010  ; Move    - dir Left Slow
        # defb 0          ; Life    - immortal
    .word 0 # time
    .word evtSetProgMoveLife # CALL Event_ProgramMoveLifeSwitch
    .word prgBitShift          # program - bitshift sprite
    .word 0b11000010 # move    - dir left, slow
    .word lifeImmortal
        # defb 0,%10010000+15,1      ; Save Object settings to Bank 1
    .word 0 # time
    .word evtSaveObjSettings | 1 # Save Object settings to the Slot 1

        # defb 0,128+4,0,&24,0       ; Static object
    .word 0 # time
    .word evtSetProgMoveLife # CALL Event_ProgramMoveLifeSwitch
    .word prgNone
    .word mvStatic
    .word lifeImmortal
        # defb 0,%10010000+15,2      ; Save Object settings to Bank 2
    .word 0 # time
    .word evtSaveObjSettings | 2 # Save Object settings to the Slot 2

        # ;Title
        # defb 0,%01110000+7          ; 7 commands at the same timepoint
    .word 0 # time
    .word evtMultipleCommands | 7 # Event_CoreMultipleEventsAtOneTime; 7 -> srcEvent_MultipleEventCount
        # defb %10010000+0+2          ; Load Settings from bank 2
    .word evtLoadObjSettings | 2 # Load Object settings from the Slot 2
        # defb 0, 12, 12*0+ 24+44, 24+16 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 12 # sprite
    .byte 24+16, 12*0 + 24+44 # Y, X
        # defb 0, 13, 12*1+ 24+44, 24+16 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 13 # sprite
    .byte 24+16, 12*1 + 24+44 # Y, X
        # defb 0, 14, 12*2+ 24+44, 24+16 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 14 # sprite
    .byte 24+16, 12*2 + 24+44 # Y, X
        # defb 0, 15, 12*3+ 24+44, 24+16 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 15 # sprite
    .byte 24+16, 12*3 + 24+44 # Y, X
        # defb 0, 16, 12*4+ 24+44, 24+16 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 16 # sprite
    .byte 24+16, 12*4 + 24+44 # Y, X
        # defb 0, 17, 12*5+ 24+44, 24+16 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 17 # sprite
    .byte 24+16, 12*5 + 24+44 # Y, X

        # ;Chibiko
        # defb 0,%01110000+3      ; 3 commands at the same timepoint
    .word 0 # time
    .word evtMultipleCommands | 3 # Event_CoreMultipleEventsAtOneTime; 7 -> srcEvent_MultipleEventCount
        # defb %10010000+0+2      ; Load Settings from bank 2
    .word evtLoadObjSettings | 2 # Load Object settings from the Slot 2
        # defb 0,0,12*0+ 24,24+64 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 0                # sprite
    .byte 24+64, 12*0 + 24 # Y, X
        # defb 0,1,12*1+ 24,24+64 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 1                # sprite
    .byte 24+64, 12*1 + 24 # Y, X

        # ;Bochan!
        # defb 0,%01110000+3                 ; 3 commands at the same timepoint
    .word 0 # time
    .word evtMultipleCommands | 3 # Event_CoreMultipleEventsAtOneTime; 7 -> srcEvent_MultipleEventCount
        # defb %10010000+0+2                 ; Load Settings from bank 2
    .word evtLoadObjSettings | 2 # Load Object settings from the Slot 2
        # defb 0,2,12*0+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 2               # sprite
    .byte 24+200-64, 12*0 + 24+160-24 # Y, X
        # defb 0,3,12*1+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)
    .word evtSingleSprite
    .word 3               # sprite
    .byte 24+200-64, 12*1 + 24+160-24 # Y, X
#----------------------------------------------------------------------------}}}
PauseLoop:
    # Jump to a different level point
    .word 4, evtChangeStreamTime, 60, PauseLoop

LevelInit:
        MTPS $PR0 # enable interrupts

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        MOV  $Event_SavedSettings,R3  # Saved Settings
        CALL @$Event_StreamInit

       #MOV  $EventStreamArray_Ep1,R5 # Event Stream
       #MOV  $Event_SavedSettings,R3  # Saved Settings
       #CALL @$ResetEventStream

       .ppudo_ensure $PPU_PrintAt,$PressFireKeyStr # Aku/Level00-Menu.asm:1101
        # Aku/Level00-Menu.asm:1103
       #CALL @$Timer_UpdateTimer
       #CALL @$EventStream_Process
       #CALL @$ObjectArray_Redraw

        CLR  @$KeyboardScanner_P1 # call Keys_WaitForRelease

.ifdef ShowLoadingScreen
       .wait_ppu
ShowTitlePic_Loop: #---------------------------------------------------------{{{
       .ppudo $PPU_SetPalette, $FireKeyDarkPalette
        CALL glow_delay_and_wait_key$
       .ppudo $PPU_SetPalette, $FireKeyNormalPalette
        CALL glow_delay_and_wait_key$
       .ppudo $PPU_SetPalette, $FireKeyBrightPalette
        CALL glow_delay_and_wait_key$
       .ppudo $PPU_SetPalette, $FireKeyNormalPalette
        CALL glow_delay_and_wait_key$
       .ppudo $PPU_SetPalette, $FireKeyDarkPalette
        CALL glow_delay_and_wait_key$
       .ppudo $PPU_SetPalette, $FireKeyBlackPalette
        CALL glow_delay_and_wait_key$

        BR   ShowTitlePic_Loop

    glow_delay_and_wait_key$:
        MOV  $5,R0
    100$:
        WAIT
        BITB @$KeyboardScanner_P1,$Keymap_AnyFire
        BNZ  finalize_title_pic_loop$

        SOB  R0,100$
        RETURN

    finalize_title_pic_loop$:
        TST  (SP)+ # remove return address from the stack
#----------------------------------------------------------------------------}}}
.endif

ShowMenu:
        # CALL CallFade # Aku/Level00-Menu.asm:1170
        CALL Fader

    .ifdef CompileEP2
        MOV  $EventStreamArray_Menu_EP2, R5
    .else
        MOV  $EventStreamArray_Menu_EP1, R5
    .endif
        CALL @$ResetEventStream
        # TODO: show hiscore value
        CALL @$Timer_UpdateTimer # Aku/Level00-Menu.asm:1180
        CALL @$EventStream_Process
        WAIT

       .ppudo_ensure $PPU_PrintAt,$MenuText1
        CALL @$ObjectArray_Redraw

        JSR  R5,@$OnscreenCursorDefine
       .byte 0x0A,0x0C # startpos  X,Y ; hl = startpos
       .byte 0x00,0x01 # movespeed X,Y ; bc = movespeed
       .byte 0x02,0x26 # MinX,MaxX     ; ix = MinX,MaxX
    .ifdef CompileEP2
       .byte 0x0C,0x12 # MinY,MaxY     ; iy = MinY,MaxY
    .else
       .byte 0x0C,0x11 # MinY,MaxY     ; iy = MinY,MaxY
    .endif

ShowMenu_Loop: #-------------------------------------------------------------{{{
        CALL @$ShowKeysBitmap
        CALL @$Timer_UpdateTimer

        CALL @$EventStream_Process

        WAIT

        BIT  $Keymap_AnyFire,@$KeyboardScanner_P1
        BNZ  MainMenuSelection
                                                            #    push hl
        CALL OnscreenCursor                                 #        call OnscreenCursor
                                                            #    pop ix
                                                            #    ld a,(ix+8)
                                                            #    bit 2,a
                                                            #    jp z,ConfigureControls
                                                            #
                                                            #ifdef Debug_ShowLevelTime
                                                            #    call ShowLevelTime
                                                            #endif
                                                            #    call CallFade
                                                            #
        JMP  @$ShowMenu_Loop                                #    jp ShowMenu_Loop
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

StartGame_1UP: #-------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
StartGame_2UP: #-------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
StartGame_2P: #--------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
Introduction: #--------------------------------------------------------------{{{
        MOV  $0,R5
        CALL ExecuteBootstrap
#----------------------------------------------------------------------------}}}
doGameplaySettings: #--------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}
DoShowCredits: #-------------------------------------------------------------{{{
        JMP  @$ShowMenu_Loop
#----------------------------------------------------------------------------}}}

ResetEventStream: #----------------------------------------------------------{{{
        MOV  $GameVarsArraysSize>>2,R0
        MOV  $Akuyou_GameVarsStart,R1

100$:   CLR  (R1)+
        CLR  (R1)+
        SOB  R0,100$

        MOV  $Event_SavedSettings,R3  # Saved Settings
        CALL @$Event_StreamInit
RETURN
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
        MOV  (PC)+,R3; CursorCurrentPosX: .word 0x09
        MOV  (PC)+,R4; CursorCurrentPosY: .word 0x0C

        CALL ClearChar

        MOVB (PC)+,R1; CursorMoveSpeedX: .word 0x00
        MOVB (PC)+,R2; CursorMoveSpeedY: .word 0x01

        MOV  @$KeyboardScanner_P1,R0
        CMP  R0,(PC)+; LastKeyMapChange: .word 0
        BEQ  draw_cursor$
        MOV  R0,@$LastKeyMapChange
    # is down pressed?
        ROR  R0
        BCC  not_down$

        CMP  R4,(PC)+; CursorMaxY: .word 0x11
        BHIS draw_cursor$
        ADD  R2,R4

        CMP  R4,$0x0E
        BNE  not_down$
        INC  R4

    not_down$:
        ROR  R0
        BCC  not_up$

        CMP  R4,(PC)+; CursorMinY: .word 0x0C
        BLOS draw_cursor$
        SUB  R2,R4

        CMP  R4,$0x0E
        BNE  not_up$
        DEC  R4

    not_up$:
        ROR  R0
        BCC  not_right$

        CMP  R3,(PC)+; CursorMaxX: .word 0x26
        BHIS draw_cursor$
        ADD  R1,R3

    not_right$:
        ROR  R0
        BCC  not_left$

        CMP  R3,(PC)+; CursorMinX: .word 0x02
        BLOS draw_cursor$
        SUB  R1,R3

    not_left$:
    draw_cursor$:
        MOV  R3,@$CursorCurrentPosX
        MOV  R4,@$CursorCurrentPosY

        CALL @$GetMemPos

        INC  @$CursorFrame
        MOV  (PC)+,R1; CursorFrame: .word 0
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
# c = 12 * 4 (48)
# b =  9 * 2 (18)
        CALL @$GetMemPos
        MOV  $8,R0

    100$:
        CLR  (R5)
        ADD  $80,R5
        SOB  R0,100$
RETURN
#----------------------------------------------------------------------------}}}

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
        MOV  $25,R2
        SUB  $16000+80,R5
       .rept 1
        WAIT
       .endr
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
       .ppudo_ensure $PPU_PrintAt,$ScanCodeStr
        MOV  (SP)+,R5
        MOV  (SP)+,R3
        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0
       .wait_ppu

1237$:
        RETURN

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
        .byte 0,0
        .asciz "76543210"
        .even
#----------------------------------------------------------------------------}}}

WaitKey: #-------------------------------------------------------------------{{{
        TST  @$KeyboardScanner_P1
        BEQ  .-4
        CLR  @$KeyboardScanner_P1
#----------------------------------------------------------------------------}}}

# 9 br.     # A br.     # B br.     # C br.     # D br.     # E br.     # F white
# 1 blue    # 2 green   # 3 cyan    # 4 red     # 5 magenta # 6 yellow  # 7 gray
TitleScreenPalette: #--------------------------------------------------------{{{
    .byte 0,   0  #--line number, 0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, cursor color is black
    .word 0b10101 #  320 dots per line, pallete 5

    .byte 1,   1  #--line number, set colors
    .byte 0x00, 0x99, 0xCC, 0xFF
    .byte 49,  1  #--line number, set colors
    .byte 0x00, 0x55, 0x11, 0xFF
    .byte 63,  1  #--line number, set colors
    .byte 0x00, 0x55, 0xDD, 0xFF
    .byte 95,  1  #--line number, set colors
    .byte 0x00, 0x22, 0xBB, 0xFF
    .byte 185, 1  #--line number, set colors
    .byte 0x00, 0x22, 0x00, 0xFF
    .byte 192, 1  #--line number, set colors
    .byte 0x00, 0x22, 0xBB, 0xFF
    .byte 196, 1  #--line number, set colors
    .byte 0x00, 0x22, 0xCC, 0xFF

    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
MenuPalette: #---------------------------------------------------------------{{{
    .byte 0, 0    #--line number, 0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10111 #  320 dots per line, pallete 7

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0xDD, 0xEE, 0xFF
    .byte 40, 1
    .byte 0x00, 0xCC, 0xBB, 0xFF
    .byte 60, 1
    .byte 0x00, 0x44, 0xBB, 0xFF
    .byte 67, 1
    .byte 0x00, 0x55, 0xCC, 0xFF
    .byte 88, 1
    .byte 0x00, 0x55, 0xBB, 0xFF
    .byte 113, 1
    .byte 0x00, 0x55, 0x33, 0xFF
    .byte 117, 1
    .byte 0x00, 0x77, 0x33, 0xFF

    .byte 120, 0  # line number, 0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10011 #  320 dots per line, pallete 3

    .byte 121, 1
    .byte 0x00, 0x77, 0xDD, 0xFF

    .byte 136, 0  #--line number, 0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10111 #  320 dots per line, pallete 7

    .byte 137, 1
    .byte 0x00, 0x77, 0xCC, 0xAA

    .byte 190, 0  #--line number, 0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 025     #  320 dots per line, pallete 5

    .byte 191, 1
    .byte 0x00, 0x66, 0xEE, 0xFF

    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
FireKeyBrightPalette: #------------------------------------------------------{{{
    .byte 185, 1  # line number, setup palette
    .byte 0x00, 0x22, 0xEE, 0xFF
    .byte 192, -1 # until the line 192
FireKeyNormalPalette:
    .byte 185, 1
    .byte 0x00, 0x22, 0xCC, 0xFF
    .byte 192, -1
FireKeyDarkPalette:
    .byte 185, 1
    .byte 0x00, 0x22, 0x44, 0xFF
    .byte 192, -1
FireKeyBlackPalette:
    .byte 185, 1
    .byte 0x00, 0x22, 0x00, 0xFF
    .byte 192, -1
#----------------------------------------------------------------------------}}}

PressFireKeyStr: .byte 9,23
                 .asciz "Press Fire to Continue"
                 .even
MenuText1:
                        #0         1         2         3         4
                        #01234567890123456789012345678901234567890
    .byte 10,10; .ascii "Hit ESC to set controls"; .byte 0xFF

    .byte 11,12; .ascii "Start Game as Chibiko"  ; .byte 0xFF
    .byte 11,13; .ascii "Start Game as Bochan "  ; .byte 0xFF
    .byte 11,14; .ascii "Start 2 Player game"    ; .byte 0xFF
    .byte 11,15; .ascii "Watch the Intro"        ; .byte 0xFF
    .byte 11,16; .ascii "Configure Settings "    ; .byte 0xFF
  .ifdef CompileEP2
    .byte 11,17; .ascii "Special Content"        ; .byte 0xFF
    .byte 11,18; .ascii "Credits & Thanks "      ; .byte 0xFF
  .else
    .byte 11,17; .ascii "Credits & Thanks "      ; .byte 0xFF
  .endif

    .byte 10,22; .ascii "www.chibiakumas.com"    ; .byte 0xFF

    .byte  9,24; .ascii "HighScore: "            ; .byte 0x00

    .even

CursorSpr: .incbin "resources/menu_cursor.spr"

DrawChibi: #------------------------------------------------------------------{{{
       .equiv SprDst, FB1+(80*64)
        MOV  $80-6,R1

        MOV  $62,R0
        MOV  $TITLETEX,R4
        ADD  4(R4),R4
        MOV  $SprDst,R5
1$:    .rept 3
        MOV  (R4)+,(R5)+
       .endr
        ADD  R1,R5
        SOB  R0,1$

        MOV  $62,R0
        MOV  $TITLETEX,R4
        ADD  10(R4),R4
        MOV  $SprDst+6,R5
2$:    .rept 3
        MOV  (R4)+,(R5)+
       .endr
        ADD  R1,R5
        SOB  R0,2$

        BR   .
#----------------------------------------------------------------------------}}}
# for some reason GAS replaces the last byte with 0
# so we add the dummy word to avoid data/code corruption
        .word 0xFFFF
end:
