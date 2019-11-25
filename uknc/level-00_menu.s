
       .include "./hwdefs.s"
       .include "./macros.s"
       .include "./core_defs.s"

       .global start # make entry point available to linker

       .equiv  Level00SizeWords, (end - start) >> 1
       .global Level00SizeWords

       .=Akuyou_LevelStart

start:
        JMP  LevelInit

CustomRam: .space 64 # Pos-Tick-Pos-Tick # enough memory for 16 enemies!

EventStreamArray_EP1: #------------------------------------------------------{{{
    # Load Palette
    .byte 0,0b01110000+4   # 4 Commands
    .byte 240,0,6          # (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 0
    .byte 1                    # 2
    .byte 1                    # 3
    .byte 0x54,0x55,0x4C,0x4B  # 4

    .byte 240,26*0+6,5*2+1 # (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    .byte 2     # Switches     # 6
    .byte 0     # delay        # 7
    .byte 0x54,0x55,0x4C,0x4B  # 8
    .byte 64+16 # delay        # 9
    .byte 0x54,0x58,0x5F,0x4B  #10

    .byte 240,26*1+6,5*1+1 # (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    .byte 1                    #12
    .byte 48                   #13
    .byte 0x54,0x56,0x5B,0x4B  #14

    .byte 240,26*2+6,5*3+1 # (Time,Cmd,Off,Bytes) load 5 bytes into the palette Offset 21*2+5
    .byte 3   # no of switches #15
    .byte 0   # delays         #16
    .byte 0x54,0x56,0x5B,0x4B  #17
    .byte 255 # delays         #18
    .byte 0x54,0x4C,0x4D,0x4B  #19
    .byte 36  # delays         #20
    .byte 0x54,0x56,0x5B,0x4B  #21

.byte 4
    .byte 136       # Jump to a different level point
    .word PauseLoop # pointer
    .byte 60        # new time

    .even
#----------------------------------------------------------------------------}}}
PauseLoop:
   .byte 4
       .byte 136       # Jump to a different level point
       .word PauseLoop # pointer
       .byte 60        # new time
    .even

LevelInit:
        MOV  $Player_Array,R5

    .ifdef CompileEP2
        MOV  $EventStreamArray_Ep2,R3 # Event Stream
    .else
        MOV  $EventStreamArray_Ep1,R3 # Event Stream
    .endif
        MOV  $Event_SavedSettings,R2  # Saved Settings
        CALL AkuYou_Event_StreamInit

        #call Akuyou_Music_Restart
        #call Akuyou_ScreenBuffer_Reset
        #call Akuyou_Interrupt_Init

        #JMP ShowTitlePic

        JMP  WaitKeyThenExit

WaitKeyThenExit: #-----------------------------------------------------------{{{
        TST  @$KeyboardScanner_KeyPresses + 2
        BEQ  .-4
        CLR  @$KeyboardScanner_KeyPresses + 2

        MOV  $PPU_Finalize, @$PPUCommand
        TST  @$PPUCommand # wait until PPU finishes command
        BNE  .-4

       .exit
#----------------------------------------------------------------------------}}}
end:
