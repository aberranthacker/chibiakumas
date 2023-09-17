#-------------------------------------------------------------------------------
#---- Note that the PRESENCE of those variables is tested, NOT their values ----
 .equiv DebugMode, 1
#.equiv DebugSprite, 1
#.equiv ExtMemCore, 1
#.equiv TwoPlayersGame, 1
 .equiv PlayerInvincible, 1
#-------------------------------------------------------------------------------
.equiv MainMenu, 0x8000
.equiv Episode1_Intro, 0x0000
.equiv Level1, 0x0001
.equiv Level2, 0x0002
.equiv Level3, 0x0003
.equiv Level4, 0x0004
.equiv Level5, 0x0005

 .equiv StartOnLevel, MainMenu
#.equiv StartOnLevel, Episode1_Intro
#.equiv StartOnLevel, Level1
#.equiv StartOnLevel, Level2
#.equiv StartOnLevel, Level3
#.equiv StartOnLevel, Level4
#.equiv StartOnLevel, Level5

.if StartOnLevel == MainMenu
  .equiv ShowLoadingScreen, 1
.endif

.equiv CPU_PPUCommandArg, PPUCommandArg >> 1

# queued commands
.equiv PPU_LoadDiskFile,       0 * 2 # requires argument
.equiv PPU_SetPalette,         1 * 2 # requires argument
.equiv PPU_Print,              2 * 2 # requires argument
.equiv PPU_PrintAt,            3 * 2 # requires argument
.equiv PPU_ShowBossText.Init,  4 * 2 # requires argument
.equiv PPU_ShowBossText,       5 * 2
.equiv PPU_DebugPrint,         6 * 2 # requires argument
.equiv PPU_DebugPrintAt,       7 * 2 # requires argument
.equiv PPU_MusicStop,          8 * 2
.equiv PPU_TitleMusicRestart,  9 * 2
.equiv PPU_IntroMusicRestart, 10 * 2
.equiv PPU_LevelMusicRestart, 11 * 2
.equiv PPU_BossMusicRestart,  12 * 2
.equiv PPU_PlaySoundEffect1,  13 * 2
.equiv PPU_PlaySoundEffect2,  14 * 2
.equiv PPU_PlaySoundEffect3,  15 * 2
.equiv PPU_PlaySoundEffect4,  16 * 2
.equiv PPU_PlaySoundEffect5,  17 * 2
.equiv PPU_PlaySoundEffect6,  18 * 2
.equiv PPU_PlaySoundEffect7,  19 * 2
.equiv PPU_StartANewGame,     20 * 2
.equiv PPU_LevelStart,        21 * 2
.equiv PPU_LevelEnd,          22 * 2
.equiv PPU_DrawPlayerUI,      23 * 2
.equiv PPU_RestoreVblankInt,  24 * 2

.equiv PPU_LastJMPTableIndex, 24 * 2

.equiv PPU_SET_FB0_VISIBLE, 0
.equiv PPU_SET_FB1_VISIBLE, 1
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
.equiv KeyboardScanner_P1, 050 # 40
.equiv CPU_KeyboardScanner_P1, KeyboardScanner_P1 >> 1
.equiv KeyboardScanner_P2, 052 # 42
.equiv CPU_KeyboardScanner_P2, KeyboardScanner_P2 >> 1
.equiv PPUCommandArg, 054 # 44 command for PPU argument
# 056 available word are available
# 070, 072, 074, 076 another four available words
.equiv SavedSettingsStart, 0104 # 68

    .ifndef ExtMemCore
.equiv SP_RESET, 0600 # 384 0x0180 Initial stack pointer
    .else
.equiv SP_RESET, 0176000 # 64512 0xFC00 Initial stack pointer
    .endif

.equiv FB0, 0600 # 0384 0x0180
.equiv FB_GAP, FB0 + 16000
.equiv PlayerStarArrayPointer, FB_GAP # it fits nicely into the gap
.equiv FB1, FB_GAP + 384

# WARNING: update BOOTSTRAP_START in Makefile if you change the value below
.equiv BootstrapStart, 01000 # next address after bootsector
.equiv Ep1IntroSlidesStart, FB0 + 4096

.equiv GameVarsStart, FB1 + 16000
    .equiv ObjectArrayPointer,  GameVarsStart
    .equiv StarArrayPointer,    ObjectArrayPointer + ObjectArraySizeBytes
    .equiv Event_SavedSettings, StarArrayPointer + StarArraySizeBytes
.equiv GameVarsEnd,   Event_SavedSettings + Event_SavedSettingsSizeBytes

    .ifndef ExtMemCore
.equiv CoreStart, GameVarsEnd
.equiv Akuyou_LevelStart, 0x9D7E # 40318 0116576 # auto-generated during a build
    .else
.equiv CoreStart, 0160000
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
.equiv SLTAB, 0140000 # 32768 0x8000 # bank 0
.equiv BootstrapCopyAddr, 0100000 # banks 1 and 2
.equiv OffscreenAreaAddr, 0160000 # 49152 0xC000 # banks 0, 1 and 2
#-end of VRAM memory map--------------------------------------------------------
#-------------------------------------------------------------------------------
# Player_driver uses ROLB to check which keys were pressed.
# So if you change keymap here, modify player_driver code as well.
.equiv KEYMAP_PAUSE, 0x80
.equiv KEYMAP_F2,    0x40
.equiv KEYMAP_F1,    0x20
.equiv KEYMAP_LEFT,  0x10
.equiv KEYMAP_RIGHT, 0x08
.equiv KEYMAP_UP,    0x04
.equiv KEYMAP_DOWN,  0x02
.equiv KEYMAP_F3,    0x01
.equiv KEYMAP_ANY_FIRE, 0b01100001
#-------------------------------------------------------------------------------
.equiv chr1Up,   0x7B # 0173
.equiv chr2Up,   0x7C # 0174
.equiv chrSlab,  0x7D # 0175
.equiv chrCross, 0x7E # 0176
.equiv chrHeart, 0x7F # 0177
#-------------------------------------------------------------------------------
.equiv setCursorScalePalette, 0
.equiv cursorGraphic, 0x10 # 020 dummy parameter
.equiv scale640, 0x00
.equiv scale320, 0x10
.equiv scale160, 0x20
.equiv scale80,  0x30
    .ifdef RGBpalette
.equiv rgb, 0b000
.equiv rgB, 0b001
.equiv rGb, 0b010
.equiv rGB, 0b011
.equiv Rgb, 0b100
.equiv RgB, 0b101
.equiv RGb, 0b110
.equiv RGB, 0b111
    .else
.equiv rgb, 0b000
.equiv rgB, 0b001
.equiv rGb, 0b100
.equiv rGB, 0b101
.equiv Rgb, 0b010
.equiv RgB, 0b011
.equiv RGb, 0b110
.equiv RGB, 0b111
    .endif
#-------------------------------------------------------------------------------
.equiv setColors, 1
    .ifdef RGBpalette
.equiv BLACK,   0b000 # 0x0
.equiv BLUE,    0b001 # 0x1
.equiv GREEN,   0b010 # 0x2
.equiv CYAN,    0b011 # 0x3
.equiv RED,     0b100 # 0x4
.equiv MAGENTA, 0b101 # 0x5
.equiv YELLOW,  0b110 # 0x6
.equiv GRAY,    0b111 # 0x7
    .else
.equiv BLACK,   0b000 # 0x0
.equiv BLUE,    0b001 # 0x1
.equiv RED,     0b010 # 0x2
.equiv MAGENTA, 0b011 # 0x3
.equiv GREEN,   0b100 # 0x4
.equiv CYAN,    0b101 # 0x5
.equiv YELLOW,  0b110 # 0x6
.equiv GRAY,    0b111 # 0x7
    .endif
.equiv BR_BLUE,    010 | BLUE    # 0x9
.equiv BR_RED,     010 | RED     # 0xC
.equiv BR_MAGENTA, 010 | MAGENTA # 0xD
.equiv BR_GREEN,   010 | GREEN   # 0xA
.equiv BR_CYAN,    010 | CYAN    # 0xB
.equiv BR_YELLOW,  010 | YELLOW  # 0xE
.equiv WHITE,      010 | GRAY    # 0xF

.equiv Black,     BLACK      << 4 | BLACK
.equiv Blue,      BLUE       << 4 | BLUE
.equiv Green,     GREEN      << 4 | GREEN
.equiv Cyan,      CYAN       << 4 | CYAN
.equiv Red,       RED        << 4 | RED
.equiv Magenta,   MAGENTA    << 4 | MAGENTA
.equiv Yellow,    YELLOW     << 4 | YELLOW
.equiv Gray,      GRAY       << 4 | GRAY
.equiv brBlue,    BR_BLUE    << 4 | BR_BLUE
.equiv brGreen,   BR_GREEN   << 4 | BR_GREEN
.equiv brCyan,    BR_CYAN    << 4 | BR_CYAN
.equiv brRed,     BR_RED     << 4 | BR_RED
.equiv brMagenta, BR_MAGENTA << 4 | BR_MAGENTA
.equiv brYellow,  BR_YELLOW  << 4 | BR_YELLOW
.equiv White,     WHITE      << 4 | WHITE

.equiv setOffscreenColors, 2

.equiv untilLine, -1 << 8
.equiv untilEndOfScreen, 201
.equiv endOfScreen, 201
#-------------------------------------------------------------------------------
.equiv COIN_COST, 4

.equiv SPR_TURBO,    0
.equiv SPR_DOUBLE,   1<<1
.equiv SPR_PSET,     1<<2
.equiv SPR_HAS_MASK, 1<<3
#-------------------------------------------------------------------------------
.equiv NOP_OPCODE, 000240
.equiv INC_R0_OPCODE, 0005200
.equiv DECB_R3_OPCODE, 0105303
.equiv MOVB_R3_R3_OPCODE, 0110303

# Show Boss Text persistance counter initial value
.equiv SBT_PersistanceCounterReset, 10
