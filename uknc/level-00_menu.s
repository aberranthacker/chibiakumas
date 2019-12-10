               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"

               .global start # make entry point available to linker

               .equiv  Level00SizeWords, (end - start) >> 1
               .global Level00SizeWords

               .=Akuyou_LevelStart

start:  JMP  LevelInit

TITLETEX: .incbin "resources/titletex.spr"
       .even
LevelStartedStr: .asciz "Level 0 just started."
       .even
CustomRam: .space 64 # Pos-Tick-Pos-Tick # enough memory for 16 enemies!

EventStreamArray_Ep1: #------------------------------------------------------{{{
    # Load Palette
    .byte 0 # -> srcEvent_NextEventTime
    # MSN->R0, LSN->R1
    .byte 0x70 | 1 # 0x70 - multiple commands, 1 -> srcEvent_MultipleEventCount
    # (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    .byte 0xF0 | 0 # Event_CoreReprogram | Event_CoreReprogram_Palette
    .word 0x0000 # palette data address

    .byte 4 # -> srcEvent_NextEventTime
    .byte 136       # Jump to a different level point
    .word PauseLoop # pointer
    .byte 60        # new time

    .even
#----------------------------------------------------------------------------}}}
PauseLoop:
    .byte 4 # srcEvent_NextEventTime
       .byte 136       # Jump to a different level point
       .word PauseLoop # pointer
       .byte 60        # new time
       .even

LevelInit:
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

    .ifdef CompileEP2
        MOV  $EventStreamArray_Ep2,R3 # Event Stream
    .else
        MOV  $EventStreamArray_Ep1,R3 # Event Stream
    .endif
        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL Event_StreamInit # uknc/event_stream.s:90

       .ppudo $PPU_PrintAt,$TitleText1 # Aku/Level00-Menu.asm:1101

        JMP  WaitKeyThenExit

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
TitleText1: .byte 9,22
            .asciz "Press Fire to Continue"
            .even

end:
