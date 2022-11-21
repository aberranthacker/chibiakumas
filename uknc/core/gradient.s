/*
*******************************************************************************
*                               Background                                    *
*******************************************************************************
*/

Background_GradientScroll:
      # | 0-Left | 1-Right | 2-Up | 3-Down |
        MOV  $Background_ShiftNow,R1
        TST  R0
        BZE  Background_SetShiftDirJump

        CMP  R0,$2
        BHIS Background_Static

        MOV  $Background_LeftScroll,R1
        BR   Background_SetShiftDirJump

Background_Static:
        MOV  $Background_NoShift,R1
Background_SetShiftDirJump:
        MOV  R1,@$jmpBackground_ShiftJumpA

        RETURN

Background_Gradient:
      # R5 HL = ScreenMem pointer # ActiveScreen
      # R3 DE = Gradient pointer  # GradientTop
      # R1 B  = Lines             # GradientTopStart
      # R2 C  = ScrollPosRate1    # Shift on Timer Ticks
        MOV  R2,@$ScrollPosRate1
        MOV  (R3)+,R4
        MOV  (R3)+,R2
        MOV  (R3)+,@$SrollNextLineChange

Background_NewLine:
       .equiv SrollNextLineChange, .+2
        CMP  R1,$0x80 # R1 is line number
        BNE  Background_NotNextLine

        TST  R2
        BZE  Background_NoShift

      # Scroll rate for 'ground'
       .equiv ScrollPosRate1, .+2
        BIT  $0xFF,@$Timer.TicksOccured
        BZE  Background_NoShift

       .equiv jmpBackground_ShiftJumpA, .+2
        JMP  @$Background_ShiftNow

Background_NoShift: # No shift
        MOV  R2,R4
        MOV  (R3)+,R2
        MOV  (R3)+,@$SrollNextLineChange # remember when we need to do it again

Background_NotNextLine: # No change yet!
        TST  R1
        BZE  1237$

       .rept 40
        MOV  R4,(R5)+
       .endr
        DEC  R1 # lines to draw counter

       .rept 40
        MOV  R2,(R5)+
       .endr
        DEC  R1 # lines to draw counter

        JMP  @$Background_NewLine

Background_LeftScroll: # Alternate scroll routine for Right->Left
      # Shift left by one pixel
        MOV  R2,R0
        BIC  $0x7777,R0 #        keep X---
        ROR  R0
        ROR  R0
        ROR  R0         # shift right ---X
        MOV  R2,R4
        BIC  $0x8888,R4 #        keep -XXX
        ROL  R4         #  shift left XXX-
        BIS  R0,R4      #         add ---X
        MOV  R4,-4(R3)
        JMP  @$Background_NoShift

Background_ShiftNow:
      # Shift right by one pixel
        MOV  R2,R0
        BIC  $0xEEEE,R0 #        keep ---X
        ROL  R0
        ROL  R0
        ROL  R0         #  shift left X---
        MOV  R2,R4
        BIC  $0x1111,R4 #        keep XXX-
        ROR  R4         # shift right -XXX
        BIS  R0,R4      #         add X---
        MOV  R4,-4(R3)
        JMP  @$Background_NoShift

1237$:  RETURN
