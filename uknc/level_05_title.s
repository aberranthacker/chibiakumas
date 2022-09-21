               .nolist

               .include "./core_defs.s"

               .global start # make entry point available to a linker
               .global Level05_TitlePalette
               .global level_05_title.bin.lzsa1
               .global Level5_TitleText
               .equiv  Level05TitleSizeWords, (end - start) >> 1
               .global Level05TitleSizeWords

               .=Akuyou_LevelStart

start:

Level05_TitlePalette:
    .word   0, cursorGraphic, scale320 | RGb
    .byte   1, setColors, Black, brMagenta, White, brGreen
    .byte  96, setColors, Black, Magenta, Gray, White
    .byte 104, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen

level_05_title.bin.lzsa1:
    .incbin "build/level_05_title.bin.lzsa1"
                         #0---------1---------2---------3---------
Level5_TitleText:        #0123456789012345678901234567890123456789
    .byte  3, 12; .ascii    "After defeating the evil zombified "   ; .byte 0xFF
    .byte  3, 13; .ascii    "merchandise cash-cow, and narrowly "   ; .byte 0xFF
    .byte  5, 14; .ascii      "avoding buying the plush doll"       ; .byte 0xFF
    .byte  4, 15; .ascii     "Chibiko headed down to the river,"    ; .byte 0xFF
    .byte  4, 16; .ascii     "only find it also full of weird"      ; .byte 0xFF
    .byte  4, 17; .ascii     "stuff too! Heading to the source "    ; .byte 0xFF
    .byte  5, 18; .ascii      "will reveal whoever sent them"       ; .byte 0xFF
    .byte  4, 19; .ascii    "and stop this annoyance once and "     ; .byte 0xFF
    .byte 15, 20; .ascii                "for all! "                 ; .byte 0x00
    .even
end:
