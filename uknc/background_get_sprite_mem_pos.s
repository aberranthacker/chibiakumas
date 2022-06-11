# Feed in Spritenum as A R0
# put sprite bank pos in DE R4
# sprite pos is returned in DE R4
GetSpriteMempos:
        ASL  R0
        MOV  R4,R3
        ADD  R0,R3
        ADD  R0,R3
        ADD  R0,R3
        ADD  4(R3),R4

        RETURN
