               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Level01SizeWords, (end - start) >> 1
               .global Level01SizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit

       .incbin "resources/level01.spr"
LevelTiles:
       .incbin "resources/level01-tiles.spr"

CustomRam: .space 64 # Pos-Tick-Pos-Tick # enough memory for 16 enemies!

EventStreamArray: #------------------------------------------------------{{{
#----------------------------------------------------------------------------}}}

EndLevel:
        MOV  $0x8000,R5
        JMP  @$ExecuteBootstrap

LevelInit:
        JMP  @$EndLevel

      # MOV  $EventStreamArray_Ep1,R5 # Event Stream
      # MOV  $Event_SavedSettings,R3  # Saved Settings
      # CALL @$Event_StreamInit

      #.ppudo_ensure $PPU_LoadMusic,$TitleMusic
      #.ppudo_ensure $PPU_MusicRestart

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

# for some reason GAS replaces the last byte with 0
# so we add the dummy word to avoid data/code corruption
        .word 0xFFFF
end:
