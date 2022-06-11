#   This routine can 'bitshift' a 2x2 grid of pixels, it is useful for Quad and
# QuadSprite background routines, as these have no way of handling scrolling
# so code like this must scroll the data for them

        # R0 shift on timer ticks
        # R1 bytes
        # R2 lines
        # R5 pointer to next line of sprite
BitShifter:
       .equiv srcBitShifter_TicksOccured, .+2
        BIT  $0x00,R0
        BZE  BitShifter_Skip

BitShifter_LinesLoop:   # <----------------------------------------------------+
        PUSH R1         #                                                      |
        ASR  R1         #                                                      |
        CLC             #                                                      |
        CLR  R4         # remembers the overflow from the last word            |
        PUSH R5         #                                                      |

BitShifter_WordsLoop:   # <-------------------------------------------------+  |
        MOV  -(R5),R0   # load next word of sprite line                     |  |
        MOV  R0,R3      # store it for later                                |  |

        BIC  $0x0101,R0 # keep        XXXXXXX-                              |  |
        ROR  R0         # shift right -XXXXXXX                              |  |
        BIS  R4,R0      # add leftmost pixel from previous word             |  |
        MOV  R0,(R5)    # store shifted word                                |  |

        BIC  $0xFEFE,R3 # keep rightmost pixel -------X                     |  |
        ASH  $7,R3      # shift left x7        X-------                     |  |
        MOV  R3,R4      # store leftmost pixel for next word                |  |

        SOB  R1,BitShifter_WordsLoop #--------------------------------------+  |

        POP  R5         #                                                      |
        BIS  R4,-(R5)   #                                                      |
        INC  R5         #                                                      |
        INC  R5         #                                                      |

        POP  R1         # restore sprite width in bytes                        |
        ADD  R1,R5      # next line of the sprite                              |

        SOB  R2,BitShifter_LinesLoop #-----------------------------------------+

        RETURN

BitShifter_Skip:
        ADD  R1,R5
        SOB  R2, BitShifter_Skip

        RETURN
