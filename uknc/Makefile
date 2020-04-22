AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld
# 2.31.1

.SUFFIXES:
.SUFFIXES: .s .o

# --just-symbols= -R include only symbols from the file
# --print-map -M
# --strip-all -s

common = core_defs.s event_stream_definitions.s hwdefs.s macros.s 

build/chibiakumas.dsk : build/bootsector.bin \
                        build/bootstrap.bin \
                        build/ppu_module.bin \
                        build/loading_screen.bin \
                        build/core.bin \
                        build/level-00.bin
	build_tools/build_dsk.rb

build/bootsector.bin : build/bootsector.o \
                       build/bootstrap.o
	$(LD) -T linker_scripts/bootsector.cmd -R build/bootstrap.o -s
	chmod -x build/bootsector.bin

build/bootstrap.bin : build/bootstrap.o \
                      build/ppu.o \
                      build/loading_screen.bin \
                      build/core.o \
                      build/level-00_menu.o
	$(LD) -T linker_scripts/bootstrap.cmd -R build/core.o -R build/ppu.o -R build/level-00_menu.o -s
	ruby build_tools/aout2sav.rb build/bootstrap.out -b -s -o build/bootstrap.bin

build/ppu_module.bin : build/ppu.o \
                       build/core.o
	$(LD) -T linker_scripts/ppu.cmd -R build/core.o -s
	ruby build_tools/aout2sav.rb build/ppu.out -b -s -o build/ppu_module.bin

build/core.bin : build/core.o
	$(LD) build/core.o -o build/core.out -s
	ruby build_tools/aout2sav.rb build/core.out -b -s -o build/core.bin

build/loading_screen.bin : ../ResCPC/Old/T38-SC1.D01
	ruby build_tools/convert_bitmap.rb

build/level-00.bin : build/core.o \
                     build/level-00_menu.o
	$(LD) build/level-00_menu.o -R build/core.o -o build/level-00_menu.out -s
	ruby build_tools/aout2sav.rb build/level-00_menu.out -b -s -o build/level-00.bin

build/bootsector.o : $(common) \
                     bootsector.s
	$(AS) -al bootsector.s -o build/bootsector.o

build/bootstrap.o : $(common) \
                    bootstrap.s \
                    ppucmd.s
	# ruby build_tools/preprocessor.rb -i bootstrap.s
	$(AS) -al bootstrap.s -o build/bootstrap.o

build/core.o : $(common) \
               core.s \
               compiled_sprite_viewer.s \
               disk_driver.s \
               do_moves.s \
               event_stream.s \
               object_driver.s \
               player_driver.s \
               screen_memory.s \
               show_sprite.s \
               sfx.s \
               stararray.s \
               stararray_add.s \
               timer.s \
               virtual_screen_pos_320.s
	$(AS) core.s -al -o build/core.o
	build_tools/level_start_update.rb

build/ppu.o : $(common) \
              ppu.s \
              resources/font.raw \
              resources/cga8x8b.raw
	$(AS) ppu.s -al -o build/ppu.o

build/level-00_menu.o : $(common) \
                        level-00_menu.s \
                        resources/titletex.spr
	$(AS) -al level-00_menu.s -o build/level-00_menu.o

#resources/font.raw : ../Aku/Sprites/T07-SC1.SPR \
#                     build_tools/spr_cpc_to_uknc.rb
#	build_tools/spr_cpc_to_uknc.rb ../Aku/Sprites/T07-SC1.SPR --font -o resources/font.raw

resources/font.raw : ../ResCPC/font.bin \
                     build_tools/spr_cpc_to_uknc.rb
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/font.bin --font -o resources/font.raw

resources/cga8x8b.raw : resources/cga8x8b.bmp.raw \
                         build_tools/prepare_font.rb
	ruby build_tools/prepare_font.rb resources/cga8x8b.bmp.raw

resources/titletex.spr : ../Aku/Sprites/TITLETEX.SPR
	build_tools/spr_cpc_to_uknc.rb ../Aku/Sprites/TITLETEX.SPR -o resources/titletex.spr

clean :
	rm -f build/*
