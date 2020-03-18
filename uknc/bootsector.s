               .nolist

               .TITLE Chibi Akumas bootsector

# CPU/PPU USER mode interrup vectors and priorities -------------------------{{{
# vect prty Source
#   04   1 input/output RPLY timeout
#   04   2 illegal addressing mode
#  010   2 unknown instruction/HALT mode command in USER mode
#  014   3 T-bit
#  014   - BPT instruction
#  020   - IOT instruction
#  024   4 ACLO
#  030   - EMT  instruction
#  034   - TRAP instruction
#  060     TTY out (channel 0 out)
#  064     TTY in (channel 0 in)
# 0100   6 EVNT (Vsync)
# 0370     serial (C2)
# 0374     serial (C2)
# 0380     serial (LAN)
# 0384     serial (LAN)
# 0460     channel 1 out
# 0464     channel 1 in
# 0464     channel 2 in
#----------------------------------------------------------------------------}}}
               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"

       .=0
        NOP # Bootable disk marker
        BR   32$
       .=040
32$:
        MOV  $0157776,SP

        MOV  $TitleStr,R0
        CALL PrintStr
load_bootstrap:
        MOV  $ParamsAddr,R0 # R0 - pointer to channel's init sequence array
        MOV  $8,R1          # R1 - size of the array, 8 bytes
1$:     MOVB (R0)+,@$CCH2OD # Send a byte to channel 2

2$:     TSTB @$CCH2OS       #
        BPL  2$             # Wait until channel is ready

        SOB  R1,1$          # Next byte

3$:     TSTB @$PS.Reply
        BMI  3$
        BNE  PrintErrorCode

        JMP  BootstrapStart

PrintErrorCode:
        CLR  R3
        BISB @$PS.Reply,R3

        MOV  $4,R0
        MOV  $ErrorCode,R1
        ADD  R0,R1

1$:     CLR  R2      # R2 - most, R3 - least significant word
        DIV  $010,R2 # quotient -> R2 , remainder -> R3
        ADD  $'0, R3 # add ASCII code for "0" to the remainder
        MOVB R3,-(R1)
        MOV  R2,R3
        SOB  R0,1$

        MOV  $ErrorCode,R0
        CALL PrintStr
        BR  .
ErrorCode:   .asciz "1234"
       .even

PrintStr:
1$:     BIT  $0x80, @$TTYOS
        BEQ  1$
        MOVB (R0)+,R1
        BEQ  2$
        MOVB R1, @$TTYOD
        BR   1$
2$:     RETURN

ParamsAddr: .byte  0, 0, 0, 0xFF # init sequence (just in case)
            .word  ParamsStruct
            .byte  0xFF, 0xFF    # two termination bytes 0xff, 0xff

ParamsStruct:
    PS.Reply:           .byte  -1   # operation status code
    PS.Command:         .byte  010  # read data from disk
    PS.DeviceType:      .byte  02        # double sided disk
    PS.DeviceNumber:    .byte  0x00 | 0  # bit 7: side(0-bottom, 1-top) ∨ drive number(0-3)
    PS.AddressOnDevice: .byte  0,2       # track 0(0-79), sector 2(1-10)
    PS.CPU_RAM_Address: .word  BootstrapStart
    PS.WordsCount:      .word  BootstrapSizeWords # number of words to transfer

TitleStr:    #---------------------------------------------------------------{{{
        .byte  033,0240,'1  # character color
        .byte  033,0241,'0  # character background color
        .byte  033,0242,'0  # screen background color
        .byte  033,0247,'0  # cursor color
        .byte  014          # clear screen

        .byte  033,'Y, 32+ 9,32+20
        .ascii "*****************************************"

        .byte  033,'Y, 32+10,32+20
        .ascii "*"
        .byte  033,0240,'5; .ascii "          ChibiAkumas  V1.666          "
        .byte  033,0240,'1; .ascii "*"

        .byte  033,'Y, 32+11,32+20
        .ascii "*"
        .byte  033,0240,'4; .ascii "          www.chibiakumas.com          "
        .byte  033,0240,'1; .ascii "*"

        .byte  033,'Y, 32+12,32+20
        .ascii "*"
        .byte  033,0240,'3; .ascii "    UKNC version"
        .byte  033,0240,'7; .ascii " by "
        .byte  033,0240,'2; .ascii "aberrant_hacker    "
        .byte  033,0240,'1; .ascii "*"

        .byte  033,'Y, 32+13,32+20
        .ascii "*"
        .byte  033,0240,'6; .ascii " github.com"
        .byte  033,0240,'7; .ascii "/"
        .byte  033,0240,'2; .ascii "aberranthacker"
        .byte  033,0240,'7; .ascii "/"
        .byte  033,0240,'5; .ascii "chibiakumas "
        .byte  033,0240,'1; .ascii "*"

        .byte  033,'Y, 32+14,32+20
        .ascii "*****************************************"
        .byte  033,'H
        .byte  033,0240,'7
        .byte  0
#----------------------------------------------------------------------------}}}
        .list # end of the bootsector
        .=0x200
