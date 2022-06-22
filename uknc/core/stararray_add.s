
# ; Starbust code - we use RST 6 as an 'add command' to save memory -
# ; RST 6 calls IY
# ; See EventStreamDefinitions for details of how the 'Directions' work

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
    .word 0x0000
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
    .word 0x0000
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
    .word 0x0000
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
    .word 0x0000
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
    .word 0x0000
Stars_AddBurst:
    .word 0x3f08
    .word 0x0000
Stars_AddBurst_Small:
    .word 0x3632
    .word 0x2E2A
    .word 0x2622
    .word 0x1E1A
    .word 0x1612
    .word 0x0000
Stars_AddBurst_TopWide:
    .word 0x1D1B
    .word 0x1513
    .word 0x0D0B
    .word 0x0000
Stars_AddBurst_RightWide:
    .word 0x2726
    .word 0x2F2D
    .word 0x1F1D
    .word 0x0000
Stars_AddBurst_LeftWide:
    .word 0x2221
    .word 0x1B19
    .word 0x2B29
    .word 0x0000
Stars_AddBurst_BottomWide:
    .word 0x2D2B
    .word 0x3533
    .word 0x3D3B
    .word 0x0000

Stars_AddToPlayer: # used by player_driver.s
        CLR  @$srcStarArrayFullMarker
        MOV  $PlayerStarArraySize,@$cmpStars_AddObject_StarArraySize
        MOV  $PlayerStarArrayPointer,@$srcStars_AddObject_StarArrayPointer
        CLR  @$srcStarArrayStartPoint
        RETURN

Stars_AddToDefault:
        MOV  $StarArraySize,@$cmpStars_AddObject_StarArraySize
        MOV  $StarArrayPointer,@$srcStars_AddObject_StarArrayPointer
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

Stars_AddObjectBatchDefault:          # Stars_AddObjectBatchDefault:
        CALL @$Stars_AddToDefault     #     call Stars_AddToDefault
                                      #
Stars_AddObjectBatch:                 # Stars_AddObjectBatch:
        RETURN
        # B = R4 = pattern (0-15)
        # C = R1 = Y pos
        # D = R2 = X pos
        MOV  R4,R0                    #     ld a,b
        CMP  R4,$16                   #     cp 16           ;radial blast!
       #BHIS Stars_AddObjectBatch2    #     jp nc,Stars_AddObjectBatch2
        ASL  R0
        MOV  Stars_VectorArray(R0),R5 #     ld hl,Stars_VectorArray
                                      #     call VectorLookup

Stars_AddBursts_Loop:                 # Stars_AddBurstsLoop:
        MOV  (R5)+,R0                 #     ld a,(hl)
                                      #     or a
        BZE  1237$                    #     ret z
        PUSH R5                       #     push hl
                                      #         inc hl
                                      #         ld h,(hl)
                                      #         ld l,a
                                      #         inc a   ;only run if two vals aren't the same!
        CALL @$Stars_AddBurst_Start   #         call nz,Stars_AddBurstStart
        POP  R5                       #     pop hl
                                      #     inc hl
                                      #     inc hl
        BR   Stars_AddBursts_Loop     # jr Stars_AddBurstsLoop
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

        # B = R4 = pattern (0-15)
        # C = R1 = Y pos
        # D = R2 = X pos
        # HL = first word of burst data
Stars_AddBurst_Start:                      # Stars_AddBurstStart:
        SWAB R2
        CLRB R2
        BISB R1,R2
        # R1, R3 are available

        PUSH R5                            #     push hl
        MOV  R5,R0                         #     ld a,h
        SWAB R0                            #     pop ix

Stars_AddBurst_Loop:                       # Stars_AddBurstLoop:
                                           #     push de
                                           #     push bc
                                           #         call Stars_AddObjectFromA
                                           #     pop bc
                                           #     pop de
                                           #

        POP  R3                            #     ld a,ixh
        SWAB R3
        CLR  R0
        BISB R3,R0
       .equiv srcBurstSpacing, .+2
        SUB  $2,R0                         #     sub 2 :BurstSpacing_Plus1 ; alter to reduce fire
        BLO  1237$                         #     ret c
        SWAB R3
        CMPB R0,R3                         #     cp ixl
        BLO  1237$                         #     ret c
                                           #
        CMP  R0,$0x24                      #     cp &24
        BNZ  Stars_AddBurstOk              #     jr nz,Stars_AddBurstOk  ; dont add a static star!
                                           #
        DEC  R0                            #     dec a
Stars_AddBurstOk:                          # Stars_AddBurstOk:
        SWAB R3
        CLRB R3
        BISB R0,R3                         #     ld ixh,a
        SWAB R3
        PUSH R3
        BR   Stars_AddBurst_Loop           #     jr Stars_AddBurstLoop
1237$:  RETURN
                                           #
Stars_AddObjectFromA:                      # Stars_AddObjectFromA:
        MOVB  R0,@$srcStarObjectMoveToAdd  #     ld (StarObjectMoveToAdd_Plus1 - 1),a
                                           #
                                           # Stars_AddObject:
        # C=R1=Y pos; D=R2=X pos
       .equiv srcStarArrayFullMarker, .+2  #     ld a,0 :StarArrayFullMarker_Plus1
        TST  $0x00                         #     or a
        BNZ  1237$                         #     ret nz ; If A>0 we cannot add any stars as the loop is full!
       .equiv srcStarArrayStartPoint, .+2  #
        MOV  $0x00,R3                      #     ld b,0      :StarArrayStartPoint_Plus1
       .equiv srcStars_AddObject_StarArrayPointer, .+2
        MOV  $0x0000,R5                    #     ld hl,&6969 :StarsAddObjectStarArrayPointer_Plus2
                                           #
                                           #     ld a,l
                                           #     add b
        ADD  R3,R5                         #     ld l,a
                                           #
Stars_SeekLoop:                            # Stars_SeekLoop:
        TSTB (R5)                          #     ld a,(hl) ; Y check
                                           #     or a
        BNZ  Stars_SeekLoopNext            #     jp NZ,Stars_SeekLoopNext ; if Y<>0 then this slot is in use
                                           #     ld a,b
        MOV  R3,@$srcStarArrayStartPoint   #     ld (StarArrayStartPoint_Plus1-1),a
                                           #
                                           #     ;found a free slot!
        MOVB R2,(R5)+ # Y=LSB, X=MSB       #     ld (hl),c ; Y
        SWAB R2                            #     inc h
        MOVB R2,(R5)+
                                           #     ld (hl),d ; X
                                           #     inc h
       .equiv  srcStarObjectMoveToAdd, .+2
        MOVB $0x00,(R5)                    #     ld (hl),&0  :StarObjectMoveToAdd_Plus1  ;**** THIS SHOULD BE THE MOVE - need to finish coding!
                                           #
1237$:  RETURN                             #     ret

Stars_SeekLoopNext:                        # Stars_SeekLoopNext:
        INC  R5                            #     inc l
        INC  R3                            #     inc b
       .equiv cmpStars_AddObject_StarArraySize, .+2
        MOV  $0x00,R0
        CMP  R0,R3                         #     ld a,0 :StarsAddObjectStarArraySize_Plus1
                                           #     cp b
        BNZ  Stars_SeekLoop                #     jr nz,Stars_SeekLoop
        CLR  @$srcStarArrayFullMarker      #     ld (StarArrayFullMarker_Plus1 - 1),a
        RETURN                             #     ret

                                           # Stars_AddObjectBatch2:
                                           #     ; A = pattern (16+)
                                           #     ; C = Y pos
                                           #     ; D = X pos
                                           #     sub 16
                                           #     ld hl,StarsOneByteDirs
                                           #
                                           #     add l
                                           #     ld l,a
                                           #
                                           #     ld a,(hl)
                                           #     jr Stars_AddObjectFromA
                                           #
                                           # ;    16   17  18 19   20  21  22 23   24, 25 ,26, 27,28 , 29,30 , 31
