                .nolist

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
        MOV  $PPU___BIN, @$LookupFileName
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
        # load loading screen
        MOV  $PPU_SetPalette, @$PPUCommand
        MOV  $PPU_LoadingScreenPalette, @$PPUCommandArg

        MOV  $LOADINSCR, @$LookupFileName # ../AkuCPC/BootsStrap_StartGame_CPC.asm:64
        MOV  $FB1, @$ReadBuffer
        MOV  $8000, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile
        # Load the game core - this is always in memory
        MOV  $CORE__BIN, @$LookupFileName
        MOV  $FileBeginCore, @$ReadBuffer
        MOV  $FileSizeCoreWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile

        # # Load saved settings
        # MOV  $SAVSETBIN, @$LookupFileName
        # MOV  $SavedSettings, @$ReadBuffer
        # MOV  $FileSizeSettingsWords, @$ReadWordsCount
        # CALL Bootstrap_LoadDiskFile

        # TODO: font load
        # TODO: player sprites load
        # TODO: Initialize the Sound Effects.
#----------------------------------------------------------------------------}}}
Bootstrap_Level_0: # ../Aku/BootStrap.asm:838  main menu --------------------
        MOV  $SPReset,SP # we are not returning, so reset the stack
        CALL StartANewGame              # call StartANewGame
        CALL LevelReset0000             # call LevelReset0000
                                        #
        .list
        MOV  $LVL00_BIN, @$LookupFileName
        MOV  $Akuyou_LevelStart, @$ReadBuffer
        MOV  $Level00SizeWords, @$ReadWordsCount
        CALL Bootstrap_LoadDiskFile
                                        # ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        # ld c,DiskMap_MainMenu_Disk
                                        #
                                        # call Bootstrap_LoadEP2Music_Z # ../Aku/BootStrap.asm:656
                                        #
                                        # ld hl,DiskMap_MainMenu      ;T08-SC1.D01
                                        # ld c,DiskMap_MainMenu_Disk
                                        #
                                        # ;need to use Specail MSX version - no extra tilemaps
                                        # jp Bootstrap_LoadEP2Level_1PartOnly # ../Aku/BootStrap.asm:724

        # TST  @$PPUCommand
        # BNE  .-4
        # MOV  $PPU_SingleProcess,@$PPUCommand

        JMP  @$Akuyou_LevelStart
        JMP  WaitKeyThenExit
        RETURN                         # ret
        .nolist
#----------------------------------------------------------------------------
Player_Dead_ResumeB: # ../Aku/BootStrap.asm:1411
        SpendCreditSelfMod2:
            MOV  $Player_Array,R5 # ld iy,Player_Array ; All credits are (currently) stored in player 1's var!

# StartANewGame -------------------------------------------------------------{{{
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
        MOV $255,@$cmpDroneFlipFireCurrent
        RETURN

StartANewGame: # ../Aku/BootStrap.asm:2151
        # reset the core                 # xor a
        CLR  @$srcShowContinueCounter    # ld (ShowContinueCounter_Plus1-1),a

        MOV  $0012700,R0 # MOV (PC)+,R0  # ld bc,&3E0D ;Split Continues ; 3E n == LD A,n
        MOV  $0x0D,R1
        MOV  $0013704,R2 # MOV @(PC)+,R4 # ld de,&2ADD ; LD IX, (addr) == DD 2A dr ad
                                         # ld a,(ContinueMode)
        TSTB @$ContinueMode              # or a
        BNE  ContinueModeSet             # jr nz,ContinueModeSet

        MOV  $0000207,R0 # RTS PC        # ld bc,&C90E ;Shared Continues ; C9 == RET
        MOV  $0x0E,R1
        MOV  $0012705,R2 # MOV (PC)+,R5  # ld de,&21FD ; LD IY, hilo   == FD 21 lo hi

ContinueModeSet: # ../Aku/BootStrap.asm:2165
        MOV  R0,@$ShowContinuesSelfMod
        MOV  R1,@$srcContinuesScreenPos
        MOV  R2,@$SpendCreditSelfMod
        MOV  R2,@$SpendCreditSelfMod2

        CALL FireMode_Normal # set our standard Left-Right Firemode
        # reset all the scores n stuff
        MOV  $Player_Array, R5                              #
                                                            #     ld a,(iy-15)
        BITB $0x80,-15(R5)                                  #     and %10000000
       .CALL NE, FireMode_4D                                #     call nz,FireMode_4D
                                                            #     ld a,1
        MOVB $1,-7(R5)                                      #     ld (iy-7),a ;live players
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
        # TODO: implement this
StartANewGame_NoControlFlip: # ../Aku/BootStrap.asm:2206
        MOV  $Player_Array, R5 # AkuYou_Player_GetPlayerVars
        CALL StartANewGamePlayer
        MOV  $Player_Array2,R5 # AkuYou_Player_GetPlayerVars + 16
        CALL StartANewGamePlayer

        MOV  $Player_ScoreBytes,R3
        MOV  $8,R0
        CLR  (R3)+ # wipe highscores
        SOB  R0,.-2

        MOV  $Player_Array, R5 # AkuYou_Player_GetPlayerVars

        MOV  $0010000,R2 # MOV R0,R0 # slightly faster than NOP
        BITB $0x40,-11(R5) # test bit 6
        BNE  NoBulletSlowdown
        MOV  $0006200,R2 # ASR R0
NoBulletSlowdown: # ../Aku/BootStrap.asm:2206
        MOV  R2,@$srcStarSlowdown # ../SrcALL/Akuyou_Multiplatform_Stararray.asm:107

       .equiv BulletConfigSize, BulletConfigHeaven_End - BulletConfigHeaven
        MOV  $Stars_AddBurst_Top,R2
        MOV  $BulletConfigSize,R1
        MOV  $BulletConfigHeaven,R3
        MOV  $2,R0
        BNE  useheaven
        MOV  $BulletConfigHell,R3
        MOV  $1,R0
useheaven: # ../Aku/BootStrap.asm:2242
        MOVB (R3)+,(R2)+
        SOB  R1,.-2

        MOVB -11(R5),R0
        BIC  $!0b11,R0 # R0 & 0b11
        BEQ  Difficulty_Normal
        CMP  R0,$1
        BEQ  Difficulty_Easy
        CMP  R0,$2
        BEQ  Difficulty_Hard
RETURN

Difficulty_Easy: # ../Aku/BootStrap.asm:2286
        MOV  $0x20,R0 # bit 5
        BR   Difficulty_Generic
Difficulty_Normal:
        MOV  $0x10,R0 # bit 4
        BR   Difficulty_Generic
Difficulty_Hard:
        MOV  $0x08,R0 # bit 3
        BR   Difficulty_Generic
Difficulty_Generic:
        CLC
        MOV  R0,srcFireFrequencyA
        ROR  R0
        MOV  R0,srcFireFrequencyB
        MOV  R0,srcFireFrequencyC
        ROR  R0
        MOV  R0,srcFireFrequencyD
        ROR  R0
        MOV  R0,srcFireFrequencyE
RETURN

StartANewGamePlayer: # ../Aku/BootStrap.asm:2256 ;player fire directions ----{{{
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
#----------------------------------------------------------------------------}}}
#----------------------------------------------------------------------------}}}

LevelReset0000: # ../Aku/BootStrap.asm:2306 ---------------------------------{{{
            # wipe our memory, to clear out any junk from old levels
       .equiv LevelArraysSizeW, (Akuyou_CoreStart - Akuyou_GameVars) >> 1
        MOV  $LevelArraysSizeW,R1
        MOV  $StarArrayPointer,R3
        CLR  (R3)+
        SOB  R1, .-2
        # This resets anything the last level may have messed with during
        # play so we can start a new level with everything back to normal
ResetCore: # ../Aku/BootStrap.asm:2318
        MOV  $1,R0
        CALL ShowSpriteReconfigureEnableDisable # ./SrcCPC/Akuyou_CPC_VirtualScreenPos_320.asm:82

        MOV  $0x69,R0
        MOV  R0,@$srcTimer_CurrentTick
        MOV  R0,@$cmpDroneFlipCurrent
        MOV  R0,@$cmpDroneFlipFireCurrent

        CLR  R0
        MOV  R0,@$srcEventObjectAnimatorToAdd
        MOV  R0,@$srcEventObjectSpriteSizeToAdd
        MOV  R0,@$srcEventObjectProgramToAdd
        MOV  R0,@$srcTimer_TicksOccured
        # R0 has to contain zero to tell the subroutine to init
        CALL DroneFlipFire # TODO: implement this; does nothing for now

        MOV  $Object_DecreaseLifeShot, @$dstObjectShotOverride

        # set stuff that happens every level
        MOV  $0x2064,@$Player_Array  # X:0x20 Y:0x64
        MOV  $0x2096,@$Player_Array2 # X:0x20 Y:0x96

        MOV  $DoMoves,@$dstObjectDoMovesOverride

        MOV  $NULL,R3
        MOV  R3,@$dstSmartBombSpecial
        MOV  R3,@$dstCustomSmartBombEnemy
        MOV  R3,@$dstCustomPlayerHitter
        MOV  R3,@$dstCustomShotToDeathCall

        CLR  R0
        MOV  R0,@$srcSfx_CurrentPriority # clear the to-do
        MOV  R0,@$srcSfx_Sound           # clear the note

        CALL DoMovesBackground_SetScroll # TODO: implement the subroutine

        # TODO: Set RST 6 to call IY
        #CALL DoCustomRsts # ../SrcCPC/Akuyou_CPC_BankSwapper.asm:73

        MOV  $Player_Array,R5 # call AkuYou_Player_GetPlayerVars
        #read "..\AkuCPC\Bootstrap_ReconfigureCore_CPC.asm"
        MOV  $Player_Array,R5 # call AkuYou_Player_GetPlayerVars
RETURN
#----------------------------------------------------------------------------}}}

WaitKeyThenExit: #-----------------------------------------------------------{{{
        CALL WaitKey
        MOV  $PPU_Finalize, @$PPUCommand
        TST  @$PPUCommand # wait until PPU finishes command
        BNE  .-4

        # JSR  R5,PPFREE
        # .word PPU_UserRamStart
        # .word PPU_ModuleSizeWords

Finish: .exit
#----------------------------------------------------------------------------}}}
Bootstrap_LoadDiskFile: # ../Aku/BootStrap.asm:2795 -------------------------{{{
        #.LOOKUP $LkpArea  #.LOOKUP area,chan,dblk[,seqnum]
        MOV  $LookupArea,R0
        EMT  0375
        BCS  1$ # TODO: carry the carry flag out of the procedure

        #.READW  $RdArea   #.READW  area,chan,buf,wcnt,blk[,BMODE=strg]
        MOV  $ReadArea,R0
        EMT  0375

        #.Close  $0      #.CLOSE  chan
        MOV  $0x0600,R0 # operation code 6(MSB), channel 0(LSB)
        EMT  0374       # close channel

1$:     RETURN
#----------------------------------------------------------------------------}}}
WaitKey: #-------------------------------------------------------------------{{{
        TST  @$KeyboardScanner_KeyPresses + 2
        BEQ  .-4
        CLR  @$KeyboardScanner_KeyPresses + 2
        RETURN
#----------------------------------------------------------------------------}}}

       .include "./ppucmd.s"

BulletConfigHeaven: #--------------------------------------------------------{{{
    # Starbust code - we use RST 6 as an 'add command' to save memory - RST 6 calls IY
    # See EventStreamDefinitions for details of how the 'Directions' work
    # Stars_AddBurst_Top
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0x1F1D
    # Stars_AddBurst_TopLeft
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0x1b19
    .byte 0
    # Stars_AddBurst_Right #
    .word 0x2725
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    # Stars_AddBurst_TopRight
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0x1F1D
    .byte 0
    # Stars_AddBurst_Left
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0x1b19
    # Stars_AddBurst_BottomLeft
    .word 0x2321
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .byte 0
    # Stars_AddBurst_Bottom
    .word 0x2321
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    # Stars_AddBurst_BottomRight
    .word 0x2725
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .byte 0
    # Stars_AddBurst_Outer
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    .word 0xFFFF
    # OuterBurstPatternMini
    .word 0x2F2F
    .word 0x1F1F
    .word 0x2929
    .word 0x1919
    .word 0x3F39
    .word 0x0F09
    # Stars_AddObjectOne
    .byte 0
    # Stars_AddBurst
    .word 0xFFFF
    .byte 0xFF,0xFF
    # Stars_AddBurst_Small
    .word 0x3632
    .word 0x2e2A
    .word 0x2622
    .word 0x1e1A
    .word 0x1612
    .byte 0
    .word 0x1d1b
    .word 0xFFFF
    .word 0xFFFF
    .byte 0
    .word 0x2726
    .word 0xFFFF
    .word 0xFFFF
    .byte 0
    .word 0x2221
    .word 0xFFFF
    .word 0xFFFF

    .byte 0
    .word 0x2d2b
    .word 0xFFFF
    .word 0xFFFF
    .byte 0
BulletConfigHeaven_End:
#----------------------------------------------------------------------------}}}
BulletConfigHell: #----------------------------------------------------------{{{
    # Stars_AddBurst_Top
    .word 0x0705
    .word 0x0F0d
    .word 0x1715
    .word 0x1F1D
    # Stars_AddBurst_TopLeft
    .word 0x0301
    .word 0x0b09
    .word 0x1311
    .word 0x1b19
    .byte 0
    # Stars_AddBurst_Right
    .word 0x2725
    .word 0x2f2D
    .word 0x3735
    .word 0x3f3D
    # Stars_AddBurst_TopRight
    .word 0x0705
    .word 0x0F0d
    .word 0x1715
    .word 0x1F1D
    .byte 0
    # Stars_AddBurst_Left
    .word 0x0301
    .word 0x0b09
    .word 0x1311
    .word 0x1b19
    # Stars_AddBurst_BottomLeft
    .word 0x2321
    .word 0x2b29
    .word 0x3331
    .word 0x3b39
    .byte 0
    # Stars_AddBurst_Bottom
    .word 0x2321
    .word 0x2b29
    .word 0x3331
    .word 0x3b39
    # Stars_AddBurst_BottomRight
    .word 0x2725
    .word 0x2f2D
    .word 0x3735
    .word 0x3f3D
    .byte 0
    # Stars_AddBurst_Outer
    .word 0x3737
    .word 0x2727
    .word 0x1717
    .word 0x3131
    .word 0x2121
    .word 0x1111
    # OuterBurstPatternMini
    .word 0x2F2F
    .word 0x1F1F
    .word 0x2929
    .word 0x1919
    .word 0x3F39
    .word 0x0F09
    # Stars_AddObjectOne
    .byte 0
    # Stars_AddBurst
    .word 0x3f08
    .byte 0,0
    # Stars_AddBurst_Small
    .word 0x3632
    .word 0x2e2A
    .word 0x2622
    .word 0x1e1A
    .word 0x1612
    .byte 0
    # Stars_AddBurst_TopWide
    .word 0x1d1b
    .word 0x1513
    .word 0x0d0b
    .byte 0
    # Stars_AddBurst_RightWide
    .word 0x2726
    .word 0x2f2d
    .word 0x1f1d
    .byte 0
    # Stars_AddBurst_LeftWide
    .word 0x2221
    .word 0x1b19
    .word 0x2b29
    .byte 0
    # Stars_AddBurst_BottomWide
    .word 0x2d2b
    .word 0x3533
    .word 0x3d3b
    .byte 0
BulletConfigHell_End:
#----------------------------------------------------------------------------}}}
# files related data --------------------------------------------------------{{{
LookupArea:         .byte  0,01 # chan, code(.LOOKUP)
    LookupFileName: .word  0 # dblk

ReadArea:           .byte  0,010 # chan, code(.READ/.READC/.READW)
                    .word  0 # blk
    ReadBuffer:     .word  0 # buf
    ReadWordsCount: .word  0 # wcnt
                    .word  0 # end of area(.READW=0,.READ=1)
CORE__BIN:
    .word 0x1AB8, 0x152A, 0x1F40, 0x0DF6 # .RAD50 "DK CORE  BIN"
SAVSETBIN: # saved settings bin
    .word 0x1AB8, 0x76FE, 0x779C, 0x0DF6 # .RAD50 "DK SAVSETBIN"
PPU___BIN:
    .word 0x1AB8, 0x6695, 0x0000, 0x0DF6 # .RAD50 "DK PPU   BIN"
LOADINSCR:
    .word 0x1AB8, 0x4D59, 0x1A76, 0x774A # .RAD50 "DK LOADINSCR"
LVL00_BIN:
    .word 0x1AB8, 0x4E7C, 0xC030, 0x0DF6 # .RAD50 "DK LVL00 BIN"

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
TextInit:    .byte  033, 0240, '2 # symbol color
             .byte  033, 0241, '0 # symbol background color
             .byte  033, 0242, '0 # screen color
             .byte  033,  045, 041, 061             # order screenlines and
             .byte  033, 0133, 060, 075, 060, 0162 # clear screen
             .byte  0
TitleStr:    .asciz "      -= ChibiAkumas  V1.666 =-"
WebSiteStr:  .asciz "      -= www.chibiakumas.com =-"
CreditsStr:  .asciz "-= UKNC version by aberrant_hacker =-"
                   #0         1         2         3         4         5         6         7
                   #01234567890123456789012345678901234567890123456789012345678901234567890123456789
        .even # PPU reads strings by words so we have to align
YahooStr:   .asciz "Yippee! Whoopee! Woo-hoo! Yay! Hurrah!\n"
        .even
LongStr:    .asciz "This is a very very very very very very very very very very very long string.\n"
        .even
LoadingStr: .asciz "\n\n     Loading"
        .even
TestStr: #.byte 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F
         #.byte 0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F
         #.byte 0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F
         .byte        '!,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F
         .byte 0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F
         .byte 0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F
         .byte 0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F
         .byte 0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F
         .byte 0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F
         .byte 0x80,0x81,0x82,0x83,0x84,0x85
         .byte 0x00
        .even
BootstrapEnd:
