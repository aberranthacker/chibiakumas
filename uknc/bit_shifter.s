#   This routine can 'bitshift' a 2x2 grid of pixels, it is useful for Quad and
# QuadSprite background routines, as these have no way of handling scrolling
# so code like this must scroll the data for them

BitShifter_Skip:
                                              #     ld a,l
                                              # BitShifterSkipB:
                                              #     add b
                                              #     ld l,a
                                              #     dec c
                                              #     jr nz,BitShifterSkipB
                                              #     
        RETURN                                #     ret
                                              # 
                                              # 
BitShifter:
       .inform_and_hang "no BitShifter"
       .equiv srcBitShifter_TicksOccured, .+2
        BIT  $0x00,R0                         #     and 0   :BitshifterTicksOccured_Plus1
        BZE  BitShifter_Skip                  #     jr z,BitShifterSkip
                                              # 
                                              # BitShifterAgain:
                                              #     push bc
                                              # 
                                              #     or a     ; Clear carry flag
                                              #     ld e,0  ; e remembers the overflow from the last byte X---
                                              #     push hl
                                              # BitShifterloop: ld a,(hl)   ; load memory
                                              # 
                                              # 
                                              #         ld d,a      ; backup for later
                                              #         and &77     ; keep XXX-
                                              #         rla         ; shift right -XXX
                                              #         or e        ; add e X---
                                              #         ld (hl),a   ; put it onscreen
                                              # 
                                              #         ld a,d      ; restore backup
                                              #         and &88     ; Keep leftmost ---X
                                              # 
                                              #         rra         ; Shift Left x3 = X---
                                              #         rra    
                                              #         rra    
                                              #         ld e,a      ; store in E for next byte
                                              # 
                                              #         dec l       ; screen byte
                                              # 
                                              #         djnz BitShifterloop
                                              #         pop hl
                                              #         ld a,(hl)
                                              #         or e
                                              #         ld (hl),a
                                              # 
                                              #     pop bc
                                              #     ld a,b
                                              #     add l
                                              #     ld l,a
                                              #     dec c
                                              #     jp nz,BitShifterAgain
                                              # 
                                              #     ret
