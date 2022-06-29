# .equiv ScrollNextLineChange, ScrollNextLineChange_Plus1 - 1
# .equiv Scroll_StackRestore,  Scroll_StackRestore_Plus2 - 2
# .equiv Background_LastLine,  Background_LastLine_Plus1 - 1
/*
*******************************************************************************
*                               Background                                    *
*******************************************************************************
*/

Background_GradientScroll:
        # | 0-Left | 1-Right | 2-Up | 3-Down |
        MOV  $Background_ShiftNow,R1            #     ld bc,Background_ShiftNow
        TST  R0                                 #     or a
        BZE  Background_SetShiftDirJump         #     jr z,Event_BackgroundScrollDirection_2
        CMP  R0,$2                              #     cp 2
        BHIS Background_Static                  #     jr NC,Background_Static
                                                #
        MOV  $Background_LeftScroll,R1          #     ld bc,Background_LeftScroll ;0
        BR   Background_SetShiftDirJump         #     jr Event_BackgroundScrollDirection_2

Background_Static:
        MOV  $Background_NoShift,R1             #     ld bc,Background_NoShift
Background_SetShiftDirJump:
        MOV  R1,@$jmpBackground_ShiftJumpA      #     ld (Background_ShiftJumpA_Plus2 - 2),bc
                                                #
        RETURN                                  #     ret
                                                #
Background_Gradient:
        # R5 HL = ScreenMem pointer # ActiveScreen
        # R3 DE = Gradient pointer  # GradientTop
        # R1 B  = Lines             # GradientTopStart
        # R2 C  = ScrollPosRate1 # Shift on Timer Ticks
                                                #     ld a,c
        MOV  R2,@$ScrollPosRate1             #     ld (ScrollPosRate1_Plus1 - 1),a
                                                #     ex hl,de
                                                #     ld a,(hl) ; Load up the first two bytes
                                                #     ld ixl,a
                                                #     inc hl
        MOV  (R3)+,R4                           #     ld a,(hl)
        MOV  (R3)+,R2                           #     ld ixh,a
       #MOV  R2,@$Background_LastLinePattern #     ld (Background_LastLine),a
                                                #     inc hl
                                                #     push hl
                                                #     pop iy
                                                #
                                                #     ld a,(hl)
        MOV  (R3)+,@$SrollNextLineChange     #     ld (ScrollNextLineChange),a
                                                #
                                                #     ex hl,de
                                                #
                                                #     ld (Scroll_StackRestore),SP ; Back up the stackpointer

Background_NewLine:                             #     di
                                                #     ld a,128        :ScrollNextLineChange_Plus1
       .equiv SrollNextLineChange, .+2       #
        CMP  R1,$0x80                           #     cp b            ; b is lineno
        BNE  Background_NotNextLine             #     jp nz, Background_NotNextLine   ;jp is faster when true
                                                #
                                                #     dec IY
                                                #
      #.equiv Background_LastLinePattern, .+2#     ld a,&FF    :Background_LastLine_Plus1
       #MOV  $0xFFFF,R2                         #     ld c,a
        TST  R2                                 #     or a
        BZE  Background_NoShift                 #     jp z,Background_NoShift
                                                #     ld a,(Timer_TicksOccured_Plus1-1)
        # Scroll rate for 'ground'              #     ld e,a
       .equiv ScrollPosRate1, .+2            #     ld a,%11111111  :ScrollPosRate1_Plus1
        BIT  $0xFF,@$Timer_TicksOccured      #     and e
        BZE  Background_NoShift                 #     jp nz,Background_ShiftNow :Background_ShiftJumpA_Plus2 #

       .equiv jmpBackground_ShiftJumpA, .+2     #
        JMP  @$Background_ShiftNow

Background_NoShift: # No shift
                                                # ld a,c
                                                #
                                                # ld d,iyh
                                                # ld e,iyl
                                                #
                                                # inc de
                                                #
        MOV  R2,R4                              # ld ixl,a    ; byte 1
                                                # inc de
                                                # ld a,(de)
        MOV  (R3)+,R2                           # ld ixh,a    ; byte 2
       #MOV  R2,@$Background_LastLinePattern # ld (Background_LastLine),a  ; last
                                                # inc de
                                                #
                                                # ld a,(de)
        MOV  (R3)+,@$SrollNextLineChange     # ld (ScrollNextLineChange),a ;remember when we need to do it again
                                                #
                                                # ld iyh,d
                                                # ld iyl,e
                                                #
Background_NotNextLine: # No change yet!
                                       #     xor a
        TST  R1                        #     cp b
        BNZ  repeatr$                  #     jr z,Background_Done  ; check if b=0
        RETURN                         #
                                       #     ld sp,hl
                                       #     ld d,ixh
                                       #     ld e,d
                                       #
# We use PushDE for fast screenwrite - Faster than CLS!
    repeatr$:
       .rept 40
        MOV  R4,(R5)+                  #     push de
       .endr                           # ; NO 2          - do another line
        DEC  R1 # lines to draw counter#     ld a,h
                                       #     add a,&08
                                       #     ld h,a
                                       #     ld sp,hl
                                       #
                                       #     ld d,ixl
                                       #     ld e,d
                                       #
                                       #     dec b
       .rept 40
        MOV  R2,(R5)+                  #     push de
       .endr
        DEC  R1 # lines to draw counter#     dec b
                                       #
                                       #     ld a,h
                                       #     add a,&08
                                       #     ld h,a
                                       #
                                       # BackgroundScreenLoopCheck_Minus1:
                                       #     bit 7,h
        JMP  @$Background_NewLine      #     jp nz,Background_NewLine

                                       #     ld de,&c050
                                       #     add hl,de
                                       #     jp Background_NewLine
                                       #
                                       # Background_Done:
                                       #     ld SP,&FFFF     :Scroll_StackRestore_Plus2
                                       #     ei
                                       # ret
                                       #
Background_LeftScroll: # Alternate scroll routine for Right->Left
        # Shift left by one pixel
        MOV  R2,R0                            # ld a,c
        BIC  $0x7777,R0 # 0111 0111 0111 0111 # and &11     ; Keep leftmost X---
        ROL  R0                               # rlca
        ROL  R0                               # rlca
        ROL  R0                               # rlca
                                              # ld e,a
        MOV  R2,R4                            # ld a,c      ; backup for later
        BIC  $0x8888,R4 # 1000 1000 1000 1000 # and &EE     ; keep -XXX
        ROR  R4                               # rrca        ; shift right -XXX
        BIS  R0,R4                            # or e        ; add e ---X
        MOV  R4,-4(R3)                        # ld (IY+0),a
        JMP  @$Background_NoShift             # jp Background_NoShift

Background_ShiftNow:
        # Shift right by one pixel
        MOV  R2,R0                            # ld a,c
        BIC  $0xEEEE,R0 # 1110 1110 1110 1110 # and &88     ; Keep leftmost X---
        ROL  R0                               # rrca
        ROL  R0                               # rrca
        ROL  R0                               # rrca
                                              # ld e,a
        MOV  R2,R4                            # ld a,c      ; backup for later
        BIC  $0x1111,R4 # 0001 0001 0001 0001 # and &77     ; keep -XXX
        ROR  R4                               # rlca        ; shift right -XXX
        BIS  R0,R4                            # or e        ; add e ---X
        MOV  R4,-4(R3)                        # ld (IY+0),a
        JMP  @$Background_NoShift             # jp Background_NoShift

