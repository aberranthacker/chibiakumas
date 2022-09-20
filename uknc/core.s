       .list

       .title Chibi Akumas core module
       .global start # make entry point available to a linker

# Global symbols ------------------------------------------------------------{{{
       .global FileBeginCore
       .global FileEndCore
       .global LevelStart
       .global SpriteBanksVectors
       .global TRandW
       .global null
#----------------------------------------------------------------------------}}}

       .include "./hwdefs.s"
       .include "./macros.s"
       .include "./core_defs.s"
       .include "./event_stream_definitions.s"

#******************************************************************************#
#*                             Main Project Code                              *#
#******************************************************************************#
       .=CoreStart

start: FileBeginCore:

# Generates a next 16-bit pseudorandom number
# generator period is 0xfffe0000 (4294836224)
#
# Inputs:
#       None
# Outputs:
#       R0 - next pseudorandom number
# Corrupts:
#       None
#
# Author: Alexander "Sandro" Tishin
#
TRandW:
       .equiv rseed1, .+2
        MOV $0, R0
        ADD R0, R0
        BHI 1$
        ADD $39, R0
    1$:
        MOV R0, @$rseed1
       .equiv rseed2, .+2
        ADD $0, R0
        MOV R0, @$rseed2
        RETURN

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
       .word Event_CoreReprogram_Palette          # 0x20 0x40
       .word null                                 # 0x21 0x42  Obsolete - Reserver for Plus Palette
       .word Event_CoreReprogram_ObjectHitHandler # 0x22 0x44  defw Event_CoreReprogram_ObjectHitHandler
       .word not_implemented_check_R0             # 0x23 0x46  defw Event_CoreReprogram_ShotToDeath
       .word Event_CoreReprogram_CustomMove1      # 0x24 0x48  mveCustom1
       .word Event_CoreReprogram_CustomMove2      # 0x25 0x4A  mveCustom2
       .word Event_CoreReprogram_PowerupSprites   # 0x26 0x4C  defw Event_CoreReprogram_PowerupSprites
       .word Event_CoreReprogram_CustomMove3      # 0x27 0x4E  mveCustom3
       .word Event_CoreReprogram_CustomMove4      # 0x28 0x50  mveCustom4
       .word not_implemented_check_R0             # 0x29 0x52  defw Event_CustomProgram1
       .word not_implemented_check_R0             # 0x2A 0x54  defw Event_CustomProgram2
       .word not_implemented_check_R0             # 0x2B 0x56  defw Event_CustomPlayerHitter
       .word not_implemented_check_R0             # 0x2C 0x58  defw Event_CustomSmartBomb
       .word not_implemented_check_R0             # 0x2D 0x5A  defw Event_ReprogramObjectBurstPosition
       .word not_implemented_check_R0             # 0x2E 0x5C  defw Event_ObjectFullCustomMoves
       .word not_implemented_check_R0             # 0x2F 0x5E  defw Event_SmartBombSpecial

null:   RETURN

not_implemented_check_R0:
    .ifdef DebugMode
       .inform_and_hang "core: not implemented\ncheck R0 for jump vector"
    .else
        BR   null
    .endif

       .include "core/do_moves.s"
       .global DoMoves
       .global FireFrequencyA
       .global FireFrequencyB
       .global FireFrequencyC
       .global FireFrequencyD
       .global FireFrequencyE
       .global Object_DecreaseLifeShot
       .global dstCustomShotToDeathCall
       .global dstObjectDoMovesOverride
       .global dstObjectShotOverride

       .include "core/event_stream.s"
       .global DoMovesBackground_SetScroll
       .global EventObjectAnimatorToAdd
       .global EventObjectProgramToAdd
       .global EventObjectSpriteSizeToAdd
       .global EventStream_Init
       .global EventStream_Process
       .global Event_LevelTime
       .global Event_RestorePalette
       .global SetLevelTime

       .include "core/execute_bootstrap.s"
       .global ExecuteBootstrap
       .global ExecuteBootstrap_NoCLS

       .include "core/gradient.s"
       .global Background_Gradient
       .global Background_GradientScroll

       .include "core/object_driver.s"
       .global ObjectArray_Redraw

       .include "core/player_driver.s"
       .global ContinuesScreenPos
       .global DroneFlipCurrent
       .global DroneFlipFire
       .global DroneFlipFireCurrent
       .global Fire1Handler
       .global Fire2Handler
       .global FireDownHandler
       .global FireLeftHandler
       .global FireRightHandler
       .global FireUpHandler
       .global PlayerCounter
       .global PlayerHandler
       .global Player_DrawUI
       .global Player_GetPlayerVars
       .global Player_Handler_DoSmartBomb
       .global SetFireDir_DOWN
       .global SetFireDir_Fire
       .global SetFireDir_FireAndSaveRestore
       .global SetFireDir_LEFT
       .global SetFireDir_LEFTsave
       .global SetFireDir_RIGHT
       .global SetFireDir_RIGHTsave
       .global SetFireDir_UP
       .global ShowContinueCounter
       .global ShowContinuesSelfMod
       .global SpendCreditSelfMod
       .global dstCustomPlayerHitter
       .global dstCustomSmartBombEnemy
       .global dstSmartBombSpecial

       .include "core/screen_memory.s"
       .global CLS
       .global ScreenBuffer_ActiveScreen
       .global ScreenBuffer_Flip
       .global ScreenBuffer_Reset

       .include "core/show_sprite.s"
       .global SprShow_BankAddr

       .include "core/stararray.s"
       .global Player_StarArray_Redraw
       .global StarArray_Redraw
       .global opcStarSlowdown

       .include "core/stararray_add.s"
       .global BurstSpacing
       .global Stars_AddBurst_Top

       .include "core/timer.s"
       .global SmartBombTimer
       .global Timer_CurrentTick
       .global Timer_GetTimer
       .global Timer_TicksOccured
       .global Timer_UpdateTimer

       .include "core/virtual_screen_pos_320.s"
       .global ShowSpriteReconfigureEnableDisable

       .include "decoders/lzsa1.s"
       .global unlzsa1

       .include "core/background_solid_fill.s"
       .global Background_SolidFill

       .include "core/background_quad_sprite.s"
       .global Background_FloodFillQuadSprite
       .global Background_FloodFillQuadSpriteColumn

       .include "core/background_bit_shifter.s"
       .global BitShifter
       .global BitShifter_TicksOccured

       .include "core/background_bit_shifter_double.s"
       .global BitShifterDouble

       .include "core/background_get_sprite_mem_pos.s"
       .global GetSpriteMempos

       .even
       .space 2
end: FileEndCore:

LevelStart:
       .nolist
