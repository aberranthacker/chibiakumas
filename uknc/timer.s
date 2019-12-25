                                                            #
                                                            # Timer_CurrentTick equ Timer_CurrentTick_Plus1-1
                                                            #
Timer_SetCurrentTick:                                       # Timer_SetCurrentTick:
        MOV  R0,@$srcTimer_CurrentTick                      #     ld (Timer_CurrentTick_Plus1-1),a
RETURN                                                      # ret
                                                            #
# The Background also updates the Timer, if you use a custom background
# such as stage 9, you need to do this yourself or nothing will happen!
Timer_UpdateTimer:                                          # Timer_UpdateTimer:
        MOV  $srcTimer_TicksOccured,R3                      #     ld hl,Timer_TicksOccured
                                                            #
        TST  $0x00; Timer_Pause_Plus2:                      #     ld a,0 :Timer_Pause_Plus1
       .equiv srcTimer_Pause, Timer_Pause_Plus2 - 2         #     or a
        BEQ  NotPaused                                      #     jr z,NotPaused
                                                            #
        CLR  R0                                             #     xor a
        MOV  R0,(R3) # R3 == srcTimer_TicksOccured          #     ld (hl),a
RETURN                                                      # ret
                                                            #
NotPaused:                                                  # NotPaused:
        MOV  $0x69,R0; Timer_CurrentTick_Plus2: # bootstrap reset the value
       .equiv  srcTimer_CurrentTick, Timer_CurrentTick_Plus2 - 2
       .global srcTimer_CurrentTick                         #     ld a,&69 :Timer_CurrentTick_Plus1
        MOV  R0,R1                                          #     ld b,a
        INC  R0                                             #     inc a
        MOV  R0,@$srcTimer_CurrentTick                      #     ld (Timer_CurrentTick),a
        XOR  R1,R0                                          #     xor b
        MOV  R0,(R3) # R3 == srcTimer_TicksOccured          #     ld (hl),a
                                                            #
        MOV  $0x00,R0; SmartBomb_Plus2:                     #     ld a,0 :SmartBomb_Plus1 ; Make the background flash with the smartbomb
       .equiv srcSmartBomb, SmartBomb_Plus2 - 2 
        BNE  SmartBombCountdown$                            #     or a
RETURN                                                      #     ret z
SmartBombCountdown$:
        DEC  R0                                             #     dec a                   ; Smartbomb timer down one
        MOV  R0,@$srcSmartBomb                              #     ld (SmartBomb_Plus1-1),a
                                                            #
                                                            #     push af
                                                            #     push hl
                                                            #     ld hl,Background_SmartBombColors    ; must be aligned
                                                            #         add l
                                                            #         ld l,a
                                                            #         ld d,(hl)
                                                            #     pop hl
                                                            #     pop af
                                                            # ret
                                                            #
                                                            # Timer_GetTimer:              ; Return current timer in I
                                                            #     ld a,(Timer_CurrentTick) ; and 'Ticks occured' Xor bitmap
                                                            #     ld i,a
                                                            #
        MOV  $0x00,R0; Timer_TicksOccured_Plus2:            #     ld a, 0 :Timer_TicksOccured_Plus1
       .equiv  srcTimer_TicksOccured, Timer_TicksOccured_Plus2 - 2
       .global srcTimer_TicksOccured
                                                            # ret
