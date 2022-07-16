Stars_AddBurst_Top:
    .word 0x07,0x05
    .word 0x0F,0x0D
    .word 0x17,0x15
    .word 0x1F,0x1D
Stars_AddBurst_TopLeft:
    .word 0x03,0x01
    .word 0x0B,0x09
    .word 0x13,0x11
    .word 0x1B,0x19
    .word 0
Stars_AddBurst_Right:
    .word 0x27,0x25
    .word 0x2F,0x2D
    .word 0x37,0x35
    .word 0x3F,0x3D
Stars_AddBurst_TopRight:
    .word 0x07,0x05
    .word 0x0F,0x0D
    .word 0x17,0x15
    .word 0x1F,0x1D
    .word 0
Stars_AddBurst_Left:
    .word 0x03,0x01
    .word 0x0B,0x09
    .word 0x13,0x11
    .word 0x1B,0x19
Stars_AddBurst_BottomLeft:
    .word 0x23,0x21
    .word 0x2B,0x29
    .word 0x33,0x31
    .word 0x3B,0x39
    .word 0
Stars_AddBurst_Bottom:
    .word 0x23,0x21
    .word 0x2B,0x29
    .word 0x33,0x31
    .word 0x3B,0x39
Stars_AddBurst_BottomRight:
    .word 0x27,0x25
    .word 0x2F,0x2D
    .word 0x37,0x35
    .word 0x3F,0x3D
    .word 0
Stars_AddBurst_Outer:
    .word 0x37,0x37
    .word 0x27,0x27
    .word 0x17,0x17
    .word 0x31,0x31
    .word 0x21,0x21
    .word 0x11,0x11
OuterBurstPatternMini:
    .word 0x2F,0x2F
    .word 0x1F,0x1F
    .word 0x29,0x29
    .word 0x19,0x19
    .word 0x3F,0x39
    .word 0x0F,0x09
Stars_AddObjectOne:
    .word 0
Stars_AddBurst:
    .word 0x3F,0x08
    .word 0
Stars_AddBurst_Small:
    .word 0x36,0x32
    .word 0x2E,0x2A
    .word 0x26,0x22
    .word 0x1E,0x1A
    .word 0x16,0x12
    .word 0
Stars_AddBurst_TopWide:
    .word 0x1D,0x1B
    .word 0x15,0x13
    .word 0x0D,0x0B
    .word 0
Stars_AddBurst_RightWide:
    .word 0x27,0x26
    .word 0x2F,0x2D
    .word 0x1F,0x1D
    .word 0
Stars_AddBurst_LeftWide:
    .word 0x22,0x21
    .word 0x1B,0x19
    .word 0x2B,0x29
    .word 0
Stars_AddBurst_BottomWide:
    .word 0x2D,0x2B
    .word 0x35,0x33
    .word 0x3D,0x3B
    .word 0
# patterns above take 270 bytes of RAM

Stars_AddToPlayer: # used by player_driver.s
        CLR  @$StarArrayFullMarker
        MOV  $PlayerStarArraySizeBytes,@$Stars_AddObject_StarArraySize
        MOV  $PlayerStarArrayPointer,@$Stars_AddObject_StarArrayPointer
        CLR  @$StarArrayStartPoint
        RETURN

# OuterBurstPatternLoop:
#     ld a,(hl)
#     or a
#     ret z
#     push hl
#         ld h,a
#         rst 6
#     pop hl
#     inc hl
#     jr OuterBurstPatternLoop

Stars_AddObjectBatchDefault:
        MOV  $StarArraySizeBytes,@$Stars_AddObject_StarArraySize
        MOV  $StarArrayPointer,@$Stars_AddObject_StarArrayPointer
        CLR  @$StarArrayStartPoint

      # input  B = R3 = pattern (0-15)
      #        C = R1 = Y pos
      #        D = R2 = X pos
      # corrupts R0, R3, R4, R5
Stars_AddObjectBatch:
        CMP  R3,$16 # radial blast!
        BHIS Stars_AddObjectBatch2

        ASL  R3
        MOV  Stars_VectorArray(R3),R5

Stars_AddBursts_Loop:
        MOV  (R5)+,R3
        BZE  1237$

        MOV  (R5)+,R0
        BZE  Stars_AddBursts_Loop

        CALL Stars_AddBurst_Loop
        BR   Stars_AddBursts_Loop

1237$:  RETURN

Stars_VectorArray:
       .word Stars_AddObjectOne         #  0 = just one - obsolete
       .word Stars_AddBurst_TopLeft     #  1
       .word Stars_AddBurst_BottomLeft  #  2
       .word Stars_AddBurst_TopRight    #  3
       .word Stars_AddBurst_BottomRight #  4
       .word Stars_AddBurst_Top         #  5
       .word Stars_AddBurst_Bottom      #  6
       .word Stars_AddBurst_Left        #  7
       .word Stars_AddBurst_Right       #  8
       .word Stars_AddBurst_TopWide     #  9
       .word Stars_AddBurst_BottomWide  # 10
       .word Stars_AddBurst_LeftWide    # 11
       .word Stars_AddBurst_RightWide   # 12
       .word Stars_AddBurst             # 13
       .word Stars_AddBurst_Small       # 14
       .word Stars_AddBurst_Outer       # 15

      # C = R1 = Y pos
      # D = R2 = X pos
      # H = R3 starting move
      # L = R0 ending move
      # R5 = pointer to next burst data word
Stars_AddBurst_Loop:
        CALL @$Stars_AddObjectFromR3

        DEC  R3
       .equiv IncreaseBurstSpacing, .+2
        MOV  R3,R3 # or DEC R3 to reduce fire, sets from bootstrap
        BLE  1237$ # return if 0 or negative

        CMP  R3,R0
        BLO  1237$

        CMP  R3,$044
        BNE  Stars_AddBurst_Loop

        DEC  R3 # don't add a static star!
        BR   Stars_AddBurst_Loop
1237$:  RETURN

      # input C = R1 = Y
      #       D = R2 = X
      # output:   R3 = move
      # corrupts  R4
Stars_AddObjectFromR3:
        MOV  R3,@$StarObjectMoveToAdd
Stars_AddObject:
       .equiv StarArrayFullMarker, .+2
        TST  $0x00
        BNZ  1237$ # if > 0 we cannot add any stars as the loop is full!

       .equiv StarArrayStartPoint, .+2  #
        MOV  $0x00,R3
       .equiv Stars_AddObject_StarArrayPointer, .+2
        MOV  $0x0000,R4
        ADD  R3,R4

Stars_SeekLoop:
        TSTB (R4) # Y check
        BNZ  Stars_SeekLoopNext # if Y <> 0 then this slot is in use

        MOV  R3,@$StarArrayStartPoint  # found a free slot!
        MOVB R1,(R4)+ # Y
        MOVB R2,(R4)+ # X
       .equiv StarObjectMoveToAdd, .+2
        MOV  $0x00,R3
        MOVB R3,(R4)  # Move, can be set from player_driver
1237$:  RETURN

Stars_SeekLoopNext:
        ADD  $3,R4
        ADD  $3,R3
       .equiv Stars_AddObject_StarArraySize, .+2
        CMP  R3,$0x00

        BLO  Stars_SeekLoop
        MOV  R3,@$StarArrayFullMarker
        RETURN

Stars_AddObjectBatch2:
        # B = R3 = pattern (0-15)
        # C = R1 = Y pos
        # D = R2 = X pos
        SUB  $16,R3
        MOVB StarsOneByteDirs(R3),R3
        BR   Stars_AddObjectFromR3

StarsOneByteDirs:
       .byte 0x21,0x09,0x0C,0x0F,0x27,0x3F,0x3C,0x39,0x61,0x49,0x4c,0x4f,0x67,0x7f,0x7c,0x79
       #       16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31
       .even
