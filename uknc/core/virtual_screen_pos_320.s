/*
--------------------------------------------------------------------------------
  Virtual Screen pos

  input  R1=VitrualY; R2=VirtualX

  output R2=ScreenByteX; R1=ScreenY (Y=255 if offscreen)
         R4 X bytes to skip;  R5 X bytes to remove
 --------------------------------------------------------------------------------
    The virtual screen has a resolution of 160x200, with a 24 pixel border,
which is used for clipping
    Y=0 is used by the code to denote a 'dead' object which will be deleted
from the list
--------------------------------------------------------------------------------
*/
VirtualPosToScreenByte:
      # we use a virtual screen size
      # X width  is 208 (160 onscreen - 2 per byte)
      # Y height is 248 (200 onscreen - 1 per line)
      #
      # this is to allow for partially onscreen sprites
      # and to keep co-ords in 1 byte
      # X < 24 or X >= 184 is not drawn
      # Y < 24 or Y >= 224 is not drawn

      # input:  R1 = Y, R2 = X
      # output: R2 = Y lines to skip
      #         R3 = Y lines to remove
      #         R4 = X bytes to skip, left
      #         R5 = X bytes to remove, right
      #-------------------------------------------------------------------------
        MOV  $24,R0

        CMP  R2,R0  # check X, R0 = 24
        BHIS VirtualPos_1$
      # X < 24
        MOV  $24+3,R4
        SUB  R2,R4
        ASR  R4
        ASR  R4
        ASL  R4 # ASR/ASL to align to word boundary (clear bit 0)
        MOV  R4,R5 # need to skip R4 bytes
        MOV  R0,R2 # R2 is offscreen, so move it back on, R0 = 24
        BR   VirtualPos_2$

    VirtualPos_1$:
        CLR  R4 # X bytes to skip, left
        CLR  R5 # X bytes to remove, right

       .equiv SpriteSizeConfig184less12, .+2
        CMP  R2,$184-12    # check X
        BLO  VirtualPos_2$ # X < 172

      # X >= 172
      # X pos is ok, but plot R5 less bytes
       .equiv SpriteSizeConfigMinus184Plus12, .+2
        MOV  $-184+12,R5
        ADD  R2,R5
        ASR  R5
        ASR  R5
        ASL  R5 # ASR/ASL to align to word boundary (clear bit 0)

    VirtualPos_2$:
        SUB  R0,R2 # R0 = 24
        ASR  R2 # halve the result, as we have 80 bytes, but 160 x co-ords
        ASR  R2
        ASL  R2 # ASR/ASL to align to word boundary (clear bit 0)
      # using MOVB because MSB contains frame buffer offset
      # show_sprite.s:265
        MOVB R2,@$SprShow_ScrWord
      #-------------------------------------------------------------------------
      # R1 Y
        CMP  R1,R0 # check Y, R0 = 24
        BHIS VirtualPos_3$
      # Y < 24
        MOV  R0,R2
        SUB  R1,R2 # move the sprite R2 up
        MOV  R2,R3 # need to plot R2 less lines
        MOV  R0,R1 # R0 = 24
        BR   VirtualPos_4$

    VirtualPos_3$:
        CLR  R2 # no lines to skip from the top of the sprite
        MOV  R1,R3
        ADD  @$SprShow_SprDstHeightLines,R3
        CMP  R3,$224  # check if (Y + height) > 224
        BHI  VirtualPos_5$
      # (Y + height) <= 224
        CLR  R3

    VirtualPos_4$:
        SUB  R0,R1 # R0 = 24
        MOV  R1,@$SprShow_ScrLine

        RETURN

    VirtualPos_5$:
      # (Y + height) > 224
        SUB  $224,R3
        SUB  R0,R1 # R0 = 24
        MOV  R1,@$SprShow_ScrLine

        RETURN
#-------------------------------------------------------------------------------
ShowSpriteReconfigureEnableDisable:
        MOV  $null,R5
        TST  R0
        BEQ  ShowSpriteReconfigureEnableDisableB

        MOV  $ShowSpriteReconfigure,R5
ShowSpriteReconfigureEnableDisableB:
        MOV  R5,@$dstShowSpriteReconfigureCommand
        MOV  $6,R2 # reconfigure width to 24px

ShowSpriteReconfigure:
      # Akuyou was designed for 24x24 sprites, but this module can
      # 'reconfigure' it for other sizes
        MOV  R2,@$SpriteSizeConfig6
        MOV  SpriteSizeConfig184less12_Vectors-2(R2),@$SpriteSizeConfig184less12
        MOV  SpriteSizeConfigMinus184Plus12_Vectors-2(R2),@$SpriteSizeConfigMinus184Plus12
        RETURN

SpriteSizeConfig184less12_Vectors:
       .word 184 -  4  #  2 bytes,  8px wide
       .word 184 -  8  #  4 bytes, 16px wide
       .word 184 - 12  #  6 bytes, 24px wide
       .word 184 - 16  #  8 bytes, 32px wide
       .word 184 - 20  # 10 bytes, 40px wide
       .word 184 - 24  # 12 bytes, 48px wide
       .word 184 - 28  # 14 bytes, 56px wide
       .word 184 - 32  # 16 bytes, 64px wide
       .word 184 - 36  # 18 bytes, 72px wide
       .word 184 - 40  # 20 bytes, 80px wide
       .word 184 - 44  # 22 bytes, 88px wide
       .word 184 - 48  # 24 bytes, 96px wide

SpriteSizeConfigMinus184Plus12_Vectors:
       .word -184 +  4 #  2 bytes,  8px wide
       .word -184 +  8 #  4 bytes, 16px wide
       .word -184 + 12 #  6 bytes, 24px wide
       .word -184 + 16 #  8 bytes, 32px wide
       .word -184 + 20 # 10 bytes, 40px wide
       .word -184 + 24 # 12 bytes, 48px wide
       .word -184 + 28 # 14 bytes, 56px wide
       .word -184 + 32 # 16 bytes, 64px wide
       .word -184 + 36 # 18 bytes, 72px wide
       .word -184 + 40 # 20 bytes, 80px wide
       .word -184 + 44 # 22 bytes, 88px wide
       .word -184 + 48 # 24 bytes, 96px wide
