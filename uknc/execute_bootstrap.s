
ExecuteBootstrap:
       #PUSH R5

        CALL ScreenBuffer_Reset

        MOV  $BootstrapSizeDWords,R0
        MOV  $CBPADR,R1
        MOV  $CBP12D,R2
        MOV  $BootstrapStart,R3
        MOV  $0x8000,(R1)

  100$:.rept 2
        MOV  (R2),(R3)+
        INC  (R1)
       .endr
        SOB  R0,100$

       #POP  R5

        JMP  @$Bootstrap_FromR5


