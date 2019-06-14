#.equiv DiskMap1, 1
#.equiv DiskMap2, 2
#.equiv DiskMap3, 3
#.equiv DiskMap4, 4

                .TITLE Chibi Akumas loader
                .GLOBAL BootstrapStart

                .include "./macros.s"
                .include "./core_defs.s"

                .=040; .word BootstrapStart   # program’s relative start address
                .=042; .word SPReset # initial location of stack pointer
                .=050; .word BootstrapEnd - 2 # address of the program’s highest word

                .=BootstrapStart

        puts $TopStr
        puts $TitleStr
        puts $CreditsStr
        puts $WebSiteStr
Bootstrap_Launch:                       #     ld bc,&7f8D ; Reset the firmware to OFF
                                        #     out (c),c
                                        #     ld hl,RasterColors_InitColors
                                        #     call SetColors
                                        #
        CLR R3                          #     ld h,0
                                        #     ld l,0
                                        #
Bootstrap_FromHL:                       #     ; HL is used as the bootstrap command
                                        #     ; H=1 means levels
                                        #     ; H=0 means system events (Menu etc)
        MOV  R3,R0                      #     ld a,h
        SWAB R0
        TSTB R0                         #     or a
        BEQ  Bootstrap_SystemEvent      #     jr z,Bootstrap_SystemEvent
        CMPB R3,$1                      #     cp 1
        BEQ  Bootstrap_Level            #     jr z,Bootstrap_Level
RETURN                                  # ret

Bootstrap_SystemEvent:
        MOV  R3,R0                      #     ld a,l
        TSTB R0                         #     cp 0
        BEQ  Bootstrap_StartGame        #     jp z,BootsStrap_StartGame
                                        #     cp 1
                                        #     jp z,BootsStrap_ContinueScreen
                                        #     cp 2
                                        #     jp z,BootsStrap_ConfigureControls
                                        #     cp 3
                                        #     jp z,BootStrap_SaveSettings
                                        #     cp 4
                                        #     jp z,GameOverWin
                                        #     cp 5
                                        #     jp z,NewGame_EP2_1UP
                                        #     cp 6
                                        #     jp z,NewGame_EP2_2UP
                                        #     cp 7
                                        #     jp z,NewGame_EP2_2P
                                        #     cp 8
                                        #     jp z,NewGame_CheatStart
RETURN                                  # ret
Bootstrap_Level:
# some missing code...
Bootstrap_StartGame:
        exit
        .include "./bootstrap/start_game.s" #   read "..\AkuCPC\BootsStrap_StartGame_CPC.asm"
        JMP Bootstrap_Level_0           #     jp Bootstrap_Level_0    ; Start the menu
#----------------------------------------------------------------------------}}}
Bootstrap_Level_0:                      # main menu -------------------------{{{
                                        #     call StartANewGame
                                        #     call LevelReset0000
                                        #
                                        #     ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        #     ld c,DiskMap_MainMenu_Disk
                                        #
                                        #     call Bootstrap_LoadEP2Music_Z
                                        #
                                        #     ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        #     ld c,DiskMap_MainMenu_Disk
                                        #
                                        #     ;need to use Specail MSX version - no extra tilemaps
                                        #     jp Bootstrap_LoadEP2Level_1PartOnly;Bootstrap_LoadEP2Level_1Part;Z;_Zpartial
                                        # ret
#----------------------------------------------------------------------------}}}

# .cas_out_open   equ &bc8c
# .cas_out_direct equ &bc98
# .cas_out_close  equ &bc8f
# 
# BootStrap_LoadDiskFile:
#     # HL - pointer to disk file
#     # DE - Destination to write to
#     push de
#     ld de,&C000 ; address of 2k buffer,
#     ld b,12     ; 12 chars
#     call cas_in_open
# 
#     pop hl
#     jr nc, LoadGiveUp
#     call cas_in_direct
# LoadGiveUp:
#     jp cas_in_close

LoadDiskFile:
RETURN

LookupArea:         .BYTE   0,1    # chan, code(.LOOKUP)
    LookupFileName: .WORD   CoreBinRadix50 # dblk

ReadArea:           .BYTE   0,10   # chan, code(.READ/.READC/.READW)
                    .WORD   0 # blk
    ReadBuffer:     .WORD   FileBeginCore # buf
    ReadWordsCount: .WORD   FileSizeCoreWords # wcnt
                    .WORD   0 # end of area(.READW=0,.READ=1)
CoreBinRadix50:
    .byte 0xB8, 0x1A, 0x2A, 0x15, 0x40, 0x1F, 0xF6, 0x0D # .radix50 "DK CORE  BIN"
LookupError:        .ASCIZ  "File lookup error."
ReadError:          .ASCIZ  "File read error."

TopStr:             .ASCIZ  "              _------------------_"
TitleStr:           .ASCIZ  "            -= ChibiAkumas V1.666 =-"
CreditsStr:         .ASCIZ  "-= conversion for the UKNC by aberrant.hacker =-"
WebSiteStr:         .ASCIZ  "              -= chibiakumas.com =-"
        .even
BootstrapEnd:
