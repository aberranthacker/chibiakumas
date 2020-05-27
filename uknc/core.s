       .nolist

       .title Chibi Akumas core module
       .global start # make entry point available to a linker

# Global symbols ------------------------------------------------------------{{{
       .global Akuyou_GameVarsStart
       .global Akuyou_GameVarsEnd
       .global ContinueMode
       .global ContinuesReset
       .global CLS
       .global Event_Stream
       .global EventStream_Process
       .global Event_SavedSettings
       .global ExecuteBootstrap
       .global FileBeginCore
       .global FileEndCore
       .global GetMemPos
       .global KeyboardScanner_P1
       .global KeyboardScanner_P2
       .global LevelStart
       .global MultiplayConfig
       .global null
       .global ObjectArray_Redraw
       .global Player_Array
       .global Player_Array2
       .global Player_ScoreBytes
       .global Player_ScoreBytes2
       .global SavedSettings
       .global SavedSettings_Last
       .global ScreenBuffer_ActiveScreen
       .global ScreenBuffer_Reset
       .global SmartBombsReset
       .global StarArrayPointer
       .global Timer_UpdateTimer
#----------------------------------------------------------------------------}}}

       .include "./hwdefs.s"
       .include "./macros.s"
       .include "./core_defs.s"

#******************************************************************************#
#*                             Main Project Code                              *#
#******************************************************************************#
                .=Akuyou_GameVarsStart # Need about 2136 bytes

        ObjectArrayPointer:     .space ObjectArraySize * 8
        StarArrayPointer:       .space StarArraySize * 4
        PlayerStarArrayPointer: .space PlayerStarArraySize * 4
        Event_SavedSettings:    .space 15 * 8

        KeyboardScanner_P1: .word 0
        KeyboardScanner_P2: .word 0

Akuyou_GameVarsEnd:

start:
FileBeginCore:
SavedSettings: # {{{
                     .byte 255          # pos -22 spare
                     .byte   0          # pos -21 spare
                     .byte   0          # pos -20 spare
                     .byte   0          # pos -19 spare
                     .byte 0b00000001   # pos -18 GameOptions (xxxxxxxS) Screen shake
                     .byte   0          # pos -17 playmode 0 normal / 128 - 4D
    ContinueMode:    .byte   0          # pos -16 Continue Sharing (0/1)
    SmartBombsReset: .byte   3          # pos -15 SmartbombsReset
    ContinuesReset:  .byte  60          # pos -14 Continues Reset
    GameDifficulty:  .byte   0          # pos -13 Game difficulty
                                        #         (enemy Fire Speed 0=normal, ;1=easy, 2=hard)
                                        #         +128 = heaven mode , +64 = star Speedup
                     .byte 0b00000000   # pos -12 Achievements (WPx54321) (W=Won P=Played)
    MultiplayConfig: .byte 0b00000000   # pos -11 Joy Config   (xxxxxxFM)
                                        # M=Multiplay
                                        # F=Swap Fire 1/2
    TurboMode:       .byte 0b00000000   # pos -10 ------XX = Turbo mode [NoInsults/NoBackground/NoRaster/NoMusic]
    LivePlayers:     .byte 1            # pos -9 Number of players currently active in the game [2/1/0]
    TimerTicks:      .byte 0            # pos -8 used for benchmarking
    BlockHeavyPageFlippedColors: .byte 64   # pos -7 0/255=on  64=off
    BlockPageFlippedColors:      .byte 255  # pos -6 0/255=on  64=off
    # ;CPC 0  =464 , 128=128 ; 129 = 128 plus ; 192 = 128 plus with 512k; 193 = 128 plus with 512k pos -1
    # ;MSX 1=V9990  4=turbo R
    # ;ZX  0=TAP 1=TRD 2=DSK   128= 128k ;192 = +3 or black +2
    CPCVer: .byte 00                    # pos  -5

       .even
    ScreenBuffer_ActiveScreen:   .word FB1 # pos -3
    ScreenBuffer_VisibleScreen:  .word FB1 # pos -1

    Player_Array:
        P1_P00: .byte 100        #  0 - Y 0x64
        P1_P01: .byte 32         #  1 - X 0x20
        P1_P02: .byte 0          #  2 - shoot delay
        P1_P03: .byte 2          #  3 - smartbombs
        P1_P04: .byte 0          #  4 - drones (0/1/2)
        P1_P05: .byte 60         #  5 - continues
        P1_P06: .byte 0          #  6 - drone pos
        P1_P07: .byte 0b00000111 #  7 - Invincibility
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
        P2_P07: .byte 0b00000111 #  7 - Invincibility
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
                                        #
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
                                        #
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
                                        #
                                        # ; table/array for screen addresses for each scan line
                                        ##ifdef MinimizeCore
                                        #     scr_addr_tableMajor: ; BYTES -XXXX--- %01111000
                                        #         defw &0000,&0050,&00A0,&00F0,&0140,&0190,&01E0,&0230,&0280,&02D0,&0320,&0370,&03C0,&0410,&0460,&04B0
                                        #     scr_addr_tableMinor: ; BYTES -----XXX ; do not need aligning
                                        #         defb &00,&08,&10,&18,&20,&28,&30,&38
                                        ##endif
                                        #
                                        # ;These are used by Arkostracker
                                        # ;There are two holes in the l ist, because the Volume registers are set relatively to the Frequency of the same Channel (+7, always).
                                        # ;Also, the Reg7 is passed as a register, so is not kept in the memory.
                                        # PLY_PSGRegistersArray:
                                        #     PLY_PSGReg0  db 0 ; +0
                                        #     PLY_PSGReg1  db 0 ; +1
                                        #     PLY_PSGReg2  db 0 ; +2
                                        #     PLY_PSGReg3  db 0 ; +3
                                        #     PLY_PSGReg4  db 0 ; +4
                                        #     PLY_PSGReg5  db 0 ; +5
                                        #     PLY_PSGReg6  db 0 ; +6
                                        #     PLY_PSGReg8  db 0 ; +7
                                        #                  db 0 ; +8
                                        #     PLY_PSGReg9  db 0 ; +9
                                        #                  db 0 ;+10
                                        #     PLY_PSGReg10 db 0 ;+11
                                        #     PLY_PSGReg11 db 0 ;+12
                                        #     PLY_PSGReg12 db 0 ;+13
                                        #     PLY_PSGReg13 db 0 ;+14
                                        # PLY_PSGRegistersArray_End:
                                        #
                                        # StarsOneByteDirs:
                                        #     defb &21,&09,&0C,&0F,&27,&3F,&3C,&39,&61,&49,&4c,&4f,&67,&7f,&7c,&79

Event_VectorArray:
       .word Event_OneObj                      # 0x00 0x00  0   0 evtSingleSprite
       .word NotImplemented                    # 0x01 0x02  2  16 # defw Event_MultiObj
       .word NotImplemented                    # 0x02 0x04  4  32 # defw Event_ObjColumn
       .word NotImplemented                    # 0x03 0x06  6  48 # defw Event_ObjStrip
       .word NotImplemented                    # 0x04 0x08  8  64 # defw Event_StarBust
       .word null                              # 0x05 0x0A 10  80
       .word null                              # 0x06 0x0C 12  96
       .word Event_CoreMultipleEventsAtOneTime # 0x07 0x0E 14 112
       .word Event_MoveSwitch                  # 0x08 0x10 16 128
       .word Event_SaveObjSettings             # 0x09 0x12 18 144
       .word Event_LoadObjSettings             # 0x0A 0x14 20 160
       .word NotImplemented                    # 0x0B 0x16 22 176 # defw Event_CoreSaveLoadSettings2
       .word null                              # 0x0C 0x18 24 192
       .word null                              # 0x0D 0x1A 26 208
       .word null                              # 0x0E 0x1C 28 224
       .word Event_CoreReprogram               # 0x0F 0x1E 30 240

Event_MoveVector:
       .word NotImplemented                    # 0x10 0x20      defw Event_MoveLifeSwitch_0000
       .word Event_SetProgram                  # 0x11 0x22  2 # defw Event_ProgramSwitch_0001
       .word NotImplemented                    # 0x12 0x24      defw Event_LifeSwitch_0010
       .word NotImplemented                    # 0x13 0x26      defw Event_MoveSwitch_0011
       .word Event_SetProgMoveLife             # 0x14 0x28  8 # mvSetProgMoveLife
       .word NotImplemented                    # 0x15 0x2A      defw Event_SpriteSwitch_0101
       .word Event_AddToBackground             # 0x16 0x2C 12 mvAddToBackground
       .word Event_AddToForeground             # 0x17 0x2E 14 mvAddToForeground
       .word Event_ChangeStreamTime            # 0x18 0x30 16   defw Event_ChangeStreamTime_1000
       .word NotImplemented                    # 0x19 0x32      defw Event_Call_1001
       .word NotImplemented                    # 0x1A 0x34 20   defw Event_LoadLastAddedObjectToAddress_1010
       .word NotImplemented                    # 0x1B 0x36      defw Event_ClearPowerups
       .word NotImplemented                    # 0x1C 0x38      defw Event_ChangeStreamSpeed_1100
       .word Event_SetSpriteSize               # 0x1D 0x3A 26 mvSetObjectSize
       .word Event_SetAnimator                 # 0x1E 0x3C 28 mvSetAnimator
       .word NotImplemented                    # 0x1F 0x3E      defw Event_CoreReprogram_AnimatorPointer

Event_ReprogramVector:
       .word Event_CoreReprogram_Palette       # 0x20 0x40 0
       .word null                              # 0x21 0x42    Obsolete - Reserver for Plus Palette
       .word NotImplemented                    # 0x22 0x44    defw Event_CoreReprogram_ObjectHitHandler
       .word NotImplemented                    # 0x23 0x46    defw Event_CoreReprogram_ShotToDeath
       .word NotImplemented                    # 0x24 0x48    defw Event_CoreReprogram_CustomMove1
       .word NotImplemented                    # 0x25 0x4A    defw Event_CoreReprogram_CustomMove2
       .word NotImplemented                    # 0x26 0x4C    defw Event_CoreReprogram_PowerupSprites
       .word NotImplemented                    # 0x27 0x4E    defw Event_CoreReprogram_CustomMove3
       .word NotImplemented                    # 0x28 0x50    defw Event_CoreReprogram_CustomMove4
       .word NotImplemented                    # 0x29 0x52    defw Event_CustomProgram1
       .word NotImplemented                    # 0x2A 0x54    defw Event_CustomProgram2
       .word NotImplemented                    # 0x2B 0x56    defw Event_CustomPlayerHitter
       .word NotImplemented                    # 0x2C 0x58    defw Event_CustomSmartBomb
       .word NotImplemented                    # 0x2D 0x5A    defw Event_ReprogramObjectBurstPosition
       .word NotImplemented                    # 0x2E 0x5C    defw Event_ObjectFullCustomMoves
       .word NotImplemented                    # 0x2F 0x5E    defw Event_SmartBombSpecial


                                        # read "..\SrcCPC\Akuyou_CPC_InterruptHandler.asm"
null:   RETURN
################################################################################
#                            End of aligned code                               #
################################################################################

                                        ## ifdef CPC320
       .include "virtual_screen_pos_320.s" #   read "../SrcCPC/Akuyou_CPC_VirtualScreenPos_320.asm"
                                        ## else
                                        ##     read "../SrcCPC/Akuyou_CPC_VirtualScreenPos_256.asm"
                                        ## endif
       .include "show_sprite.s"         # read "../SrcCPC/Akuyou_CPC_ShowSprite.asm"
                                        #
       .include "stararray.s"           # read "../SrcALL/Akuyou_Multiplatform_Stararray.asm"
       .include "stararray_add.s"       # read "../SrcALL/Akuyou_Multiplatform_Stararray_Add.asm"
       .include "do_moves.s"            # read "../SrcALL/Akuyou_Multiplatform_DoMoves.asm"
                                        #
                                        # ;;;;;;;;;;;;;;;;;;;;Input Driver;;;;;;;;;;;;;;;;;;;;;;;;
                                        # read "../SrcCPC/Akuyou_CPC_KeyboardDriver.asm"
                                        # ;;;;;;;;;;;;;;;;;;;;Disk Driver;;;;;;;;;;;;;;;;;;;;;;;;
       .include "disk_driver.s"         # read "../SrcCPC/Akuyou_CPC_DiskDriver.asm"
       .include "execute_bootstrap.s"   # read "../SrcCPC/Akuyou_CPC_ExecuteBootstrap.asm"
                                        # read "../SrcCPC/Akuyou_CPC_TextDriver.asm"
                                        #
       .include "sfx.s"                 # read "../SrcALL/Akuyou_Multiplatform_SFX.asm"
                                        #
       .include "compiled_sprite_viewer.s" # read "../SrcCPC/Akuyou_CPC_CompiledSpriteViewer.asm" ;also includes CLS
                                        # read "../SrcCPC/Akuyou_CPC_BankSwapper.asm"
                                        #
       .include "player_driver.s"       # read "../SrcALL/Akuyou_Multiplatform_PlayerDriver.asm"
       .include "timer.s"               # read "../SrcALL/Akuyou_Multiplatform_Timer.asm"
                                        #
                                        # read "../SrcCPC/Akuyou_CPC_Gradient.asm"
                                        #
       .include "object_driver.s"       # read "../SrcALL/Akuyou_Multiplatform_ObjectDriver.asm"
       .include "event_stream.s"        # read "../SrcALL/Akuyou_Multiplatform_EventStream.asm"
                                        # read "../SrcCPC/Akuyou_CPC_CpcPlus.asm"
                                        # read "../SrcALL/Akuyou_Multiplatform_ArkosTrackerLite.asm"
       .include "screen_memory.s"       # read "../SrcCPC/Akuyou_CPC_ScreenMemory.asm"
                                        # read "../SrcALL/Akuyou_Multiplatform_AkuCommandVectorArray.asm"
                                        #
                                        ## ifdef Debug_Monitor
                                        ## ;   read "../SrcALL/Multiplatform_Monitor.asm"
                                        ## ;   read "../SrcALL/Multiplatform_MonitorMemdump.asm"
                                        ## ;   read "../SrcALL/Multiplatform_MonitorSimple.asm"
                                        ## endif
NotImplemented:
       BR   .
       .asciz "Not implemented"
       .even
end: FileEndCore:

LevelStart:
        JMP  .
