               .list

               .TITLE Chibi Akumas Bootsector

               .include "./hwdefs.s"
               .include "./macros.s"
               .include "./core_defs.s"

       .=0
        NOP  # Bootable disk marker
        BR   68$

       .=040
        RTI                 # dummy interrupt handler
       .=0104
68$:    MOV  $040,@$0100    # set dummy Vblank int handler
        MOV  $SPReset,SP

        BIC  $0x0080, @$CCH1OS # disable channel 1 output interrupt
        BIC  $0x0080, @$CCH2OS # disable channel 2 output interrupt

        MOV  $TitleStr,R0
        CALL @$PrintStr

load_bootstrap:
        MOV  $ParamsAddr,R0 # R0 - pointer to channel's init sequence array
        MOV  $8,R1          # R1 - size of the array, 8 bytes
10$:    MOVB (R0)+,@$CCH2OD # Send a byte to the channel 2

20$:    TSTB @$CCH2OS       #
        BPL  20$            # Wait until the channel is ready

        SOB  R1,10$         # Next byte

30$:    TSTB @$PS.Reply
        BMI  30$
        BNE  PrintErrorCode

        JMP  @$BootstrapStart

PrintErrorCode:
        CLR  R3
        BISB @$PS.Reply,R3

        MOV  $4,R0
        MOV  $ErrorCode,R1
        ADD  R0,R1

10$:    CLR  R2      # R2 - most, R3 - least significant word
        DIV  $010,R2 # quotient -> R2 , remainder -> R3
        ADD  $'0, R3 # add ASCII code for "0" to the remainder
        MOVB R3,-(R1)
        MOV  R2,R3
        SOB  R0,10$

        MOV  $ErrorCode,R0
        CALL @$PrintStr
        BR  .
ErrorCode:   .asciz "1234"
       .even

PrintStr:
10$:    MOVB (R0)+,R1
        BZE  1237$

20$:    BIT  $0x80, @$TTYOST
        BZE  20$

        MOV  R1, @$TTYODT
        BR   10$

1237$:  RETURN

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
      #.byte  033,0240,'2  # character color
      #.byte  033,0241,'7  # character background color
      #.byte  033,0242,'7  # screen background color
      #.byte  033,0247,'0  # cursor color
      #.byte  014          # clear screen

       .byte  033,'Y, 32+1,32+0
       .ascii "ChibiAkumas  V1.666"

       .byte  033,'H # move curor to "home" position
       .byte  0
#----------------------------------------------------------------------------}}}
       .=0x200
               .nolist
