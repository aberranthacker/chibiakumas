AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld
# 2.31.1

.SUFFIXES:
.SUFFIXES: .s .o

# --just-symbols= -R include only symbols from the file
# --print-map -M
# --strip-all -s

common = hwdefs.s core_defs.s macros.s

build/AKU.SAV : build/bootstrap.o \
		build/core.o \
		build/CORE.BIN \
		build/PPU.BIN \
		build/LOADIN.SCR \
		build/LVL00.BIN \
		linker_scripts/bootstrap.cmd
	$(LD) -T linker_scripts/bootstrap.cmd -R build/core.o -R build/ppu.o -R build/level-00_menu.o -s
	chmod -x build/AKU.SAV
	ruby build_tools/add_CCB.rb build/AKU.SAV

build/CORE.BIN : build/core.o
	$(LD) build/core.o -o build/core.out -s
	ruby build_tools/aout2sav.rb build/core.out -b -s -o build/CORE.BIN

build/PPU.BIN : build/ppu.o \
		build/core.o
	$(LD) -T linker_scripts/ppu.cmd -R build/core.o -s
	ruby build_tools/aout2sav.rb build/ppu.out -b -s -o build/PPU.BIN

build/LOADIN.SCR : ../ResCPC/Old/T38-SC1.D01 \
		   build_tools/convert_bitmap.rb
	ruby build_tools/convert_bitmap.rb

build/LVL00.BIN : build/core.o \
                  build/level-00_menu.o
	$(LD) build/level-00_menu.o -R build/core.o -o build/level-00_menu.out -s
	ruby build_tools/aout2sav.rb build/level-00_menu.out -b -s -o build/LVL00.BIN

build/bootstrap.o : bootstrap.s \
		    ppucmd.s $(common)
	ruby build_tools/preprocessor.rb -i bootstrap.s
	$(AS) -al bootstrap.s -o build/bootstrap.o

build/core.o : core.s \
	       disk_driver.s \
	       do_moves.s \
	       event_stream.s \
	       object_driver.s \
	       player_driver.s \
	       show_sprite.s \
	       sfx.s \
	       stararray.s \
	       stararray_add.s \
	       timer.s \
	       virtual_screen_pos_320.s \
	       $(common)
	$(AS) core.s -al -o build/core.o
	build_tools/level_start_update.rb

build/ppu.o : ppu.s \
	      cga8x8b.raw \
	      $(common)
	$(AS) ppu.s -o build/ppu.o
build/level-00_menu.o : core_defs.s \
                        level-00_menu.s
	$(AS) level-00_menu.s -o build/level-00_menu.o

clean :
	rm -f build/*.o build/*.out build/*.SAV build/*.BIN
