               .nolist

               .include "./core_defs.s"

               .global start # make entry point available to a linker
               .global Level07_TitlePalette
               .global level_07_title.bin.lzsa1
               .global Level7_TitleText
               .equiv  Level07TitleSizeWords, (end - start) >> 1
               .global Level07TitleSizeWords

               .=Akuyou_LevelStart

start:

Level07_TitlePalette:
    .word   0, cursorGraphic, scale320 | RGb
    .byte   1, setColors, Black, brMagenta, White, brGreen
    .byte  96, setColors, Black, Magenta, Gray, White
    .byte 104, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen

level_07_title.bin.lzsa1:
    .incbin "build/level_07_title.bin.lzsa1"
                         #0---------1---------2---------3---------
Level7_TitleText:        #0123456789012345678901234567890123456789
    .byte  0, 12; .ascii "The monsters are coming from this cave! " ; .byte 0xFF
    .byte  0, 13; .ascii       "There's only one entrance."         ; .byte 0xFF
    .byte  0, 14; .ascii   "So whoever is sending them must be"     ; .byte 0xFF
    .byte  0, 15; .ascii                "in there! "                ; .byte 0xFF

    .byte  0, 17; .ascii   "It's difficult to see, as the caves "   ; .byte 0xFF
    .byte  0, 18; .ascii    "is are only lit by phosphor rocks "    ; .byte 0xFF
    .byte  0, 19; .ascii         "and Glowing Creatures "           ; .byte 0xFF

    .byte  0, 21; .ascii       "Victory is in your grasp! "         ; .byte 0xFF
    .byte  0, 22; .ascii "Go in there, and 'Sort this shit out!'"   ; .byte 0x00
    .even
end:
