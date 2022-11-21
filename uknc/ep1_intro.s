               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make the entry point available to a linker
               .global Ep1IntroSize
               .global Ep1IntroSizeWords

               .equiv  Ep1IntroSize, (end - start)
               .equiv  Ep1IntroSizeWords, Ep1IntroSize >> 1

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit
       .incbin "build/ep1_intro.spr"

slide01: .incbin "build/ep1-intro/ep1-intro-slide01.raw.lzsa1" # chibiki
slide02: .incbin "build/ep1-intro/ep1-intro-slide02.raw.lzsa1" # fishing
slide03: .incbin "build/ep1-intro/ep1-intro-slide03.raw.lzsa1" # camping
slide04: .incbin "build/ep1-intro/ep1-intro-slide04.raw.lzsa1" # prank with poison
slide05: .incbin "build/ep1-intro/ep1-intro-slide05.raw.lzsa1" # school1
slide06: .incbin "build/ep1-intro/ep1-intro-slide06.raw.lzsa1" # bulbs
slide07: .incbin "build/ep1-intro/ep1-intro-slide07.raw.lzsa1" # plane
slide08: .incbin "build/ep1-intro/ep1-intro-slide08.raw.lzsa1" # school2
         .even

EventStreamArray:
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0b0001
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 0           # 5  unused object settings

    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0b0010
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 1           # 5 unused object settings

    .word 0, evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvStatic
    .word         lifeImmortal
    .word     evtSaveObjSettings | 2           # 2

    .word 0, evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvRegular | spdFast | 040
    .word         lifeImmortal
    .word     evtSaveObjSettings | 3           # 2

    .word 0, evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvRegular | spdNormal | 062
    .word         lifeImmortal
    .word     evtSaveObjSettings | 4           # 2
#-------------------------------------------------------------------------------
   # charnikohime
    .word 0, evtMultipleCommands | 5
    .word     evtAddToForeground               # 1
    .word     evtLoadObjSettings | 2           # 2
    .word     evtSingleSprite, 3               # 3
    .byte         24+80+6, 24+80-16 # Y, X 110, 88
    .word     evtSaveObjPointer, charnikohime  # 4
    .word     evtAddToBackground               # 5

   # Start of fade in block
    .equiv FadeStartPoint, 0
    .word FadeStartPoint + 1, evtSetPalette, BluePalette
    .word FadeStartPoint + 2, evtSetPalette, DarkRealPalette
    .word FadeStartPoint + 3, evtSetPalette, RealPalette

    #----------
   #.word 3, evtChangeStreamTime, 256+245+15, DebugStartPoint
    #----------
DebugStartPoint:

    .word 10, evtCallAddress, ShowText1Init

    .word 49, evtCallAddress, ShowText0Init

    .word 50, evtSetPalette, ChibikoAttacksPalette
   # flying Chibiko
    .word 50, evtMultipleCommands | 4
    .word     evtLoadObjSettings | 3           # 1
    .word     evtSingleSprite, sprTwoFrame | 0 # 2
    .byte         24+40-10, 24+160-24 # Y, X : 30, 272
    .word     evtSingleSprite, sprTwoFrame | 1 # 3
    .byte         24+40-10, 24+160-12 # Y, X : 30, 296
    .word     evtSingleSprite, sprTwoFrame | 2 # 4
    .byte         24+40-10, 24+160    # Y, X : 30, 320
   # cleanup Chibiko sprite
    .word 51, evtMultipleCommands | 5
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40-10,      24+160-12-6 # Y, X : 30, 284
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40+24+8-10, 24+160-12-6 # Y, X : 62, 284
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40-10,      24+160-12   # Y, X : 30, 286
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40+24+8-10, 24+160-12   # Y, X : 62, 286
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40-10+8,    24+160-12   # Y, X : 22, 286

    .word 52, evtSetPalette, ChibikoAttacksPalette2
   # flying head
    .word 52, evtMultipleCommands | 7
    .word     evtLoadObjSettings | 4               # 1
    .word     evtAddToBackground                   # 2
    .word     evtSingleSprite, sprTwoFrame | 6     # 3 cleanup sprite
    .byte         24+80-4+10, 24+80-16 # Y, X : 86, 128
    .word     evtSingleSprite, sprTwoFrame | 6     # 4 cleanup sprite
    .byte         24+80+10, 24+80-16+8 # Y, X : 90, 144
    .word     evtAddToForeground                   # 5
    .word     evtSingleSprite, sprTwoFrame | 5     # 6
    .byte         24+80+10, 24+80-16   # Y, X :  9, 128
    .word     evtSaveObjPointer, charnikohimehead  # 7

    .word 52, evtCallAddress, Decapitate
    .word 54, evtCallAddress, Decapitateend

    .word 55, evtCallAddress, Clear4000

    .word 68, evtCallAddress, ShowText2Init

    .word 85, evtChangeStreamTime, 67, StartIntroProper

StartIntroProper:
    .word 68, evtCallAddress, ShowText0Init
    .word 68, evtCallAddress, ClearObjects

    .word 75,         evtCallAddress, ShowText3Init  # when you die
    .word 85+15,      evtCallAddress, ShowText4Init
    .word 110+15,     evtCallAddress, ShowText5Init
    .word 140+15,     evtCallAddress, ShowText6Init
    .word 170+15,     evtCallAddress, ShowText7Init  # chibiko
    .word 200+15,     evtCallAddress, ShowText8Init  # fishing
    .word 230+15,     evtCallAddress, ShowText9Init  # camping

    .word 256+  5+15, evtCallAddress, ShowText10Init # prank
    .word 256+ 35+15, evtCallAddress, ShowText11Init # school1
    .word 256+ 65+15, evtCallAddress, ShowText12Init # bulbs
    .word 256+ 95+15, evtCallAddress, ShowText13Init # plane
    .word 256+125+15, evtCallAddress, ShowText14Init # school2
    .word 256+155+15, evtCallAddress, ShowText15Init # lightning1
    .word 256+185+15, evtCallAddress, ShowText16Init # lightning2
    .word 256+215+15, evtCallAddress, ShowText17Init # heaven
    .word 256+245+15, evtCallAddress, ShowText18Init # hell
    .word 512+ 20+15, evtCallAddress, ShowText19Init # chibiko
    .word 512+ 50+15, evtCallAddress, ShowText20Init # chibiko nosferatu
    .word 512+ 90+15, evtCallAddress, ShowText21Init # haunting

    .word 768+64, evtCallAddress, EndLevel

EndLevel:
       .ppudo_ensure $PPU_MusicStop
        MOV  $0x8000,R5
        JMP  @$ExecuteBootstrap

LevelInit:
        CALL @$ScreenBuffer.Reset
       .ppudo_ensure $PPU_IntroMusicRestart

        MOV  $LevelSprites,R0
        MOV  $SpriteBanksVectors,R1
        MOV  R0,(R1)+
        MOV  R0,(R1)+
        MOV  R0,(R1)+
        MOV  R0,(R1)+

        MOV  $EventStreamArray,R5
        CALL @$EventStream_Init

        MTPS $PR0 # enable interrupts
LevelLoop:
       .equiv dstClearScreenPoint, .+2
        CALL @$null
       .equiv dstFadeCommand, .+2
        CALL @$null

        CALL @$Timer.UpdateTimer
        CALL @$EventStream_Process

       .equiv dstDoubleStreamProcess, .+2
        CALL @$null

        BITB $KEYMAP_ANY_FIRE,@$KeyboardScanner_P1
        BNZ  EndLevel

        CALL @$ObjectArray_Redraw

       .equiv dstShowBossTextCommand, .+2
        CALL @$null
        WAIT
        WAIT
        WAIT
        WAIT
        WAIT

       .equiv ShowTextUpdate, .+2
        MOV  $0, R0
        CMP  R0,$22
        BHI  LevelLoop

        MOV  $0xFF,@$ShowTextUpdate
        ASL  R0

        MOV  SubtitlesTable(R0), @$PPUCommandArg
       .ppudo_ensure $PPU_ShowBossText.Init

        MOV  $1, @$CharsToPrint
        MOV  $ShowBossText, @$dstShowBossTextCommand

        CALL @$Clear4000

        TST  R0
        BZE  skip_palette_change$
        MOV  PalettesTable(R0), @$PPUCommandArg
       .ppudo_ensure $PPU_SetPalette

    skip_palette_change$:
       .equiv PicAddr, .+2
        MOV  $0x0000,R1
        BZE  1237$ # address is zero, no slide to display
        MOV  $FB0,R2
        CALL @$unlzsa1

        MOV  $FB0,R1
        MOV  $FB1+(12*2),R2
        MOV  $96,R3
        96$:
           .rept 16
            MOV  (R1)+,(R2)+
           .endr
        ADD  $24*2,R2
        SOB  R3,96$

1237$:
        JMP  @$LevelLoop


    SubtitlesTable:
       .word SubtitlesEmpty
       .word Subtitles1
       .word Subtitles2
       .word Subtitles3
       .word Subtitles4
       .word Subtitles5
       .word Subtitles6
       .word Subtitles7
       .word Subtitles8
       .word Subtitles9
       .word Subtitles10
       .word Subtitles11
       .word Subtitles12
       .word Subtitles13
       .word Subtitles14
       .word Subtitles15
       .word Subtitles16
       .word Subtitles17
       .word Subtitles18
       .word Subtitles19
       .word Subtitles20
       .word Subtitles21
       .word Subtitles22
    PalettesTable:
       .word BlackPalette           #  0
       .word RealPalette            #  1
       .word ChibikoAttacksPalette2 #  2
       .word WhenYouDiePalette      #  3
       .word IfYoureGoodPalette     #  4
       .word IfYoureBadPalette      #  5
       .word OtherOptionPalette     #  6
       .word PhotoChibiko1Palette   #  7
       .word FishingPalette         #  8
       .word CampingPalette         #  9
       .word PrankPalette           # 10
       .word School1Palette         # 11
       .word BulbsPalette           # 12
       .word PlanePalette           # 13
       .word School2Palette         # 14
       .word Lightning1Palette      # 15
       .word Lightning2Palette      # 16
       .word HeavenPalette          # 17
       .word HellPalette            # 18
       .word PhotoChibiko2Palette   # 19
       .word PhotoChibiko3Palette   # 20
       .word HauntingPalette        # 21
       .word BlackPalette           # 22

ShowText0Init: #-------------------------------------------------------------{{{
        CLR  @$PicAddr
        CLR  R0
        BR   UpdateShowText
ShowText1Init:
        CLR  @$PicAddr
        MOV  $1,R0
        BR   UpdateShowText
ShowText2Init:
        CLR  @$PicAddr
        MOV  $2,R0
        BR   UpdateShowText
ShowText3Init:
        CLR  @$PicAddr
        MOV  $3,R0
        BR   UpdateShowText
ShowText4Init:
        CLR  @$PicAddr
        MOV  $4,R0
        BR   UpdateShowText
ShowText5Init:
        CLR  @$PicAddr
        MOV  $5,R0
        BR   UpdateShowText
ShowText6Init:
        CLR  @$PicAddr
        MOV  $6,R0
        BR   UpdateShowText
ShowText7Init:
        MOV  $slide01,@$PicAddr # chibiko
        MOV  $7,R0
        BR   UpdateShowText
ShowText8Init:
        MOV  $slide02,@$PicAddr # fishing
        MOV  $8,R0
        BR   UpdateShowText
ShowText9Init:
        MOV  $slide03,@$PicAddr # camping
        MOV  $9,R0
        BR   UpdateShowText
ShowText10Init:
        MOV  $slide04,@$PicAddr # prank
        MOV  $10,R0
        BR   UpdateShowText
ShowText11Init:
        MOV  $slide05,@$PicAddr # school1
        MOV  $11,R0
        BR   UpdateShowText
ShowText12Init:
        MOV  $slide06,@$PicAddr # bulbs
        MOV  $12,R0
        BR   UpdateShowText
ShowText13Init:
        MOV  $slide07,@$PicAddr # plane
        MOV  $13,R0
        BR   UpdateShowText
ShowText14Init:
        MOV  $slide08,@$PicAddr # school2
        MOV  $14,R0
        BR   UpdateShowText
ShowText15Init:
        MOV  $slide09,@$PicAddr # lightning1
        MOV  $15,R0
        BR   UpdateShowText
ShowText16Init:
        MOV  $slide10,@$PicAddr # lightning2
        MOV  $16,R0
        BR   UpdateShowText
ShowText17Init:
        MOV  $slide11,@$PicAddr # heaven
        MOV  $17,R0
        BR   UpdateShowText
ShowText18Init:
        MOV  $slide12,@$PicAddr # hell
        MOV  $18,R0
        BR   UpdateShowText
ShowText19Init:
        MOV  $slide13,@$PicAddr # photo1
        MOV  $19,R0
        BR   UpdateShowText
ShowText20Init:
        MOV  $slide14,@$PicAddr # photo2
        MOV  $20,R0
        BR   UpdateShowText
ShowText21Init:
        MOV  $slide15,@$PicAddr # haunting
        MOV  $21,R0
        BR   UpdateShowText
ShowText22Init:
        CLR  @$PicAddr
        MOV  $22,R0

UpdateShowText:
        MOV  $null, @$dstShowBossTextCommand
        MOV  R0, @$ShowTextUpdate

        RETURN
#----------------------------------------------------------------------------}}}

ShowBossText: # ../Aku/Level252-Intro.asm:1950
        INC  @$CharsToPrint
       .equiv CharsToPrint, .+2
        MOV  $1, @$PPUCommandArg
       .ppudo_ensure $PPU_ShowBossText

        RETURN

# Subtitles #----------------------------------------------------------------{{{
SubtitlesEmpty: #------------------------------------------------------------{{{
    .byte  0,  0; .ascii ""; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles1: #----------------------------------------------------------------{{{
                         #0         1         2         3         4
                         #01234567890123456789012345678901234567890
    .byte 11,  5; .ascii "Once Upon a time..."                     ; .byte 0xFF
    .byte  7,  6; .ascii "In a land far far away..."               ; .byte 0xFF
    .byte  5,  7; .ascii "There was a girl who was kind"           ; .byte 0xFF
    .byte  3,  8; .ascii "to everyone and brought happiness"       ; .byte 0xFF
    .byte  6,  9; .ascii "everywhere She went \177 \177 \177"      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles2: #----------------------------------------------------------------{{{
    .byte  7, 23; .ascii "She isn't in this game!!!"               ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles3: #----------------------------------------------------------------{{{
    .byte  8, 12; .ascii "Do you know what happens"                ; .byte 0xFF
    .byte 13, 13; .ascii "when you  die?"                          ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles4: #----------------------------------------------------------------{{{
    .byte  8, 12; .ascii "They say 'if you're good"                ; .byte 0xFF
    .byte  3, 13; .ascii "You go to a place of wonder where"       ; .byte 0xFF
    .byte  5, 14; .ascii "all your dreams will come true'"         ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles5: #----------------------------------------------------------------{{{
    .byte  4, 12; .ascii "But \"If you're bad, you'll go to"       ; .byte 0xFF
    .byte  4, 13; .ascii "the OTHER PLACE Where you'll be"         ; .byte 0xFF
    .byte  1, 14; .ascii "punished for the bad things you did!\""  ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles6: #----------------------------------------------------------------{{{
    .byte  3, 12; .ascii "But what no-one tells you is that"       ; .byte 0xFF
    .byte  2, 13; .ascii "some people are SO bad, they don't "     ; .byte 0xFF
    .byte 12, 14; .ascii "go there either..."                      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles7: #----------------------------------------------------------------{{{
    .byte  2, 18; .ascii "Chibiko was a typical cheerful girl."    ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles8: #----------------------------------------------------------------{{{
    .byte 11, 18; .ascii "She loved animals,"                      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles9: #----------------------------------------------------------------{{{
    .byte  2, 18; .ascii "and enjoyed spending time outdoors!"     ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles10: #---------------------------------------------------------------{{{
    .byte  3, 18; .ascii "Sometimes she was 'a bit' naughty."      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles11: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "And she didn't really like to study."    ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles12: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "But one time she was very, very bad"     ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles13: #---------------------------------------------------------------{{{
    .byte  7, 18; .ascii "And took a 'prank' too far."             ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles14: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "When someone does the unforgivable..."   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles15: #---------------------------------------------------------------{{{
    .byte  7, 18; .ascii "Judgement comes from above!"             ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles16: #---------------------------------------------------------------{{{
    .byte  3, 18; .ascii "and strikes them once and for all!"      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles17: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "Really bad people don't go to heaven."   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles18: #---------------------------------------------------------------{{{
    .byte  3, 18; .ascii "and even hell has its limit to who"      ; .byte 0xFF
    .byte 13, 19; .ascii "they'll take!!!"                         ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles19: #---------------------------------------------------------------{{{
    .byte  2, 16; .ascii "You see, when people die,if they've "    ; .byte 0xFF
    .byte  4, 17; .ascii "been 'Really Bad', they dont go"         ; .byte 0xFF
    .byte 13, 18; .ascii "'up' or 'down'"                          ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles20: #---------------------------------------------------------------{{{
    .byte  2, 16; .ascii "They stay where they were as undead"     ; .byte 0xFF
    .byte  6, 17; .ascii "monsters, hated by God, and"             ; .byte 0xFF
    .byte  9, 18; .ascii "feared by all mankind!"                  ; .byte 0xFF
    .byte  1, 19; .ascii "With an endless thirst for human blood!" ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles21: #---------------------------------------------------------------{{{
Subtitles22:
    .byte  2, 16; .ascii "They live out eternity as Nosferatu,"    ; .byte 0xFF
    .byte  1, 17; .ascii "Vampires, cursed to live by feeding on"  ; .byte 0xFF
    .byte  2, 18; .ascii "their former friends and companions!"    ; .byte 0x00
    .even #------------------------------------------------------------------}}}
#----------------------------------------------------------------------------}}}

Decapitate:
       .equiv charnikohime, .+2
        MOV  $0,R0
        MOVB $sprTwoFrame | 4, 3(R0) # change sprite
        RETURN

Decapitateend:
       .equiv charnikohimehead, .+2
        MOV  $0,R0
        MOVB $044, 2(R0) # change move to static
        RETURN

ClearObjects:
        MOV  @$charnikohime,R0
        CLR  (R0)
        MOV  @$charnikohimehead,R0
        CLR  (R0)
        RETURN

Clear4000: #-----------------------------------------------------------------{{{
      # do note use the power more than 5, because of the SOB range
       .equiv Clear4000_PowerOfTwo, 5
        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R2,-(SP)

        MOV  $8000 >> Clear4000_PowerOfTwo, R0
        CLR  R1
        MOV  @$ScreenBuffer.ActiveScreen,R2
    10$:
       .rept 1 << Clear4000_PowerOfTwo
        MOV  R1,(R2)+
       .endr
        SOB  R0,10$

        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0

        RETURN
#----------------------------------------------------------------------------}}}

BlackPalette: #-----------------------------------------------------------------
    .byte   1, setColors, Black, Black, Black, Black
    .word endOfScreen
BluePalette: #------------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | rgb
    .byte   1, setColors, Black, Blue, Blue, Magenta
    .word endOfScreen
DarkRealPalette: #--------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | Rgb
    .byte   1, setColors, Black, Magenta, Green, Gray
    .word endOfScreen
RealPalette: #------------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | Rgb
    .byte   1, setColors, Black, brYellow,  brMagenta, White
    .byte 110, setColors, Black, brMagenta, brGreen,   White
    .byte 131, setColors, Black, brRed,     brMagenta, White
    .word endOfScreen
ChibikoAttacksPalette: #--------------------------------------------------------
    .byte   1, setColors, Black, Magenta, brBlue, White
    .word untilLine | 88 # leave palette unchanged starting the line
ChibikoAttacksPalette2: #-------------------------------------------------------
    .byte  88, setColors, Black, brRed, brGreen, Gray
    .byte 180, setColors, Black, Red, brRed, Gray
    .word endOfScreen
WhenYouDiePalette: #------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | rgb
    .byte   1, setColors, Black, Magenta, White, White
    .word endOfScreen
IfYoureGoodPalette: #-----------------------------------------------------------
    .word   0, cursorGraphic, scale320 | rGb
    .byte   1, setColors, Black, Cyan, brCyan, White
    .word endOfScreen
IfYoureBadPalette: #------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | Rgb
    .byte   1, setColors, Black, Red, brRed, White
    .word endOfScreen
OtherOptionPalette: #-----------------------------------------------------------
    .word   0, cursorGraphic, scale320 | rGB
    .byte   1, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen
PhotoChibiko1Palette: #---------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, Magenta,  brCyan, White
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
FishingPalette: #---------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Blue,     brCyan, White
    .byte  52, setColors, Black, Magenta,  brCyan, White
    .byte  78, setColors, Black, Green,    brCyan, White
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
CampingPalette: #---------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | Rgb
    .byte   1, setColors, Black, brRed, brYellow, White
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
PrankPalette: #-----------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, Magenta,  brCyan, White
    .byte  38, setColors, Black, brGreen,  brCyan, White
    .word  70, cursorGraphic, scale320 | RGB
    .byte  73, setColors, Black, Green,    brCyan, White
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
School1Palette: #---------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | rgB
    .byte   1, setColors, Black, brBlue, brMagenta, White
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
BulbsPalette: #-----------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, Gray, Green, White
    .byte  30, setColors, Black, Magenta, brCyan, White
    .byte  70, setColors, Black, Green, Green, White
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
PlanePalette: #-----------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, brRed, brGreen, White
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
School2Palette: #---------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | Rgb
    .byte   1, setColors, Black, brRed, brYellow, White
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
Lightning1Palette: #------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Gray,     Green,  White
    .byte  30, setColors, Black, Magenta,  Cyan,   White
    .byte  85, setColors, Black, Green,    Green,  White
    .byte 100, setColors, Black, brYellow, brCyan, White
    .word endOfScreen
Lightning2Palette: #------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Gray,     brYellow, White
    .byte  85, setColors, Black, Green,    Green,    White
    .byte 100, setColors, Black, brYellow, brCyan,   White
    .word endOfScreen
HeavenPalette: #----------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Magenta, brCyan, White
    .word endOfScreen
HellPalette: #------------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, Magenta, brRed,     brYellow
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen
PhotoChibiko2Palette: #---------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, Magenta, brCyan, White
    .word  99, cursorGraphic, scale320 | RGB
    .byte 100, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen
PhotoChibiko3Palette: #---------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RGB
    .byte   1, setColors, Black, Magenta, brCyan,    White
    .byte  40, setColors, Black, Magenta, brRed,     White
    .byte  57, setColors, Black, Magenta, brCyan,    White
    .byte 100, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen
HauntingPalette: #--------------------------------------------------------------
    .word   0, cursorGraphic, scale320 | RgB
    .byte   1, setColors, Black, Magenta, brCyan,    White
    .byte  47, setColors, Black, brRed,   brCyan,    White
    .word  99, cursorGraphic, scale320 | rGB
    .byte 100, setColors, Black, Magenta, brMagenta, White
    .word endOfScreen
#-------------------------------------------------------------------------------
    .even
end:
