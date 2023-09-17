/*
*******************************************************************************
*                               Show Sprite                                   *
*******************************************************************************
We can preread a sprite to get the width/height
This is used for Direct sprites, and was used by the object loop
The object loop now assumes the sprite is 24x24, this was done to save time
as 97% of the time - it is
*/
      # input:
      # output: A  R0 sprite attributes
      #            R1 Y offset
      #         B  R2 width
      #         DE Sprbankaddr
      #         HL Sprite offset pointer
ShowSprite_ReadInfo: # ---------------------------------------------------------
       .equiv SprShow_SprNum, .+2
        MOV  $0,R0
        ASL  R0
        ASL  R0
        ASL  R0

       .equiv SprShow_BankAddr, .+2
        MOV  $LevelSprites,R1
        MOV  R1,R2 # store sprite bank address to calculate mask address
        ADD  R1,R0
        ADD  (R0)+,R1
        MOV  R1,@$SprShow_TempAddr

        ADD  (R0)+,R2
        MOV  R2,@$SprShow_MaskAddr

        MOVB (R0)+,R1
        BZE  SpriteGiveUp
        MOV  R1,@$SprShow_SprDstHeightLines # height of the sprite in lines

        MOVB (R0)+,R1 # Y offset
        MOVB (R0)+,R2 # width in bytes
      # don't care about sign extension, 80 is a maximum value
        MOV  R2,@$SprShow_SprDstWidthBytes
        MOV  R2,@$SprShow_SpriteWidth

      # Sprite attributes such as PSet, Doubleheight and transp color
        MOVB (R0),R0
        MOV  R0,@$SprShow_SprAttrs

        RETURN

    SpriteGiveUp:
      # Forcably quit not just getting info - but showing the sprite
        TST  (SP)+
        RETURN
#-------------------------------------------------------------------------------
SpriteRenderersVectors:
       .word SprDraw_TurboRenderer                # 0b0000  0
       .word SprDraw_TurboRenderer_LineDoubler    # 0b0010  2
       .word SprDraw_PsetRenderer                 # 0b0100  4
       .word SprDraw_PsetRenderer_LineDoubler     # 0b0110  6
       .word SprDraw_WithMaskRenderer             # 0b1000  8
       .word SprDraw_WithMaskRenderer_LineDoubler # 0b1010 10
#-------------------------------------------------------------------------------
ShowSprite: # ShowSprite is the main routine of our program!
        CALL @$ShowSprite_ReadInfo # Get Sprite Details
      # A  R0 sprite attributes
      #    R1 Y offset
      # B  R2 width
       .equiv SpriteSizeConfig6, .+2
        CMP  R2,$6 # 6 bytes, default sprite width
        BEQ  ShowSprite_SizeNotChanged

       .equiv dstShowSpriteReconfigureCommand, .+2
        CALL @$ShowSpriteReconfigure

ShowSprite_SizeNotChanged:
       .equiv SprShow_Y, .+2
        ADD  $48,R1
       .equiv SprShow_X, .+2
        MOV  $48,R2

      # Set renderer according to the sprite attributes
      # Bit 3 sprite with a bit-mask to clear background
      # Bit 2 forces "pset" - wipes background but faster
      # Bit 1 double height with bitmask
      # Bit 0 has to be clear
        MOV  SpriteRenderersVectors(R0),@$jmpShowSprite_DrawAndReturn

      # R1 Y
      # R2 X
        CALL @$VirtualPosToScreenByte
      # R2 Y lines to skip   | R4 X bytes to skip, left    #
      # R3 Y lines to remove | R5 X bytes to remove, right #

        MOV  R2,R0
        BIS  R3,R0
        BIS  R4,R0
        BIS  R5,R0
        BZE  ShowSprite_SkipCrop # if all are zero, do nothing

# truncate the sprite ----------------------------------------------------------
        MOV  $SprDraw_BasicRenderer,@$jmpShowSprite_DrawAndReturn
      # R3 less lines to draw
        SUB  R3,@$SprShow_SprDstHeightLines
        BLOS 1237$ # return if new height is <= 0

      # R5 = X bytes to remove from the right side
        SUB  R5,@$SprShow_SprDstWidthBytes
        BLOS 1237$ # return if new width is <= 0

      # R2 = lines to skip from the top
      # MUL beats ADD+SOB when factor is more than 2 in this case
        MUL  @$SprShow_SpriteWidth,R2
        ADD  R3,R4
      # R4 = X bytes to skip on the left side
        ADD  R4,@$SprShow_TempAddr
#-------------------------------------------------------------------------------
    ShowSprite_SkipCrop:
      # SprShow_ScrLine = Y - lines to skip
       .equiv SprShow_ScrLine, .+2
        MOV  $0x00,R5
   .ifdef DebugMode
        MUL  $80,R5
        ADD  $384,R5
   .else
        ASL  R5 # calculate the table entry offset
        MOV  scr_addr_table(R5),R5
   .endif
       .equiv ShowSprite_ActiveScreenBit14, .+2
       .equiv SprShow_ScrWord, .+2
        ADD  $0x4000,R5 # add X position and the frame buffer MSB

      # SprShow_SprDstHeightLines = (H - lines to remove) or (H - lines to skip)
       .equiv SprShow_SprDstHeightLines, .+2
        MOV  $0x00,R2
      # address of the visible part of the sprite
       .equiv SprShow_TempAddr, .+2
        MOV  $0x0000,R4

       .equiv jmpShowSprite_DrawAndReturn, .+2
        JMP  @$SprDraw_BasicRenderer

1237$:  RETURN

# This is our most basic render, its slow, but can do any size and clipping ----
SprDraw_BasicRenderer: # (SprDrawChooseRender)-------------------------------{{{
      # R2 number of lines
      # R4 sprite  address
      # R5 screen memory dst address
       #MOV  @$TranspBitA,@$TranspBitB

       .equiv LineLoopBR, 000400 + (SprDrawLn_LineLoop - SprDrawLn_LineLoopBR - 2) >> 1 & 0xFF
        MOV  $LineLoopBR,R0

       .equiv SprShow_SprAttrs, .+4
        BIT  $0x02,$0x00
        BZE  SprDrawLn_SetLineLoopBR

        MOV  $000240,R0 # NOP to remove BR to execute double line related code

SprDrawLn_SetLineLoopBR:
        MOV  R0, @$SprDrawLn_LineLoopBR

SprDrawLn_LineLoop:
        MOV  R5,-(SP)
        MOV  R4,R3
       .equiv SprShow_SprDstWidthBytes, .+2
        MOV  $0x00,R1
        ASR  R1

   .ifdef DebugMode
        BNZ  1$
       .inform_and_hang "BasicRenderer: line to draw is 0"
    1$:
        CMP  R5,$0077777
        BLOS SprDrawLn_PixelLoop
       .inform_and_hang "BasicRenderer: dst out of FB"
   .endif

SprDrawLn_PixelLoop:
        MOV  (R3)+, R0
        BZE  SprDrawLn_NextWord

   .ifdef DebugSprite
      # test code, marks slow sprites so we can see they will be slow
        BIS  $0b1000000110000001,R0
   .endif
        MOV  R0,(R5)

SprDrawLn_NextWord:
        INC  R5
        INC  R5

        SOB  R1,SprDrawLn_PixelLoop

       .equiv SprShow_SpriteWidth, .+2
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
# Turbo version ----------------------------------------------------------------
# SprDraw_TurboRenderer (SprDrawChooseRender)--------------------------------{{{
SprDraw_TurboRenderer_LineDoubler:
        MOV  $80-6,R1
        ASL  R2
        MOV  $SprDraw_TurboRenderer_24px_Double,R3
        JMP  (R3)
SprDraw_TurboRenderer: # Pick the render based on width
       .equiv TranspBitA, .+2
        MOV  $0x00,R0 # Set R0 to ZERO / Transp byte
        MOV  @$SprShow_SprDstWidthBytes,R1

    .ifdef DebugMode
        CMP  R1,$24
        BLOS SprDraw_TurboRenderer_Jump
       .inform_and_hang "TurboRenderer: jump out of range"
    .endif

    SprDraw_TurboRenderer_Jump:
        JMP  @SprDraw_TurboRenderer_JumpTable-2(R1)

    SprDraw_TurboRenderer_JumpTable:
       .word SprDraw_TurboRenderer_8pxInit  #  2  8
       .word SprDraw_TurboRenderer_16pxInit #  4 16
       .word SprDraw_TurboRenderer_24pxInit #  6 24
       .word SprDraw_TurboRenderer_32pxInit #  8 32
       .word SprDraw_WidthNotSupported      # 10 40
       .word SprDraw_TurboRenderer_48pxInit # 12 48
       .word SprDraw_WidthNotSupported      # 14 56
       .word SprDraw_WidthNotSupported      # 16 64
       .word SprDraw_WidthNotSupported      # 18 72
       .word SprDraw_WidthNotSupported      # 20 80
       .word SprDraw_WidthNotSupported      # 22 88
       .word SprDraw_TurboRenderer_96pxInit # 24 96

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
    SprDraw_TurboRenderer_48pxInit:
        MOV  $80-12,R1
        MOV  $SprDraw_TurboRenderer_48px,R3
        JMP  (R3)
    SprDraw_TurboRenderer_96pxInit:
        MOV  $80-24,R1
        MOV  $SprDraw_TurboRenderer_96px,R3
        JMP  (R3)

# ********** A MUST BE the transparent byte for THIS WHOLE LOOP! ***********

SprDraw_TurboRenderer_24px_Double: # Line doubler - does two nextlines each time
        BIT  $1,R2
        BZE  SprDraw_TurboRenderer_24px
        ADD  $6,R5
        BR   SprDraw_TurboRenderer_LineSkip

# TODO: implement skipping the word if it has trasparency
    SprDraw_TurboRenderer_96px:
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_96pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_96pxSkip:
        INC  R5
        INC  R5
   #SprDraw_TurboRenderer_88px: # not used
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_88pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_88pxSkip:
        INC  R5
        INC  R5
   #SprDraw_TurboRenderer_80px: # not used
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_80pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_80pxSkip:
        INC  R5
        INC  R5
   #SprDraw_TurboRenderer_72px: # not used
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_72pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_72pxSkip:
        INC  R5
        INC  R5
   #SprDraw_TurboRenderer_64px: # not used
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_64pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_64pxSkip:
        INC  R5
        INC  R5
   #SprDraw_TurboRenderer_56px: # not used
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_56pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_56pxSkip:
        INC  R5
        INC  R5
    SprDraw_TurboRenderer_48px:
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_48pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_48pxSkip:
        INC  R5
        INC  R5
   #SprDraw_TurboRenderer_40px: # not used
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_40pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_40pxSkip:
        INC  R5
        INC  R5
    SprDraw_TurboRenderer_32px:
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_32pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_32pxSkip:
        INC  R5
        INC  R5
    SprDraw_TurboRenderer_24px:
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_24pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_24pxSkip:
        INC  R5
        INC  R5
    SprDraw_TurboRenderer_16px:
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_16pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_16pxSkip:
        INC  R5
        INC  R5
    SprDraw_TurboRenderer_8px:
        MOV  (R4)+,R0
        BZE  SprDraw_TurboRenderer_8pxSkip
        MOV  R0,(R5)
        SprDraw_TurboRenderer_8pxSkip:
        INC  R5
        INC  R5

    SprDraw_TurboRenderer_LineSkip:
        DEC  R2
        BZE  SprDraw_TurboRenderer_Done

        ADD  R1,R5
        JMP  (R3)

SprDraw_TurboRenderer_Done:
        RETURN
#----------------------------------------------------------------------------}}}
# Pset Version! no transparentcy, so fast! -------------------------------------
# SprDraw_PsetRenderer (SprDrawChooseRenderPset)-----------------------------{{{
SprDraw_PsetRenderer_LineDoubler:
        MOV  $80-6,R1
        ASL  R2
        MOV  $opcSOBToEndOfPsetDrawChain+18,@$SprDraw_PsetRenderer_SOB
        BR   SprDraw_PsetRenderer_Double

SprDraw_PsetRenderer:
        MOV  @$SprShow_SprDstWidthBytes,R1

    .ifdef DebugMode
        CMP  R1,$24
        BLOS SprDraw_PsetRendererJump
       .inform_and_hang "PsetRenderer jump out of range"
    .endif

    SprDraw_PsetRendererJump:
        JMP  @SprDraw_PsetRendererJumpTable-2(R1)
    SprDraw_PsetRendererJumpTable: #-----------------------------------------{{{
       .word SprDraw_PsetRenderer8pxInit   #  2
       .word SprDraw_PsetRenderer16pxInit  #  4
       .word SprDraw_PsetRenderer24pxInit  #  6
       .word SprDraw_PsetRenderer32pxInit  #  8
       .word SprDraw_WidthNotSupported     # 10
       .word SprDraw_PsetRenderer48pxInit  # 12
       .word SprDraw_WidthNotSupported     # 14 56
       .word SprDraw_WidthNotSupported     # 16
       .word SprDraw_WidthNotSupported     # 18
       .word SprDraw_WidthNotSupported     # 20
       .word SprDraw_WidthNotSupported     # 22 88
       .word SprDraw_PsetRenderer96pxInit  # 24
    #------------------------------------------------------------------------}}}
    SprDraw_PsetRenderer8pxInit: #-------------------------------------------{{{
        MOV  $80-2,R1
        MOV  $opcSOBToEndOfPsetDrawChain+ 1,@$SprDraw_PsetRenderer_SOB #  2/2=1
        BR   SprDraw_PsetRenderer8pxVer
    SprDraw_PsetRenderer16pxInit:
        MOV  $80-4,R1
        MOV  $opcSOBToEndOfPsetDrawChain+ 2,@$SprDraw_PsetRenderer_SOB #  4/2=2
        BR   SprDraw_PsetRenderer16pxVer
    SprDraw_PsetRenderer24pxInit:
        MOV  $80-6,R1
        MOV  $opcSOBToEndOfPsetDrawChain+ 3,@$SprDraw_PsetRenderer_SOB #  6/2=3
        BR   SprDraw_PsetRenderer24pxVer
    SprDraw_PsetRenderer32pxInit:
        MOV  $80-8,R1
        MOV  $opcSOBToEndOfPsetDrawChain+ 4,@$SprDraw_PsetRenderer_SOB #  8/2=4
        BR   SprDraw_PsetRenderer32pxVer
    SprDraw_PsetRenderer48pxInit:
        MOV  $80-12,R1
        MOV  $opcSOBToEndOfPsetDrawChain+ 6,@$SprDraw_PsetRenderer_SOB # 12/2=6
        BR   SprDraw_PsetRenderer48pxVer
    SprDraw_PsetRenderer96pxInit:
        MOV  $80-24,R1
        MOV  $opcSOBToEndOfPsetDrawChain+12,@$SprDraw_PsetRenderer_SOB # 24/2=12
        BR   SprDraw_PsetRenderer96pxVer
#----------------------------------------------------------------------------}}}
    SprDraw_PsetRenderer_Double:
        BIT  $1,R2
        BZE  SprDraw_PsetRenderer24pxVer
        ADD  $6,R5
        BR   SprDraw_PsetRenderer_LineSkip

    SprDraw_PsetRenderer96pxVer:
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
   #SprDraw_PsetRenderer80pxVer: # not used
        MOV  (R4)+,(R5)+
   #SprDraw_PsetRenderer72pxVer: # not used
        MOV  (R4)+,(R5)+
   #SprDraw_PsetRenderer64pxVer: # not used
        MOV  (R4)+,(R5)+
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer48pxVer:
        MOV  (R4)+,(R5)+
   #SprDraw_PsetRenderer40pxVer: # not used
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer32pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer24pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer16pxVer:
        MOV  (R4)+,(R5)+
    SprDraw_PsetRenderer8pxVer:
        MOV  (R4)+,(R5)+
    #---------------------------------------------------------------------------
       .equiv opcSOBToEndOfPsetDrawChain, 0077202

    SprDraw_PsetRenderer_LineSkip:
        ADD  R1,R5
    SprDraw_PsetRenderer_SOB:
        SOB  R2,SprDraw_PsetRenderer24pxVer

        RETURN
#----------------------------------------------------------------------------}}}
# Version that uses mask to clear background -----------------------------------
# SprDraw_WithMaskRenderer --------------------------------------------------{{{
SprDraw_WithMaskRenderer_Vectors:
       .word SprDraw_WithMaskRenderer_8pxInit   #  2  8
       .word SprDraw_WithMaskRenderer_16pxInit  #  4 16
       .word SprDraw_WithMaskRenderer_24pxInit  #  6 24
       .word SprDraw_WithMaskRenderer_32pxInit  #  8 32
       .word SprDraw_WidthNotSupported          # 10 40
       .word SprDraw_WithMaskRenderer_48pxInit  # 12 48
       .word SprDraw_WidthNotSupported          # 14 56
       .word SprDraw_WidthNotSupported          # 16 64
       .word SprDraw_WidthNotSupported          # 18 72
       .word SprDraw_WidthNotSupported          # 20 80
       .word SprDraw_WidthNotSupported          # 22 88
       .word SprDraw_WithMaskRenderer_96pxInit  # 24 96

SprDraw_WithMaskRenderer_LineDoubler:
        MOV  $80-6,R1
        MOV  R5,R3
        ASL  R2
        PUSH R2
        MOV  $opcSOBToEndOfWithMaskBICBChain +24+6,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain +12+6,@$SprDraw_WithMaskRenderer_BIS_SOB #  2/2=1
        CLRB @$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_Double_BICB

SprDraw_WithMaskRenderer:
       .equiv SprShow_MaskAddr, .+2
        MOV  $0x0000,R0
        MOV  @$SprShow_SprDstWidthBytes,R1
        MOV  R5,R3
        PUSH R2

    SprDraw_WithMaskRenderer_Jump:
        JMP  @SprDraw_WithMaskRenderer_Vectors-2(R1)

    SprDraw_WithMaskRenderer_8pxInit: #--------------------------------------{{{
        MOV  $80-2,R1
        MOV  $opcSOBToEndOfWithMaskBICBChain+ 2,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain+ 1,@$SprDraw_WithMaskRenderer_BIS_SOB #  2/2=1
        MOVB $11+6,@$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_8pxBICB
    SprDraw_WithMaskRenderer_16pxInit:
        MOV  $80-4,R1
        MOV  $opcSOBToEndOfWithMaskBICBChain+ 4,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain+ 2,@$SprDraw_WithMaskRenderer_BIS_SOB #  4/2=2
        MOVB $10+6,@$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_16pxBICB
    SprDraw_WithMaskRenderer_24pxInit:
        MOV  $80-6,R1
        MOV  $opcSOBToEndOfWithMaskBICBChain+ 6,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain+ 3,@$SprDraw_WithMaskRenderer_BIS_SOB #  6/2=3
        MOVB $9+6,@$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_24pxBICB
    SprDraw_WithMaskRenderer_32pxInit:
        MOV  $80-8,R1
        MOV  $opcSOBToEndOfWithMaskBICBChain+ 8,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain+ 4,@$SprDraw_WithMaskRenderer_BIS_SOB #  8/2=4
        MOVB $8+6,@$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_32pxBICB
    SprDraw_WithMaskRenderer_48pxInit:
        MOV  $80-12,R1
        MOV  $opcSOBToEndOfWithMaskBICBChain+12,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain+ 6,@$SprDraw_WithMaskRenderer_BIS_SOB # 12/2=6
        MOVB $6+6,@$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_48pxBICB
    SprDraw_WithMaskRenderer_96pxInit:
        MOV  $80-24,R1
        MOV  $opcSOBToEndOfWithMaskBICBChain+24,@$SprDraw_WithMaskRenderer_BICB_SOB #
        MOV  $opcSOBToEndOfWithMaskBISChain+12,@$SprDraw_WithMaskRenderer_BIS_SOB # 24/2=12
        MOV  $0+6, @$SprDraw_BR_to_BIS
        BR   SprDraw_WithMaskRenderer_96pxBICB
#----------------------------------------------------------------------------}}}
    SprDraw_WithMaskRenderer_Double_BICB:
        BIT  $0b0001,R2
        BZE  SprDraw_WithMaskRenderer_24pxBICB
        ADD  $6,R3
        BR   SprDraw_WithMaskRenderer_BICB_LineSkip

    SprDraw_WithMaskRenderer_96pxBICB:
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
   #SprDraw_WithMaskRenderer_88pxBICB: # not used
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
   #SprDraw_WithMaskRenderer_80pxBICB: # not used
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
   #SprDraw_WithMaskRenderer_72pxBICB: # not used
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
   #SprDraw_WithMaskRenderer_64pxBICB: # not used
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
   #SprDraw_WithMaskRenderer_56pxBICB: # not used
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
    SprDraw_WithMaskRenderer_48pxBICB:
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
   #SprDraw_WithMaskRenderer_40pxBICB: # not used
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
    SprDraw_WithMaskRenderer_32pxBICB:
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
    SprDraw_WithMaskRenderer_24pxBICB:
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
    SprDraw_WithMaskRenderer_16pxBICB:
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
    SprDraw_WithMaskRenderer_8pxBICB:
        BICB (R0) ,(R3)+
        BICB (R0)+,(R3)+
    #---------------------------------------------------------------------------
       .equiv opcSOBToEndOfWithMaskBICBChain, 0077202

    SprDraw_WithMaskRenderer_BICB_LineSkip:
        ADD  R1,R3
    SprDraw_WithMaskRenderer_BICB_SOB:
        SOB  R2,SprDraw_WithMaskRenderer_24pxBICB

        POP  R2

    SprDraw_BR_to_BIS:
        BR   SprDraw_WithMaskRenderer_24pxBIS

    SprDraw_WithMaskRenderer_Double_BIS:
        BIT  $1,R2
        BZE  SprDraw_WithMaskRenderer_24pxBIS
        ADD  $6,R5
        BR   SprDraw_WithMaskRenderer_BIS_LineSkip

    SprDraw_WithMaskRenderer_96pxBIS:
        BIS  (R4)+,(R5)+
   #SprDraw_WithMaskRenderer_88pxBIS: # not used
        BIS  (R4)+,(R5)+
   #SprDraw_WithMaskRenderer_80pxBIS: # not used
        BIS  (R4)+,(R5)+
   #SprDraw_WithMaskRenderer_72pxBIS: # not used
        BIS  (R4)+,(R5)+
   #SprDraw_WithMaskRenderer_64pxBIS: # not used
        BIS  (R4)+,(R5)+
   #SprDraw_WithMaskRenderer_56pxBIS: # not used
        BIS  (R4)+,(R5)+
    SprDraw_WithMaskRenderer_48pxBIS:
        BIS  (R4)+,(R5)+
   #SprDraw_WithMaskRenderer_40pxBIS: # not used
        BIS  (R4)+,(R5)+
    SprDraw_WithMaskRenderer_32pxBIS:
        BIS  (R4)+,(R5)+
    SprDraw_WithMaskRenderer_24pxBIS:
        BIS  (R4)+,(R5)+
    SprDraw_WithMaskRenderer_16pxBIS:
        BIS  (R4)+,(R5)+
    SprDraw_WithMaskRenderer_8pxBIS:
        BIS  (R4)+,(R5)+
    #---------------------------------------------------------------------------
       .equiv opcSOBToEndOfWithMaskBISChain, 0077202

    SprDraw_WithMaskRenderer_BIS_LineSkip:
        ADD  R1,R5
    SprDraw_WithMaskRenderer_BIS_SOB:
        SOB  R2,SprDraw_WithMaskRenderer_24pxBIS

        RETURN
#----------------------------------------------------------------------------}}}
SprDraw_WidthNotSupported:
       .inform_and_hang2 "Spr Width not supported"
