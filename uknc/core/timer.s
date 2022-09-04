#
# The Background also updates the Timer, if you use a custom background
# such as stage 9, you need to do this yourself or nothing will happen!
#
# output: R0 = smartbomb color or 0
Timer_UpdateTimer:
       .equiv Timer_Pause, .+2
        TST  $0x00
        BNZ  Timer_Paused

       .equiv Timer_CurrentTick, .+2
        MOV  $0x69,R0 # ResetCore sets it to 0x69 ../bootstrap.s:369
        MOV  R0,R1
        INC  R0
        MOV  R0,@$Timer_CurrentTick
        XOR  R1,R0
       .equiv Timer_TicksOccured, .+2
        MOV  R0,$0x00
       .equiv SmartBombTimer, .+2 # Make the background flash with the smartbomb
        MOV  $0x00,R0
        BNZ  Timer_SmartBombCountdown

        RETURN

Timer_SmartBombCountdown:
        DEC  R0 # Smartbomb timer down one
        MOV  R0,@$SmartBombTimer
        ASL  R0
        MOV  Background_SmartBombColors(R0),R0

        RETURN

Timer_Paused:
        CLR  R0
        MOV  R0,@$Timer_TicksOccured

        RETURN

# Timer_GetTimer:              ; Return current timer in I
#     ld a,(Timer_CurrentTick) ; and 'Ticks occured' Xor bitmap
#     ld i,a
#     ld a,0 :Timer_TicksOccured_Plus1
#     ret
