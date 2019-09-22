
;-------------------------------------------------------------------------------
;-                             plus Sprites                                    -
;-------------------------------------------------------------------------------

CPCGPU_VectorArray:
    defw CPCGPU_GetVectorArray          ;0
    defw null :EnablePlusPalette_Plus2  ;1
    defw Plus_SetPlusRasters            ;2
    defw getPlusRasterPalette           ;3

CPCGPU_GetVectorArray:
    ld hl,CPCGPU_VectorArray
ret

CPCGPU_CommandNum:
    push hl
    ld hl,CPCGPU_VectorArray
jp VectorJump_PushHlFirst

getPlusRasterPalette:
    ld de,PlusRasterPalette
ret

Plus_SetPlusRasters:
    ld de,PlusRasterPalette
    ld bc,9*8
    ldir
ret
