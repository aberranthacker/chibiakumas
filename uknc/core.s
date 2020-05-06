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
       .global FileBeginCore
       .global FileEndCore
       .global KeyboardScanner_P1
       .global KeyboardScanner_P2
       .global LevelStart
       .global MultiplayConfig
       .global NULL
       .global ObjectArray_Redraw
       .global Player_Array
       .global Player_Array2
       .global Player_ScoreBytes
       .global Player_ScoreBytes2
       .global SavedSettings
       .global SavedSettings_Last
       .global SmartBombsReset
       .global StarArrayPointer
       .global Timer_UpdateTimer
#----------------------------------------------------------------------------}}}

       .include "macros.s"
       .include "core_defs.s"

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

Event_ReprogramVector:
       .word Event_CoreReprogram_Palette # 0 # TODO: implement this
       .word NULL # 2                   #     defw null;Event_CoreReprogram_PlusPalette ; 1      ; Obsolete - Reserver for Plus Palette
       .word NULL # 4                   #     defw Event_CoreReprogram_ObjectHitHandler ; 2
       .word NULL # 6                   #     defw Event_CoreReprogram_ShotToDeath      ; 3
       .word NULL # 8                   #     defw Event_CoreReprogram_CustomMove1      ; 4
       .word NULL #10                   #     defw Event_CoreReprogram_CustomMove2      ; 5
       .word NULL #12                   #     defw Event_CoreReprogram_PowerupSprites   ; 6
       .word NULL #14                   #     defw Event_CoreReprogram_CustomMove3      ; 7
       .word NULL #16                   #     defw Event_CoreReprogram_CustomMove4      ; 8
       .word NULL #18                   #     defw Event_CustomProgram1                 ; 9
       .word NULL #20                   #     defw Event_CustomProgram2                 ;10
       .word NULL #22                   #     defw Event_CustomPlayerHitter             ;11
       .word NULL #24                   #     defw Event_CustomSmartBomb                ;12
       .word NULL #26                   #     defw Event_ReprogramObjectBurstPosition   ;13
       .word NULL #28                   #     defw Event_ObjectFullCustomMoves          ;14
       .word NULL #30                   #     defw Event_SmartBombSpecial               ;15

Event_MoveVector: # 128+
       .word NULL                       #     defw Event_MoveLifeSwitch_0000               ; 0
       .word Event_ProgramSwitch        # 2 # defw Event_ProgramSwitch_0001                ; 1
       .word NULL                       #     defw Event_LifeSwitch_0010                   ; 2
       .word NULL                       #     defw Event_MoveSwitch_0011                   ; 3
       .word Event_ProgramMoveLifeSwitch# 8 # defw Event_ProgramMoveLifeSwitch_0100        ; 4
       .word NULL                       #     defw Event_SpriteSwitch_0101                 ; 5
       .word NULL                       #     defw Event_AddFront_0110                     ; 6
       .word NULL                       #     defw Event_AddBack_0111                      ; 7
       .word Event_ChangeStreamTime     #16   defw Event_ChangeStreamTime_1000             ; 8
       .word NULL                       #     defw Event_Call_1001                         ; 9
       .word NULL                       #     defw Event_LoadLastAddedObjectToAddress_1010 ;10
       .word NULL                       #     defw Event_ClearPowerups                     ;11
       .word NULL                       #     defw Event_ChangeStreamSpeed_1100            ;12
       .word NULL                       #     defw Event_SpriteSizeSwitch_1101             ;13
       .word Event_AnimatorSwitch       #28 # defw Event_AnimatorSwitch_1110               ;14
       .word NULL                       #     defw Event_CoreReprogram_AnimatorPointer     ;15
                                        #
                                        # ; These are the jump-pointes used by the raster color interrupt routine - to
                                        # ; try to save time only one byte is altered, so it must be byte aligned!
Event_VectorArray:
       .word Event_OneObj                      #   0  0 0x00
       .word NULL                              #  16  2 0x02 # defw Event_MultiObj
       .word NULL                              #  32  4 0x04 # defw Event_ObjColumn
       .word NULL                              #  48  6 0x06 # defw Event_ObjStrip
       .word NULL                              #  64  8 0x08 # defw Event_StarBust
       .word NULL                              #  80 10 0x0A
       .word NULL                              #  96 12 0x0C
       .word Event_CoreMultipleEventsAtOneTime # 112 14 0x0E
       .word Event_MoveSwitch                  # 128 16 0x10
       .word Event_CoreSaveLoadSettings        # 144 18 0x12
       .word NULL                              # 160 20 0x14
       .word NULL                              # 176 22 0x16 # defw Event_CoreSaveLoadSettings2
       .word NULL                              # 192 24 0x18
       .word NULL                              # 208 26 0x1A
       .word NULL                              # 224 28 0x1C
       .word Event_CoreReprogram               # 240 30 0x1E

                                        # read "..\SrcCPC\Akuyou_CPC_InterruptHandler.asm"
NULL:   RETURN
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
                                        # read "../SrcCPC/Akuyou_CPC_ExecuteBootstrap.asm"
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
end: FileEndCore:

LevelStart:
        JMP  .

