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
                        build/level-00.bin \
                        build/ep1-intro.bin \
                        build/ep1-intro-slides.bin
	build_tools/build_dsk.rb

build/bootsector.bin : build/bootsector.o \
                       build/bootstrap.o
	$(LD) -T linker_scripts/bootsector.cmd -R build/bootstrap.o -s
	chmod -x build/bootsector.bin

build/bootstrap.bin : build/bootstrap.o \
                      build/ppu.o \
                      build/loading_screen.bin \
                      build/core.o \
                      build/level-00_menu.o \
                      build/ep1-intro.o \
                      build/ep1-intro-slides.o
	$(LD) -s -T linker_scripts/bootstrap.cmd \
	    -R build/core.o \
	    -R build/ppu.o \
	    -R build/level-00_menu.o \
	    -R build/ep1-intro.o \
	    -R build/ep1-intro-slides.o
	ruby build_tools/aout2sav.rb build/bootstrap.out -b -s -o build/bootstrap.bin

build/ppu_module.bin : build/ppu.o \
                       build/core.o
	$(LD) -T linker_scripts/ppu.cmd -R build/core.o -s
	ruby build_tools/aout2sav.rb build/ppu.out -b -s -o build/ppu_module.bin

build/core.bin : build/core.o \
                 build/bootstrap.o
	$(LD) build/core.o -o build/core.out -R build/bootstrap.o -s
	ruby build_tools/aout2sav.rb build/core.out -b -s -o build/core.bin

build/loading_screen.bin : ../ResCPC/Old/T38-SC1.D01
	ruby build_tools/convert_bitmap.rb

build/level-00.bin : build/core.o \
                     build/level-00_menu.o
	$(LD) build/level-00_menu.o -R build/core.o -o build/level-00_menu.out -s
	ruby build_tools/aout2sav.rb build/level-00_menu.out -b -s -o build/level-00.bin

build/ep1-intro.bin : build/core.o \
                      build/ep1-intro.o \
                      build/ep1-intro-slides.o
	$(LD) build/ep1-intro.o -R build/core.o -R build/ep1-intro-slides.o -o build/ep1-intro.out -s
	ruby build_tools/aout2sav.rb build/ep1-intro.out -b -s -o build/ep1-intro.bin

build/ep1-intro-slides.bin : build/ep1-intro-slides.o
	$(LD) build/ep1-intro-slides.o -o build/ep1-intro-slides.out -s
	ruby build_tools/aout2sav.rb build/ep1-intro-slides.out -b -s -o build/ep1-intro-slides.bin

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
               execute_bootstrap.s \
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
              ../../akg_player/akg_player.s \
              resources/font.raw \
              resources/cga8x8b.raw
	$(AS) ppu.s -al -o build/ppu.o
	build_tools/music_buffer_update.rb

build/level-00_menu.o : $(common) \
                        level-00_menu.s \
                        resources/titletex.spr \
                        resources/menu_cursor.spr \
                        build/ep1_title_music.bin
	$(AS) -al level-00_menu.s -o build/level-00_menu.o

build/ep1_title_music.bin: build/ep1_title_music.o
	$(LD) build/ep1_title_music.o -o build/ep1_title_music.out -s
	ruby build_tools/aout2sav.rb build/ep1_title_music.out -b -s -o build/ep1_title_music.bin

build/ep1_title_music.o : $(common) \
	                  build/ppu.o \
	                  build/ep1_title_music.formatted.s
	$(AS) build/ep1_title_music.formatted.s -o build/ep1_title_music.o

build/ep1-intro.o : $(common) \
                    ep1-intro.s \
                    resources/ep1-intro.spr \
                    build/ep1_intro_music.bin \
                    build/ep1-intro/ep1-intro-slide01.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide02.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide03.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide04.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide05.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide06.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide07.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide08.raw.lzsa1
	$(AS) -al ep1-intro.s -o build/ep1-intro.o

build/ep1_intro_music.bin: build/ep1_intro_music.o
	$(LD) build/ep1_intro_music.o -o build/ep1_intro_music.out -s
	ruby build_tools/aout2sav.rb build/ep1_intro_music.out -b -s -o build/ep1_intro_music.bin

build/ep1_intro_music.o : $(common) \
	                  build/ppu.o \
	                  build/ep1_intro_music.formatted.s
	$(AS) build/ep1_intro_music.formatted.s -o build/ep1_intro_music.o

build/ep1-intro-slides.o : ep1-intro-slides.s \
                           build/ep1-intro/ep1-intro-slide09.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide10.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide11.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide12.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide13.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide14.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide15.raw.lzsa1
	$(AS) -al ep1-intro-slides.s -o build/ep1-intro-slides.o

#resources/font.raw : ../Aku/Sprites/T07-SC1.SPR \
#                     build_tools/spr_cpc_to_uknc.rb
#	build_tools/spr_cpc_to_uknc.rb ../Aku/Sprites/T07-SC1.SPR --font -o resources/font.raw

resources/font.raw : build_tools/spr_cpc_to_uknc.rb \
	             ../ResCPC/font.bin
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/font.bin --font -o resources/font.raw

resources/cga8x8b.raw : resources/cga8x8b.bmp.raw \
                        build_tools/prepare_font.rb
	ruby build_tools/prepare_font.rb resources/cga8x8b.bmp.raw

resources/titletex.spr : build_tools/spr_cpc_to_uknc.rb \
	                 ../Aku/Sprites/TITLETEX.SPR
	build_tools/spr_cpc_to_uknc.rb ../Aku/Sprites/TITLETEX.SPR -o resources/titletex.spr

resources/menu_cursor.spr : build_tools/bmp_to_uknc_raw.rb \
                            resources/menu_cursor-Sheet.bmp
	build_tools/bmp_to_uknc_raw.rb

build/ep1_title_music.formatted.s : build_tools/format_song.rb \
      	                            music/ep1_title_music.s
	build_tools/format_song.rb music/ep1_title_music.s build/ep1_title_music.formatted.s

build/ep1_intro_music.formatted.s : build_tools/format_song.rb \
	                      music/ep1_intro_music.s
	build_tools/format_song.rb music/ep1_intro_music.s build/ep1_intro_music.formatted.s

resources/ep1-intro.spr : build_tools/spr_cpc_to_uknc.rb \
	                  ../ResCPC/LEVEL252A.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/LEVEL252A.SPR -o resources/ep1-intro.spr

build/ep1-intro/ep1-intro-slide01.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide02.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide03.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide04.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide05.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide06.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide07.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide08.raw.lzsa1: resources/ep1-intro-slides-1.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide09.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide10.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide11.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide12.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide13.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide14.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb
build/ep1-intro/ep1-intro-slide15.raw.lzsa1: resources/ep1-intro-slides-2.raw
	ruby build_tools/build_intro_slides.rb

clean :
	rm -rf build/*

