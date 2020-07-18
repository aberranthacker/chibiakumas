    MOV  $srcAddr, R1   # start address of RLE block
    MOV  $dstAddr, R2   # destination start address

1$: MOVB (R1)+, R0
    BZE  1237$          # 0 => decoding finished
    MOV  R0, R3         # prepare counter
    BIC  $0xFFE0, R3    # only lower 5 bits are significant

    TSTB R0             # 1-byte command?
    BPL  $2             # yes => jump
    SWAB R3             # move lower byte to high byte
    BISB (R1)+, R3      # set lower byte of counter
2$: CLR  R4             # clear filler
    BICB $0x9F, R0
    BZE  3$             # zero pattern? => jump

    MOV  $0xFF, R4      #
    CMPB R0, $0x60      # 0xFF pattern?
    BEQ  3$             # yes => jump

    CMPB R0, $0x20      # given pattern?
    BNE  4$             # no => jump

    MOVB (R1)+, R4      # read the given pattern
3$: MOVB R4, (R2)+      # loop: write pattern to destination
    SOB  R3, 3$         #
    BR   1$

4$: MOVB (R1)+, (R2)+   # loop: copy bytes to destination
    SOB  R3, 4$
    BR   1$

1237$:

    RETURN

