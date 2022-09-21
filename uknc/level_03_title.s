               .nolist

               .include "./core_defs.s"

               .global start # make entry point available to a linker
               .global Level03_TitlePalette
               .global level_03_title.bin.lzsa1
               .global Level03_TitleText

               .equiv  Level03TitleSizeWords, (end - start) >> 1
               .global Level03TitleSizeWords

               .=Akuyou_LevelStart

start:

Level03_TitlePalette:
    .word   0, cursorGraphic, scale320 | RGb
    .byte   1, setColors, Black, brMagenta, White, brGreen
    .byte  96, setColors, Black, Magenta, Gray, White
    .byte 104, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen

level_03_title.bin.lzsa1:
    .incbin "build/level_03_title.bin.lzsa1"
                         #0---------1---------2---------3---------
Level03_TitleText:       #0123456789012345678901234567890123456789
    .byte  3, 13; .ascii   "The monsters climbing the mountain"     ; .byte 0xFF ; .even
    .byte  3, 14; .ascii   "seem to be coming from the forest"      ; .byte 0xFF ; .even
    .byte  2, 15; .ascii  "it's time to push forward, and stop"     ; .byte 0xFF ; .even
    .byte 13, 16; .ascii             "the invasion!"                ; .byte 0xFF ; .even
    .byte  3, 17; .ascii   "The animals of the forest seem to"      ; .byte 0xFF ; .even
    .byte  3, 18; .ascii   "have become mutants, zombies, and"      ; .byte 0xFF ; .even
    .byte  8, 19; .ascii        "generally super-annoyng."          ; .byte 0xFF ; .even

    .byte  3, 21; .ascii   "But no matter what zombified evil"      ; .byte 0xFF ; .even
    .byte  3, 22; .ascii   "lurks in the heart of the forest"       ; .byte 0xFF ; .even
    .byte  3, 23; .ascii   "it will be no match for Chibiko's"      ; .byte 0xFF ; .even
    .byte 13, 24; .ascii             "Black Magic!!!"               ; .byte 0x00 ; .even
    .even
end:
