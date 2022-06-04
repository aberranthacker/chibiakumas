/*
*******************************************************************************
*                               Show Sprite                                   *
*******************************************************************************
 SprShow_W     equ SprShow_W_Plus1 - 1

 SprShow_Xoff  equ SprShow_Xoff_Plus1 - 1
 SprShow_Yoff  equ SprShow_Yoff_Plus1 - 1

 SprShow_TempX equ ScreenBuffer_ActiveScreenDirectC_Plus1 - 2
 SprShow_TempY equ SprShow_TempY_Plus2 - 2

 SprShow_TempW equ SprShow_TempW_Plus1 - 1
 SprShow_TempH equ SprShow_TempH_Plus1 - 1
 SprShow_OldX  equ SprShow_OldX_Plus1 - 1

 SprShow_TempAddr equ SprShow_TempAddr_Plus2 - 2 ; defw &0000
*/

# SpriteBank_Font2:
#     ld a,2
# SpriteBank_Font: ;Init the spritefont location - Corrupts HL and now BC
#     ;SpriteBank_FontNum ;A= 1 = Chibifont   2 = regularfont
#     cp 1
#     jr z,SpriteBank_FontNumChibi
#     ld bc,DrawText_DicharSprite_NextLine-DrawText_DicharSprite_Font_Plus1
#     ;The font is located at &C000/4000 in bank C1/C3, or &7000 in the Bootstrap block
#     ld hl,Font_RegularSizePos
#
#     jr ShowSprite_SetFontBankAddr
# SpriteBank_FontNumChibi:
#     ld bc,DrawText_DicharSprite_NextLineMini-DrawText_DicharSprite_Font_Plus1
#     ;The font is located at &C000 in bank C1/C3, or &7000 in the Bootstrap block
#     ld hl,Font_SmallSizePos
# ShowSprite_SetFontBankAddr:
#     ld (DrawText_CharSpriteMoveSize_Plus1-1),a
#     ld a,c
#     ld (DrawText_DicharSprite_Font_Plus1-1),a
# ShowSprite_SetBankAddr:
#     ld (SprShow_BankAddr),hl
# ret
#
# We can preread a sprite to get the width/height
# This is used for Direct sprites, and was used by the object loop
# The object loop now assumes the sprite is 24x24, this was done to save time
# as 97% of the time - it is
ShowSprite_ReadInfo: # ------------------------------------------------------{{{
        MOV  $0,R0
       .equiv srcSprShow_SprNum, .-2
        ASL  R0

        MOV  $LevelSprites,R5
       .equiv srcSprShow_BankAddr, .-2
        MOV  R5,R3
        # 6 bytes per sprite
        ADD  R0,R5
        ADD  R0,R5
        ADD  R0,R5

        MOVB (R5)+,R0 # height of the sprite in lines
        BZE  SpriteGiveUp$

        MOVB R0,@$srcSprShow_TempH

        MOVB (R5)+,R1 # width in bytes
        # don't care about sign extension, 80 is a maximum value
        MOV  R1,@$srcSprShow_DrawWidth
        MOV  R1,@$srcSprShow_SpriteWidth

        MOVB (R5)+,@$srcSprShow_Yoffset

        # Sprite attributes such as PSet, Doubleheight and transp color
        MOVB (R5)+,R0 # sign extension is irrelevant
        MOV  R0,@$srcSprShow_SpriteAttributes

        # R0 sprite attributes
        # R1 width
        # R3 sprite store address
        # R5 sprite offset
    SpriteGiveUp$:
        RETURN                                              # ret
                                                            #
                                                            # SpriteGiveUp:
                                                            #     pop af ;Forcably quit not just getting info - but showing the sprite
                                                            # ret
#----------------------------------------------------------------------------}}}

# ShowSpriteDirect is a cruder version of ShowSprite, it does not use the
# 'virtual' screen res of (160x200) and cannot do clipping - it was designed for
# the UI objects which never moved and never needed clipping
# not implemented -----------------------------------------------------------{{{
                                                            # ShowSpriteDirect:
                                                            #     ;set draw pos into Temp_X and Temp_Y
                                                            #     call ShowSprite_ReadInfo
                                                            #
                                                            #     ld c,(hl)
                                                            #     inc hl
                                                            #     ld b,(hl)
                                                            #
                                                            #     ex de,hl
                                                            #     add hl,bc
                                                            #     ld (SprShow_TempAddr),hl
                                                            #     ex de,hl
                                                            #         ld a,(SprShow_Yoff)
                                                            #         ld c,a
                                                            #         ld a,(SprShow_TempY)
                                                            #         add c
                                                            #         ld (SprShow_TempY),A
                                                            #     ;Quick shortcuts for fonts
                                                            #     ld a,(SprShow_TempW)
                                                            #     ld (SprShow_W),a
                                                            #     dec a
                                                            #     jr z,ShowSpriteDirectOneByteSpecial
                                                            #     dec a
                                                            #     jp z,ShowSpriteDirectTwoByteSpecial
                                                            #     dec a
                                                            #     dec a
                                                            #     jr z,ShowSpriteDirectFourByteSpecial
                                                            #
                                                            #     xor a
                                                            #     ld (TranspBitA_Plus1-1),a
                                                            #
                                                            #     ld hl,SprDrawChooseRender
                                                            #     ld a,(SprShow_Xoff_Plus1-1)
                                                            #     bit 7,a
                                                            #     jp z,ShowSprite_OK_Xoff2
                                                            #     ld hl,SprDrawChooseRenderPset
                                                            #
                                                            #     ShowSprite_OK_Xoff2:
                                                            #
                                                            #     ld (ShowSprite_Ready_Return_Plus2-2),hl
                                                            #     jp ShowSprite_Ready
                                                            #
                                                            # ShowSpriteDirectFourByteSpecial:
                                                            #     ld (TranspBitA_Plus1-1),a
                                                            #     ld hl,SprDraw16pxInit
                                                            #     ld (ShowSprite_Ready_Return_Plus2-2),hl
                                                            #     jp ShowSprite_Ready
                                                            # ShowSpriteDirectTwoByteSpecial:
                                                            #     ;shortcut for our minifont!
                                                            #     ld hl, SprDrawPset8pxInit
                                                            #     ld (ShowSprite_Ready_Return_Plus2-2),hl
                                                            #     jp ShowSprite_Ready
                                                            #
                                                            # ShowSpriteDirectOneByteSpecial:
                                                            #     ;shortcut for our minifont!
                                                            #     ld hl, SprDrawLnStartBegin
                                                            #     ld (ShowSprite_Ready_Return_Plus2-2),hl
                                                            #     jp ShowSprite_Ready
                                                            #
                                                            # GetSpriteXY
                                                            #     ld a,(SprShow_X)
                                                            #     ld b,a
                                                            #     ld a,(SprShow_Y)
                                                            #     ld c,a
                                                            # ret
#----------------------------------------------------------------------------}}}

#-------------------------------------------------------------------------------
ShowSprite: # ShowSprite is the main routine of our program!
        CALL @$ShowSprite_ReadInfo # Get Sprite Details
        # R0 Xoff
        # R1 width
        # R3 sprite store address
        # R5 sprite offset

       .equiv cmpSpriteSizeConfig6, .+2
        CMP  R1,$3 # 3 words, default sprite width

       .equiv dstShowSpriteReconfigureCommand, .+4
       .call NE, @$ShowSpriteReconfigure # calls ShowSpriteReconfigure or null

        ADD  (R5),R3 # calculate sprite address
        MOV  R3,@$srcSprShow_TempAddr

        # we are relying on sprite attributes still being in R0
        BIC  $0xFFF8,R0 # Bits 2,1,0 - transparency
        MOVB TranspColors(R0),@$srcTranspBitA

# *********  show a new sprite *********

# ShowSprite_OK:
       .equiv srcSprShow_Yoffset, .+2
        MOV  $48,R1 # set from ShowSprite_ReadInfo
       .equiv srcSprShow_Y, .+2
        ADD  $48,R1 # set from object array

       .equiv srcSprShow_SpriteAttributes, .+2
        MOV  $48,R0 # set from ShowSprite_ReadInfo
       .equiv srcSprShow_X, .+2
        MOV  $48,R2 # set from object array

        # Set renderer according to the sprite attributes
        # Bit 7 forces "pset" - wipes background but faster
        # Bit 6 doubles height
        # Bits 2,1,0 - transparency
        BIT  $0x40,R0
        BZE  ShowSprite_OK_NoDoubler$

        # Doubler gives an interlacing effect, used for faux big sprites
        # without slowdown
        MOV  $SprDrawChooseRenderLineDoubler,R5

        BIT  $0x80,R0
        BZE  ShowSprite_OK_SetRenderer$

        # Double height with Pset (no transparency - much faster)
        MOV  $SprDrawChooseRenderLineDoublerPset,R5
        BR   ShowSprite_OK_SetRenderer$

    ShowSprite_OK_NoDoubler$: # Normal sprite
        MOV  $SprDrawChooseRender,R5
        BIT  $0x80,R0
        BZE  ShowSprite_OK_SetRenderer$

        # PSET sprite - deletes background, fast no transp
        MOV  $SprDrawChooseRenderPset,R5

    ShowSprite_OK_SetRenderer$:
        MOV  R5,@$jmpShowSprite_Ready_Return

        # R1 Y
        # R2 X
        CALL @$VirtualPosToScreenByte
        # R2 Y lines to skip   | R4 X bytes to skip, left    #
        # R3 Y lines to remove | R5 X bytes to remove, right #

        MOV  R2,R0
        BIS  R3,R0
        BIS  R4,R0
        BIS  R5,R0
        BZE  ShowSprite_SkipChanges    # if all are zero, do nothing

# truncate the sprite -------------------------------------------------------{{{
        MOV  $SprDrawLnStartBegin,@$jmpShowSprite_Ready_Return

    # R3 = Y lines to remove
        CMP  @$srcSprShow_TempH,R3     # check if new width is <= 0
        BHI  ShowSprite_HeightNotZero$
        RETURN
    ShowSprite_HeightNotZero$:
        SUB  R3,@$srcSprShow_TempH

    # R5 = X bytes to remove from the right side
        CMP  @$srcSprShow_DrawWidth,R5 # check if new width is =< 0
        BHI  ShowSprite_WidthNotZero$
        RETURN
    ShowSprite_WidthNotZero$:
        SUB  R5,@$srcSprShow_DrawWidth

        MOV  @$srcSprShow_TempAddr,R5
    # R2 = Y lines to skip
        TST  R2
        BZE  ShowSprite_NoLinesToSkip$

        MOV  @$srcSprShow_SpriteWidth,R0
    ShowSprite_AddressDown$:
        ADD  R0,R5
        SOB  R2,ShowSprite_AddressDown$
    # R4 = X bytes to skip on the left side
    ShowSprite_NoLinesToSkip$:
        ADD  R4,R5
        MOV  R5,@$srcSprShow_TempAddr
#----------------------------------------------------------------------------}}}

    ShowSprite_SkipChanges:
        # srcSprShow_TempY = Y - lines to skip
       .equiv srcSprShow_TempY, .+2
        MOV  $0x00,R5
        ASL  R5 # calculate the table entry offset
        MOV  scr_addr_table(R5),R5

        ADD  (PC)+,R5 # add X position and the frame buffer MSB
        srcSprShow_TempX: .byte 0x00
        srcFB_MSB:        .byte 0x40 # FB1
                         #.byte 0x00 # FB0

        # srcSprShow_TempH = (H - lines to remove) or (H - lines to skip)
       .equiv srcSprShow_TempH, .+2
        MOV  $0x00,R2
        # address of the visible part of the sprite
       .equiv srcSprShow_TempAddr, .+2
        MOV  $0x0000,R4

        JMP  @$SprDrawLnStartBegin
       .equiv jmpShowSprite_Ready_Return, .-2

# This is our most basic render, its slow, but can do any size and clipping                                                           # SprDrawLnStartBegin:            ; This is our most basic render, its slow, but can do any size and clipping
SprDrawLnStartBegin: #------------------------------------------------------{{{
    SprDrawLnStartBeginB$:
        MOV  @$srcTranspBitA,@$srcTranspBitB

        MOV  $SprDraw_LineLoop$,R0

        BIT  $0x40,@$srcSprShow_SpriteAttributes
        BZE  SprDrawLn_NoDoubler$

        MOV  $SprDrawLnDoubleLine$,R0

    SprDrawLn_NoDoubler$:
        MOV  R0, @$dstSprDrawLnDoubleLineJump

    SprDraw_LineLoop$:
        MOV  R5,-(SP)
        MOV  R4,R3
       .equiv srcSprShow_DrawWidth, .+2
        MOV  $0x00,R1
        ASR  R1

   .if DebugMode
        CMP  R5,$0077777
        BLOS SprDraw_PixelLoop$
       .inform_and_hang "SprDrawLn: dst out of FB"
   .endif

    SprDraw_PixelLoop$:
        # TODO: implement transparency
        MOV  (R3)+, R0
       .equiv srcTranspBitB, .+2
        CMP  R0,$0x01
       #BEQ  SprDraw_NextWord$
   .ifdef DebugSprite
       # test code, marks slow sprites so we can see they will be slow
       BIS  $0b1000000110000001,R0
   .endif
        MOV  R0,(R5)

    SprDraw_NextWord$:
        INC  R5
        INC  R5

        SOB  R1,SprDraw_PixelLoop$

       .equiv srcSprShow_SpriteWidth, .+2
        ADD  $0x00,R4;
        MOV  (SP)+,R5
        ADD  $80,R5
        DEC  R2
        BZE  1237$

       .equiv dstSprDrawLnDoubleLineJump, .+2
        JMP  @$SprDraw_LineLoop$
       # TODO: implement SprDrawLnDoubleLine
    SprDrawLnDoubleLine$:
       #CALL GetNxtLin
        BR   SprDraw_LineLoop$

1237$:  RETURN
#----------------------------------------------------------------------------}}}

# SprDrawChooseRender: turbo version ----------------------------------------{{{
SprDrawChooseRenderLineDoubler:
        MOV  $80-6,R1
        ASL  R2
        MOV  $SprDraw24pxVer_Double$,R3
        JMP  (R3)
SprDrawChooseRender: # Pick the render based on width
       .equiv srcTranspBitA, .+2
        MOV  $0x00,R0 # Set R0 to ZERO / Transp byte
        MOV  @$srcSprShow_DrawWidth,R1
    .ifdef DebugMode
        CMP  R1,$24
        BHI  .
    .endif
        JMP  @SprDrawJumpTable(R1)
    SprDrawJumpTable:
       .word NotImplemented      #  0
       .word SprDraw8pxInit$     #  2
       .word SprDraw16pxInit$    #  4
       .word SprDraw24pxInit$    #  6
       .word SprDraw32pxInit$    #  8
       .word SprDraw40pxInit$    # 10
       .word SprDraw48pxInit$    # 12
       .word SprDrawLnStartBegin # 14 56
       .word SprDrawLnStartBegin # 16 64
       .word SprDraw72pxInit$    # 18
       .word SprDrawLnStartBegin # 20 80
       .word SprDrawLnStartBegin # 22 88
       .word SprDraw96pxInit$    # 24

    SprDraw8pxInit$:  .inform_and_hang "no SprDraw8pxInit"
    SprDraw16pxInit$: .inform_and_hang "no SprDraw16pxInit"
    SprDraw24pxInit$:
        MOV  $80-6,R1
        MOV  $SprDraw24pxVer$,R3
        JMP  (R3)
    SprDraw32pxInit$: .inform_and_hang "no SprDraw32pxInit"
    SprDraw40pxInit$: .inform_and_hang "no SprDraw40pxInit"
    SprDraw48pxInit$: .inform_and_hang "no SprDraw48pxInit"
    SprDraw72pxInit$: .inform_and_hang "no SprDraw72pxInit"
    SprDraw96pxInit$: .inform_and_hang "no SprDraw96pxInit"

        # ********** A MUST BE the transparent byte for THIS WHOLE LOOP! ***********

# draw chain {{{
    SprDraw24pxVer_Double$:                                 # SprDraw24pxVer_Double:  ;Line doubler - does two nextlines each time
        BIT  $1,R2                                          #         bit 0,C
        BNZ  SprDraw24pxVer$                                #         jp z,SprDrawTurbo_LineSkip
        ADD  $6,R5
        BR   SprDrawTurbo_LineSkip$                         #         jp SprDraw24pxVer
                                                            # SprDraw96pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_SkipFb
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_SkipFb:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_SkipEb
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_SkipEb:
                                                            #         inc hl
                                                            # SprDraw88pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_SkipCb
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_SkipCb:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_SkipDb
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_SkipDb:
                                                            #         inc hl
                                                            # SprDraw80pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_SkipAb
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_SkipAb:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_SkipBb
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_SkipBb:
                                                            #         inc hl
                                                            #
                                                            # SprDraw72pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_Skip1b
                                                            #         ld (hl),e
                                                            #
                                                            #         SprDraw24pxW_Skip1b:
                                                            #         inc hl
                                                            #
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_Skip2b
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_Skip2b:
                                                            #         inc hl
                                                            #
                                                            # SprDraw64pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_Skip3b
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_Skip3b:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_Skip4b
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_Skip4b:
                                                            #         inc hl
                                                            #
                                                            # SprDraw56pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_Skip5b
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_Skip5b:
                                                            #         inc hl
                                                            #
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_Skip6b
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_Skip6b:
                                                            #         inc hl
                                                            # SprDraw48pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_SkipF
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_SkipF:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_SkipE
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_SkipE:
                                                            #         inc hl
                                                            # SprDraw40pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_SkipC
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_SkipC:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_SkipD
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_SkipD:
                                                            #         inc hl
                                                            # SprDraw32pxVer:
                                                            #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_SkipA
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_SkipA:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_SkipB
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_SkipB:
                                                            #         inc hl
                                                            #
    SprDraw24pxVer$:                                        # SprDraw24pxVer:
        MOV  (R4)+,(R5)+                                    #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_Skip1
                                                            #         ld (hl),e
                                                            #
                                                            #         SprDraw24pxW_Skip1:
                                                            #         inc hl
                                                            #
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_Skip2
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_Skip2:
                                                            #         inc hl
                                                            #
                                                            # SprDraw16pxVer:
        MOV  (R4)+,(R5)+                                    #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_Skip3
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_Skip3:
                                                            #         inc hl
                                                            #
                                                            #         ; Byte Start
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_Skip4
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_Skip4:
                                                            #         inc hl
                                                            #
                                                            # SprDraw8pxVer:
        MOV  (R4)+,(R5)+                                    #         pop de
                                                            #         cp e
                                                            #         jr z,SprDraw24pxW_Skip5
                                                            #         ld (hl),e
                                                            #         SprDraw24pxW_Skip5:
                                                            #         inc hl
                                                            #
                                                            #         cp d
                                                            #         jr z,SprDraw24pxW_Skip6
                                                            #         ld (hl),d
                                                            #         SprDraw24pxW_Skip6:
# }}}
    SprDrawTurbo_LineSkip$:
        DEC  R2
        BZE  SprDrawTurbo_Done$

        ADD  R1,R5
        JMP  (R3)

    SprDrawTurbo_Done$:
        RETURN
#----------------------------------------------------------------------------}}}

#--------------------- Pset Version! no transparentcy, so fast! ----------------
# SprDrawChooseRenderPset: --------------------------------------------------{{{
SprDrawChooseRenderLineDoublerPset:
        MOV  $80-6,R1
        ASL  R2
        MOV  $SOBToEndOfPsetDrawChain+20,@$SprDrawPset_SOB$
        BR   SprDrawPset_Double$

SprDrawChooseRenderPset:
        MOV  @$srcSprShow_DrawWidth,R1
    .ifdef DebugMode
        CMP  R1,$32
        BHI  .
    .endif
        JMP  @SprDrawPsetJumpTable(R1)
    SprDrawPsetJumpTable: #--------------------------------------------------{{{
       .word NotImplemented        #  0
       .word SprDrawPset8pxInit$   #  2
       .word SprDrawPset16pxInit$  #  4
       .word SprDrawPset24pxInit$  #  6
       .word SprDrawPset32pxInit$  #  8
       .word SprDrawPset40pxInit$  # 10
       .word SprDrawPset48pxInit$  # 12
       .word SprDrawLnStartBegin   # 14 56
       .word SprDrawPset64pxInit$  # 16
       .word SprDrawPset72pxInit$  # 18
       .word SprDrawPset80pxInit$  # 20
       .word SprDrawLnStartBegin   # 22 88
       .word SprDrawPset96pxInit$  # 24
       .word SprDrawLnStartBegin   # 26 104
       .word SprDrawLnStartBegin   # 28 112
       .word SprDrawLnStartBegin   # 30 120
       .word SprDrawPset128pxInit$ # 32
    #------------------------------------------------------------------------}}}

    SprDrawPset8pxInit$: #---------------------------------------------------{{{
        MOV  $80-2,R1
        MOV  $SOBToEndOfPsetDrawChain+1, @$SprDrawPset_SOB$ #  2 / 2 = 1
        BR   SprDrawPset8pxVer$
    SprDrawPset16pxInit$:
        MOV  $80-4,R1
        MOV  $SOBToEndOfPsetDrawChain+2, @$SprDrawPset_SOB$ #  4 / 2 = 2
        BR   SprDrawPset16pxVer$
    SprDrawPset24pxInit$:
        MOV  $80-6,R1
        MOV  $SOBToEndOfPsetDrawChain+3, @$SprDrawPset_SOB$ #  6 / 2 = 3
        BR   SprDrawPset24pxVer$
    SprDrawPset32pxInit$:
        MOV  $80-8,R1
        MOV  $SOBToEndOfPsetDrawChain+4, @$SprDrawPset_SOB$ #  8 / 2 = 4
        BR   SprDrawPset32pxVer$
    SprDrawPset40pxInit$:
        MOV  $80-10,R1
        MOV  $SOBToEndOfPsetDrawChain+5, @$SprDrawPset_SOB$ # 10 / 2 = 5
        MOV  $SprDrawPset40pxVer$,R3
    SprDrawPset48pxInit$:
        MOV  $80-12,R1
        MOV  $SOBToEndOfPsetDrawChain+6, @$SprDrawPset_SOB$ # 12 / 2 = 6
        MOV  $SprDrawPset48pxVer$,R3
    SprDrawPset64pxInit$:
        MOV  $80-16,R1
        MOV  $SOBToEndOfPsetDrawChain+8, @$SprDrawPset_SOB$ # 16 / 2 = 7
        MOV  $SprDrawPset64pxVer$,R3
    SprDrawPset72pxInit$:
        MOV  $80-18,R1
        MOV  $SOBToEndOfPsetDrawChain+9, @$SprDrawPset_SOB$ # 18 / 2 = 9
        MOV  $SprDrawPset32pxVer$,R3
    SprDrawPset80pxInit$:
        MOV  $80-20,R1
        MOV  $SOBToEndOfPsetDrawChain+10,@$SprDrawPset_SOB$ # 20 / 2 = 10
        MOV  $SprDrawPset80pxVer$,R3
    SprDrawPset96pxInit$:
        MOV  $80-24,R1
        MOV  $SOBToEndOfPsetDrawChain+12,@$SprDrawPset_SOB$ # 24 / 2 = 12
        MOV  $SprDrawPset96pxVer$,R3
    SprDrawPset128pxInit$:
        MOV  $80-32,R1
        MOV  $SOBToEndOfPsetDrawChain+16,@$SprDrawPset_SOB$ # 32 / 2 = 16
        MOV  $SprDrawPset128pxVer$,R3
#----------------------------------------------------------------------------}}}
    SprDrawPset_Double$:
        BIT  $1,R2
        BNZ  SprDrawPset24pxVer$
        ADD  $6,R5
        BR   SprDrawPset_LineSkip$

    SprDrawPset128pxVer$: #--------------------------------------------------{{{
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDrawPset96pxVer$:
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDrawPset80pxVer$:
        MOV  (R4)+,(R5)+
    SprDrawPset72pxVer:
        MOV  (R4)+,(R5)+
    SprDrawPset64pxVer$:
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDrawPset48pxVer$:
        MOV  (R4)+,(R5)+
    SprDrawPset40pxVer$:
        MOV  (R4)+,(R5)+
    SprDrawPset32pxVer$:
        MOV  (R4)+,(R5)+
    SprDrawPset24pxVer$:
        MOV  (R4)+,(R5)+
    SprDrawPset16pxVer$:
        MOV  (R4)+,(R5)+
    SprDrawPset8pxVer$:
        MOV  (R4)+,(R5)+
    #------------------------------------------------------------------------}}}

       .equiv SOBToEndOfPsetDrawChain, 0077202
    SprDrawPset_LineSkip$:
        ADD  R1,R5
    SprDrawPset_SOB$:
        SOB  R2,SprDrawPset24pxVer$

        RETURN
#----------------------------------------------------------------------------}}}

