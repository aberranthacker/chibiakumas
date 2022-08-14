    .nolist
    .include "./core_defs.s"

   # sprite 0 Dummy sprite
    .word 0  # sprite offset
    .word 0  # bit-mask offset
    .byte 0  # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO  # attributes

   # sprite 1 Coin
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0  # Y offset
    .byte 4  # width
    .byte SPR_TURBO # attributes

   # sprite 2 Skull healthy
    .word Skull100A # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 3 Skull healthy
    .word Skull100B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 4
    .word LegsLeftA # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 5
    .word LegsLeftB # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 6
    .word LegsLeftC # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 7
    .word LegsRightA # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 8
    .word LegsRightB # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 9
    .word LegsRightC # sprite offset
    .word 0  # bit-mask offset
    .byte 40 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 10
    .word HandUp # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 11
    .word HandDown # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 12
    .word HandLeft # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 13
    .word HandRight # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 14
    .word Skull80A # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 15
    .word Skull100B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 16
    .word Skull60B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 17
    .word Skull40B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 18
    .word Skull20B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 19 not used
    .word Skull0B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 20
    .word Skull0B # sprite offset
    .word 0  # bit-mask offset
    .byte 64 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 21 not used
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 22 not used
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 23 not used
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 24 not used
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 25 not used
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

   # sprite 26
    .word Coin # sprite offset
    .word 0  # bit-mask offset
    .byte 51 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO # attributes

Coin:
    .incbin "build/level_02/coin.1.bin"

LegsLeftA:
    .incbin "build/level_02/legs_left_a.1.bin"
LegsLeftB:
    .incbin "build/level_02/legs_left_b.1.bin"
LegsLeftC:
    .incbin "build/level_02/legs_left_c.1.bin"

LegsRightA:
    .incbin "build/level_02/legs_right_a.1.bin"
LegsRightB:
    .incbin "build/level_02/legs_right_b.1.bin"
LegsRightC:
    .incbin "build/level_02/legs_right_c.1.bin"

HandUp:
    .incbin "build/level_02/hand_up.1.bin"
HandDown:
    .incbin "build/level_02/hand_down.1.bin"
HandLeft:
    .incbin "build/level_02/hand_left.1.bin"
HandRight:
    .incbin "build/level_02/hand_right.1.bin"

Skull100A:
    .incbin "build/level_02/skull_100_a.1.bin"
Skull100B:
    .incbin "build/level_02/skull_100_b.1.bin"

Skull80A:
    .incbin "build/level_02/skull_80_a.1.bin"
#Skull80B:
#    .incbin "build/level_02/skull_80_b.1.bin"

Skull60B:
    .incbin "build/level_02/skull_60_b.1.bin"

Skull40B:
    .incbin "build/level_02/skull_40_b.1.bin"

Skull20B:
    .incbin "build/level_02/skull_20_b.1.bin"

#Skull0A:
#    .incbin "build/level_02/skull_0_a.1.bin"
Skull0B:
    .incbin "build/level_02/skull_0_b.1.bin"

#Skull100C:
#    .incbin "build/level_02/skull_100_c.1.bin"
#Skull80C:
#    .incbin "build/level_02/skull_80_c.1.bin"
#Skull60C:
#    .incbin "build/level_02/skull_60_c.1.bin"
#Skull40C:
#    .incbin "build/level_02/skull_40_c.1.bin"
#Skull20C:
#    .incbin "build/level_02/skull_20_c.1.bin"
#Skull0C:
#    .incbin "build/level_02/skull_0_c.1.bin"
