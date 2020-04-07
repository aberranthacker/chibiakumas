;
;-------------------------------------------------------------------------------
;-*****************************************************************************-
;-*                          Compiled Sprive Viewer                           *-
;-*****************************************************************************-
;-------------------------------------------------------------------------------
;
; Compiled sprites are just machine code programs to render loading/continue etc
; screens we run them from here to allow the 64k override to be standardised
;
CLS:
    ; clear the screen
    ld  a,(ScreenBuffer_ActiveScreen)
CLSB:
    ld  h,a
    ld  d,a
    ld  e,&01
    ld  BC,&3FCF
    xor a
    ld  l,a
    ld  (hl),a
    ldir
ret

ShowCompiledSprite: ; show compiled sprite A
    ld l,a
    jr CLS
