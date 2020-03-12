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

EventStreamArray_Menu_EP1: #-------------------------------------------------{{{
                    # ;defb 1,128,&24,128+64+60       ; Move Static

                    # defb 0,%01110000+4          ; 4 Commands
                    #     defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
                    #     defb 1
                    #     defb 1
                    #     defb &54,&54,&54,&54

                    #     defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
                    #     defb 1
                    #     defb 1
                    #     defb &54,&54,&54,&54

                    #     defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
                    #     defb 0
                    #     defb 1
                    #     defb &54,&54,&54,&54

                    #     defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
                    #     defb 1
                    #     defb 1
                    #     defb &54,&54,&54,&54

                    #     defb 0,evtCallAddress
                    #     defw SetFaderEP1Menu

                    # ; We will use 4 Paralax layers
                    # ;  ---------()- (sky)        %11001000
                    # ;  ------------ (Far)        %11000100
                    # ;  -----X---X-- (mid)        %11000010   Bank 1
                    # ;  []=====[]=== (foreground) %11000001   Bank 0

                    # ; Background L
                    # defb 0,128+4,1,%11000001,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
                    # defb 0,%10010000+15,0      ; Save Object settings to Bank 0

                    # defb 0,128+4,1,%11000010,0 ; Program - Bitshift Sprite... Move - dir Left Slow ... Life - immortal
                    # defb 0,%10010000+15,1      ; Save Object settings to Bank 1

                    # defb 0,128+4,0,&24,0       ; Static object
                    # defb 0,%10010000+15,2      ; Save Object settings to Bank 2

                    # ;Title
                    # defb 0,%01110000+7          ; 3 commands at the same timepoint
                    # defb %10010000+0+2          ; Load Settings from bank 2
                    # defb 0,12,12*0+ 24+44,24+16 ; Single Object sprite 11 (animated)
                    # defb 0,13,12*1+ 24+44,24+16 ; Single Object sprite 11 (animated)
                    # defb 0,14,12*2+ 24+44,24+16 ; Single Object sprite 11 (animated)
                    # defb 0,15,12*3+ 24+44,24+16 ; Single Object sprite 11 (animated)
                    # defb 0,16,12*4+ 24+44,24+16 ; Single Object sprite 11 (animated)
                    # defb 0,17,12*5+ 24+44,24+16 ; Single Object sprite 11 (animated)

                    # ;Chibiko
                    # defb 0,%01110000+3      ; 3 commands at the same timepoint
                    # defb %10010000+0+2      ; Load Settings from bank 2
                    # defb 0,0,12*0+ 24,24+64 ; Single Object sprite 11 (animated)
                    # defb 0,1,12*1+ 24,24+64 ; Single Object sprite 11 (animated)

                    # ;Bochan!
                    # defb 0,%01110000+3                 ; 3 commands at the same timepoint
                    # defb %10010000+0+2                 ; Load Settings from bank 2
                    # defb 0,2,12*0+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)
                    # defb 0,3,12*1+ 24+160-24,24+200-64 ; Single Object sprite 11 (animated)

                    # ;Palette Change
                    # defb 1,%01110000+4      ; 4 Commands
                    #     defb 240,0,6        ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
                    #     defb 1
                    #     defb 1
                    #     defb &54,&54,&44,&40

                    #     defb 240,26*0+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
                    #     defb 1
                    #     defb 1
                    #     defb &54,&54,&44,&40

                    #     defb 240,26*1+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
                    #     defb 0
                    #     defb 1
                    #     defb &54,&54,&44,&40

                    #     defb 240,26*2+6,6   ; (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
                    #     defb 1
                    #     defb 1
                    #     defb &54,&54,&44,&40
#----------------------------------------------------------------------------}}}
PauseLoop:
    .word 4 # -> srcEvent_NextEventTime
    .word evtMove | mvChangeStreamTime # Jump to a different level point
    .word PauseLoop # pointer
    .word 60        # new time

LevelInit:
        MOV  $EventStreamArray_Ep1,R3 # Event Stream
        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL Event_StreamInit # uknc/event_stream.s:90

       .ppudo_ensure $PPU_PrintAt,$TitleText1 # Aku/Level00-Menu.asm:1101
        # Aku/Level00-Menu.asm:1103
        CALL Timer_UpdateTimer
        CALL EventStream_Process
        CALL ObjectArray_Redraw # uknc/object_driver.s:74

        CLR  @$KeyboardScanner_KeyPresses + 2 # call Keys_WaitForRelease

ShowTitlePic_Loop:
        CALL Timer_UpdateTimer
        CALL EventStream_Process
        WAIT

       .ppudo $PPU_SetPalette, $AnyKeyNormalPalette
        CALL glow_delay$
       .ppudo $PPU_SetPalette, $AnyKeyDarkPalette
        CALL glow_delay$
       .ppudo $PPU_SetPalette, $AnyKeyBlackPalette
        CALL glow_delay$
       .ppudo $PPU_SetPalette, $AnyKeyDarkPalette
        CALL glow_delay$

        TST  @$KeyboardScanner_KeyPresses + 2
        BNE  ShowMenu

        JMP  ShowTitlePic_Loop
    glow_delay$:
        MOV  $0x6FFF, R0
        SOB  R0,.
        RETURN

ShowMenu:
       .ppudo_ensure $PPU_PrintAt,$TestStr
        CALL DrawChibi

        MOV  EventStreamArray_Menu_EP1
        CALL ResetEventStream
        # CALL Akuyou_CLS

        JMP  .

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

WaitKey: #-------------------------------------------------------------------{{{
        TST  @$KeyboardScanner_KeyPresses + 2
        BEQ  .-4
        CLR  @$KeyboardScanner_KeyPresses + 2
#----------------------------------------------------------------------------}}}

MenuPalette: #---------------------------------------------------------------{{{
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
AnyKeyNormalPalette: #-------------------------------------------------------{{{
    .byte 185, 1
    .word 0xCC00
    .word 0xFF44
    .byte 192, -1
AnyKeyDarkPalette:
    .byte 185, 1
    .word 0xEE00
    .word 0xFF66
    .byte 192, -1
AnyKeyBlackPalette:
    .byte 185, 1
    .word 0xFF00
    .word 0xFFFF
    .byte 192, -1
#----------------------------------------------------------------------------}}}

TitleText1: .byte 9,23
            .asciz "Press Fire to Continue"
            .even

TestStr:    .byte 20,10
            .asciz "Test string"
            .even
end:
