
                .TITLE Chibi Akumas PPU module
                .GLOBAL start # make entry point available to linker

                .include "./macros.s"
                .include "./hwdefs.s"
                .include "./core_defs.s"

                .equiv  PPU_ModuleSizeWords, (end - start) >> 1
                .global PPU_ModuleSizeWords

                .=PPU_UserRamStart

start:
# clear top and bottom screen areas -----------------------------------------{{{
                BR   6$
5$:             MOV  R1,@$PBP0DT
                INC  @$PBPADR
                MOV  R1,@$PBP0DT
                INC  @$PBPADR
                SOB  R0, 5$
                RETURN

6$:             CLR  R1
                MOV  $0100000, @$PBPADR
                MOV  $44*40>>1, R0
                CALL 5$              # clear top screen area
                MOV  $0103340, @$PBPADR
                MOV  $44*40>>1, R0
                CALL 5$              # clear bottom screen area
#----------------------------------------------------------------------------}}}
# initialize our scanlines parameters table (SLTAB): ------------------------{{{
/*
312 (1..312) lines is SECAM half-frame
309 (1..309) SLTAB records in total (lines 4..312 of SECAM's half-frame)
  scanlines   1..19  are not visible due to the vertical blanking interval
  scanlines  20..307 are visible (lines 23-310 of SECAM's half-frame)
  scanlines 308..309 are not visible due to the vertical blanking interval

| 2-word records | 4-word records |
| 0 address      | 0 data         | data - words that will be loaded into
| 2 next record  | 2 data         |        control registers
|                | 4 address      | address - address of the line to display
|                | 6 next record  | next record - address of the next record of
                                                  the SLTAB

Very first record of the table is 2-word and has fixed address 0270
--------------------------------------------------------------------------------
"next record" word description: ---------------------------------------------{{{

+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+-----+------+
|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3|   2 |   1 |    0 |
+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+-----+------+
|     address of the next record       | sel |2W/4W|cursor|
+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+-----+------+

bit 0: cursor switching control
       1 - switch cursor state (on/off)
       0 - save cursor state
       Hardware draws cursor in range of sequential lines.
       It has to be switched "on" on the first line of the sequence,
       saved in between, and turned "off" on the last line of the sequence.

bit 1: size of the next record
       1 - next is 4-word record
       0 - next is 2-word record

bit 2: 1) for 2-word record - bit 2 of address of the next element of the table
       2) for 4-word record - selects register where data will be loaded:
          0 - cursor, pallete and horizontal scale control register
          1 - colors control register
-----------------------------------------------------------------------------}}}
cursor, pallete and horizontal scale control registers desription: ----------{{{

1st word
+----+----+----+----+----+----+----+----+----+----+----+----+---+---+---+---+
| 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |  7 |  6 |  5 |  4 | 3 | 2 | 1 | 0 |
+----+----+----+----+----+----+----+----+----+----+----+----+---+---+---+---+
| X  | cursor position within a line    |graph curs pos|type| Y | R | G | B |
+----+----+----+----+----+----+----+----+----+----+----+----+---+---+---+---+

bits 0-3:  cursor color and brightness
bit 4:     cursor type
           1 - graphic cursor
           0 - character cursor
bits 5-7:  graphic cursor position within pixels octet
           0 - least significant bit (on the left side of the octet)
           7 - most significant bit (on the right side of the octet)
bits 8-14: cursor position within a text line
           from 0 to 79

2nd word
+----+----+----+----+----+----+---+---+---+---+---+---+---+----+----+----+
| 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 |  2 |  1 |  0 |
+----+----+----+----+----+----+---+---+---+---+---+---+---+----+----+----+
|                     unused                  | scale | X | PB | PG | PR |
+----+----+----+----+----+----+---+---+---+---+---+---+---+----+----+----+

bits 0-2:  brightness of RGB components on the whole line
           1 - full brightness
           0 - 50% of the full brightness
bit 3:     unused
bits 4,5:  horizontal scale
           | 5 | 4 | width px | width chars | last char pos |
           +---+---+----------+-------------+---------------+
           | 0 | 0 |   640    |     80      |     0117      |
           | 0 | 1 |   320    |     40      |      047      |
           | 1 | 0 |   160    |     20      |      023      |
           | 1 | 1 |    80    |     10      |      011      |
bits 6-15: unused
-----------------------------------------------------------------------------}}}
colors control registers description:----------------------------------------{{{

1st word
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           |15 |14 |13 |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           | Y | R | G | B | Y | R | G | B | Y | R | G | B | Y | R | G | B |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
bitplanes  |      011      |      010      |      001      |      000      |
bit 2,1,0

2nd word
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           |15 |14 |13 |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
           | Y | R | G | B | Y | R | G | B | Y | R | G | B | Y | R | G | B |
           +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
bitplanes  |      111      |      110      |      101      |      100      |
bits 2,1,0
-----------------------------------------------------------------------------}}}
*/
                MOV  $SLTAB,R0       # set R0 to beginning of SLTAB
                MOV  R0,R1           # R0 address of current record (2)

                MOV  $15,R2          #  records 2..16 are same
1$:             CLR  (R0)+           #--addresses of lines 2..16
                ADD  $4,R1           #  calc address of next record of SLTAB
                MOV  R1,(R0)+        #--address of records 3..17
                SOB  R2,1$

                # we are switching from 2-word records to 4-word records
                # so we have to align at 4 words (8 bytes)
                CLR  (R0)+           #--address of line 17
                ADD  $0b1000,R1      #  align

                BIS  $0b0010,R1      #  next record is 4-word
                BIC  $0b0100,R1      #  set cursor/scale/palette
                MOV  R1,(R0)+        #--address of the record 18
                ADD  $0b100,R0       #  correct R0 due to alignment
                BIC  $0b100,R0

                MOV  $0b10000,(R0)+  #--cursor settings, graphical cursor
                MOV  $0b10111,(R0)+  #  320 dots per line, pallete 7
                CLR  (R0)+           #  address of line 18
                BIS  $0b110,R1       #  next record is 4-word, color settings
                ADD  $8,R1           #  calculate address to next record
                MOV  R1,(R0)+        #--pointer to record 19

                MOV  $0x2020,(R0)+   # colors  011  010  001  000 (YRGB)
                MOV  $0x2020,(R0)+   # colors  111  110  101  100 (YRGB)
                CLR  (R0)+           #--address of line 19
                BIC  $0b110,R1       #  next record is 2-word
                ADD  $8,R1           #  calculate pointer to next record
                MOV  R1,(R0)+        #--pointer to the record 20
#------------------------------------- top region, header
                MOV  $0100000,R2     # scanlines 20..307 are visible
                MOV  $43,R3          #
2$:             MOV  R2,(R0)+        #--address of screenline
                ADD  $4,R1           #  calc address of next record of SLTAB
                MOV  R1,(R0)+        #--set address of next record of SLTAB
                ADD  $40,R2          #  calculate address of next screenline
                SOB  R3,2$           #

                # we are switching from 2-word records to 4-word records
                # so we have to align at 8 bytes
                MOV  R2,(R0)+        #--address of a screenline
                BIS  $0b0010,R1      #  next record is 4-word
                BIC  $0b0100,R1      #  display settings
                ADD  $0b1000,R1      #  calc address of next record of SLTAB
                                     #  taking alignment into account
                MOV  R1,(R0)+        #--pointer to record 63
                ADD  $0b100,R0       #  correct R0
                BIC  $0b100,R0       #  due to alignment
                ADD  $40,R2          #  calculate address of next screenline

                MOV  R0,@$FBSLTAB    #
                SUB  $2,@$FBSLTAB    #

                MOV  $0b10000,(R0)+  #--cursor settings: graphical cursor
                MOV  $0b10111,(R0)+  #  320 dots per line, pallete 7
                MOV  R2,(R0)+        #--address of a screenline
                ADD  $8,R1           #  calc address of next record of SLTAB
                BIS  $0b110,R1       #  next record is 4-word, color settings
                MOV  R1,(R0)+        #--pointer to record 64
#------------------------------------- main screen area
                MOV  $FB1 >> 1,R2    # address of second frame-buffer
                MOV  $200,R3         # number of lines on main screen area
3$:             MOV  $0xCC00,(R0)+   #  colors  011  010  001  000 (YRGB)
                MOV  $0xFF99,(R0)+   #  colors  111  110  101  100 (YRGB)
                MOV  R2,(R0)+        #--main RAM address of a scanline
                ADD  $8,R1           #  calc address of next record of SLTAB
                MOV  R1,(R0)+        #--pointer to the next record of SLTAB
                ADD  $40,R2          #  calculate address of next screenline
                SOB  R3,3$           #
#------------------------------------- bottom region, footer
                MOV  $0x2020,(R0)+   # colors  011  010  001  000 (YRGB)
                MOV  $0x2020,(R0)+   # colors  111  110  101  100 (YRGB)
                MOV  $0103340+40,R2  #
                MOV  R2,(R0)+        #
                ADD  $40,R2          # calculate address of next screenline
                ADD  $8,R1           # calculate pointer to next record
                BIC  $0b110,R1       # next record consists of 2 words
                MOV  R1,(R0)+        #--set address of record 265

                MOV  $42,R3          #
4$:             MOV  R2,(R0)+        #--address of a screenline
                ADD  $4,R1           #  calc address of next record of SLTAB
                MOV  R1,(R0)+        #--pointer to the next record of SLTAB
                ADD  $40,R2          # calculate address of next screenline
                SOB  R3,4$           #
                                     #
                CLR  (R0)+           #--address of line 308
                MOV  R1,(R0)         #--pointer back to record 308
#----------------------------------------------------------------------------}}}
Setup:          #------------------------------------------------------------{{{
                MOV  @$0100, @$SYS100
                MOV  $VblankIntHandler,@$0100

                MOV  @$0300, @$SYS300
                MOV  $KeyboardIntHadler,@$0300

                MOV  @$0272, @$SYS272 # store address of system SLTAB (186; 0xBA)
                MOV  $SLTAB, @$0272   # use our SLTAB

                MOV  $PGM, @$07124    # add PGM to PPU's processes table
                MOV  $1, @$07100      # add PGM to PPU's processes execution table
                RETURN                # end of the init subroutine
#----------------------------------------------------------------------------}}}
Teardown:       #------------------------------------------------------------{{{
                CLR  @$07100          # do not run the PGM anymore
                MOV  @$SYS100, @$0100 # restore Vblank interrupt handler
                MOV  @$SYS272, @$0272 # restore pointer to system SLTAB (186; 0xBA)
                MOV  @$SYS300, @$0300 # restore keyboard interrupt handler
                MOV  $PPU_PPUCommand, @$PBPADR
                CLR  @$PBP12D         # inform CPU program that we are done
                # MOV  $start,R1        #
                # JMP  @$0176300        # free allocatem memory and exit
                RETURN
#----------------------------------------------------------------------------}}}
PGM:            #---------------------------------------------------------------
                MOV  R0, -(SP) # store R0 in order for the process manager to function correctly
                MOV  $PPU_PPUCommand, @$PBPADR
                MOV  @$PBP12D,R0
                CMP  R0, $PPU_Print
                BEQ  JMPPrint
                CMP  R0, $PPU_SetPalette
                BEQ  JMPSetPalette
                CMP  R0, $PPU_Finalize
                BEQ  JMPTeardown

                BR   CommandExecuted

JMPPrint:       JMP  Print
JMPSetPalette:  JMP  SetPalette
JMPTeardown:    JMP  Teardown
#-------------------------------------------------------------------------------
CommandExecuted: #-----------------------------------------------------------{{{
                MOV  $PPU_PPUCommand, @$PBPADR
                CLR  @$PBP12D        # inform CPU's program that we are done
                MOV  $PGM, @$07124   # add to processes table
                MOV  $1, @$07100     # require execution
                MOV  (SP)+, R0       # restore R0
                JMP  @$0174170       # jump back to the process manager (63608; 0xF878)
#----------------------------------------------------------------------------}}}
SetPalette:     #------------------------------------------------------------{{{
                MOV  $PPU_PPUCommandArg, @$PBPADR
                MOV  @$PBP12D, @$PBPADR
                # R0 - first parameter word
                # R1 - second parameter word
                # R2 - display/color parameters flag
                # R3 - current line
                # R4 - next line where parameters change
                MOV  @$PBP12D,R3     # get line number
                MOV  R3,R4
NextRecord$:
                MOV  R4,R3           # R3 = previous iteration's next line
                MOV  R3,R5           # prepare to calculate address of SLTAB section to modify
                ASH  $3,R5           # calculate offset by multiplying by 8 (by shifting R5 left by 3 bits)
                ADD  @$FBSLTAB,R5    # and add address of SLTAB section we modify

                INC  @$PBPADR
                MOV  @$PBP12D,R2     # get display/color parameters flag
                INC  @$PBPADR
                MOV  @$PBP12D,R0     # get first data word
                INC  @$PBPADR
                MOV  @$PBP12D,R1     # get second data word
                INC  @$PBPADR
                MOV  @$PBP12D,R4     # get next line idx

SetParams$:     TST  R2
                BNE  ColorSet$
                BIC  $0b100,(R5)+
                BR   SetData$
ColorSet$:      BIS  $0b100,(R5)+

SetData$:       MOV  R0,(R5)+
                MOV  R1,(R5)+
                ADD  $2,R5           # skip third word (screen line address)

                INC  R3              # increase current line idx
                CMP  R3,R4           # compare current line idx with next line idx
                BLO  SetParams$      # branch if lower

                CMP  R4,$201
                BNE  NextRecord$
                JMP  CommandExecuted
#----------------------------------------------------------------------------}}}
Print: #---------------------------------------------------------------------{{{
                .equiv LineWidth, 40
                .equiv CharHeight, 9
                .equiv CharLineSize, LineWidth * CharHeight
                .equiv TextLinesCount, 9

                MOV  $StrBuffer,R3
                MOV  $LineWidth,R2
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5

                MOV  $PPU_PPUCommandArg, (R5) # load address register
                MOV  (R4), R0 # get address of a string from CPU RAM
                ASR  R0       # divide it by 2 to calculate bitplane address
                MOV  R0,(R5)  # load address of a string into address register

1$:             MOV  (R4),R0  # load 2 bytes from CPU RAM
                MOV  R0,(R3)+ # store them into buffer
                TSTB R0       # end of string?
                BEQ  3$       # yes, we are done here
                SWAB R0       # swap bytes to test most significant one
                TSTB R0       # end of string?
                BEQ  3$       # yes, we are done here
                INC  (R5)     # next address
                BR   1$

3$:             MOV  @$CurrentLine,R1 # prepare to calculate relative char address
                MUL  $CharLineSize,R1 # calculate relative address of the line
                ADD  @$CurrentChar,R1 # calculate relative address of the char
                ADD  $0x8000,R1       # calculate absolute address of the next char

                MOV  $StrBuffer,R3
                MOV  $PBP0DT,R4

NextChar:       MOV  R1,(R5)      # load address of the next char into address register
                MOVB (R3)+,R0     # load character code from string buffer
                TSTB R0           # end of string?
                BEQ  DonePrinting # yes, finish
                CMPB $'\n, R0     # new line?
                BEQ  NewLine      #

Draw:           ASH  $3,R0        # shift left by 3(multiply by 8)
                ADD  $CGAFont,R0  # calculate char position within font

                .rept 8
                MOVB (R0)+,(R4)   #
                ADD  R2,(R5)      # set address reg to next line of the char
                .endr

                INC  R1
                INC  @$CurrentChar
                CMP  @$CurrentChar,R2  # end of screen line? (R2 == 40)
                BNE  NextChar          # no, print another character
NewLine:        CLR  @$CurrentChar
                INC  @$CurrentLine
                CMP  @$CurrentLine,$TextLinesCount
                BNE  Recalculate
                CLR  @$CurrentLine

Recalculate:    MOV  @$CurrentLine,R1 # prepare to calculate relative char address
                MUL  $CharLineSize,R1 #
                ADD  @$CurrentChar,R1 # add char position
                ADD  $0x8000,R1       # calculate absolute address of the next char
                MOV  R1,(R5)  # load address of the next char into address register
                BR   NextChar

DonePrinting:   JMP  CommandExecuted

CurrentLine:    .word 0
CurrentChar:    .word 0
StrBuffer:      .space 80*2
#----------------------------------------------------------------------------}}}
VblankIntHandler: #----------------------------------------------------------{{{
        # we do not need firmware interrupt handler except for this small
        # procedure
        TST  @$07130 # is floppy drive spindle rotating?
        BEQ  1$      # no
        DEC  @$07130 # decrease spindle rotation counter
        BNE  1$      # continue rotation if the counter is not zero
        CALL @07132  # stop floppy drive spindle
1$:

        RTI
#----------------------------------------------------------------------------}}}
KeyboardIntHadler: #---------------------------------------------------------{{{
        MOV  $PPU_KeyboardScanner_KeyPresses,@$PBPADR
        MOVB @$KBDATA,@$PBP12D
        INC  @$PBPADR
        MOV  $1,@$PBP12D
        RTI
#----------------------------------------------------------------------------}}}

CGAFont: .incbin "cga8x8b.raw"
SYS100:  .word 0174612 # default vertical blank interrupt handler
SYS272:  .word 02270   # address of default scanlines table
SYS300:  .word 0175412 # default keyboard interrupt hadler
FBSLTAB: .word 0       # adrress of main screen SLTAB

         .balign 8 # align at 8 bytes or the new SLTAB will be invalid
SLTAB:   .space 288 * 2 * 4 # space for a 288 four-words entries
         .space 10 * 2 * 2  # reserve some more space for invisible scanlines

end:
