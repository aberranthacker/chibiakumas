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

   # sprite 2 Powerup Drone
    .word PowerupDrone # sprite offset
    .word 0  # bit-mask offset
    .byte 21 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 3 Powerup Rate
    .word PowerupRate # sprite offset
    .word 0  # bit-mask offset
    .byte 21 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 4 Powerup Power
    .word PowerupPower # sprite offset
    .word 0  # bit-mask offset
    .byte 21 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 5 Boulder
    .word Boulder # sprite offset
    .word 0  # bit-mask offset
    .byte 12 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 6 BoulderSmall
    .word BoulderSmall # sprite offset
    .word 0  # bit-mask offset
    .byte 8  # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 7 Burning Bloke
    .word BurningBloke # sprite offset
    .word 0  # bit-mask offset
    .byte 32 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 8 Castle
    .word Castle # sprite offset
    .word 0   # bit-mask offset
    .byte 106 # height of the sprite
    .byte 0   # Y offset
    .byte 12  # width
    .byte SPR_PSET # attributes

   # sprite 9 Cloud first part
    .word CloudA # sprite offset
    .word CloudAMask # bit-mask offset
    .byte 12 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK | SPR_DOUBLE # attributes

   # sprite 10 Cloud second part
    .word CloudB # sprite offset
    .word CloudAMask # bit-mask offset
    .byte 12 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK | SPR_DOUBLE # attributes

   # sprite 11 Cloud third part
    .word CloudC # sprite offset
    .word CloudAMask # bit-mask offset
    .byte 11 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK | SPR_DOUBLE # attributes

   # sprite 12 Cross
    .word Cross # sprite offset
    .word 0  # bit-mask offset
    .byte 19 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte 0 # attributes

   # sprite 13 Cross Crucified Bloke
    .word CrossCrucifiedBloke # sprite offset
    .word 0  # bit-mask offset
    .byte 20 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 14 Cross Impaled Bloke
    .word CrossImpaledBloke # sprite offset
    .word 0  # bit-mask offset
    .byte 23 # height of the sprite
    .byte 0  # Y offset
    .byte 4  # width
    .byte SPR_PSET # attributes

   # sprite 15 Gravecross
    .word Gravecross # sprite offset
    .word GravecrossMask # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 16 Gravestone
    .word Gravestone # sprite offset
    .word GravestoneMask  # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 17 Moon
    .word Moon # sprite offset
    .word MoonMask  # bit-mask offset
    .byte 31 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 18 Rock Pt.1
    .word RockPT1 # sprite offset
    .word RockPT1Mask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 19 Rock Pt.2
    .word RockPT2 # sprite offset
    .word RockPT2Mask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 20 Rock Pt.3
    .word RockPT3 # sprite offset
    .word RockPT3Mask # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 21 Spikey Rock top part
    .word SpikeyRockA # sprite offset
    .word 0  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 22 Spikey Rock middle part
    .word SpikeyRockB # sprite offset
    .word 0  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 23 Spikey Rock bottom part
    .word SpikeyRockC # sprite offset
    .word 0  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 24 Ant Attacker
    .word AntAttacker # sprite offset
    .word 0  # bit-mask offset
    .byte 22 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte 0 # attributes

   # sprite 25 Boni Burd
    .word BoniBurd # sprite offset
    .word BoniBurdMask  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 8  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 26 Eyeclopse
    .word EyeClopse # sprite offset
    .word EyeClopseMask  # bit-mask offset
    .byte 31 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 27 Rock Chick
    .word RockChick # sprite offset
    .word 0  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 28 Skeleton Crawler
    .word SkeletonCrawler # sprite offset
    .word SkeletonCrawlerMask  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_HAS_MASK # attributes

   # sprite 29 Skull Bomber
    .word SkullBomber # sprite offset
    .word 0  # bit-mask offset
    .byte 23 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 30 Skull Gang
    .word SkullGang # sprite offset
    .word 0  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

   # sprite 31 Splice-Face
    .word SpliceFace # sprite offset
    .word 0  # bit-mask offset
    .byte 24 # height of the sprite
    .byte 0  # Y offset
    .byte 6  # width
    .byte SPR_PSET # attributes

Coin:
    .incbin "build/level_01/coin.1.bin"
PowerupDrone:
    .incbin "build/level_01/powerup_drone.1.bin"
PowerupRate:
    .incbin "build/level_01/powerup_rate.1.bin"
PowerupPower:
    .incbin "build/level_01/powerup_power.1.bin"
Boulder:
    .incbin "build/level_01/boulder.1.bin"
BoulderSmall:
    .incbin "build/level_01/boulder_small.1.bin"
BurningBloke:
    .incbin "build/level_01/burning_bloke.1.bin"
Castle:
    .incbin "build/level_01/castle.1.bin"
CloudA:
    .incbin "build/level_01/cloud_a.1.bin"
CloudB:
    .incbin "build/level_01/cloud_b.1.bin"
CloudC:
    .incbin "build/level_01/cloud_c.1.bin"
CloudAMask:
    .incbin "build/level_01/cloud_a_mask.1.bin"
CloudBMask:
    .incbin "build/level_01/cloud_b_mask.1.bin"
CloudCMask:
    .incbin "build/level_01/cloud_c_mask.1.bin"
Cross:
    .incbin "build/level_01/cross.1.bin"
CrossCrucifiedBloke:
    .incbin "build/level_01/cross_crucified_bloke.1.bin"
CrossImpaledBloke:
    .incbin "build/level_01/cross_impaled_bloke.1.bin"
Gravecross:
    .incbin "build/level_01/gravecross.1.bin"
GravecrossMask:
    .incbin "build/level_01/gravecross_mask.1.bin"
Gravestone:
    .incbin "build/level_01/gravestone.1.bin"
GravestoneMask:
    .incbin "build/level_01/gravestone_mask.1.bin"
Moon:
    .incbin "build/level_01/moon.1.bin"
MoonMask:
    .incbin "build/level_01/moon_mask.1.bin"
RockPT1:
    .incbin "build/level_01/rock_pt1.1.bin"
RockPT2:
    .incbin "build/level_01/rock_pt2.1.bin"
RockPT3:
    .incbin "build/level_01/rock_pt3.1.bin"
RockPT1Mask:
    .incbin "build/level_01/rock_pt1_mask.1.bin"
RockPT2Mask:
    .incbin "build/level_01/rock_pt2_mask.1.bin"
RockPT3Mask:
    .incbin "build/level_01/rock_pt3_mask.1.bin"
SpikeyRockA:
    .incbin "build/level_01/spikey_rock_a.1.bin"
SpikeyRockB:
    .incbin "build/level_01/spikey_rock_b.1.bin"
SpikeyRockC:
    .incbin "build/level_01/spikey_rock_c.1.bin"
AntAttacker:
    .incbin "build/level_01/ant_attacker.1.bin"
BoniBurd:
    .incbin "build/level_01/boni_burd.1.bin"
BoniBurdMask:
    .incbin "build/level_01/boni_burd_mask.1.bin"
EyeClopse:
    .incbin "build/level_01/eye_clopse.1.bin"
EyeClopseMask:
    .incbin "build/level_01/eye_clopse_mask.1.bin"
RockChick:
    .incbin "build/level_01/rock_chick.1.bin"
SkeletonCrawler:
    .incbin "build/level_01/skeleton_crawler.1.bin"
SkeletonCrawlerMask:
    .incbin "build/level_01/skeleton_crawler_mask.1.bin"
SkullBomber:
    .incbin "build/level_01/skull_bomber.1.bin"
SkullGang:
    .incbin "build/level_01/skull_gang.1.bin"
SpliceFace:
    .incbin "build/level_01/splice_face.1.bin"

