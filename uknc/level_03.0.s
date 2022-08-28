    .nolist
    .include "./core_defs.s"

   # sprite 0 Dummy sprite
    .word 0  # sprite offset
    .word 0  # bit-mask offset
    .byte 0  # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET  # attributes

   # sprite 1 Biterfly
    .word Biterfly # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 2 Coin
    .word Coin # sprite offset
    .word 0 # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 4 # witdh
    .byte SPR_PSET # attributes

   # sprite 3 GnatPack
    .word GnatPack # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 4 GrassTuftA
    .word GrassTuftA # sprite offset
    .word 0 # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 5 GrassTuftB
    .word GrassTuftB # sprite offset
    .word 0 # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 6 GrassTuftBig
    .word GrassTuftBig # sprite offset
    .word 0 # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 7 GrassTuftC
    .word GrassTuftC # sprite offset
    .word 0 # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 8 GrassTuftD
    .word GrassTuftD # sprite offset
    .word 0 # bit-mask offset
    .byte 5 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 9 Kamisagi
    .word Kamisagi # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 10 MukadeBachi1
    .word MukadeBachi1 # sprite offset
    .word 0 # bit-mask offset
    .byte 14 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 11 MukadeBachi2
    .word MukadeBachi2 # sprite offset
    .word 0 # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 12 MukadeBachi3
    .word MukadeBachi3 # sprite offset
    .word 0 # bit-mask offset
    .byte 12 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 13 MukadeBachi5
    .word MukadeBachi5 # sprite offset
    .word 0 # bit-mask offset
    .byte 13 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 14 PowerupDrone
    .word PowerupDrone # sprite offset
    .word PowerupDroneMask # bit-mask offset
    .byte 21 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 15 PowerupPower
    .word PowerupPower # sprite offset
    .word 0 # bit-mask offset
    .byte 21 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 16 PowerupRate
    .word PowerupRate # sprite offset
    .word 0 # bit-mask offset
    .byte 21 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 17 ShroomBomber
    .word ShroomBomber # sprite offset
    .word 0 # bit-mask offset
    .byte 30 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_PSET # attributes

   # sprite 18 ZombieCapybara
    .word ZombieCapybara # sprite offset
    .word 0 # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0 # Y offset
    .byte 8 # witdh
    .byte SPR_PSET # attributes

   # sprite 19 ZombieSalaryman
    .word ZombieSalaryman # sprite offset
    .word ZombieSalarymanMask # bit-mask offset
    .byte 37 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

Biterfly:
    .incbin "build/level_03/biterfly.0.bin"

Coin:
    .incbin "build/level_03/coin.0.bin"

GnatPack:
    .incbin "build/level_03/gnat_pack.0.bin"

GrassTuftA:
    .incbin "build/level_03/grass_tuft_a.0.bin"

GrassTuftB:
    .incbin "build/level_03/grass_tuft_b.0.bin"

GrassTuftBig:
    .incbin "build/level_03/grass_tuft_big.0.bin"

GrassTuftC:
    .incbin "build/level_03/grass_tuft_c.0.bin"

GrassTuftD:
    .incbin "build/level_03/grass_tuft_d.0.bin"

Kamisagi:
    .incbin "build/level_03/kamisagi.0.bin"

MukadeBachi1:
    .incbin "build/level_03/mukade_bachi_1.0.bin"

MukadeBachi2:
    .incbin "build/level_03/mukade_bachi_2.0.bin"

MukadeBachi3:
    .incbin "build/level_03/mukade_bachi_3.0.bin"

MukadeBachi5:
    .incbin "build/level_03/mukade_bachi_5.0.bin"

PowerupDrone:
    .incbin "build/level_03/powerup_drone.0.bin"
PowerupDroneMask:
    .incbin "build/level_03/powerup_drone_mask.0.bin"

PowerupPower:
    .incbin "build/level_03/powerup_power.0.bin"

PowerupRate:
    .incbin "build/level_03/powerup_rate.0.bin"

ShroomBomber:
    .incbin "build/level_03/shroom_bomber.0.bin"

ZombieCapybara:
    .incbin "build/level_03/zombie_capybara.0.bin"

ZombieSalaryman:
    .incbin "build/level_03/zombie_salaryman.0.bin"
ZombieSalarymanMask:
    .incbin "build/level_03/zombie_salaryman_mask.0.bin"

