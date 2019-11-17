
                .TITLE Chibi Akumas loader

                .include "./macros.s"
                .include "./core_defs.s"


                .=040; .word LoaderStart   # program’s relative start address
                .=042; .word SPReset       # initial location of stack pointer
                .=050; .word LoaderEnd - 2 # address of the program’s highest word

                .=01000
LoaderStart:

LoaderEnd:
