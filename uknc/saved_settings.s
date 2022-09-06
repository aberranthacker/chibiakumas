         .nolist

         .title Chibi Akumas saved settings
         .include "./core_defs.s"

         .global start # make the entry point available to a linker

         .global GameOptions
         .global FireMode
         .global ContinueMode
         .global SmartBombsReset
         .global ContinuesReset
         .global GameDifficulty
         .global Achivements
         .global MultiplayConfig
         .global TurboMode
         .global LivePlayers
         .global Player_Array
         .global   P1_P00
         .global   P1_P01
         .global   P1_P02
         .global   P1_P03
         .global   P1_P04
         .global   P1_P05
         .global   P1_P06
         .global   P1_P07
         .global   P1_P08
         .global   P1_P09
         .global   P1_P10
         .global   P1_P11
         .global   P1_P12
         .global   P1_P13
         .global   P1_P14
         .global   P1_P15

         .global Player_Array2
         .global   P2_P00
         .global   P2_P01
         .global   P2_P02
         .global   P2_P03
         .global   P2_P04
         .global   P2_P05
         .global   P2_P06
         .global   P2_P07
         .global   P2_P08
         .global   P2_P09
         .global   P2_P10
         .global   P2_P11
         .global   P2_P12
         .global   P2_P13
         .global   P2_P14
         .global   P2_P15

         .global Player_ScoreBytes
         .global Player_ScoreBytes2
         .global HighScoreBytes

         .=SavedSettingsStart

start:
    GameOptions:     .byte 0b00000001   #  GameOptions (xxxxxxxS) Screen shake
    FireMode:        .byte 0b00000000   #  playmode 0 normal / 128 - 4D
    ContinueMode:    .byte   0          #  Continue Sharing (0/1) # not implemented
    SmartBombsReset: .byte   3          #  SmartbombsReset
    ContinuesReset:  .byte  60          #  Continues Reset
    GameDifficulty:  .byte 0b00000000   #  Game difficulty
                                        #  (enemy Fire Speed 0=normal, ;1=easy, 2=hard)
                                        #  +128 = heaven mode , +64 = star Speedup
    Achivements:     .byte 0b00000000   #  Achievements (WPx54321) (W=Won P=Played)
    MultiplayConfig: .byte 0b00000000   #  Joy Config (xxxxxxFM)
                                        #  M=Multiplay
                                        #  F=Swap Fire 1/2
    TurboMode:       .byte 0b00000000   #  ------XX = Turbo mode [NoInsults/NoBackground/NoRaster/NoMusic]
    LivePlayers:     .byte 1            #  Number of players currently active in the game [2/1/0]
                .even
    Player_Array:
        P1_P00: .byte 100        #  0 - Y 0x64
        P1_P01: .byte 32         #  1 - X 0x20
        P1_P02: .byte 0          #  2 - shoot delay
        P1_P03: .byte 3          #  3 - smartbombs     # <= 127
        P1_P04: .byte 0          #  4 - drones (0/1/2) # <= 127
        P1_P05: .byte 60         #  5 - continues
        P1_P06: .byte 0          #  6 - drone pos
        P1_P07: .byte 0b00000111 #  7 - Invincible for how many ticks
        P1_P08: .byte 0          #  8 - Player SpriteNum
        P1_P09: .byte 3          #  9 - Lives          # <= 127
        P1_P10: .byte 0          # 10 - Burst Fire (Xfire)
        P1_P11: .byte 0b00000100 # 11 - Fire Speed - PlayerShootSpeed_Plus1
        P1_P12: .byte 0          # 12 - Player num (0=1, 1=2)
        P1_P13: .byte 0          # 13 - Points to add to player 1 - used to make score 'roll up'
        P1_P14: .byte 0          # 14 - PlayerShootPower_Plus1
        P1_P15: .byte 0x67       # 15 - FireDir

    Player_Array2:             #Player 2 is 16 bytes after player 1
        P2_P00: .byte 150        #  0 - Y 0x96
        P2_P01: .byte 32         #  1 - X 0x20
        P2_P02: .byte 0          #  2 - Shoot delay
        P2_P03: .byte 3          #  3 - smartbombs
        P2_P04: .byte 0          #  4 - Drones (0/1/2)
        P2_P05: .byte 60         #  5 - continues
        P2_P06: .byte 0          #  6 - Drone Pos
        P2_P07: .byte 0b00000111 #  7 - Invincibility
        P2_P08: .byte 0          #  8 - Player SpriteNum
        P2_P09: .byte 0          #  9 - Lives
        P2_P10: .byte 0          # 10 - Burst Fire
        P2_P11: .byte 0b00000100 # 11 - Fire speed
        P2_P12: .byte 128        # 12 - Player num (0=1,1=2)
        P2_P13: .byte 0          # 13 - Points to add to player 2 - used to make score 'roll up'
        P2_P14: .byte 0          # 14 - PlayerShootPower_Plus1
        P2_P15: .byte 0x67       # 15 - FireDir

    Player_ScoreBytes:  .space 8 # Player 1 current score
    Player_ScoreBytes2: .space 8 # Player 2 current score

    HighScoreBytes:     .space 8 # Highscore
end:
