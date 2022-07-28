FILES = [
  'build/bootsector.bin',
  'build/bootstrap.bin',
  'build/ppu_module.bin',
  'build/loading_screen.bin',
  'build/saved_settings.bin',
  'build/core.bin',
  'build/ep1_intro.bin',
  'build/ep1_intro_slides.bin',
  'build/level_00.bin',
  'build/level_01.bin',
  'build/level_02.bin'
]

FILLER = '#'.ord

SECTORS_IN_TOTAL = 10 * 80 * 2
BYTES_IN_TOTAL = SECTORS_IN_TOTAL * 512
