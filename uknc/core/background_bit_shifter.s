#   This routine can 'bitshift' a 2x2 grid of pixels, it is useful for Quad and
# QuadSprite background routines, as these have no way of handling scrolling
# so code like this must scroll the data for them

      # R0 shift on timer ticks
      # R1 bytes per line
      # R2 lines
      # R5 pointer to next line of sprite, we will use -(R5) to read the line
BitShifter:
        BIT  @$Timer.TicksOccured,R0
        BZE  BitShifter_Skip
      # we will restore R1 before next LinesLoop cycle, without advancing SP!
        PUSH R1
        BitShifter_LinesLoop: # <---------------------------------------------+
            ASR  R1         #                                                 |
            CLR  R4         # remembers the overflow from the last word       |
            BitShifter_WordsLoop: # <--------------------------------------+  |
                MOV  -(R5),R0   # load next word of sprite line            |  |
                MOV  R0,R3      # store it for later                       |  |
                BIC  $0x0101,R0 # keep        XXXXXXX-                     |  |
                ROR  R0         # shift right -XXXXXXX                     |  |
                BIS  R4,R0      # add leftmost pixel from previous word    |  |
                MOV  R0,(R5)    # store shifted word                       |  |
                                #                                          |  |
                MOV  R3,R4      #                                          |  |
                BIC  $0xFEFE,R4 # keep rightmost pixel -------X            |  |
                ASH  $7,R4      # shift left x7        X-------            |  |
            SOB  R1,BitShifter_WordsLoop #---------------------------------+  |
            MOV  (SP),R1    # restore sprite width in bytes                   |
            ADD  R1,R5      #                                                 |
            BIS  R4,-2(R5)  #                                                 |
            ADD  R1,R5      # next line of the sprite                         |
        SOB  R2,BitShifter_LinesLoop #----------------------------------------+
        POP  R1 # we don't need the value anymore, advance SP
        RETURN

BitShifter_Skip:
        MUL  R2,R1
        ADD  R1,R5

        RETURN
