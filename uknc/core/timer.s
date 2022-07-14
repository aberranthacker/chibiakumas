#
# Timer_CurrentTick equ Timer_CurrentTick_Plus1-1
#
Timer_SetCurrentTick:                                       # Timer_SetCurrentTick:
        MOV  R0,@$Timer_CurrentTick                         #     ld (Timer_CurrentTick_Plus1-1),a
        RETURN                                              # ret

# The Background also updates the Timer, if you use a custom background
# such as stage 9, you need to do this yourself or nothing will happen!
        # output: R0 = smartbomb color or 0
        #         R3 = pointer to Timer_TicksOccured
Timer_UpdateTimer:                                     #
        MOV  $Timer_TicksOccured,R3                    # ld hl,Timer_TicksOccured
       .equiv Timer_Pause, .+2
        TST  $0x00                                     # ld a,0 :Timer_Pause_Plus1
        BZE  NotPaused                                 # jr z,NotPaused

        CLR  R0                                        # xor a
        MOV  R0,(R3) # R3 points to Timer_TicksOccured # ld (hl),a

        RETURN                                              # ret

    NotPaused:                                              # NotPaused:
       .equiv Timer_CurrentTick, .+2                        #     ld a,&69 :Timer_CurrentTick_Plus1
        MOV  $0x69,R0 # ResetCore sets it to 0x69 ../bootstrap.s:369
        MOV  R0,R1                                          #     ld b,a
        INC  R0                                             #     inc a
        MOV  R0,@$Timer_CurrentTick                         #     ld (Timer_CurrentTick),a
        XOR  R1,R0                                          #     xor b
        MOV  R0,(R3) # R3 points to Timer_TicksOccured      #     ld (hl),a
       .equiv SmartBombTimer, .+2 # Make the background flash with the smartbomb
        MOV  $0x00,R0                                       #     ld a,0 :SmartBomb_Plus1
        BNZ  SmartBombCountdown$                            #     or a

        RETURN                                              #     ret z

SmartBombCountdown$:
        DEC  R0                                             #     dec a ; Smartbomb timer down one
        MOV  R0,@$SmartBombTimer                            #     ld (SmartBomb_Plus1-1),a
        ASL  R0                                             #
        MOV  Background_SmartBombColors(R0),R0              #     push af
        RETURN                                              #     push hl
                                                            #     ld hl,Background_SmartBombColors    ; must be aligned
                                                            #         add l
                                                            #         ld l,a
                                                            #         ld d,(hl)
                                                            #     pop hl
                                                            #     pop af
                                                            # ret
                                                            #
Timer_GetTimer: # Return current timer in I
       #MOV  @$Timer_CurrentTick,R0   # ld a,(Timer_CurrentTick) ; and 'Ticks occured' Xor bitmap
                                      # ld i,a
                                      # ld a, 0 :Timer_TicksOccured_Plus1
       .equiv Timer_TicksOccured, .+2
        MOV  $0x00,R0 # bootstrap's ResetCore resets the value to 0x00

        RETURN                           # ret
