               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to linker

               .equiv  Level00SizeWords, (end - start) >> 1
               .global Level00SizeWords

               .=Akuyou_LevelStart

start:  JMP  @$LevelInit

TITLETEX: .incbin "resources/titletex.spr"

CustomRam: .space 64 # Pos-Tick-Pos-Tick # enough memory for 16 enemies!

EventStreamArray_Ep1: #------------------------------------------------------{{{
    # Load Palette
    .word 0 # -> srcEvent_NextEventTime
    # event MSB->R0, argument LSB->R1
    .word evtMultipleCommands | 1 # Event_CoreMultipleEventsAtOneTime; 1 -> srcEvent_MultipleEventCount
    .word evtCoreReprogram | prgPalette # Event_CoreReprogram; Event_CoreReprogram_Palette
    .word TitleScreenPalette # palette data address

    .word 4 # -> srcEvent_NextEventTime
    # Jump to a different level point
    .word evtMove | mvChangeStreamTime # Event_MoveSwitch; Event_ChangeStreamTime
    .word PauseLoop # pointer
    .word 60        # new time
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
    .word evtCoreReprogram | prgPalette # Event_CoreReprogram; Event_CoreReprogram_Palette
    .word MenuPalette # palette data address

        # ; Background L
        # defb 0
        # defb 128+4     ; SrcALL/Akuyou_Multiplatform_EventStream.asm:182
        #                ; CALL Event_ProgramMoveLifeSwitch_0100
        # defb 1         ; Program - Bitshift Sprite
        # defb %11000001 ; Move - dir Left Slow
        # defb 0         ; Life - immortal
    .word 0 # time
    .word evtMove | mvSetProgMoveLife # CALL Event_ProgramMoveLifeSwitch
    .word 1          # program - bitshift sprite
    .word 0b11000001 # move    - dir left, slow
    .word 0          # life    - immortal
        # defb 0,%10010000+15,0      ; Save Object settings to Bank 0
    .word 0 # time
    .word evtLoadSaveObjSettings | 0x0F # CALL Event_CoreSaveLoadSettings
    .word 0 # Save Object settings to the Slot 0

        # defb 0
        # defb 128+4      ; SrcALL/Akuyou_Multiplatform_EventStream.asm:182
        #                 ; CALL Event_ProgramMoveLifeSwitch_0100
        # defb 1          ; Program - Bitshift Sprite
        # defb %11000010  ; Move    - dir Left Slow
        # defb 0          ; Life    - immortal
    .word 0 # time
    .word evtMove | mvSetProgMoveLife # CALL Event_ProgramMoveLifeSwitch
    .word 1          # program - bitshift sprite
    .word 0b11000010 # move    - dir left, slow
    .word 0          # life    - immortal
        # defb 0,%10010000+15,1      ; Save Object settings to Bank 1
    .word 0 # time
    .word evtLoadSaveObjSettings | 0x0F # CALL Event_CoreSaveLoadSettings
    .word 1 # Save Object settings to the Slot 1

        # defb 0,128+4,0,&24,0       ; Static object
    .word 0 # time
    .word evtMove | mvSetProgMoveLife # CALL Event_ProgramMoveLifeSwitch
    .word 0          # program - bitshift sprite
    .word 0x24       # 0b100100 move - dir left, slow
    .word 0          # life immortal
        # defb 0,%10010000+15,2      ; Save Object settings to Bank 2
    .word 0 # time
    .word evtLoadSaveObjSettings | 0x0F # CALL Event_CoreSaveLoadSettings
    .word 2 # Save Object settings to the Slot 2

        # ;Title
        # defb 0,%01110000+7          ; 7 commands at the same timepoint
    .word 0 # time
    .word evtMultipleCommands | 7 # Event_CoreMultipleEventsAtOneTime; 7 -> srcEvent_MultipleEventCount
        # defb %10010000+0+2          ; Load Settings from bank 2
    .word evtLoadSaveObjSettings | 0x02 # Load Object settings from the Slot 2
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
    .word evtLoadSaveObjSettings | 0x02 # Load Object settings from the Slot 2
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
    .word evtLoadSaveObjSettings | 0x02 # Load Object settings from the Slot 2
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
    .word 4 # -> srcEvent_NextEventTime
    .word evtMove | mvChangeStreamTime # Jump to a different level point
    .word PauseLoop # pointer
    .word 60        # new time

LevelInit:
        MTPS $PR0 # enable interrupts

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        MOV  $Event_SavedSettings,R3  # Saved Settings
        CALL @$Event_StreamInit

        MOV  $EventStreamArray_Ep1,R5 # Event Stream
        MOV  $Event_SavedSettings,R3  # Saved Settings
        CALL @$ResetEventStream

       .ppudo_ensure $PPU_PrintAt,$PressFireKeyStr # Aku/Level00-Menu.asm:1101
        # Aku/Level00-Menu.asm:1103
        CALL @$Timer_UpdateTimer
        CALL @$EventStream_Process
        CALL @$ObjectArray_Redraw

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
       .byte 0x09,0x0C # startpos   ld hl,&090C ; hl = startpos
       .word 0x0001    # movespeed  ld bc,&0001 ; bc = movespeed
       .byte 0x02,0x26 # MinX,MaxX  ld ix,&2602 ; ix = MinX,MaxX
    .ifdef CompileEP2
       .byte 0x0C,0x12 # MinY,MaxY  ld iy,&120C ; iy = MinY,MaxY
    .else
       .byte 0x0C,0x11 # MinY,MaxY  ld iy,&110C ; iy = MinY,MaxY
    .endif

ShowMenu_Loop: #-------------------------------------------------------------{{{
        CALL @$ShowKeysBitmap
        CALL @$Timer_UpdateTimer

        CALL @$EventStream_Process

        WAIT

        BIT  $Keymap_AnyFire,@$KeyboardScanner_P1
        BNZ  MainMenuSelection
                                                            #    push hl
                                                            #        call OnscreenCursor
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
MainMenuSelection:
        JMP  @$ShowMenu_Loop

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
        MOV  (R5)+,@$CursorCurrentPosXY
        MOV  (R5)+,@$CursorMoveSpeedXY

        MOVB (R5)+,@$CursorMinX
        MOVB (R5)+,@$CursorMaxX

        MOVB (R5)+,@$CursorMinY
        MOVB (R5)+,@$CursorMaxY

        RTS  R5
#----------------------------------------------------------------------------}}}
OnscreenCursor: #------------------------------------------------------------{{{
        MOV  (PC)+,R5; CursorCurrentPosXY: .word 0x0101

        MOV  (PC)+,R1; CursorMoveSpeedXY: .word 0x0202
        CursorMaxY: .word 24
        CursorMinY: .word 2
        CursorMaxX: .word 39
        CursorMinX: .word 2
RETURN
#----------------------------------------------------------------------------}}}
ClearChar: #-----------------------------------------------------------------{{{
# c = 12 * 4 (48)
# b =  9 * 2 (18)
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
    .byte 0       #--line number, last line of the top screen area
    .byte 0       #  0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10101 #  320 dots per line, pallete 5
    .byte 1       #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xCC00  #
    .word 0xFF99  #
    .byte 49      #--line number (201 if there is no more parameters)
    .byte 1       #  set colors
    .word 0x1100  #
    .word 0xFF55  #
    .byte 63      #--line number
    .byte 1       #  set colors
    .word 0xDD00  #
    .word 0xFF55  #
    .byte 95      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFF22  #
    .byte 185     #--line number
    .byte 1       #  set colors
    .word 0x0000  #
    .word 0xFF22  #
    .byte 192     #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFF22  #
    .byte 196     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #
    .word 0xFF22  #
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
MenuPalette: #---------------------------------------------------------------{{{
    .byte 0       #--line number, last line of the top screen area
    .byte 0       #  0 - set cursor/scale/palette *always 0 for the first record*
    .word 0b10000 #  graphical cursor
    .word 0b10111 #  320 dots per line, pallete 7
    .byte 1       #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xEE00  #  colors 011 010 001 000 (YRGB)
    .word 0xFFDD  #  colors 111 110 101 100 (YRGB)
    .byte 40      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFFCC  #
    .byte 58      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFF44  #
    .byte 67      #--line number
    .byte 1       #  set colors
    .word 0xCC00  #
    .word 0xFF55  #
    .byte 88      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFF55  #
    .byte 117     #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFF77  #
    .byte 121     #--line number
    .byte 1       #  set colors
    .word 0x9900  #
    .word 0xFF77  #
    .byte 137     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #
    .word 0xAA77  #
    .byte 190     #--line number
    .byte 0       #  0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 025     #  320 dots per line, pallete 5
    .byte 191     #--line number
    .byte 1       #  set colors
    .word 0xEE00  #
    .word 0xFF66  #
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
FireKeyBrightPalette: #------------------------------------------------------{{{
    .byte 185, 1  # starting line 185, setup palette
    .word 0xEE00
    .word 0xFF22
    .byte 192, -1 # until line 192
FireKeyNormalPalette:
    .byte 185, 1
    .word 0xCC00
    .word 0xFF22
    .byte 192, -1
FireKeyDarkPalette:
    .byte 185, 1
    .word 0x4400
    .word 0xFF22
    .byte 192, -1
FireKeyBlackPalette:
    .byte 185, 1
    .word 0x0000
    .word 0xFF22
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
end:
