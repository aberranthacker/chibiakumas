    .nolist
    .include "./core_defs.s"

   # sprite 0 Dummy sprite
    .word 0  # sprite offset
    .word 0  # bit-mask offset
    .byte 0  # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET  # attributes

   # sprite 1 Coin
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0  # Y offset
    .byte 4  # width
    .byte SPR_PSET # attributes

   # sprite 2 Skull healthy
    .word Skull100A # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 3 Skull healthy
    .word Skull100B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 4
    .word LegsLeftA # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 5
    .word LegsLeftB # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 6
    .word LegsLeftC # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 7
    .word LegsRightA # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 8
    .word LegsRightB # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 9
    .word LegsRightC # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 10
    .word HandUp # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 11
    .word HandDown # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 12
    .word HandLeft # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 13
    .word HandRight # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 14
    .word Skull80A # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 15
    .word Skull80B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 16
    .word Skull60B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 17
    .word Skull40B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 18
    .word Skull20B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 19
    .word Skull0A # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 20
    .word Skull0B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 21
    .word Skull100C # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 22
    .word Skull80C # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 23
    .word Skull60C # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 24
    .word Skull40C # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 25
    .word Skull20C # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 26
    .word Skull0C # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

Coin:
    .incbin "build/level_02/coin.0.bin"

LegsLeftA:
    .incbin "build/level_02/legs_left_a.0.bin"
LegsLeftB:
    .incbin "build/level_02/legs_left_b.0.bin"
LegsLeftC:
    .incbin "build/level_02/legs_left_c.0.bin"

LegsRightA:
    .incbin "build/level_02/legs_right_a.0.bin"
LegsRightB:
    .incbin "build/level_02/legs_right_b.0.bin"
LegsRightC:
    .incbin "build/level_02/legs_right_c.0.bin"

HandUp:
    .incbin "build/level_02/hand_up.0.bin"
HandDown:
    .incbin "build/level_02/hand_down.0.bin"
HandLeft:
    .incbin "build/level_02/hand_left.0.bin"
HandRight:
    .incbin "build/level_02/hand_right.0.bin"

Skull100A:
    .incbin "build/level_02/skull_100_a.0.bin"
Skull100B:
    .incbin "build/level_02/skull_100_b.0.bin"

Skull80A:
    .incbin "build/level_02/skull_80_a.0.bin"
Skull80B:
    .incbin "build/level_02/skull_80_b.0.bin"

Skull60B:
    .incbin "build/level_02/skull_60_b.0.bin"

Skull40B:
    .incbin "build/level_02/skull_40_b.0.bin"

Skull20B:
    .incbin "build/level_02/skull_20_b.0.bin"

Skull0A:
    .incbin "build/level_02/skull_0_a.0.bin"
Skull0B:
    .incbin "build/level_02/skull_0_b.0.bin"

Skull100C:
    .incbin "build/level_02/skull_100_c.0.bin"
Skull80C:
    .incbin "build/level_02/skull_80_c.0.bin"
Skull60C:
    .incbin "build/level_02/skull_60_c.0.bin"
Skull40C:
    .incbin "build/level_02/skull_40_c.0.bin"
Skull20C:
    .incbin "build/level_02/skull_20_c.0.bin"
Skull0C:
    .incbin "build/level_02/skull_0_c.0.bin"
