AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld
# 2.38
MAKEFLAGS += --silent --jobs
LDFLAGS += --strip-all

.SUFFIXES:
.SUFFIXES: .s .o

# --just-symbols= -R include only symbols from the file
# --print-map -M
# --strip-all -s

common = core_defs.s event_stream_definitions.s hwdefs.s macros.s

# chibiakumas.dsk -----------------------------------------------------------{{{
build/chibiakumas.dsk : build_tools/build_dsk.rb \
                        build/bootsector.bin \
                        build/bootstrap.bin \
                        build/ppu_module.bin \
                        build/loading_screen.bin \
                        build/core.bin \
                        build/ep1_intro.bin \
                        build/ep1_intro_slides.bin \
                        build/level_00.bin \
                        build/level_01.bin \
                        build/level_02.bin
	build_tools/build_dsk.rb
# chibiakumas.dsk -----------------------------------------------------------}}}

# bootsector.bin ------------------------------------------------------------{{{
build/bootsector.bin : build/bootsector.o \
                       build/bootstrap.o
	$(LD) $(LDFLAGS) -T linker_scripts/bootsector.cmd -R build/bootstrap.o
	chmod -x build/bootsector.bin
build/bootsector.o : $(common) \
                     bootsector.s
	$(AS) -al bootsector.s -o build/bootsector.o
# bootsector.bin ------------------------------------------------------------}}}

# bootsrap.bin --------------------------------------------------------------{{{
build/bootstrap.bin : build/bootstrap.o \
                      build/ppu.o \
                      build/loading_screen.bin \
                      build/core.o \
                      build/level_00_menu.o \
                      build/ep1_intro.o \
                      build/ep1_intro_slides.o \
                      build/level_01.o \
                      build/level_02.o
	$(LD) $(LDFLAGS) -M \
	      -T linker_scripts/bootstrap.cmd \
	      -R build/core.o \
	      -R build/ep1_intro_slides.o \
	      -R build/ep1_intro.o \
	      -R build/level_00_menu.o \
	      -R build/level_01.o \
	      -R build/level_02.o \
	      -R build/ppu.o > build/bootstrap.map.txt
	ruby build_tools/aout2sav.rb build/bootstrap.out -b -s -o build/bootstrap.bin
	build_tools/update_bootstrap_disk_map.rb

build/bootstrap.o : $(common) \
                    bootstrap.s \
                    ppucmd.s
	$(AS) -al bootstrap.s -o build/bootstrap.o | build_tools/format_list.rb
# bootsrap.bin --------------------------------------------------------------}}}

# loading_screen.bin --------------------------------------------------------{{{
build/loading_screen.bin : ../ResCPC/Old/T38-SC1.D01
	ruby build_tools/convert_bitmap.rb
# loading_screen.bin --------------------------------------------------------}}}

# ppu_module.bin ------------------------------------------------------------{{{
build/ppu_module.bin : build/ppu.o \
                       build/core.o
	$(LD) $(LDFLAGS) -T linker_scripts/ppu.cmd -R build/core.o
	ruby build_tools/aout2sav.rb build/ppu.out -b -s -o build/ppu_module.bin
build/ppu.o : $(common) \
              ppu.s \
              ppu/interrupts_handlers.s \
              music/ep1_title_music_playerconfig.s \
              music/ep1_intro_music_playerconfig.s \
              music/ep1_level_music_playerconfig.s \
	      build/ep1_title_music.formatted.s \
	      build/ep1_intro_music.formatted.s \
	      build/ep1_level_music.formatted.s \
	      build/ep1_boss_music.formatted.s \
	      music/ep1_sfx_playerconfig.s \
	      music/ep1_sfx.s \
              ../../akg_player/akg_player.s \
              ../../akg_player/akg_sound_effects.s \
              resources/font.raw \
              resources/cga8x8b.raw
	$(AS) ppu.s -I../../akg_player -al -o build/ppu.o | build_tools/format_list.rb

resources/font.raw : build_tools/spr_cpc_to_uknc.rb \
	             ../ResCPC/font.bin
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/font.bin --font -o resources/font.raw

resources/cga8x8b.raw : resources/cga8x8b.bmp.raw \
                        build_tools/prepare_font.rb
	ruby build_tools/prepare_font.rb resources/cga8x8b.bmp.raw
build/ep1_title_music.formatted.s : build_tools/format_song.rb \
				    music/ep1_title_music.s
	build_tools/format_song.rb music/ep1_title_music.s build/ep1_title_music.formatted.s
build/ep1_intro_music.formatted.s : build_tools/format_song.rb \
	                            music/ep1_intro_music.s
	build_tools/format_song.rb music/ep1_intro_music.s build/ep1_intro_music.formatted.s
build/ep1_level_music.formatted.s : build_tools/format_song.rb \
	                            music/ep1_level_music.s
	build_tools/format_song.rb music/ep1_level_music.s build/ep1_level_music.formatted.s
build/ep1_boss_music.formatted.s : build_tools/format_song.rb \
	                           music/ep1_boss_music.s
	build_tools/format_song.rb music/ep1_boss_music.s build/ep1_boss_music.formatted.s
# ppu_moduel.bin ------------------------------------------------------------}}}

# core.bin ------------------------------------------------------------------{{{
build/core.bin : build/core.o \
                 build/bootstrap.o
	$(LD) $(LDFLAGS) build/core.o -o build/core.out -R build/bootstrap.o
	ruby build_tools/aout2sav.rb build/core.out -b -s -o build/core.bin
build/core.o : $(common) \
               core.s \
               core/background_bit_shifter.s \
               core/background_bit_shifter_double.s \
               core/background_get_sprite_mem_pos.s \
               core/background_quad_sprite.s \
               core/background_solid_fill.s \
               core/compiled_sprite_viewer.s \
               core/do_moves.s \
               core/event_stream.s \
               core/execute_bootstrap.s \
               core/gradient.s \
               core/object_driver.s \
               core/player_driver.s \
               core/screen_memory.s \
               core/show_sprite.s \
               core/stararray.s \
               core/stararray_add.s \
               core/timer.s \
               core/virtual_screen_pos_320.s
	$(AS) core.s -al -o build/core.o | build_tools/format_list.rb
	build_tools/level_start_update.rb
# core.bin ------------------------------------------------------------------}}}

# level_00_menu.bin ---------------------------------------------------------{{{
build/level_00.bin : build/core.o \
                     build/level_00_menu.o
	$(LD) $(LDFLAGS) build/level_00_menu.o -R build/core.o -o build/level_00_menu.out
	ruby build_tools/aout2sav.rb build/level_00_menu.out -b -s -o build/level_00.bin
build/level_00_menu.o : $(common) \
                        level_00_menu.s \
                        resources/titletex.spr \
                        resources/menu_cursor.spr
	$(AS) -al level_00_menu.s -o build/level_00_menu.o

resources/titletex.spr : build_tools/spr_cpc_to_uknc.rb \
	                 ../Aku/Sprites/TITLETEX.SPR
	build_tools/spr_cpc_to_uknc.rb ../Aku/Sprites/TITLETEX.SPR -o resources/titletex.spr

resources/menu_cursor.spr : build_tools/bmp_to_uknc_raw.rb \
                            resources/menu_cursor-Sheet.bmp
	build_tools/bmp_to_uknc_raw.rb
# level_00_menu.o -----------------------------------------------------------}}}

# ep1_intro.bin -------------------------------------------------------------{{{
build/ep1_intro.bin : build/core.o \
                      build/ep1_intro.o \
                      build/ep1_intro_slides.o
	$(LD) $(LDFLAGS) \
	      build/ep1_intro.o \
	      -R build/core.o \
	      -R build/ep1_intro_slides.o \
	      -o build/ep1_intro.out
	ruby build_tools/aout2sav.rb build/ep1_intro.out -b -s -o build/ep1_intro.bin

build/ep1_intro.o : $(common) \
                    ep1_intro.s \
                    resources/ep1_intro.spr \
                    build/ep1-intro/ep1-intro-slide01.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide02.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide03.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide04.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide05.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide06.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide07.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide08.raw.lzsa1
	$(AS) -al ep1_intro.s -o build/ep1_intro.o

build/ep1_intro_slides.bin : build/ep1_intro_slides.o
	$(LD) $(LDFLAGS) build/ep1_intro_slides.o -o build/ep1_intro_slides.out
	ruby build_tools/aout2sav.rb build/ep1_intro_slides.out -b -s -o build/ep1_intro_slides.bin

build/ep1_intro_slides.o : ep1_intro_slides.s \
                           build/ep1-intro/ep1-intro-slide09.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide10.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide11.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide12.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide13.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide14.raw.lzsa1 \
                           build/ep1-intro/ep1-intro-slide15.raw.lzsa1
	$(AS) -al ep1_intro_slides.s -o build/ep1_intro_slides.o

resources/ep1_intro.spr : build_tools/spr_cpc_to_uknc.rb \
	                  ../ResCPC/LEVEL252A.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/LEVEL252A.SPR -o resources/ep1_intro.spr

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
# ep1_intro.bin -------------------------------------------------------------}}}

# level_01.bin --------------------------------------------------------------{{{
build/level_01.bin : build/core.o \
                     build/level_01.o
	$(LD) $(LDFLAGS) build/level_01.o -R build/core.o -o build/level_01.out
	ruby build_tools/aout2sav.rb build/level_01.out -b -s -o build/level_01.bin
build/level_01.o : $(common) \
                   level_01.s \
		   resources/level01_00.spr \
		   resources/level01_01.spr \
		   resources/level01_tiles.spr \
		   resources/chibi_lr.spr
	$(AS) -al level_01.s -o build/level_01.o | build_tools/format_list.rb

resources/level01_00.spr : build_tools/spr_cpc_to_uknc.rb \
                           resources/level_01_bank_0.SPR
	build_tools/spr_cpc_to_uknc.rb resources/level_01_bank_0.SPR -o resources/level01_00.spr
resources/level01_01.spr : build_tools/spr_cpc_to_uknc.rb \
                           resources/level_01_bank_1.SPR
	build_tools/spr_cpc_to_uknc.rb resources/level_01_bank_1.SPR -o resources/level01_01.spr

resources/level01_tiles.spr : build_tools/spr_cpc_to_uknc.rb \
	                      ../ResCPC/Level01-Tiles.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/Level01-Tiles.SPR -o resources/level01_tiles.spr
# level_01.bin --------------------------------------------------------------}}}

# level_02.bin --------------------------------------------------------------{{{
build/level_02.bin : build/core.o \
                     build/level_02.o
	$(LD) $(LDFLAGS) build/level_02.o -R build/core.o -o build/level_02.out
	ruby build_tools/aout2sav.rb build/level_02.out -b -s -o build/level_02.bin

build/level_02.o : $(common) \
                   level_02.s \
		   resources/level02.spr \
		   resources/level02_tiles.spr \
		   resources/chibi_lr.spr
	$(AS) -al level_02.s -o build/level_02.o | build_tools/format_list.rb

resources/level02.spr : build_tools/spr_cpc_to_uknc.rb \
                        ../ResCPC/LEVEL2A.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/LEVEL2A.SPR -o resources/level02.spr

resources/level02_tiles.spr : build_tools/spr_cpc_to_uknc.rb \
	                      ../ResCPC/Level2-Tiles-CPC.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/Level2-Tiles-CPC.SPR -o resources/level02_tiles.spr
# level_02.bin --------------------------------------------------------------}}}

resources/chibi_lr.spr : build_tools/spr_cpc_to_uknc.rb \
			 resources/chibi_lr.cpc.spr
	build_tools/spr_cpc_to_uknc.rb resources/chibi_lr.cpc.spr -o resources/chibi_lr.spr

clean :
	rm -rf build/*
