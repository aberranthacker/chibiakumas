
ExecuteBootstrap:
       .ppudo_ensure $PPU_MusicStop
       .ppudo_ensure $PPU_LevelEnd
        CALL ScreenBuffer_Reset

        MOV  $BootstrapSizeDWords,R0
        MOV  $CBPADR,R1
        MOV  $CBP12D,R2
        MOV  $BootstrapStart,R3
        MOV  $BootstrapCopyAddr,(R1)

        100$:
           .rept 2
            MOV  (R2),(R3)+
            INC  (R1)
           .endr
        SOB  R0,100$

        JMP  @$Bootstrap_FromR5
