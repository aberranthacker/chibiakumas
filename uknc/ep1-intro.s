               .nolist

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"
               .include "./event_stream_definitions.s"

               .global start # make entry point available to a linker

               .equiv  Ep1IntroSizeWords, (end - start) >> 1
               .global Ep1IntroSizeWords

               .=Akuyou_LevelStart

start:
        JMP  @$LevelInit
       .incbin "resources/ep1-intro.spr"

EventStreamArray:
    .word 0 # time
    .word evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0x01
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 0           # 5

    .word 0 # time
    .word evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0x10
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground               # 4
    .word     evtSaveObjSettings | 1           # 5

    .word 0 # time
    .word evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvStatic
    .word         lifeImmortal
    .word     evtSaveObjSettings | 2           # 2

    .word 0 # time
    .word evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvRegular | spdFast | 0x20
    .word         lifeImmortal
    .word     evtSaveObjSettings | 3           # 2

    .word 0 # time
    .word evtMultipleCommands | 2
    .word     evtSetProgMoveLife               # 1
    .word         prgNone
    .word         mvRegular | spdNormal | 0x32
    .word         lifeImmortal
    .word     evtSaveObjSettings | 4           # 2

    .word 0 # time
    .word evtMultipleCommands | 5
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

   #.word 10 # time
    .word 4 # time
    .word evtCallAddress, ShowText1Init

    .word 64 # time
    .word evtCallAddress, EndLevel

charnikohime: .word 0

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
        # TODO: call Akuyou_Music_Restart when implemented
        CALL @$ScreenBuffer_Reset

        MTPS $PR0 # enable interrupts
LevelLoop:
        CALL @(PC)+; dstClearScreenPoint: .word null

    .ifdef Debug_ShowLevelTime
        CALL @$ShowLevelTime
    .endif

        CALL @(PC)+; dstFadeCommand: .word null

        CALL @$Timer_UpdateTimer
       #WAIT
        CALL @$EventStream_Process
        CALL @(PC)+; dstDoubleStreamProcess: .word null
       #WAIT

        BITB @$KeyboardScanner_P1,$Keymap_AnyFire
        BNZ  EndLevel

        CALL @$ObjectArray_Redraw
        CALL @(PC)+; dstShowBossTextCommand: .word ShowBossText

        MOV  (PC)+, R0; srcShowTextUpdate: .word 0xFF
        CMP  R0,$22
        BHI  LevelLoop

        ASL  R0 
        JMP  @ShowTextJumpTable(R0)
    ShowTextJumpTable: #-----------------------------------------------------{{{
       .word ShowText0
       .word ShowText1
       .word ShowText2
       .word ShowText3
       .word ShowText4
       .word ShowText5
       .word ShowText6
       .word ShowText7
       .word ShowText8
       .word ShowText9
       .word ShowText10
       .word ShowText11
       .word ShowText12
       .word ShowText13
       .word ShowText14
       .word ShowText15
       .word ShowText16
       .word ShowText17
       .word ShowText18
       .word ShowText19
       .word ShowText20
       .word ShowText21
       .word ShowText22
    #------------------------------------------------------------------------}}}

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

    ShowText0:

    ShowText1:
        MOV  $Subtitles1,R5
        MOV  $5,R0
        BR   ResetText
    ShowText2:
    ShowText3:
    ShowText4:
    ShowText5:
    ShowText6:
    ShowText7:
    ShowText8:
    ShowText9:
    ShowText10:
    ShowText11:
    ShowText12:
    ShowText13:
    ShowText14:
    ShowText15:
    ShowText16:
    ShowText17:
    ShowText18:
    ShowText19:
    ShowText20:
    ShowText21:
    ShowText22:

    ResetText:                                              # ResetText:
        MOV  R5,@$srcOnscreenTextPointer                    #         ld(OnscreenTextPointer_Plus2-2),hl
                                                            #         ld (OnscreenTextPos_Plus1-1),a
                                                            #         ld a,1
                                                            #         ld (BossCharNum_Plus1-1),a
                                                            #         ld a,0
        MOV  $0xFF,@$srcShowTextUpdate                      #         ld(ShowTextUpdate_Plus1-1),a
                                                            #         ld a,15
                                                            #         ld (OnscreenTimer_Plus1-1),a
      #.wait_ppu
       #MOV  R5, @$PPUCommandArg; .word srcOnscreenTextPointer
       #MOV  $PPU_LoadText, @$PPUCommand
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

ShowBossText: # ../Aku/Level252-Intro.asm:1950
       CMP  (PC)+,(PC)+; srcOnscreenTimer:
      .word 15, 10
       BLO  1237$
       MOV  (PC)+,R1; srcOnscreenTextPointer: .word SubtitlesEmpty

    AnotheLineStart$:
       MOVB (R1)+,@$buffer
       MOVB (R1)+,@$buffer+1
       MOVB (R1)+,@$buffer+2
      .ppudo_ensure $PPU_PrintAt,$buffer

100$:  WAIT
       MOVB (R1)+,R0
       BZE  1237$
       CMPB R0,$0xFF
       BEQ  AnotheLineStart$

       MOVB R0,@$buffer+2
      .ppudo_ensure $PPU_Print,$buffer+2

       BR   100$

1237$: RETURN 

buffer: .byte 0,0,0,0

SubtitlesEmpty:
    .byte  4, 0; .ascii "     " ; .byte 0xFF
    .byte  4, 1; .ascii "     " ; .byte 0x00
    .even
Subtitles1:
                        #0         1         2         3         4
                        #01234567890123456789012345678901234567890
    .byte  8, 5; .ascii "Once Upon a time..."                ; .byte 0xFF
    .byte  5, 6; .ascii "In a land far far away..."          ; .byte 0xFF
    .byte  3, 7; .ascii "There was a girl who was kind"      ; .byte 0xFF
    .byte  1, 8; .ascii "to everyone and brought happiness"  ; .byte 0xFF
    .byte  4, 9; .ascii "everywhere She went \177 \177 \177" ; .byte 0x00
    .even

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
#----------------------------------------------------------------------------}}}
BlackPalette: #---------------------------------------------------------------{{{
    .byte 1       #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x0000  #
    .word 0x0000  #
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
BluePalette: #---------------------------------------------------------------{{{
    .byte 0       #--line number, last line of the top screen area
    .byte 0       #  0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10000 #  320 dots per line, pallete 0

    .byte 1       #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x1100  #
    .word 0x5511  #
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
DarkRealPalette: #-----------------------------------------------------------{{{
    .byte 0       #--line number, last line of the top screen area
    .byte 0       #  0 - set cursor/scale/palette
    .word 0b10000 #  graphical cursor
    .word 0b10000 #  320 dots per line, pallete 0

    .byte 1       #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xAA00  #
    .word 0xFFDD  #
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
RealPalette: #---------------------------------------------------------------{{{
    .byte 0       #--line number, last line of the top screen area
    .byte 0       #  0 - set cursor/scale/palette
    .word 0x10    #  graphical cursor, YRGB color
    .word 0b10111 #  320 dots per line, pallete 6
    .byte 01      #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xAA00  #
    .word 0xFFDD  #

    .byte 051     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xFF00  #
    .word 0xFFDD  #
    .byte 053     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xDD00  #
    .word 0xFFDD  #
    .byte 055     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x5500  #
    .word 0xFFDD  #
    .byte 057     #--line number, first line of the main screen area
    .byte 0       #  set colors
    .word 0x10    #
    .word 0b10000 #

    .byte 061     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xFF00  #
    .word 0xFFDD  #
    .byte 063     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xDD00  #
    .word 0xFFDD  #
    .byte 065     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x5500  #
    .word 0xFFDD  #
    .byte 067     #--line number, first line of the main screen area
    .byte 0       #  set colors
    .word 0x10    #
    .word 0b10000 #


    .byte 071     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xFF00  #
    .word 0xFFDD  #
    .byte 073     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xDD00  #
    .word 0xFFDD  #
    .byte 075     #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x5500  #
    .word 0xFFDD  #
    .byte 077     #--line number, first line of the main screen area
    .byte 0       #  set colors
    .word 0x10    #
    .word 0b10000 #


    .byte 0101    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xFF00  #
    .word 0xFFDD  #
    .byte 0103    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xDD00  #
    .word 0xFFDD  #
    .byte 0105    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x5500  #
    .word 0xFFDD  #
    .byte 0107    #--line number, first line of the main screen area
    .byte 0       #  set colors
    .word 0x10    #
    .word 0b10000 #


    .byte 0111    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xFF00  #
    .word 0xFFDD  #
    .byte 0113    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xDD00  #
    .word 0xFFDD  #
    .byte 0115    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0x5500  #
    .word 0xFFDD  #
    .byte 0117     #--line number, first line of the main screen area
    .byte 0       #  set colors
    .word 0x10    #
    .word 0b10000 #


    .byte 0121    #--line number, first line of the main screen area
    .byte 1       #  set colors
    .word 0xAA00  #
    .word 0xFFDD  #
 
    .byte 201     #--line number, 201 - end of the main screen params
    .even
#----------------------------------------------------------------------------}}}
# 9 br.     # A br.     # B br.     # C br.     # D br.     # E br.     # F white
# 1 blue    # 2 green   # 3 cyan    # 4 red     # 5 magenta # 6 yellow  # 7 gray

# for some reason GAS replaces the last byte with 0
# so we add dummy word to avoid data/code corruption
        .word 0xFFFF
end:
