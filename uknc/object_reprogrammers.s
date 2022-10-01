                                       # 
                                       # SetObjectcheck:
                                       #     ld i,a
                                       #     ld a,h
                                       #     cp &69
                                       #     ret nz      ;stay if not on screen yet
                                       #     pop af      ;steal a return!
                                       #     ret
                                       # 
                                       # SetObjectProgram:
                                       #     call SetObjectcheck
                                       #     push hl
                                       #     set 6,l ; inc h ; add hl,de ; spr
                                       #     jr SetObjectH2
                                       # 
                                       # ;ret
                                       # ; YYYYYXXXXMMMMSSS LLLLPPPRRRAAAA
                                       # 
                                       # SetObjectLife:;
                                       #     call SetObjectcheck
                                       #     push hl
                                       #     set 6,l;inc h;  add hl,de   ;spr
                                       #     jr SetObjectH3
                                       # 
SetObjectY:                            # SetObjectY:;
        TST  (R5)                      #     call SetObjectcheck
        BZE  1237$                     #     push hl
        MOVB R0,@(R5)                  #     jr SetObjectH0
1237$:  RETURN                         # 
                                       # SetObjectMove:;
                                       #     call SetObjectcheck
                                       #     push hl
                                       #     jr SetObjectH2
                                       # 
                                       # SetObjectAnimator:;
                                       #     call SetObjectcheck
                                       #     push hl
                                       #     set 6,l
                                       #     jr SetObjectH0
                                       # 
SetObjectSprite:
        TST  (R5)                      #     call SetObjectcheck
        BZE  1237$                     #     push hl
        MOVB R0,@3(R5)
1237$:  RETURN
                                       # SetObjectH3:
                                       #     inc h;  add hl,de
                                       # SetObjectH2:
                                       #     inc h;  add hl,de
                                       # SetObjectH1:
                                       #     inc h;  add hl,de
                                       # SetObjectH0:
                                       # SetObjectFound:
                                       #     ld a,i
                                       #     ld (hl),a
                                       #     pop hl
                                       # ret
