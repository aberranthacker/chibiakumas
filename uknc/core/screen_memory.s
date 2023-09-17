CLS:
        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R5,-(SP)

      # clear the screen
        CLR  R0
        MOV  $200,R1
       .equiv ScreenBuffer.ActiveScreen, .+2
        MOV  $FB1,R5

        CALL Background_SolidFill

        MOV  (SP)+,R5
        MOV  (SP)+,R1
        MOV  (SP)+,R0

        RETURN

ScreenBuffer.Reset:
        MOV  $0x4000,R0
        BIS  R0,@$StarArray_ActiveScreenBit14
        BIS  R0,@$ShowSprite_ActiveScreenBit14
        MOV  $FB1,@$ScreenBuffer.ActiveScreen

        MOV  $PPU_SET_FB1_VISIBLE,@$CCH1OD
      # frame buffer switching triggers ShowBossText
      # we wait before CLS because PPU may stil be drawing the BossText
        WAIT
        CALL CLS
        RETURN

ScreenBuffer.Flip:
        MOV  $0x4000,R0
        BIT  R0,@$StarArray_ActiveScreenBit14
        BZE  ScreenBuffer.SetFB1Active

      # FB1 active, switch to FB0
        MOV  $PPU_SET_FB1_VISIBLE,@$CCH1OD

        BIC  R0,@$StarArray_ActiveScreenBit14
        BIC  R0,@$ShowSprite_ActiveScreenBit14
        MOV  $FB0,@$ScreenBuffer.ActiveScreen
        RETURN

      # FB0 active, switch to FB1
    ScreenBuffer.SetFB1Active:
        MOV  $PPU_SET_FB0_VISIBLE,@$CCH1OD

        BIS  R0,@$StarArray_ActiveScreenBit14
        BIS  R0,@$ShowSprite_ActiveScreenBit14
        MOV  $FB1,@$ScreenBuffer.ActiveScreen
        RETURN

   .ifndef DebugMode
scr_addr_table: .screen_lines_table
   .endif
