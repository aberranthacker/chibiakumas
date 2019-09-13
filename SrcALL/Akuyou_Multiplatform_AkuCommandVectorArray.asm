Aku_VectorArray:
    defw Aku_GetVectorArray  ;0
    defw null                ;1
    defw null                ;2

;   defw VDP_GetFreeYPos
Aku_GetVectorArray:
    ld hl,Aku_VectorArray
    ret

Aku_CommandNum:
    push hl         ;
    ld hl,Aku_VectorArray
jp VectorJump_PushHlFirst
