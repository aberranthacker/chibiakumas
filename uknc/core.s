       .list

       .title Chibi Akumas core module
       .global start # make entry point available to a linker

# Global symbols ------------------------------------------------------------{{{
       .global ContinueMode
       .global ContinuesReset
       .global FileBeginCore
       .global FileEndCore
       .global FireMode
       .global GameDifficulty
       .global KeyboardScanner_P1
       .global KeyboardScanner_P2
       .global LevelStart
       .global LivePlayers
       .global MultiplayConfig
       .global Player_Array
   .ifdef TwoPlayersGame
       .global Player_Array2
   .endif
       .global Player_ScoreBytes
       .global Player_ScoreBytes2
       .global SavedSettings
       .global SavedSettings_Last
       .global SmartBombsReset
       .global SpriteBanksVectors
       .global null
       .global P1_P13
#----------------------------------------------------------------------------}}}

       .include "./hwdefs.s"
       .include "./macros.s"
       .include "./core_defs.s"

#******************************************************************************#
#*                             Main Project Code                              *#
#******************************************************************************#
       .=CoreStart

start: FileBeginCore:
SavedSettings: #-------------------------------------------------------------{{{
    GameOptions:     .byte 0b00000001   #  GameOptions (xxxxxxxS) Screen shake
    FireMode:        .byte 0b00000000   #  playmode 0 normal / 128 - 4D
    ContinueMode:    .byte   0          #  Continue Sharing (0/1)
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
        P1_P09: .byte 20         #  9 - Lives          # <= 127
        P1_P10: .byte 0          # 10 - Burst Fire (Xfire)
        P1_P11: .byte 0b00000100 # 11 - Fire Speed - PlayerShootSpeed_Plus1
        P1_P12: .byte 0          # 12 - Player num (0=1, 1=2)
        P1_P13: .byte 0          # 13 - Points to add to player 1 - used to make score 'roll up'
        P1_P14: .byte 0          # 14 - PlayerShootPower_Plus1
        P1_P15: .byte 0x67       # 15 - FireDir

.ifdef TwoPlayersGame
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
.endif

    Player_ScoreBytes:  .space 8 # Player 1 current score
.ifdef TwoPlayersGame
    Player_ScoreBytes2: .space 8 # Player 2 current score
.endif

    HighScoreBytes:     .space 8 # Highscore
SavedSettings_Last: # 0x80 bytes --------------------------------------------}}}

SpriteBanksVectors:
       .word LevelSprites
       .word LevelSprites
       .word LevelSprites
       .word LevelSprites

# to effect transparency without an 'alpha map'
TranspColors: .byte 0x00 # 0b00000000
              .byte 0xF0 # 0b11110000
              .byte 0x0F # 0b00001111
              .byte 0xFF # 0b11111111
              .byte 0xAC # 0b10101100
              .byte 0x53 # 0b10010011

# Smartbomb effect shows a flashing background, these are the bytes used
Background_SmartBombColors:
       .word 0xFFFF, 0x0000, 0xFFFF, 0x0000, 0xFFFF

Event_VectorArray:
       .word Event_SingleSprite                 # 0x00 0x00  defw Event_OneObj
       .word not_implemented_check_R0           # 0x01 0x02  defw Event_MultiObj
       .word not_implemented_check_R0           # 0x02 0x04  defw Event_ObjColumn
       .word not_implemented_check_R0           # 0x03 0x06  defw Event_ObjStrip
       .word not_implemented_check_R0           # 0x04 0x08  defw Event_StarBust
       .word null                               # 0x05 0x0A
       .word null                               # 0x06 0x0C
       .word Event_CoreMultipleEventsAtOneTime  # 0x07 0x0E
       .word null                               # 0x08 0x10  Event_MoveSwitch, legacy
       .word Event_SaveObjSettings              # 0x09 0x12
       .word Event_LoadObjSettings              # 0x0A 0x14
       .word not_implemented_check_R0           # 0x0B 0x16  defw Event_CoreSaveLoadSettings2
       .word null                               # 0x0C 0x18
       .word null                               # 0x0D 0x1A
       .word null                               # 0x0E 0x1C
       .word null                               # 0x0F 0x1E  Event_CoreReprogram, legacy
# Event_MoveVector:
       .word Event_SetMoveLife                   # 0x10 0x20  evtSetMoveLife
       .word Event_SetProgram                    # 0x11 0x22    defw Event_ProgramSwitch_0001
       .word Event_SetLife                       # 0x12 0x24  evtSetLife
       .word Event_SetMove                       # 0x13 0x26    defw Event_MoveSwitch_0011
       .word Event_SetProgMoveLife               # 0x14 0x28  evtSetProgMoveLife
       .word Event_SetSprite                     # 0x15 0x2A    defw Event_SpriteSwitch_0101
       .word Event_AddToBackground               # 0x16 0x2C  evtAddToBackground
       .word Event_AddToForeground               # 0x17 0x2E  evtAddToForeground
       .word Event_ChangeStreamTime              # 0x18 0x30  evtChangeStreamTime
       .word Event_CallSubroutine                # 0x19 0x32  evtCallAddress
       .word Event_LoadLastAddedObjectToAddress  # 0x1A 0x34  evtSaveLstObjToAdd
       .word not_implemented_check_R0            # 0x1B 0x36    defw Event_ClearPowerups
       .word not_implemented_check_R0            # 0x1C 0x38    defw Event_ChangeStreamSpeed_1100
       .word Event_SetSpriteSize                 # 0x1D 0x3A  evtSetObjectSize
       .word Event_SetAnimator                   # 0x1E 0x3C  evtSetAnimator
       .word Event_CoreReprogram_AnimatorPointer # 0x1F 0x3E    defw Event_CoreReprogram_AnimatorPointer
# Event_ReprogramVector:
       .word Event_CoreReprogram_Palette        # 0x20 0x40
       .word null                               # 0x21 0x42  Obsolete - Reserver for Plus Palette
       .word not_implemented_check_R0           # 0x22 0x44  defw Event_CoreReprogram_ObjectHitHandler
       .word not_implemented_check_R0           # 0x23 0x46  defw Event_CoreReprogram_ShotToDeath
       .word Event_CoreReprogram_CustomMove1    # 0x24 0x48  mveCustom1
       .word Event_CoreReprogram_CustomMove2    # 0x25 0x4A  mveCustom2
       .word not_implemented_check_R0           # 0x26 0x4C  defw Event_CoreReprogram_PowerupSprites
       .word Event_CoreReprogram_CustomMove3    # 0x27 0x4E  mveCustom3
       .word Event_CoreReprogram_CustomMove4    # 0x28 0x50  mveCustom4
       .word not_implemented_check_R0           # 0x29 0x52  defw Event_CustomProgram1
       .word not_implemented_check_R0           # 0x2A 0x54  defw Event_CustomProgram2
       .word not_implemented_check_R0           # 0x2B 0x56  defw Event_CustomPlayerHitter
       .word not_implemented_check_R0           # 0x2C 0x58  defw Event_CustomSmartBomb
       .word not_implemented_check_R0           # 0x2D 0x5A  defw Event_ReprogramObjectBurstPosition
       .word not_implemented_check_R0           # 0x2E 0x5C  defw Event_ObjectFullCustomMoves
       .word not_implemented_check_R0           # 0x2F 0x5E  defw Event_SmartBombSpecial

null:   RETURN

not_implemented_check_R0:
    .ifdef DebugMode
       .inform_and_hang "core: not implemented\ncheck R0 for jump vector"
    .else
        BR   null
    .endif

       .include "core/compiled_sprite_viewer.s"
       .global CLS

       .include "core/do_moves.s"
       .global DoMoves
       .global Object_DecreaseLifeShot
       .global dstCustomShotToDeathCall
       .global dstObjectDoMovesOverride
       .global dstObjectShotOverride
       .global FireFrequencyA
       .global FireFrequencyB
       .global FireFrequencyC
       .global FireFrequencyD
       .global FireFrequencyE

       .include "core/event_stream.s"
       .global DoMovesBackground_SetScroll
       .global EventStream_Process
       .global EventStream_Init
       .global EventObjectAnimatorToAdd
       .global EventObjectProgramToAdd
       .global EventObjectSpriteSizeToAdd
       .global Event_LevelTime

       .include "core/execute_bootstrap.s"
       .global ExecuteBootstrap

       .include "core/gradient.s"
       .global Background_Gradient
       .global Background_GradientScroll

       .include "core/object_driver.s"
       .global ObjectArray_Redraw

       .include "core/player_driver.s"
       .global DroneFlipFire
       .global Player_DrawUI
       .global PlayerHandler
       .global Player_Handler_DoSmartBomb
       .global Player_GetPlayerVars
       .global SetFireDir_DOWN
       .global SetFireDir_Fire
       .global SetFireDir_FireAndSaveRestore
       .global SetFireDir_LEFT
       .global SetFireDir_LEFTsave
       .global SetFireDir_RIGHT
       .global SetFireDir_RIGHTsave
       .global SetFireDir_UP
       .global ShowContinuesSelfMod
       .global SpendCreditSelfMod
       .global DroneFlipCurrent
       .global DroneFlipFireCurrent
       .global dstCustomPlayerHitter
       .global dstCustomSmartBombEnemy
       .global Fire1Handler
       .global Fire2Handler
       .global FireDownHandler
       .global FireLeftHandler
       .global FireRightHandler
       .global FireUpHandler
       .global dstSmartBombSpecial
       .global ContinuesScreenPos
       .global ShowContinueCounter

       .include "core/screen_memory.s"
       .global GetMemPos
       .global ScreenBuffer_ActiveScreen
       .global ScreenBuffer_Flip
       .global ScreenBuffer_Init
       .global ScreenBuffer_Reset

       .include "core/show_sprite.s"
       .global SprShow_BankAddr

       .include "core/stararray.s"
       .global opcStarSlowdown
       .global StarArray_Redraw
       .global Player_StarArray_Redraw

       .include "core/stararray_add.s"
       .global Stars_AddBurst_Top
       .global BurstSpacing

       .include "core/timer.s"
       .global Timer_GetTimer
       .global Timer_UpdateTimer
       .global Timer_CurrentTick
       .global Timer_TicksOccured
       .global SmartBombTimer

       .include "core/virtual_screen_pos_320.s"
       .global ShowSpriteReconfigureEnableDisable

       .include "decoders/lzsa1.s"
       .global unlzsa1

       .include "core/background_solid_fill.s"
       .global Background_SolidFill

       .include "core/background_quad_sprite.s"
       .global Background_FloodFillQuadSprite

       .include "core/background_bit_shifter.s"
       .global BitShifter
       .global BitShifter_TicksOccured

       .include "core/background_bit_shifter_double.s"
       .global BitShifterDouble

       .include "core/background_get_sprite_mem_pos.s"
       .global GetSpriteMempos

       .even
      #.space 2
end: FileEndCore:

LevelStart:
       .nolist
