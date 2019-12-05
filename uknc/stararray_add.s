
# ; Starbust code - we use RST 6 as an 'add command' to save memory -
# ; RST 6 calls IY
# ; See EventStreamDefinitions for details of how the 'Directions' work

Stars_AddBurst_Top: .global Stars_AddBurst_Top
    .word 0x0705
    .word 0x0F0D
    .word 0x1715
    .word 0x1F1D
Stars_AddBurst_TopLeft:
    .word 0x0301
    .word 0x0B09
    .word 0x1311
    .word 0x1B19
    .byte 0
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
    .byte 0
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
    .byte 0
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
    .byte 0
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
    .byte 0
Stars_AddBurst:
    .word 0x3f08
    .byte 0,0
Stars_AddBurst_Small:
    .word 0x3632
    .word 0x2E2A
    .word 0x2622
    .word 0x1E1A
    .word 0x1612
    .byte 0
Stars_AddBurst_TopWide:
    .word 0x1D1B
    .word 0x1513
    .word 0x0D0B
    .byte 0
Stars_AddBurst_RightWide:
    .word 0x2726
    .word 0x2F2D
    .word 0x1F1D
    .byte 0
Stars_AddBurst_LeftWide:
    .word 0x2221
    .word 0x1B19
    .word 0x2B29
    .byte 0
Stars_AddBurst_BottomWide:
    .word 0x2D2B
    .word 0x3533
    .word 0x3D3B
    .byte 0
                                                            #
                                                            # ;   ld hl,OuterBurstPatternMini  ; OuterBurstPattern
                                                            # ;   ld iy,Stars_AddBurstStartOne ; Change RST6 call
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
                                                            #
                                                            # Stars_AddObjectBatchDefault:
                                                            #     call Stars_AddToDefault
                                                            #
                                                            # Stars_AddObjectBatch:
                                                            #     ;ld iy,Stars_AddBurstStart
                                                            #
                                                            #     ; B = pattern (0-15)
                                                            #     ; C = Y pos
                                                            #     ; D = X pos
                                                            #     ld a,b
                                                            #     cp 16           ;radial blast!
                                                            #     jp nc,Stars_AddObjectBatch2
                                                            #
                                                            #     ld hl,Stars_VectorArray
                                                            #
                                                            #     call VectorLookup
                                                            #
                                                            # Stars_AddBurstsLoop
                                                            #     ld a,(hl)
                                                            #     or a
                                                            #     ret z
                                                            #     push hl
                                                            #         inc hl
                                                            #         ld h,(hl)
                                                            #         ld l,a
                                                            #         inc a   ;only run if two vals aren't the same!
                                                            #         call nz,Stars_AddBurstStart
                                                            #     pop hl
                                                            #
                                                            #     inc hl
                                                            #     inc hl
                                                            # jr Stars_AddBurstsLoop
                                                            #
.macro VectorLookup # VectorLookup:
        ADD  R0,R3   # add twice for a two byte address
        ADD  R0,R3
        MOV  (R3),R3 # hl now is the memory loc of the line
.endm
        # Jump to address No A at HL - MUST PUSH HL Before Jumping here!
VectorJump_PushHlFirst: # ../SrcALL/Akuyou_Multiplatform_Stararray_Add.asm:156
        ADD  R0,R3   # add twice for a two byte address
        ADD  R0,R3
        # TODO: use JMP  @(R4)
        MOV  (R3),$VectorJump_Plus2-2 # hl now is the memory loc of the line
        POP  R3
        JMP  $0x0000; VectorJump_Plus2:

                                                            # Stars_VectorArray:
                                                            #     defw Stars_AddObjectOne         ;  0 = just one - obsolete
                                                            #     defw Stars_AddBurst_TopLeft     ;  1
                                                            #     defw Stars_AddBurst_BottomLeft  ;  2
                                                            #     defw Stars_AddBurst_TopRight    ;  3
                                                            #     defw Stars_AddBurst_BottomRight ;  4
                                                            #     defw Stars_AddBurst_Top         ;  5
                                                            #     defw Stars_AddBurst_Bottom      ;  6
                                                            #     defw Stars_AddBurst_Left        ;  7
                                                            #     defw Stars_AddBurst_Right       ;  8
                                                            #     defw Stars_AddBurst_TopWide     ;  9
                                                            #     defw Stars_AddBurst_BottomWide  ; 10
                                                            #     defw Stars_AddBurst_LeftWide    ; 11
                                                            #     defw Stars_AddBurst_RightWide   ; 12
                                                            #     defw Stars_AddBurst             ; 13
                                                            #     defw Stars_AddBurst_Small       ; 14
                                                            #     defw Stars_AddBurst_Outer       ; 15
                                                            #
                                                            # Stars_AddToPlayer:
                                                            #     xor a
                                                            #     ld (StarArrayFullMarker_Plus1-1),a
                                                            #     ld a,PlayerStarArraySize;(StarArraySize_Player)
                                                            #     ld hl,PlayerStarArrayPointer;(StarArrayMemloc_Player)
                                                            # jr Stars_AddToDefaultB
                                                            #
                                                            # Stars_AddToDefault:
                                                            #     ld a,StarArraySize ; (StarArraySize_Enemy)
                                                            #     ld hl,StarArrayPointer ; (StarArrayMemloc_Enemy)
                                                            #
                                                            # Stars_AddToDefaultB:
                                                            #     ld (StarsAddObjectStarArraySize_Plus1-1),a
                                                            #     ld (StarsAddObjectStarArrayPointer_Plus2-2),hl
                                                            #     xor a
                                                            #     ld (StarArrayStartPoint_Plus1-1),a
                                                            #     ret
                                                            #
                                                            # ;Stars_AddBurst
                                                            # ;   ld hl,&3f08 ; FROM - TO
                                                            # ;   jr Stars_AddBurstStart
                                                            # Stars_AddBurstStartOne:
                                                            #     ld l,h
                                                            #
                                                            # Stars_AddBurstStart:
                                                            #     push hl
                                                            #     ld a,h
                                                            #
                                                            # Stars_AddBurstStart2:
                                                            #     pop ix
                                                            #
                                                            # Stars_AddBurstLoop:
                                                            #     push de
                                                            #     push bc
                                                            #         call Stars_AddObjectFromA
                                                            #     pop bc
                                                            #     pop de
                                                            #
                                                            #     ld a,ixh
                                                            #     sub 2 :BurstSpacing_Plus1   ;alter to reduce fire
                                                            #     ret c
                                                            #     cp ixl
                                                            #     ret c
                                                            #
                                                            #     cp &24
                                                            #     jr nz,Stars_AddBurstOk  ; dont add a static star!
                                                            #
                                                            #     dec a
                                                            # Stars_AddBurstOk:
                                                            #     ld ixh,a
                                                            #     jr Stars_AddBurstLoop
                                                            #
                                                            # Stars_AddObjectFromA:
                                                            #     ld (StarObjectMoveToAdd_Plus1-1),a
                                                            #
                                                            # Stars_AddObject:
                                                            #     ; C = Y pos, D= X pos
                                                            #     ld a,0 :StarArrayFullMarker_Plus1
                                                            #     or a
                                                            #     ret nz  ; If A>0 we cannot add any stars as the loop is full!
                                                            #
                                                            #     ld b,0         :StarArrayStartPoint_Plus1
                                                            #     ld hl,&6969    :StarsAddObjectStarArrayPointer_Plus2
                                                            #
                                                            #     ld a,l
                                                            #     add b
                                                            #     ld l,a
                                                            #
                                                            # Stars_SeekLoop:
                                                            #     ld a,(hl)   ; Y check
                                                            #     or a
                                                            #     jp NZ,Stars_SeekLoopNext        ; if Y<>0 then this slot is in use
                                                            #     ld a,b
                                                            #     ld (StarArrayStartPoint_Plus1-1),a
                                                            #
                                                            #     ;found a free slot!
                                                            #     ld (hl),c   ;Y
                                                            #     inc h   ;add hl,de
                                                            #
                                                            #     ld (hl),d   ;X
                                                            #
                                                            #     inc h   ;add hl,de
                                                            #     ld (hl),&0      :StarObjectMoveToAdd_Plus1  ;**** THIS SHOULD BE THE MOVE - need to finish coding!
                                                            #
                                                            #     ret
                                                            #
                                                            # Stars_SeekLoopNext:
                                                            #     inc l;inc hl
                                                            #     inc b
                                                            #     ld a,0 :StarsAddObjectStarArraySize_Plus1
                                                            #     cp b
                                                            #     jr nz,Stars_SeekLoop
                                                            #     ld (StarArrayFullMarker_Plus1-1),a
                                                            #     ret
                                                            #
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
