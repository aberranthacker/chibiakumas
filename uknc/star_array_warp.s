StarArrayWarp.Randomize:
        CALL TRandW                      #     ld a,r
        BIT  $0b01110000,R0              #     and %01110000
        BNZ  1237$                       #     ret nz
                                         #     ld a,r
        BIC  $0xFFF3,R0                  #     and %00001100
        ASR  R0                          #     rrca
        ASR  R0                          #     rrca
        MOV  R0,@$StarArrayWarp.WarpMode #     ld (warpmode_plus1-1),a
1237$:  RETURN                           #     ret

      # replaces Star Array moves according to a table
StarArrayWarp:
        CALL StarArrayWarp.Randomize     #     call StarArrayWarpRandomize
        MOV  @$StarArrayWarp.WarpMode,R0 #     ld a,1 :warpmode_plus1
        INC  R0                          #     inc a
        BIC  $0xFFFC,R0                  #     and %00000011
        MOV  R0,@$StarArrayWarp.WarpMode #     ld (warpmode_plus1-1),a
        BIT  $1,R0                       #     and %00000001
        BZE  StarArrayWarp.Right         #     jr z,StarArrayWarp2
        BR   StarArrayWarp.Left          #     jp StarArrayWarp3
                                         #     ret
StarArrayWarp.Right:
        MOV  $WarpRight,R4               #     ld de,WarpRight
        BR   StarArrayWarp.Start         #     jr StarArrayWarpStart
                                         #
StarArrayWarp.Left:
        MOV  $WarpLeft,R4                #     ld de,Warpleft
        BR   StarArrayWarp.Start         #     jr StarArrayWarpStart
                                         #
StarArrayWarp.Start:
        MOV  $StarArrayPointer+2,R5      #     ld hl,StarArrayPointer
                                         #     inc h
                                         #     inc h
        MOV  $StarArraySize>>1,R1        #     ld a,StarArraySize
                                         #     srl a
                                         #     ld b,a
                                         #
                                         #     ld a,(warpmode_plus1-1)
       .equiv StarArrayWarp.WarpMode, .+4
        BIT  $0x02,$0                    #     and %00000010
        BZE  StarArrayWarp.Begin         #     jr z,StarArrayWarpBegin
                                         #     ld a,l
        ADD  $StarArraySizeBytes>>1,R5   #     add &80
                                         #     ld l,a
StarArrayWarp.Begin:
        MOV  $0xFFC0,R2
        MOV  $3,R3
StarArrayWarp.Repeat:
        MOVB (R5),R0                     #     ld a,(hl)
        BIC  R2,R0                       #     and %00111111
        ADD  R4,R0                       #     ld e,a
                                         #     ld a,(de)
        MOVB (R0),(R5)                   #     ld (hl),a
        ADD  R3,R5                       #     inc l
        SOB  R1,StarArrayWarp.Repeat     # djnz StarArrayWarpRepeat
        RETURN                           # ret
                                         #
WarpLeft:
   .byte 0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x07
   .byte 0x00,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,0x17
   .byte 0x08,0x09,0x13,0x14,0x15,0x16,0x1E,0x1F
   .byte 0x10,0x11,0x12,0x1C,0x1D,0x25,0x26,0x27
   .byte 0x18,0x19,0x1A,0x1B,0x24,0x2D,0x2E,0x3F
   .byte 0x20,0x21,0x22,0x23,0x2B,0x2C,0x36,0x37
   .byte 0x28,0x29,0x2A,0x32,0x33,0x34,0x35,0x3F
   .byte 0x30,0x31,0x39,0x3A,0x3B,0x3C,0x3D,0x3E

WarpRight:
   .byte 0x08,0x00,0x01,0x02,0x03,0x04,0x05,0x06
   .byte 0x10,0x11,0x09,0x0A,0x0B,0x0C,0x0D,0x0E
   .byte 0x18,0x19,0x1A,0x12,0x13,0x14,0x15,0x0F
   .byte 0x20,0x21,0x22,0x23,0x1B,0x1C,0x16,0x17
   .byte 0x28,0x29,0x2A,0x2B,0x24,0x1D,0x1E,0x1F
   .byte 0x30,0x31,0x32,0x2C,0x2D,0x25,0x26,0x27
   .byte 0x38,0x39,0x33,0x34,0x35,0x36,0x2E,0x2F
   .byte 0x38,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,0x37
