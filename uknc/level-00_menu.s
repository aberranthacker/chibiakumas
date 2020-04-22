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
        MOV  $EventStreamArray_Ep1,R3 # Event Stream
        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL @$Event_StreamInit

        MOV  $EventStreamArray_Ep1,R3 # Event Stream
        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL @$ResetEventStream

       .ppudo_ensure $PPU_PrintAt,$TitleText1 # Aku/Level00-Menu.asm:1101
        # Aku/Level00-Menu.asm:1103
        CALL @$Timer_UpdateTimer
        CALL @$EventStream_Process
        CALL @$ObjectArray_Redraw

        CLR  @$KeyboardScanner_KeyPresses + 2 # call Keys_WaitForRelease

.ifdef ShowLoadingScreen
ShowTitlePic_Loop:
       .ppudo $PPU_SetPalette, $FireKeyDarkPalette
        CALL @$glow_delay$
       .ppudo $PPU_SetPalette, $FireKeyNormalPalette
        CALL @$glow_delay$
       .ppudo $PPU_SetPalette, $FireKeyBrightPalette
        CALL @$glow_delay$
       .ppudo $PPU_SetPalette, $FireKeyNormalPalette
        CALL @$glow_delay$

        TST  @$KeyboardScanner_KeyPresses + 2
        BNE  ShowMenu

        JMP  @$ShowTitlePic_Loop
    glow_delay$:
        MOV  $0xAFFF, R0
        SOB  R0,.
        RETURN
.endif

ShowMenu:
    .ifdef CompileEP2
        MOV  $EventStreamArray_Menu_EP2, R3
    .else
        MOV  $EventStreamArray_Menu_EP1, R3
    .endif
        .list
        CALL @$ResetEventStream

        CALL @$CLS
       .ppudo_ensure $PPU_PrintAt,$MenuText1

        # CALL CallFade # Aku/Level00-Menu.asm:1170

        # TODO: show hiscore value
        CALL @$Timer_UpdateTimer # Aku/Level00-Menu.asm:1180
        CALL @$EventStream_Process
        CALL @$ObjectArray_Redraw
        .nolist

       # .ppudo_ensure $PPU_PrintAt,$TestStr

        BR   .
        JMP  @$DrawChibi

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

ResetEventStream:
        MOV  $GameVarsArraysSize>>2,R0
        MOV  $Akuyou_GameVarsStart,R1
100$:   CLR  (R1)+
        CLR  (R1)+
        SOB  R0,100$

        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL @$Event_StreamInit
RETURN

WaitKey: #-------------------------------------------------------------------{{{
        TST  @$KeyboardScanner_KeyPresses + 2
        BEQ  .-4
        CLR  @$KeyboardScanner_KeyPresses + 2
#----------------------------------------------------------------------------}}}

TitleScreenPalette: #---------------------------------------------------------------{{{
    .byte 1       #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xCC00  #  colors 011 010 001 000 (YRGB) | br.red   | black   |
    .word 0xFF99  #  colors 111 110 101 100 (YRGB) | br.white | br.blue |
    .byte 49      #--line number (201 if there is no more parameters)
    .byte 1       #  set colors
    .word 0x1100  #  | blue     | black   |
    .word 0xFF55  #  | br.white | magenta |
    .byte 63      #--line number
    .byte 1       #  set colors
    .word 0xDD00  #  | br.magenta| black  |
    .word 0xFF55  #  | br.white | magenta |
    .byte 95      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #  | br.cyan  | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 185     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #  | br.red   | black   |
    .word 0xFF44  #  | br.white | red     |
    .byte 192     #--line number
    .byte 1       #  set colors
    .word 0xBB00  #  | br.cyan  | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 196     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #  | br.red   | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}

# 9 br.     # A br.     # B br.     # C br.     # D br.     # E br.     # F white
# 1 blue    # 2 green   # 3 cyan    # 4 red     # 5 magenta # 6 yellow  # 7 gray
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
    .byte 185, 1  # starting line 185 setup palette
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
#----------------------------------------------------------------------------}}}

TitleText1: .byte 9,23
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

TestStr:    .byte 20,10
            .asciz "Test string"
            .even
end:
