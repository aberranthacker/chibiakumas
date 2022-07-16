#-------------------------------------------------------------------------------
# Note that the PRESENCE of those variables is tested, NOT their values. -------
 .equiv DebugMode, 1
#.equiv DebugSprite, 1
 .equiv SkipPSGSend, 1
#.equiv ExtMemCore, 1 # do `make clean` after commenting/uncommenting this line
#.equiv TwoPlayersGame, 1
#-------------------------------------------------------------------------------
.equiv MainMenu, 0x8000
.equiv Episode1_Intro, 0x0000
.equiv Level1, 0x0001
.equiv Level2, 0x0002

#.equiv StartOnLevel, MainMenu
#.equiv StartOnLevel, Episode1_Intro
 .equiv StartOnLevel, Level1
#.equiv StartOnLevel, Level2

.if StartOnLevel == MainMenu
  .equiv ShowLoadingScreen, 1
.endif

.equiv PPU_PPUCommandArg, PPUCommandArg >> 1

.equiv PPU_NOP,           2
.equiv PPU_Finalize,      4
.equiv PPU_SingleProcess, 6
.equiv PPU_MultiProcess,  8
.equiv PPU_SetPalette,   10
.equiv PPU_Print,        12
.equiv PPU_PrintAt,      14
.equiv PPU_FlipFB,       16
.equiv PPU_ShowFB0,      18
.equiv PPU_ShowFB1,      20
.equiv PPU_LoadText,     22
.equiv PPU_ShowBossText, 24
.equiv PPU_LoadMusic,    26
.equiv PPU_MusicRestart, 28
.equiv PPU_MusicStop,    30
.equiv PPU_DebugPrint,   32
.equiv PPU_DebugPrintAt, 34
.equiv PPU_TitleMusicRestart, 36
.equiv PPU_IntroMusicRestart, 38
.equiv PPU_LevelMusicRestart, 40
.equiv PPU_BossMusicRestart,  42
.equiv PPU_PlaySoundEffect1,  44
.equiv PPU_PlaySoundEffect2,  46
.equiv PPU_PlaySoundEffect3,  48
.equiv PPU_PlaySoundEffect4,  50
.equiv PPU_PlaySoundEffect5,  52
.equiv PPU_PlaySoundEffect6,  54
.equiv PPU_PlaySoundEffect7,  56

.equiv PPU_LastJMPTableIndex, 56
#-------------------------------------------------------------------------------
.equiv ExtMemSizeBytes, 7168

.equiv ObjectArraySize, 60
.equiv ObjectArrayElementSize, 8
.equiv ObjectArraySizeBytes, ObjectArraySize * ObjectArrayElementSize

.equiv StarArraySize, 256
.equiv StarArrayElementSize, 3
.equiv StarArraySizeBytes, StarArraySize * StarArrayElementSize

# WARNING: if you want to change PlayerArray size
# check if it fits into a gap between framebuffers (CPU memory map section)
# the gap size is 384 bytes
.equiv PlayerStarArraySize, 128
.equiv PlayerStarArrayElementSize, 3
.equiv PlayerStarArraySizeBytes, PlayerStarArraySize * PlayerStarArrayElementSize

.equiv Event_SavedSettingsSize, 15
.equiv Event_SavedSettingsElementSize, 8
.equiv Event_SavedSettingsSizeBytes, Event_SavedSettingsSize * Event_SavedSettingsElementSize

# used to clean up game vars between level
.equiv GameVarsArraySize, ObjectArraySizeBytes + StarArraySizeBytes + Event_SavedSettingsSizeBytes
.equiv GameVarsArraySizeWords, GameVarsArraySize >> 1
#-------------------------------------------------------------------------------
# CPU memory map ---------------------------------------------------------------
# 040 dummy interrupt handler, see bootsector
.equiv KeyboardScanner_P1, 042 # 34 0x22
.equiv KeyboardScanner_P2, 044 # 36 0x24
.equiv PPUCommandArg, 046 # 38 0x26 command for PPU argument
# 050, 052, 054, 056 four words are available

.equiv SPReset, 0600 # 3382 0x17E Initial stack pointer
.equiv FB0, 0600 # 0384 0x0180
.equiv FB_gap, FB0 + 16000
.equiv PlayerStarArrayPointer, FB_gap # it fits nicely into the gap
.equiv FB1, FB_gap + 384

.equiv BootstrapStart,  FB0
.equiv Ep1IntroSlidesStart, FB0 + 4096

.equiv GameVarsStart, FB1 + 16000
    .equiv ObjectArrayPointer,  GameVarsStart
    .equiv StarArrayPointer,    ObjectArrayPointer + ObjectArraySizeBytes
    .equiv Event_SavedSettings, StarArrayPointer + StarArraySizeBytes
.equiv GameVarsEnd,   Event_SavedSettings + Event_SavedSettingsSizeBytes

    .ifdef ExtMemCore
.equiv CoreStart, 0160000
    .else
.equiv CoreStart, GameVarsEnd
    .endif

    .ifndef ExtMemCore
.equiv Akuyou_LevelStart, 0xA04E # 41038 0120116 # auto-generated during a build
    .else
.equiv Akuyou_LevelStart, GameVarsEnd
    .endif

.equiv LevelSprites, Akuyou_LevelStart + 4
# 0160000 57344 0xE000 end of RAM ----------------------------------------------
#-------------------------------------------------------------------------------
.equiv PPU_UserRamSize,  0054104 # 22596 0x5844
.equiv PPU_UserRamSizeWords, PPU_UserRamSize >> 1 # 0026042 11298 0x2C22
#-------------------------------------------------------------------------------
# PPU memory map ---------------------------------------------------------------
.equiv PPU_UserRamStart, 0023666 # 10166 0x27B6

.equiv PPU_StrBuffer, 0047562 # 20338 0x4F72 # auto-generated during a build
#.equiv PPU_MusicBuffer, PPU_StrBuffer + 320

.equiv PPU_UserProcessMetadataAddr, 0077772 # 32762 0x7FFA

.equiv SLTAB, 0100000# 32768 0x8000
.equiv OffscreenAreaAddr, 0140000 # 49152 0xC000
#-end of PPU memory map---------------------------------------------------------
.equiv Keymap_Down,  0x01
.equiv Keymap_Up,    0x02
.equiv Keymap_Right, 0x04
.equiv Keymap_Left,  0x08
.equiv Keymap_F1,    0x10
.equiv Keymap_F2,    0x20
.equiv Keymap_F3,    0x40
.equiv Keymap_Pause, 0x80
.equiv Keymap_AnyFire, 0b01110000
#-------------------------------------------------------------------------------
.equiv chr1Up,   0x7B # 0173
.equiv chr2Up,   0x7C # 0174
.equiv chrSlab,  0x7D # 0175
.equiv chrCross, 0x7E # 0176
.equiv chrHeart, 0x7F # 0177
#-------------------------------------------------------------------------------
.equiv setCursorScalePalette, 0
.equiv cursorGraphic, 0x10 # dummy parameter
.equiv scale640, 0x00
.equiv scale320, 0x10
.equiv scale160, 0x20
.equiv scale80,  0x30
#-------------------------------------------------------------------------------
.equiv setColors, 1
.equiv Black,     0x00
.equiv Blue,      0x11
.equiv Green,     0x22
.equiv Cyan,      0x33
.equiv Red,       0x44
.equiv Magenta,   0x55
.equiv Yellow,    0x66
.equiv Gray,      0x77
.equiv brBlue,    0x99
.equiv brGreen,   0xAA
.equiv brCyan,    0xBB
.equiv brRed,     0xCC
.equiv brMagenta, 0xDD
.equiv brYellow,  0xEE
.equiv White,     0xFF

.equiv untilLine, -1 << 8
.equiv untilEndOfScreen, 201
.equiv endOfScreen, 201
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
.equiv AkuYou_Event_StreamInit, EventStream_Init # Init the eventstream
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
