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
    .word     evtSetAnimator | anmNone # 3
    .word     evtAddToBackground      # 4
    .word     evtSaveObjSettings | 0           # 5

    .word 0 # time
    .word evtMultipleCommands | 5
    .word     evtSetProgMoveLife               # 1
    .word         prgBitShift
    .word         mveBackground | 0x10
    .word         lifeImmortal
    .word     evtSetObjectSize | 0             # 2
    .word     evtSetAnimator | anmNone         # 3
    .word     evtAddToBackground      # 4
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
    .byte         24+80-16 ,24+80+6 # Y, X
    .word     evtSaveLstObjToAdd               # 4
    .word         charnikohime
    .word     evtAddToBackground               # 5


LevelInit:
        # TODO: Load artifact of Level252-Intro_Screens1.asm
        # TODO: call Akuyou_Music_Restart when implemented
        MOV  $EventStreamArray,R5
        MOV  $Event_SavedSettings,R3
        CALL @$Event_StreamInit
        # TODO: call Akuyou_Music_Restart when implemented
        CALL @$ScreenBuffer_Reset

LevelLoop:
        CALL @(PC)+; dstClearScreenPoint: .word null # Clear4000

    .ifdef Debug_ShowLevelTime
        CALL @$ShowLevelTime
    .endif

        CALL @(PC)+; dstFadeCommand: .word null

        MTPS $PR0
        CALL @$Timer_UpdateTimer
        WAIT
        CALL @$EventStream_Process
        CALL @(PC)+; dstDoubleStreamProcess: .word null
        WAIT

        BITB @$KeyboardScanner_P1,$Keymap_AnyFire
        BNZ  EndLevelFire

        CALL @$ObjectArray_Redraw

       #CALL @(PC)+; dstShowBossTextCommand: .word ShowBossText

        JMP  @$LevelLoop

charnikohime: .word 0
Clear4000: #-----------------------------------------------------------------{{{
        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R2,-(SP)

        MOV  $8000>>4,R0
        CLR  R1
        MOV  $ScreenBuffer_ActiveScreen,R2
    10$:
       .rept 1<<4
        MOV  R1,(R2)+
       .endr
        SOB  R0,10$

        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0

        RETURN
#----------------------------------------------------------------------------}}}
EndLevelFire: #--------------------------------------------------------------{{{
        MOV  $8000,R5
        CALL @$ExecuteBootstrap
#----------------------------------------------------------------------------}}}

# for some reason GAS replaces the last byte with 0
# so we add dummy word to avoid data/code corruption
        .word 0xFFFF
end:
