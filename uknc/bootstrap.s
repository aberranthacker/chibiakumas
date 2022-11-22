                .list

                .TITLE BootstrapChibi Akumas loader

                .global start
                .global Bootstrap.Launch
                .global Bootstrap.FromR5
                .global BootstrapEnd
                .equiv  Bootstrap.PS.DeviceNumber, PS.DeviceNumber
                .global Bootstrap.PS.DeviceNumber
                .global BootstrapSize
                .global BootstrapSizeWords
                .global BootstrapSizeQWords
                .global LoadingScreenPalette

                .global saved_settings.bin
                .global ep1_intro.bin
                .global ep1_intro_slides.bin
                .global level_00.bin
                .global level_01.bin
                .global level_02.bin
                .global level_03_title.bin
                .global level_03.bin
                .global level_04.bin
                .global level_05_title.bin
                .global level_07_title.bin

                .include "./hwdefs.s"
                .include "./macros.s"
                .include "./core_defs.s"

                .equiv BootstrapSize, (end - start)
                .equiv BootstrapSizeWords, BootstrapSize >> 1 + 1
                .equiv BootstrapSizeQWords, BootstrapSize >> 3 + 1

                .=BootstrapStart
start:
        MTPS $PR0 # enable interrupts

.if StartOnLevel == MainMenu
        CALL Bootstrap.LoadLevel_0
.endif

.ifdef ShowLoadingScreen
       .ppudo_ensure $PPU_TitleMusicRestart
       .ppudo_ensure $PPU_PrintAt,$PressFireKeyStr
ShowTitlePic_Loop: #---------------------------------------------------------{{{
       .ppudo_ensure $PPU_SetPalette, $FireKeyDarkPalette
        CALL glow_delay_and_wait_key$
       .ppudo_ensure $PPU_SetPalette, $FireKeyNormalPalette
        CALL glow_delay_and_wait_key$
       .ppudo_ensure $PPU_SetPalette, $FireKeyBrightPalette
        CALL glow_delay_and_wait_key$
       .ppudo_ensure $PPU_SetPalette, $FireKeyNormalPalette
        CALL glow_delay_and_wait_key$
       .ppudo_ensure $PPU_SetPalette, $FireKeyDarkPalette
        CALL glow_delay_and_wait_key$
       .ppudo_ensure $PPU_SetPalette, $FireKeyBlackPalette
        CALL glow_delay_and_wait_key$

        BR   ShowTitlePic_Loop

    glow_delay_and_wait_key$:
        MOV  $5,R1
        100$:
            CALL TRandW
            WAIT
            BITB $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
            BNZ  finalize_title_pic_loop$
        SOB  R1,100$

        RETURN

    finalize_title_pic_loop$:
        TST  (SP)+ # remove return address from the stack
#----------------------------------------------------------------------------}}}
.endif

.if StartOnLevel == MainMenu
        JMP  @$Bootstrap.StartLevel
.else
        MOV  $StartOnLevel,R5
.endif

Bootstrap.FromR5:
        TST  R5                    # R5 is used as the bootstrap command
        BMI  Bootstrap.SystemEvent # negative means system events (Menu etc)
        BR   Bootstrap.Level       # positive means levels

Bootstrap.SystemEvent:
        BIC  $0x8000,R5
    .ifdef DebugMode
        CMP  R5,$8
        BHI  .
    .endif
        ASL  R5
        JMP  @SystemEventsJmpTable(R5)
    SystemEventsJmpTable:
       .word Bootstrap.StartGame        # 0 BootsStrap_StartGame
       .word Bootstrap.Continue         # 1 BootsStrap_Continue
       .word 0                          # 2 BootsStrap_ConfigureControls
       .word 0                          # 3 BootStrap_SaveSettings
       .word 0                          # 4 GameOverWin
       .word 0                          # 5 NewGame_EP2_1UP
       .word 0                          # 6 NewGame_EP2_2UP
       .word 0                          # 7 NewGame_EP2_2P
       .word 0                          # 8 NewGame_CheatStart

Bootstrap.Level:
    .ifdef DebugMode
        CMP  R5,$5
        BLOS 1$
       .inform_and_hang2 "bootstrap: no levels further than 4"
        1$:
    .endif
        ASL  R5
        JMP  @LevelsJmpTable(R5)
    LevelsJmpTable:
       .word Bootstrap.Level_Intro
       .word Bootstrap.Level_1
       .word Bootstrap.Level_2
       .word Bootstrap.Level_3
       .word Bootstrap.Level_4
       .word Bootstrap.Level_5

Bootstrap.StartLevel:
        MOV  $SP_RESET,SP # we are not returning, so reset the stack
        JMP  @$Akuyou_LevelStart

Bootstrap.StartGame:
Bootstrap.Level_0:
        CALL Bootstrap.LoadLevel_0
        BR   Bootstrap.StartLevel

Bootstrap.LoadLevel_0: # ../Aku/BootStrap.asm:838  main menu --------------------
        MOV  $level_00.bin,R0
        CALL Bootstrap.DiskRead_Start
            CALL StartANewGame
            CALL LevelReset0000
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_00.bin"
        RETURN
#----------------------------------------------------------------------------
Bootstrap.Level_Intro:
        MOV  $ep1_intro.bin,R0
        CALL Bootstrap.DiskRead_Start
           .ppudo_ensure $PPU_SetPalette, $BlackPalette
            CALL LevelReset0000
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "ep1_intro.bin"

        MOV  $ep1_intro_slides.bin,R0
        CALL Bootstrap.DiskRead_Start
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "ep1_intro_slides.bin"

        JMP  @$Bootstrap.StartLevel
#----------------------------------------------------------------------------
Bootstrap.Level_1: # --------------------------------------------------------
        MOV  $level_01.bin,R0
        CALL Bootstrap.DiskRead_Start
            CALL StartANewGame
            CALL LevelReset0000
            MOVB $3,@$Player_Array + 9 # set number of lives for the first player
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_01.bin"

        CALL Bootstrap.WaitForFireKey

       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        WAIT
       .ppudo_ensure $PPU_LevelStart

        JMP  @$Bootstrap.StartLevel
#----------------------------------------------------------------------------
Bootstrap.Level_2: # --------------------------------------------------------
        MOV  $level_02.bin,R0
        CALL Bootstrap.DiskRead_Start
           .ppudo_ensure $PPU_LevelStart
           .ppudo_ensure $PPU_SetPalette, $BlackPalette
            CALL LevelReset0000
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_02.bin"

        JMP  @$Bootstrap.StartLevel
#----------------------------------------------------------------------------
Bootstrap.Level_3: # --------------------------------------------------------
        MOV  $level_03_title.bin,R0
        CALL Bootstrap.DiskRead_Start
       .if StartOnLevel != MainMenu
            CALL CLS
       .endif
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_03_title.bin"

        MOV  $level_03_title.bin.lzsa1,R1
        MOV  $FB1+8000,R2
        CALL @$unlzsa1

       .ppudo_ensure $PPU_SetPalette,$Level03_TitlePalette
        CALL Bootstrap.DisplayUnpackedTitleImage
       .ppudo_ensure $PPU_PrintAt,$Level03_TitleText

        MOV  $level_03.bin,R0
        CALL Bootstrap.DiskRead_Start
            CALL LevelReset0000
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_03.bin"

        CALL Bootstrap.WaitForFireKey

       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        WAIT
       .ppudo_ensure $PPU_LevelStart

        JMP  @$Bootstrap.StartLevel
#----------------------------------------------------------------------------
Bootstrap.Level_4: # --------------------------------------------------------
        MOV  $level_04.bin,R0
        CALL Bootstrap.DiskRead_Start
           .ppudo_ensure $PPU_LevelStart
           .ppudo_ensure $PPU_SetPalette, $BlackPalette
            CALL LevelReset0000
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_04.bin"

        JMP  @$Bootstrap.StartLevel
#----------------------------------------------------------------------------
Bootstrap.Level_5: # --------------------------------------------------------
        MOV  $level_05_title.bin,R0
        CALL Bootstrap.DiskRead_Start
       .if StartOnLevel != MainMenu
            CALL CLS
       .endif
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_05_title.bin"

        MOV  $level_05_title.bin.lzsa1,R1
        MOV  $FB1+8000,R2
        CALL @$unlzsa1

       .ppudo_ensure $PPU_SetPalette,$Level05_TitlePalette
        CALL Bootstrap.DisplayUnpackedTitleImage
       .ppudo_ensure $PPU_PrintAt,$Level05_TitleText

        MOV  $level_05.bin,R0
        CALL Bootstrap.DiskRead_Start
            CALL LevelReset0000
        CALL Bootstrap.DiskIO_WaitForFinish
       .check_for_loading_error "level_05.bin"

        WAIT
        CALL Bootstrap.WaitForFireKey

       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        WAIT
       .ppudo_ensure $PPU_LevelStart

        JMP  @$Bootstrap.StartLevel
#----------------------------------------------------------------------------

Bootstrap.DisplayUnpackedTitleImage:
        MOV  $FB1+8000,R1
        MOV  $FB1+(12*2),R2
        MOV  $96,R3
        96$:
           .rept 16
            MOV  (R1),(R2)+
            CLR  (R1)+
           .endr
        ADD  $24*2,R2
        SOB  R3,96$
        RETURN
#----------------------------------------------------------------------------
Bootstrap.Continue_SpendCredit:
        DECB 5(R4)    # continues
        MOVB $3,3(R4) # smartbombs
        MOVB $7,7(R4) # invincibility for 7 ticks
        MOVB $3,9(R4) # lives
        MOV  $INC_R0_OPCODE,@$PlayerCounter

        CALL @$Event_RestorePalette
       .ppudo_ensure $PPU_LevelStart
        BIC  $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
        RETURN

Bootstrap.Continue: # ../Aku/BootStrap.asm:1324
       .ppudo_ensure $PPU_LevelEnd
       .ppudo_ensure $PPU_SetPalette,$ContinuePalette
        MOV  $Player_Array,R4
        TSTB 5(R4)
        BZE  Bootstrap.GameOver

        PUSH R4
        MOV  $continue.bin.lzsa1,R1
        MOV  $FB1 + 36*80,R2
        CALL unlzsa1
        POP  R4

        MOV  $75,R0
        1$: WAIT
        SOB  R0, 1$

        CLR  R1
        BISB 5(R4),R1 # number of continues

        MOV  $ContinueStr+23,R2
        MOV  $2,R3 # number of digits
        CALL NumberToDecStr
       .ppudo_ensure $PPU_PrintAt,$ContinueStr

        MOV  $9,R0
        BIC  $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
        WAIT
        Continue_CoundownLoop:
            MOV  R0, @$ContinueCountdownStr+2
            ADD  $'0, @$ContinueCountdownStr+2
            MOV  $8*80,R1 # 8 lines, 80 bytes per line
            MOV  $FB1+20*8*80,R3
            CALL ClearR1Words
           .ppudo_ensure $PPU_PrintAt,$ContinueCountdownStr

            MOV  $50,R1
            Continue_WaitASecondLoop:
                BITB @$KeyboardScanner_P1,$KEYMAP_ANY_FIRE
                BNZ  Bootstrap.Continue_SpendCredit
                WAIT
            SOB  R1,Continue_WaitASecondLoop
        DEC  R0
        BPL  Continue_CoundownLoop

Bootstrap.GameOver:
       .ppudo_ensure $PPU_MusicStop
       .ppudo_ensure $PPU_SetPalette,$BlackPalette
        CALL CLS
       .ppudo_ensure $PPU_PrintAt,$GameOver_Text
       .ppudo_ensure $PPU_SetPalette,$GameOverPalette

        MOV  $game_over.bin.lzsa1,R1
        MOV  $FB1 + 20*80,R2
        CALL unlzsa1

        CALL Bootstrap.WaitForFireKey_NoMessage

Bootstrap.Review:
       .ppudo_ensure $PPU_SetPalette,$BlackPalette
        CALL CLS

        MOV  $8,R1
        MOV  $Player_ScoreBytes+8,R2
        MOV  $PlayerScoreText+2,R3
        MOV  $HighScoreBytes+8,R4
        MOV  $HighScoreText+2,R5
        ScoreToStrLoop:
            CLRB R0
            BISB -(R2),R0
            ADD  $'0,R0
            MOVB R0,(R3)+

            CLRB R0
            BISB -(R4),R0
            ADD  $'0,R0
            MOVB R0,(R5)+
        SOB  R1,ScoreToStrLoop

        MOV  $9,R1
        MOV  $Player_ScoreBytes+8,R2
        MOV  $HighScoreBytes+8,R3
        CompareScoreDigitsLoop:
            DEC  R1
            BZE  Bootstrap.Review_MehScore

            CMPB -(R3),-(R2)
        BEQ  CompareScoreDigitsLoop
        BLO  Bootstrap.Review_NewScore

Bootstrap.Review_MehScore:
        MOV  $ChibikoReviewsMehScore,@$MehOrNewScore
        BR   Bootstrap.Review_ShowScore

Bootstrap.Review_NewScore:
        MOV  $ChibikoReviewsNewScore,@$MehOrNewScore
        MOV  $8,R1
        MOV  $Player_ScoreBytes,R4
        MOV  $HighScoreBytes,R5

        PlayerScoreHigher_CopyNextByte:
            MOVB (R4)+,(R5)+
        SOB  R1,PlayerScoreHigher_CopyNextByte

        MOV  $saved_settings.bin,R0
        CALL Bootstrap.DiskWrite_Start
        CALL Bootstrap.DiskIO_WaitForFinish

Bootstrap.Review_ShowScore:
       .wait_ppu
        CALL @$TRandW
        BIC  $0xFFF9,R0
       .equiv MehOrNewScore, .+2
        MOV  ChibikoReviewsNewScore(R0),@$PPUCommandArg
       .ppudo $PPU_PrintAt
       .ppudo_ensure $PPU_PrintAt,$ChibikoReview

        MOV  $high_score.bin.lzsa1,R1
        MOV  $LevelStart,R2
        CALL unlzsa1

       .ppudo_ensure $PPU_PrintAt,$RankText

        MOV  $LevelStart,R4
        MOV  $FB1+80*136,R5
        MOV  $64,R1
        LinesLoop:
            MOV  $8,R2
            LineLoop:
                MOV  (R4),(R5)+
                CLR  (R4)+
            SOB  R2,LineLoop
            ADD  $64,R5
        SOB  R1,LinesLoop

       .ppudo_ensure $PPU_SetPalette,$ReviewPalette

       .ppudo_ensure $PPU_PrintAt,$PlayerScoreText
       .ppudo_ensure $PPU_PrintAt,$HighScoreText
       .ppudo_ensure $PPU_PrintAt,$RankF

        CALL Bootstrap.WaitForFireKey_NoMessage

        MOV  $0x8000,R5
        JMP  Bootstrap.FromR5
#-------------------------------------------------------------------------------
ChibikoReviewsWin:
    .word ChibikoReviewWin
ChibikoReviewsNewScore:
    .word ChibikoReview1
    .word ChibikoReview2
    .word ChibikoReview3
    .word ChibikoReview4
ChibikoReviewsMehScore:
    .word ChibikoReview5
    .word ChibikoReview6
    .word ChibikoReview7
    .word ChibikoReview8
# Texts/strings -------------------------------------------------------------{{{
                         #0---------1---------2---------3---------
ContinueStr:             #0123456789012345678901234567890123456789
       .byte 16, 16; .ascii              "Continue?"                ; .byte -1 ; .even
       .byte 15, 18; .ascii              "Credits: --"              ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ContinueCountdownStr:    #0123456789012345678901234567890123456789
       .byte 20, 20; .ascii                  "-"                    ; .byte  0 ; .even
                         #0---------1---------2---------3---------
GameOver_Text:           #0123456789012345678901234567890123456789
    .byte  7, 16; .ascii        "The Moster Hoard has driven"       ; .byte -1 ; .even
    .byte  8, 17; .ascii         "Chibiko from her homeland"        ; .byte -1 ; .even
    .byte  2, 18; .ascii   "She is forced to live in a cardboard"   ; .byte -1 ; .even
    .byte  8, 19; .ascii         "box as a street vampire! "        ; .byte -1 ; .even
    .byte 11, 20; .ascii            "With Chibiko gone,"            ; .byte -1 ; .even
    .byte 11, 21; .ascii            "peace and harmony"             ; .byte -1 ; .even
    .byte  6, 22; .ascii       "spread through out the land."       ; .byte -1 ; .even
    .byte  9, 24; .ascii          "(Boy! Did you fuck up!)"         ; .byte  0 ; .even
                         #0---------1---------2---------3---------
RankText:                #0123456789012345678901234567890123456789
    .byte  8,  1; .ascii         "Your Score was:"                  ; .byte -1 ; .even

    .byte 13,  3; .ascii              "HighScore:"                  ; .byte -1 ; .even

    .byte  3,  7; .ascii    "Your 'Chibiko Scoring System (TM)'"    ; .byte -1 ; .even
    .byte 15,  8; .ascii                "Rank was -"                ; .byte  0 ; .even
                         #0---------1---------2---------3---------
PlayerScoreText:         #0123456789012345678901234567890123456789
    .byte 24,  1; .ascii                         "--------"         ; .byte  0; .even
                         #0---------1---------2---------3---------
HighScoreText:           #0123456789012345678901234567890123456789
    .byte 24,  3; .ascii                         "--------"         ; .byte  0; .even
                         #0---------1---------2---------3---------
RankF:                   #0123456789012345678901234567890123456789
    .byte 17, 10; .ascii                  "*****"                   ; .byte -1 ; .even
    .byte 17, 11; .ascii                  "*    "                   ; .byte -1 ; .even
    .byte 17, 12; .ascii                  "*****"                   ; .byte -1 ; .even
    .byte 17, 13; .ascii                  "*    "                   ; .byte -1 ; .even
    .byte 17, 14; .ascii                  "*    "                   ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview:           #0123456789012345678901234567890123456789
    .byte 12, 17; .ascii             "Chibiko says:"                ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReviewWin:        #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "Well, you won!"                  ; .byte -1 ; .even
    .byte  9, 20; .ascii          "But I'm still giving you an F!"  ; .byte -1 ; .even

    .byte  9, 22; .ascii          "Try get a better score next"     ; .byte -1 ; .even
    .byte  9, 23; .ascii          "time sucker! ;-)"                ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview1:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "Good Job!"                       ; .byte -1 ; .even
    .byte  9, 20; .ascii          "Now try plugging the controller" ; .byte -1 ; .even
    .byte  9, 21; .ascii          "in first before starting the"    ; .byte -1 ; .even
    .byte  9, 22; .ascii          "game!"                           ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview2:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "Amazing!!!"                      ; .byte -1 ; .even
    .byte  9, 20; .ascii          "You survived SUCH a long time"   ; .byte -1 ; .even
    .byte  9, 21; .ascii          "by aimlessly hitting buttons"    ; .byte -1 ; .even
    .byte  9, 22; .ascii          "at random!"                      ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview3:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "Superb Performace!"              ; .byte -1 ; .even
    .byte  9, 20; .ascii          "Imagine how good you'll be"      ; .byte -1 ; .even
    .byte  9, 21; .ascii          "when you actually learn how"     ; .byte -1 ; .even
    .byte  9, 22; .ascii          "to play!"                        ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview4:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "Well Done!"                      ; .byte -1 ; .even
    .byte  9, 20; .ascii          "I'm sure there's worse players"  ; .byte -1 ; .even
    .byte  9, 21; .ascii          "out there, I mean, the world"    ; .byte -1 ; .even
    .byte  9, 22; .ascii          "population is 7.6 billion"       ; .byte -1 ; .even
    .byte  9, 23; .ascii          "....There MUST be, right?"       ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview5:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "You're really something, after"  ; .byte -1 ; .even
    .byte  9, 20; .ascii          "all, It's rare to see someone"   ; .byte -1 ; .even
    .byte  9, 21; .ascii          "CLINICALLY BRAINDEAD still able" ; .byte -1 ; .even
    .byte  9, 22; .ascii          "to play computer games!"         ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview6:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "If YOU are the result of 2 "     ; .byte -1 ; .even
    .byte  9, 20; .ascii          "million years of human "         ; .byte -1 ; .even
    .byte  9, 21; .ascii          "evolution I'd say the species"   ; .byte -1 ; .even
    .byte  9, 22; .ascii          "is seriously fucked!"            ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview7:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "Never mind!"                     ; .byte -1 ; .even
    .byte  9, 20; .ascii          "Maybe you will manage to serve"  ; .byte -1 ; .even
    .byte  9, 21; .ascii          "some purpose one day!?!"         ; .byte -1 ; .even
    .byte  9, 22; .ascii          "You DO own an organ donor "      ; .byte -1 ; .even
    .byte  9, 23; .ascii          "card don't you?"                 ; .byte  0 ; .even
                         #0---------1---------2---------3---------
ChibikoReview8:          #0123456789012345678901234567890123456789
    .byte  9, 19; .ascii          "I'd say the purpose of your"     ; .byte -1 ; .even
    .byte  9, 20; .ascii          "existance is to define"          ; .byte -1 ; .even
    .byte  9, 21; .ascii          "utter failure so the rest"       ; .byte -1 ; .even
    .byte  9, 22; .ascii          "of the population can feel"      ; .byte -1 ; .even
    .byte  9, 23; .ascii          "superior!"                       ; .byte  0 ; .even
                         #0---------1---------2---------3---------
PressFireKeyStr:         #0123456789012345678901234567890123456789
    .byte  9, 23; .ascii          "Press Fire to Continue"          ; .byte  0 ; .even
#----------------------------------------------------------------------------}}}

StartANewGame: # ../Aku/BootStrap.asm:2151 #---------------------------------{{{
      # reset the core
        CALL FireMode_Normal # set our standard Left-Right Firemode
      # reset all the scores n stuff
        TSTB @$FireMode
        BPL  NormalFireMode

        CALL FireMode_4D
NormalFireMode:
        MOVB $1,@$LivePlayers
        MOV  $INC_R0_OPCODE,@$PlayerCounter
        BITB $1,@$MultiplayConfig
        BZE  StartANewGame_NoMultiplay

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
   .ifdef TwoPlayersGame
        MOV  $8,R1
   .else
        MOV  $4,R1
   .endif
       #CALL @$ClearR1Words # wipe highscores
       .ppudo_ensure $PPU_StartANewGame # resets score

       #MOV  $Player_Array, R5 # AkuYou_Player_GetPlayerVars
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
        MOV  $DECB_R3_OPCODE,R0

        TSTB @$GameDifficulty # test bit 7
        BMI  HeavenMode

        MOV  $BulletConfigHell,R3
        MOV  $MOVB_R3_R3_OPCODE,R0
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
# StartANewGame -------------------------------------------------------------}}}
StartANewGamePlayer: # ../Aku/BootStrap.asm:2256 ;player fire directions ----{{{
        INC  R5
        INC  R5
        CLRB (R5)+                   #  2 Fire Delay
        MOVB @$SmartBombsReset,(R5)+ #  3 smartbombs
        CLRB (R5)+                   #  4 drones
        MOVB @$ContinuesReset,(R5)+  #  5 continues
        MOVB $16,(R5)+               #  6 drone pos
        MOVB $7,(R5)+                #  7 invincibility 0b00000111
        CLRB (R5)+                   #  8 spritenum
        CLRB (R5)+                   #  9 Player Lives (default both players to dead)
        CLRB (R5)+                   # 10 burst fire xfire
        MOVB $4,(R5)+                # 11 Fire Speed    0b00000100
        INC  R5
        CLRB (R5)+                   # 13 Points to add
        CLRB (R5)+                   # 14 player shoot power
        MOVB $0x67,(R5)+             # 15 Fire dir

        RETURN
#----------------------------------------------------------------------------}}}
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
        MOV  R0,@$Timer.CurrentTick
        MOV  R0,@$DroneFlipCurrent

        CLR  @$EventObjectAnimatorToAdd
        CLR  @$EventObjectSpriteSizeToAdd
        CLR  @$EventObjectProgramToAdd
        CLR  @$Timer.TicksOccured

        CLR  R0
        CALL @$DroneFlipFire

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
        CALL @$DoMovesBackground_SetScroll # TODO: implement the subroutine

        RETURN
# LevelReset0000 end --------------------------------------------------------}}}
#-------------------------------------------------------------------------------
NumberToDecStr:
      # R1 number
      # R2 destination string ponter
      # R3 number of digits
        ADD  R3,R2
        10$:
            CLR  R0      # R0 - most, R1 - least significant word
            DIV  $10,R0  # quotient -> R0 , remainder -> R1
            ADD  $'0, R1 # add ASCII code for "0" to the remainder
            MOVB R1,-(R2)
            MOV  R0,R1
        SOB  R3,10$
        RETURN
#-------------------------------------------------------------------------------
ClearOffscreenBP12:
        MOV  $88*40>>2,R0
        MOV  $CBP12D,R1
        MOV  $CBPADR,R2
        MOV  $OffscreenAreaAddr,(R2)
        200$:
           .rept 1<<2
            CLR  (R1)
            INC  (R2)
           .endr
        SOB  R0,200$
        RETURN
#-------------------------------------------------------------------------------
Bootstrap.WaitForFireKey_NoMessage:
        BIC  $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1

        BITB $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
        BZE  .-6
        RETURN
#-------------------------------------------------------------------------------

Bootstrap.WaitForFireKey: # Bootstrap.WFK -----------------------------------{{{
       .ppudo $PPU_DebugPrintAt,$HitAFireKeyStr
        Bootstrap.WFK_Loop:
            CALL Bootstrap.WFK_DelayLoop
           .ppudo $PPU_SetPalette,$P3
            CALL Bootstrap.WFK_DelayLoop
           .ppudo $PPU_SetPalette,$P4
            CALL Bootstrap.WFK_DelayLoop
           .ppudo $PPU_SetPalette,$P3
            CALL Bootstrap.WFK_DelayLoop
           .ppudo $PPU_SetPalette,$P2
            CALL Bootstrap.WFK_DelayLoop
           .ppudo $PPU_SetPalette,$P1
            CALL Bootstrap.WFK_DelayLoop
           .ppudo $PPU_SetPalette,$P2
        BR   Bootstrap.WFK_Loop

Bootstrap.WFK_DelayLoop:
        MOV  $4,R1
        DelayLoop_Next:
            WAIT
            BITB $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
            BZE  DelayLoop_NoFirePressed

            CLRB @$KeyboardScanner_P1
            TST  (SP)+ # remove returning address from stack
            RETURN     # out of Bootstrap.WaitForFireKey
            DelayLoop_NoFirePressed:
        SOB  R1,DelayLoop_Next
        RETURN

HitAFireKeyStr:
    .byte 13, 7; .ascii "hit a fire key"    ; .byte 0 ; .even
P1:
    .byte   0, setOffscreenColors
    .word      BLACK  | BLACK      << 4 | BR_GREEN  << 8 | BR_CYAN << 12
    .word      BR_RED | BR_MAGENTA << 4 | BR_YELLOW << 8 | WHITE   << 12
    .word untilLine | 0
P2:
    .byte   0, setOffscreenColors
    .word      BLACK  | BLUE       << 4 | BR_GREEN  << 8 | BR_CYAN << 12
    .word      BR_RED | BR_MAGENTA << 4 | BR_YELLOW << 8 | WHITE   << 12
    .word untilLine | 0
P3:
    .byte   0, setOffscreenColors
    .word      BLACK  | BR_BLUE    << 4 | BR_GREEN  << 8 | BR_CYAN << 12
    .word      BR_RED | BR_MAGENTA << 4 | BR_YELLOW << 8 | WHITE   << 12
    .word untilLine | 0
P4:
    .byte   0, setOffscreenColors
    .word      BLACK  | CYAN       << 4 | BR_GREEN  << 8 | BR_CYAN << 12
    .word      BR_RED | BR_MAGENTA << 4 | BR_YELLOW << 8 | WHITE   << 12
    .word untilLine | 0
#----------------------------------------------------------------------------}}}

ClearR1Words:
      # R1 - number of words
      # R3 - starting address
      # we have to deal with odd number of iterations before entering the cycle
        INC  R1
        ASR  R1
        BCC  2$ # number of iterations is odd, skipping first command
        100$:
            CLR  (R3)+
        2$:
            CLR  (R3)+
        SOB  R1, 100$
        RETURN
#-------------------------------------------------------------------------------

Bootstrap.DiskWrite_Start: #--------------------------------------------------
        MOVB $020,@$PS.Command # write to disk
        BR   Bootstrap.DiskIO_Start

Bootstrap.DiskRead_Start: #-------------------------------------------------
        MOVB $010,@$PS.Command # read from disk

Bootstrap.DiskIO_Start:
        MOV  (R0)+,@$PS.CPU_RAM_Address
        MOV  (R0)+,@$PS.WordsCount
        MOV  (R0),R0 # starting block number
      # calculate location of a file on a disk from the starting block number
        CLR  R2      # R2 - most significant word
        MOV  R0,R3   # R3 - least significant word
        DIV  $20,R2  # quotient -> R2, remainder -> R3
        MOVB R2,@$PS.AddressOnDevice     # track number (0-79)

        CLR  R2
        DIV  $10,R2
        INC  R3
        MOVB R3,@$PS.AddressOnDevice + 1 # sector (1-10)

        ASH  $7,R2
        BICB $0x80,@$PS.DeviceNumber     # BICB/BISB to preserve drive number
        BISB R2,@$PS.DeviceNumber        # head (0, 1)

        MOVB $-1,@$PS.Status

       .ppudo_ensure $PPU_LoadDiskFile,$ParamsStruct
        RETURN
# Bootstrap.DiskRead_Start #------------------------------------------------
ParamsStruct:
    PS.Status:          .byte -1  # operation status code
    PS.Command:         .byte 010 # read data from disk
    PS.DeviceType:      .byte 02       # double sided disk
    PS.DeviceNumber:    .byte 0x00 | 0 # bit 7: head(0-bottom, 1-top) ∨ drive number 0(0-3)
    PS.AddressOnDevice: .byte 0, 1     # track 0(0-79), sector 1(1-10)
    PS.CPU_RAM_Address: .word 0
    PS.WordsCount:      .word 0        # number of words to transfer
Bootstrap.DiskIO_WaitForFinish: #--------------------------------------------{{{
        CLC
        MOVB @$PS.Status,R0
        BMI  Bootstrap.DiskIO_WaitForFinish
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
# Bootstrap.DiskIO_WaitForFinish #-------------------------------------------}}}

# files related data --------------------------------------------------------{{{
# each record is 3 words:
#   .word address for the data from a disk
#   .word size in words
#   .word starting block of a file
saved_settings.bin:
    .word SavedSettingsStart
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
level_03_title.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_03.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_04.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_05_title.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_05.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
level_07_title.bin:
    .word Akuyou_LevelStart
    .word 0
    .word 0
#----------------------------------------------------------------------------}}}

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

BlackPalette: #--------------------------------------------------------------{{{
    .byte 1, setOffscreenColors
    .word    BLACK | BLUE  << 4 | BLACK << 8 | BLACK << 12
    .word    BLACK | BLACK << 4 | BLACK << 8 | BLACK << 12
    .byte 1, setColors, Black, Black, Black, Black
    .word untilEndOfScreen
#----------------------------------------------------------------------------}}}
ContinuePalette: #-----------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | RGB
    .byte 1, setColors, Black, Magenta, brCyan, White
    .word untilEndOfScreen
#----------------------------------------------------------------------------}}}
GameOverPalette: #-----------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Red, brYellow, White
    .byte 127, setColors, Black, Red, brMagenta, White
    .word untilEndOfScreen
#----------------------------------------------------------------------------}}}
ReviewPalette: #-------------------------------------------------------------{{{
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, brCyan, brYellow, White
    .word  39, cursorGraphic, scale320 | rGB
    .byte  40, setColors, Black, brCyan, brMagenta, White
    .word 135, cursorGraphic, scale320 | RGB
    .byte 136, setColors, Black, Magenta, brCyan, White
    .word untilEndOfScreen
#----------------------------------------------------------------------------}}}
FireKeyBrightPalette: #------------------------------------------------------{{{
    .byte 185, setColors, Black, Green, brYellow, White
    .word untilLine | 192
FireKeyNormalPalette:
    .byte 185, setColors, Black, Green, brRed, White
    .word untilLine | 192
FireKeyDarkPalette:
    .byte 185, setColors, Black, Green, Red, White
    .word untilLine | 192
FireKeyBlackPalette:
    .byte 185, setColors, Black, Green, Black, White
    .word untilLine | 192
#----------------------------------------------------------------------------}}}
continue.bin.lzsa1:
    .incbin "build/continue.bin.lzsa1"
game_over.bin.lzsa1:
    .incbin "build/game_over.bin.lzsa1"
high_score.bin.lzsa1:
    .incbin "build/high_score.bin.lzsa1"

    .even
end:
