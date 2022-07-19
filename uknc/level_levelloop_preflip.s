       .equiv Background_Call, .+2
        CALL @$Background_Draw

        CALL @$EventStream_Process

        MOV  $LevelSprites,@$SprShow_BankAddr
        CALL @$ObjectArray_Redraw

        MOV  $ChibiSprites,@$SprShow_BankAddr
        CALL @$PlayerHandler
        MOV  $ChibiSprites,@$SprShow_BankAddr
        CALL @$Player_StarArray_Redraw

        CALL @$StarArray_Redraw

       #CALL @$Player_DrawUI

       #CALL @$PlaySfx

       #CALL @$ScreenBuffer_Flip

       .equiv FadeCommandCall, .+2
        CALL @$null
