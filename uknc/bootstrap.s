                .list

                .TITLE BootstrapChibi Akumas loader

                .global start
                .global Bootstrap_Launch
                .global Bootstrap_FromR5
                .global BootstrapEnd
                .global BootstrapSize
                .global BootstrapSizeWords
                .global BootstrapSizeDWords
                .global LoadingScreenPalette

                .include "./hwdefs.s"
                .include "./macros.s"
                .include "./core_defs.s"

                .equiv BootstrapSize, (end - start)
                .equiv BootstrapSizeWords, BootstrapSize >> 1
                .equiv BootstrapSizeDWords, BootstrapSize >> 2 + 1

                .=BootstrapStart
start:
Bootstrap_Launch: # used by bootsector linker script
        MOV  $BootstrapSizeDWords,R0
        MOV  $CBPADR,R1
        MOV  $CBP12D,R2
        MOV  $BootstrapStart,R3
        MOV  $0x8000,(R1)

        100$:
            .rept 2
             MOV  (R3)+,(R2)
             INC  (R1)
            .endr
        SOB  R0,100$

# Load core modules ---------------------------------------------------------{{{
        MOV  $ppu_module.bin,R0
        CALL Bootstrap_LoadDiskFile

        MOV  $-1,@$PPUCommandArg
        JSR  R5,@$PPEXEC
       .word FB1 # PPU module location
       .word PPU_ModuleSizeWords

Bootstrap_Launch_WaitForPPUInit:
        TST  @$PPUCommandArg
        BNZ  Bootstrap_Launch_WaitForPPUInit
        #-----------------------------------------------------------------------
     .ifdef ShowLoadingScreen
        MOV  $loading_screen.bin,R0
        CALL Bootstrap_LoadDiskFile
       .ppudo_ensure $PPU_SetPalette, $TitleScreenPalette
     .else
      # clear main screen area
        MOV  $8000>>3, R0
        MOV  $FB1, R1
        CLR  R3
        1$:
           .rept 1<<3
            MOV  R3, (R1)+
           .endr
        SOB  R0, 1$
     .endif
        #-----------------------------------------------------------------------
        # Load the game core - this is always in memory
        MOV  $core.bin,R0
        CALL Bootstrap_LoadDiskFile
       .ifdef ExtMemCore # copy core to extended memory
            MOV  $GameVarsEnd,R4
            MOV  $CoreStart,R5
            MOV  $ExtMemSizeBytes>>2,R1
            200$:
                MOV  (R4)+, (R5)+
                MOV  (R4)+, (R5)+
            SOB R1,200$
       .endif

        BCC  10$
       .inform_and_hang3 "core.bin loading error"
10$:
        # TODO: Load saved settings
        # TODO: player sprites load
        # TODO: Initialize the Sound Effects.
#----------------------------------------------------------------------------}}}

        MOV  $StartOnLevel,R5

Bootstrap_FromR5:
       .ppudo_ensure $PPU_MultiProcess
        TST  R5                    # R5 is used as the bootstrap command
        BMI  Bootstrap_SystemEvent # negative means system events (Menu etc)
        BR   Bootstrap_Level       # positive means levels

Bootstrap_SystemEvent:
        BIC  $0x8000,R5
    .ifdef DebugMode
        CMP  R5,$8
        BHI  .
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
        CMP  R5,$2
        BLOS 1$
        .inform_and_hang "bootstrap: no levels further than 2"
        1$:
    .endif
        ASL  R5
        JMP  @LevelsJmpTable(R5)
    LevelsJmpTable:
       .word Bootstrap_Level_Intro
       .word Bootstrap_Level_1
       .word Bootstrap_Level_2

Bootstrap_StartGame:

Bootstrap_Level_0: # ../Aku/BootStrap.asm:838  main menu --------------------
        CALL StartANewGame
        CALL LevelReset0000

        MOV  $level_00.bin,R0
        CALL Bootstrap_LoadDiskFile
        BCC  1$
       .inform_and_hang3 "level_00.bin loading error"
1$:
       .ppudo_ensure $PPU_SingleProcess
        MOV  $SPReset,SP # we are not returning, so reset the stack
        JMP  @$Akuyou_LevelStart
#----------------------------------------------------------------------------
Bootstrap_Level_Intro:
       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        CALL LevelReset0000

        MOV  $ep1_intro.bin,R0
        CALL Bootstrap_LoadDiskFile
        BCC  1$
       .inform_and_hang3 "ep1_intro.bin loading error"
    1$:
        MOV  $ep1_intro_slides.bin,R0
        CALL Bootstrap_LoadDiskFile
        BCC  2$
       .inform_and_hang3 "ep1_intro_slides.bin loading error"
    2$:
       .ppudo_ensure $PPU_SingleProcess
        MOV  $SPReset,SP # we are not returning, so reset the stack
        JMP  @$Akuyou_LevelStart
#----------------------------------------------------------------------------
Bootstrap_Level_1: # --------------------------------------------------------
       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        CALL LevelReset0000

        MOV  $level_01.bin,R0
        CALL Bootstrap_LoadDiskFile
        BCC  1$
       .inform_and_hang3 "level_01.bin loading error"
    1$:
       .ppudo_ensure $PPU_SingleProcess
        MOV  $SPReset,SP # we are not returning, so reset the stack
        JMP  @$Akuyou_LevelStart
#----------------------------------------------------------------------------
Bootstrap_Level_2: # --------------------------------------------------------
       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        CALL LevelReset0000

        MOV  $level_02.bin,R0
        CALL Bootstrap_LoadDiskFile
        BCC  1$
       .inform_and_hang3 "level_02.bin loading error"
    1$:
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
        MOV  R3,@$FireUpHandler
        MOV  R3,@$FireDownHandler
        MOV  R3,@$FireLeftHandler
        MOV  R3,@$FireRightHandler

        MOV  $SetFireDir_LEFTsave, @$Fire1Handler
        MOV  $SetFireDir_RIGHTsave,@$Fire2Handler
        BR   FireMode_Both

FireMode_4D: # ../Aku/BootStrap.asm:2128
        MOV  $SetFireDir_UP,   @$FireUpHandler
        MOV  $SetFireDir_DOWN, @$FireDownHandler
        MOV  $SetFireDir_LEFT, @$FireLeftHandler
        MOV  $SetFireDir_RIGHT,@$FireRightHandler

        MOV  $SetFireDir_Fire, @$Fire1Handler
        MOV  $SetFireDir_FireAndSaveRestore,@$Fire2Handler

FireMode_Both: # ../Aku/BootStrap.asm:2143
        MOV $255,@$DroneFlipFireCurrent
        RETURN

StartANewGame: # ../Aku/BootStrap.asm:2151
        # reset the core                 # xor a
        CLR  @$ShowContinueCounter       # ld (ShowContinueCounter_Plus1-1),a

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
        MOV  R1,@$ContinuesScreenPos
        MOV  R2,@$SpendCreditSelfMod
        MOV  R2,@$SpendCreditSelfMod2

        CALL FireMode_Normal # set our standard Left-Right Firemode
        # reset all the scores n stuff
                                         # ld a,(iy-15)
        TSTB @$FireMode                  # and %10000000
        BPL  NormalFireMode
        CALL FireMode_4D                 # call nz,FireMode_4D
NormalFireMode:
                                         # ld a,1
        MOVB $1,@$LivePlayers            # ld (iy-7),a ;live players
                                         # ;multiplay support
        MOV  $0x003E,R3                  # ld hl,&003E
                                         # ld a,(MultiplayConfig)
        BITB $1,@$MultiplayConfig        # bit 0,a
        BZE  StartANewGame_NoMultiplay   # jr z,StartANewGame_NoMultiplay
                                         # ld bc,&F990
                                         # in a,(c) ;Test if the multiplay is really there!
                                         # inc a
                                         # jr z,StartANewGame_NoMultiplay
                                         # ld hl,&78ED
StartANewGame_NoMultiplay: # ../Aku/BootStrap.asm:2195
        # TODO: implement this
StartANewGame_NoControlFlip: # ../Aku/BootStrap.asm:2206
        MOV  $Player_Array, R5 # AkuYou_Player_GetPlayerVars
        CALL StartANewGamePlayer
   .ifdef TwoPlayersGame
        MOV  $Player_Array2,R5 # AkuYou_Player_GetPlayerVars + 16
        CALL StartANewGamePlayer
   .endif

        MOV  $Player_ScoreBytes,R3
        MOV  $8,R1
        CALL @$ClearR1Words # wipe highscores

        MOV  $Player_Array, R5 # AkuYou_Player_GetPlayerVars
        MOV  $0010000,R2 # MOV R0,R0 # slightly faster than NOP
        BITB $0x40,@$GameDifficulty  # test bit 6
        BNZ  NoBulletSlowdown

        MOV  $0006200,R2 # ASR R0

NoBulletSlowdown: # ../Aku/BootStrap.asm:2206
        MOV  R2,@$opcStarSlowdown # ../SrcALL/Akuyou_Multiplatform_Stararray.asm:107

       .equiv BulletConfigSize, (BulletConfigHeaven_End - BulletConfigHeaven)
        MOV  $Stars_AddBurst_Top,R2
        MOV  $BulletConfigSize,R1

        MOV  $BulletConfigHeaven,R3
        MOV  $0105303,R0 # DECB R3 opcode

        TSTB @$GameDifficulty # test bit 7
        BMI  HeavenMode

        MOV  $BulletConfigHell,R3
        MOV  $0110303,R0 # MOVB R3,R3 opcode
HeavenMode: # ../Aku/BootStrap.asm:2242
        MOV  R0,@$BurstSpacing
        100$:
            MOVB (R3)+,(R2)+
        SOB  R1,100$

        MOVB @$GameDifficulty,R0
        BIC  $0xFFFC,R0 # 0b11111100
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
        MOV  R0,@$FireFrequencyA
        ASR  R0
        MOV  R0,@$FireFrequencyB
        MOV  R0,@$FireFrequencyC
        ASR  R0
        MOV  R0,@$FireFrequencyD
        ASR  R0
        MOV  R0,@$FireFrequencyE

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

ClearR1Words:
      # we have to deal with odd number of iterations before entering the
      # cycle
        INC  R1
        ASR  R1
        BCC  2$ # number of iterations is odd, skipping first command
        100$:
            CLR  (R3)+
        2$:
            CLR  (R3)+
        SOB  R1, 100$

        RETURN

LevelReset0000: # ../Aku/BootStrap.asm:2306 ---------------------------------{{{
        # wipe our memory, to clear out any junk from old levels
        MOV  $ObjectArraySizeBytes >> 1,R1
        MOV  $ObjectArrayPointer,R3
        CALL @$ClearR1Words

        MOV  $StarArraySizeBytes >> 1,R1
        MOV  $StarArrayPointer,R3
        CALL @$ClearR1Words

        MOV  $PlayerStarArraySizeBytes >> 1,R1
        MOV  $PlayerStarArrayPointer,R3
        CALL @$ClearR1Words

        MOV  $Event_SavedSettingsSizeBytes >> 1,R1
        MOV  $Event_SavedSettings,R3
        CALL @$ClearR1Words

        # This resets anything the last level may have messed with during
        # play so we can start a new level with everything back to normal
ResetCore: # ../Aku/BootStrap.asm:2318
        MOV  $1,R0
        CALL ShowSpriteReconfigureEnableDisable # ./SrcCPC/Akuyou_CPC_VirtualScreenPos_320.asm:82

        MOV  $0x69,R0
        MOV  R0,@$Timer_CurrentTick
        MOV  R0,@$DroneFlipCurrent

        CLR  R0
        MOV  R0,@$EventObjectAnimatorToAdd
        MOV  R0,@$EventObjectSpriteSizeToAdd
        MOV  R0,@$EventObjectProgramToAdd
        MOV  R0,@$Timer_TicksOccured

        CALL DroneFlipFire

        MOV  $Object_DecreaseLifeShot, @$dstObjectShotOverride

        # set stuff that happens every level
        MOV  $0x2064,@$Player_Array  # X:0x20 Y:0x64
   .ifdef TwoPlayersGame
        MOV  $0x2096,@$Player_Array2 # X:0x20 Y:0x96
   .endif

        MOV  $DoMoves,@$dstObjectDoMovesOverride

        MOV  $null,R3
        MOV  R3,@$dstSmartBombSpecial
        MOV  R3,@$dstCustomSmartBombEnemy
        MOV  R3,@$dstCustomPlayerHitter
        MOV  R3,@$dstCustomShotToDeathCall

        CLR  R0
        CALL DoMovesBackground_SetScroll # TODO: implement the subroutine

        RETURN
# LevelReset0000 end --------------------------------------------------------}}}

Bootstrap_LoadDiskFile: # ---------------------------------------------------{{{
        MOV  (R0)+,@$PS.CPU_RAM_Address
        MOV  (R0)+,@$PS.WordsCount
        MOV  (R0),R0 # starting block number
        # calculate location of a file on a disk from the starting block number
        CLR  R2     # R2 - most significant word
        MOV  R0,R3  # R3 - least significant word
        DIV  $20,R2 # quotient -> R2, remainder -> R3
        MOVB R2,@$PS.AddressOnDevice     # track number (0-79)

        CLR  R2
        DIV  $10,R2
        INC  R3
        MOVB R3,@$PS.AddressOnDevice + 1 # sector (1-10)

        ASH  $7,R2
        MOVB R2,@$PS.DeviceNumber        # head (0, 1)

        MOVB $-1,@$PS.Status
        CLC

        MOV  $ParamsAddr,R0 # R0 - pointer to channel's init sequence array
        MOV  $8,R1          # R1 - size of the array, 8 bytes

        SendNextByteToChannel2:
            MOVB (R0)+,@$CCH2OD
            CheckChannel2Readiness:
                TSTB @$CCH2OS
            BPL  CheckChannel2Readiness
        SOB  R1,SendNextByteToChannel2

        CheckLoadDiskFileStatus:
            MOVB @$PS.Status,R0
        BMI  CheckLoadDiskFileStatus
        BZE  1237$
        # +------------------------------------------------------+
        # | Код ответа |  Значение                               |
        # +------------+-----------------------------------------+
        # |     00     | Операция завершилась нормально          |
        # |     01     | Ошибка контрольной суммы зоны данных    |
        # |     02     | Ошибка контрольной суммы зоны заголовка |
        # |     03     | Не найден адресный маркер               |
        # |    100     | Дискета не отформатированна             |
        # |    101     | Не обнаружен межсекторный промежуток    |
        # |    102     | Не найден сектор с заданным номером     |
        # |     04     | Не найден маркер данных                 |
        # |     05     | Сектор на найден                        |
        # |     06     | Защита от записи                        |
        # |     07     | Нулевая дорожка не обнаружена           |
        # |     10     | Дорожка не обнаружена                   |
        # |     11     | Неверный массив параметров              |
        # |     12     | Резерв                                  |
        # |     13     | Неверный формат сектора                 |
        # |     14     | Не найден индекс (ошибка линии ИНДЕКС)  |
        # +------------------------------------------------------+
        SEC  # set carry flag to indicate that there was an error

1237$:  RETURN

ParamsAddr: .byte 0, 0, 0, 0xFF # init sequence (just in case)
            .word ParamsStruct
            .byte 0xFF, 0xFF    # two termination bytes 0xff, 0xff
ParamsStruct:
    PS.Status:          .byte -1  # operation status code
    PS.Command:         .byte 010 # read data from disk
    PS.DeviceType:      .byte 02       # double sided disk
    PS.DeviceNumber:    .byte 0x00 | 0 # bit 7: head(0-bottom, 1-top) ∨ drive number 0(0-3)
    PS.AddressOnDevice: .byte 0, 1     # track 0(0-79), sector 1(1-10)
    PS.CPU_RAM_Address: .word 0
    PS.WordsCount:      .word 0        # number of words to transfer
#----------------------------------------------------------------------------}}}

# files related data --------------------------------------------------------{{{

.global ppu_module.bin
.global loading_screen.bin
.global core.bin
.global ep1_intro.bin
.global ep1_intro_slides.bin
.global level_00.bin
.global level_01.bin
.global level_02.bin
# each record is 3 words:
#   .word address for the data from a disk
#   .word size in words
#   .word starting block of a file
ppu_module.bin:
    .word FB1
    .word 0
    .word 0
loading_screen.bin:
    .word FB1
    .word 0
    .word 0
core.bin:
    .word GameVarsEnd
    .word 0
    .word 0
ep1_intro.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
ep1_intro_slides.bin:
    .word Ep1IntroSlidesStart
    .word 0
    .word 0
level_00.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_01.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_02.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
#----------------------------------------------------------------------------}}}

       .include "./ppucmd.s"

BulletConfigHeaven: #--------------------------------------------------------{{{
   # Starbust code - we use RST 6 as an 'add command' to save memory - RST 6 calls IY
   # See EventStreamDefinitions for details of how the 'Directions' work
   # Stars_AddBurst_Top
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0x1F,0x1D
   # Stars_AddBurst_TopLeft
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0x1B,0x19
    .byte 0
   # Stars_AddBurst_Right
    .byte 0x27,0x25
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
   # Stars_AddBurst_TopRight
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0x1F,0x1D
    .byte 0
   # Stars_AddBurst_Left
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0x1b,0x19
   # Stars_AddBurst_BottomLeft
    .byte 0x23,0x21
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0
   # Stars_AddBurst_Bottom
    .byte 0x23,0x21
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
   # Stars_AddBurst_BottomRight
    .byte 0x27,0x25
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0
   # Stars_AddBurst_Outer
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0xFF,0x00
   # OuterBurstPatternMini
    .byte 0x2F,0x2F
    .byte 0x1F,0x1F
    .byte 0x29,0x29
    .byte 0x19,0x19
    .byte 0x3F,0x39
    .byte 0x0F,0x09
   # Stars_AddObjectOne
    .byte 0
   # Stars_AddBurst
    .byte 0xFF,0x00
    .byte 0xFF,0x00
   # Stars_AddBurst_Small
    .byte 0x36,0x32
    .byte 0x2E,0x2A
    .byte 0x26,0x22
    .byte 0x1E,0x1A
    .byte 0x16,0x12
    .byte 0
   # Stars_AddBurst_TopWide:
    .byte 0x1D,0x1B
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0
   # Stars_AddBurst_RightWide:
    .byte 0x27,0x26
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0
   # Stars_AddBurst_LeftWide:
    .byte 0x22,0x21
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0
   # Stars_AddBurst_BottomWide:
    .byte 0x2D,0x2B
    .byte 0xFF,0x00
    .byte 0xFF,0x00
    .byte 0
    .even
BulletConfigHeaven_End:
#----------------------------------------------------------------------------}}}
BulletConfigHell: #----------------------------------------------------------{{{
   # Stars_AddBurst_Top:
    .byte 0x07,0x05
    .byte 0x0F,0x0D
    .byte 0x17,0x15
    .byte 0x1F,0x1D
   # Stars_AddBurst_TopLeft:
    .byte 0x03,0x01
    .byte 0x0B,0x09
    .byte 0x13,0x11
    .byte 0x1B,0x19
    .byte 0
   # Stars_AddBurst_Right:
    .byte 0x27,0x25
    .byte 0x2F,0x2D
    .byte 0x37,0x35
    .byte 0x3F,0x3D
   # Stars_AddBurst_TopRight:
    .byte 0x07,0x05
    .byte 0x0F,0x0D
    .byte 0x17,0x15
    .byte 0x1F,0x1D
    .byte 0
   # Stars_AddBurst_Left:
    .byte 0x03,0x01
    .byte 0x0B,0x09
    .byte 0x13,0x11
    .byte 0x1B,0x19
   # Stars_AddBurst_BottomLeft:
    .byte 0x23,0x21
    .byte 0x2B,0x29
    .byte 0x33,0x31
    .byte 0x3B,0x39
    .byte 0
   # Stars_AddBurst_Bottom:
    .byte 0x23,0x21
    .byte 0x2B,0x29
    .byte 0x33,0x31
    .byte 0x3B,0x39
   # Stars_AddBurst_BottomRight:
    .byte 0x27,0x25
    .byte 0x2F,0x2D
    .byte 0x37,0x35
    .byte 0x3F,0x3D
    .byte 0
   # Stars_AddBurst_Outer:
    .byte 0x37,0x37
    .byte 0x27,0x27
    .byte 0x17,0x17
    .byte 0x31,0x31
    .byte 0x21,0x21
    .byte 0x11,0x11
   # OuterBurstPatternMini:
    .byte 0x2F,0x2F
    .byte 0x1F,0x1F
    .byte 0x29,0x29
    .byte 0x19,0x19
    .byte 0x3F,0x39
    .byte 0x0F,0x09
   # Stars_AddObjectOne:
    .byte 0
   # Stars_AddBurst:
    .byte 0x3F,0x08
    .byte 0, 0
   # Stars_AddBurst_Small:
    .byte 0x36,0x32
    .byte 0x2E,0x2A
    .byte 0x26,0x22
    .byte 0x1E,0x1A
    .byte 0x16,0x12
    .byte 0
   # Stars_AddBurst_TopWide:
    .byte 0x1D,0x1B
    .byte 0x15,0x13
    .byte 0x0D,0x0B
    .byte 0
   # Stars_AddBurst_RightWide:
    .byte 0x27,0x26
    .byte 0x2F,0x2D
    .byte 0x1F,0x1D
    .byte 0
   # Stars_AddBurst_LeftWide:
    .byte 0x22,0x21
    .byte 0x1B,0x19
    .byte 0x2B,0x29
    .byte 0
   # Stars_AddBurst_BottomWide:
    .byte 0x2D,0x2B
    .byte 0x35,0x33
    .byte 0x3D,0x3B
    .byte 0
    .even
BulletConfigHell_End:
#----------------------------------------------------------------------------}}}

BlackPalette: #------------------------------------------------------{{{
    .byte 1, setColors, Black, Black, Black, Black
    .word untilEndOfScreen
#----------------------------------------------------------------------------}}}
TitleScreenPalette: #--------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | 0b101
    .byte   1, setColors, Black, brBlue, brRed, White
    .byte  49, setColors, Black, Magenta, Blue, White
    .byte  63, setColors, Black, Magenta, brMagenta, White
    .byte  95, setColors, Black, Green, brCyan, White
    .byte 185, setColors, Black, Green, Black, White
    .byte 192, setColors, Black, Green, brCyan, White
    .byte 196, setColors, Black, Green, brRed, White
    .word untilEndOfScreen
#----------------------------------------------------------------------------}}}
#0         1         2         3         4         5         6         7
#01234567890123456789012345678901234567890123456789012345678901234567890123456789
       .even # PPU reads strings word by word, so align
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
end:

BootstrapEnd: # used by bootsector linker script
