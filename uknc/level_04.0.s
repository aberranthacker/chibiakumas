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

   # sprite 12 S12Shoe
    .word S12Shoe # sprite offset
    .word S12ShoeMask # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 13 S13BossAbove75HitA
    .word S13BossAbove75HitA # sprite offset
    .word S13BossAbove75HitAMask # bit-mask offset
    .byte 69 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 14 S15BossAbove75HitB
    .word S15BossAbove75HitB # sprite offset
    .word 0 # bit-mask offset
    .byte 69 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 15 S15BossAbove75HitC
    .word S15BossAbove75HitC # sprite offset
    .word S15BossAbove75HitCMask # bit-mask offset
    .byte 56 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 16 S16BossBelow75HitA
    .word S16BossBelow75HitA # sprite offset
    .word S16BossBelow75HitAMask # bit-mask offset
    .byte 69 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 17 S18BossBelow75HitB
    .word S18BossBelow75HitB # sprite offset
    .word 0 # bit-mask offset
    .byte 69 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 18 S18BossBelow75HitC
    .word S18BossBelow75HitC # sprite offset
    .word S18BossBelow75HitCMask # bit-mask offset
    .byte 56 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 19 S19BossDeadA
    .word S19BossDeadA # sprite offset
    .word 0 # bit-mask offset
    .byte 67 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 20 S20BossDeadB
    .word S20BossDeadB # sprite offset
    .word 0 # bit-mask offset
    .byte 68 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 21 S21BossDeadC
    .word S21BossDeadC # sprite offset
    .word 0 # bit-mask offset
    .byte 70 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

S01BossAbove75A:
    .incbin "build/level_04/s01_boss_above_75_a.0.bin"
S01BossAbove75AMask:
    .incbin "build/level_04/s01_boss_above_75_a_mask.0.bin"
    .even

S02BossAbove75B:
    .incbin "build/level_04/s02_boss_above_75_b.0.bin"

S03BossAbove75C:
    .incbin "build/level_04/s03_boss_above_75_c.0.bin"
S03BossAbove75CMask:
    .incbin "build/level_04/s03_boss_above_75_c_mask.0.bin"
    .even

S04BossBelow75A:
    .incbin "build/level_04/s04_boss_below_75_a.0.bin"
S04BossBelow75AMask:
    .incbin "build/level_04/s04_boss_below_75_a_mask.0.bin"
    .even

S05BossBelow75B:
    .incbin "build/level_04/s05_boss_below_75_b.0.bin"

S06BossBelow75C:
    .incbin "build/level_04/s06_boss_below_75_c.0.bin"
S06BossBelow75CMask:
    .incbin "build/level_04/s06_boss_below_75_c_mask.0.bin"
    .even

S07Coin:
    .incbin "build/level_04/s07_coin.0.bin"
S07CoinMask:
    .incbin "build/level_04/s07_coin_mask.0.bin"
    .even

S08Akanbee:
    .incbin "build/level_04/s08_akanbee.0.bin"
S08AkanbeeMask:
    .incbin "build/level_04/s08_akanbee_mask.0.bin"
    .even

S09Lambtron:
    .incbin "build/level_04/s09_lambtron.0.bin"
S09LambtronMask:
    .incbin "build/level_04/s09_lambtron_mask.0.bin"
    .even

S10Chu:
    .incbin "build/level_04/s10_chu.0.bin"
S10ChuMask:
    .incbin "build/level_04/s10_chu_mask.0.bin"
    .even

S11ChuText:
    .incbin "build/level_04/s11_chu_text.0.bin"
S11ChuTextMask:
    .incbin "build/level_04/s11_chu_text_mask.0.bin"
    .even

S12Shoe:
    .incbin "build/level_04/s12_shoe.0.bin"
S12ShoeMask:
    .incbin "build/level_04/s12_shoe_mask.0.bin"
    .even

S13BossAbove75HitA:
    .incbin "build/level_04/s13_boss_above_75_hit_a.0.bin"
S13BossAbove75HitAMask:
    .incbin "build/level_04/s13_boss_above_75_hit_a_mask.0.bin"
    .even

S15BossAbove75HitB:
    .incbin "build/level_04/s15_boss_above_75_hit_b.0.bin"

S15BossAbove75HitC:
    .incbin "build/level_04/s15_boss_above_75_hit_c.0.bin"
S15BossAbove75HitCMask:
    .incbin "build/level_04/s15_boss_above_75_hit_c_mask.0.bin"
    .even

S16BossBelow75HitA:
    .incbin "build/level_04/s16_boss_below_75_hit_a.0.bin"
S16BossBelow75HitAMask:
    .incbin "build/level_04/s16_boss_below_75_hit_a_mask.0.bin"
    .even

S18BossBelow75HitB:
    .incbin "build/level_04/s18_boss_below_75_hit_b.0.bin"

S18BossBelow75HitC:
    .incbin "build/level_04/s18_boss_below_75_hit_c.0.bin"
S18BossBelow75HitCMask:
    .incbin "build/level_04/s18_boss_below_75_hit_c_mask.0.bin"
    .even

S19BossDeadA:
    .incbin "build/level_04/s19_boss_dead_a.0.bin"

S20BossDeadB:
    .incbin "build/level_04/s20_boss_dead_b.0.bin"

S21BossDeadC:
    .incbin "build/level_04/s21_boss_dead_c.0.bin"

