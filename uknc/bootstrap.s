#.equiv DiskMap1, 1
#.equiv DiskMap2, 2
#.equiv DiskMap3, 3
#.equiv DiskMap4, 4

                .TITLE BootstrapChibi Akumas loader
                .global Bootstrap_Launch

                .include "./hwdefs.s"
                .include "./macros.s"
                .include "./core_defs.s"

                .=040; .word BootstrapStart   # program’s relative start address
                .=042; .word SPReset          # initial location of stack pointer
                .=050; .word BootstrapEnd - 2 # address of the program’s highest word

                .=BootstrapStart

        .cout $TitleStr
        .cout $WebSiteStr
        .cout $CreditsStr
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
        CLR  PPUCommand
# Prepare screen-lines table to display cover art ---------------------------{{{
        MOV  $PPUBIN, @$LookupFileName
        MOV  $FB1, @$ReadBuffer
        MOV  $PPU_ModuleSizeWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile

        JSR  R5,PPEXEC
        .WORD FB1 # PPU module location
        .WORD PPU_ModuleSizeWords 
#----------------------------------------------------------------------------}}}

        MOV     $8000, R0
        MOV     $FB1, R1
        CLR     R3
1$:     MOV     R3, (R1)+
        SOB     R0, 1$

        MOV     $LoadingSCR, @$LookupFileName # ../AkuCPC/BootsStrap_StartGame_CPC.asm:64
        MOV     $FB1, @$ReadBuffer
        MOV     $8000, @$ReadWordsCount
        CALL    Bootstrap_LoadDiskFile

        CLR     @$CCH0IS
WtKey:  TSTB    @$CCH0IS
        BPL     WtKey

        MOV     $-1, @$PPUCommand
1$:     TST     PPUCommand # wait until PPU finishes command
        BNE     1$

        JSR     R5,PPFREE
        .WORD   PPU_UserRamStart
        .WORD   PPU_ModuleSizeWords
        .exit

       CALL Bootstrap_LoadDiskFile
Finish: .exit
        # loads core
        # loads saved settings
        # TODO: display loading screen
        # TODO: font load
        # TODO: player sprites load
        # TODO: Initialize the Sound Effects.
        .include "./bootstrap/start_game.s" # read "../AkuCPC/BootsStrap_StartGame_CPC.asm"
        JMP  Bootstrap_Level_0              #     jp Bootstrap_Level_0    ; Start the menu
#----------------------------------------------------------------------------}}}
Bootstrap_Level_0:                      # main menu -------------------------{{{
        # ../Aku/BootStrap.asm:2271
        CALL StartANewGame              #     call StartANewGame
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

Bootstrap_LoadDiskFile:
                #.LOOKUP $LkpArea        #.LOOKUP area,chan,dblk[,seqnum]
                MOV     $LookupArea,R0
                EMT     0375
# TODO: carry the carry flag out of the procedure
                BCS     1$
                #.READW  $RdArea         #.READW  area,chan,buf,wcnt,blk[,BMODE=strg]
                MOV     $ReadArea,R0
                EMT     0375
# TODO: carry the carry flag out of the procedure
                BCS     1$
1$:             #.Close  $0              #.CLOSE  chan
                MOV     $0x0600,R0 # operation code 6, channel 0
                EMT     0374
RETURN

        .include "./ppucmd.s"

LookupArea:         .BYTE   0,01 # chan, code(.LOOKUP)
    LookupFileName: .WORD   0 # dblk

ReadArea:           .BYTE   0,010 # chan, code(.READ/.READC/.READW)
                    .WORD   0 # blk
    ReadBuffer:     .WORD   0 # buf
    ReadWordsCount: .WORD   0 # wcnt
                    .WORD   0 # end of area(.READW=0,.READ=1)
CoreBinRad50:
    .byte 0xB8, 0x1A, 0x2A, 0x15, 0x40, 0x1F, 0xF6, 0x0D # .RAD50 "DK CORE  BIN"
SavSetBinRad50: # saved settings bin
    .byte 0xB8, 0x1A, 0xFE, 0x76, 0x9C, 0x77, 0xF6, 0x0D # .RAD50 "DK SAVSETBIN"
PPUBIN:
    .byte 0xB8, 0x1A, 0x95, 0x66, 0x00, 0x00, 0xF6, 0x0D # .RAD50 "DK PPU   BIN"
LoadingSCR:
    .byte 0xB8, 0x1A, 0x59, 0x4D, 0x76, 0x1A, 0x4A, 0x77 # .RAD50 "DK LOADINSCR"
LoadingScreenPalette:
    .word -1,       # line number
    .word  0,       # 0 - cursor/scale/palette
    .word  0b10000, # graphical cursor
    .word  0b10111, # 320 dots per line, pallete 7
    .word  0,       # line number
    .word  1,       # color settings
    .word  0xCC00,  # colors  011  010  001  000 (YRGB)
    .word  0xFF99,  # colors  111  110  101  100 (YRGB)

LookupError:        .ASCIZ  "File lookup error."
ReadError:          .ASCIZ  "File read error."

TitleStr:           .ASCIZ  "         -= ChibiAkumas  V1.666 =-"
WebSiteStr:         .ASCIZ  "         -= www.chibiakumas.com =-"
CreditsStr:         .ASCIZ  "-= converted for the UKNC by aberranth =-"

        .even

StartANewGame:

        .exit
BootstrapEnd:
