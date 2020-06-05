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
                                                            # ShowSprite_ReadInfo:
        MOV  (PC)+,R0; srcSprShow_SprNum: .word 0           #     ld a,&0 :SprShow_SprNum_Plus1
                                                            #     ld c,a
                                                            #
                                                            #     ld b,0
                                                            #         or a ; only done to clear carry flag
        ASL  R0                                             #     rl b
                                                            #     rl c
                                                            #
        MOV  (PC)+,R5; srcSprShow_BankAddr: .word LevelSprites #  ld hl,&4000 :SprShow_BankAddr_Plus2
        MOV  R5,R3                                          #     ld d,h
                                                            #     ld e,l
        ADD  R0,R5                                          #     add hl,bc
        ADD  R0,R5                                          #     add hl,bc ; 6 bytes per sprite
        ADD  R0,R5                                          #     add hl,bc
                                                            #
        MOVB (R5)+,R0 # height of the sprite in lines       #     ld a,(hl)
                                                            #     or a
        BZE  SpriteGiveUp$                                  #     jr z,SpriteGiveUp
        MOVB R0,@$srcSprShow_TempH                          #     ld (SprShow_TempH),a
                                                            #
                                                            #     inc hl
        MOVB (R5)+,R1 # width in bytes                      #     ld a,(hl)
        # don't care about sign extension, 80 is a maximum value
        MOV  R1,@$srcSprShow_TempW                          #     ld (SprShow_TempW),a
        MOV  R1,@$srcSprShow_W                              #     ld (SprShow_W),a
                                                            #     ld b,a
                                                            #
                                                            #     inc hl
                                                            #     ld a,(hl)
        MOVB (R5)+,@$srcSprShow_Yoff                        #     ld (SprShow_Yoff),a
                                                            #     inc hl
        # Note Xoffset is never actually used for x-coords  #
        # the mem pos is actually sprite attribs
        # such as PSet, Doubleheight and trans color
        MOVB (R5)+,R0 # sign extension is irrelevant        #     ld a,(hl)
        MOV  R0,@$srcSprShow_Xoff                           #     ld (SprShow_Xoff),a ;
                                                            #                         ;
                                                            #     inc hl
        # leave with Sprbankaddr in R3                      #     ;leave with Sprbankaddr in DE
        # Width in R1, and Xoff in R0                       #     ;Width in B and Xoff in A
    SpriteGiveUp$:
        RETURN                                              # ret
                                                            #
                                                            # SpriteGiveUp:
                                                            #     pop af ;Forcably quit not just getting info - but showing the sprite
                                                            # ret
#----------------------------------------------------------------------------}}}

                                                            # ;ShowSpriteDirect is a cruder version of ShowSprite, it does not use the
                                                            # ;'virtual' screen res of (160x200) and cannot do clipping - it was designed for
                                                            # ;the UI objects which never moved and never needed clipping
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
#-------------------------------------------------------------------------------
ShowSprite: # ShowSprite is the main routine of our program!
        CALL @$ShowSprite_ReadInfo # Get Sprite Details

        CMP  R1,(PC)+; cmpSpriteSizeConfig6: .word 6
       .call NE, @(PC)+ # calls ShowSpriteReconfigure or null
        dstShowSpriteReconfigureCommand: .word ShowSpriteReconfigure

        ADD  (R5),R3 # calculate sprite address
        MOV  R3,@$srcSprShow_TempAddr

        # we are relying on Xoff still being in R0
        BIC  $0xFFF8,R0 # Bits 2,1,0 - transparency
        MOVB TranspColors(R0),@$srcTranspBitA

# *********  show a new sprite *********

# ShowSprite_OK:
        MOV  (PC)+,R1; srcSprShow_Yoff: .word 48                      #     ld a,48 :SprShow_Yoff_Plus1
        ADD  (PC)+,R1; srcSprShow_Y: .word 48 # set from object array #     add 48  :SprShow_Y_Plus1
                                                                      #     ld c,a
        MOV  (PC)+,R0; srcSprShow_Xoff: .word 48                      #     ld a,48 :SprShow_Xoff_Plus1
        MOV  (PC)+,R2; srcSprShow_X: .word 48 # set from object array #     ld b,48 :SprShow_X_Plus1
                                                                      #
        BIT  $0x40,R0                                                 #     bit 6,a
        BZE  ShowSprite_OK_NoDoubler$                                 #     jp z,ShowSprite_OK_NoDoubler
        # Doubler gives an interlacing effect, used for faux big sprites
        # without slowdown
        MOV  $SprDrawChooseRenderLineDoubler,R5                       #     ld hl,SprDrawChooseRenderLineDoubler
                                                                      #
        BIT  $0x80,R0                                                 #     bit 7,a
        BZE  ShowSprite_OK_Xoff$                                      #     jp z,ShowSprite_OK_Xoff
        # Double height with Pset (no transparency - much faster)
        MOV  $SprDrawChooseRenderLineDoublerPset,R5                   #     ld hl,SprDrawChooseRenderLineDoublerPset
                                                                      #
                                                                      #     jp ShowSprite_OK_Xoff
    ShowSprite_OK_NoDoubler$: # Normal sprite                         # ShowSprite_OK_NoDoubler:
        MOV  $SprDrawChooseRender,R5                                  #     ld hl,SprDrawChooseRender
        BIT  $0x80,R0                                                 #     bit 7,a
        BZE  ShowSprite_OK_Xoff$                                      #     jp z,ShowSprite_OK_Xoff
        # PSET sprite - deletes background, fast no transp
        MOV  $SprDrawChooseRenderPset,R5                              #     ld hl,SprDrawChooseRenderPset
                                                                      #
    ShowSprite_OK_Xoff$:                                              # ShowSprite_OK_Xoff:
        # Bit 7 forces "pset" - wipes background but faster
        # Bit 6 doubles height
        # Bits 2,1,0 - transparency
                                                            #     and %00000000
                                                            #     add b
                                                            #     ld b,a

        MOV  R5,@$jmpShowSprite_Ready_Return                #     ld (ShowSprite_Ready_Return_Plus2 - 2),hl
        CALL @$VirtualPosToScreenByte                       #         call VirtualPosToScreenByte
        # R2 Y lines to skip   | R4 X bytes to skip   #     #         ; H X bytes to skip; L X bytes to remove
        # R3 Y lines to remove | R5 X bytes to remove #     #         ; D Y bytes to skip; E Y bytes to remove
                                                            #         ld A,B
                                                            #         ld (SprShow_TempX),A
                                                            #         ld A,C
                                                            #         ld (SprShow_TempY),A

        MOV  R2,R0                                          #         ld a,h
        BIS  R3,R0                                          #         or l
        BIS  R4,R0                                          #         or d ; if all are zero, do nothing
        BIS  R5,R0                                          #         or e
        BZE  ShowSprite_SkipChanges                         #         jp Z,ShowSprite_SkipChanges

                                                            #         exx ;push hl
                                                            #             ld hl,SprDrawLnStartBegin
        MOV  $SprDrawLnStartBegin,@$jmpShowSprite_Ready_Return #          ld (ShowSprite_Ready_Return_Plus2 - 2),hl

                                                            #         exx ;pop hl

                                                            ##    ifdef Debug
                                                            #         call Debug_ReleaseEXX
                                                            ##    endif
                                                            #
                                                            #         ld a,h
                                                            #         ld (SprShow_OldX),a
                                                            #         push de
                                                            #             ld a,(SprShow_TempH)
                                                            #             dec a
                                                            #             cp E
                                                            #             jr NC,ShowSprite_HeiNotZero     ; check if new width is <0
                                                            #                 ;pop af ; use up the pushed val
                                                            #                 pop af
                                                            #                 ei
                                                            #                 ret
                                                            #             ShowSprite_HeiNotZero:
                                                            #             inc a
                                                            #             sub E
                                                            #             ld (SprShow_TempH),a
                                                            #
                                                            #             ld a,(SprShow_TempW)
                                                            #             ld (SprShow_W),a
                                                            #             dec a
                                                            #             cp L
                                                            #             jr NC,ShowSprite_WidthNotZero       ; check if new width is <0
                                                            #                 ;pop af ; use up the pushed val
                                                            #                 pop af
                                                            #                 ei
                                                            #                 ret
                                                            #             ShowSprite_WidthNotZero:
                                                            #             inc a
                                                            #             sub L
                                                            #             ld (SprShow_TempW),a
                                                            #     ex af,af'
                                                            #             ld hl,(SprShow_TempAddr)
                                                            #
                                                            #         pop af      ;restore width
                                                            #         ld d,0
                                                            #         ld e,a      ; store width for loop
                                                            #
                                                            #     ; we can only use the basic slow render - the others cannot clip
                                                            #     ex af,af'
                                                            #     ld b,a
                                                            #     or a
                                                            #     jr Z,ShowSprite_AddressOK
                                                            #
                                                            #     ShowSprite_AddressDown:
                                                            #         add hl,de
                                                            #     djnz ShowSprite_AddressDown
                                                            #
                                                            # ShowSprite_AddressOK:   ;Address does not need changing
                                                            #     ld b,0
                                                            #     ld c,&00 :SprShow_OldX_Plus1
                                                            #     add hl,bc ; add the width to the address
                                                            #
                                                            #     ld (SprShow_TempAddr),hl ; save the new start address
                                                            #
                                                            #
                                                            #     jp ShowSprite_Ready
                                                            #     ;we have messed with the co-ords, so can only use the basic render not supefast ones
                                                            #
ShowSprite_SkipChanges:                                     # ShowSprite_SkipChanges:
        # No co-ord tweaks were needed, all sprite is onscreen
                                                            #     ;pop af         ;restore width
                                                            #     ex af,af'
                                                            #
                                                            # ShowSprite_Ready:
        MOV  (PC)+,R5; srcSprShow_TempY: .word 0x0000       #     ld hl,&0000 :SprShow_TempY_Plus2
        ASL  R5                                             #     add hl,hl       ; table is two bytes so double hl
                                                            #
        MOV  scr_addr_table(R5),R5                          #     ld de,scr_addr_table    ; get table
                                                            #     add hl,de       ;add line num
                                                            #
                                                            #     ld a,(hl)       ; read the two bytes in
                                                            #     inc l ;inc hl
                                                            #     ld h,(hl)
                                                            #     ld l,a  ; hl now is the memory loc of the line
                                                            #
        ADD  (PC)+,R5;                                      #     ld de,&C069 :ScreenBuffer_ActiveScreenDirectC_Plus1
        srcFB_shift:
        srcSprShow_TempX: .byte 0x00                        #     add hl,de   ; hl = memory line, bc = X pos = hl is now the location on screen
                          .byte 0x40 # FB1                  #
                         #.byte 0x00 # FB0

                                                            #
                                                            # ;;;;;;;;;;;;;;;;
                                                            #
        MOV  (PC)+,R2; srcSprShow_TempH: .word 0x00         #     ld c,&00 :SprShow_TempH_Plus1
        # current sprite address
        MOV  (PC)+,R4; srcSprShow_TempAddr: .word 0x0000    #     ld iy,&0000 :SprShow_TempAddr_Plus2
                                                            #
        JMP  @(PC)+; jmpShowSprite_Ready_Return: .word SprDrawLnStartBegin #     jp SprDrawLnStartBegin :ShowSprite_Ready_Return_Plus2
                                                            #
                                                            #
# This is our most basic render, its slow, but can do any size and clipping                                                           # SprDrawLnStartBegin:            ; This is our most basic render, its slow, but can do any size and clipping
SprDrawLnStartBegin: #------------------------------------------------------{{{
        .inform_and_hang "SprDrawLnStartBegin is not implemented"#
                                                            # SprDrawLnStartBeginB:
                                                            #     ld a,(TranspBitA_Plus1-1)
                                                            #     ld (TranspBitB_Plus1-1),a
                                                            #     push hl
                                                            #     ld hl, SprDrawLnStart2
                                                            #
                                                            #     ld a,(SprShow_Xoff)
                                                            #     bit 6,a
                                                            #     jp z,SprDrawLn_NoDoubler
                                                            #
                                                            #     ld hl,SprDrawLnDoubleLine
                                                            #
                                                            # SprDrawLn_NoDoubler:
                                                            #     ld (SprDrawLnDoubleLineJump_Plus2-2),hl
                                                            #     pop hl
                                                            #
                                                            #     ei
                                                            # SprDrawLnStart2:
                                                            #     push hl
                                                            #         ld d,IYH
                                                            #         ld e,IYL
                                                            #
        MOV  (PC)+,R1; srcSprShow_TempW: .word 0x00         #         ld b,&00 :SprShow_TempW_Plus1;a
                                                            #         SprDrawPixelLoop:
                                                            #             ld a,(de)
                                                            #             cp 1 :TranspBitB_Plus1
                                                            #             jr z,SprDrawSkipPixelLoop
                                                            ##            ifdef DebugSprite
                                                            #                 or %11000000 ; test code, marks slow sprites so we can see they will be slow
                                                            ##            endif
                                                            #             ld (hl),a
                                                            #         SprDrawSkipPixelLoop:
                                                            #             inc hl
                                                            #             inc de
                                                            #         djnz SprDrawPixelLoop
                                                            #
                                                            #         ld d,0
        MOV  (PC)+,R2; srcSprShow_W: .word 0                #         ld e,0 :SprShow_W_Plus1
                                                            #         add iy,de
                                                            #     pop hl
                                                            #
                                                            #     ld a,h
                                                            #     add a,&08
                                                            #     ld h,a
                                                            #
                                                            # GetNextLineBasicSpriteCheck_Minus1:
                                                            #     bit 7,h
                                                            #     jp nz,GetNextLineBasicSpriteCheckDone
                                                            #     ld de,&c050
                                                            #     add hl,de
                                                            # GetNextLineBasicSpriteCheckDone:
                                                            #     dec c
                                                            #     ei
                                                            #     ret z
                                                            #
                                                            #     jp SprDrawLnStart2 :SprDrawLnDoubleLineJump_Plus2
                                                            # SprDrawLnDoubleLine:
                                                            #     call GetNxtLin
                                                            #
                                                            #     jr SprDrawLnStart2
                                                            #
                                                            # SprDrawLineEnd2:
#----------------------------------------------------------------------------}}}

# SprDrawChooseRender: turbo version ----------------------------------------{{{
SprDrawChooseRenderLineDoubler:
        MOV  $80-6,R1
        ASL  R2
        MOV  $SprDraw24pxVer_Double$,R3
        JMP  (R3)
SprDrawChooseRender: # Pick the render based on width
        MOV  (PC)+,R0; srcTranspBitA: .word 0 # Set A to ZERO / Transp byte
        MOV  @$srcSprShow_TempW,R1
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

    SprDraw8pxInit$: .inform_and_hang "SprDraw8pxInit is not implemented"
    SprDraw16pxInit$: .inform_and_hang "SprDraw16pxInit is not implemented"
    SprDraw24pxInit$:
        MOV  $80-6,R1
        MOV  $SprDraw24pxVer$,R3
        JMP  (R3)
    SprDraw32pxInit$: .inform_and_hang "SprDraw32pxInit is not implemented"
    SprDraw40pxInit$: .inform_and_hang "SprDraw40pxInit is not implemented"
    SprDraw48pxInit$: .inform_and_hang "SprDraw48pxInit is not implemented"
    SprDraw72pxInit$: .inform_and_hang "SprDraw72pxInit is not implemented"
    SprDraw96pxInit$: .inform_and_hang "SprDraw96pxInit is not implemented"

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
        MOV  @$srcSprShow_TempW,R1
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

