               .nolist

               .title Chibi Akumas PPU module

               .global start # make the entry point available to a linker
               .global StrBuffer
               .global PPU_ModuleSize
               .global PPU_ModuleSizeWords

               .include "./macros.s"
               .include "./hwdefs.s"
               .include "./core_defs.s"

               .equiv  PPU_ModuleSize, (end - start)
               .equiv  PPU_ModuleSizeWords, PPU_ModuleSize >> 1

               .=PPU_UserRamStart

start:
                MOV  $0b001,@$PBPMSK  # disable writes to bitplane 0

                MOV  @$PASWCR,-(SP)
ClrTextArea: # --------------------------------------------------------------{{{
                # enable write-only direct access to the RAM above 0100000
            .if OffscreenAreaAddr < 0120000     # 0100000..0117777
                MOV  $0x011,@$PASWCR
            .elseif OffscreenAreaAddr < 0140000 # 0120000..0137777
                MOV  $0x021,@$PASWCR
            .elseif OffscreenAreaAddr < 0160000 # 0140000..0157777
                MOV  $0x041,@$PASWCR
            .else                               # 0160000..0176777
                MOV  $0x081,@$PASWCR
            .endif

                MOV  $88*20>>1, R0
                CLR  R1
                MOV  $OffscreenAreaAddr,R5

1$:            .rept 2
                MOV  R1,(R5)+
               .endr
                SOB  R0,1$
#----------------------------------------------------------------------------}}}
                # replace ROM with RAM in the range 0100000..0117777
                MOV  $0x010,@$PASWCR
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
                MOV  $0b10111,(R0)+  #  320 dots per line, palette 7
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
                MOV  $OffscreenAreaAddr,R2     # scanlines 20..307 are visible
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

                MOV  R0,@$FirstLineAddress
                ADD  $4,@$FirstLineAddress
#------------------------------------- main screen area
                MOV  $FB1 >> 1,R2    # address of second frame-buffer
                MOV  $200,R3         # number of lines on main screen area
3$:             MOV  $0x0000,(R0)+   #  colors  011  010  001  000 (YRGB)
                MOV  $0x0000,(R0)+   #  colors  111  110  101  100 (YRGB)
                MOV  R2,(R0)+        #--main RAM address of a scanline
                ADD  $8,R1           #  calc address of next record of SLTAB
                MOV  R1,(R0)+        #--pointer to the next record of SLTAB
                ADD  $40,R2          #  calculate address of next screenline

                SOB  R3,3$           #
#------------------------------------- bottom region, footer
                MOV  $0x2020,(R0)+   # colors  011  010  001  000 (YRGB)
                MOV  $0x2020,(R0)+   # colors  111  110  101  100 (YRGB)
                MOV  $OffscreenAreaAddr+03340+40,R2  #
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
                MOV  (SP)+,@$PASWCR
#-------------------------------------------------------------------------------
                MOV  @$0272, @$SYS272 # store address of system SLTAB (186; 0xBA)
                MOV  $SLTAB, @$0272   # use our SLTAB

                MOV  $SoundEffects,R5
                CALL PLY_SE_InitSoundEffects
                MOV  @$0100, @$SYS100
                MOV  $VblankIntHandler,@$0100

                MOV  @$KBINT, @$SYS300
                MOV  $KeyboardIntHadler,@$KBINT

                MOV  @$0320,@$SYS320
                MOV  $Channel0In_IntHandler,@$0320

                MOV  @$0324,@$SYS324
                MOV  $Channel0Out_IntHandler,@$0324

                MOV  $PGM, @$07124    # add PGM to PPU's processes table
                MOV  $1, @$07100      # add PGM to PPU's processes execution table

                RETURN                # end of the init subroutine
#-------------------------------------------------------------------------------
PGM: #--------------------------------------------------------------------------
                MOV  R0, -(SP) # store R0 in order for the process manager to
                               # function correctly
SingleProcess_Loop:
                MOV  @$CommandsQueue_CurrentPosition,R5
                CMP  R5,$CommandsQueue_Bottom
                BEQ  EventLoop
#-------------------------------------------------------------------------------
CommandsQueue_Process:
                MOV  (R5)+,R1
                MOV  (R5)+,R0
                MOV  R5,@$CommandsQueue_CurrentPosition
            .ifdef DebugMode
                CMP  R1,$PPU_LastJMPTableIndex
                BHI  .
            .endif
                CALL @JMPTable(R1)
                MOV  @$CommandsQueue_CurrentPosition,R5
                CMP  R5,$CommandsQueue_Bottom
                BLO  CommandsQueue_Process

               .equiv SingleProcessFlag, .+2
EventLoop:      TST  $0
                BNZ  SingleProcess_Loop # non-zero, flag is set, loop

                MOV  $PGM, @$07124      # add to processes table
                MOV  $1, @$07100        # require execution
                MOV  (SP)+, R0          # restore R0
                JMP  @$0174170          # jump back to the process manager (63608; 0xF878)
#-------------------------------------------------------------------------------
JMPTable:      .word EventLoop             # do nothing
               .word CommandsQueue_Process # PPU_NOP
               .word Teardown              # PPU_Finalize
               .word GoSingleProcess       # PPU_SingleProcess
               .word GoMultiProcess        # PPU_MultiProcess
               .word SetPalette            # PPU_SetPalette
               .word Print                 # PPU_Print
               .word PrintAt               # PPU_PrintAt
               .word FlipFB                # PPU_FlipFB
               .word ShowFB0               # PPU_ShowFB0
               .word ShowFB1               # PPU_ShowFB1
               .word LoadText              # PPU_LoadText
               .word ShowBossText          # PPU_ShowBossText
               .word LoadMusic             # PPU_LoadMusic
               .word MusicRestart          # PPU_MusicRestart
               .word MusicStop             # PPU_MusicStop
               .word Debug_Print           # PPU_Debug_Print
               .word Debug_PrintAt         # PPU_Debug_PrintAt
               .word TitleMusicRestart
               .word IntroMusicRestart
               .word LevelMusicRestart
               .word BossMusicRestart
               .word PlaySoundEffect1
               .word PlaySoundEffect2
               .word PlaySoundEffect3
               .word PlaySoundEffect4
               .word PlaySoundEffect5
               .word PlaySoundEffect6
               .word PlaySoundEffect7

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
GoSingleProcess: #-----------------------------------------------------------{{{
                MOV  $1,@$SingleProcessFlag # skip firmware processes
                RETURN
#----------------------------------------------------------------------------}}}
GoMultiProcess: #------------------------------------------------------------{{{
                CLR  @$SingleProcessFlag
                RETURN
#----------------------------------------------------------------------------}}}
SetPalette: #----------------------------------------------------------------{{{
                PUSH @$PASWCR
                MOV  $0x010,@$PASWCR

                CLC
                ROR  R0
                MOV  R0,@$PBPADR # palette address
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

                MOVB @$PBP2DT,R2     # get display/color parameters flag
                BMI  palette_is_set$ # negative value - terminator
                INC  @$PBPADR
                MOV  @$PBP12D,R0     # get first data word
                INC  @$PBPADR
                MOV  @$PBP12D,R1     # get second data word
                INC  @$PBPADR
                CLR  R4
                BISB @$PBP1DT,R4  # get next line idx
    set_params$:
                TSTB R2
                BNZ  set_colors$     # 1 - set colors
                BIC  $0b100,(R5)+    # 0 - set data
                BR   set_data$
    set_colors$:
                BIS  $0b100,(R5)+
    set_data$:
                MOV  R0,(R5)+
                MOV  R1,(R5)+
                INC  R5
                INC  R5           # skip third word (screen line address)

                INC  R3           # increase current line idx
                CMP  R3,R4        # compare current line idx with next line idx
                BLO  set_params$  # branch if lower

                CMP  R4,$201
                BNE  next_record$

    palette_is_set$:
                POP  @$PASWCR

                RETURN
#----------------------------------------------------------------------------}}}
PrintAt: #-------------------------------------------------------------------{{{
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5
                CLC
                ROR  R0
                MOV  R0,(R5)
                ROL  R0
                INC  R0
                INC  R0
                MOV  (R4),R1
                MOVB R1,@$CurrentChar
                SWAB R1
                MOVB R1,@$CurrentLine
                BR   Print
#----------------------------------------------------------------------------}}}
Print: #---------------------------------------------------------------------{{{
               .equiv LineWidth, 40
               .equiv TextLinesCount, 25
               .equiv CharHeight, 8
               .equiv CharLineSize, LineWidth * CharHeight
               .equiv FbStart, FB1 >> 1
               .equiv Font, FontBitmap - (32 * 8)
               .equiv BPDataReg, DTSOCT

                MOV  $10<<1,@$DTSCOL # foreground color
                MOV  $LineWidth,R2
                MOV  $StrBuffer,R3
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5

                CLC
                ROR  R0
                MOV  R0,(R5)  # load address of a string into address register

LoadNext2Bytes: MOV  (R4),R0  # load 2 bytes from CPU RAM
                MOV  R0,(R3)+ # store them into buffer
                TSTB R0       #
                BZE  3$       # end of text
                BMI  2$       # end of string
                SWAB R0       # swap bytes to test most significant one
                TSTB R0       #
                BZE  3$       # end of text
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
                BZE  DonePrinting # end of text
                BMI  NextString   # end of string
                CMPB $'\n, R0     # new line?
                BEQ  NewLine      #

                ASH  $3,R0        # shift left by 3(multiply by 8)
                ADD  $Font,R0     # calculate char bitmap address

               .rept 8
                MOVB (R0)+,(R4) #
                ADD  R2,(R5)    # advance the address register to the next line
               .endr

                INC  R1
                INC  (PC)+; CurrentChar: .word 0
                CMP  @$CurrentChar,R2 # end of screen line? (R2 == 40)
                BNE  NextChar         # no, print another character
NewLine:        CLR  @$CurrentChar
                INC  (PC)+; CurrentLine: .word 0
                CMP  @$CurrentLine,$TextLinesCount # next line out of screen?
                BNE  Recalculate   # no, recalculate screen address
                CLR  @$CurrentLine # yes, print from the beginning

Recalculate:    MOV  @$CurrentLine,R1 #
                MUL  $CharLineSize,R1 # calculate relative line address
                ADD  @$CurrentChar,R1 # calculate relative char dst address
                ADD  $FbStart,R1      # calculate screen address of the next char
                MOV  R1,(R5)          # load screen address of the next char to address register
                BR   NextChar

NextString:     MOV  $StrBuffer,R3
                MOV  (PC)+,(R5); NextStringAddr: .word 0
                MOV  $PBP12D,R4
                MOV  (R4),R0
                MOVB R0,@$CurrentChar
                SWAB R0
                MOVB R0,@$CurrentLine
                INC  (R5)
                BR   LoadNext2Bytes

DonePrinting:   RETURN

#----------------------------------------------------------------------------}}}
FlipFB: #--------------------------------------------------------------------{{{
               .equiv ActiveFrameBuffer, .+2
                CMP  $FB0>>1,$FB0>>1
                BEQ  ShowFB1
#----------------------------------------------------------------------------}}}
ShowFB0: #-------------------------------------------------------------------{{{
                MOV  @$PASWCR,-(SP) # PPU address space window control register
                MOV  $0x010,@$PASWCR

                MOV  $0x2000,R0
                MOV  $8,R1 # length of the screenlines table record
                MOV  $200>>2,R2
                MOV  @$FirstLineAddress,R5

        100$:  .rept 1<<2
                BIC  R0,(R5)
                ADD  R1,R5
               .endr
                SOB  R2,100$

                MOV  (SP)+, @$PASWCR
                MOV  $FB0>>1,@$ActiveFrameBuffer

                RETURN
#----------------------------------------------------------------------------}}}
ShowFB1: #-------------------------------------------------------------------{{{
                MOV  @$PASWCR,-(SP) # PPU address space window control register
                MOV  $0x010,@$PASWCR

                MOV  $0x2000,R0
                MOV  $8,R1
                MOV  $200>>2,R2
                MOV  @$FirstLineAddress,R5

        100$:  .rept 1<<2
                BIS  R0,(R5)
                ADD  R1,R5
               .endr
                SOB  R2,100$

                MOV  (SP)+, @$PASWCR
                MOV  $FB1>>1,@$ActiveFrameBuffer

                RETURN
#----------------------------------------------------------------------------}}}
LoadText: #------------------------------------------------------------------{{{
                MOV  $StrBuffer,R3
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5

                CLC
                ROR  R0
                MOV  R0,(R5)  # load address of a string into address register

                MOV  (R4),(R3)+ # load and store coordinates of the first line of the text
                INC  (R5)

        10$:    MOV  (R4),R0  # load 2 bytes from CPU RAM
                MOV  R0,(R3)+ # store them into the buffer
                TSTB R0       #
                BZE  1237$    # end of the text
                SWAB R0       # swap bytes to test most significant one
                TSTB R0       #
                BZE  1237$    # end of the text
                INC  (R5)     # next address
                BR   10$

1237$:          RETURN
#----------------------------------------------------------------------------}}}
ShowBossText: #--------------------------------------------------------------{{{
                MOV  $10<<1,@$DTSCOL # foreground color
                MOV  $LineWidth,R2
                MOV  $StrBuffer,R3
                MOV  $PBP12D,R4
                MOV  $PBPADR,R5

                MOV  R0,@$CharsToPrint
                MOV  $DTSOCT,R4

SBT_NextTextLine:
                MOVB (R3)+,R0
                ADD  $FbStart,R0

                MOVB (R3)+,R1
                MUL  $CharLineSize,R1
                ADD  R0,R1

SBT_NextChar:   DEC  (PC)+; CharsToPrint: .word 0xFF
                BZE  1237$

                MOV  R1,(R5)      # load address of the next char into address register
                MOVB (R3)+,R0     # load character code from string buffer
                TSTB R0
                BMI  SBT_NextTextLine
                BZE  1237$        # return if we are reached end of the text

                ASH  $3,R0        # shift left by 3(multiply by 8)
                ADD  $Font,R0     # calculate char bitmap address

               .rept 8
                MOVB (R0)+,(R4) #
                ADD  R2,(R5)    # advance the address register to the next line
               .endr

                INC  R1
                BR   SBT_NextChar

1237$:          RETURN
#----------------------------------------------------------------------------}}}

LoadMusic:
        RETURN
TitleMusicRestart:
        MOV  $TitleMusic,-(SP)
        BR   MusicRestart
IntroMusicRestart:
        MOV  $IntroMusic,-(SP)
        BR   MusicRestart
LevelMusicRestart:
        MOV  $LevelMusic,-(SP)
        BR   MusicRestart
BossMusicRestart:
        MOV  $BossMusic,-(SP)
        BR   MusicRestart
MusicRestart: #--------------------------------------------------------------{{{
        # don't call PLY_AKG_Play on VblankInt
        MOV  $0000401,@$MusicPlayerCall # BR .+4
        CALL PLY_AKG_Stop

        CLR  R0 # Subsong0
        MOV  (SP)+,R5
        CALL PLY_AKG_Init
      # call PLY_Play on VblankInt
        MOV  $0004737,@$MusicPlayerCall # CALL @(PC)+

        RETURN
#----------------------------------------------------------------------------}}}
MusicStop: #-----------------------------------------------------------------{{{
      # don't call PLY_Play on VblankInt
        MOV  $0000401,@$MusicPlayerCall # BR .+4
        CALL PLY_AKG_Stop

        RETURN
#----------------------------------------------------------------------------}}}
PlaySoundEffect1: # player fire
        MOV  $1,R0 # R0 contains sound effect number (>0!)
        CLR  $0,R1 # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
PlaySoundEffect2: # enemy fire
        MOV  $2,R0 # R0 contains sound effect number (>0!)
        MOV  $1,R1 # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
PlaySoundEffect3: # enemy dead
        MOV  $3,R0 # R0 contains sound effect number (>0!)
        MOV  $1,R1 # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
PlaySoundEffect4: # player dead
        MOV  $4,R0 # R0 contains sound effect number (>0!)
        CLR  $R1   # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
PlaySoundEffect5: # smartbomb
        MOV  $5,R0 # R0 contains sound effect number (>0!)
        MOV  $2,R1 # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
PlaySoundEffect6: # coin
        MOV  $6,R0 # R0 contains sound effect number (>0!)
        MOV  $2,R1 # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
PlaySoundEffect7: # powerup
        MOV  $7,R0 # R0 contains sound effect number (>0!)
        MOV  $2,R1 # The channel where to play the sound effect (0, 1, 2)
        CLR  R2    # Inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect

# IN: R0 A = Sound effect number (>0!).
#     R1 C = The channel where to play the sound effect (0, 1, 2).
#     R2 B = Inverted volume (0 = full volume, 16 = no sound). Hardware sounds are also lowered.
PrintDebugInfo: #------------------------------------------------------------{{{
        PUSH @$PASWCR
        # enable write-only direct access to the RAM above 0100000
    .if OffscreenAreaAddr < 0120000     # 0100000..0117777
        MOV  $0x011,@$PASWCR
    .elseif OffscreenAreaAddr < 0140000 # 0120000..0137777
        MOV  $0x021,@$PASWCR
    .elseif OffscreenAreaAddr < 0160000 # 0140000..0157777
        MOV  $0x041,@$PASWCR
    .else                               # 0160000..0176777
        MOV  $0x081,@$PASWCR
    .endif

        MOV  $PBPADR,R5

        MOV  $5,R0   # set R0 to number of decimal digits
        MOV  $LevelTimeStr,R1
        ADD  R0,R1   # set pointer to end of the string
        MOV  $PPU_Event_LevelTime,(R5)
        MOV  @$PBP12D,R3

10$:    CLR  R2      # R2 - most, R3 - least significant word
        DIV  $10,R2  # quotient -> R2 , remainder -> R3
        ADD  $'0,R3  # add ASCII code for "0" to the remainder
        MOVB R3,-(R1)
        MOV  R2,R3
        SOB  R0,10$

        MOV  $5,R0
        MOV  $CGAFontBitmap,R1
        MOV  $40,R2
        MOV  $LevelTimeStrEnd,R3
20$:
        MOV  $OffscreenAreaAddr-1,R5
        ADD  R0,R5

        MOVB -(R3),R4
        ASL  R4
        ASL  R4
        ASL  R4
        ADD  R1,R4 # R4 contains font char address

       .rept 8
        MOVB (R4)+,(R5)
        ADD  R2,R5
       .endr

        SOB  R0,20$

        POP  @$PASWCR

        RETURN
LevelTimeStr:   .ascii "12345"
LevelTimeStrEnd:
       .even


#----------------------------------------------------------------------------}}}
Debug_PrintAt: #-------------------------------------------------------------{{{
        MOV  $PBP12D,R4
        MOV  $PBPADR,R5
        CLC
        ROR  R0
        MOV  R0,(R5)
        ROL  R0
        INC  R0
        INC  R0
        MOV  (R4),R1
        MOVB R1,@$Debug_CurrentChar
        SWAB R1
        MOVB R1,@$Debug_CurrentLine
        BR   Debug_Print
#----------------------------------------------------------------------------}}}
Debug_Print: #---------------------------------------------------------------{{{
       #MTPS $PR7
        PUSH @$PASWCR
      # enable write-only direct access to the RAM above 0100000
    .if OffscreenAreaAddr < 0120000     # 0100000..0117777
        MOV  $0x011,@$PASWCR
    .elseif OffscreenAreaAddr < 0140000 # 0120000..0137777
        MOV  $0x021,@$PASWCR
    .elseif OffscreenAreaAddr < 0160000 # 0140000..0157777
        MOV  $0x041,@$PASWCR
    .else                               # 0160000..0176777
        MOV  $0x081,@$PASWCR
    .endif

       .equiv Debug_LineWidth, 40
       .equiv Debug_TextLinesCount, 10
       .equiv Debug_CharHeight, 8
       .equiv Debug_CharLineSize, Debug_LineWidth * Debug_CharHeight
       .equiv Debug_FbStart, OffscreenAreaAddr
       .equiv Debug_Font, CGAFontBitmap # - (32 * 8)

        MOV  $Debug_LineWidth,R2
        MOV  $StrBuffer,R3
        MOV  $PBP12D,R4
        MOV  $PBPADR,R5

        CLC
        ROR  R0
        MOV  R0,(R5)  # load address of a string into address register

Debug_LoadNext2Bytes:
        MOV  (R4),R0  # load 2 bytes from CPU RAM
        MOV  R0,(R3)+ # store them into buffer
        TSTB R0       #
        BZE  3$       # end of text
        BMI  2$       # end of string
        SWAB R0       # swap bytes to test most significant one
        TSTB R0       #
        BZE  3$       # end of text
        BMI  2$       # end of string
        INC  (R5)     # next address
        BR   Debug_LoadNext2Bytes

2$:     INC  (R5)
        MOV  (R5),@$Debug_NextStringAddr

3$:     MOV  @$Debug_CurrentLine,R1 # prepare to calculate relative char address
        MUL  $Debug_CharLineSize,R1 # calculate relative address of the line
        ADD  @$Debug_CurrentChar,R1 # calculate relative address of the char
        ADD  $Debug_FbStart,R1      # calculate absolute address of the next char

        MOV  $StrBuffer,R3
Debug_NextChar:
        MOV  R1,R5        #
        MOVB (R3)+,R0     # load character code from string buffer
        TSTB R0           #
        BZE  Debug_DonePrinting # end of text
        BMI  Debug_NextString   # end of string
        CMPB $'\n, R0           # new line?
        BEQ  Debug_NewLine      #

        ASH  $3,R0          # shift left by 3(multiply by 8)
        ADD  $Debug_Font,R0 # calculate char bitmap address

       .rept 8
        MOVB (R0)+,(R5)
        ADD  R2, R5
       .endr

        INC  R1
       .equiv Debug_CurrentChar, .+2
        INC  $0x00
        CMP  @$Debug_CurrentChar,R2 # end of screen line? (R2 == 40)
        BNE  Debug_NextChar         # no, print another character
Debug_NewLine:
        CLR  @$Debug_CurrentChar
       .equiv Debug_CurrentLine, .+2
        INC  $0x00
        CMP  @$Debug_CurrentLine,$Debug_TextLinesCount # next line out of screen?
        BNE  Debug_Recalculate   # no, recalculate screen address
        CLR  @$Debug_CurrentLine # yes, print from the beginning
Debug_Recalculate:
        MOV  @$Debug_CurrentLine,R1 #
        MUL  $Debug_CharLineSize,R1 # calculate relative line address
        ADD  @$Debug_CurrentChar,R1 # calculate relative char dst address
        ADD  $Debug_FbStart,R1      # calculate screen address of the next char
        BR   Debug_NextChar

Debug_NextString:
        MOV  $StrBuffer,R3
        MOV  $PBP12D,R4
        MOV  $PBPADR,R5
       .equiv Debug_NextStringAddr, .+2
        MOV  $0x0000,(R5);
        MOV  (R4),R0
        MOVB R0,@$Debug_CurrentChar
        SWAB R0
        MOVB R0,@$Debug_CurrentLine
        INC  (R5)
        BR   Debug_LoadNext2Bytes

Debug_DonePrinting:
        POP  @$PASWCR
       #MTPS $PR0
        RETURN
#----------------------------------------------------------------------------}}}

VblankIntHandler: #----------------------------------------------------------{{{
      # we disabling "single process mode" to load data from disk only,
      # and to avoid random disk loading issues, we disabling our
      # Vblank handler as well
        TST  @$SingleProcessFlag
        BZE  SkipToFirmwareHandler

        MOV  @$PBPADR,-(SP)
        MOV  R5,-(SP)
        MOV  R4,-(SP)
        MOV  R3,-(SP)
        MOV  R2,-(SP)
        MOV  R1,-(SP)
        MOV  R0,-(SP)

    .ifdef DebugMode
        MTPS $PR7
        CALL @$PrintDebugInfo
        MTPS $PR0
    .endif

MusicPlayerCall:
        BR   .+4 # or CALL @(PC)+ when music is playing
       .word PLY_AKG_Play

        CALL PLY_SE_PlaySoundEffectsStream

        MOV  (SP)+,R0
        MOV  (SP)+,R1
        MOV  (SP)+,R2
        MOV  (SP)+,R3
        MOV  (SP)+,R4
        MOV  (SP)+,R5
        MOV  (SP)+,@$PBPADR

SkipToFirmwareHandler:
        # we do not need firmware interrupt handler except for this small
        # procedure
        TST  @$07130 # is floppy drive spindle rotating?
        BZE  1237$   # no
        DEC  @$07130 # decrease spindle rotation counter
        BNZ  1237$   # continue rotation unless the counter reaches zero
        CALL @07132  # stop floppy drive spindle

1237$:  RTI
#----------------------------------------------------------------------------}}}
KeyboardIntHadler: #---------------------------------------------------------{{{
# key codes #-----------------------------------------------------{{{
# | oct | hex|  key    | note     | oct | hex|  key  |  note     |
# |-----+----+---------+----------+-----+----+-------+-----------|
# |   5 | 05 | ,       | NumPad   | 106 | 46 | АЛФ   | Alphabet  |
# |   6 | 06 | АР2     | Esc      | 107 | 47 | ФИКС  | Lock      |
# |   7 | 07 | ; / +   |          | 110 | 48 | Ч / ^ |           |
# |  10 | 08 | К1 / К6 | F1 / F6  | 111 | 49 | С / S |           |
# |  11 | 09 | К2 / К7 | F2 / F7  | 112 | 4A | М / M |           |
# |  12 | 0A | КЗ / К8 | F3 / F8  | 113 | 4B | SPACE |           |
# |  13 | 0B | 4 / ¤   |          | 114 | 4C | Т / T |           |
# |  14 | 0C | К4 / К9 | F4 / F9  | 115 | 4D | Ь / X |           |
# |  15 | 0D | К5 / К10| F5 / F10 | 116 | 4E | ←     |           |
# |  16 | 0E | 7 / '   |          | 117 | 4F | , / < |           |
# |  17 | 0F | 8 / (   |          | 125 | 55 | 7     | NumPad    |
# |  25 | 15 | -       | NumPad   | 126 | 56 | 0     | NumPad    |
# |  26 | 16 | ТАБ     | Tab      | 127 | 57 | 1     | NumPad    |
# |  27 | 17 | Й / J   |          | 130 | 58 | 4     | NumPad    |
# |  30 | 18 | 1 / !   |          | 131 | 59 | +     | NumPad    |
# |  31 | 19 | 2 / "   |          | 132 | 5A | ЗБ    | Backspace |
# |  32 | 1A | 3 / #   |          | 133 | 5B | →     |           |
# |  33 | 1B | Е / E   |          | 134 | 5C | ↓     |           |
# |  34 | 1C | 5 / %   |          | 135 | 5D | . / > |           |
# |  35 | 1D | 6 / &   |          | 136 | 5E | Э / \ |           |
# |  36 | 1E | Ш / [   |          | 137 | 5F | Ж / V |           |
# |  37 | 1F | Щ / ]   |          | 145 | 65 | 8     | NumPad    |
# |  46 | 26 | УПР     | Ctrl     | 146 | 66 | .     | NumPad    |
# |  47 | 27 | Ф / F   |          | 147 | 67 | 2     | NumPad    |
# |  50 | 28 | Ц / C   |          | 150 | 68 | 5     | NumPad    |
# |  51 | 29 | У / U   |          | 151 | 69 | ИСП   | Execute   |
# |  52 | 2A | К / K   |          | 152 | 6A | УСТ   | Settings  |
# |  53 | 2B | П / P   |          | 153 | 6B | ВВОД  | Enter     |
# |  54 | 2C | H / N   |          | 154 | 6C | ↑     |           |
# |  55 | 2D | Г / G   |          | 155 | 6D | : / * |           |
# |  56 | 2E | Л / L   |          | 156 | 6E | Х / H |           |
# |  57 | 2F | Д / D   |          | 157 | 6F | З / Z |           |
# |  66 | 36 | ГРАФ    | Graph    | 165 | 75 | 9     | NumPad    |
# |  67 | 37 | Я / Q   |          | 166 | 76 | ВВОД  | NumPad    |
# |  70 | 38 | Ы / Y   |          | 167 | 77 | 3     | NumPad    |
# |  71 | 39 | В / W   |          | 170 | 78 | 7     | NumPad    |
# |  72 | 3A | А / A   |          | 171 | 79 | СБРОС | Reset     |
# |  73 | 3B | И / I   |          | 172 | 7A | ПОМ   | Help      |
# |  74 | 3C | Р / R   |          | 173 | 7B | / / ? |           |
# |  75 | 3D | О / O   |          | 174 | 7C | Ъ / } |           |
# |  76 | 3E | Б / B   |          | 175 | 7D | - / = |           |
# |  77 | 3F | Ю / @   |          | 176 | 7E | О / } |           |
# | 105 | 45 | HP      | Shift    | 177 | 7F | 9 / ) |           |
#-----------------------------------------------------------------}}}
        MOV  R0,-(SP)
        MOV  @$PBPADR,-(SP)

        MOV  $PPU_KeyboardScanner_P1,@$PBPADR

        MOVB @$KBDATA,R0
        BMI  key_released$

    key_pressed$: #------------------
        CMPB R0,$070  # Y
        BEQ  fire_right_pressed$

        CMPB R0,$047  # F
        BEQ  fire_left_pressed$

        CMPB R0,$0134 # Down
        BEQ  down_pressed$

        CMPB R0,$0154 # Up
        BEQ  up_pressed$

        CMPB R0,$0133 # Right
        BEQ  right_pressed$

        CMPB R0,$0116 # Left
        BEQ  left_pressed$

        CMPB R0,$046  # УПР
        BEQ  fire_smartbomb_pressed$

        CMPB R0,$015  # К5
        BEQ  pause_pressed$

        BR   1237$
    #--------------------------------
    key_released$: #-----------------
        CMPB R0,$0210  # Y
        BEQ  fire_right_released$

        CMPB R0,$0207  # F
        BEQ  fire_left_released$

        CMPB R0,$0214 # Up? or Down?
        BNE  not_up_down$

        BITB @$PBP12D,$1
        BZE  up_released$
        BR   down_released$

    not_up_down$:
        CMPB R0,$0213 # Right
        BEQ  right_released$

        CMPB R0,$0216 # Left
        BEQ  left_released$

        CMPB R0,$0206  # УПР
        BEQ  fire_smartbomb_released$

        CMPB R0,$0215  # К5
        BEQ  pause_released$

        BR   1237$
    #--------------------------------
    down_pressed$: #-----------------
        MOV  $0x01,R0
        BR   set_bit$
    up_pressed$:
        MOV  $0x02,R0
        BR   set_bit$
    right_pressed$:
        MOV  $0x04,R0
        BR   set_bit$
    left_pressed$:
        MOV  $0x08,R0
        BR   set_bit$
    fire_right_pressed$:
        MOV  $0x10,R0
        BR   set_bit$
    fire_left_pressed$:
        MOV  $0x20,R0
        BR   set_bit$
    fire_smartbomb_pressed$:
        MOV  $0x40,R0
        BR   set_bit$
    pause_pressed$:
        MOV  $0x80,R0
        BR   set_bit$
    #--------------------------------
    down_released$: #----------------
        MOV  $0x01,R0
        BR   clear_bit$
    up_released$:
        MOV  $0x02,R0
        BR   clear_bit$
    right_released$:
        MOV  $0x04,R0
        BR   clear_bit$
    left_released$:
        MOV  $0x08,R0
        BR   clear_bit$
    fire_right_released$:
        MOV  $0x10,R0
        BR   clear_bit$
    fire_left_released$:
        MOV  $0x20,R0
        BR   clear_bit$
    fire_smartbomb_released$:
        MOV  $0x40,R0
        BR   clear_bit$
    pause_released$:
        MOV  $0x80,R0
        BR   clear_bit$
    #--------------------------------
    set_bit$:
        BIS  R0,@$PBP12D
        BR   1237$
    clear_bit$:
        BIC  R0,@$PBP12D

1237$:
        MOV  (SP)+,@$PBPADR
        MOV  (SP)+,R0
        RTI
#----------------------------------------------------------------------------}}}
Channel0In_IntHandler: #----------------------------------------------------------{{{
        MOV  @$PBPADR,-(SP)
        MOV  R5,-(SP)
       #MOV  R4,-(SP)
       #MOV  R3,-(SP)
       #MOV  R2,-(SP)
       #MOV  R1,-(SP)
       #MOV  R0,-(SP)

        MOV  @$CommandsQueue_CurrentPosition,R5
        CMP  R5,$CommandsQueue_Top
        BLOS CommandsQueue_Full
        MOV  $PPU_PPUCommandArg,@$PBPADR
        MOV  @$PBP12D,-(R5)
        MOV  @$PCH0ID,-(R5)
        MOV  R5,@$CommandsQueue_CurrentPosition

       #MOV  (SP)+,R0
       #MOV  (SP)+,R1
       #MOV  (SP)+,R2
       #MOV  (SP)+,R3
       #MOV  (SP)+,R4
        MOV  (SP)+,R5
        MOV  (SP)+,@$PBPADR

        RTI
CommandsQueue_Full:
        BR   .
        NOP
        MOV  (SP)+,R5
        MOV  (SP)+,@$PBPADR
        RTI

#----------------------------------------------------------------------------}}}
Channel0Out_IntHandler: #------------------------------------------------------------------
        RTI

       .include "music/ep1_title_music_playerconfig.s"
       .include "music/ep1_intro_music_playerconfig.s"
       .include "music/ep1_level_music_playerconfig.s"
       .include "music/ep1_boss_music_playerconfig.s"
       .include "music/ep1_sfx_playerconfig.s"
       .include "../../akg_player/akg_player.s"
       .include "../../akg_player/player_sound_effects.s"

TitleMusic: .include "build/ep1_title_music.formatted.s"
IntroMusic: .include "build/ep1_intro_music.formatted.s"
LevelMusic: .include "build/ep1_level_music.formatted.s"
BossMusic:  .include "build/ep1_boss_music.formatted.s"
SoundEffects: .include "music/ep1_sfx.s"

FontBitmap: .space 8 # whitespace symbol
            .incbin "resources/font.raw"
CGAFontBitmap: .incbin "resources/cga8x8b.raw"

SYS100:  .word 0174612 # firmware vertical blank interrupt handler
SYS272:  .word 02270   # default scanlines table
SYS300:  .word 0175412 # firmware keyboard interrupt handler
SYS320:  .word 0175700 # firmware PPU channel 0 in  interrupt handler
SYS324:  .word 0175700 # firmware PPU channel 0 out interrupt handler

FBSLTAB: .word 0          # adrress of main screen SLTAB
FirstLineAddress: .word 0 #

CommandsQueue_Top:
       .space 2*2*16
CommandsQueue_Bottom:
CommandsQueue_CurrentPosition: .word CommandsQueue_Bottom
StrBuffer:
.asciz "aslkdhflksahfdksa"
       .even
end:
       .nolist
