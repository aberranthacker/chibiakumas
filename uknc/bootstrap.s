
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
        MOV  $LoadingSCR, @$LookupFileName # ../AkuCPC/BootsStrap_StartGame_CPC.asm:64
        MOV  $FB1, @$ReadBuffer
        MOV  $8000, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile

        MOV  $PPU_SetPalette, @$PPUCommand
        MOV  $PPU_LoadingScreenPalette, @$PPUCommandArg
#----------------------------------------------------------------------------}}}

        MOV  @$SPReset,SP # we are not returning, so reset the stack

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
            .include "./bootstrap/start_game.s" # read "../AkuCPC/BootsStrap_StartGame_CPC.asm"
        JMP  Bootstrap_Level_0 # Start the menu
#----------------------------------------------------------------------------}}}
Bootstrap_Level_0: # ../Aku/BootStrap.asm:838  main menu --------------------{{{
        CALL StartANewGame              # call StartANewGame
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
        MOV  $0012704,R2 # MOV @(PC)+,R4 # ld de,&2ADD ; LD IX, (addr) = DD 2A dr ad
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
        #reset all the scores n stuff
        CALL AkuYou_Player_GetPlayerVars
                                                            #     ld a,(iy-15)
        BITB $0x80,-15(R5)                                  #     and %10000000
        BEQ  1$                                             #     call nz,FireMode_4D
        CALL FireMode_4D                                    #
                                                            #     ld a,1
 1$:    MOVB $1,-7(R5)                                      #     ld (iy-7),a ;live players
                                                            #
                                                            #     ;multiplay support
                                                            #     ld hl,&003E ;ld a,0
                                                            #     ld a,(MultiplayConfig)
        BITB $0,@$MultiplayConfig                           #     bit 0,a
        #BEQ  StartANewGame_NoMultiplay                      #     jr z,StartANewGame_NoMultiplay
                                                            #     ld bc,&F990
                                                            #     in a,(c) ;Test if the multiplay is really there!
                                                            #     inc a
                                                            #     jr z,StartANewGame_NoMultiplay
                                                            #     ld hl,&78ED

        CALL WaitKey
        MOV  $PPU_Finalize, @$PPUCommand
2$:     TST  PPUCommand # wait until PPU finishes command
        BNE  2$

        JSR  R5,PPFREE
        .WORD PPU_UserRamStart
        .WORD PPU_ModuleSizeWords

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
        EMT     0375
        # TODO: carry the carry flag out of the procedure
        BCS  1$
        #.READW  $RdArea   #.READW  area,chan,buf,wcnt,blk[,BMODE=strg]
        MOV  $ReadArea,R0
        EMT  0375
        # TODO: carry the carry flag out of the procedure
        BCS  1$
1$:     #.Close  $0        #.CLOSE  chan
        MOV  $0x0600,R0 # operation code 6, channel 0
        EMT  0374       # close channel
RETURN
#----------------------------------------------------------------------------}}}

WaitKey:
        CLR  @$CCH0IS
1$:     TSTB @$CCH0IS
        BPL  1$
        CLR  @$CCH0IS
        RETURN

            .include "./ppucmd.s"

# files related data --------------------------------------------------------{{{
LookupArea:         .BYTE  0,01 # chan, code(.LOOKUP)
    LookupFileName: .WORD  0 # dblk

ReadArea:           .BYTE  0,010 # chan, code(.READ/.READC/.READW)
                    .WORD  0 # blk
    ReadBuffer:     .WORD  0 # buf
    ReadWordsCount: .WORD  0 # wcnt
                    .WORD  0 # end of area(.READW=0,.READ=1)
CoreBin:
    .BYTE 0xB8, 0x1A, 0x2A, 0x15, 0x40, 0x1F, 0xF6, 0x0D # .RAD50 "DK CORE  BIN"
SavSetBin: # saved settings bin
    .BYTE 0xB8, 0x1A, 0xFE, 0x76, 0x9C, 0x77, 0xF6, 0x0D # .RAD50 "DK SAVSETBIN"
PPUBIN:
    .BYTE 0xB8, 0x1A, 0x95, 0x66, 0x00, 0x00, 0xF6, 0x0D # .RAD50 "DK PPU   BIN"
LoadingSCR:
    .BYTE 0xB8, 0x1A, 0x59, 0x4D, 0x76, 0x1A, 0x4A, 0x77 # .RAD50 "DK LOADINSCR"

LookupError: .ASCIZ "File lookup error."
ReadError:   .ASCIZ "File read error."
#----------------------------------------------------------------------------}}}
LoadingScreenPalette: #------------------------------------------------------{{{
    .WORD 0       #--line number, last line of the top screen area, *required!*
    .WORD 0       #  0 - set cursor/scale/palette, *ignored for the first record*
    .WORD 0b10000 #  graphical cursor
    .WORD 0b10101 #  320 dots per line, pallete 5
    .WORD 1       #--line number, first line of the main screen area, *required!*
    .WORD 1       #  set colors
    .WORD 0xCC00  #  colors  011  010  001  000 (YRGB) | br.red   | black   |
    .WORD 0xFF99  #  colors  111  110  101  100 (YRGB) | br.white | br.blue |
    .WORD 49      #--line number (201 if there is no more parameters)
    .WORD 1       #  set colors
    .WORD 0x1100  #  | blue     | black   |
    .WORD 0xFF55  #  | br.white | magenta |
    .WORD 63      #--line number
    .WORD 1       #  set colors
    .WORD 0x9900  #  | br.blue  | black   |
    .WORD 0xFF55  #  | br.white | magenta |
    .WORD 95      #--line number
    .WORD 1       #  set colors
    .WORD 0xBB00  #  | br.cyan  | black   |
    .WORD 0xFF22  #  | br.white | green   |
    .WORD 195     #--line number
    .WORD 1       #  set colors
    .WORD 0xCC00  #  | br.red   | black   |
    .WORD 0xFF22  #  | br.white | green   |
    .WORD 201     #--line number, 201 - end of the main screen params
#----------------------------------------------------------------------------}}}

TitleStr:    .ASCIZ "         -= ChibiAkumas  V1.666 =-"
WebSiteStr:  .ASCIZ "         -= www.chibiakumas.com =-"
CreditsStr:  .ASCIZ "-= converted for the UKNC by aberranth =-"

        .even
BootstrapEnd:
