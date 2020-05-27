                .nolist

                .TITLE BootstrapChibi Akumas loader

                .global start
                .global Bootstrap_Launch
                .global Bootstrap_FromR5
                .global BootstrapEnd
                .global LoadingScreenPalette

                .include "./hwdefs.s"
                .include "./macros.s"
                .include "./core_defs.s"

                .equiv BootstrapSizeWords, (end - start) >> 1
                .global BootstrapSizeWords

                .equiv BootstrapSizeDWords, BootstrapSizeWords >> 1
                .global BootstrapSizeDWords

                .=BootstrapStart
start:
Bootstrap_Launch:
        MOV  $BootstrapSizeDWords,R0
        MOV  $CBPADR,R1
        MOV  $CBP12D,R2
        MOV  $BootstrapStart,R3
        MOV  $0x8000,(R1)

  100$:.rept 2
        MOV  (R3)+,(R2)
        INC  (R1)
       .endr
        SOB  R0,100$

# Load core modules ---------------------------------------------------------{{{
        MOV  $ppu_module.bin,R0
        CALL Bootstrap_LoadDiskFile

        # PPU will clear the command code when it ready to execute a new one
       .ppudo $PPU_NOP

        JSR  R5,PPEXEC
       .word FB1 # PPU module location
       .word PPU_ModuleSizeWords + 1280 # 2.5KB is a space required for SLTAB
#-------------------------------------------------------------------------------
     .ifdef ShowLoadingScreen
        # Apply loading screen palette
       .ppudo_ensure $PPU_SetPalette, $LoadingScreenPalette
        # Load loading screen
        MOV  $loading_screen.bin,R0
        CALL Bootstrap_LoadDiskFile
     .else
        # clear main screen area
        MOV  $8000>>3, R0
        MOV  $FB1, R1
        CLR  R3
1$:    .rept 1<<3
        MOV  R3, (R1)+
       .endr
        SOB  R0, 1$
     .endif

        # Load the game core - this is always in memory
        MOV  $core.bin,R0
        CALL Bootstrap_LoadDiskFile

        # TODO: Load saved settings
        # TODO: player sprites load
        # TODO: Initialize the Sound Effects.
#----------------------------------------------------------------------------}}}

        MOV  $0x8000,R5

Bootstrap_FromR5:
       .ppudo_ensure $PPU_MultiProcess
        TST  R5                    # R5 is used as the bootstrap command
        BMI  Bootstrap_SystemEvent # negative means system events (Menu etc)
        BR   Bootstrap_Level       # positive means levels

Bootstrap_SystemEvent:
        BIC  $0x8000,R5
    .ifdef DebugMode
        CMP  R5,$9
        BHIS .
    .endif
        ASL  R5
        JMP  @SystemEventsJmpTable(R5)
    SystemEventsJmpTable:
       .word Bootstrap_StartGame        # 0; BootsStrap_StartGame
       .word 0                          # 1; BootsStrap_ContinueScreen
       .word 0                          # 2; BootsStrap_ConfigureControls
       .word 0                          # 3; BootStrap_SaveSettings
       .word 0                          # 4; GameOverWin
       .word 0                          # 5; NewGame_EP2_1UP
       .word 0                          # 6; NewGame_EP2_2UP
       .word 0                          # 7; NewGame_EP2_2P
       .word 0                          # 8; NewGame_CheatStart

Bootstrap_Level:
    .ifdef DebugMode
        CMP  R5,$1
        BHIS .
    .endif
        ASL  R5
        JMP  @LevelsJmpTable(R5)
    LevelsJmpTable:
       .word Bootstrap_Level_Intro

Bootstrap_StartGame:


Bootstrap_Level_0: # ../Aku/BootStrap.asm:838  main menu --------------------
        CALL StartANewGame
        CALL LevelReset0000

        MOV  $level_00.bin,R0
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
       .ppudo_ensure $PPU_SingleProcess
        MOV  $SPReset,SP # we are not returning, so reset the stack
        JMP  @$Akuyou_LevelStart
#----------------------------------------------------------------------------
Bootstrap_Level_Intro:
        # TODO: show loadnig screen
        # call Akuyou_ShowCompiledSprite
        CALL LevelReset0000

        # TODO: load music Aku/BootStrap.asm:1185
        MOV  $ep1_intro.bin,R0
        CALL Bootstrap_LoadDiskFile

       .ppudo_ensure $PPU_SingleProcess
        MOV  $SPReset,SP # we are not returning, so reset the stack
        JMP  @$Akuyou_LevelStart
#----------------------------------------------------------------------------

Player_Dead_ResumeB: # ../Aku/BootStrap.asm:1411
        SpendCreditSelfMod2:
            MOV  $Player_Array,R5 # ld iy,Player_Array ; All credits are (currently) stored in player 1's var!

# StartANewGame -------------------------------------------------------------{{{
FireMode_Normal: # ../Aku/BootStrap.asm:2116
        MOV  $null,R3
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
        MOV  $GameVarsArraySizeWords,R1
        MOV  $Akuyou_GameVarsStart,R3
  100$: CLR  (R3)+
        SOB  R1, 100$
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
        # TODO: check if 2 lines below still relevant
        MOV  $0x2064,@$Player_Array  # X:0x20 Y:0x64
        MOV  $0x2096,@$Player_Array2 # X:0x20 Y:0x96

        MOV  $DoMoves,@$dstObjectDoMovesOverride

        MOV  $null,R3
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

Bootstrap_LoadDiskFile: # ---------------------------------------------------{{{
        MOV  (R0)+,@$PS.CPU_RAM_Address
        MOV  (R0)+,@$PS.WordsCount
        MOV  (R0),R0 # starting block number
        # calculate location of a file on a disk from the starting block number
        CLR  R2     # R2 - most significant word
        MOV  R0,R3  # R3 - least significant word
        DIV  $20,R2 # quotient -> R2, remainder -> R3
        MOVB R2,@$PS.AddressOnDevice     # track number
        CLR  R2
        DIV  $10,R2
        INC  R3
        MOVB R3,@$PS.AddressOnDevice + 1 # sector
        ASH  $7,R2
        MOVB R2,@$PS.DeviceNumber        # head

        MOVB $-1,@$PS.Status
        CLC

        MOV  $ParamsAddr,R0 # R0 - pointer to channel's init sequence array
        MOV  $8,R1          # R1 - size of the array, 8 bytes
1$:     MOVB (R0)+,@$CCH2OD # Send a byte to channel 2

2$:     TSTB @$CCH2OS       #
        BPL  2$             # Wait until channel is ready

        SOB  R1,1$          # Next byte

3$:     TSTB @$PS.Status
        BMI  3$
        BEQ  1237$
        SEC  # set carry flag to indicate that there was an error
        MOV  @$PS.Status,R0
1237$:  RETURN

ParamsAddr: .byte 0, 0, 0, 0xFF # init sequence (just in case)
            .word ParamsStruct
            .byte 0xFF, 0xFF    # two termination bytes 0xff, 0xff
ParamsStruct:
    PS.Status:          .byte -1  # operation status code
    PS.Command:         .byte 010 # read data from disk
    PS.DeviceType:      .byte 02       # double sided disk
    PS.DeviceNumber:    .byte 0x00 | 0 # bit 7: head(0-bottom, 1-top) ∨ drive number 0(0-3)
    PS.AddressOnDevice: .byte 0,1      # track 0(0-79), sector 1(1-10)
    PS.CPU_RAM_Address: .word 0
    PS.WordsCount:      .word 0        # number of words to transfer
#----------------------------------------------------------------------------}}}

# files related data --------------------------------------------------------{{{
ppu_module.bin:
       .word FB1                 # address for the data from a disk
       .word PPU_ModuleSizeWords # words count to read from a disk
       .word PPUModuleBlockNum   # starting block of a file
loading_screen.bin:
       .word FB1
       .word 8000
       .word LoadingScreenBlockNum
core.bin:
       .word FileBeginCore
       .word FileSizeCoreWords
       .word CoreBlockNum
level_00.bin:
       .word Akuyou_LevelStart
       .word Level00SizeWords
       .word Level00BlockNum
ep1_intro.bin:
       .word Akuyou_LevelStart
       .word Ep1IntroSizeWords
       .word Ep1IntroBlockNum
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
    .word 0x1B19
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
BlackPalette: #------------------------------------------------------{{{
    .byte 1       #--line number
    .byte 1       #  set colors
    .word 0x0000  #
    .word 0x0000  #
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
LoadingScreenPalette: #------------------------------------------------------{{{
    .byte 0       #--line number, last line of the top screen area, *required!*
    .byte 0       #  0 - set cursor/scale/palette, *ignored for the first record*
    .word 0b10000 #  graphical cursor
    .word 0b10101 #  320 dots per line, pallete 5
    .byte 1       #--line number, first line of the main screen area, *required!*
    .byte 1       #  set colors
    .word 0xCC00  #  colors 011 010 001 000 (YRGB) | br.red   | black   |
    .word 0xFF99  #  colors 111 110 101 100 (YRGB) | br.white | br.blue |
    .byte 49      #--line number (201 if there is no more parameters)
    .byte 1       #  set colors
    .word 0x1100  #  | blue     | black   |
    .word 0xFF55  #  | br.white | magenta |
    .byte 63      #--line number
    .byte 1       #  set colors
    .word 0xDD00  #  | br.green | black   |
    .word 0xFF55  #  | br.white | magenta |
    .byte 95      #--line number
    .byte 1       #  set colors
    .word 0xBB00  #  | br.cyan  | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 185     #--line number
    .byte 1       #  set colors
    .word 0x0000  #
    .word 0xFF22  #
    .byte 192     #--line number
    .byte 1       #  set colors
    .word 0xBB00  #
    .word 0xFF22  #
    .byte 196     #--line number
    .byte 1       #  set colors
    .word 0xCC00  #  | br.red   | black   |
    .word 0xFF22  #  | br.white | green   |
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
                   #0         1         2         3         4         5         6         7
                   #01234567890123456789012345678901234567890123456789012345678901234567890123456789
       .even # PPU reads strings word by word, so align
YahooStr:   .asciz "Yippee! Whoopee! Woo-hoo! Yay! Hurrah!\n"
       .even
TestStr: .byte 0,10
         .byte        '!,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F
         .byte 0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F
         .byte 0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F
         .byte 0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F
         .byte 0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F
         .byte 0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F
         .byte 0x80,0x81,0x82,0x83,0x84,0x85
         .byte 0x00
       .even
# for some reason gas replaces the last byte with 0
# so we add dummy word to avoid data/code corruption
        .word 0xFFFF
end:
BootstrapEnd:
