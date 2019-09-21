    call Background_Draw    :Background_Call_Plus2

    call Akuyou_EventStream_Process
    call Akuyou_ObjectArray_Redraw

    call Akuyou_Player_Handler
    call AkuYou_Player_StarArray_Redraw

    call Akuyou_StarArray_Redraw

    call Akuyou_PlaySfx

ifdef Debug_ShowLevelTime
    call ShowLevelTime
endif

    call null   :FadeCommand_Plus2  ; also MSX
