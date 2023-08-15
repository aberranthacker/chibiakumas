    .nolist
    .include "./core_defs.s"

   # sprite 0 Dummy sprite
    .word 0  # sprite offset
    .word 0  # bit-mask offset
    .byte 0  # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO  # attributes

   # sprite 1 S01BossAbove75A
    .word S01BossAbove75A # sprite offset
    .word S01BossAbove75AMask # bit-mask offset
    .byte 67 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 2 S02BossAbove75B
    .word S02BossAbove75B # sprite offset
    .word 0 # bit-mask offset
    .byte 68 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 3 S03BossAbove75C
    .word S03BossAbove75C # sprite offset
    .word S03BossAbove75CMask # bit-mask offset
    .byte 54 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 4 S04BossBelow75A
    .word S04BossBelow75A # sprite offset
    .word S04BossBelow75AMask # bit-mask offset
    .byte 67 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 5 S05BossBelow75B
    .word S05BossBelow75B # sprite offset
    .word 0 # bit-mask offset
    .byte 69 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 6 S06BossBelow75C
    .word S06BossBelow75C # sprite offset
    .word S06BossBelow75CMask # bit-mask offset
    .byte 56 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 7 S07Coin
    .word S07Coin # sprite offset
    .word S07CoinMask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 4 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 8 S08Akanbee
    .word S08Akanbee # sprite offset
    .word S08AkanbeeMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 9 S09Lambtron
    .word S09Lambtron # sprite offset
    .word S09LambtronMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 10 S10Chu
    .word S10Chu # sprite offset
    .word S10ChuMask # bit-mask offset
    .byte 14 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 11 S11ChuText
    .word S11ChuText # sprite offset
    .word S11ChuTextMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

S01BossAbove75A:
    .incbin "build/level_04/s01_boss_above_75_a.1.bin"
S01BossAbove75AMask:
    .incbin "build/level_04/s01_boss_above_75_a_mask.1.bin"
    .even

S02BossAbove75B:
    .incbin "build/level_04/s02_boss_above_75_b.1.bin"

S03BossAbove75C:
    .incbin "build/level_04/s03_boss_above_75_c.1.bin"
S03BossAbove75CMask:
    .incbin "build/level_04/s03_boss_above_75_c_mask.1.bin"
    .even

S04BossBelow75A:
    .incbin "build/level_04/s04_boss_below_75_a.1.bin"
S04BossBelow75AMask:
    .incbin "build/level_04/s04_boss_below_75_a_mask.1.bin"
    .even

S05BossBelow75B:
    .incbin "build/level_04/s05_boss_below_75_b.1.bin"

S06BossBelow75C:
    .incbin "build/level_04/s06_boss_below_75_c.1.bin"
S06BossBelow75CMask:
    .incbin "build/level_04/s06_boss_below_75_c_mask.1.bin"
    .even

S07Coin:
    .incbin "build/level_04/s07_coin.1.bin"
S07CoinMask:
    .incbin "build/level_04/s07_coin_mask.1.bin"
    .even

S08Akanbee:
    .incbin "build/level_04/s08_akanbee.1.bin"
S08AkanbeeMask:
    .incbin "build/level_04/s08_akanbee_mask.1.bin"
    .even

S09Lambtron:
    .incbin "build/level_04/s09_lambtron.1.bin"
S09LambtronMask:
    .incbin "build/level_04/s09_lambtron_mask.1.bin"
    .even

S10Chu:
    .incbin "build/level_04/s10_chu.1.bin"
S10ChuMask:
    .incbin "build/level_04/s10_chu_mask.1.bin"
    .even

S11ChuText:
    .incbin "build/level_04/s11_chu_text.1.bin"
S11ChuTextMask:
    .incbin "build/level_04/s11_chu_text_mask.1.bin"
    .even

