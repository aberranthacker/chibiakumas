# Solid fill render - fill lines with DE R0

# Note, you must inject the correct Nextline code into this function with code like:
# call Akuyou_ScreenBuffer.Init
# ld (BackgroundSolidFillNextLine_Minus1-1),hl

# call Akuyou_ScreenBuffer.Flip
# ld (BackgroundSolidFillNextLine_Minus1+1),hl

#  To add some lines to your background
#    MOV  $16,R1     # number of lines
#    MOV  $0x0000,R4 # word to fill with
#    CALL @$Background_SolidFill # expects pointer to screen memory in R5

Background_SolidFill:
        100$:
            .rept 40
             MOV  R0,(R5)+
            .endr
        SOB  R1,100$

        RETURN
