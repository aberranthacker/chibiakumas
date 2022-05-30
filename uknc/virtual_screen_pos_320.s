/*
--------------------------------------------------------------------------------
  Virtual Screen pos

  input  B=VitrualX; C=VirtualY

  output B=ScreenByteX; C=ScreenY (Y=255 if ofscreen)
         H X bytes to skip;  L X bytes to remove
         D Y lines to skip;  E Y lines to remove
--------------------------------------------------------------------------------
    The virtual screen has a resolution of 160x200, with a 24 pixel border,
which is used for clipping
    Y=0 is used by the code to denote a 'dead' object which will be deleted
from the list
--------------------------------------------------------------------------------
  Virtual Screen pos

  input  R1=VitrualX; R2=VirtualY

  output R2=ScreenByteX; R1=ScreenY (Y=255 if offscreen)
         R4 X bytes to skip;  R5 X bytes to remove
         R2 Y lines to skip;  R3 Y lines to remove
--------------------------------------------------------------------------------
*/
VirtualPosToScreenByte:
        #  we use a virtual screen size
        #  X width  is 208 (160 onscreen - 2 per byte)
        #  Y height is 248 (200 onscreen - 1 per line)
        #
        #  this is to allow for partially onscreen sprites
        #  and to keep co-ords in 1 byte
        #  X < 24 or X >= 184 is not drawn
        #  Y < 24 or Y >= 224 is not drawn

        # R1 = Y, R2 = X, R0 = Xoff
    #---------------------------------------------------------------------------
    .list
        CLR  R4 # X bytes to skip
    .nolist
        CLR  R5 # X bytes to remove
        # only works with 24 pixel sprites
        CMP  R2,$24     # check X
       .equiv cmpSpriteSizeConfig24, .-2
        BHIS VirtualPos_1$
        # X < 24
        MOV  $25,R4
       .equiv srcSpriteSizeConfig25, .-2
        SUB  R2,R4
        RORB R4     # move the sprite R4 left
        MOV  R4,R5  # need to plot R4 less bytes
        MOV  $24,R2 # R2 was offscreen, so move it back on
       .equiv srcSpriteSizeConfig24B, .-2
        BR   VirtualPos_2$

    VirtualPos_1$:
        CMP  R2,$184-12 # check X
       .equiv cmpSpriteSizeConfig184less12, .-2
        BLOS VirtualPos_2$ # X <= 172
        # X > 172
        MOV  R2,R0
        SUB  $184-12,R0
       .equiv srcSpriteSizeConfig184less12, .-2
        RORB R0
        ADD  R0,R5 # X pos is ok, but plot R0 less -bytes-

    VirtualPos_2$:
        SUB  $24,R2
       .equiv srcSpriteSizeConfig24C, .-2
        RORB R2 # halve the result, as we have 80 bytes, but 160 x co-ords
        # using MOVB because MSB contains frame buffer offset
        # show_sprite.s:265
        MOVB R2,@$srcSprShow_TempX
    #---------------------------------------------------------------------------
        # R1 Y
        CLR  R2 # Y lines to skip
        CLR  R3 # Y lines to remove

        CMP  R1,$24 # check Y
       .equiv cmpSpriteSizeConfig24D, .-2
        BHIS VirtualPos_3$
        # Y < 24
        MOV  $24,R2
       .equiv srcSpriteSizeConfig24E, .-2
        SUB  R1,R2 # move the sprite R2  up
        MOV  R2,R3 # need to plot A less lines
        MOV  $24,R1
       .equiv srcSpriteSizeConfig24F, .-2
        BR   VirtualPos_4$

    VirtualPos_3$:
        CMP  R1,$224-24 # check Y
       .equiv cmpSpriteSizeConfig224less24, .-2
        BLO  VirtualPos_4$
        # Y > 224
        MOV  R1,R3
        SUB  $224-24,R3
       .equiv srcSpriteSizeConfig224less24, .-2

    VirtualPos_4$:
        SUB  $24,R1
       .equiv srcSpriteSizeConfig24G, .-2
        MOV  R1,@$srcSprShow_TempY

        RETURN

#-------------------------------------------------------------------------------
       .global ShowSpriteReconfigureEnableDisable
ShowSpriteReconfigureEnableDisable:
        MOV  $null,R5
        TST  R0
        BEQ  ShowSpriteReconfigureEnableDisableB
        MOV  $ShowSpriteReconfigure,R5
ShowSpriteReconfigureEnableDisableB:
        MOV  R5,@$dstShowSpriteReconfigureCommand
        BR   ShowSpriteReconfigure_24px

ShowSpriteReconfigure:
        MOV  R1,@$cmpSpriteSizeConfig6
        # Akuyou was designed for 24x24 sprites, but this module can
        # 'reconfigure' it for other sizes
        CMP  R1,$6
        BEQ  ShowSpriteReconfigure_24px
        CMP  R1,$8
        BEQ  ShowSpriteReconfigure_32px
        CMP  R1,$12
        BEQ  ShowSpriteReconfigure_48px
        CMP  R1,$16
        BEQ  ShowSpriteReconfigure_64px
        CMP  R1,$20
        BEQ  ShowSpriteReconfigure_80px
        CMP  R1,$24
        BEQ  ShowSpriteReconfigure_96px
        CMP  R1,$32
        BEQ  ShowSpriteReconfigure_128px
        CMP  R1,$2
        BEQ  ShowSpriteReconfigure_8px
        CMP  R1,$4
        BEQ  ShowSpriteReconfigure_16px

        RETURN

ShowSpriteReconfigure_128px: # Not actually used!
        MOV  $184-64,R1
        MOV  $224-24,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_104px: # Not actually used!
        MOV  $184-52,R1
        MOV  $224-96,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_96px:  # Used by Boss 1
        MOV  $184-48,R1
        MOV  $224-24,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_80px:  # Not actually used!
        MOV  $184-40,R1
        MOV  $224-80,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_48px:
        MOV  $184-24,R1
        MOV  $224-48,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_32px:
        MOV  $184-16,R1
        MOV  $224-32,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_64px:  # not actually used
        MOV  $184-32,R1
        MOV  $224-64,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_16px:
        MOV  $184- 8,R1
        MOV  $224-16,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_8px:
        MOV  $184- 4,R1
        MOV  $224- 8,R2
        BR   ShowSpriteReconfigure_all
ShowSpriteReconfigure_24px:
        MOV  $184-12,R1
        MOV  $224-24,R2

ShowSpriteReconfigure_all:
        # Right X
        MOV  R1,$cmpSpriteSizeConfig184less12
        MOV  R1,$srcSpriteSizeConfig184less12

        # Bottom Y
        MOV  R2,$cmpSpriteSizeConfig224less24
        MOV  R2,$srcSpriteSizeConfig224less24

        RETURN
