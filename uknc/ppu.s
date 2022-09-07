               .nolist

               .title Chibi Akumas PPU module

               .global start # make the entry point available to a linker
               .global PPU_ModuleSize
               .global PPU_ModuleSizeWords

               .include "./macros.s"
               .include "./hwdefs.s"
               .include "./core_defs.s"

               .equiv  PPU_ModuleSize, (end - start)
               .equiv  PPU_ModuleSizeWords, PPU_ModuleSize >> 1

               .=PPU_UserRamStart

start:
        MTPS $PR7
      # bit 0 if clear disables ROM chip in range 0100000..0117777
      #       which allows to enable RW access to RAM in that range
      #       when bit 4 is set as well
      # bits 1-3 used to select ROM cartridge banks
      # bit 4 replaces ROM in range 0100000..0117777 with RAM, see bit 0
      # bit 5 replaces ROM in range 0120000..0137777 with write only RAM
      # bit 6 replaces ROM in range 0140000..0157777 with write only RAM
      # bit 7 replaces ROM in range 0160000..0176777 with write only RAM
      # bit 8 enables PPU Vblank interrupt when clear, disables when set
      # bit 9 enables CPU Vblank interrupt when clear, disables when set
      #
      # WARNING: since there is no way to disable ROM chips in range
      # 0120000..0176777, we can only write to the RAM in that range.
      # **But** UKNCBL emulator allows to read from the RAM as well!
      # **Beware** this is **not** how the real hardware behaves!
        MOV  $0x0F0,@$PASWCR
#-------------------------------------------------------------------------------
        MOV  $88*2,R0
        MOV  $OffscreenAreaAddr,R5
        1$:
           .rept 10
            CLR  (R5)+
           .endr
        SOB  R0,1$

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
SLTABInit:
        MOV  $SLTAB,R0       # set R0 to beginning of SLTAB
        MOV  R0,R1           # R0 address of current record (2)

        MOV  $15,R2          #  records 2..16 are same
1$:     CLR  (R0)+           #--addresses of lines 2..16
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

        MOV  R0,@$TopAreaColors # store the address for future use
        MOV  $0xBA90,(R0)+   # colors  011  010  001  000 (YRGB)
        MOV  $0xFEDC,(R0)+   # colors  111  110  101  100 (YRGB)
        CLR  (R0)+           #--address of line 19
        BIC  $0b110,R1       #  next record is 2-word
        ADD  $8,R1           #  calculate pointer to next record
        MOV  R1,(R0)+        #--pointer to the record 20
#------------------------------------- top region, header
        MOV  $OffscreenAreaAddr,R2 # scanlines 20..307 are visible
        MOV  $43,R3          #
2$:     MOV  R2,(R0)+        #--address of screenline
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

        MOV  R0,@$FBSLTAB   #
        SUB  $2,@$FBSLTAB   #

        MOV  $0b10000,(R0)+  #--cursor settings: graphical cursor
        MOV  $0b10111,(R0)+  #  320 dots per line, pallete 7
        MOV  R2,(R0)+        #--address of a screenline
        ADD  $8,R1           #  calc address of next record of SLTAB
        BIS  $0b110,R1       #  next record is 4-word, color settings
        MOV  R1,(R0)+        #--pointer to record 64

        MOV  R0,@$FirstMainScreenLinePointer
        ADD  $4,@$FirstMainScreenLinePointer
#----------------------------- main screen area
        MOV  $FB1 >> 1,R2    # address of second frame-buffer
        MOV  $200,R3         # number of lines on main screen area
3$:     MOV  $0x0000,(R0)+   #  colors  011  010  001  000 (YRGB)
        MOV  $0x0000,(R0)+   #  colors  111  110  101  100 (YRGB)
        MOV  R2,(R0)+        #--main RAM address of a scanline
        ADD  $8,R1           #  calc address of next record of SLTAB
        MOV  R1,(R0)+        #--pointer to the next record of SLTAB
        ADD  $40,R2          #  calculate address of next screenline

        SOB  R3,3$           #
#------------------------------------- bottom region, footer
        MOV  R0,@$BottomAreaColors # store the address for future use
        MOV  $0xBA90,(R0)+   # colors  011  010  001  000 (YRGB)
        MOV  $0xFEDC,(R0)+   # colors  111  110  101  100 (YRGB)
        MOV  $OffscreenAreaAddr+03340+40,R2  #
        MOV  R2,(R0)+        #
        ADD  $40,R2          # calculate address of next screenline
        ADD  $8,R1           # calculate pointer to next record
        BIC  $0b110,R1       # next record consists of 2 words
        MOV  R1,(R0)+        #--set address of record 265

        MOV  $42,R3          #
4$:     MOV  R2,(R0)+        #--address of a screenline
        ADD  $4,R1           #  calc address of next record of SLTAB
        MOV  R1,(R0)+        #--pointer to the next record of SLTAB
        ADD  $40,R2          # calculate address of next screenline

        SOB  R3,4$           #
                             #
        CLR  (R0)+           #--address of line 308
        MOV  R1,(R0)         #--pointer back to record 308
#----------------------------------------------------------------------------}}}
        MOV  $0x001,@$PASWCR
#-------------------------------------------------------------------------------
        MOV  $SLTAB, @$0272   # use our SLTAB

        MOV  $SoundEffects,R5
        CALL PLY_SE_InitSoundEffects

        MOV  $VblankIntHandler,@$0100
        MOV  $KeyboardIntHadler,@$KBINT
        MOV  $Channel0In_IntHandler,@$PCH0II
      # read from the channel, just in case
        TST  @$PCH0ID

        MOV  $Channel1In_IntHandler,@$PCH1II
        BIS  $Ch1StateInInt,@$PCHSIS
      # read from the channel, just in case
        TST  @$PCH1ID

      # Aberrant Sound Module detection
        MOV  $PSG0+16,R1
        MOV  $PSG1,R2
        MOV  $Trap4,@$4
      # Aberrant Sound Module uses addresses range 0177360-0177377
      # 16 addresses in total
        MOV  $8,R0 # 8 even addresses
        TestNextSoundBoardAddress:
            TST  -(R1)
        SOB  R0,TestNextSoundBoardAddress
      # R1 now contains 0177360, address of PSG0

        TST  @$Trap4Detected
        BZE  PSGPresent

        CLR  @$Trap4Detected
        MOV  $DummyPSG,R1
        MOV  R1,R2
PSGPresent:
        MOV  R1,@$PLY_AKG_PSGAddress
        MOV  R2,@$PLY_SE_PSGAddress
       #MOV  $0173362,@$4 # restore back trap 4 handler

      # inform bootstrap that PPU is ready to receive commands
        MOV  $CPU_PPUCommandArg,@$PBPADR
        CLR  @$PBP12D

        MTPS $PR0
#-------------------------------------------------------------------------------
Queue_Loop:
        MOV  @$CommandsQueue_CurrentPosition,R5
        CMP  R5,$CommandsQueue_Bottom
        BEQ  Queue_Loop

        MOV  (R5)+,R1
        MOV  (R5)+,R0
        MOV  R5,@$CommandsQueue_CurrentPosition
    .ifdef DebugMode
        CMP  R1,$PPU_LastJMPTableIndex
        BHI  .
    .endif
        CALL @CommandVectors(R1)
        BR   Queue_Loop
#-------------------------------------------------------------------------------
CommandVectors:
       .word LoadDiskFile
       .word SetPalette            # PPU_SetPalette
       .word Print                 # PPU_Print
       .word PrintAt               # PPU_PrintAt
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
       .word StartANewGame
       .word LevelStart
       .word LevelEnd
       .word Player_DrawUI         # PPU_DrawPlayerUI
#-------------------------------------------------------------------------------
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
SetPalette_NextRecord:
        MOV  R4,R3        # R3 = previous iteration's next line
        MOV  R3,R5        # prepare to calculate address of SLTAB section to modify
        ASH  $3,R5        # calculate offset by multiplying by 8 (by shifting R5 left by 3 bits)
       .equiv FBSLTAB, .+2
        ADD  $0,R5        # and add address of SLTAB section we modify

        MOVB @$PBP2DT,R2         # get display/color parameters flag
        BMI  SetPalette_Finalize # negative value - terminator

        INC  @$PBPADR
        MOV  @$PBP12D,R0     # get first data word
        INC  @$PBPADR
        MOV  @$PBP12D,R1     # get second data word
        INC  @$PBPADR
        CLR  R4
        BISB @$PBP1DT,R4     # get next line idx

        CMP  R2,$2
        BEQ  SetPalette_OffscreenColors
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
        BNE  SetPalette_NextRecord
        BR   SetPalette_Finalize

SetPalette_OffscreenColors:
       .equiv TopAreaColors, .+2
        MOV  $0,R2
        MOV  R0,(R2)+
        MOV  R1,(R2)
       .equiv BottomAreaColors, .+2
        MOV  $0,R2
        MOV  R0,(R2)+
        MOV  R1,(R2)
        BR   SetPalette_NextRecord

SetPalette_Finalize:
        POP  @$PASWCR

        RETURN
#----------------------------------------------------------------------------}}}
SetOffscreenAreaColors: # ---------------------------------------------------{{{
        PUSH @$PASWCR
        MOV  $0x010,@$PASWCR

       #CLC
       #ROR  R0
       #MOV  R0,@$PBPADR # palette address
       #MOV  $PBPADR,R5
       #MOV  $PBP12D,R4
       #MOV  R0,(R5)

       #MOV  (R4),R1
       #INC  (R5)
       #MOV  (R4),R2
       #equiv TopAreaColors, .+2
       #MOV  $0,R3
       #MOV  R1,(R3)+
       #MOV  R2,(R3)
       #equiv BottomAreaColors, .+2
       #MOV  $0,R3
       #MOV  R1,(R3)+
       #MOV  R2,(R3)

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
        MOV  $0b001,@$PBPMSK # disable writes to bitplane 0

        CLC
        ROR  R0
        MOV  R0,(R5)  # load address of a string into address register

LoadNext2Bytes:
        MOV  (R4),R0  # load 2 bytes from CPU RAM
        MOV  R0,(R3)+ # store them into buffer
        BZE  3$       # end of text
        BMI  2$       # end of string

        SWAB R0       # swap bytes to test most significant one
        BZE  3$       # end of text
        BMI  2$       # end of string

        INC  (R5)     # next address
        BR   LoadNext2Bytes

2$:     INC  (R5)
        MOV  (R5),@$NextStringAddr

3$:     MOV  @$CurrentLine,R1 # prepare to calculate relative char address
        MUL  $CharLineSize,R1 # calculate relative address of the line
        ADD  @$CurrentChar,R1 # calculate relative address of the char
        ADD  $FbStart,R1      # calculate absolute address of the next char

        MOV  $StrBuffer,R3
        MOV  $BPDataReg,R4
NextChar:
        MOV  R1,(R5)      # load address of the next char into address register
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
       .equiv CurrentChar, .+2
        INC  $0
        CMP  @$CurrentChar,R2 # end of screen line? (R2 == 40)
        BNE  NextChar         # no, print another character
NewLine:
        CLR  @$CurrentChar
       .equiv CurrentLine, .+2
        INC  $0
        CMP  @$CurrentLine,$TextLinesCount # next line out of screen?
        BNE  Recalculate   # no, recalculate screen address
        CLR  @$CurrentLine # yes, print from the beginning

Recalculate:
        MOV  @$CurrentLine,R1 #
        MUL  $CharLineSize,R1 # calculate relative line address
        ADD  @$CurrentChar,R1 # calculate relative char dst address
        ADD  $FbStart,R1      # calculate screen address of the next char
        MOV  R1,(R5)          # load screen address of the next char to address register
        BR   NextChar

NextString:
        MOV  $StrBuffer,R3
       .equiv NextStringAddr, .+2
        MOV  $0,(R5)
        MOV  $PBP12D,R4
        MOV  (R4),R0
        MOVB R0,@$CurrentChar
        SWAB R0
        MOVB R0,@$CurrentLine
        INC  (R5)
        BR   LoadNext2Bytes

DonePrinting:
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
        100$:
            MOV  (R4),R0  # load 2 bytes from CPU RAM
            MOV  R0,(R3)+ # store them into the buffer
            BZE  1237$    # end of the text

            SWAB R0       # swap bytes to test most significant one
            BZE  1237$    # end of the text

            INC  (R5)     # next address
        BR   100$

1237$:  RETURN
#----------------------------------------------------------------------------}}}
ShowBossText: #--------------------------------------------------------------{{{
        MOV  $10<<1,@$DTSCOL # foreground color
        MOV  $LineWidth,R2
        MOV  $StrBuffer,R3
        MOV  $PBP12D,R4
        MOV  $PBPADR,R5

        MOV  R0,@$CharsToPrint
        MOV  $DTSOCT,R4
        MOV  $0b001,@$PBPMSK # disable writes to bitplane 0

SBT_NextTextLine:
        MOVB (R3)+,R0
        ADD  $FbStart,R0

        MOVB (R3)+,R1
        MUL  $CharLineSize,R1
        ADD  R0,R1

SBT_NextChar:
       .equiv CharsToPrint, .+2
        DEC  $0xFF
        BZE  1237$

        MOV  R1,(R5)      # load address of the next char into address register
        MOVB (R3)+,R0     # load character code from string buffer
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

1237$:  RETURN
#----------------------------------------------------------------------------}}}
LoadMusic: #-----------------------------------------------------------------{{{
        RETURN
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
        BZE  3$       # end of text
        BMI  2$       # end of string

        SWAB R0       # swap bytes to test most significant one
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
TitleMusicRestart: #---------------------------------------------------------{{{
        MOV  $TitleMusic,-(SP)
        BR   MusicRestart
#----------------------------------------------------------------------------}}}
IntroMusicRestart: #---------------------------------------------------------{{{
        MOV  $IntroMusic,-(SP)
        BR   MusicRestart
#----------------------------------------------------------------------------}}}
LevelMusicRestart: #---------------------------------------------------------{{{
        MOV  $LevelMusic,-(SP)
        BR   MusicRestart
#----------------------------------------------------------------------------}}}
BossMusicRestart: #----------------------------------------------------------{{{
        MOV  $BossMusic,-(SP)
        BR   MusicRestart
#----------------------------------------------------------------------------}}}
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
        MOV  $0,R0
        CALL PLY_SE_StopSoundEffectFromChannel
        MOV  $1,R0
        CALL PLY_SE_StopSoundEffectFromChannel
        MOV  $2,R0
        CALL PLY_SE_StopSoundEffectFromChannel

        RETURN
#----------------------------------------------------------------------------}}}
PlaySoundEffect1: # player fire #--------------------------------------------{{{
        MOV  $1,R0 # effect number, starts from 1
        CLR  R1    # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
PlaySoundEffect2: # enemy fire #---------------------------------------------{{{
        MOV  $2,R0 # effect number, starts from 1
        MOV  $1,R1 # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
PlaySoundEffect3: # enemy dead #---------------------------------------------{{{
        MOV  $3,R0 # effect number, starts from 1
        MOV  $1,R1 # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
PlaySoundEffect4: # player dead #--------------------------------------------{{{
        MOV  $4,R0 # effect number, starts from 1
        CLR  R1    # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
PlaySoundEffect5: # smartbomb #----------------------------------------------{{{
        MOV  $5,R0 # effect number, starts from 1
        CLR  R1 # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
PlaySoundEffect6: # coin #---------------------------------------------------{{{
        MOV  $6,R0 # effect number, starts from 1
        MOV  $2,R1 # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
PlaySoundEffect7: # powerup #------------------------------------------------{{{
        MOV  $7,R0 # effect number, starts from 1
        MOV  $2,R1 # channel number 0, 1, 2
        CLR  R2    # inverted volume (0 = full volume, 16 = no sound)
        JMP  PLY_SE_PlaySoundEffect
#----------------------------------------------------------------------------}}}
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
        MOV  $CPU_Event_LevelTime,(R5)
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
StartANewGame: #-------------------------------------------------------------{{{
        MOV  $PPU_Player_ScoreBytes,R3
        CLR  (R3)+
        CLR  (R3)+
        CLR  (R3)+
        CLR  (R3)+

        RETURN
#----------------------------------------------------------------------------}}}
LevelStart: #----------------------------------------------------------------{{{
        CLR  @$P1_P03
        CLR  @$P1_P09
        CLR  @$Skip_Player_DrawUI
        CALL Player_DrawScore
        RETURN
#----------------------------------------------------------------------------}}}
LevelEnd: #------------------------------------------------------------------{{{
        MOV  $1,@$Skip_Player_DrawUI

        MOV  $PPU_Player_ScoreBytes,R3
        MOV  $PBP12D,R4
        MOV  $PBPADR,R5
        MOV  $CPU_Player_ScoreBytes,(R5)
        MOV  $4,R0
        LevelEnd_NextScoreWord:
            MOV  (R3)+,(R4)
            INC  (R5)
        SOB  R0,LevelEnd_NextScoreWord
        CALL ClrTextArea

        RETURN
#----------------------------------------------------------------------------}}}
ClrTextArea: # --------------------------------------------------------------{{{
        MOV  $88*4,R0
        MOV  $PBP0DT,R3
        MOV  $PBP12D,R4
        MOV  $PBPADR,R5
        MOV  $OffscreenAreaAddr,(R5)

        1$:
           .rept 10
            CLR  (R3)
            CLR  (R4)
            INC  (R5)
           .endr
        SOB  R0,1$

        RETURN
#----------------------------------------------------------------------------}}}
Player_DrawUI: # ------------------------------------------------------------{{{
       .equiv Skip_Player_DrawUI, .+2
        TST  $1
        BZE  Player_UpdateScore
        RETURN

Player_UpdateScore:
        MOV  $PBPADR,R5
        MOV  $PBP2DT,R4
        MOV  $CPU_P1_P13,(R5)          # ld a,(iy+13) ; points to add to the score
        TSTB (R4)                      # or a
        BZE  Player_DrawLivesIcons     # ret z ;no score to add
      # we are playing on PDP-11, so our score is base 8
        MOV  $8,R1
                                       # ld b,a
                                       # dec a
        DECB (R4)                      # dec a
        MOV  $PPU_Player_ScoreBytes,R3 # ld (iy+13),a
        MOVB (R3),R0                   # ld a,(hl)
        INCB R0                        # inc a
        MOVB R0,(R3)                   # ld (hl),a
        CMPB R0,R1                     # cp 10
        BLO  Player_DrawScore          # ret C ; return if nothing to carry

        CLR  R2
        INC  R2                        # inc c ; We've rolled into another digit.
Player_AddScore_NextDigit:

                                       # xor a
        TSTB R2                        # cp c
        BZE  Player_DrawScore          # ret z ; check if C is zero

        MOV  R0,R2                     # ld c,a
        MOVB (R3),R0                   # ld a,(hl)
        INCB R0                        # inc a
        CMPB R0,R1                     # cp 10
        BLO  Player_AddScore_Inc       # jp C,Player_AddScore_Inc
        CLR  R0                        # xor a
        INCB R2                        # inc c

Player_AddScore_Inc:
        MOVB R0,(R3)+                     # ld (hl),a
                                          # inc l
# TODO: implement Xfire related stuff
       #MOV  R3,R0                        # ld a,l
       #BIC  $0xFFF8,R0                   # and 7
       #CMP  R0,$3                        # cp 3
       #BNZ  NoBurstPower                 # jp nz,NoBurstPower
        CMP  R3,$PPU_Player_ScoreBytesEnd # add 10
        BLOS Player_AddScore_NextDigit    # jr nc,Player_AddScore_NoOverflow
                                      # Player_AddScore_NoOverflow:
                                          # ld (iy+10),a
                                      # NoBurstPower:
                                          # ld a,%00000111
                                          # or l ; repeat until we get to 8 - if so we've run out of digits
                                          # jr nz,Player_AddScore_NextDigit
                                          # ret
Player_DrawScore:
        MOV  $PBPADR,R5
        MOV  $DTSOCT,R4
        MOV  $8,R3           # number of digits
        MOV  $40,R2          # screen width, words
        MOV  $0b111,@$DTSCOL # dots color
        CLR  @$PBPMSK        # write to all bit-planes
        CLR  @$BP01BC        # background color, pixels 0-3
        CLR  @$BP12BC        # background color, pixels 4-7

        PlayerScore_Draw_NextDigit:
           .equiv ScoreLineOffset, 40*4*8 - 40*11
           .equiv ScoreLineAddr, OffscreenAreaAddr + ScoreLineOffset
            MOV  $ScoreLineAddr+8,(R5)
            SUB  R3,(R5)

            MOVB PPU_Player_ScoreBytes-1(R3),R0
            ASH  $3,R0      # shift left by 3(multiply by 8)
           .equiv FontDigitsOffset, 16*8
           .equiv FontDigitsAddr, FontBitmap + FontDigitsOffset
            ADD  $FontDigitsAddr, R0 # calculate char bitmap address

           .rept 8
            MOVB (R0)+,R1
          # MOV fills background with background color
          # MOVB preserves background
            MOV  R1,(R4)
            ADD  R2,(R5) # advance the address register to the next line
           .endr
        SOB  R3, PlayerScore_Draw_NextDigit

Player_DrawLivesIcons:
        MOV  $39,R2
        CLR  R1
        MOV  $PBPADR,R5
        MOV  $CPU_P1_P09,(R5) # lives
        MOV  $PBP2DT,R4
        MOVB (R4),R0
        BZE  Player_RemoveHitpointIcon

       .equiv P1_P09, .+2
        CMP  R0,$0
        BEQ  Player_DrawSmartbomsIcons # number of lives not changed

        MOV  R0,@$P1_P09
        MOV  $PBP0DT,R4
        DrawNextHitpointIcon:
            MOV  $HitpointIcon,R3
            MOV  $HitpointIconPosition,(R5)
            ADD  R1,(R5)
            CALL DrawIcon
            INC  R1
            INC  R1
        SOB  R0,DrawNextHitpointIcon

Player_RemoveHitpointIcon:
        MOV  $16,R3
        MOV  $HitpointIconPosition,(R5)
        ADD  R1,(R5)
        CALL ClearIcon

Player_DrawSmartbomsIcons:
        CLR  R1
        MOV  $CPU_P1_P03,(R5) # smartbombs
        MOV  $PBP2DT,R4
        MOVB (R4),R0
        BZE  Player_RemoveSmartbombIcon

       .equiv P1_P03, .+2
        CMP  R0,$0
        BEQ  1237$ # number of smartbombs not changed

        MOV  R0,@$P1_P03
        MOV  $PBP0DT,R4
        DrawNextSmartbombIcon:
            MOV  $SmartbombIcon,R3
            MOV  $SmartbombIconPosition,(R5)
            SUB  R1,(R5)
            CALL DrawIcon
            INC  R1
            INC  R1
        SOB  R0,DrawNextSmartbombIcon

Player_RemoveSmartbombIcon:
        MOV  $16,R3
        MOV  $SmartbombIconPosition,(R5)
        SUB  R1,(R5)
        CALL ClearIcon

1237$:  RETURN

DrawIcon:
       .rept 16
        MOV  (R3)+,(R4)+
        MOV  (R3)+,(R4)
        TST  -(R4) # decrease R4 by 2
        INC  (R5)

        MOV  (R3)+,(R4)+
        MOV  (R3)+,(R4)
        TST  -(R4) # decrease R4 by 2
        ADD  R2,(R5)
       .endr
        RETURN

ClearIcon:
        MOV  $PBP0DT,R4
        ClearIcon_Loop:
            CLR  (R4)+
            CLR  (R4)
            TST  -(R4) # decrease R4 by 2
            INC  (R5)

            CLRB (R4)+
            INC  R4
            CLR  (R4)
            TST  -(R4) # decrease R4 by 2
            ADD  R2,(R5)
        SOB  R3,ClearIcon

        RETURN

.equiv HitpointIconPosition, OffscreenAreaAddr + 40 * 29
.equiv SmartbombIconPosition, OffscreenAreaAddr + 40 * 29 + 38
#----------------------------------------------------------------------------}}}
LoadDiskFile:
        MOV  R0,@$023200
        JMP  @$0125030

       .include "ppu/interrupts_handlers.s"
       .include "music/ep1_title_music_playerconfig.s"
       .include "music/ep1_intro_music_playerconfig.s"
       .include "music/ep1_level_music_playerconfig.s"
       .include "music/ep1_boss_music_playerconfig.s"
       .include "../../akg_player/akg_player.s"
       .include "music/ep1_sfx_playerconfig.s"
       .include "../../akg_player/player_sound_effects.s"

TitleMusic: .include "build/ep1_title_music.formatted.s"
IntroMusic: .include "build/ep1_intro_music.formatted.s"
LevelMusic: .include "build/ep1_level_music.formatted.s"
BossMusic:  .include "build/ep1_boss_music.formatted.s"
SoundEffects: .include "music/ep1_sfx.s"

FontBitmap: .space 8 # whitespace symbol
            .incbin "resources/font.raw"
CGAFontBitmap: .incbin "resources/cga8x8b.raw"
HitpointIcon:  .incbin "build/hitpoint_icon.bin"
SmartbombIcon: .incbin "build/smartbomb_icon.bin"

PPU_Player_ScoreBytes: .space 8
PPU_Player_ScoreBytesEnd:

DummyPSG: .word 0

CommandsQueue_Top:
       .space 2*2*16
CommandsQueue_Bottom:
CommandsQueue_CurrentPosition:

       .word CommandsQueue_Bottom
StrBuffer:
       .even
end:
       .nolist
