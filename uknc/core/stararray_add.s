Stars_AddBurst_Top:
    .word 0x0705
    .word 0x0F0D
    .word 0x1715
    .word 0x1F1D
Stars_AddBurst_TopLeft:
    .word 0x0301
    .word 0x0B09
    .word 0x1311
    .word 0x1B19
    .word 0
Stars_AddBurst_Right:
    .word 0x2725
    .word 0x2F2D
    .word 0x3735
    .word 0x3F3D
Stars_AddBurst_TopRight:
    .word 0x0705
    .word 0x0F0D
    .word 0x1715
    .word 0x1F1D
    .word 0
Stars_AddBurst_Left:
    .word 0x0301
    .word 0x0B09
    .word 0x1311
    .word 0x1B19
Stars_AddBurst_BottomLeft:
    .word 0x2321
    .word 0x2B29
    .word 0x3331
    .word 0x3B39
    .word 0
Stars_AddBurst_Bottom:
    .word 0x2321
    .word 0x2B29
    .word 0x3331
    .word 0x3B39
Stars_AddBurst_BottomRight:
    .word 0x2725
    .word 0x2F2D
    .word 0x3735
    .word 0x3F3D
    .word 0
Stars_AddBurst_Outer:
    .word 0x3737
    .word 0x2727
    .word 0x1717
    .word 0x3131
    .word 0x2121
    .word 0x1111
OuterBurstPatternMini:
    .word 0x2F2F
    .word 0x1F1F
    .word 0x2929
    .word 0x1919
    .word 0x3F39
    .word 0x0F09
Stars_AddObjectOne:
    .word 0
Stars_AddBurst:
    .word 0x3f08
    .word 0
Stars_AddBurst_Small:
    .word 0x3632
    .word 0x2E2A
    .word 0x2622
    .word 0x1E1A
    .word 0x1612
    .word 0
Stars_AddBurst_TopWide:
    .word 0x1D1B
    .word 0x1513
    .word 0x0D0B
    .word 0
Stars_AddBurst_RightWide:
    .word 0x2726
    .word 0x2F2D
    .word 0x1F1D
    .word 0
Stars_AddBurst_LeftWide:
    .word 0x2221
    .word 0x1B19
    .word 0x2B29
    .word 0
Stars_AddBurst_BottomWide:
    .word 0x2D2B
    .word 0x3533
    .word 0x3D3B
    .word 0

Stars_AddToPlayer: # used by player_driver.s
        CLR  @$srcStarArrayFullMarker
        MOV  $PlayerStarArraySizeBytes,@$cmpStars_AddObject_StarArraySize
        MOV  $PlayerStarArrayPointer,@$srcStars_AddObject_StarArrayPointer
        CLR  @$srcStarArrayStartPoint
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
        MOV  $StarArraySizeBytes,@$cmpStars_AddObject_StarArraySize
        MOV  $StarArrayPointer,@$srcStars_AddObject_StarArrayPointer
        CLR  @$srcStarArrayStartPoint

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
        MOV  (R5)+,R0
        BZE  1237$

        INCB R0 # only run if two vals aren't the same! (whaat???)
        BZE  11387$

        CALL @$Stars_AddBurst_Start
11387$: BR   Stars_AddBursts_Loop

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

        # C  = R1 = Y pos
        # D  = R2 = X pos
        # HL = R0 = first word of burst data
        # R5 = pointer to next burst data word
Stars_AddBurst_Start:
        SWAB R0

Stars_AddBurst_Loop:
        CALL @$Stars_AddObjectFromR0

        CLR  R4
        BISB R0,R4
       .equiv srcBurstSpacing, .+2
        SUB  $2,R4 # alter to reduce fire
        BLO  1237$
        SWAB R0
        CMPB R4,R0
        BLO  1237$

        CMP  R4,$044
        BNE  1$
        DEC  R4    # don't add a static star!
    1$:
        SWAB R0
        CLRB R0
        BISB R4,R0
        BR   Stars_AddBurst_Loop
1237$:  RETURN

        # input Y    = R1
        #       X    = R2
        #       Move = R0 LSB
        # corrupts R3, R4
Stars_AddObjectFromR0:
       .equiv srcStarArrayFullMarker, .+2
        TST  $0x00
        BNZ  1237$ # if > 0 we cannot add any stars as the loop is full!

       .equiv srcStarArrayStartPoint, .+2  #
        MOV  $0x00,R3
       .equiv srcStars_AddObject_StarArrayPointer, .+2
        MOV  $0x0000,R4
        ADD  R3,R4

Stars_SeekLoop:
        TSTB (R4) # Y check
        BNZ  Stars_SeekLoopNext # if Y <> 0 then this slot is in use

        MOV  R3,@$srcStarArrayStartPoint  # found a free slot!
        MOVB R1,(R4)+ # Y
        MOVB R2,(R4)+ # X
        MOVB R0,(R4)  # Move
1237$:  RETURN

Stars_SeekLoopNext:
        ADD  $3,R4
        ADD  $3,R3
       .equiv cmpStars_AddObject_StarArraySize, .+2
        CMP  R3,$0x00

        BLO  Stars_SeekLoop
        MOV  R3,@$srcStarArrayFullMarker
        RETURN

Stars_AddObjectBatch2:
        # B = R3 = pattern (0-15)
        # C = R1 = Y pos
        # D = R2 = X pos
        SUB  $16,R3
        MOVB StarsOneByteDirs(R3),R0
        BR   Stars_AddObjectFromR0

StarsOneByteDirs:
       .byte 0x21,0x09,0x0C,0x0F,0x27,0x3F,0x3C,0x39,0x61,0x49,0x4c,0x4f,0x67,0x7f,0x7c,0x79
       #       16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31
       .even
