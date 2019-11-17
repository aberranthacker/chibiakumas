
PPEXEC:         #------------------------------------------------------------{{{
        MOV  2(R5),@$PS.A2      # Arg 2 - memory size, words
        MOVB $01,  @$PS.Request # 01 - allocate memory
        CALL PPUOut             # => Send request to PPU
        BNE  MAError            # If error, --> Memory allocation error
        # CALL Info               #
        CMP  @$PS.A1, $PPU_UserRamStart # check if allocated area begins where we wanted
        BNE  MAError
                                # PS.A1 contains address of allocated area
        MOV  (R5)+,@$PS.A2      # Arg 2 - addr of mem block in CPUs RAM
        MOV  (R5)+,@$PS.A3      # Arg 3 - size of mem block, words
        MOVB $020, @$PS.Request # 020 - CPU to PPU memory copy
        CALL PPUOut             # => Send request to PPU
        BNE  MCpError           # If error, --> Memory copy error
        # CALL Info             #
                                #
        MOVB $030,@$PS.Request  # 030 - Execute programm
        CALL PPUOut             # => Send request to PPU
        BNE  ExError            # IF error, --> Execution error
        RTS  R5
#----------------------------------------------------------------------------}}}
PPFREE:         #------------------------------------------------------------{{{
        MOV  (R5)+,@$PS.A1      # Arg 1 - address of memory block
        MOV  (R5)+,@$PS.A2      # Arg 2 - size of the memory block, words
        MOVB $02,  @$PS.Request # 02 - free memory
        CALL PPUOut             # => Send request to PPU
        BNE  MFrError           # If error, --> Memory freeing error
        RTS  R5
#----------------------------------------------------------------------------}}}
# Error messages ------------------------------------------------------------{{{
MAError:
        .cout $sMAError
        CALL Info
        JMP  Finish
MCpError:
        .cout $sMCpError
        CALL Info
        JMP  Finish
ExError:
        .cout $sExError
        CALL Info
        JMP  Finish
MFrError:
        .cout $sMFrError
        CALL Info
        JMP  Finish

sMAError:  .ASCIZ  "?PPU-F-memory allocation error"
sMCpError: .ASCIZ  "?PPU-F-memory copy error"
sExError:  .ASCIZ  "?PPU-F-execution error"
sMFrError: .ASCIZ  "?PPU-F-memory freeing error"

        .Even
#----------------------------------------------------------------------------}}}
PPUOut:         #------------------------------------------------------------{{{
        MOV  $AMP,R0        # R0 - pointer to channel's init sequence array
        MOV  $8,R1          # R1 - size of the array, 8 bytes
1$:     MOVB (R0)+,@$CCH2OD # Send a byte to channel 2

2$:     TSTB @$CCH2OS       #
        BPL  2$             # Wait until channel is ready

        SOB  R1,1$          # Next byte

        TSTB PS.Reply       # Test PPU's operation status code
        RETURN              #

AMP:    .byte  0, 0, 0, 0xFF # init sequence
        .word  PStruct       # address of parameters struct
        .byte  0xFF, 0xFF    # two termination bytes 0xff, 0xff

PStruct:    # Parameters struct (PS)
    PS.Reply:   .byte  0   # operation status code
    PS.Request: .byte  1   # request code
                           # 01 - allocate memory
                           # 02 - free memory
                           # 010 - mem copy PPU -> CPU
                           # 020 - mem copy CPU -> PPU
                           # 030 - execute
    PS.Type:    .byte  032 # device type - PPU RAM
    PS.No:      .byte  0   # device number
    PS.A1:      .word  0   # Argument 1
    PS.A2:      .word  0   # Argument 2
    PS.A3:      .word  0   # Argument 3

        .Even
#----------------------------------------------------------------------------}}}
Info:           #------------------------------------------------------------{{{
        MOV  $Arg1+7, R1
        MOV  @$PS.A1,R3
        CALL InsDecStr
        .cout $Arg1
        MOV  $Arg2+7, R1
        MOV  @$PS.A2,R3
        CALL InsDecStr
        .cout $Arg2
        MOV  $Arg3+7, R1
        MOV  @$PS.A3,R3
        CALL InsDecStr
        .cout $Arg3
        RETURN
                #0         1         2         3         4         5         6         7
                #01234567890123456789012345678901234567890123456789012345678901234567890123456789
Arg1:   .ASCIZ  "PS.A1: 123456"
Arg2:   .ASCIZ  "PS.A2: 123456"
Arg3:   .ASCIZ  "PS.A3: 123456"
        .Even
#----------------------------------------------------------------------------}}}
InsDecStr:      #------------------------------------------------------------{{{
        MOV  $6,R0      # R0 - length of the number
                        # R1 - position of number in str (first argument)
                        # R3 - number (second argument)
        ADD  R0,R1
1$:     CLR  R2         # R2 - most, R3 - least significant word
            DIV  $10,R2
                        # R2 contains quotient, R3 - remainder
            ADD  $'0,R3 # add ASCII code for "0" to the remainder
            MOVB R3,-(R1)
            MOV  R2,R3
        SOB  R0,1$
        RETURN
#----------------------------------------------------------------------------}}}
