; vim: set fileformat=dos filetype=asmpdp11 tabstop=8 expandtab shiftwidth=4 autoindent :

PPEXEC:         ;------------------------------------------------------------{{{
        PUSH    R1,R2,R3
            MOV     2(R5),PS.A2     ;Arg 2 - memory size, words
            MOVB    #1,PS.Request   ;01 - allocate memory
            CALL    PPUOut          ;=> Send request to PPU
            BNE     MAError         ;If error, --> Memory allocation error
            CALL    Info            ;
            MOV     @#PS.A1,PPUMBeg ;Arg 1 - addr of mem block in PPUs RAM
                                    ;        set by malloc command
            MOV     (R5)+,PS.A2     ;Arg 2 - addr of mem block in CPUs RAM
            MOV     (R5)+,PS.A3     ;Arg 3 - size of mem block, words
            MOVB    #20,PS.Request  ;020 - CPU to PPU memory copy
            CALL    PPUOut          ;=> Send request to PPU
            BNE     MCpError        ;If error, --> Memory copy error
            CALL    Info            ;
                                    ;
            MOVB    #30,PS.Request  ;030 - Execute programm
            CALL    PPUOut          ;=> Send request to PPU
            BNE     ExError         ;IF error, --> Execution error
        POP     R3,R2,R1
        RTS     R5              ;
;----------------------------------------------------------------------------}}}
PPFREE:         ;------------------------------------------------------------{{{
        PUSH    R1,R2,R3
            MOV     (R5)+,PS.A1     ;Arg 1 - address of memory block
            MOV     (R5)+,PS.A2     ;Arg 2 - size of the memory block, words
            MOVB    #2,PS.Request   ;02 - free memory
            CALL    PPUOut          ;=> Send request to PPU
            BNE     MFrError        ;If error, --> Memory freeing error
        POP     R3,R2,R1
        RTS     R5
;----------------------------------------------------------------------------}}}
                ;Error messages ---------------------------------------------{{{
MAError:
        .Print  #sMAError
        CALL    Info
        JMP     Finish
MCpError:
        .Print  #sMCpError
        CALL    Info
        JMP     Finish
ExError:
        .Print  #sExError
        CALL    Info
        JMP     Finish
MFrError:
        .Print  #sMFrError
        CALL    Info
        JMP     Finish

sMAError:       .ASCIZ  "?PPU-F-memory allocation error"
sMCpError:      .ASCIZ  "?PPU-F-memory copy error"
sExError:       .ASCIZ  "?PPU-F-execution error"
sMFrError:      .ASCIZ  "?PPU-F-memory freeing error"
                .Even
;----------------------------------------------------------------------------}}}
PPUOut:         ;------------------------------------------------------------{{{
        MOV     #AMP,R0         ;R0 - pointer to channel's init sequence array
        MOV     #8.,R1          ;R1 - size of the array, 8 bytes
1$:     MOVB    (R0)+,@#CCH2OD  ;Send a byte to channel 2
2$:         TSTB    @#CCH2OS    ;
            BPL     2$          ;Wait until channel is ready
        SOB     R1,1$           ;Next byte

        TSTB    PS.Reply        ;Test PPU's operation status code
        RETURN                  ;

AMP:            .Byte   0, 0, 0, 377    ;init sequence
                .Word   PStruct         ;address of parameters struct
                .Byte   377, 377        ;two termination bytes 0xff, 0xff
PStruct:        ;Parameters struct
PS.Reply:       .Byte   0       ;operation status code
PS.Request:     .Byte   1       ;01 - allocate memory
                                ;02 - free memory
                                ;10 - mem copy PPU -> CPU
                                ;20 - mem copy CPU -> PPU
                                ;30 - execute
PS.Type:        .Byte   32      ;device type - PPUs RAM
PS.No:          .Byte   0       ;device number
PS.A1:          .Word   0       ;Argument 1
PS.A2:          .Word   0       ;Argument 2
PS.A3:          .Word   0       ;Argument 3
                .Even
;----------------------------------------------------------------------------}}}
Info:           ;------------------------------------------------------------{{{
        MOV     #<Arg1+7>,R1
        MOV     @#PS.A1,R3
        CALL    InsDecStr
        .Print  #Arg1
        MOV     #<Arg2+7>,R1
        MOV     @#PS.A2,R3
        CALL    InsDecStr
        .Print  #Arg2
        MOV     #<Arg3+7>,R1
        MOV     @#PS.A3,R3
        CALL    InsDecStr
        .Print  #Arg3
        RETURN
                ;0         1         2         3         4         5         6         7
                ;01234567890123456789012345678901234567890123456789012345678901234567890123456789
Arg1:   .ASCIZ  "PS.A1: 123456"
Arg2:   .ASCIZ  "PS.A2: 123456"
Arg3:   .ASCIZ  "PS.A3: 123456"
        .Even
;----------------------------------------------------------------------------}}}
InsDecStr:      ;------------------------------------------------------------{{{
        MOV     #6,R0     ;R0 - length of the number
                          ;R1 - position of number in str (first argument)
                          ;R3 - number (second argument)
        ADD R0,R1
1$:     CLR R2            ;R2 - most, R3 - least significant word
            DIV  #10.,R2
                          ;R2 contains quotient, R3 - remainder
            ADD  #'0,R3   ;add ASCII code for "0" to the remainder
            MOVB R3,-(R1)
            MOV  R2,R3
        SOB R0,1$
        RETURN
;----------------------------------------------------------------------------}}}
