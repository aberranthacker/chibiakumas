#
# The Background also updates the Timer, if you use a custom background
# such as stage 9, you need to do this yourself or nothing will happen!
#
# output: R0 = smartbomb color or 0
Timer.UpdateTimer:
       .equiv Timer.Pause, .+2
        TST  $0x00
        BNZ  Timer.Paused

       .equiv Timer.CurrentTick, .+2
        MOV  $0x69,R0 # ResetCore sets it to 0x69 ../bootstrap.s:369
        MOV  R0,R1
        INC  R0
        MOV  R0,@$Timer.CurrentTick
        XOR  R1,R0
       .equiv Timer.TicksOccured, .+2
        MOV  R0,$0x00
       .equiv Timer.SmartBombTimer, .+2 # Make the background flash with the smartbomb
        MOV  $0x00,R0
        BNZ  Timer.SmartBombCountdown

        RETURN

Timer.SmartBombCountdown:
        DEC  R0 # Smartbomb timer down one
        MOV  R0,@$Timer.SmartBombTimer
        ASL  R0
        MOV  Background_SmartBombColors(R0),R0

        RETURN

Timer.Paused:
        CLR  R0
        MOV  R0,@$Timer.TicksOccured

        RETURN

# Timer.GetTimer:              ; Return current timer in I
#     ld a,(Timer.CurrentTick) ; and 'Ticks occured' Xor bitmap
#     ld i,a
#     ld a,0 :Timer.TicksOccured_Plus1
#     ret
