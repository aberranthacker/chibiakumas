
                .TITLE Chibi Akumas PPU module
                .GLOBAL start

                .include "./macros.s"
                .include "./hwdefs.s"
                .include "./core_defs.s"

                .equiv  PPU_ModuleSizeWords, (end - start)
                .global PPU_ModuleSizeWords

                .=PPU_UserRamStart

start:
/* setup our scanlines parameters table (SLTAB): ----------------------------{{{
 | 2400 | 175700—176567 | верхняя служебная строка           |
 | 2470 | 100000—154537 | основной (главный) экран           |
 | 4700 | 154540—175677 | экран установок (по клавише «УСТ») |
 | 6750 | 176570—177457 | нижняя служебная строка            |
 |      | 177460—177777 | для внутреннего использования      |

312 (1..312) lines is SECAM half-frame
309 (1..309) SLTAB elements in total (lines 4..312 of SECAM's half-frame)
  scanlines   1..19  are not visible due to the vertical blanking interval
  scanlines  20..307 are visible (lines 23-310 of SECAM's half-frame)
  scanlines 308..309 are not visible due to the vertical blanking interval

|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3|   2 |   1 |    0 |
|                                      |elem |2W/4W|cursor|

2-nd bit: 1) 2 words element - bit 2
          2) 4 words element
             0 - cursor, pallete and horizontal scale
             1 - colors
1-st bit: 0 - next is 2 words element
          1 - next is 4 words element
*/

                MOV     $SLTAB,R0       # set R0 to beginning of SLTAB
                MOV     R0,R1           # R0 address of the current element (2)
                ADD     $4,R1           # R1 address of the next element (3)

                MOV     $15,R2          # elements 2..16 are same
1$:             CLR     (R0)+           # --addresses of lines 2..16
                MOV     R1,(R0)+        # --pointers to elements 3..17
                ADD     $4,R1           # calc address of the next element of SLTAB
                SOB     R2,1$

                CLR     (R0)+           #--address of line 17
                BIS     $0b010,R1       #  next element is 4 words
                BIC     $0b100,R1       #  display settings
                MOV     R1,(R0)+        #--pointer to an element 18

                MOV     $0b10000,(R0)+  #--cursor settings, graphical cursor
                MOV     $0b10111,(R0)+  #  320 dots per line, pallete 7
                CLR     (R0)+           #  address of line 18
                ADD     $8,R1           #  calculate pointer to next element
                BIS     $0b110,R1       #  next element is 4 words, color settings
                MOV     R1,(R0)+        #--pointer to element 19

                MOV     $0x2020,(R0)+   # colors  011  010  001  000 (YRGB)
                MOV     $0x2020,(R0)+   # colors  111  110  101  100 (YRGB)
                CLR     (R0)+           #--address of line 19
                ADD     $8,R1           #  calculate pointer to next element
                BIC     $0b110,R1       #  next element consists of 2 words
                MOV     R1,(R0)+        #--pointer to element 20
#---------------------------------------- scanlines 20..307 are visible
                MOV     $100000,R2      #
                MOV     $43,R3          #
2$:             MOV     R2,(R0)+        #--address of screenline
                ADD     $4,R1           #  calc address of next element of SLTAB
                MOV     R1,(R0)+        #--set address of next element of SLTAB
                ADD     $40,R2          #  calculate address of next screenline
                SOB     R3,2$           #

                MOV     R2,(R0)+        #--address of a screenline
                ADD     $4,R1           # calc address of next element of SLTAB
                BIS     $0b110,R1       # next element is 4 words, color settings
                MOV     R1,(R0)+        #--pointer to element 64
#--------------------------------------- main screen
                MOV     $FB1 >> 1,R2    # address of bitplane 0
                MOV     $200,R3         # height of main RAM located framebuffer
                MOV     R0,@$FBSLTAB    #
3$:             MOV     $0xCC00,(R0)+   # colors  011  010  001  000 (YRGB)
                MOV     $0xAA99,(R0)+   # colors  111  110  101  100 (YRGB)
                MOV     R2,(R0)+        #--main RAM address of a scanline
                ADD     $8,R1           # calc address of next element of SLTAB
                MOV     R1,(R0)+        #--pointer to the next element of SLTAB
                ADD     $40,R2          # calculate address of next screenline
                SOB     R3,3$           #
#---------------------------------------
                MOV     $0x2020,(R0)+   # colors  011  010  001  000 (YRGB)
                MOV     $0x2020,(R0)+   # colors  111  110  101  100 (YRGB)
                MOV     $103340,R2      #
                MOV     R2,(R0)+        #
                ADD     $40,R2          # calculate address of next screenline
                ADD     $8,R1           # calculate pointer to next element
                BIC     $0b110,R1       # next element consists of 2 words
                MOV     R1,(R0)+        #--pointer to element 265

                MOV     $43,R3          #
4$:             MOV     R2,(R0)+        #--address of a screenline
                ADD     $4,R1           #  calc address of next element of SLTAB
                MOV     R1,(R0)+        #--pointer to the next element of SLTAB
                ADD     $40,R2          # calculate address of next screenline
                SOB     R3,4$           #
                                        #
                CLR     (R0)+           #--address of line 308
                MOV     R1,(R0)         #--pointer back to element 308
#----------------------------------------------------------------------------}}}
                MOV     @$0272, @$SYS272 # store pointer to system SLTAB (186; 0xBA)
                MOV     $SLTAB, @$0272   # use our SLTAB

                MOV     $PGM, @$07124    # Записать в таблицу процессов
                MOV     $1, @$07100      # Записать в таблицу запуска
                RETURN                   # Завершить эту подпрограмму

PGM:            MOV     R0, -(SP)        # save R0 in order for the process manager to function correctly

                MOV     $PPUCommand >> 1, @$PBPADR
                CMP     @$PBP12D, $0xFFFF
                BEQ     PrepareToBeRemoved

                MOV     $PGM, @$07124   # Поставить в очередь процессов
                MOV     $1, @$07100     # Потребовать обслуживания
                MOV     (SP)+ ,R0       # Восстановить
                JMP     @$0174170       # Перейти к диспетчеру процессов (63608; 0xF878)
PrepareToBeRemoved:
                MOV     @$SYS272, @$0272 # restore pointer to system SLTAB (186; 0xBA)
                CLR     @$PBP12D
                RETURN

# FlipToFB0:
#         MOV $(FB0 >> 1),R2
#         BR  FlipFB
# FlipToFB1:
#         MOV $(FB1 >> 1),R2
#         BR  FlipFB
# FlipFB:
#         MOV  $FBPointer,R0
#         MOV  $200,R1
# loop$:  BIT  $2,(R0)+
#         BNE  2$
# 4$: # next is 4 words
#         ADD  $4,R0
# 2$: # next is 2 words
#         MOV  R2,(R0)+
#         ADD  $40,R2
#         SOB  R1,loop$
# RETURN
#
# # 0 data
# # 2 data
# # 4 address
# # 6 next element
#
# # 0 address
# # 2 next element

SYS272:  .WORD     # pointer to systems scanlines table
FBSLTAB: .WORD     # adrress of main screen SLTAB
         .balign 8 # align at 8 bytes or the new SLTAB will be invalid
SLTAB:   # .SPACE 288 * 2 * 4 # space for a 288 four-words entries
         .WORD 0   # expecting that next ~2.5KB of RAM is unused

end:
