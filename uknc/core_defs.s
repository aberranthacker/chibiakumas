.equiv DebugMode, 1
.equiv ShowLoadingScreen, 1

.equiv PPU_UserRamStart, 0x27B6 # 023666 10166
.equiv PPU_UserRamSize,  0x5844 # 054104 22596
.equiv PPU_UserRamSizeWords, PPU_UserRamSize >> 1 # 0x2C22 026042 11298
.equiv PPU_PPUCommand,    PPUCommand >> 1
.equiv PPU_PPUCommandArg, PPUCommandArg >> 1

.equiv FB0, 384 # 0600 0x0180
.equiv FB_gap, FB0 + 16000
.equiv FB1, FB_gap + 384

.equiv PPU_NOP,            2 #  1
.equiv PPU_Finalize,       4 #  2
.equiv PPU_SingleProcess,  6 #  3
.equiv PPU_MultiProcess,   8 #  4
.equiv PPU_SetPalette,    10 #  5
.equiv PPU_Print,         12 #  6
.equiv PPU_PrintAt,       14 #  7

.equiv BootstrapStart,  512
.equiv Akuyou_GameVarsStart, FB1 + 16000

.equiv StarArraySize, 256
.equiv ObjectArraySize, 60
.equiv PlayerStarArraySize, 128
.equiv GameVarsArraysSize, StarArraySize * 4 + ObjectArraySize * 8 + PlayerStarArraySize * 4 + 15*8

.equiv Akuyou_LevelStart, 0x926C # 37484 0111154 # auto-generated during a build
.equiv LevelSprites, Akuyou_LevelStart + 4

.equiv SPReset,       0157772 # Initial stack pointer
.equiv PPUCommand,    0157774 # command for PPU code
.equiv PPUCommandArg, 0157776 # command for PPU argument
# 0xE000 57344 0160000 end of ram

.equiv TextScreen_MaxX, 39
.equiv TextScreen_MinX, 0
.equiv TextScreen_MaxY, 24
.equiv TextScreen_MinY, 0

# -Player 2's data starts XX bytes after player so you can use IY+XX+1 to get
# a var from player 2 without changing IY
.equiv Akuyou_PlayerSeparator, 16

.equiv Keymap_D,     0x01
.equiv Keymap_U,     0x02
.equiv Keymap_R,     0x04
.equiv Keymap_L,     0x08
.equiv Keymap_F1,    0x10
.equiv Keymap_F2,    0x20
.equiv Keymap_F3,    0x40
.equiv Keymap_Pause, 0x80
.equiv Keymap_AnyFire, 0b01110000


# PlusSprite_ExtBank equ &C7
# Akuyou_PlayerSpritePos equ &3800
# Akuyou_PlusSpritesPos  equ &3800
#
# Akuyou_Music_Bank  equ &C0
# Akuyou_MusicPos    equ &50   ;Akuyou only allows &400 bytes for music
# Akuyou_MusicPosAlt equ &7B00 ;When music switches during boss battle, store the alternate here
# Akuyou_SfxPos      equ &3000 ;Akuyou only allows &100 bytes for SFX
#
# Akuyou_LevelStart      equ &4000 ;+3-Bank 0
# Akuyou_LevelStart_Bank equ &C0
#
# LevelData128kpos      equ &4000  ;+3-Bank 1
# LevelData128kpos_Bank equ &C7
#
# LevelData128kpos_C      equ &4000 ;+3-Bank 1
# LevelData128kpos_C_Bank equ &C4
#
# LevelData128kpos_D         equ &6000 ;+3-Bank 1
# LevelData128kpos_D_OneByte equ &60
# LevelData128kpos_D_Bank    equ &C4
#
# CSprite_SetDisk  equ 2*3
# CSprite_Continue equ 1*3
# CSprite_Loading  equ 0*3
#
# Font_Membank        equ &C6
# Font_RegularSizePos equ &7000
# Font_SmallSizePos   equ &7800
#
#-------------------------------------------------------------------------------
# Platform Specific Core commands
#-------------------------------------------------------------------------------
.equiv Akuyou_RasterColors_SetPointers, RasterColors_SetPointers # Set the memory location of the CPC raster switching data
.equiv Akuyou_BankSwitch_C0_BankCopy, BankSwitch_C0_BankCopy # Copy data between banks on CPC (banks numbered C0-C7 etc)
.equiv Akuyou_BankSwitch_C0, BankSwitch_C0 # Switch Banks for a moment (Disable interrupts first!)
.equiv Akuyou_BankSwitch_C0_Reset, BankSwitch_C0_Reset # Reset to bank that was made current
.equiv Akuyou_BankSwitch_C0_SetCurrent, BankSwitch_C0_SetCurrent # set a bank as 'Current'
#-------------------------------------------------------------------------------
.equiv Akuyou_RasterColors_Reset, RasterColors_Reset # Reset raster colors
.equiv Akuyou_RasterColors_Disable, RasterColors_Disable # Disable raster flips
#-------------------------------------------------------------------------------
.equiv Akuyou_CPCGPU_CommandNum, CPCGPU_CommandNum # Run a graphics command from the CPC Graphics vector array
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Core Jumpblock definitions
#-------------------------------------------------------------------------------
# Execute a bootstrap command
.equiv Akuyou_ExecuteBootStrap, ExecuteBootStrap
# Show a sprite
.equiv Akuyou_ShowSprite, ShowSprite
# Set the memory pointer of the sprite to be shown.
.equiv Akuyou_ShowSprite_SetBankAddr, ShowSprite_SetBankAddr
# show a 'compiled' sprite (Fullscreen images for loading/insert disk etc)
.equiv Akuyou_ShowCompiledSprite, ShowCompiledSprite
# Get the current 'XY' location of the last drawn/about to be drawn sprite
.equiv Akuyou_GetSpriteXY, GetSpriteXY
# Disable sprite clipping - used for odd shaped sprites in boss battle
.equiv Akuyou_ShowSpriteReconfigureEnableDisable, ShowSpriteReconfigureEnableDisable
# Eventstream usually processes every few ticks, we can ;force an immediate update if we need to
.equiv Akuyou_Event_Stream_ForceNow, Event_Stream_ForceNow
# Define the move direction of objects set to background
.equiv Akuyou_Background_SetScroll, DoMovesBackground_SetScroll
# Define gradient scroll direction
.equiv Akuyou_Background_GradientScroll, Background_GradientScroll
# Draw background gradient
.equiv Akuyou_Background_Gradient, Background_Gradient
#-------------------------------------------------------------------------------
.equiv Akuyou_Music_Init, PLY_Init   # Arkostracker Init Music
.equiv Akuyou_Music_Stop, PLY_Stop   # Arkostracker Stop Music
.equiv Akuyou_Music_Play, PLY_Play   # Arkostracker Play Music
.equiv Akuyou_Music_Restart, Music_Restart # Restart music
.equiv Akuyou_Sfx_Init, PLY_SFX_Init # Arkostracker Init SFX
.equiv Akuyou_Sfx_Play, PLY_SFX_Play # Arkostracker Play SFX
.equiv Akuyou_PlaySfx, SFX_PlaySfx   # Queue an SFX
#-------------------------------------------------------------------------------
.equiv Akuyou_RasterColors_MusicOnly, RasterColors_MusicOnly # Disable raster flips, but keep music
.equiv Akuyou_RasterColors_StopMusic, RasterColors_StopMusic # Stop music
#-------------------------------------------------------------------------------
.equiv Akuyou_Interrupt_Init,    RasterColors_Init # Enable our interrupt handler
.equiv Akuyou_RasterColors_Init, RasterColors_Init # Init raster color settings
#-------------------------------------------------------------------------------
.equiv Akuyou_RasterColors_Blackout, RasterColors_Blackout # Set all CPC colors to black
.equiv Akuyou_RasterColors_DefaultSafe, RasterColors_DefaultSafe # Reset CPC colors to black-purple-cyan-white
#-------------------------------------------------------------------------------
.equiv Akuyou_Bankswapper_CallHL, BankSwitch_C0_CallHL # Call HL after setting a different bank
#-------------------------------------------------------------------------------
.equiv Akuyou_ObjectArray_Redraw, objectArray_Redraw # Redraw objects
#-------------------------------------------------------------------------------
.equiv Akuyou_Player_Handler, Player_Handler # Draw players, handle input etc
.equiv AkuYou_Player_DrawUI, Player_DrawUI # Draw icons and scores
#-------------------------------------------------------------------------------
.equiv AkuYou_Player_ReadControls, Player_ReadControlsClassic # Read the key/joy input
#-------------------------------------------------------------------------------
.equiv AkuYou_Player_GetPlayerVars, Player_GetPlayerVars # Get the start of the player settings memory
.equiv Akuyou_Player_GetHighscore,  Player_GetHighscore # Get the current highscore
#-------------------------------------------------------------------------------
.equiv AkuYou_Player_Hit_Injure_1, Player_Hit_Injure_1 # Player 1 has been hurt (For omega array)
.equiv AkuYou_Player_Hit_Injure_2, Player_Hit_Injure_2 # Player 2 has been hurt (for omega array)
#-------------------------------------------------------------------------------
.equiv Akuyou_StarArray_Redraw, StarArray_Redraw # Redraw the enemy bullets (also redraws particles on V9990)
.equiv AkuYou_Player_StarArray_Redraw, Player_StarArray_Redraw # Redraw the player bullets
.equiv Akuyou_SetStarArrayPalette, SetStarArrayPalette # set the color of the enemy stars (used in EP2 for level 4 boss)
#-------------------------------------------------------------------------------
.equiv Akuyou_FireStar, ObjectProgram_HyperFire # Fire a star
.equiv Akuyou_DoSmartBombCall, DoSmartBombCall # Act as if the player has used a smartbomb, This occurs at the end of a level to kill remaining enemies
.equiv AkuYou_Event_StreamInit, Event_StreamInit # Init the eventstream
.equiv Akuyou_EventStream_Process, Event_Stream # Process level events
.equiv Akuyou_GetLevelTime, GetLevelTime # Get the current level tick
.equiv Akuyou_SetLevelTime, SetLevelTime # set the current level tick
#-------------------------------------------------------------------------------
.equiv Akuyou_LoadDiscSector, LoadDiscSector # Load a disk file
.equiv Akuyou_LoadDiscSectorZ, LoadDiscSectorZ # Load and decompress a diskfile
#-------------------------------------------------------------------------------
.equiv Akuyou_Firmware_Kill, Firmware_Kill # Disable Remove the firmware from memory (when disk loading is finished)
.equiv Akuyou_Firmware_Restore, Firmware_Restore # Restore the firmware
#-------------------------------------------------------------------------------
.equiv Akuyou_SpriteBank_Font, SpriteBank_Font # Set font (1=small 2=normal)
#-------------------------------------------------------------------------------
.equiv Akuyou_DrawText_LocateSprite, DrawText_LocateSprite # Routine that moves 'cursor' to a screen location (40x25 virtual screen)
.equiv Akuyou_DrawText_LocateSprite4CR, DrawText_LocateSprite4CR # Same as above, however this one also allows for CarridgeReturn
.equiv Akuyou_DrawText_CharSprite, DrawText_CharSprite # Draw a single character
.equiv Akuyou_DrawText_PrintString, DrawText_PrintString # Draw a string (Char+&80 terminated for normal language, &FF terminated for other languages)
.equiv Akuyou_DrawText_Decimal, DrawText_Decimal # Print decimal numbers
#-------------------------------------------------------------------------------
.equiv Akuyou_Object_DecreaseLifeShot, Object_DecreaseLifeShot # The normal hit-handler for objects - this is here for use if we have overriden the main hit handler
#-------------------------------------------------------------------------------
.equiv Akuyou_ScreenBuffer_Init, ScreenBuffer_Init # Start the screenbuffer for flipping
.equiv Akuyou_ScreenBuffer_Flip, ScreenBuffer_Flip # Flip the active and visible screen
.equiv Akuyou_ScreenBuffer_Reset, ScreenBuffer_Reset # Reset the screen buffers (active and visible are default)
.equiv Akuyou_ScreenBuffer_Alt, ScreenBuffer_Alt # Allows overriding of screen buffer
#-------------------------------------------------------------------------------
.equiv Akuyou_ScreenBuffer_GetNxtLin, GetNxtLin
.equiv Akuyou_get_scr_addr_table, get_scr_addr_table # Get the address of the screen memory lookuptable
.equiv Akuyou_GetMemPos, GetMemPos # Get screen memory position  from row col (CPC/ZX)
.equiv Akuyou_ScreenBuffer_GetActiveScreen, ScreenBuffer_GetActiveScreen # Get screenbuffer mem origin (C0/80 on CPC , 40/C0 on ZX , 0/1 on MSX)
.equiv Akuyou_CLS, CLS # Clear the screen (Slow)
#-------------------------------------------------------------------------------
.equiv Akuyou_Timer_UpdateTimer, Timer_UpdateTimer # Process Timer update
.equiv Akuyou_Timer_SetCurrentTick, Timer_SetCurrentTick # Set time
.equiv Akuyou_Timer_GetTimer, Timer_GetTimer # Get current game time
#-------------------------------------------------------------------------------
.equiv Akuyou_ObjectProgram_SpriteBankSwitch, ObjectProgram_SpriteBankSwitch # switch spritebank 0-3)
#-------------------------------------------------------------------------------
.equiv Akuyou_DoMoves, DoMoves # process moves using standard processor
#-------------------------------------------------------------------------------
.equiv Akuyou_DoObjectSpawn, DoObjectSpawn # Spawn an object
#-------------------------------------------------------------------------------
.equiv Akuyou_Plus_HideSprites, null #  Hide CPC plus sprite
#-------------------------------------------------------------------------------
.equiv Akuyou_Aku_CommandNum, Aku_CommandNum # Core Vector array - for rare Core commands
#-------------------------------------------------------------------------------
# Levels contain small amounts of executable code
# .equiv LevelData_StartLevel, Akuyou_LevelStart+&3ff0 # Start the level with INIT
#-------------------------------------------------------------------------------
# Special one off used for a cheap joke!
.equiv ChibiAkumasEp2_Player2Start, Player2Start
