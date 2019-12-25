               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to linker

               .equiv  Level00SizeWords, (end - start) >> 1
               .global Level00SizeWords

               .=Akuyou_LevelStart

start:  JMP  LevelInit

TITLETEX: .incbin "resources/titletex.spr"

CustomRam: .space 64 # Pos-Tick-Pos-Tick # enough memory for 16 enemies!

EventStreamArray_Ep1: #------------------------------------------------------{{{
    # Load Palette
    .word 0 # -> srcEvent_NextEventTime
    # event MSB->R0, argument LSB->R1
    .word evtMultipleCommands | 1 # Event_CoreMultipleEventsAtOneTime; 1 -> srcEvent_MultipleEventCount
    .word evtCoreReprogram | prgPalette # Event_CoreReprogram; Event_CoreReprogram_Palette
    .word MenuPalette # palette data address

    .word 4 # -> srcEvent_NextEventTime
    # Jump to a different level point
    .word evtMove | mvChangeStreamTime # Event_MoveSwitch; Event_ChangeStreamTime
    .word PauseLoop # pointer
    .word 60        # new time
#----------------------------------------------------------------------------}}}
PauseLoop:
    .word 4 # -> srcEvent_NextEventTime
    .word evtMove | mvChangeStreamTime # Jump to a different level point
    .word PauseLoop # pointer
    .word 60        # new time

LevelInit:
    .ifdef CompileEP2
        MOV  $EventStreamArray_Ep2,R3 # Event Stream
    .else
        MOV  $EventStreamArray_Ep1,R3 # Event Stream
    .endif
        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL Event_StreamInit # uknc/event_stream.s:90

       .ppudo $PPU_PrintAt,$TitleText1 # Aku/Level00-Menu.asm:1101

        CALL Timer_UpdateTimer
        CALL EventStream_Process
        CALL ObjectArray_Redraw # uknc/object_driver.s:77
       .ppudo $PPU_PrintAt,$TestStr

        # call Keys_WaitForRelease

        CALL DrawChibi
        JMP  WaitKeyThenExit

DrawChibi:
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
RETURN

ResetEventStream:
        MOV  $256*4>>2,R1
        MOV  $StarArrayPointer,R2
1$:     CLR  (R2)+
        CLR  (R2)+
        SOB  R1,1$
        MOV  $Event_SavedSettings,R2
RETURN
WaitKeyThenExit: #-----------------------------------------------------------{{{
        TST  @$KeyboardScanner_KeyPresses + 2
        BEQ  .-4
        CLR  @$KeyboardScanner_KeyPresses + 2

       .ppudo $PPU_Finalize

       .exit
#----------------------------------------------------------------------------}}}

MenuPalette: #---------------------------------------------------------------{{{
    .byte 0       #--line number, last line of the top screen area, *required!*
    .byte 0       #  0 - set cursor/scale/palette, *ignored for the first record*
    .word 0b10000 #  graphical cursor
    .word 0b10101 #  320 dots per line, pallete 5
    .byte 1       #--line number, first line of the main screen area, *required!*
    .byte 1       #  set colors
    .word 0xCC00  #  colors 011 010 001 000 (YRGB) | br.red   | black   |
    .word 0xFF99  #  colors 111 110 101 100 (YRGB) | br.white | br.blue |
    .byte 49      #--line number (201 if there is no more parameters)
    .byte 1       #  set colors
    .word 0x1100  #  | blue     | black   |
    .word 0xFF55  #  | br.white | magenta |
    .byte 63      #--line number
    .byte 1       #  set colors
    .word 0xAA00  #  | br.green | black   |
    .word 0xFF55  #  | br.white | magenta |
    .byte 95      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #  | br.cyan  | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 184     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #  | br.cyan  | black   |
    .word 0xFF44  #  | br.white | green   |
    .byte 192
    .byte 1
    .word 0xBB00  #  | br.cyan  | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 196     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #  | br.red   | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
TitleText1: .byte 9,23
            .asciz "Press Fire to Continue"
            .even
TestStr:    .byte 20,10
            .asciz "Test string"
            .even

end:
