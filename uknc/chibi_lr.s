    .nolist
    .include "./core_defs.s"

   # sprite 0
    .word ChibiR.0 # sprite offset
    .word ChibiR.0.Mask
    .byte 32 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte SPR_HAS_MASK # attributes
   # sprite 1
    .word ChibiR.1 # sprite offset
    .word ChibiR.1.Mask
    .byte 32 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte SPR_HAS_MASK # attributes
   # sprite 2
    .word ChibiL.0 # sprite offset
    .word ChibiL.0.Mask 
    .byte 32 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte SPR_HAS_MASK # attributes
   # sprite 3
    .word ChibiL.1 # sprite offset
    .word ChibiL.1.Mask
    .byte 32 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte SPR_HAS_MASK # attributes
   # sprite 4
    .word Drone.0 # sprite offset
    .word Drone.Mask
    .byte 16 # height of the sprite
    .byte 0  # Y offset
    .byte 4  # width
    .byte SPR_HAS_MASK # attributes
   # sprite 5
    .word Drone.1 # sprite offset
    .word Drone.Mask
    .byte 16 # height of the sprite
    .byte 0  # Y offset
    .byte 4  # width
    .byte SPR_HAS_MASK # attributes

ChibiR.0:
    .incbin "build/chibi/chibi_r.0.bin"
ChibiR.0.Mask:
    .incbin "build/chibi/chibi_r_mask.0.bin"
ChibiR.1:
    .incbin "build/chibi/chibi_r.1.bin"
ChibiR.1.Mask:
    .incbin "build/chibi/chibi_r_mask.1.bin"
ChibiL.0:
    .incbin "build/chibi/chibi_l.0.bin"
ChibiL.0.Mask:
    .incbin "build/chibi/chibi_l_mask.0.bin"
ChibiL.1:
    .incbin "build/chibi/chibi_l.1.bin"
ChibiL.1.Mask:
    .incbin "build/chibi/chibi_l_mask.1.bin"
Drone.0:
    .incbin "build/chibi/drone.0.bin"
Drone.1:
    .incbin "build/chibi/drone.1.bin"
Drone.Mask:
    .incbin "build/chibi/drone_mask.0.bin"
