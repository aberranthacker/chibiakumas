               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make the entry point available to a linker

               .equiv  Ep1IntroSizeWords, (end - start) >> 1
               .global Ep1IntroSizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit
       .incbin "resources/ep1-intro.spr"

EventStreamArray:
    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0x01
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 0           # 5

    .word 0, evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0x10
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 2           # 5

    .word 0, evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvStatic
    .word         lifeImmortal
    .word     evtSaveObjSettings | 2           # 2

    .word 0, evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvRegular | spdFast | 0x20
    .word         lifeImmortal
    .word     evtSaveObjSettings | 3           # 2

    .word 0, evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvRegular | spdNormal | 0x32
    .word         lifeImmortal
    .word     evtSaveObjSettings | 4           # 2

    .word 0, evtMultipleCommands | 5
    .word     evtAddToForeground               # 1
    .word     evtLoadObjSettings | 2           # 2
    .word     evtSingleSprite, 3               # 3
    .byte         24+80+6, 24+80-16 # Y, X
    .word     evtSaveLstObjToAdd               # 4
    .word         charnikohime
    .word     evtAddToBackground               # 5

    # Start of fade in block
    .equiv FadeStartPoint, 0

    .word FadeStartPoint + 1 # time
    .word evtSetPalette, BluePalette

    .word FadeStartPoint + 2 # time
    .word evtSetPalette, DarkRealPalette

    .word FadeStartPoint + 3 # time
    .word evtSetPalette, RealPalette

    .word 10, evtCallAddress, ShowText1Init

    .word 49, evtCallAddress, ShowText0Init

    .word 50, evtSetPalette, ChibikoAttacksPalette

    .word 50, evtMultipleCommands | 4
    .word     evtLoadObjSettings | 3           # 1
    .word     evtSingleSprite, sprTwoFrame | 0 # 2
    .byte         24+40-10, 24+160-24
    .word     evtSingleSprite, sprTwoFrame | 1 # 3
    .byte         24+40-10, 24+160-12
    .word     evtSingleSprite, sprTwoFrame | 2 # 4
    .byte         24+40-10, 24+160

    .word 51, evtMultipleCommands | 5
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40-10,      24+160-12-6
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40+24+8-10, 24+160-12-6
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40-10,      24+160-12
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40+24+8-10, 24+160-12
    .word     evtSingleSprite, sprTwoFrame | 6
    .byte         24+40-10+8,    24+160-12

    .word 52, evtSetPalette, ChibikoAttacksPalette2

    .word 52, evtMultipleCommands | 7
    .word     evtLoadObjSettings | 4               # 1
    .word     evtAddToBackground                   # 2
    .word     evtSingleSprite, sprTwoFrame | 6     # 3
    .byte         24+80-4+10, 24+80-16
    .word     evtSingleSprite, sprTwoFrame | 6     # 4
    .byte         24+80+10, 24+80-16+8
    .word     evtAddToForeground                   # 5
    .word     evtSingleSprite, sprTwoFrame | 5     # 6
    .byte         24+80+10, 24+80-16
    .word     evtSaveLstObjToAdd, charnikohimehead # 7

    .word 52, evtCallAddress, Decapitate
    .word 54, evtCallAddress, Decapitateend

    .word 55, evtCallAddress, Clear4000

    .word 68, evtCallAddress, ShowText2Init

    .word 85, evtChangeStreamTime, 67, StartIntroProper

StartIntroProper:
    .word 68, evtCallAddress, ShowText0Init
    .word 68, evtCallAddress, ClearObjects
    .word 70, evtSetPalette, Palette70

    .word 72, evtCallAddress, ShowText3Init
    .word 85, evtCallAddress, ShowText4Init

    .word 110,evtCallAddress, ShowText5Init
    .word 140,evtCallAddress, ShowText6Init
    .word 170,evtCallAddress, ShowText7Init
    .word 200,evtCallAddress, ShowText8Init
    .word 230,evtCallAddress, ShowText9Init
    .word 256+5,evtCallAddress, ShowText10Init
    .word 256+35,evtCallAddress, ShowText11Init
    .word 256+65,evtCallAddress, ShowText12Init
    .word 256+95,evtCallAddress, ShowText13Init
    .word 256+125,evtCallAddress, ShowText14Init
    .word 256+155,evtCallAddress, ShowText15Init
    .word 256+185,evtCallAddress, ShowText16Init
    .word 256+215,evtCallAddress, ShowText17Init
    .word 256+245,evtCallAddress, ShowText18Init
    .word 512+20,evtCallAddress, ShowText19Init
    .word 512+50,evtCallAddress, ShowText20Init
    .word 512+90,evtCallAddress, ShowText21Init

    .word 768+64, evtCallAddress, EndLevel

charnikohime: .word 0
charnikohimehead: .word 0

EndLevel:
        MOV  $0x8000,R5
        JMP  @$ExecuteBootstrap

LevelInit:
       .ppudo_ensure $PPU_SetPalette, $BlackPalette
        # TODO: Load artifact of Level252-Intro_Screens1.asm
        # TODO: call Akuyou_Music_Restart when implemented
        MOV  $EventStreamArray,R5
       #MOV  $Event_SavedSettings,R3
        CALL @$Event_StreamInit
      #.ppudo_ensure $PPU_LoadMusic, $MusicStart
      #.ppudo_ensure $PPU_MusicRestart
        CALL @$ScreenBuffer_Reset

        MTPS $PR0 # enable interrupts
LevelLoop:
        CALL @(PC)+; dstClearScreenPoint: .word null

    .ifdef Debug_ShowLevelTime
        CALL @$ShowLevelTime
    .endif

        CALL @(PC)+; dstFadeCommand: .word null

        CALL @$Timer_UpdateTimer
        WAIT
        CALL @$EventStream_Process
        CALL @(PC)+; dstDoubleStreamProcess: .word null

        BITB @$KeyboardScanner_P1,$Keymap_AnyFire
        BNZ  EndLevel

        WAIT
        CALL @$ObjectArray_Redraw
        CALL @(PC)+; dstShowBossTextCommand: .word ShowBossText

        MOV  (PC)+, R0; srcShowTextUpdate: .word 0xFF
        CMP  R0,$22
        BHI  LevelLoop

        ASL  R0
        MOV  SubtitlesTable(R0),R5
        BR   ResetText
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

    ResetText:                                              # ResetText:
       #MOV  R5,@$srcOnscreenTextPointer                    #         ld(OnscreenTextPointer_Plus2-2),hl
                                                            #         ld (OnscreenTextPos_Plus1-1),a
                                                            #         ld a,1
                                                            #         ld (BossCharNum_Plus1-1),a
                                                            #         ld a,0
        MOV  $0xFF,@$srcShowTextUpdate                      #         ld(ShowTextUpdate_Plus1-1),a
                                                            #         ld a,15
                                                            #         ld (OnscreenTimer_Plus1-1),a
       .wait_ppu
        MOV  R5, @$PPUCommandArg;
        MOV  $PPU_LoadText, @$PPUCommand
        MOV  $1,@$srcCharsToPrint

        CALL @$Clear4000                                    #         call Clear4000
                                                            #
                                                            #         ld ixh,0
                                                            ##ifdef BuildCPC
                                                            #         call Akuyou_RasterColors_Blackout
                                                            ##endif
                                                            ##if buildCPCv+buildENTv
                                                            #         call null   :CompiledSprite_Plus2
                                                            ##endif
                                                            #
                                                            # NoBackPic:
                                                            ##if buildCPCv+buildENTv
                                                            #         ld a,ixh
                                                            #         cp 0
                                                            #         call nz,RLE_Draw
                                                            ##endif
        JMP  @$LevelLoop                                    #         jp levelloop

ShowText0Init: #-------------------------------------------------------------{{{
        MOV  $0,R0
        BR   UpdateShowText
ShowText1Init:
        MOV  $1,R0
        BR   UpdateShowText
ShowText2Init:
        MOV  $2,R0
        BR   UpdateShowText
ShowText3Init:
        MOV  $3,R0
        BR   UpdateShowText
ShowText4Init:
        MOV  $4,R0
        BR   UpdateShowText
ShowText5Init:
        MOV  $5,R0
        BR   UpdateShowText
ShowText6Init:
        MOV  $6,R0
        BR   UpdateShowText
ShowText7Init:
        MOV  $7,R0
        BR   UpdateShowText
ShowText8Init:
        MOV  $8,R0
        BR   UpdateShowText
ShowText9Init:
        MOV  $9,R0
        BR   UpdateShowText
ShowText10Init:
        MOV  $10,R0
        BR   UpdateShowText
ShowText11Init:
        MOV  $11,R0
        BR   UpdateShowText
ShowText12Init:
        MOV  $12,R0
        BR   UpdateShowText
ShowText13Init:
        MOV  $13,R0
        BR   UpdateShowText
ShowText14Init:
        MOV  $14,R0
        BR   UpdateShowText
ShowText15Init:
        MOV  $15,R0
        BR   UpdateShowText
ShowText16Init:
        MOV  $16,R0
        BR   UpdateShowText
ShowText17Init:
        MOV  $17,R0
        BR   UpdateShowText
ShowText18Init:
        MOV  $18,R0
        BR   UpdateShowText
ShowText19Init:
        MOV  $19,R0
        BR   UpdateShowText
ShowText20Init:
        MOV  $20,R0
        BR   UpdateShowText
ShowText21Init:
        MOV  $21,R0
        BR   UpdateShowText
ShowText22Init:
        MOV  $22,R0

UpdateShowText:
        MOV  R0, @$srcShowTextUpdate

NoSpeech:
        RETURN
#----------------------------------------------------------------------------}}}

ShowBossText: # ../Aku/Level252-Intro.asm:1950
        INC  @$srcCharsToPrint
        MOV  (PC)+, @(PC)+
        srcCharsToPrint: .word 1; .word PPUCommandArg;
        MOV  $PPU_ShowBossText, @$PPUCommand
RETURN

# Subtitles #----------------------------------------------------------------{{{
SubtitlesEmpty: #------------------------------------------------------------{{{
    .byte  4, 10; .ascii "     " ; .byte 0xFF
    .byte  4, 11; .ascii "     " ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles1: #----------------------------------------------------------------{{{
                         #0         1         2         3         4
                         #01234567890123456789012345678901234567890
    .byte  8,  5; .ascii "Once Upon a time..."                     ; .byte 0xFF
    .byte  5,  6; .ascii "In a land far far away..."               ; .byte 0xFF
    .byte  3,  7; .ascii "There was a girl who was kind"           ; .byte 0xFF
    .byte  1,  8; .ascii "to everyone and brought happiness"       ; .byte 0xFF
    .byte  4,  9; .ascii "everywhere She went \177 \177 \177"      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles2: #----------------------------------------------------------------{{{
    .byte  7, 23; .ascii "She isn't in this game!!!"               ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles3: #----------------------------------------------------------------{{{
    .byte  7, 12; .ascii "Do you know what happens"                ; .byte 0xFF
    .byte  7, 13; .ascii "       when you die??"                   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles4: #----------------------------------------------------------------{{{
    .byte  8, 12; .ascii "They say 'if you're good"                ; .byte 0xFF
    .byte  3, 13; .ascii "You go to a place of wonder where"       ; .byte 0xFF
    .byte  5, 14; .ascii "all your dreams will come true'"         ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles5: #----------------------------------------------------------------{{{
    .byte  4, 12; .ascii "But 'If you're bad, you'll go to"        ; .byte 0xFF
    .byte  4, 13; .ascii "the OTHER PLACE Where you'll be"         ; .byte 0xFF
    .byte  1, 14; .ascii "punished for the bad things you did!!'"  ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles6: #----------------------------------------------------------------{{{
    .byte  3, 12; .ascii "But what no-one tells you is that"       ; .byte 0xFF
    .byte  2, 13; .ascii "some people are SO bad, they don't "     ; .byte 0xFF
    .byte 12, 14; .ascii "go there either.."                       ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles7: #----------------------------------------------------------------{{{
    .byte  2, 18; .ascii "Chibiko was a typical cheerful girl.."   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles8: #----------------------------------------------------------------{{{
    .byte 10, 18; .ascii "She loved animals,!"                     ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles9: #----------------------------------------------------------------{{{
    .byte  2, 18; .ascii "And enjoyed spending time outdoors!!"    ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles10: #---------------------------------------------------------------{{{
    .byte  3, 18; .ascii "Sometimes she was 'a bit' naughty."      ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles11: #---------------------------------------------------------------{{{
    .byte  1, 18; .ascii " And she didn't really like to study."   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles12: #---------------------------------------------------------------{{{
    .byte  1, 18; .ascii "But one time she was very, very bad."    ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles13: #---------------------------------------------------------------{{{
    .byte  6, 18; .ascii "And took a 'prank' too far."             ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles14: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "When someone does the unforgivable..."   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles15: #---------------------------------------------------------------{{{
    .byte  7, 18; .ascii "Judgement comes from above!."            ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles16: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "and strikes them once and for all!."     ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles17: #---------------------------------------------------------------{{{
    .byte  2, 18; .ascii "Really bad people don't go to heaven."   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles18: #---------------------------------------------------------------{{{
    .byte  1, 18; .ascii "and even hell has its limit to who"      ; .byte 0xFF
    .byte 12, 19; .ascii "they'll take!!."                         ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles19: #---------------------------------------------------------------{{{
    .byte  2, 16; .ascii "You see, when people die,if they've "    ; .byte 0xFF
    .byte  4, 17; .ascii "been 'Really Bad', they dont go"         ; .byte 0xFF
    .byte 10, 18; .ascii "'up' or 'down'"                          ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles20: #---------------------------------------------------------------{{{
    .byte  2, 16; .ascii "They stay where they were as undead"     ; .byte 0xFF
    .byte  6, 17; .ascii "monsters, hated by God, and"             ; .byte 0xFF
    .byte  9, 18; .ascii "feared by all mankind!"                  ; .byte 0xFF
    .byte  1, 19; .ascii "with an endless thirst for human blood!" ; .byte 0x00
    .even #------------------------------------------------------------------}}}
Subtitles21: #---------------------------------------------------------------{{{
Subtitles22:
    .byte  2, 16; .ascii "They live out eternity as Nosferatu,"    ; .byte 0xFF
    .byte  1, 17; .ascii "Vampires, cursed to live by feeding on"  ; .byte 0xFF
    .byte  2, 18; .ascii "their former friends and companions!!"   ; .byte 0x00
    .even #------------------------------------------------------------------}}}
#----------------------------------------------------------------------------}}}

Decapitate:
        MOV  @$charnikohime,R0
        MOVB $sprTwoFrame|4,3(R0) # change sprite
RETURN

Decapitateend:
        MOV  @$charnikohimehead,R0
        MOVB $0x24,2(R0) # change move to static
RETURN

ClearObjects:
        MOV  @$charnikohime,R0
        CLR  (R0)
        MOV  @$charnikohimehead,R0
        CLR  (R0)
RETURN

Clear4000: #-----------------------------------------------------------------{{{
        # do note use the power more than 4, because of the limit of the SOB
       .equiv Clear4000_PowerOfTwo, 4
        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R2,-(SP)

        MOV  $8000 >> Clear4000_PowerOfTwo, R0
        CLR  R1
        MOV  @$ScreenBuffer_ActiveScreen,R2
    10$:
       .rept 1 << Clear4000_PowerOfTwo
        MOV  R1,(R2)+
       .endr
        SOB  R0,10$

        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0

        RETURN
#-----------------------------------------------------------------------------}}}
BlackPalette: #---------------------------------------------------------------{{{
    .byte 1, 1    # line number,  set colors
    .byte 0x00, 0x00, 0x00, 0x00
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
BluePalette: #---------------------------------------------------------------{{{
    .byte 0, 0    # line number, set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10000 #  320 dots per line, pallete 0

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0x11, 0x11, 0x55
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
DarkRealPalette: #-----------------------------------------------------------{{{
    .byte 0, 0    #  line number, 0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10000 #  320 dots per line, pallete 0

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0xDD, 0xAA, 0xFF
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
RealPalette: #---------------------------------------------------------------{{{
    .byte 0, 0    # line number, 0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, YRGB color
    .word 0b10100 #  320 dots per line, pallete 4

    .byte 1, 1    # line number, set colors
    .byte 0x00, 0xEE, 0xDD, 0xFF # 54=000, 4D=F0F, 4F=F8F, 4B=FFF

    .byte 0121,1  #--line number, set colors
    .byte 0x00, 0xDD, 0xAA, 0xFF # 54=000, 47=F88, 52=0F0, 4B=FFF

    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
ChibikoAttacksPalette: #-----------------------------------------------------{{{
    .byte 1, 1
    .byte 0x00, 0x55, 0x99, 0xFF # 0x0000, 0x0808, 0x088F, 0x0FFF RGB

    .byte 88,-1   #line number, leave palette unchanged starting the line
    .even
#----------------------------------------------------------------------------}}}
ChibikoAttacksPalette2: #----------------------------------------------------{{{
    .byte 88, 1
    .byte 0x00, 0xCC, 0xAA, 0x77 # 000, C03, 2D7, 888 RGB

    .byte 180, 1
    .byte 0x00, 0x44, 0xCC, 0x77 # 000, 090, 0F0, 8F8 GRB

    .byte 201
    .even
#----------------------------------------------------------------------------}}}
Palette70: #-----------------------------------------------------------------{{{
    .byte 0, 0    # line number, 0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, YRGB color
    .word 0b10011 #  320 dots per line, pallete 4

    .byte 1, 1
    .byte 0x00, 0xDD, 0x77, 0xFF # 54=000, 5D=80F, 40=888, 4B=FFF

    .byte 201
    .even
#----------------------------------------------------------------------------}}}
# 9 br.     # A br.     # B br.     # C br.     # D br.     # E br.     # F white
# 1 blue    # 2 green   # 3 cyan    # 4 red     # 5 magenta # 6 yellow  # 7 gray

# for some reason GAS(or LD) replaces the last byte with 0
# so we add dummy word to avoid data/code corruption
        .word 0xFFFF
end:
