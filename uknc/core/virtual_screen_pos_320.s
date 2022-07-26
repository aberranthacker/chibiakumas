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
       .equiv SpriteSizeConfig224less24A, .+2
        CMP  R1,$224-24 # check Y
        BLO  VirtualPos_4$
      # Y > 224
        MOV  R1,R3
       .equiv SpriteSizeConfig224less24B, .+2
        SUB  $224-24,R3

    VirtualPos_4$:
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
        MOV  R2,@$SpriteSizeConfig6
      # Akuyou was designed for 24x24 sprites, but this module can
      # 'reconfigure' it for other sizes
        CMP  R2,$6
        BEQ  ShowSpriteReconfigure_24px
        CMP  R2,$8
        BEQ  ShowSpriteReconfigure_32px
        CMP  R2,$12
        BEQ  ShowSpriteReconfigure_48px
       #CMP  R2,$16
       #BEQ  ShowSpriteReconfigure_64px
       #CMP  R2,$20
       #BEQ  ShowSpriteReconfigure_80px
        CMP  R2,$24
        BEQ  ShowSpriteReconfigure_96px
       #CMP  R2,$32
       #BEQ  ShowSpriteReconfigure_128px
        CMP  R2,$2
        BEQ  ShowSpriteReconfigure_8px
        CMP  R2,$4
        BEQ  ShowSpriteReconfigure_16px

        RETURN

ShowSpriteReconfigure_128px: # Not actually used!
       #MOV  $184-64,R2
       #MOV  $-184+64,R3
       #MOV  $224-128,R4
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_104px: # Not actually used!
       #MOV  $184-52,R2
       #MOV  $-184+52,R3
       #MOV  $224-104,R4
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_96px:  # Used by Boss 1
        MOV  $184-48,R2
        MOV  $-184+48,R3
        MOV  $224-96,R4
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_80px:  # Not actually used!
       #MOV  $184-40,R2
       #MOV  $-184+40,R3
       #MOV  $224-80,R4
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_64px:  # not actually used
       #MOV  $184-32,R2
       #MOV  $-184+32,R3
       #MOV  $224-64,R4
       #BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_48px:
        MOV  $184-24,R2
        MOV  $-184+24,R3
        MOV  $224-48,R4
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_32px:
        MOV  $184-16,R2
        MOV  $-184+16,R3
        MOV  $224-32,R4
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_16px:
        MOV  $184- 8,R2
        MOV  $-184+8,R3
        MOV  $224-16,R4
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_8px:
        MOV  $184-4,R2
        MOV  $-184+4,R3
        MOV  $224-8,R4
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_24px:
        MOV  $184-12,R2
        MOV  $-184+12,R3
        MOV  $224-24,R4

ShowSpriteReconfigure_all:
        # Right X
        MOV  R2,@$SpriteSizeConfig184less12
        MOV  R3,@$SpriteSizeConfigMinus184Plus12

        # Bottom Y
        MOV  R4,@$SpriteSizeConfig224less24A
        MOV  R4,@$SpriteSizeConfig224less24B

        RETURN
