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
VirtualPosToScreenByte:                                     # VirtualPosToScreenByte:
                                                            #     ld HL,&0000
                                                            #     ld D,h
                                                            #     ld e,h

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
        CLR  R4 # X bytes to skip
        CLR  R5 # X bytes to remove
                                                            #     ; only works with 24 pixel sprites
        # check X                                           #     ld a,B  ;Check X
        CMP  R2,(PC)+; cmpSpriteSizeConfig24: .word 24      #     cp 24 :SpriteSizeConfig24_Plus1
        BHIS VirtualPos_1$                                  #     jp NC,VirtualPos_1  ; jp is faster if we expect it to be true!
        # X < 24                                            # ; X<24
        MOV  (PC)+,R4; srcSpriteSizeConfig25: .word 25      #     ld a,25 :SpriteSizeConfig25_Plus1
        SUB  R2,R4                                          #     sub a,B
        RORB R4                                             #     RRA
        MOV  R4,R5                                          #     ld H,A  ;move the sprite A left
                                                            #     ld L,A  ;need to plot A less bytes
                                                            #
        MOV  (PC)+,R2; srcSpriteSizeConfig24B: .word 24     #     ld B,24  :SpriteSizeConfig24B_Plus1;B was offscreen, so move it back on
        BR   VirtualPos_2$                                  #     jp VirtualPos_2
    VirtualPos_1$:                                          # VirtualPos_1:
                                                            #     ;ld a,B ;Check X
        CMP  R2,(PC)+; cmpSpriteSizeConfig184less12: .word 184-12 #     cp 184-12 :SpriteSizeConfig184less12_Plus1
        BLOS VirtualPos_2$ # X <= 172                       #     jp C,VirtualPos_1
        # X > 172
        MOV  R2,R0                                          #     ld a,B
        SUB  (PC)+,R0; srcSpriteSizeConfig184less12: .word 184-12 #     sub 184-12 :SpriteSizeConfig184less12B_Plus1
                                                            #
        RORB R0                                             #     RRA
                                                            #
        ADD  R0,R5 # X pos is ok, but plot R0 less -words-  #     add L   ;   X pos is ok, but plot A less bytes
                                                            #     ld L,A
                                                            #     ;ld a,B ;Check X
    VirtualPos_2$:                                          # VirtualPos_2:
                                                            #     ld a,B  ;Check X
        SUB  (PC)+,R2; srcSpriteSizeConfig24C: .word 24     #     sub 24 :SpriteSizeConfig24C_Plus1
        RORB R2                                             #     RRA ; halve the result, as we have 80 bytes, but 160 x co-ords
        MOVB R2,@$srcSprShow_TempX                          #     ld B,a
    #---------------------------------------------------------------------------
        # R1 Y
        CLR  R2 # Y lines to skip
        CLR  R3 # Y lines to remove
                                                            #     ld a,C  ;Check Y
        CMP  R1,(PC)+; cmpSpriteSizeConfig24D: .word 24     #     cp 24 :SpriteSizeConfig24D_Plus1
        BHIS VirtualPos_3$                                  #     jp NC,VirtualPos_3
                                                            # ; Y<24
        MOV  (PC)+,R2; srcSpriteSizeConfig24E: .word 24     #     ld a,24 :SpriteSizeConfig24E_Plus1
        SUB  R1,R2                                          #     sub a,C
        MOV  R2,R3                                          #     ld D,A  ;move the sprite A up
                                                            #     ld E,A  ;need to plot A less lines
        MOV  (PC)+,R1; srcSpriteSizeConfig24F: .word 24     #     ld C,24 :SpriteSizeConfig24F_Plus1
        BR   VirtualPos_4$                                  #     jp VirtualPos_4
    VirtualPos_3$:                                          # VirtualPos_3:
                                                            #     ;ld a,C ;Check Y
        CMP  R1,(PC)+; cmpSpriteSizeConfig224less24: .word 224-24 #     cp 224-24 :SpriteSizeConfig224less24_Plus1
        BLO  VirtualPos_4$                                  #     jp C,VirtualPos_4
                                                            # ; Y>224
        MOV  R1,R3                                          #     ld a,C
        SUB  (PC)+,R3; srcSpriteSizeConfig224less24: .word 224-24 #     sub 224-24 :SpriteSizeConfig224less24B_Plus1
                                                            #     ld E,A
    VirtualPos_4$:                                          # VirtualPos_4:
        SUB  (PC)+,R1; srcSpriteSizeConfig24G: .word 24     #     ld a,C  ;Check Y
        MOV  R1,@$srcSprShow_TempY                          #     sub 24 :SpriteSizeConfig24G_Plus1
                                                            #     ld C,a
RETURN                                                      #     ret

ShowSpriteReconfigureEnableDisable:                         # ShowSpriteReconfigureEnableDisable:
       .global ShowSpriteReconfigureEnableDisable
        MOV  $null,R5                                       #     ld hl,null
        TST  R0                                             #     or a
        BEQ  ShowSpriteReconfigureEnableDisableB            #     jr z,ShowSpriteReconfigureEnableDisableB
        MOV  $ShowSpriteReconfigure,R5                      #     ld hl,ShowSpriteReconfigure
ShowSpriteReconfigureEnableDisableB:                        # ShowSpriteReconfigureEnableDisableB:
        MOV  R5,@$dstShowSpriteReconfigureCommand           #     ld (ShowSpriteReconfigureCommand_Plus2-2),hl
        BR   ShowSpriteReconfigure_24px                     #     jr ShowSpriteReconfigure_24px

ShowSpriteReconfigure:                                      # ShowSpriteReconfigure:
        MOV  R1,@$cmpSpriteSizeConfig6                      #     ld (SpriteSizeConfig6_Plus1-1),a
        # Akuyou was designed for 24x24 sprites, but this module can
        # 'reconfigure' it for other sizes
        CMP  R1,$6                                          #     cp 6 ;24px
        BEQ  ShowSpriteReconfigure_24px                     #     jp z,ShowSpriteReconfigure_24px
        CMP  R1,$8                                          #     cp 8 ;32px
        BEQ  ShowSpriteReconfigure_32px                     #     jp z,ShowSpriteReconfigure_32px
        CMP  R1,$12                                         #     cp 12 ;32px
        BEQ  ShowSpriteReconfigure_48px                     #     jp z,ShowSpriteReconfigure_48px
        CMP  R1,$16                                         #     cp 16 ;64px
        BEQ  ShowSpriteReconfigure_64px                     #     jr z,ShowSpriteReconfigure_64px
        CMP  R1,$20                                         #     cp 20 ;80px
        BEQ  ShowSpriteReconfigure_80px                     #     jr z,ShowSpriteReconfigure_80px
        CMP  R1,$24                                         #     cp 24 ;96px
        BEQ  ShowSpriteReconfigure_96px                     #     jr z,ShowSpriteReconfigure_96px
        CMP  R1,$32                                         #     cp 32 ;128px
        BEQ  ShowSpriteReconfigure_128px                    #     jr z,ShowSpriteReconfigure_128px
        CMP  R1,$2                                          #     cp 2 ;8px
        BEQ  ShowSpriteReconfigure_8px                      #     jr z,ShowSpriteReconfigure_8px
        CMP  R1,$4                                          #     cp 4 ;16px
        BEQ  ShowSpriteReconfigure_16px                     #     jr z,ShowSpriteReconfigure_16px
RETURN                                                      # ret
                                                            #
ShowSpriteReconfigure_128px: # Not actually used!           # ShowSpriteReconfigure_128px:     ;Not actually used!
        MOV  $184-64,R1                                     #     ld a,184-64
        MOV  $224-24,R2                                     #     ld b,224-24
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_104px:                                # ShowSpriteReconfigure_104px:     ;Not actually used!
        MOV  $184-52,R1                                     #     ld a,184-52
        MOV  $224-96,R2                                     #     ld b,224-96
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_96px:                                 # ShowSpriteReconfigure_96px:      ;Used by Boss 1
        MOV  $184-48,R1                                     #     ld a,184-48
        MOV  $224-24,R2                                     #     ld b,224-24
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_80px:                                 # ShowSpriteReconfigure_80px:      ;Not actually used!
        MOV  $184-40,R1                                     #     ld a,184-40
        MOV  $224-80,R2                                     #     ld b,224-80
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_48px:                                 # ShowSpriteReconfigure_48px:
        MOV  $184-24,R1                                     #     ld a,184-24
        MOV  $224-48,R2                                     #     ld b,224-48
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_32px:                                 # ShowSpriteReconfigure_32px:
        MOV  $184-16,R1                                     #     ld a,184-16
        MOV  $224-32,R2                                     #     ld b,224-32
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_64px:                                 # ShowSpriteReconfigure_64px:      ;not actually used
        MOV  $184-32,R1                                     #     ld a,184-32
        MOV  $224-64,R2                                     #     ld b,224-64
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_16px:                                 # ShowSpriteReconfigure_16px:
        MOV  $184- 8,R1                                     #     ld a,184-8
        MOV  $224-16,R2                                     #     ld b,224-16
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_8px:                                  # ShowSpriteReconfigure_8px:
        MOV  $184- 4,R1                                     #     ld a,184-4
        MOV  $224- 8,R2                                     #     ld b,224-8
        BR   ShowSpriteReconfigure_all                      #     jr ShowSpriteReconfigure_all
ShowSpriteReconfigure_24px:                                 # ShowSpriteReconfigure_24px:
        MOV  $184-12,R1                                     #     ld a,184-12
        MOV  $224-24,R2                                     #     ld b,224-24
                                                            #
ShowSpriteReconfigure_all:                                  # ShowSpriteReconfigure_all:
        # Right X                                           #     ;Right X
        MOV  R1,$cmpSpriteSizeConfig184less12               #     ld (SpriteSizeConfig184less12_Plus1-1),a
        MOV  R1,$srcSpriteSizeConfig184less12               #     ld (SpriteSizeConfig184less12B_Plus1-1),a
                                                            #     ld a,B
        # Bottom Y                                          #     ;Bottom Y
        MOV  R2,$cmpSpriteSizeConfig224less24               #     ld (SpriteSizeConfig224less24_Plus1-1),a
        MOV  R2,$srcSpriteSizeConfig224less24               #     ld (SpriteSizeConfig224less24B_Plus1-1),a
RETURN                                                      # ret
