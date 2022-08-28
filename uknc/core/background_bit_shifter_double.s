#   This routine can 'bitshift' a 2x2 grid of pixels, it is useful for Quad and
# QuadSprite background routines, as these have no way of handling scrolling
# so code like this must scroll the data for them

      # R0 shift on timer ticks
      # R1 bytes per line
      # R2 lines
      # R5 pointer to next line of sprite, we will use -(R5) to read the line
BitShifterDouble:
        BIT  @$Timer_TicksOccured,R0
        BZE  BitShifterDouble_Skip
      # we will restore R1 before next LinesLoop cycle, without advancing SP!
        PUSH R1
        BitShifterDouble_LinesLoop: # <---------------------------------------+
            ASR  R1         #                                                 |
            CLR  R4         # remembers the overflow from the last word       |
            BitShifterDouble_WordsLoop: # <--------------------------------+  |
                MOV  -(R5),R0   # load next word of sprite line            |  |
                MOV  R0,R3      # store it for later                       |  |
                BIC  $0x0303,R0 # clear 2px on right XXXXXX--              |  |
                ROR  R0         #                                          |  |
                ROR  R0         # shift right x2     --XXXXXX              |  |
                BIS  R4,R0      # add 2 leftmost pixels from previous word |  |
                MOV  R0,(R5)    # store shifted word                       |  |
                                #                                          |  |
                MOV  R3,R4      #                                          |  |
                BIC  $0xFCFC,R4 # clear 6px on left  ------XX              |  |
                ASH  $6,R4      # shift left x6      XX------              |  |
            SOB  R1,BitShifterDouble_WordsLoop #---------------------------+  |
            MOV  (SP),R1    # restore sprite width in bytes                   |
            ADD  R1,R5      #                                                 |
            BIS  R4,-2(R5)  #                                                 |
            ADD  R1,R5      # next line of the sprite                         |
        SOB  R2,BitShifterDouble_LinesLoop #----------------------------------+
        POP  R1 # we don't need the value anymore, advance SP
        RETURN

BitShifterDouble_Skip:
        MUL  R2,R1
        ADD  R1,R5

        RETURN
