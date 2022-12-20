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

        CLR  R4 # X bytes to skip, left
        CLR  R5 # X bytes to remove, right

        CMP  R2,R0  # check X, R0 = 24
        BHIS VirtualPos_1$
      # X < 24
        MOV  $24+3,R4
        SUB  R2,R4
        ASR  R4
        ASR  R4
        ASL  R4
        MOV  R4,R5 # need to skip R4 bytes
        MOV  R0,R2 # R2 is offscreen, so move it back on, R0 = 24
        BR   VirtualPos_2$

    VirtualPos_1$:
       .equiv SpriteSizeConfig184less12, .+2
        CMP  R2,$184-12    # check X
        BLO  VirtualPos_2$ # X < 172
        # X >= 172
       .equiv SpriteSizeConfigMinus184Plus12, .+2
        MOV  $-184+12,R3
        ADD  R2,R3
        ASR  R3
        ASR  R3
        ASL  R3 # align to word boundary
        ADD  R3,R5 # X pos is ok, but plot R5 less bytes

    VirtualPos_2$:
        SUB  R0,R2 # R0 = 24
        ASR  R2 # halve the result, as we have 80 bytes, but 160 x co-ords
        ASR  R2
        ASL  R2 # align to word boundary
      # using MOVB because MSB contains frame buffer offset
      # show_sprite.s:265
        MOVB R2,@$SprShow_ScrWord
      #-------------------------------------------------------------------------
      # R1 Y
        CLR  R2 # Y lines to skip
        CLR  R3 # Y lines to remove

        CMP  R1,R0 # check Y, R0 = 24
        BHIS VirtualPos_3$
      # Y < 24
        MOV  R0,R2
        SUB  R1,R2 # move the sprite R2 up
        MOV  R2,R3 # need to plot R2 less lines
        MOV  R0,R1 # R0 = 24
        BR   VirtualPos_4$

    VirtualPos_3$:
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
        BR   ShowSpriteReconfigure_24px

ShowSpriteReconfigure:
      # Akuyou was designed for 24x24 sprites, but this module can
      # 'reconfigure' it for other sizes
        MOV  R2,@$SpriteSizeConfig6
        JMP  @ShowSpriteReconfigureVectors-2(R2)

ShowSpriteReconfigureVectors:
       .word ShowSpriteReconfigure_8px  #  2 bytes wide
       .word ShowSpriteReconfigure_16px #  4 bytes wide
       .word ShowSpriteReconfigure_24px #  6 bytes wide
       .word ShowSpriteReconfigure_32px #  8 bytes wide
       .word null                       # 10 bytes wide
       .word ShowSpriteReconfigure_48px # 12 bytes wide
       .word null                       # 14 bytes wide
       .word null                       # 16 bytes wide
       .word null                       # 18 bytes wide
       .word null                       # 20 bytes wide
       .word null                       # 22 bytes wide
       .word ShowSpriteReconfigure_96px # 24 bytes wide

ShowSpriteReconfigure_128px: # Not actually used!
       #MOV  $184-64,R2
       #MOV  $-184+64,R3
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_104px: # Not actually used!
       #MOV  $184-52,R2
       #MOV  $-184+52,R3
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_96px:  # Used by Boss 1
        MOV  $184-48,@$SpriteSizeConfig184less12
        MOV  $-184+48,@$SpriteSizeConfigMinus184Plus12
        RETURN
ShowSpriteReconfigure_80px:  # Not actually used!
       #MOV  $184-40,R2
       #MOV  $-184+40,R3
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_64px:  # not actually used
       #MOV  $184-32,R2
       #MOV  $-184+32,R3
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_48px:
        MOV  $184-24,@$SpriteSizeConfig184less12
        MOV  $-184+24,@$SpriteSizeConfigMinus184Plus12
        RETURN
ShowSpriteReconfigure_32px:
        MOV  $184-16,@$SpriteSizeConfig184less12
        MOV  $-184+16,@$SpriteSizeConfigMinus184Plus12
        RETURN
ShowSpriteReconfigure_16px:
        MOV  $184- 8,@$SpriteSizeConfig184less12
        MOV  $-184+8,@$SpriteSizeConfigMinus184Plus12
        RETURN
ShowSpriteReconfigure_8px:
        MOV  $184-4,@$SpriteSizeConfig184less12
        MOV  $-184+4,@$SpriteSizeConfigMinus184Plus12
        RETURN
ShowSpriteReconfigure_24px:
        MOV  $184-12,@$SpriteSizeConfig184less12
        MOV  $-184+12,@$SpriteSizeConfigMinus184Plus12
        RETURN
