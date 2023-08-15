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
    .word BiterflyMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 2 Coin
    .word Coin # sprite offset
    .word CoinMask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 4 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 3 GnatPack
    .word GnatPack # sprite offset
    .word GnatPackMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 4 GrassTuftA
    .word GrassTuftA # sprite offset
    .word GrassTuftAMask # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 5 GrassTuftB
    .word GrassTuftB # sprite offset
    .word GrassTuftBMask # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 6 GrassTuftBig
    .word GrassTuftBig # sprite offset
    .word GrassTuftBigMask # bit-mask offset
    .byte 16 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 7 GrassTuftC
    .word GrassTuftC # sprite offset
    .word GrassTuftCMask # bit-mask offset
    .byte 6 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 8 GrassTuftD
    .word GrassTuftD # sprite offset
    .word GrassTuftDMask # bit-mask offset
    .byte 5 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 9 Kamisagi
    .word Kamisagi # sprite offset
    .word KamisagiMask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 10 MukadeBachi1
    .word MukadeBachi1 # sprite offset
    .word MukadeBachi1Mask # bit-mask offset
    .byte 14 # height of the sprite
    .byte 10 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 11 MukadeBachi2
    .word MukadeBachi2 # sprite offset
    .word MukadeBachi2Mask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 12 MukadeBachi3
    .word MukadeBachi3 # sprite offset
    .word MukadeBachi3Mask # bit-mask offset
    .byte 12 # height of the sprite
    .byte 12 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 13 MukadeBachi5
    .word MukadeBachi5 # sprite offset
    .word MukadeBachi5Mask # bit-mask offset
    .byte 13 # height of the sprite
    .byte 11 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 14 PowerupDrone
    .word PowerupDrone # sprite offset
    .word PowerupMask # bit-mask offset
    .byte 21 # height of the sprite
    .byte 3 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 15 PowerupPower
    .word PowerupPower # sprite offset
    .word PowerupMask # bit-mask offset
    .byte 21 # height of the sprite
    .byte 3 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 16 PowerupRate
    .word PowerupRate # sprite offset
    .word PowerupMask # bit-mask offset
    .byte 21 # height of the sprite
    .byte 3 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 17 ShroomBomber
    .word ShroomBomber # sprite offset
    .word ShroomBomberMask # bit-mask offset
    .byte 30 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 18 ZombieCapybara
    .word ZombieCapybara # sprite offset
    .word ZombieCapybaraMask # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0 # Y offset
    .byte 8 # witdh
    .byte SPR_HAS_MASK # attributes

   # sprite 19 ZombieSalaryman
    .word ZombieSalaryman # sprite offset
    .word ZombieSalarymanMask # bit-mask offset
    .byte 37 # height of the sprite
    .byte 0 # Y offset
    .byte 6 # witdh
    .byte SPR_HAS_MASK # attributes

Biterfly:
    .incbin "build/level_03/biterfly.0.bin"
BiterflyMask:
    .incbin "build/level_03/biterfly_mask.0.bin"

Coin:
    .incbin "build/level_03/coin.0.bin"
CoinMask:
    .incbin "build/level_03/coin_mask.0.bin"
    .even

GnatPack:
    .incbin "build/level_03/gnat_pack.0.bin"
GnatPackMask:
    .incbin "build/level_03/gnat_pack_mask.0.bin"
    .even

GrassTuftA:
    .incbin "build/level_03/grass_tuft_a.0.bin"
GrassTuftAMask:
    .incbin "build/level_03/grass_tuft_a_mask.0.bin"
    .even

GrassTuftB:
    .incbin "build/level_03/grass_tuft_b.0.bin"
GrassTuftBMask:
    .incbin "build/level_03/grass_tuft_b_mask.0.bin"
    .even

GrassTuftBig:
    .incbin "build/level_03/grass_tuft_big.0.bin"
GrassTuftBigMask:
    .incbin "build/level_03/grass_tuft_big_mask.0.bin"
    .even

GrassTuftC:
    .incbin "build/level_03/grass_tuft_c.0.bin"
GrassTuftCMask:
    .incbin "build/level_03/grass_tuft_c_mask.0.bin"
    .even

GrassTuftD:
    .incbin "build/level_03/grass_tuft_d.0.bin"
GrassTuftDMask:
    .incbin "build/level_03/grass_tuft_d_mask.0.bin"
    .even

Kamisagi:
    .incbin "build/level_03/kamisagi.0.bin"
KamisagiMask:
    .incbin "build/level_03/kamisagi_mask.0.bin"
    .even

MukadeBachi1:
    .incbin "build/level_03/mukade_bachi_1.0.bin"
MukadeBachi1Mask:
    .incbin "build/level_03/mukade_bachi_1_mask.0.bin"
    .even

MukadeBachi2:
    .incbin "build/level_03/mukade_bachi_2.0.bin"
MukadeBachi2Mask:
    .incbin "build/level_03/mukade_bachi_2_mask.0.bin"
    .even

MukadeBachi3:
    .incbin "build/level_03/mukade_bachi_3.0.bin"
MukadeBachi3Mask:
    .incbin "build/level_03/mukade_bachi_3_mask.0.bin"
    .even

MukadeBachi5:
    .incbin "build/level_03/mukade_bachi_5.0.bin"
MukadeBachi5Mask:
    .incbin "build/level_03/mukade_bachi_5_mask.0.bin"
    .even

PowerupDrone:
    .incbin "build/level_03/powerup_drone.0.bin"
PowerupPower:
    .incbin "build/level_03/powerup_power.0.bin"
PowerupRate:
    .incbin "build/level_03/powerup_rate.0.bin"
PowerupMask:
    .incbin "build/level_03/powerup_drone_mask.0.bin"
    .even

ShroomBomber:
    .incbin "build/level_03/shroom_bomber.0.bin"
ShroomBomberMask:
    .incbin "build/level_03/shroom_bomber_mask.0.bin"
    .even

ZombieCapybara:
    .incbin "build/level_03/zombie_capybara.0.bin"
ZombieCapybaraMask:
    .incbin "build/level_03/zombie_capybara_mask.0.bin"
    .even

ZombieSalaryman:
    .incbin "build/level_03/zombie_salaryman.0.bin"
ZombieSalarymanMask:
    .incbin "build/level_03/zombie_salaryman_mask.0.bin"
    .even

