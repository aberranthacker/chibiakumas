
;Direct code variables
;ScrollPos      equ ScrollPos_Plus1-1
;ScrollPosRate1         equ ScrollPosRate1_Plus1-1
;ScrollPosRate2         equ ScrollPosRate2_Plus1-1
ScrollNextLineChange    equ ScrollNextLineChange_Plus1-1
Scroll_StackRestore     equ Scroll_StackRestore_Plus2-2
;BGGradiantPos      equ BGGradiantPos_Plus2-2
Background_LastLine equ Background_LastLine_Plus1-1

;*******************************************************************************
;*                               Background                                    *
;*******************************************************************************

Background_GradientScroll:
    ; 0-Left 1-Right 2-Up 3-Down
    ld bc,Background_ShiftNow
    or a
    jr z,Event_BackgroundScrollDirection_2
    cp 2
    jr NC,Background_Static

    ld bc,Background_LeftScroll ;0
    jr Event_BackgroundScrollDirection_2
Background_Static:
    ld bc,Background_NoShift
Event_BackgroundScrollDirection_2:
    ld (Background_ShiftJumpA_Plus2-2),bc

    ret

Background_Gradient:
    ld a,c
    ld (ScrollPosRate1_Plus1-1),a

;Background_Clear
;di
;halt
;   call Timer_UpdateTimer
;Background_Buffer2
    ;ld (Background_NextLineJump_Plus2-2),hl

;   ld a,(ScreenBuffer_ActiveScreen)
;   ld h,a
;   ld l,&50
;   LD B,200            ;Lineno - starts at bottom (200)
;   ld de,BGGradiant

    ;HL = ScreenMem ; DE = Gradient ; B = Lines ; C = ScrollPosRate1_Plus1
;Background_Gradient_Start
    ;ld a,c

    ex hl,de
    ld a,(hl)               ;Load up the first two bytes
    ld ixl,a
    inc hl
    ld a,(hl)
    ld ixh,a
    ld (Background_LastLine),a
    inc hl
    push hl
    pop iy

    ld a,(hl)
    ld (ScrollNextLineChange),a

    ex hl,de

    ld (Scroll_StackRestore),SP ; Back up the stackpointer

Background_NewLine:
    di
    ld a,128        :ScrollNextLineChange_Plus1

    cp b            ; b is lineno
    jp nz, Background_NotNextLine   ;jp is faster when true

    dec IY

    ld a,&FF    :Background_LastLine_Plus1
    ld c,a
    or a
    jp z,Background_NoShift
    ld a,(Timer_TicksOccured_Plus1-1)
    ld e,a
    ld a,%11111111  :ScrollPosRate1_Plus1       ; Scroll rate for 'ground'
    and e
    jp nz,Background_ShiftNow :Background_ShiftJumpA_Plus2

Background_NoShift:     ; No shift
    ld a,c

    ld d,iyh
    ld e,iyl

    inc de

    ld ixl,a    ; byte 1
    inc de
    ld a,(de)
    ld ixh,a    ; byte 2
    ld (Background_LastLine),a  ; last
    inc de

    ld a,(de)
    ld (ScrollNextLineChange),a ;remember when we need to do it again

    ld iyh,d
    ld iyl,e

Background_NotNextLine: ; No change yet!
    xor a
    cp b
    jr z,Background_Done  ; check if b=0

    ld sp,hl
    ld d,ixh
    ld e,d

; We use PushDE for fast screenwrite - Faster than CLS!
repeatr1:
    ei
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    di
    push de
    push de
    push de
    push de

; NO 2          - do another line
    ld a,h
    add a,&08
    ld h,a
    ld sp,hl

    ld d,ixl
    ld e,d

    dec b
    ei
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL

    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
ifndef CPC320
    di
endif
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
ifdef CPC320
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
    di
    push de;push HL
    push de;push HL
    push de;push HL
    push de;push HL
endif

    dec b

    ld a,h
    add a,&08
    ld h,a

BackgroundScreenLoopCheck_Minus1:
    bit 7,h
    jp nz,Background_NewLine
    ld de,&c050
    add hl,de
jp Background_NewLine

Background_Done:
    ld SP,&FFFF     :Scroll_StackRestore_Plus2
    ei
ret

Background_LeftScroll:          ; Alternate scroll routine for Right->Left
    ld a,c
    and &11     ; Keep leftmost X---
    rlca
    rlca
    rlca
    ld e,a
    ld a,c      ; backup for later
    and &EE     ; keep -XXX
    rrca        ; shift right -XXX
    or e        ; add e ---X
    ld (IY+0),a
jp Background_NoShift

Background_ShiftNow:
    ;Shift by one pixel
    ld a,c
    and &88     ; Keep leftmost X---
    rrca
    rrca
    rrca
    ld e,a
    ld a,c      ; backup for later
        and &77     ; keep -XXX
    rlca        ; shift right -XXX
    or e        ; add e ---X
    ld (IY+0),a
jp Background_NoShift
