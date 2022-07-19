# Feed in Spritenum as A R0
# put sprite bank pos in DE R4
# sprite pos is returned in DE R4
GetSpriteMempos:
        ASL  R0
        ASL  R0
        ASL  R0
        ADD  R4,R0
        ADD  (R0),R4

        RETURN
