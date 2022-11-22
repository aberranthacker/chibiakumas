               .nolist

               .include "./core_defs.s"

               .global start # make entry point available to a linker
               .global level_05_title.bin.lzsa1
               .global Level05_TitlePalette
               .global Level05_TitleText

               .equiv  Level05TitleSizeWords, (end - start) >> 1
               .global Level05TitleSizeWords

               .=Akuyou_LevelStart

start:

Level05_TitlePalette:
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Magenta, brCyan, White
    .word 103, cursorGraphic, scale320 | rgB
    .byte 104, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen

level_05_title.bin.lzsa1:
    .incbin "build/level_05_title.bin.lzsa1"
    .even
                         #0---------1---------2---------3---------
Level05_TitleText:       #0123456789012345678901234567890123456789
    .byte  3, 13; .ascii    "After defeating the evil zombified"    ; .byte 0xFF ; .even
    .byte  3, 14; .ascii    "merchandise cash-cow, and narrowly"    ; .byte 0xFF ; .even
    .byte  5, 15; .ascii      "avoding buying the plush doll"       ; .byte 0xFF ; .even
    .byte  4, 16; .ascii     "Chibiko headed down to the river,"    ; .byte 0xFF ; .even
    .byte  4, 17; .ascii     "only find it also full of weird"      ; .byte 0xFF ; .even
    .byte  4, 18; .ascii     "stuff too! Heading to the source"     ; .byte 0xFF ; .even
    .byte  5, 19; .ascii      "will reveal whoever sent them"       ; .byte 0xFF ; .even
    .byte  4, 20; .ascii    "and stop this annoyance once and"      ; .byte 0xFF ; .even
    .byte 15, 21; .ascii                "for all!"                  ; .byte 0x00 ; .even
end:

