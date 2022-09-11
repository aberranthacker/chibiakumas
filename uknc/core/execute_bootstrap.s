
ExecuteBootstrap:
        CALL ScreenBuffer_Reset

ExecuteBootstrap_NoCLS:
        MOV  $BootstrapSizeQWords,R0
        MOV  $CBPADR,R1
        MOV  $CBP12D,R2
        MOV  $BootstrapStart,R3
        MOV  $BootstrapCopyAddr,(R1)

        100$:
           .rept 4
            MOV  (R2),(R3)+
            INC  (R1)
           .endr
        SOB  R0,100$

        JMP  @$Bootstrap_FromR5
