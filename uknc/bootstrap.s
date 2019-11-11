
                .TITLE BootstrapChibi Akumas loader

                .global Bootstrap_Launch
                .global LoadingScreenPalette

                .include "./hwdefs.s"
                .include "./macros.s"
                .include "./core_defs.s"

                .=040; .word BootstrapStart   # program’s relative start address
                .=042; .word SPReset          # initial location of stack pointer
                .=050; .word BootstrapEnd - 2 # address of the program’s highest word

                .=BootstrapStart

        .cout $TextInit
        .cout $TitleStr
        .cout $WebSiteStr
        .cout $CreditsStr
Bootstrap_Launch:
        CLR R3

Bootstrap_FromHL:                  # HL is used as the bootstrap command
        MOV  R3,R0                 # H=1 means levels
        SWAB R0                    # H=0 means system events (Menu etc)
                                   # SWAB sets Z flag if low-order byte of result = 0
        BEQ  Bootstrap_SystemEvent
        CMPB R3,$1
        BEQ  Bootstrap_Level
RETURN

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
# Prepare screen-lines table to display loading screen ----------------------{{{
        MOV  $PPUBIN, @$LookupFileName
        MOV  $FB1, @$ReadBuffer
        MOV  $PPU_ModuleSizeWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile

        CLR  PPUCommand

        JSR  R5,PPEXEC
        .WORD FB1 # PPU module location
        .WORD PPU_ModuleSizeWords
#----------------------------------------------------------------------------}}}
# clear main screen area ----------------------------------------------------{{{
        MOV  $4000, R0
        MOV  $FB1, R1
        CLR  R3
1$:     MOV  R3, (R1)+
        MOV  R3, (R1)+
        SOB  R0, 1$
#----------------------------------------------------------------------------}}}
# load loading screen -------------------------------------------------------{{{
        MOV  $PPU_SetPalette, @$PPUCommand
        MOV  $PPU_LoadingScreenPalette, @$PPUCommandArg

        MOV  $LoadingSCR, @$LookupFileName # ../AkuCPC/BootsStrap_StartGame_CPC.asm:64
        MOV  $FB1, @$ReadBuffer
        MOV  $8000, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile
#----------------------------------------------------------------------------}}}
        # Load the game core - this is always in memory
        MOV  $CoreBin, @$LookupFileName
        MOV  $FileBeginCore, @$ReadBuffer
        MOV  $FileSizeCoreWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile
        # Load saved settings
        MOV  $SavSetBin, @$LookupFileName
        MOV  $SavedSettings, @$ReadBuffer
        MOV  $FileSizeSettingsWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile

        # TODO: font load
        # TODO: player sprites load
        # TODO: Initialize the Sound Effects.
#----------------------------------------------------------------------------}}}
Bootstrap_Level_0: # ../Aku/BootStrap.asm:838  main menu --------------------{{{
        MOV  $SPReset,SP # we are not returning, so reset the stack # 01600
        CALL StartANewGame              # call StartANewGame # 01664
                                        # call LevelReset0000
                                        #
                                        # ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        # ld c,DiskMap_MainMenu_Disk
                                        #
                                        # call Bootstrap_LoadEP2Music_Z
                                        #
                                        # ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        # ld c,DiskMap_MainMenu_Disk
                                        #
                                        # ;need to use Specail MSX version - no extra tilemaps
                                        # jp Bootstrap_LoadEP2Level_1PartOnly
         RETURN                         # ret
#----------------------------------------------------------------------------}}}
Player_Dead_ResumeB: # ../Aku/BootStrap.asm:1411
        SpendCreditSelfMod2:
            MOV  $Player_Array,R5 # ld iy,Player_Array ; All credits are (currently) stored in player 1's var!

FireMode_Normal: # ../Aku/BootStrap.asm:2116
        MOV  $NULL,R3
        MOV  R3,@$dstFireUpHandler
        MOV  R3,@$dstFireDownHandler
        MOV  R3,@$dstFireLeftHandler
        MOV  R3,@$dstFireRightHandler

        MOV  $SetFireDir_LEFTsave, @$dstFire1Handler
        MOV  $SetFireDir_RIGHTsave,@$dstFire2Handler
        BR   FireMode_Both

FireMode_4D: # ../Aku/BootStrap.asm:2128
        MOV  $SetFireDir_UP,   @$dstFireUpHandler
        MOV  $SetFireDir_DOWN, @$dstFireDownHandler
        MOV  $SetFireDir_LEFT, @$dstFireLeftHandler
        MOV  $SetFireDir_RIGHT,@$dstFireRightHandler

        MOV  $SetFireDir_Fire, @$dstFire1Handler
        MOV  $SetFireDir_FireAndSaveRestore,@$dstFire2Handler

FireMode_Both: # ../Aku/BootStrap.asm:2143
        MOV $255,@$dstDroneFlipFireCurrent
        RETURN

StartANewGame: # ../Aku/BootStrap.asm:2151
        # reset the core                 # xor a
        CLR  @$srcShowContinueCounter    # ld (ShowContinueCounter_Plus1-1),a

        MOV  $0012700,R0 # MOV (PC)+,R0  # ld bc,&3E0D ;Split Continues ; 3E n = LD A,n
        MOV  $0x0D,R1
        MOV  $0013704,R2 # MOV @(PC)+,R4 # ld de,&2ADD ; LD IX, (addr) = DD 2A dr ad
                                         # ld a,(ContinueMode)
        TSTB @$ContinueMode              # or a
        BNE  ContinueModeSet             # jr nz,ContinueModeSet

        MOV  $0000207,R0 # RTS PC        # ld bc,&C90E ;Shared Continues ; C9 = RET
        MOV  $0x0E,R1
        MOV  $0012705,R2 # MOV (PC)+,R5  # ld de,&21FD ; LD IY, hilo   = FD 21 lo hi

ContinueModeSet: # ../Aku/BootStrap.asm:2165
        MOV  R0,@$ShowContinuesSelfMod
        MOV  R1,@$srcContinuesScreenPos
        MOV  R2,@$SpendCreditSelfMod
        MOV  R2,@$SpendCreditSelfMod2

        CALL FireMode_Normal # set our standard Left-Right Firemode
        # reset all the scores n stuff
        CALL AkuYou_Player_GetPlayerVars # $Player_Array -> R5
                                                            #     ld a,(iy-15)
        BITB $0x80,-15(R5)                                  #     and %10000000
        BEQ  1$                                             #     call nz,FireMode_4D
        CALL FireMode_4D                                    #
                                                            #     ld a,1
1$:     MOVB $1,-7(R5)                                      #     ld (iy-7),a ;live players
                                                            #
                                                            #     ;multiplay support
        MOV  $0x003E,R3                                     #     ld hl,&003E
                                                            #     ld a,(MultiplayConfig)
        BITB $0,@$MultiplayConfig                           #     bit 0,a
        BEQ  StartANewGame_NoMultiplay                      #     jr z,StartANewGame_NoMultiplay
                                                            #     ld bc,&F990
                                                            #     in a,(c) ;Test if the multiplay is really there!
                                                            #     inc a
                                                            #     jr z,StartANewGame_NoMultiplay
                                                            #     ld hl,&78ED

StartANewGame_NoMultiplay: # ../Aku/BootStrap.asm:2195
StartANewGame_NoControlFlip: # ../Aku/BootStrap.asm:2206
        MOV  $Player_Array, R5
        CALL StartANewGamePlayer
        MOV  $Player_Array2,R5
        CALL StartANewGamePlayer
                                          # ld hl,Player_ScoreBytes
                                          # ld b,8*2
                                          # xor a
        .putstr $YahooStr
        .putstr $LongStr
        .putstr $YahooStr
        .putstr $YahooStr
        .putstr $YahooStr
        .putstr $LongStr
        .putstr $YahooStr
        .putstr $YahooStr

        JMP  WaitKeyThenExit

                 #0         1         2         3         4         5         6         7
                 #01234567890123456789012345678901234567890123456789012345678901234567890123456789
YahooStr: .asciz "Yippee! Whoopee! Woo-hoo! Yay! Hurrah!\n"
LongStr:  .asciz "This is a very very very very very very very very very very very long string.\n"

        .even

StartANewGamePlayer: # ../Aku/BootStrap.asm:2256 ;player fire directions
        ADD  $2,R5
        CLR  R0
        MOVB R0,   (R5)+  #  2 Fire Delay
        MOVB @$SmartBombsReset,(R5)+ # 3 smartbombs
        MOVB R0,   (R5)+  #  4 drones
        MOVB @$ContinuesReset, (R5)+ # 5 continues
        MOVB $16,  (R5)+  #  6 drone pos
        MOVB $7,   (R5)+  #  7 invincibility 0b00000111
        MOVB R0,   (R5)+  #  8 spritenum
        MOVB R0,   (R5)+  #  9 Player Lives (default both players to dead)
        MOVB R0,   (R5)+  # 10 burst fire xfire
        MOVB $4,   (R5)+  # 11 Fire Speed    0b00000100
        INC  R5
        MOVB R0,   (R5)+  # 13 Points to add
        MOVB R0,   (R5)+  # 14 player shoot power
        MOVB $0x67,(R5)+  # 15 Fire dir
RETURN

WaitKeyThenExit:
        CALL WaitKey
        MOV  $PPU_Finalize, @$PPUCommand
        TST  @$PPUCommand # wait until PPU finishes command
        BNE  .-4

        JSR  R5,PPFREE
        .word PPU_UserRamStart
        .word PPU_ModuleSizeWords

Finish: .exit

Bootstrap_LoadDiskFile: #----------------------------------------------------{{{
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

        #.LOOKUP $LkpArea  #.LOOKUP area,chan,dblk[,seqnum]
        MOV  $LookupArea,R0
        EMT  0375
        BCS  1$ # TODO: carry the carry flag out of the procedure

        #.READW  $RdArea   #.READW  area,chan,buf,wcnt,blk[,BMODE=strg]
        MOV  $ReadArea,R0
        EMT  0375

        #.Close  $0      #.CLOSE  chan
        MOV  $0x0600,R0 # operation code 6, channel 0
        EMT  0374       # close channel

1$:     RETURN
#----------------------------------------------------------------------------}}}

WaitKey:
        TST  @$KeyboardScanner_KeyPresses + 2
        BEQ  .-4
        CLR  @$KeyboardScanner_KeyPresses + 2
        RETURN

            .include "./ppucmd.s"

# files related data --------------------------------------------------------{{{
LookupArea:         .byte  0,01 # chan, code(.LOOKUP)
    LookupFileName: .word  0 # dblk

ReadArea:           .byte  0,010 # chan, code(.READ/.READC/.READW)
                    .word  0 # blk
    ReadBuffer:     .word  0 # buf
    ReadWordsCount: .word  0 # wcnt
                    .word  0 # end of area(.READW=0,.READ=1)
CoreBin:
    .word 0x1AB8, 0x152A, 0x1F40, 0x0DF6 # .RAD50 "DK CORE  BIN"
SavSetBin: # saved settings bin
    .word 0x1AB8, 0x76FE, 0x779C, 0x0DF6 # .RAD50 "DK SAVSETBIN"
PPUBIN:
    .word 0x1AB8, 0x6695, 0x0000, 0x0DF6 # .RAD50 "DK PPU   BIN"
LoadingSCR:
    .word 0x1AB8, 0x4D59, 0x1A76, 0x774A # .RAD50 "DK LOADINSCR"

LookupError: .asciz "File lookup error."
ReadError:   .asciz "File read error."
#----------------------------------------------------------------------------}}}
LoadingScreenPalette: #------------------------------------------------------{{{
    .word 0       #--line number, last line of the top screen area, *required!*
    .word 0       #  0 - set cursor/scale/palette, *ignored for the first record*
    .word 0b10000 #  graphical cursor
    .word 0b10101 #  320 dots per line, pallete 5
    .word 1       #--line number, first line of the main screen area, *required!*
    .word 1       #  set colors
    .word 0xCC00  #  colors 011 010 001 000 (YRGB) | br.red   | black   |
    .word 0xFF99  #  colors 111 110 101 100 (YRGB) | br.white | br.blue |
    .word 49      #--line number (201 if there is no more parameters)
    .word 1       #  set colors
    .word 0x1100  #  | blue     | black   |
    .word 0xFF55  #  | br.white | magenta |
    .word 63      #--line number
    .word 1       #  set colors
    .word 0xAA00  #  | br.green | black   |
    .word 0xFF55  #  | br.white | magenta |
    .word 95      #--line number
    .word 1       #  set colors
    .word 0xBB00  #  | br.cyan  | black   |
    .word 0xFF22  #  | br.white | green   |
    .word 195     #--line number
    .word 1       #  set colors
    .word 0xCC00  #  | br.red   | black   |
    .word 0xFF22  #  | br.white | green   |
    .word 201     #--line number, 201 - end of the main screen params
#----------------------------------------------------------------------------}}}

TextInit:    .byte  0033, 0240, '2 # symbol color
             .byte  0033, 0241, '0 # symbol background color
             .byte  0033, 0242, '0 # screen color
             .byte  0033, 0045, 0041, 0061             # order screenlines and
             .byte  0033, 0133, 0060, 0075, 0060, 0162 # clear screen
             .byte  0
TitleStr:    .asciz "      -= ChibiAkumas  V1.666 =-"
WebSiteStr:  .asciz "      -= www.chibiakumas.com =-"
CreditsStr:  .asciz "-= UKNC version by aberrant.hacker =-"

        .even
BootstrapEnd:
