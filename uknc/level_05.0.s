    .nolist
    .include "./core_defs.s"

   # sprite 0 Dummy sprite
    .word 0  # sprite offset
    .word 0  # bit-mask offset
    .byte 0  # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_TURBO  # attributes

   # sprite 1 S01Tentitack
    .word S01Tentitack # sprite offset
    .word S01TentitackMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 2 S02Superfish
    .word S02Superfish # sprite offset
    .word S02SuperfishMask # bit-mask offset
    .byte 32 # height of the sprite
    .byte 0 # Y offset
    .byte 5 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 3 S03Lilifrog
    .word S03Lilifrog # sprite offset
    .word S03LilifrogMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 4 S04Spitfish
    .word S04Spitfish # sprite offset
    .word S04SpitfishMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 5 S05SpitfishBomber
    .word S05SpitfishBomber # sprite offset
    .word S05SpitfishBomberMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 6 S06Pairanah
    .word S06Pairanah # sprite offset
    .word S06PairanahMask # bit-mask offset
    .byte 31 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 7 S07Bubble24
    .word S07Bubble24 # sprite offset
    .word S07Bubble24Mask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 8 S08Bubble16
    .word S08Bubble16 # sprite offset
    .word S08Bubble16Mask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 4 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 9 S09Minerfish
    .word S09Minerfish # sprite offset
    .word S09MinerfishMask # bit-mask offset
    .byte 32 # height of the sprite
    .byte 0 # Y offset
    .byte 8 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 10 S10Coin
    .word S10Coin # sprite offset
    .word S10CoinMask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 4 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 11 S11FishfaceLeft
    .word S11FishfaceLeft # sprite offset
    .word S11FishfaceLeftMask # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 12 S12FishboneLeft
    .word S12FishboneLeft # sprite offset
    .word S12FishboneLeftMask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 13 S13PowerupPower
    .word S13PowerupPower # sprite offset
    .word S13PowerupPowerMask # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 14 S14PowerupRate
    .word S14PowerupRate # sprite offset
    .word S14PowerupRateMask # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 15 S15PowerupDrone
    .word S15PowerupDrone # sprite offset
    .word S15PowerupDroneMask # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 16 S16Wave1
    .word S16Wave1 # sprite offset
    .word 0 # bit-mask offset
    .byte 7 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 17 S17Wave2
    .word S17Wave2 # sprite offset
    .word 0 # bit-mask offset
    .byte 7 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 18 S18Wave3
    .word S18Wave3 # sprite offset
    .word 0 # bit-mask offset
    .byte 8 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 19 S19Weed1
    .word S19Weed1 # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 20 S20Weed2
    .word S20Weed2 # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 21 S21Coral1
    .word S21Coral1 # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 22 S22Coral2
    .word S22Coral2 # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 23 S23FishfaceRight
    .word S23FishfaceRight # sprite offset
    .word S23FishfaceRightMask # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 24 S24FishboneRight
    .word S24FishboneRight # sprite offset
    .word S24FishboneRightMask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 25 S25Tuffet
    .word S25Tuffet # sprite offset
    .word 0 # bit-mask offset
    .byte 7 # height of the sprite
    .byte 0 # Y offset
    .byte 4 # witdh
    .byte SPR_TURBO # attributes

   # sprite 26 S26Grass1
    .word S26Grass1 # sprite offset
    .word 0 # bit-mask offset
    .byte 7 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 27 S27Grass2
    .word S27Grass2 # sprite offset
    .word 0 # bit-mask offset
    .byte 8 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 28 S28Bush
    .word S28Bush # sprite offset
    .word 0 # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 29 S29Rock1
    .word S29Rock1 # sprite offset
    .word 0 # bit-mask offset
    .byte 13 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

   # sprite 30 S30Rock2
    .word S30Rock2 # sprite offset
    .word 0 # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_TURBO # attributes

S01Tentitack:
    .incbin "build/level_05/s01_tentitack.0.bin"
S01TentitackMask:
    .incbin "build/level_05/s01_tentitack_mask.0.bin"

S02Superfish:
    .incbin "build/level_05/s02_superfish.0.bin"
S02SuperfishMask:
    .incbin "build/level_05/s02_superfish_mask.0.bin"

S03Lilifrog:
    .incbin "build/level_05/s03_lilifrog.0.bin"
S03LilifrogMask:
    .incbin "build/level_05/s03_lilifrog_mask.0.bin"

S04Spitfish:
    .incbin "build/level_05/s04_spitfish.0.bin"
S04SpitfishMask:
    .incbin "build/level_05/s04_spitfish_mask.0.bin"

S05SpitfishBomber:
    .incbin "build/level_05/s05_spitfish_bomber.0.bin"
S05SpitfishBomberMask:
    .incbin "build/level_05/s05_spitfish_bomber_mask.0.bin"

S06Pairanah:
    .incbin "build/level_05/s06_pairanah.0.bin"
S06PairanahMask:
    .incbin "build/level_05/s06_pairanah_mask.0.bin"

S07Bubble24:
    .incbin "build/level_05/s07_bubble24.0.bin"
S07Bubble24Mask:
    .incbin "build/level_05/s07_bubble24_mask.0.bin"

S08Bubble16:
    .incbin "build/level_05/s08_bubble16.0.bin"
S08Bubble16Mask:
    .incbin "build/level_05/s08_bubble16_mask.0.bin"

S09Minerfish:
    .incbin "build/level_05/s09_minerfish.0.bin"
S09MinerfishMask:
    .incbin "build/level_05/s09_minerfish_mask.0.bin"

S10Coin:
    .incbin "build/level_05/s10_coin.0.bin"
S10CoinMask:
    .incbin "build/level_05/s10_coin_mask.0.bin"

S11FishfaceLeft:
    .incbin "build/level_05/s11_fishface_left.0.bin"
S11FishfaceLeftMask:
    .incbin "build/level_05/s11_fishface_left_mask.0.bin"

S12FishboneLeft:
    .incbin "build/level_05/s12_fishbone_left.0.bin"
S12FishboneLeftMask:
    .incbin "build/level_05/s12_fishbone_left_mask.0.bin"

S13PowerupPower:
    .incbin "build/level_05/s13_powerup_power.0.bin"
S13PowerupPowerMask:
    .incbin "build/level_05/s13_powerup_power_mask.0.bin"

S14PowerupRate:
    .incbin "build/level_05/s14_powerup_rate.0.bin"
S14PowerupRateMask:
    .incbin "build/level_05/s14_powerup_rate_mask.0.bin"

S15PowerupDrone:
    .incbin "build/level_05/s15_powerup_drone.0.bin"
S15PowerupDroneMask:
    .incbin "build/level_05/s15_powerup_drone_mask.0.bin"

S16Wave1:
    .incbin "build/level_05/s16_wave1.0.bin"

S17Wave2:
    .incbin "build/level_05/s17_wave2.0.bin"

S18Wave3:
    .incbin "build/level_05/s18_wave3.0.bin"

S19Weed1:
    .incbin "build/level_05/s19_weed1.0.bin"

S20Weed2:
    .incbin "build/level_05/s20_weed2.0.bin"

S21Coral1:
    .incbin "build/level_05/s21_coral1.0.bin"

S22Coral2:
    .incbin "build/level_05/s22_coral2.0.bin"

S23FishfaceRight:
    .incbin "build/level_05/s23_fishface_right.0.bin"
S23FishfaceRightMask:
    .incbin "build/level_05/s23_fishface_right_mask.0.bin"

S24FishboneRight:
    .incbin "build/level_05/s24_fishbone_right.0.bin"
S24FishboneRightMask:
    .incbin "build/level_05/s24_fishbone_right_mask.0.bin"

S25Tuffet:
    .incbin "build/level_05/s25_tuffet.0.bin"

S26Grass1:
    .incbin "build/level_05/s26_grass1.0.bin"

S27Grass2:
    .incbin "build/level_05/s27_grass2.0.bin"

S28Bush:
    .incbin "build/level_05/s28_bush.0.bin"

S29Rock1:
    .incbin "build/level_05/s29_rock1.0.bin"

S30Rock2:
    .incbin "build/level_05/s30_rock2.0.bin"

