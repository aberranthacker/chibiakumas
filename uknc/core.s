       .list

       .title Chibi Akumas core module
       .global start # make entry point available to a linker

# Global symbols ------------------------------------------------------------{{{
       .global Akuyou_GameVarsEnd
       .global Akuyou_GameVarsStart
       .global ContinueMode
       .global ContinuesReset
       .global Event_SavedSettings
       .global FileBeginCore
       .global FileEndCore
       .global KeyboardScanner_P1
       .global KeyboardScanner_P2
       .global LevelStart
       .global MultiplayConfig
       .global Player_Array
       .global Player_Array2
       .global Player_ScoreBytes
       .global Player_ScoreBytes2
       .global SavedSettings
       .global SavedSettings_Last
       .global SmartBombsReset
       .global StarArrayPointer
       .global PlayerStarArrayPointer
       .global null
#----------------------------------------------------------------------------}}}

       .include "./hwdefs.s"
       .include "./macros.s"
       .include "./core_defs.s"

#******************************************************************************#
#*                             Main Project Code                              *#
#******************************************************************************#
                .=Akuyou_GameVarsStart # Need about 2136 bytes

    # WARNING: update GameVarsArraySize calculation in `core_defs.s`
    # in case you changed values below
    ObjectArrayPointer:     .space ObjectArraySize * 8
    StarArrayPointer:       .space StarArraySize * 4
    PlayerStarArrayPointer: .space PlayerStarArraySize * 4
    Event_SavedSettings:    .space 15 * 8

    KeyboardScanner_P1: .word 0
    KeyboardScanner_P2: .word 0

start:
FileBeginCore:
SavedSettings: # {{{
                     .byte 255          # pos -20 spare
                     .byte   0          # pos -19 spare
                     .byte   0          # pos -18 spare
                     .byte   0          # pos -17 spare
                     .byte   0          # pos -16 spare
                     .byte 0b00000001   # pos -15 GameOptions (xxxxxxxS) Screen shake
                     .byte   0          # pos -14 playmode 0 normal / 128 - 4D
    ContinueMode:    .byte   0          # pos -13 Continue Sharing (0/1)
    SmartBombsReset: .byte   3          # pos -12 SmartbombsReset
    ContinuesReset:  .byte  60          # pos -11 Continues Reset
    GameDifficulty:  .byte   0          # pos -10 Game difficulty
                                        #         (enemy Fire Speed 0=normal, ;1=easy, 2=hard)
                                        #         +128 = heaven mode , +64 = star Speedup
                     .byte 0b00000000   # pos -9 Achievements (WPx54321) (W=Won P=Played)
    MultiplayConfig: .byte 0b00000000   # pos -8 Joy Config   (xxxxxxFM)
                                        # M=Multiplay
                                        # F=Swap Fire 1/2
    TurboMode:       .byte 0b00000000   # pos -7 ------XX = Turbo mode [NoInsults/NoBackground/NoRaster/NoMusic]
    LivePlayers:     .byte 1            # pos -6 Number of players currently active in the game [2/1/0]
    TimerTicks:      .byte 0            # pos -5 used for benchmarking
       .even
    ScreenBuffer_ActiveScreen:   .word FB1 # pos -4
    ScreenBuffer_VisibleScreen:  .word FB1 # pos -2

    Player_Array:
        P1_P00: .byte 100        #  0 - Y 0x64
        P1_P01: .byte 32         #  1 - X 0x20
        P1_P02: .byte 0          #  2 - shoot delay
        P1_P03: .byte 2          #  3 - smartbombs
        P1_P04: .byte 0          #  4 - drones (0/1/2)
        P1_P05: .byte 60         #  5 - continues
        P1_P06: .byte 0          #  6 - drone pos
        P1_P07: .byte 1          #  7 - Invincibility
        P1_P08: .byte 0          #  8 - Player SpriteNum
        P1_P09: .byte 3          #  9 - Lives
        P1_P10: .byte 100        # 10 - Burst Fire (Xfire)
        P1_P11: .byte 0b00000100 # 11 - Fire Speed - PlayerShootSpeed_Plus1
        P1_P12: .byte 0          # 12 - Player num (0=1, 1=2)
        P1_P13: .byte 0          # 13 - Points to add to player 1 - used to make score 'roll up'
        P1_P14: .byte 0          # 14 - PlayerShootPower_Plus1
        P1_P15: .byte 0x67       # 15 - FireDir

    Player_Array2:             #Player 2 is 16 bytes after player 1
        P2_P00: .byte 150        #  0 - Y 0x96
        P2_P01: .byte 32         #  1 - X 0x20
        P2_P02: .byte 0          #  2 - Shoot delay
        P2_P03: .byte 2          #  3 - smartbombs
        P2_P04: .byte 0          #  4 - Drones (0/1/2)
        P2_P05: .byte 60         #  5 - continues
        P2_P06: .byte 0          #  6 - Drone Pos
        P2_P07: .byte 1          #  7 - Invincibility
        P2_P08: .byte 0          #  8 - Player SpriteNum
        P2_P09: .byte 0          #  9 - Lives
        P2_P10: .byte 0          # 10 - Burst Fire
        P2_P11: .byte 0b00000100 # 11 - Fire speed
        P2_P12: .byte 128        # 12 - Player num (0=1,1=2)
        P2_P13: .byte 0          # 13 - Points to add to player 2 - used to make score 'roll up'
        P2_P14: .byte 0          # 14 - PlayerShootPower_Plus1
        P2_P15: .byte 0x67       # 15 - FireDir

    KeyMap2:
       .byte 0xFF,       0x00 # Pause
       .byte 0b01111111, 0x05 # Fire3
       .byte 0b10111111, 0x06 # Fire2R
       .byte 0b01111111, 0x06 # Fire1L
       .byte 0b11011111, 0x07 # Right
       .byte 0b11011111, 0x08 # Left
       .byte 0b11101111, 0x07 # Down
       .byte 0b11110111, 0x07 # Up

    KeyMap:
       .byte 0xF7,       0x03 # Pause bit 20
       .byte 0b11111011, 0x02 # Fire3     19
       .byte 0b11111011, 0x04 # Fire2R    18
       .byte 0b11110111, 0x04 # Fire1L    17
       .byte 0xFD,       0x00 # Right     16
       .byte 0xFE,       0x01 # Left      15
       .byte 0xFB,       0x00 # Down      14
       .byte 0xFE,       0x00 # Up        13

       .balign 8,0
    Player_ScoreBytes:  .space 8,0 # Player 2 current score
    Player_ScoreBytes2: .space 8,0 # Player 1 current score
    # 25
    HighScoreBytes:     .space 8,0 # Highscore
SavedSettings_Last: # 0x80 bytes --------------------------------------------}}}

# some data we don't need on UKNC -------------------------------------------{{{
                                        # ;X,X,Y,Y,S,[0,0,0] - [] not used
                                        # PlusSprites_Config1:
                                        #     ;These go at &6030
                                        #     defb &60-&00, &02, &08, &00
                                        #     defb &60-&20, &02, &08, &00
                                        #     defb &60-&40, &02, &08, &00
                                        #     defb &00+&00, &00, &08, &00
                                        #     defb &00+&20, &00, &08, &00
                                        #     defb &00+&40, &00, &08, &00
                                        # PlusSprites_Config2:
                                        #     defb &00+&00, &00, &B4, &00
                                        #     defb &00+&20, &00, &B4, &00
                                        #     defb &00+&40, &00, &B4, &00
                                        #     defb &60-&00, &02, &B4, &00
                                        #     defb &60-&20, &02, &B4, &00
                                        #     defb &60-&40, &02, &B4, &00
                                        #
                                        #   ;   Z change to zero
                                        # ;MusicRestoredefw 0000 ; pointer to the function to call to bring back the music
                                        #                        ; needed by 64k where music is wiped by firmware
                                        #
                                        # ;*******************************************************************************
                                        # ;                   Rastercolors Aligned Code
                                        # ;*******************************************************************************
                                        # ; Some template rastercolors to use for blackout (when using the screen for
                                        # ; temp space) and continue screens and the like with basic colors
                                        # align 256, &00
                                        #
                                        # DiskRemap:
                                        #     ifdef DiskMap_SingleDisk
                                        #         defb 1, 1, 1, 1, 1
                                        #     else
                                        #         defb 0, 1, 2, 3, 4
                                        #     endif
                                        #
                                        # RasterColors_Safe_ForInterrupt: defb 1, 1
                                        # RasterColors_Safe:              defb &54, &58, &5F, &4B
                                        # RasterColors_Black_ForInterrupt: defb 1, 1
                                        # RasterColors_Black:              defb &54, &54, &54, &54
                                        #
                                        # ; These are the default memory locations for the rastercolors - note they are
                                        # ; memory aligned - they are often overrided by the Level code
                                        # RasterColors_ColorArray1:
                                        # RasterColors_ColorArray3:
                                        # RasterColors_ColorArray4:
                                        # RasterColors_ColorArray2:
                                        #     defb 1
                                        #     defb 1
                                        #     defb 64+20, 64+24, 64+29, 64+11
                                        #
                                        # PlusRasterPalette: ; {{{
                                        #     defb 50 ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 100    ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 120    ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 200    ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 0      ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 0      ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 0      ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 200    ;next split
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defw &0000
                                        #     defb 0      ;next split }}}
# some data we don't need on UKNC -------------------------------------------}}}

# Transparent colors are used by the sprite, if the byte matches it is skipped
# to effect transparency without an 'alpha map'
TranspColors: .byte 0x00 # 0b00000000
              .byte 0xF0 # 0b11110000
              .byte 0x0F # 0b00001111
              .byte 0xFF # 0b11111111
              .byte 0xAC # 0b10101100
              .byte 0x53 # 0b10010011

# Smartbomb effect shows a flashing background, these are the bytes used
# Background_SmartBombColors: defb &FF, &0, &FF, &0, &FF

# StarsOneByteDirs:
#     defb &21,&09,&0C,&0F,&27,&3F,&3C,&39,&61,&49,&4c,&4f,&67,&7f,&7c,&79

Event_VectorArray:
       .word Event_SingleSprite                # 0x00 0x00  # defw Event_OneObj
       .word Event_MultiObj_NotImplemented     # 0x01 0x02  # defw Event_MultiObj
       .word Event_ObjColumn_NotImplemented    # 0x02 0x04  # defw Event_ObjColumn
       .word Event_ObjStrip_NotImplemented     # 0x03 0x06  # defw Event_ObjStrip
       .word Event_StarBurst_NotImplemented    # 0x04 0x08  # defw Event_StarBust
       .word null                              # 0x05 0x0A
       .word null                              # 0x06 0x0C
       .word Event_CoreMultipleEventsAtOneTime # 0x07 0x0E
       .word null                              # 0x08 0x10  Event_MoveSwitch, legacy
       .word Event_SaveObjSettings             # 0x09 0x12
       .word Event_LoadObjSettings             # 0x0A 0x14
       .word Event_CoreSaveLoadSettings2_NotImplemented # 0x0B 0x16  # defw Event_CoreSaveLoadSettings2
       .word null                              # 0x0C 0x18
       .word null                              # 0x0D 0x1A
       .word null                              # 0x0E 0x1C
       .word null                              # 0x0F 0x1E  Event_CoreReprogram, legacy
# Event_MoveVector:
       .word Event_SetMoveLife                 # 0x10 0x20  evtSetMoveLife
       .word Event_SetProgram                  # 0x11 0x22  # defw Event_ProgramSwitch_0001
       .word Event_SetLife                     # 0x12 0x24  evtSetLife
       .word Event_SetMove                     # 0x13 0x26    defw Event_MoveSwitch_0011
       .word Event_SetProgMoveLife             # 0x14 0x28  evtSetProgMoveLife
       .word Event_SpriteSwitch                # 0x15 0x2A    defw Event_SpriteSwitch_0101
       .word Event_AddToBackground             # 0x16 0x2C  evtAddToBackground
       .word Event_AddToForeground             # 0x17 0x2E  evtAddToForeground
       .word Event_ChangeStreamTime            # 0x18 0x30  evtChangeStreamTime
       .word Event_Call                        # 0x19 0x32  evtCallAddress
       .word Event_LoadLastAddedObjectToAddress # 0x1A 0x34  evtSaveLstObjToAdd
       .word Event_ClearPowerups_NotImplemented # 0x1B 0x36    defw Event_ClearPowerups
       .word Event_ChangeStreamSpeed_1100_NotImplemented # 0x1C 0x38    defw Event_ChangeStreamSpeed_1100
       .word Event_SetSpriteSize               # 0x1D 0x3A  evtSetObjectSize
       .word Event_SetAnimator                 # 0x1E 0x3C  evtSetAnimator
       .word Event_CoreReprogram_AnimatorPointer_NotImplemented # 0x1F 0x3E    defw Event_CoreReprogram_AnimatorPointer
# Event_ReprogramVector:
       .word Event_CoreReprogram_Palette       # 0x20 0x40
       .word null                              # 0x21 0x42  Obsolete - Reserver for Plus Palette
       .word Event_CoreReprogram_ObjectHitHandler_NotImplemented # 0x22 0x44  defw Event_CoreReprogram_ObjectHitHandler
       .word Event_CoreReprogram_ShotToDeath_NotImplemented # 0x23 0x46  defw Event_CoreReprogram_ShotToDeath
       .word Event_CoreReprogram_CustomMove1   # 0x24 0x48  mveCustom1
       .word Event_CoreReprogram_CustomMove2   # 0x25 0x4A  mveCustom2
       .word Event_CoreReprogram_PowerupSprites_NotImplemented # 0x26 0x4C  defw Event_CoreReprogram_PowerupSprites
       .word Event_CoreReprogram_CustomMove3   # 0x27 0x4E  mveCustom3
       .word Event_CoreReprogram_CustomMove4   # 0x28 0x50  mveCustom4
       .word Event_CustomProgram1_NotImplemented # 0x29 0x52  defw Event_CustomProgram1
       .word Event_CustomProgram2_NotImplemented # 0x2A 0x54  defw Event_CustomProgram2
       .word Event_CustomPlayerHitter_NotImplemented # 0x2B 0x56  defw Event_CustomPlayerHitter
       .word Event_CustomSmartBomb_NotImplemented # 0x2C 0x58  defw Event_CustomSmartBomb
       .word Event_ReprogramObjectBurstPosition_NotImplemented # 0x2D 0x5A  defw Event_ReprogramObjectBurstPosition
       .word Event_ObjectFullCustomMoves_NotImplemented # 0x2E 0x5C  defw Event_ObjectFullCustomMoves
       .word Event_SmartBombSpecial_NotImplemented # 0x2F 0x5E  defw Event_SmartBombSpecial

                                        # read "..\SrcCPC\Akuyou_CPC_InterruptHandler.asm"
null:   RETURN

Event_MultiObj_NotImplemented:
    .inform_and_hang "no Event_MultiObj"
Event_ObjColumn_NotImplemented:
    .inform_and_hang "no Event_ObjColumn"
Event_ObjStrip_NotImplemented:
    .inform_and_hang "no Event_ObjStrip"
Event_StarBurst_NotImplemented:
    .inform_and_hang "no Event_StarBurst"
Event_CoreSaveLoadSettings2_NotImplemented:
    .inform_and_hang "no Event_CoreSaveLoadSettings2"
Event_ClearPowerups_NotImplemented:
    .inform_and_hang "no Event_ClearPowerups"
Event_ChangeStreamSpeed_1100_NotImplemented:
    .inform_and_hang "no Event_ChangeStreamSpeed"
Event_CoreReprogram_AnimatorPointer_NotImplemented:
    .inform_and_hang "no Event_CoreReprogram_AnimatorPointer"
Event_CoreReprogram_ObjectHitHandler_NotImplemented:
    .inform_and_hang "no Event_CoreReprogram_ObjectHitHandler"
Event_CoreReprogram_ShotToDeath_NotImplemented:
    .inform_and_hang "no Event_CoreReprogram_ShotToDeath"
Event_CoreReprogram_PowerupSprites_NotImplemented:
    .inform_and_hang "no Event_CoreReprogram_PowerupSprites"
Event_CustomProgram1_NotImplemented:
    .inform_and_hang "no Event_CustomProgram1"
Event_CustomProgram2_NotImplemented:
    .inform_and_hang "no Event_CustomProgram2"
Event_CustomPlayerHitter_NotImplemented:
    .inform_and_hang "no Event_CustomPlayerHitter"
Event_CustomSmartBomb_NotImplemented:
    .inform_and_hang "no Event_CustomSmartBomb"
Event_ReprogramObjectBurstPosition_NotImplemented:
    .inform_and_hang "no Event_ReprogramObjectBurstPosition"
Event_ObjectFullCustomMoves_NotImplemented:
    .inform_and_hang "no Event_ObjectFullCustomMoves"
Event_SmartBombSpecial_NotImplemented:
    .inform_and_hang "no Event_SmartBombSpecial"

        # read "../SrcALL/Akuyou_Multiplatform_AkuCommandVectorArray.asm"
        # read "../SrcCPC/Akuyou_CPC_BankSwapper.asm"
       .include "core/compiled_sprite_viewer.s"
       .global CLS

       .include "core/do_moves.s"
       .global DoMoves
       .global Object_DecreaseLifeShot
       .global dstCustomShotToDeathCall
       .global dstObjectDoMovesOverride
       .global dstObjectShotOverride
       .global srcFireFrequencyA
       .global srcFireFrequencyB
       .global srcFireFrequencyC
       .global srcFireFrequencyD
       .global srcFireFrequencyE

       .include "core/event_stream.s"
       .global DoMovesBackground_SetScroll
       .global EventStream_Process
       .global EventStream_Init
       .global srcEventObjectAnimatorToAdd
       .global srcEventObjectProgramToAdd
       .global srcEventObjectSpriteSizeToAdd
       .global srcEvent_LevelTime

       .include "core/execute_bootstrap.s"
       .global ExecuteBootstrap

       .include "core/gradient.s"
       .global Background_Gradient
       .global Background_GradientScroll

       .include "core/object_driver.s"
       .global ObjectArray_Redraw

       .include "core/player_driver.s"
       .global DroneFlipFire
       .global PlayerHandler
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
       .global cmpDroneFlipCurrent
       .global cmpDroneFlipFireCurrent
       .global dstCustomPlayerHitter
       .global dstCustomSmartBombEnemy
       .global dstFire1Handler
       .global dstFire2Handler
       .global dstFireDownHandler
       .global dstFireLeftHandler
       .global dstFireRightHandler
       .global dstFireUpHandler
       .global dstSmartBombSpecial
       .global srcContinuesScreenPos
       .global srcShowContinueCounter

       .include "core/screen_memory.s"
       .global GetMemPos
       .global ScreenBuffer_ActiveScreen
       .global ScreenBuffer_Flip
       .global ScreenBuffer_Init
       .global ScreenBuffer_Reset

       .include "core/sfx.s"
       .global srcSfx_CurrentPriority
       .global srcSfx_Sound

       .include "core/show_sprite.s"

       .include "core/stararray.s"
       .global opcStarSlowdown
       .global StarArray_Redraw
       .global Player_StarArray_Redraw

       .include "core/stararray_add.s"
       .global Stars_AddBurst_Top

       .include "core/timer.s"
       .global Timer_GetTimer
       .global Timer_UpdateTimer
       .global srcTimer_CurrentTick
       .global srcTimer_TicksOccured

       .include "core/virtual_screen_pos_320.s"
       .global ShowSpriteReconfigureEnableDisable

       .include "decoders/lzsa1.s"
       .global unlzsa1

       ## ifdef Debug_Monitor
       ## ;   read "../SrcALL/Multiplatform_Monitor.asm"
       ## ;   read "../SrcALL/Multiplatform_MonitorMemdump.asm"
       ## ;   read "../SrcALL/Multiplatform_MonitorSimple.asm"
       ## endif

       .include "background_solid_fill.s"
       .global Background_SolidFill

       .include "background_quad_sprite.s"
       .global Background_FloodFillQuadSprite

       .include "background_bit_shifter.s"
       .global BitShifter
       .global srcBitShifter_TicksOccured

       .include "background_get_sprite_mem_pos.s"
       .global GetSpriteMempos

       .even
end: FileEndCore:

LevelStart:
       .nolist
