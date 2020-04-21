               .nolist

               .TITLE Chibi Akumas PPU module
               .GLOBAL start # make entry point available to linker

               .include "./macros.s"
               .include "./hwdefs.s"
               .include "./core_defs.s"

               .equiv  PPU_ModuleSizeWords, (end - start) >> 1
               .global PPU_ModuleSizeWords

               .=PPU_UserRamStart

start:
ClrTextArea: # --------------------------------------------------------------{{{
                MOV  $88*40>>1, R0
                CLR  R1
                MOV  $PBPADR,R5
                MOV  $PBP0DT,R4
                MOV  $0100000,(R5)

1$:            .rept 2
                MOV  R1,(R4)
                INC  (R5)
               .endr
                SOB  R0,1$
#----------------------------------------------------------------------------}}}
# initialize our scanlines parameters table (SLTAB): ------------------------{{{
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
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
       Hardware draws cursor in a range of sequential lines.
       The cursor has to be switched "on" on the first line of the sequence,
       saved in between, and turned "off" on the last line of the sequence.

bit 1: size of the next record
       1 - next is a 4-word record
       0 - next is a 2-word record

bit 2: 1) for 2-word record - bit 2 of address of the next element of the table
       2) for 4-word record - selects register where data will be loaded:
          0 - cursor, pallete, and horizontal scale control register
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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
SLTABInit:      MOV  $SLTAB,R0       # set R0 to beginning of SLTAB
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
PGM: #--------------------------------------------------------------------------
                MOV  R0, -(SP) # store R0 in order for the process manager to
                               # function correctly
ShortLoop:      MOV  $PPU_PPUCommand, @$PBPADR
                MOV  @$PBP12D,R0
                ASL  R0 # multiply by 2 to calculate word offset
                JMP  @JMPTable(R0)
JMPTable:      .word EventLoop
               .word CommandExecuted      # PPU_NOP
               .word Teardown             # PPU_Finalize
               .word SetSingleProcessFlag # PPU_SingleProcess
               .word ClrSingleProcessFlag # PPU_MultiProcess
               .word SetPalette           # PPU_SetPalette
               .word Print                # PPU_Print
               .word PrintAt              # PPU_PrintAt
#-------------------------------------------------------------------------------
CommandExecuted: #-----------------------------------------------------------{{{
                MOV  $PPU_PPUCommand, @$PBPADR
                CLR  @$PBP12D        # inform CPU's program that we are done
EventLoop:      TST  @$SingleProcessFlag
                BNE  ShortLoop       # non-zero, flag is set, loop

                MOV  $PGM, @$07124   # add to processes table
                MOV  $1, @$07100     # require execution
                MOV  (SP)+, R0       # restore R0
                JMP  @$0174170       # jump back to the process manager (63608; 0xF878)
#----------------------------------------------------------------------------}}}
Teardown: #------------------------------------------------------------------{{{
                MOV  @$SYS272, @$0272 # restore default SLTAB (186; 0xBA)
                MOV  @$SYS300, @$0300 # restore keyboard interrupt handler
                MOV  @$SYS100, @$0100 # restore Vblank interrupt handler

                MOV  $PPU_PPUCommand, @$PBPADR
                CLR  @$PBP12D         # inform CPU program that we are done

                MOV  (SP)+,R0
                CLR  @$07100          # do not run the PGM anymore
                JMP  @$0174170        # jump back to the process manager (63608; 0xF878)
#----------------------------------------------------------------------------}}}
SetSingleProcessFlag: #------------------------------------------------------{{{
                MOV  $1,@$SingleProcessFlag
                JMP  CommandExecuted
#----------------------------------------------------------------------------}}}
ClrSingleProcessFlag: #------------------------------------------------------{{{
                CLR  @$SingleProcessFlag
                JMP  CommandExecuted
#----------------------------------------------------------------------------}}}
SetPalette: #----------------------------------------------------------------{{{
                MOV  $PPU_PPUCommandArg, @$PBPADR
                MOV  @$PBP12D, @$PBPADR # get palette address
                CLC
                ROR  @$PBPADR           #
                # R0 - first parameter word
                # R1 - second parameter word
                # R2 - display/color parameters flag
                # R3 - current line
                # R4 - next line where parameters change
                # R5 - pointer to a word that we'll modify
                CLR  R3
                BISB @$PBP1DT,R3  # get line number
                MOV  R3,R4
    next_record$:
                MOV  R4,R3        # R3 = previous iteration's next line
                MOV  R3,R5        # prepare to calculate address of SLTAB section to modify
                ASH  $3,R5        # calculate offset by multiplying by 8 (by shifting R5 left by 3 bits)
                ADD  @$FBSLTAB,R5 # and add address of SLTAB section we modify

                MOVB @$PBP2DT,R2  # get display/color parameters flag
                INC  @$PBPADR
                MOV  @$PBP12D,R0  # get first data word
                INC  @$PBPADR
                MOV  @$PBP12D,R1  # get second data word
                INC  @$PBPADR
                CLR  R4
                BISB @$PBP1DT,R4  # get next line idx
    set_params$:
                TSTB R2
                BMI  palette_is_set$ # negative value - terminator
                BNE  set_colors$     # 1 - set colors
                BIC  $0b100,(R5)+    # 0 - set data
                BR   set_data$
    set_colors$:
                BIS  $0b100,(R5)+
    set_data$:
                MOV  R0,(R5)+
                MOV  R1,(R5)+
                ADD  $2,R5        # skip third word (screen line address)

                INC  R3           # increase current line idx
                CMP  R3,R4        # compare current line idx with next line idx
                BLO  set_params$  # branch if lower

                CMP  R4,$201
                BNE  next_record$
    palette_is_set$:
                JMP  CommandExecuted
#----------------------------------------------------------------------------}}}
PrintAt: #-------------------------------------------------------------------{{{
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5
                MOV  $PPU_PPUCommandArg,(R5)
                MOV  (R4),R0
                INC  (R4)
                INC  (R4)
                CLC
                ROR  R0
                MOV  R0,(R5)
                MOV  (R4),R0
                MOVB R0,@$CurrentChar
                SWAB R0
                MOVB R0,@$CurrentLine
                BR   Print
#----------------------------------------------------------------------------}}}
Print: #---------------------------------------------------------------------{{{
               .equiv LineWidth, 40
               .equiv TextLinesCount, 25
               .equiv CharHeight, 8
               .equiv CharLineSize, LineWidth * CharHeight
               .equiv FbStart, FB1 >> 1
               .equiv BPDataReg, PBP12D
               .equiv Font, CGAFont - (32 * 8 * 2)

                MOV  $LineWidth,R2
                MOV  $StrBuffer,R3
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5

                MOV  $PPU_PPUCommandArg, (R5) # load address register
                MOV  (R4),R0  # get address of a string from CPU RAM
                CLC
                ROR  R0       # divide it by 2 to calculate bitplane address
                MOV  R0,(R5)  # load address of a string into address register

LoadNext2Bytes: MOV  (R4),R0  # load 2 bytes from CPU RAM
                MOV  R0,(R3)+ # store them into buffer
                TSTB R0       #
                BEQ  3$       # end of text
                BMI  2$       # end of string
                SWAB R0       # swap bytes to test most significant one
                TSTB R0       #
                BEQ  3$       # end of text
                BMI  2$       # end of string
                INC  (R5)     # next address
                BR   LoadNext2Bytes

2$:             INC  (R5)
                MOV  (R5),@$NextStringAddr

3$:             MOV  @$CurrentLine,R1 # prepare to calculate relative char address
                MUL  $CharLineSize,R1 # calculate relative address of the line
                ADD  @$CurrentChar,R1 # calculate relative address of the char
                ADD  $FbStart,R1      # calculate absolute address of the next char

                MOV  $StrBuffer,R3
                MOV  $BPDataReg,R4

NextChar:       MOV  R1,(R5)      # load address of the next char into address register
                MOVB (R3)+,R0     # load character code from string buffer
                TSTB R0           #
                BEQ  DonePrinting # end of text
                BMI  NextString   # end of string
                CMPB $'\n, R0     # new line?
                BEQ  NewLine      #

Draw:           ASH  $4,R0        # shift left by 4(multiply by 16)
                ADD  $Font,R0     # calculate char bitmap address

               .rept 8
                MOV  (R0)+,(R4) #
                ADD  R2,(R5)    # advance the address register to the next line
               .endr

                INC  R1
                INC  @$CurrentChar
                CMP  @$CurrentChar,R2 # end of screen line? (R2 == 40)
                BNE  NextChar         # no, print another character
NewLine:        CLR  @$CurrentChar
                INC  @$CurrentLine
                CMP  @$CurrentLine,$TextLinesCount # next line out of screen?
                BNE  Recalculate      # no, recalculate screen address
                CLR  @$CurrentLine    # yes, print from the beginning

Recalculate:    MOV  @$CurrentLine,R1 #
                MUL  $CharLineSize,R1 # calculate relative line address
                ADD  @$CurrentChar,R1 # calculate relative char dst address
                ADD  $FbStart,R1      # calculate screen address of the next char
                MOV  R1,(R5)          # load screen address of the next char to address register
                BR   NextChar

NextString:     MOV  $StrBuffer,R3
                MOV  @$NextStringAddr,(R5)
                MOV  (R4),R0
                MOVB R0,@$CurrentChar
                SWAB R0
                MOVB R0,@$CurrentLine
                INC  (R5)
                BR   LoadNext2Bytes

DonePrinting:   JMP  CommandExecuted

CurrentLine:    .word 0
CurrentChar:    .word 0
NextStringAddr: .word 0
StrBuffer:      .space 160
#----------------------------------------------------------------------------}}}

VblankIntHandler: #----------------------------------------------------------{{{
        # we do not need firmware interrupt handler except for this small
        # procedure
        TST  @$07130 # is floppy drive spindle rotating?
        BEQ  1$      # no
        DEC  @$07130 # decrease spindle rotation counter
        BNE  1$      # continue rotation unless the counter reaches zero
        CALL @07132  # stop floppy drive spindle
1$:

        RTI
#----------------------------------------------------------------------------}}}
KeyboardIntHadler: #---------------------------------------------------------{{{
# key codes #----------------------------------------------------------------{{{
# | code |   key   | note     | code |  key  |  note     |
# |------+---------+----------+------+-------+-----------+
# |   05 | ,       | NumPad   | 0106 | АЛФ   | Alphabet  |
# |   06 | АР2     | Esc      | 0107 | ФИКС  | Lock      |
# |   07 | ; / +   |          | 0110 | Ч / ^ |           |
# |  010 | К1 / К6 | F1 / F6  | 0111 | С / S |           |
# |  011 | К2 / К7 | F2 / F7  | 0112 | М / M |           |
# |  012 | КЗ / К8 | F3 / F8  | 0113 | SPACE |           |
# |  013 | 4 / ¤   |          | 0114 | Т / T |           |
# |  014 | К4 / К9 | F4 / F9  | 0115 | Ь / X |           |
# |  015 | К5 / К10| F5 / F10 | 0116 | ←     |           |
# |  016 | 7 / '   |          | 0117 | , / < |           |
# |  017 | 8 / (   |          | 0125 | 7     | NumPad    |
# |  025 | -       | NumPad   | 0126 | 0     | NumPad    |
# |  026 | ТАБ     | Tab      | 0127 | 1     | NumPad    |
# |  027 | Й / J   |          | 0130 | 4     | NumPad    |
# |  028 | 1 / !   |          | 0131 | +     | NumPad    |
# |  031 | 2 / "   |          | 0132 | ЗБ    | Backspace |
# |  032 | 3 / #   |          | 0133 | →     |           |
# |  033 | Е / E   |          | 0134 | ↓     |           |
# |  034 | 5 / %   |          | 0135 | . / > |           |
# |  035 | 6 / &   |          | 0136 | Э / \ |           |
# |  036 | Ш / [   |          | 0137 | Ж / V |           |
# |  037 | Щ / ]   |          | 0145 | 8     | NumPad    |
# |  046 | УПР     | Ctrl     | 0146 | .     | NumPad    |
# |  047 | Ф / F   |          | 0147 | 2     | NumPad    |
# |  050 | Ц / C   |          | 0150 | 5     | NumPad    |
# |  051 | У / U   |          | 0151 | ИСП   | Execute   |
# |  052 | К / K   |          | 0152 | УСТ   | Settings  |
# |  053 | П / P   |          | 0153 | ВВОД  | Enter     |
# |  054 | H / N   |          | 0154 | ↑     |           |
# |  055 | Г / G   |          | 0155 | : / * |           |
# |  056 | Л / L   |          | 0156 | Х / H |           |
# |  057 | Д / D   |          | 0157 | З / Z |           |
# |  066 | ГРАФ    | Graph    | 0165 | 9     | NumPad    |
# |  067 | Я / Q   |          | 0166 | ВВОД  | NumPad    |
# |  070 | Ы / Y   |          | 0167 | 3     | NumPad    |
# |  071 | В / W   |          | 0170 | 7     | NumPad    |
# |  072 | А / A   |          | 0171 | СБРОС | Reset     |
# |  073 | И / I   |          | 0172 | ПОМ   | Help      |
# |  074 | Р / R   |          | 0173 | / / ? |           |
# |  075 | О / O   |          | 0174 | Ъ / } |           |
# |  076 | Б / B   |          | 0175 | - / = |           |
# |  077 | Ю / @   |          | 0176 | О / } |           |
# | 0105 | HP      | Shift    | 0177 | 9 / ) |           |
# ----------------------------------------------------------------------------}}}
        PUSH R0
        MOV  $PPU_KeyboardScanner_KeyPresses,@$PBPADR
        MOVB @$KBDATA,R0
        BMI  1237$

        MOVB R0,@$PBP12D
        INC  @$PBPADR
        MOV  $1,@$PBP12D

1237$:  POP  R0
        RTI
#----------------------------------------------------------------------------}}}

SingleProcessFlag: .word 0
#CGAFont: .space 8 # whitespace symbol
#         .incbin "resources/font.bin"
CGAFont: .space 8*2 # whitespace symbol
         .incbin "resources/font.bin"
SYS100:  .word 0174612 # address of default vertical blank interrupt handler
SYS272:  .word 02270   # address of default scanlines table
SYS300:  .word 0175412 # address of default keyboard interrupt hadler
FBSLTAB: .word 0       # adrress of main screen SLTAB

         .balign 8 # scan-lines parameters table, it has to be aligned at 4 words
SLTAB:   # space for the SLTAB must be reserved when allocating PPU memory
end:
