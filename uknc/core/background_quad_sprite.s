# Quad Sprite render - This is MUCH faster than a tilestrip, but all the tiles
# must be identical!

# To add some lines to your background
#   ld b,16
#   ld de,Tile_Start
#   call BackgroundFloodFillQuadSprite

# where B is the number of lines, DE is the start of a 32px (8 byte) wide
# sprite and HL is the right hand side of the area to fill

# R1 number of lines
# R4 tile pointer
# R5 screen memory pointer
Background_FloodFillQuadSpriteColumn:
        MOV  R1,@$Background_FloodFillQuadSprite_LinesCount
        MOV  R2,@$Background_FloodFillQuadSpriteColumn_LinesCount
        MOV  $0000404,@$Background_FloodFillQuadSprite_SolidFillBR
        BR   Background_FloodFillQuadSprite_Loop

Background_FloodFillQuadSprite:
        MOV  R1,@$Background_FloodFillQuadSprite_LinesCount
        MOV  $0010000,@$Background_FloodFillQuadSprite_SolidFillBR

        Background_FloodFillQuadSprite_Loop:
            MOV  (R4)+,R0
            MOV  (R4)+,R1
            MOV  (R4)+,R2
            MOV  (R4)+,R3

           .rept 10
            MOV  R0,(R5)+
            MOV  R1,(R5)+
            MOV  R2,(R5)+
            MOV  R3,(R5)+
           .endr

Background_FloodFillQuadSprite_SolidFillBR:
            BR   Background_FloodFillQuadSprite_SolidFill # or MOV R0,R0

Background_FloodFillQuadSprite_NextLine:
       .equiv Background_FloodFillQuadSprite_LinesCount, .+2
        DEC  $0x00
        BNZ  Background_FloodFillQuadSprite_Loop

        RETURN

Background_FloodFillQuadSprite_SolidFill:
            CLR  R0
           .equiv Background_FloodFillQuadSpriteColumn_LinesCount, .+2
            MOV  $1,R1
            CALL @$Background_SolidFill
            BR   Background_FloodFillQuadSprite_NextLine
