                                                            #
                                                            # Timer_CurrentTick equ Timer_CurrentTick_Plus1-1
                                                            #
Timer_SetCurrentTick:                                       # Timer_SetCurrentTick:
        MOV  R0,@$srcTimer_CurrentTick                      #     ld (Timer_CurrentTick_Plus1-1),a
        RETURN                                              # ret
                                                            #
# The Background also updates the Timer, if you use a custom background
# such as stage 9, you need to do this yourself or nothing will happen!
Timer_UpdateTimer:                                          # Timer_UpdateTimer:
        MOV  $srcTimer_TicksOccured,R3                      #     ld hl,Timer_TicksOccured
       .equiv srcTimer_Pause, .+2
        TST  $0x00                                          #     ld a,0 :Timer_Pause_Plus1
        BZE  NotPaused                                      #     jr z,NotPaused
                                                            #
        CLR  R0                                             #     xor a
        MOV  R0,(R3) # R3 points to srcTimer_TicksOccured   #     ld (hl),a

        RETURN                                              # ret

NotPaused:                                                  # NotPaused:
       .equiv srcTimer_CurrentTick, .+2                     #     ld a,&69 :Timer_CurrentTick_Plus1
        MOV  $0x69,R0 # bootstrap's ResetCore resets the value to 0x69

        MOV  R0,R1                                          #     ld b,a
        INC  R0                                             #     inc a
        MOV  R0,@$srcTimer_CurrentTick                      #     ld (Timer_CurrentTick),a
        XOR  R1,R0                                          #     xor b
        MOV  R0,(R3) # R3 points to srcTimer_TicksOccured   #     ld (hl),a
       .equiv srcSmartBomb, .+2 # Make the background flash with the smartbomb
        MOV  $0x00,R0                                       #     ld a,0 :SmartBomb_Plus1 
        BNZ  SmartBombCountdown$                            #     or a

        RETURN                                              #     ret z

SmartBombCountdown$:
       .inform_and_hang "no SmartBombCountdown"
        DEC  R0                                             #     dec a ; Smartbomb timer down one
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
Timer_GetTimer: # Return current timer in I
        MOV  @$srcTimer_CurrentTick,R0   # ld a,(Timer_CurrentTick) ; and 'Ticks occured' Xor bitmap
                                         # ld i,a
                                         # ld a, 0 :Timer_TicksOccured_Plus1
       .equiv srcTimer_TicksOccured, .+2
        MOV  $0x00,R0 # bootstrap's ResetCore resets the value to 0x00

        RETURN                           # ret
                                        
