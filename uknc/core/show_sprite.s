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

# We can preread a sprite to get the width/height
# This is used for Direct sprites, and was used by the object loop
# The object loop now assumes the sprite is 24x24, this was done to save time
# as 97% of the time - it is
ShowSprite_ReadInfo: # ------------------------------------------------------{{{
       .equiv srcSprShow_SprNum, .+2
        MOV  $0,R0
        ASL  R0

       .equiv srcSprShow_BankAddr, .+2
        MOV  $LevelSprites,R5
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
        MOV  R0,@$srcSprShow_SprAttrs

        # A  R0 sprite attributes
        # B  R1 width
        # DE R3 sprite store address
        # HL R5 points to sprite offset
    SpriteGiveUp$:
        RETURN

        # SpriteGiveUp:
        #     pop af ;Forcably quit not just getting info - but showing the sprite
        # ret
#----------------------------------------------------------------------------}}}

# ShowSpriteDirect is a cruder version of ShowSprite, it does not use the
# 'virtual' screen res of (160x200) and cannot do clipping - it was designed for
# the UI objects which never moved and never needed clipping
ShowSpriteDirect: #----------------------------------------------------------{{{
      # set draw pos into Temp_X and Temp_Y
        CALL ShowSprite_ReadInfo                              # call ShowSprite_ReadInfo
                                                            #
                                                            # ld c,(hl)
                                                            # inc hl
                                                            # ld b,(hl)
                                                            #
        ADD  (R5),R3                                        # ex de,hl
                                                            # add hl,bc
        MOV  R3,@$srcSprShow_TempAddr                       # ld (SprShow_TempAddr),hl
                                                            # ex de,hl
                                                            #     ld a,(SprShow_Yoff)
                                                            #     ld c,a
                                                            #     ld a,(SprShow_TempY)
                                                            #     add c
        ADD  @$srcSprShow_Yoffset, @$srcSprShow_ScrLine       #     ld (SprShow_TempY),A
                                                            # ;Quick shortcuts for fonts
        MOV  @$srcSprShow_DrawWidth,R0                      # ld a,(SprShow_TempW)
        MOV  R0,@$srcSprShow_SpriteWidth                    # ld (SprShow_W),a
        DEC  R0                                             # dec a
        BZE  ShowSpriteDirectOneByteSpecial                 # jr z,ShowSpriteDirectOneByteSpecial
        DEC  R0                                             # dec a
        BZE  ShowSpriteDirectTwoByteSpecial                 # jp z,ShowSpriteDirectTwoByteSpecial
        DEC  R0                                             # dec a
        DEC  R0                                             # dec a
        BZE  ShowSpriteDirectFourByteSpecial                # jr z,ShowSpriteDirectFourByteSpecial
                                                            #
                                                            # xor a
        CLR  @$srcTranspBitA                                # ld (TranspBitA_Plus1-1),a
                                                            #
        MOV  $SprDraw_TurboRenderer,R5                      # ld hl,SprDrawChooseRender
        BIT  $0x80,@$srcSprShow_SprAttrs                    # ld a,(SprShow_Xoff_Plus1-1)
                                                            # bit 7,a
        BZE  ShowSprite_OK_Xoff2                            # jp z,ShowSprite_OK_Xoff2

        MOV  $SprDraw_PsetRenderer,R5                       # ld hl,SprDrawChooseRenderPset
ShowSprite_OK_Xoff2:
        MOV  R5,@$jmpShowSprite_DrawAndReturn               # ld (ShowSprite_Ready_Return_Plus2 - 2),hl
        JMP  ShowSprite_SkipChanges                         # jp ShowSprite_Ready

ShowSpriteDirectFourByteSpecial:
        CLR  @$srcTranspBitA                                # ld (TranspBitA_Plus1-1),a
                                                            # ld hl,SprDraw16pxInit
        MOV  $SprDraw_TurboRenderer_16pxInit, @$jmpShowSprite_DrawAndReturn # ld (ShowSprite_Ready_Return_Plus2-2),hl
        JMP  ShowSprite_SkipChanges                         # jp ShowSprite_Ready
ShowSpriteDirectTwoByteSpecial: # shortcut for our minifont!
        MOV  $SprDraw_PsetRenderer8pxInit, @$jmpShowSprite_DrawAndReturn # ld hl, SprDraw_PsetRenderer8pxInit
        JMP  ShowSprite_SkipChanges                         # ld (ShowSprite_Ready_Return_Plus2-2),hl
                                                            # jp ShowSprite_Ready
ShowSpriteDirectOneByteSpecial: # shortcut for our minifont!
        MOV  $SprDraw_BasicRenderer, @$jmpShowSprite_DrawAndReturn # ld hl, SprDrawLnStartBegin
                                                            # ld (ShowSprite_Ready_Return_Plus2-2),hl
        JMP  ShowSprite_SkipChanges                         # jp ShowSprite_Ready

# GetSpriteXY:
        # ld a,(SprShow_X)
        # ld b,a
        # ld a,(SprShow_Y)
        # ld c,a
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
        ADD  $48,R1 # set from object array # object_driver.s

       .equiv srcSprShow_SprAttrs, .+2
        MOV  $48,R0 # set from ShowSprite_ReadInfo
       .equiv srcSprShow_X, .+2
        MOV  $48,R2 # set from object array # object_driver.s

        # Set renderer according to the sprite attributes
        # Bit 7 forces "pset" - wipes background but faster
        # Bit 6 doubles height
        # Bits 2,1,0 - transparency
        BIT  $0x40,R0
        BZE  ShowSprite_OK_NoDoubler$

        # Doubler gives an interlacing effect, used for faux big sprites
        # without slowdown
        MOV  $SprDraw_TurboRenderer_LineDoubler,R5

        BIT  $0x80,R0
        BZE  ShowSprite_OK_SetRenderer$

        # Double height with Pset (no transparency - much faster)
        MOV  $SprDraw_PsetRenderer_LineDoubler,R5
        BR   ShowSprite_OK_SetRenderer$

    ShowSprite_OK_NoDoubler$: # Normal sprite
        MOV  $SprDraw_TurboRenderer,R5
        BIT  $0x80,R0
        BZE  ShowSprite_OK_SetRenderer$

        # PSET sprite - deletes background, fast no transp
        MOV  $SprDraw_PsetRenderer,R5

    ShowSprite_OK_SetRenderer$:
        MOV  R5,@$jmpShowSprite_DrawAndReturn

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
        MOV  $SprDraw_BasicRenderer,@$jmpShowSprite_DrawAndReturn

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
        # srcSprShow_ScrLine = Y - lines to skip
       .equiv srcSprShow_ScrLine, .+2
        MOV  $0x00,R5
        ASL  R5 # calculate the table entry offset
        MOV  scr_addr_table(R5),R5
        ADD  (PC)+,R5 # add X position and the frame buffer MSB
        srcSprShow_ScrWord: .byte 0x00
        srcFB_MSB:          .byte 0x40 # FB1
                           #.byte 0x00 # FB0

        # srcSprShow_TempH = (H - lines to remove) or (H - lines to skip)
       .equiv srcSprShow_TempH, .+2
        MOV  $0x00,R2
        # address of the visible part of the sprite
       .equiv srcSprShow_TempAddr, .+2
        MOV  $0x0000,R4

       .equiv jmpShowSprite_DrawAndReturn, .+2
        JMP  @$SprDraw_BasicRenderer

# This is our most basic render, its slow, but can do any size and clipping
SprDraw_BasicRenderer: # (SprDrawChooseRender)-------------------------------{{{
        # R2 number of lines
        # R4 sprite src address
        # R5 screen memory dst address
        MOV  @$srcTranspBitA,@$srcTranspBitB

       .equiv LineLoopBR, 000400 + (SprDrawLn_LineLoop - SprDrawLn_LineLoopBR - 2) >> 1 & 0xFF
        MOV  $LineLoopBR,R0

        BIT  $0x40,@$srcSprShow_SprAttrs
        BZE  SprDrawLn_SetLineLoopBR

        MOV  $000240,R0 # NOP to remove BR to execute double line related code

SprDrawLn_SetLineLoopBR:
        MOV  R0, @$SprDrawLn_LineLoopBR

SprDrawLn_LineLoop:
        MOV  R5,-(SP)
        MOV  R4,R3
       .equiv srcSprShow_DrawWidth, .+2
        MOV  $0x00,R1
        ASR  R1

   .ifdef DebugMode
        BNZ  1$
       .inform_and_hang "SprDrawLn line to draw is 0"
    1$:
        CMP  R5,$0077777
        BLOS SprDrawLn_PixelLoop
       .inform_and_hang "SprDrawLn: dst out of FB"
   .endif

SprDrawLn_PixelLoop:
        # TODO: implement transparency
        MOV  (R3)+, R0
       .equiv srcTranspBitB, .+2
        CMP  R0,$0x0000
       #BEQ  SprDrawLn_NextWord
   .ifdef DebugSprite
        # test code, marks slow sprites so we can see they will be slow
        BIS  $0b1000000110000001,R0
   .endif
        MOV  R0,(R5)

SprDrawLn_NextWord:
        INC  R5
        INC  R5

        SOB  R1,SprDrawLn_PixelLoop

       .equiv srcSprShow_SpriteWidth, .+2
        ADD  $0x00,R4
        MOV  (SP)+,R5
        ADD  $80,R5
        DEC  R2
        BZE  1237$

       .equiv SprDrawLn_LineLoopBR, .
        BR   SprDrawLn_LineLoop # or NOP if double line draw

SprDrawLn_DoubleLine:
        ADD  $80,R5
        BR   SprDrawLn_LineLoop

1237$:  RETURN
#----------------------------------------------------------------------------}}}

# Turbo version
# SprDraw_TurboRenderer (SprDrawChooseRender)---------------------------------{{{
SprDraw_TurboRenderer_LineDoubler:
        MOV  $80-6,R1
        ASL  R2
        MOV  $SprDraw_TurboRenderer_24px_Double,R3
        JMP  (R3)
SprDraw_TurboRenderer: # Pick the render based on width
       .equiv srcTranspBitA, .+2
        MOV  $0x00,R0 # Set R0 to ZERO / Transp byte
        MOV  @$srcSprShow_DrawWidth,R1

    .ifdef DebugMode
        CMP  R1,$24
        BLOS SprDraw_TurboRenderer_Jump
       .inform_and_hang "SprDraw jump out of range"
    .endif

    SprDraw_TurboRenderer_Jump:
        JMP  @SprDraw_TurboRenderer_JumpTable-2(R1)

    SprDraw_TurboRenderer_JumpTable:
       .word SprDraw_TurboRenderer_8pxInit  #  2
       .word SprDraw_TurboRenderer_16pxInit #  4
       .word SprDraw_TurboRenderer_24pxInit #  6
       .word SprDraw_TurboRenderer_32pxInit #  8
       .word SprDraw_TurboRenderer_40pxInit # 10
       .word SprDraw_TurboRenderer_48pxInit # 12
       .word SprDraw_BasicRenderer          # 14 56
       .word SprDraw_BasicRenderer          # 16 64
       .word SprDraw_TurboRenderer_72pxInit # 18
       .word SprDraw_BasicRenderer          # 20 80
       .word SprDraw_BasicRenderer          # 22 88
       .word SprDraw_TurboRenderer_96pxInit # 24

    SprDraw_TurboRenderer_8pxInit:
        MOV  $80-2,R1
        MOV  $SprDraw_TurboRenderer_8px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_16pxInit:
        MOV  $80-4,R1
        MOV  $SprDraw_TurboRenderer_16px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_24pxInit:
        MOV  $80-6,R1
        MOV  $SprDraw_TurboRenderer_24px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_32pxInit:
        MOV  $80-8,R1
        MOV  $SprDraw_TurboRenderer_32px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_40pxInit:
        MOV  $80-10,R1
        MOV  $SprDraw_TurboRenderer_40px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_48pxInit:
        MOV  $80-12,R1
        MOV  $SprDraw_TurboRenderer_48px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_72pxInit:
        MOV  $80-18,R1
        MOV  $SprDraw_TurboRenderer_72px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_96pxInit:
        MOV  $80-24,R1
        MOV  $SprDraw_TurboRenderer_96px,R3
        JMP  (R3)

        # ********** A MUST BE the transparent byte for THIS WHOLE LOOP! ***********

    SprDraw_TurboRenderer_24px_Double:       # SprDraw24pxVer_Double:  ;Line doubler - does two nextlines each time
        BIT  $1,R2                  #         bit 0,C
        BZE  SprDraw_TurboRenderer_24px      #         jp z,SprDraw_TurboRenderer_LineSkip
        ADD  $6,R5
        BR   SprDraw_TurboRenderer_LineSkip  #         jp SprDraw24pxVer

# TODO: implement skipping the word if it has trasparency
SprDraw_TurboRenderer_96px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_88px: # unused
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_80px: # unused
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_72px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_64px: # unused
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_56px: # unused
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_48px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_40px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_32px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_24px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_16px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_8px:
        MOV  (R4)+,(R5)+
SprDraw_TurboRenderer_LineSkip:
        DEC  R2
        BZE  SprDraw_TurboRenderer_Done

        ADD  R1,R5
        JMP  (R3)

SprDraw_TurboRenderer_Done:
        RETURN
#----------------------------------------------------------------------------}}}

# Pset Version! no transparentcy, so fast! ----------------
# SprDraw_PsetRenderer (SprDrawChooseRenderPset)------------------------------{{{
SprDraw_PsetRenderer_LineDoubler:
        MOV  $80-6,R1
        ASL  R2
        MOV  $opcSOBToEndOfPsetDrawChain+22,@$SprDraw_PsetRenderer_SOB
        BR   SprDraw_PsetRenderer_Double

SprDraw_PsetRenderer:
        MOV  @$srcSprShow_DrawWidth,R1

    .ifdef DebugMode
        CMP  R1,$32
        BLOS SprDraw_PsetRendererJump
       .inform_and_hang "SprDraw_PsetRenderer jump out of range"
    .endif

    SprDraw_PsetRendererJump:
        JMP  @SprDraw_PsetRendererJumpTable-2(R1)
    SprDraw_PsetRendererJumpTable: #--------------------------------------------------{{{
       .word SprDraw_PsetRenderer8pxInit   #  2
       .word SprDraw_PsetRenderer16pxInit  #  4
       .word SprDraw_PsetRenderer24pxInit  #  6
       .word SprDraw_PsetRenderer32pxInit  #  8
       .word SprDraw_PsetRenderer40pxInit  # 10
       .word SprDraw_PsetRenderer48pxInit  # 12
       .word SprDraw_BasicRenderer         # 14 56
       .word SprDraw_PsetRenderer64pxInit  # 16
       .word SprDraw_PsetRenderer72pxInit  # 18
       .word SprDraw_PsetRenderer80pxInit  # 20
       .word SprDraw_BasicRenderer         # 22 88
       .word SprDraw_PsetRenderer96pxInit  # 24
       .word SprDraw_BasicRenderer         # 26 104
       .word SprDraw_BasicRenderer         # 28 112
       .word SprDraw_BasicRenderer         # 30 120
       .word SprDraw_PsetRenderer128pxInit # 32
    #------------------------------------------------------------------------}}}

    SprDraw_PsetRenderer8pxInit: #---------------------------------------------------{{{
        MOV  $80-2,R1
        MOV  $opcSOBToEndOfPsetDrawChain+1, @$SprDraw_PsetRenderer_SOB #  2 / 2 = 1
        BR   SprDraw_PsetRenderer8pxVer
    SprDraw_PsetRenderer16pxInit:
        MOV  $80-4,R1
        MOV  $opcSOBToEndOfPsetDrawChain+2, @$SprDraw_PsetRenderer_SOB #  4 / 2 = 2
        BR   SprDraw_PsetRenderer16pxVer
    SprDraw_PsetRenderer24pxInit:
        MOV  $80-6,R1
        MOV  $opcSOBToEndOfPsetDrawChain+3, @$SprDraw_PsetRenderer_SOB #  6 / 2 = 3
        BR   SprDraw_PsetRenderer24pxVer
    SprDraw_PsetRenderer32pxInit:
        MOV  $80-8,R1
        MOV  $opcSOBToEndOfPsetDrawChain+4, @$SprDraw_PsetRenderer_SOB #  8 / 2 = 4
        BR   SprDraw_PsetRenderer32pxVer
    SprDraw_PsetRenderer40pxInit:
        MOV  $80-10,R1
        MOV  $opcSOBToEndOfPsetDrawChain+5, @$SprDraw_PsetRenderer_SOB # 10 / 2 = 5
        MOV  $SprDraw_PsetRenderer40pxVer,R3
    SprDraw_PsetRenderer48pxInit:
        MOV  $80-12,R1
        MOV  $opcSOBToEndOfPsetDrawChain+6, @$SprDraw_PsetRenderer_SOB # 12 / 2 = 6
        BR   SprDraw_PsetRenderer48pxVer
    SprDraw_PsetRenderer64pxInit:
        MOV  $80-16,R1
        MOV  $opcSOBToEndOfPsetDrawChain+8, @$SprDraw_PsetRenderer_SOB # 16 / 2 = 8
        BR   SprDraw_PsetRenderer64pxVer
    SprDraw_PsetRenderer72pxInit:
        MOV  $80-18,R1
        MOV  $opcSOBToEndOfPsetDrawChain+9, @$SprDraw_PsetRenderer_SOB # 18 / 2 = 9
        BR   SprDraw_PsetRenderer72pxVer
    SprDraw_PsetRenderer80pxInit:
        MOV  $80-20,R1
        MOV  $opcSOBToEndOfPsetDrawChain+10,@$SprDraw_PsetRenderer_SOB # 20 / 2 = 10
        BR   SprDraw_PsetRenderer80pxVer
    SprDraw_PsetRenderer96pxInit:
        MOV  $80-24,R1
        MOV  $opcSOBToEndOfPsetDrawChain+12,@$SprDraw_PsetRenderer_SOB # 24 / 2 = 12
        BR   SprDraw_PsetRenderer96pxVer
    SprDraw_PsetRenderer128pxInit:
        MOV  $80-32,R1
        MOV  $opcSOBToEndOfPsetDrawChain+16,@$SprDraw_PsetRenderer_SOB # 32 / 2 = 16
        BR   SprDraw_PsetRenderer128pxVer
#----------------------------------------------------------------------------}}}
    SprDraw_PsetRenderer_Double:
        BIT  $1,R2
        BZE  SprDraw_PsetRenderer24pxVer
        ADD  $6,R5
        BR   SprDraw_PsetRenderer_LineSkip

    SprDraw_PsetRenderer128pxVer: #--------------------------------------------------{{{
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer96pxVer:
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer80pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer72pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer64pxVer:
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer48pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer40pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer32pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer24pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer16pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer8pxVer:
        MOV  (R4)+,(R5)+
    #------------------------------------------------------------------------}}}
       .equiv opcSOBToEndOfPsetDrawChain, 0077202

    SprDraw_PsetRenderer_LineSkip:
        ADD  R1,R5
    SprDraw_PsetRenderer_SOB:
        SOB  R2,SprDraw_PsetRenderer24pxVer

        RETURN
#----------------------------------------------------------------------------}}}

