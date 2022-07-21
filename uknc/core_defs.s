#-------------------------------------------------------------------------------
# Note that the PRESENCE of those variables is tested, NOT their values. -------
#.equiv DebugMode, 1
#.equiv DebugSprite, 1
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

.equiv CPU_PPUCommandArg, PPUCommandArg >> 1

.equiv PPU_NOP,                0
.equiv PPU_Finalize,           2
.equiv PPU_SingleProcess,      4
.equiv PPU_MultiProcess,       6
.equiv PPU_SetPalette,         8
.equiv PPU_Print,             10
.equiv PPU_PrintAt,           12
.equiv PPU_LoadText,          14
.equiv PPU_ShowBossText,      16
.equiv PPU_LoadMusic,         18
.equiv PPU_MusicRestart,      20
.equiv PPU_MusicStop,         22
.equiv PPU_DebugPrint,        24
.equiv PPU_DebugPrintAt,      26
.equiv PPU_TitleMusicRestart, 28
.equiv PPU_IntroMusicRestart, 30
.equiv PPU_LevelMusicRestart, 32
.equiv PPU_BossMusicRestart,  34
.equiv PPU_PlaySoundEffect1,  36
.equiv PPU_PlaySoundEffect2,  38
.equiv PPU_PlaySoundEffect3,  40
.equiv PPU_PlaySoundEffect4,  42
.equiv PPU_PlaySoundEffect5,  44
.equiv PPU_PlaySoundEffect6,  46
.equiv PPU_PlaySoundEffect7,  48
.equiv PPU_StartANewGame,     50
.equiv PPU_LevelEnd,          52
.equiv PPU_DrawPlayerUI,      54

.equiv PPU_LastJMPTableIndex, 54
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

.equiv SPReset, 0600 # 3384 0x180 Initial stack pointer
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
.equiv Akuyou_LevelStart, 0x9E44 # 40516 0117104 # auto-generated during a build
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
.equiv PPU_UserRamEnd,   0077771 # 32761 0x7FF9
.equiv PPU_UserProcessMetadataAddr, 0077772 # 32762 0x7FFA
#-end of PPU memory map---------------------------------------------------------
#-------------------------------------------------------------------------------
# VRAM memory map --------------------------------------------------------------
.equiv SLTAB, 0100000 # 32768 0x8000 # bank 0
.equiv BootstrapCopyAddr, 0100000 # banks 1 and 2
.equiv OffscreenAreaAddr, 0160000 # 49152 0xC000 # banks 0, 1 and 2
#-end of VRAM memory map--------------------------------------------------------
#-------------------------------------------------------------------------------
.equiv Keymap_Pause, 0x80
.equiv Keymap_F2,    0x40
.equiv Keymap_F1,    0x20
.equiv Keymap_Left,  0x10
.equiv Keymap_Right, 0x08
.equiv Keymap_Up,    0x04
.equiv Keymap_Down,  0x02
.equiv Keymap_F3,    0x01
.equiv Keymap_AnyFire, 0b01100001
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
.equiv COIN_COST, 4
