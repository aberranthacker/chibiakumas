
                .TITLE Chibi Akumas PPU module
                .GLOBAL start

                .include "./macros.s"
                .include "./hwdefs.s"
                .include "./core_defs.s"

	        .equiv PPU_ModuleSizeWords, (end - start)
	        .global PPU_ModuleSizeWords

                .=PPU_UserRamStart

start:
                #------------------------------------------------------------{{{
# screen scanlines metadata: ------------------------------------------------{{{
# | 2400 | 175700—176567 | верхняя служебная строка           |
# | 2470 | 100000—154537 | основной (главный) экран           |
# | 4700 | 154540—175677 | экран установок (по клавише «УСТ») |
# | 6750 | 176570—177457 | нижняя служебная строка            |
# |      | 177460—177777 | для внутреннего использования      |
# 309 lines in total (lines 4..312 of SECAM's half-frame)
# scanlines 1..19 are not visible due to the vertical blanking interval
# scanlines 20..307 are visible
# scanlines 308..309 are not visible due to the vertical blanking interval
                MOV     $SLTAB,R0       #calc address of the SLTAB
                MOV     R0,R1           #R0 address of the current element (2)
                ADD     $4,R1           #R1 address of the next element (3)

                MOV     $15,R2          #elements 2..16 are same
1$:             CLR     (R0)+           #--addresses of lines 2..16
                MOV     R1,(R0)+        #--pointers to elements 3..17
                ADD     $4,R1           #calc address of the next element of SLTAB
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
                                        #--color settings YRGB YRGB YRGB YRGB
                MOV     $0x2200,(R0)+   #colors  011  010  001  000
                MOV     $0xAAFF,(R0)+   #colors  111  110  101  100
                CLR     (R0)+           #  address of line 19
                ADD     $8,R1           #  calculate pointer to next element
                BIC     $0b110,R1       #  next element consists of 2 words
                MOV     R1,(R0)+        #--pointer to element 20
#----------------------------------------scanlines 20..307 are visible
                MOV     $100000,R2      #
                MOV     $44,R3          #
2$:             MOV     R2,(R0)+        #--VRAM address of a scanline
                ADD     $4,R1           #calc address of next element SLTAB
                MOV     R1,(R0)+        #--pointer to the next element SLTAB
                ADD     $40,R2          #calculate VRAM address of next scanline
                SOB     R3,2$           #
                                        #
                MOV     $FB1,R2         #address of bitplane 0
                MOV     $200,R3         #height of main RAM located framebuffer
3$:             MOV     R2,(R0)+        #--main RAM address of a scanline
                ADD     $4,R1           #calc address of next element of SLTAB
                MOV     R1,(R0)+        #--pointer to the next element of SLTAB
                ADD     $40,R2          #calculate VRAM address of next scanline
                SOB     R3,3$           #
                                        #
                MOV     $103340,R2      #
                MOV     $44,R3          #
4$:             MOV     R2,(R0)+        #--VRAM address of a scanline
                ADD     $4,R1           #calc address of next element of SLTAB
                MOV     R1,(R0)+        #--pointer to the next element of SLTAB
                ADD     $40,R2          #calculate VRAM address of next scanline
                SOB     R3,4$           #
                                        #
                CLR     (R0)+           #--address of line 308
                MOV     R1,(R0)         #--pointer back to element 308
#----------------------------------------------------------------------------}}}
                MTPS    PR7             #disable interrupts
                MOV     $1,@$PBPMSK     #disable writes to bitplane 0 via registers
                MOV     @$272,$SYS272   #store pointer to the next element of
                                        #scanlines table
                MOV     $SLTAB,@$272    #--pointer to element 1 in SLTAB

# WaitKey:        TSTB    @$KBSTAT        #wait for any key state to change
#                 BPL     WaitKey         #branch if plus
# 
#                 TSTB    @$KBDATA        #loop if a key was pressed off
#                 BMI     WaitKey         #branch if minus
#                                         #--- finish PPU program ---
#                 MOV     $SYS272,@$272   #restore pointer to systems scanlines table
#                 CLR     @$PBPMSK        #enable writes to all bitplanes through registers
# 
#                 MOV     $FlgEnd/2,@$PBPADR
#                 MOV     $-1,@$PBP12D   #signal that PPUs program finished
                RETURN

#----------------------------------------------------------------------------}}}

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

SYS272: .WORD     # pointer to systems scanlines table

        .balign 8 # align at 8 bytes or the new SLTAB will be invalid
SLTAB:  .SPACE 288 * 2 * 4 # space for a 288 four-words entries

end:
