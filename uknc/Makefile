AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld
# 2.38
MAKEFLAGS += --silent --jobs
LDFLAGS += --strip-all

.SUFFIXES:
.SUFFIXES: .s .o
.PHONY: clean

# --just-symbols= -R include only symbols from the file
# --print-map -M
# --strip-all -s

common = core_defs.s event_stream_definitions.s hwdefs.s macros.s

all : pre-build build/chibiakumas.dsk

pre-build :
	mkdir -p build/chibi
	mkdir -p build/level_01
	mkdir -p build/level_02
	mkdir -p build/level_03

clean :
	rm -rf build/*

# chibiakumas.dsk -----------------------------------------------------------{{{
build/chibiakumas.dsk : build_tools/build_dsk.rb \
                        build_tools/dsk_image_constants.rb \
                        build/bootsector.bin \
                        build/bootstrap.bin \
                        build/ppu_module.bin \
                        build/loading_screen.bin \
                        build/core.bin \
                        build/ep1_intro.bin \
                        build/ep1_intro_slides.bin \
                        build/level_00.bin \
                        build/level_01.bin \
                        build/level_02.bin \
                        build/level_03.bin \
                        build/saved_settings.bin
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
                      build/level_02.o \
                      build/level_03.o \
                      build/saved_settings.o
	$(LD) $(LDFLAGS) -M \
	      -T linker_scripts/bootstrap.cmd \
	      -R build/core.o \
	      -R build/ep1_intro_slides.o \
	      -R build/ep1_intro.o \
	      -R build/level_00_menu.o \
	      -R build/level_01.o \
	      -R build/level_02.o \
	      -R build/level_03.o \
	      -R build/ppu.o \
	      -R build/saved_settings.o > build/bootstrap.map.txt
	ruby build_tools/aout2sav.rb build/bootstrap.out -b -s -o build/bootstrap.bin
	build_tools/update_bootstrap_disk_map.rb

build/bootstrap.o : $(common) \
                    bootstrap.s \
                    ppucmd.s \
                    build/high_score.bin.lzsa1 \
                    build/continue.bin.lzsa1 \
                    build/level_01_loading.bin.lzsa1 \
                    build/level_03_loading.bin.lzsa1 \
                    build/level_05_loading.bin.lzsa1 \
                    build/level_07_loading.bin.lzsa1
	$(AS) -al bootstrap.s -o build/bootstrap.o | build_tools/format_list.rb

build/high_score.bin.lzsa1 : build_tools/bmp_to_raw.rb \
                             resources/bootstrap/high_score.bmp
	build_tools/bmp_to_raw.rb resources/bootstrap/high_score.bmp build/high_score.bin
	build_tools/lzsa -f 1 -r build/high_score.bin build/high_score.bin.lzsa1

build/continue.bin.lzsa1 : build_tools/bmp_to_raw.rb \
                           resources/bootstrap/continue-320x96.bmp
	build_tools/bmp_to_raw.rb resources/bootstrap/continue-320x96.bmp build/continue.bin
	build_tools/lzsa -f 1 -r build/continue.bin build/continue.bin.lzsa1

build/level_01_loading.bin.lzsa1 : build_tools/bmp_to_raw.rb \
                                   resources/bootstrap/level_01-loading.bmp
	build_tools/bmp_to_raw.rb resources/bootstrap/level_01-loading.bmp build/level_01_loading.bin
	build_tools/lzsa -f 1 -r build/level_01_loading.bin build/level_01_loading.bin.lzsa1

build/level_03_loading.bin.lzsa1 : build_tools/bmp_to_raw.rb \
                                   resources/bootstrap/level_03-loading.bmp
	build_tools/bmp_to_raw.rb resources/bootstrap/level_03-loading.bmp build/level_03_loading.bin
	build_tools/lzsa -f 1 -r build/level_03_loading.bin build/level_03_loading.bin.lzsa1

build/level_05_loading.bin.lzsa1 : build_tools/bmp_to_raw.rb \
                                   resources/bootstrap/level_05-loading.bmp
	build_tools/bmp_to_raw.rb resources/bootstrap/level_05-loading.bmp build/level_05_loading.bin
	build_tools/lzsa -f 1 -r build/level_05_loading.bin build/level_05_loading.bin.lzsa1

build/level_07_loading.bin.lzsa1 : build_tools/bmp_to_raw.rb \
                                   resources/bootstrap/level_07-loading.bmp
	build_tools/bmp_to_raw.rb resources/bootstrap/level_07-loading.bmp build/level_07_loading.bin
	build_tools/lzsa -f 1 -r build/level_07_loading.bin build/level_07_loading.bin.lzsa1
# bootsrap.bin --------------------------------------------------------------}}}

# saved_settings.bin --------------------------------------------------------{{{
build/saved_settings.bin : build/saved_settings.o
	$(LD) $(LDFLAGS) build/saved_settings.o -o build/saved_settings.out
	ruby build_tools/aout2sav.rb build/saved_settings.out -b -s -o build/saved_settings.bin

build/saved_settings.o : saved_settings.s
	$(AS) -al saved_settings.s -o build/saved_settings.o
# saved_settings.bin --------------------------------------------------------}}}

# loading_screen.bin --------------------------------------------------------{{{
build/loading_screen.bin : ../ResCPC/Old/T38-SC1.D01
	ruby build_tools/convert_bitmap.rb
# loading_screen.bin --------------------------------------------------------}}}

# ppu_module.bin ------------------------------------------------------------{{{
build/ppu_module.bin : build/ppu.o \
                       build/core.o \
                       build/saved_settings.o
	$(LD) $(LDFLAGS) -T linker_scripts/ppu.cmd -R build/core.o -R build/saved_settings.o
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
	      build/hitpoint_icon.bin \
	      build/smartbomb_icon.bin \
              resources/font.raw \
              resources/cga8x8b.raw
	$(AS) ppu.s -I../../akg_player -al -o build/ppu.o | build_tools/format_list.rb

build/smartbomb_icon.bin : build_tools/bmp_to_raw.rb \
                           resources/icons/smartbomb_icon-3bpp.bmp
	build_tools/bmp_to_raw.rb resources/icons/smartbomb_icon-3bpp.bmp build/smartbomb_icon.bin -b 3

build/hitpoint_icon.bin : build_tools/bmp_to_raw.rb \
                          resources/icons/hitpoint_icon-3bpp.bmp
	build_tools/bmp_to_raw.rb resources/icons/hitpoint_icon-3bpp.bmp build/hitpoint_icon.bin -b 3

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
	         build/saved_settings.o \
                 build/bootstrap.o
	$(LD) $(LDFLAGS) build/core.o -o build/core.out -R build/bootstrap.o -R build/saved_settings.o
	ruby build_tools/aout2sav.rb build/core.out -b -s -o build/core.bin
build/core.o : $(common) \
               core.s \
               core/background_bit_shifter.s \
               core/background_bit_shifter_double.s \
               core/background_get_sprite_mem_pos.s \
               core/background_quad_sprite.s \
               core/background_solid_fill.s \
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
                     build/level_00_menu.o \
                     build/saved_settings.o
	$(LD) $(LDFLAGS) build/level_00_menu.o \
		         -R build/core.o \
		         -R build/saved_settings.o \
		         -o build/level_00_menu.out
	ruby build_tools/aout2sav.rb build/level_00_menu.out -b -s -o build/level_00.bin
build/level_00_menu.o : $(common) \
                        level_00_menu.s \
                        build/menu.spr \
                        build/menu_cursor.spr
	$(AS) -al level_00_menu.s -o build/level_00_menu.o | build_tools/format_list.rb

build/menu.spr : build_tools/spr_cpc_to_uknc.rb \
	         resources/menu/TITLETEX.SPR
	build_tools/spr_cpc_to_uknc.rb resources/menu/TITLETEX.SPR -o build/menu.spr

build/menu_cursor.spr : build_tools/bmp_to_raw.rb \
                        resources/menu/cursor-Sheet.bmp
	build_tools/bmp_to_raw.rb resources/menu/cursor-Sheet.bmp build/menu_cursor.spr
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
                    build/ep1_intro.spr \
                    build/ep1-intro/ep1-intro-slide01.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide02.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide03.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide04.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide05.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide06.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide07.raw.lzsa1 \
                    build/ep1-intro/ep1-intro-slide08.raw.lzsa1
	$(AS) -al ep1_intro.s -o build/ep1_intro.o | build_tools/format_list.rb

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

build/ep1_intro.spr : build_tools/spr_cpc_to_uknc.rb \
	              ../ResCPC/LEVEL252A.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/LEVEL252A.SPR -o build/ep1_intro.spr

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

# chibi_lr.spr --------------------------------------------------------------{{{
build/chibi_lr.spr : build_tools/bmp_to_raw.rb \
		     build/chibi/chibi_r.0.bin \
		     build/chibi/chibi_r_mask.0.bin \
		     build/chibi/chibi_r.1.bin \
		     build/chibi/chibi_r_mask.1.bin \
		     build/chibi/chibi_l.0.bin \
		     build/chibi/chibi_l_mask.0.bin \
		     build/chibi/chibi_l.1.bin \
		     build/chibi/chibi_l_mask.1.bin \
		     build/chibi/drone.0.bin \
		     build/chibi/drone_mask.0.bin \
		     build/chibi/drone.1.bin \
		     build/chibi/drone_mask.1.bin \
		     chibi_lr.s
	$(AS) -al chibi_lr.s -o build/chibi_lr.o
	$(LD) $(LDFLAGS) build/chibi_lr.o -T linker_scripts/sprites.cmd -o build/chibi_lr.spr

build/chibi/chibi_r.0.bin : build_tools/bmp_to_raw.rb \
	                    resources/chibi/chibi_r.0.bmp
	build_tools/bmp_to_raw.rb resources/chibi/chibi_r.0.bmp build/chibi/chibi_r.0.bin

build/chibi/chibi_r_mask.0.bin : build_tools/bmp_to_raw.rb \
	                         resources/chibi/chibi_r_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/chibi/chibi_r_mask.0.bmp build/chibi/chibi_r_mask.0.bin

build/chibi/chibi_r.1.bin : build_tools/bmp_to_raw.rb \
	                    resources/chibi/chibi_r.1.bmp
	build_tools/bmp_to_raw.rb resources/chibi/chibi_r.1.bmp build/chibi/chibi_r.1.bin

build/chibi/chibi_r_mask.1.bin : build_tools/bmp_to_raw.rb \
	                         resources/chibi/chibi_r_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/chibi/chibi_r_mask.1.bmp build/chibi/chibi_r_mask.1.bin

build/chibi/chibi_l.0.bin : build_tools/bmp_to_raw.rb \
	                    resources/chibi/chibi_l.0.bmp
	build_tools/bmp_to_raw.rb resources/chibi/chibi_l.0.bmp build/chibi/chibi_l.0.bin

build/chibi/chibi_l_mask.0.bin : build_tools/bmp_to_raw.rb \
	                         resources/chibi/chibi_l_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/chibi/chibi_l_mask.0.bmp build/chibi/chibi_l_mask.0.bin

build/chibi/chibi_l.1.bin : build_tools/bmp_to_raw.rb \
	                    resources/chibi/chibi_l.1.bmp
	build_tools/bmp_to_raw.rb resources/chibi/chibi_l.1.bmp build/chibi/chibi_l.1.bin

build/chibi/chibi_l_mask.1.bin : build_tools/bmp_to_raw.rb \
	                         resources/chibi/chibi_r_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/chibi/chibi_l_mask.1.bmp build/chibi/chibi_l_mask.1.bin

build/chibi/drone.0.bin : build_tools/bmp_to_raw.rb \
	                  resources/chibi/drone.0.bmp
	build_tools/bmp_to_raw.rb resources/chibi/drone.0.bmp build/chibi/drone.0.bin

build/chibi/drone_mask.0.bin : build_tools/bmp_to_raw.rb \
	                       resources/chibi/drone_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/chibi/drone_mask.0.bmp build/chibi/drone_mask.0.bin

build/chibi/drone.1.bin : build_tools/bmp_to_raw.rb \
	                    resources/chibi/drone.1.bmp
	build_tools/bmp_to_raw.rb resources/chibi/drone.1.bmp build/chibi/drone.1.bin

build/chibi/drone_mask.1.bin : build_tools/bmp_to_raw.rb \
	                       resources/chibi/drone_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/chibi/drone_mask.1.bmp build/chibi/drone_mask.1.bin
# chibi_lr.spr --------------------------------------------------------------}}}

# level_01.bin --------------------------------------------------------------{{{
build/level_01.bin : build/core.o \
                     build/level_01.o \
                     build/saved_settings.o
	$(LD) $(LDFLAGS) build/level_01.o \
		         -R build/core.o \
		         -R build/saved_settings.o \
		         -o build/level_01.out

	ruby build_tools/aout2sav.rb build/level_01.out -b -s -o build/level_01.bin

build/level_01.o : $(common) \
                   level_01.s \
		   build/level_01.0.spr \
		   build/level_01.1.spr \
		   build/level_01_tiles.spr \
		   build/chibi_lr.spr
	$(AS) -al level_01.s -o build/level_01.o | build_tools/format_list.rb

#build/level_01.0.spr : build_tools/spr_cpc_to_uknc.rb \
#                       resources/level_01a.CPC.SPR
#	build_tools/spr_cpc_to_uknc.rb resources/level_01a.CPC.SPR -o build/level_01.0.spr
#build/level_01.1.spr : build_tools/spr_cpc_to_uknc.rb \
#                           resources/level_01b.CPC.SPR
#	build_tools/spr_cpc_to_uknc.rb resources/level_01b.CPC.SPR -o build/level_01.1.spr

build/level_01_tiles.spr : build_tools/spr_cpc_to_uknc.rb \
	                       ../ResCPC/Level01-Tiles.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/Level01-Tiles.SPR -o build/level_01_tiles.spr

# level_01.bin --------------------------------------------------------------}}}

# level_01.0.spr ------------------------------------------------------------{{{
build/level_01.0.spr : build/level_01/level_01.0.o \
		       linker_scripts/sprites.cmd
	$(LD) $(LDFLAGS) build/level_01/level_01.0.o -T linker_scripts/sprites.cmd \
		         -o build/level_01.0.spr

build/level_01/level_01.0.o : level_01.0.s \
			      build/level_01/coin.0.bin \
			      build/level_01/powerup_drone.0.bin \
			      build/level_01/powerup_rate.0.bin \
			      build/level_01/powerup_power.0.bin \
			      build/level_01/boulder.0.bin \
			      build/level_01/boulder_small.0.bin \
			      build/level_01/burning_bloke.0.bin \
			      build/level_01/castle.0.bin \
			      build/level_01/cloud_a.0.bin \
			      build/level_01/cloud_b.0.bin \
			      build/level_01/cloud_c.0.bin \
			      build/level_01/cloud_a_mask.0.bin \
			      build/level_01/cloud_b_mask.0.bin \
			      build/level_01/cloud_c_mask.0.bin \
			      build/level_01/cross.0.bin \
			      build/level_01/cross_crucified_bloke.0.bin \
			      build/level_01/cross_impaled_bloke.0.bin \
			      build/level_01/gravecross.0.bin \
			      build/level_01/gravecross_mask.0.bin \
			      build/level_01/gravestone.0.bin \
			      build/level_01/gravestone_mask.0.bin \
			      build/level_01/moon.0.bin \
			      build/level_01/moon_mask.0.bin \
			      build/level_01/rock_pt1.0.bin \
			      build/level_01/rock_pt2.0.bin \
			      build/level_01/rock_pt3.0.bin \
			      build/level_01/rock_pt1_mask.0.bin \
			      build/level_01/rock_pt2_mask.0.bin \
			      build/level_01/rock_pt3_mask.0.bin \
			      build/level_01/spikey_rock_a.0.bin \
			      build/level_01/spikey_rock_b.0.bin \
			      build/level_01/spikey_rock_c.0.bin \
			      build/level_01/spikey_rock_a_mask.0.bin \
			      build/level_01/spikey_rock_b_mask.0.bin \
			      build/level_01/spikey_rock_c_mask.0.bin \
			      build/level_01/ant_attacker.0.bin \
			      build/level_01/boni_burd.0.bin \
			      build/level_01/boni_burd_mask.0.bin \
			      build/level_01/eye_clopse.0.bin \
			      build/level_01/eye_clopse_mask.0.bin \
			      build/level_01/rock_chick.0.bin \
			      build/level_01/skeleton_crawler.0.bin \
			      build/level_01/skeleton_crawler_mask.0.bin \
			      build/level_01/skull_bomber.0.bin \
			      build/level_01/skull_gang.0.bin \
			      build/level_01/splice_face.0.bin
	$(AS) -al level_01.0.s -o build/level_01/level_01.0.o

build/level_01/coin.0.bin : build_tools/bmp_to_raw.rb \
	                    resources/level_01/coin.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/coin.0.bmp \
		                  build/level_01/coin.0.bin

build/level_01/powerup_drone.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/powerup_drone.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/powerup_drone.0.bmp \
		                  build/level_01/powerup_drone.0.bin

build/level_01/powerup_rate.0.bin : build_tools/bmp_to_raw.rb \
				    resources/level_01/powerup_rate.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/powerup_rate.0.bmp \
		                  build/level_01/powerup_rate.0.bin

build/level_01/powerup_power.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/powerup_power.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/powerup_power.0.bmp \
		                  build/level_01/powerup_power.0.bin

build/level_01/boulder.0.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/boulder.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/boulder.0.bmp \
		                  build/level_01/boulder.0.bin

build/level_01/boulder_small.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/boulder_small.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/boulder_small.0.bmp \
		                  build/level_01/boulder_small.0.bin

build/level_01/burning_bloke.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/burning_bloke.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/burning_bloke.0.bmp \
		                  build/level_01/burning_bloke.0.bin

build/level_01/castle.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/castle.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/castle.0.bmp \
		                  build/level_01/castle.0.bin

build/level_01/cloud_a.0.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/cloud_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cloud_a.0.bmp \
		                  build/level_01/cloud_a.0.bin

build/level_01/cloud_b.0.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/cloud_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cloud_b.0.bmp \
		                  build/level_01/cloud_b.0.bin

build/level_01/cloud_c.0.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/cloud_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cloud_c.0.bmp \
		                  build/level_01/cloud_c.0.bin

build/level_01/cloud_a_mask.0.bin : build_tools/bmp_to_raw.rb \
			            resources/level_01/cloud_a.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/cloud_a.0.bmp \
		                       build/level_01/cloud_a_mask.0.bin

build/level_01/cloud_b_mask.0.bin : build_tools/bmp_to_raw.rb \
			            resources/level_01/cloud_b.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/cloud_b.0.bmp \
		                       build/level_01/cloud_b_mask.0.bin

build/level_01/cloud_c_mask.0.bin : build_tools/bmp_to_raw.rb \
			            resources/level_01/cloud_c.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/cloud_c.0.bmp \
		                       build/level_01/cloud_c_mask.0.bin

build/level_01/cross.0.bin : build_tools/bmp_to_raw.rb \
			     resources/level_01/cross.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cross.0.bmp \
		                  build/level_01/cross.0.bin

build/level_01/cross_crucified_bloke.0.bin : build_tools/bmp_to_raw.rb \
			     	             resources/level_01/cross_crucified_bloke.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cross_crucified_bloke.0.bmp \
		                  build/level_01/cross_crucified_bloke.0.bin

build/level_01/cross_impaled_bloke.0.bin : build_tools/bmp_to_raw.rb \
				           resources/level_01/cross_impaled_bloke.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cross_impaled_bloke.0.bmp \
		                  build/level_01/cross_impaled_bloke.0.bin

build/level_01/gravecross.0.bin : build_tools/bmp_to_raw.rb \
				  resources/level_01/gravecross.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/gravecross.0.bmp \
		                  build/level_01/gravecross.0.bin

build/level_01/gravecross_mask.0.bin : build_tools/bmp_to_raw.rb \
				       resources/level_01/gravecross_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/gravecross_mask.0.bmp \
		                       build/level_01/gravecross_mask.0.bin

build/level_01/gravestone.0.bin : build_tools/bmp_to_raw.rb \
				  resources/level_01/gravestone.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/gravestone.0.bmp \
		                  build/level_01/gravestone.0.bin

build/level_01/gravestone_mask.0.bin : build_tools/bmp_to_raw.rb \
				       resources/level_01/gravestone_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/gravestone_mask.0.bmp \
		                       build/level_01/gravestone_mask.0.bin

build/level_01/moon.0.bin : build_tools/bmp_to_raw.rb \
			    resources/level_01/moon.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/moon.0.bmp \
		                  build/level_01/moon.0.bin

build/level_01/moon_mask.0.bin : build_tools/bmp_to_raw.rb \
				 resources/level_01/moon_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/moon_mask.0.bmp \
		                       build/level_01/moon_mask.0.bin

build/level_01/rock_pt1.0.bin : build_tools/bmp_to_raw.rb \
				resources/level_01/rock_pt1.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_pt1.0.bmp \
		                  build/level_01/rock_pt1.0.bin

build/level_01/rock_pt2.0.bin : build_tools/bmp_to_raw.rb \
				resources/level_01/rock_pt2.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_pt2.0.bmp \
		                  build/level_01/rock_pt2.0.bin

build/level_01/rock_pt3.0.bin : build_tools/bmp_to_raw.rb \
				resources/level_01/rock_pt3.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_pt3.0.bmp \
		                  build/level_01/rock_pt3.0.bin

build/level_01/rock_pt1_mask.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt1_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/rock_pt1_mask.0.bmp \
		                       build/level_01/rock_pt1_mask.0.bin

build/level_01/rock_pt2_mask.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt2_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/rock_pt2_mask.0.bmp \
		                       build/level_01/rock_pt2_mask.0.bin

build/level_01/rock_pt3_mask.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt3_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/rock_pt3_mask.0.bmp \
		                       build/level_01/rock_pt3_mask.0.bin

build/level_01/spikey_rock_a.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/spikey_rock_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/spikey_rock_a.0.bmp \
		                  build/level_01/spikey_rock_a.0.bin

build/level_01/spikey_rock_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/spikey_rock_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/spikey_rock_b.0.bmp \
		                  build/level_01/spikey_rock_b.0.bin

build/level_01/spikey_rock_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/spikey_rock_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/spikey_rock_c.0.bmp \
		                  build/level_01/spikey_rock_c.0.bin

build/level_01/spikey_rock_a_mask.0.bin : build_tools/bmp_to_raw.rb \
				          resources/level_01/spikey_rock_a_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/spikey_rock_a_mask.0.bmp \
		                       build/level_01/spikey_rock_a_mask.0.bin

build/level_01/spikey_rock_b_mask.0.bin : build_tools/bmp_to_raw.rb \
				          resources/level_01/spikey_rock_b_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/spikey_rock_b_mask.0.bmp \
		                       build/level_01/spikey_rock_b_mask.0.bin

build/level_01/spikey_rock_c_mask.0.bin : build_tools/bmp_to_raw.rb \
				          resources/level_01/spikey_rock_c_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/spikey_rock_c_mask.0.bmp \
		                       build/level_01/spikey_rock_c_mask.0.bin

build/level_01/ant_attacker.0.bin : build_tools/bmp_to_raw.rb \
	                            resources/level_01/ant_attacker.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/ant_attacker.0.bmp \
		                  build/level_01/ant_attacker.0.bin

build/level_01/boni_burd.0.bin : build_tools/bmp_to_raw.rb \
	                         resources/level_01/boni_burd.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/boni_burd.0.bmp \
		                  build/level_01/boni_burd.0.bin

build/level_01/boni_burd_mask.0.bin : build_tools/bmp_to_raw.rb \
	                              resources/level_01/boni_burd_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/boni_burd_mask.0.bmp \
		                       build/level_01/boni_burd_mask.0.bin

build/level_01/eye_clopse.0.bin : build_tools/bmp_to_raw.rb \
	                          resources/level_01/eye_clopse.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/eye_clopse.0.bmp \
		                  build/level_01/eye_clopse.0.bin

build/level_01/eye_clopse_mask.0.bin : build_tools/bmp_to_raw.rb \
	                               resources/level_01/eye_clopse_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/eye_clopse_mask.0.bmp \
		                       build/level_01/eye_clopse_mask.0.bin

build/level_01/rock_chick.0.bin : build_tools/bmp_to_raw.rb \
	                          resources/level_01/rock_chick.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_chick.0.bmp \
		                  build/level_01/rock_chick.0.bin

build/level_01/skeleton_crawler.0.bin : build_tools/bmp_to_raw.rb \
	                                resources/level_01/skeleton_crawler.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/skeleton_crawler.0.bmp \
		                  build/level_01/skeleton_crawler.0.bin

build/level_01/skeleton_crawler_mask.0.bin : build_tools/bmp_to_raw.rb \
	                                     resources/level_01/skeleton_crawler_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/skeleton_crawler_mask.0.bmp \
		                       build/level_01/skeleton_crawler_mask.0.bin

build/level_01/skull_bomber.0.bin : build_tools/bmp_to_raw.rb \
	                            resources/level_01/skull_bomber.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/skull_bomber.0.bmp \
		                  build/level_01/skull_bomber.0.bin

build/level_01/skull_gang.0.bin : build_tools/bmp_to_raw.rb \
	                          resources/level_01/skull_gang.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/skull_gang.0.bmp \
		                  build/level_01/skull_gang.0.bin

build/level_01/splice_face.0.bin : build_tools/bmp_to_raw.rb \
				   resources/level_01/splice_face.0.bmp
	build_tools/bmp_to_raw.rb resources/level_01/splice_face.0.bmp \
		                  build/level_01/splice_face.0.bin
# level_01.0.spr ------------------------------------------------------------}}}

# level_01.1.spr ------------------------------------------------------------{{{
build/level_01.1.spr : build/level_01/level_01.1.o \
		       linker_scripts/sprites.cmd
	$(LD) $(LDFLAGS) build/level_01/level_01.1.o -T linker_scripts/sprites.cmd \
		         -o build/level_01.1.spr

build/level_01/level_01.1.o : level_01.1.s \
			      build/level_01/coin.1.bin \
			      build/level_01/powerup_drone.1.bin \
			      build/level_01/powerup_rate.1.bin \
			      build/level_01/powerup_power.1.bin \
			      build/level_01/boulder.1.bin \
			      build/level_01/boulder_small.1.bin \
			      build/level_01/burning_bloke.1.bin \
			      build/level_01/castle.1.bin \
			      build/level_01/cloud_a.1.bin \
			      build/level_01/cloud_b.1.bin \
			      build/level_01/cloud_c.1.bin \
			      build/level_01/cloud_a_mask.1.bin \
			      build/level_01/cloud_b_mask.1.bin \
			      build/level_01/cloud_c_mask.1.bin \
			      build/level_01/cross.1.bin \
			      build/level_01/cross_crucified_bloke.1.bin \
			      build/level_01/cross_impaled_bloke.1.bin \
			      build/level_01/gravecross.1.bin \
			      build/level_01/gravecross_mask.1.bin \
			      build/level_01/gravestone.1.bin \
			      build/level_01/gravestone_mask.1.bin \
			      build/level_01/moon.1.bin \
			      build/level_01/moon_mask.1.bin \
			      build/level_01/rock_pt1.1.bin \
			      build/level_01/rock_pt2.1.bin \
			      build/level_01/rock_pt3.1.bin \
			      build/level_01/rock_pt1_mask.1.bin \
			      build/level_01/rock_pt2_mask.1.bin \
			      build/level_01/rock_pt3_mask.1.bin \
			      build/level_01/spikey_rock_a.1.bin \
			      build/level_01/spikey_rock_b.1.bin \
			      build/level_01/spikey_rock_c.1.bin \
			      build/level_01/spikey_rock_a_mask.1.bin \
			      build/level_01/spikey_rock_b_mask.1.bin \
			      build/level_01/spikey_rock_c_mask.1.bin \
			      build/level_01/ant_attacker.1.bin \
			      build/level_01/boni_burd.1.bin \
			      build/level_01/boni_burd_mask.1.bin \
			      build/level_01/eye_clopse.1.bin \
			      build/level_01/eye_clopse_mask.1.bin \
			      build/level_01/rock_chick.1.bin \
			      build/level_01/skeleton_crawler.1.bin \
			      build/level_01/skeleton_crawler_mask.1.bin \
			      build/level_01/skull_bomber.1.bin \
			      build/level_01/skull_gang.1.bin \
			      build/level_01/splice_face.1.bin
	$(AS) -al level_01.1.s -o build/level_01/level_01.1.o

build/level_01/coin.1.bin : build_tools/bmp_to_raw.rb \
	                    resources/level_01/coin.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/coin.1.bmp \
		                  build/level_01/coin.1.bin

build/level_01/powerup_drone.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/powerup_drone.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/powerup_drone.1.bmp \
		                  build/level_01/powerup_drone.1.bin

build/level_01/powerup_rate.1.bin : build_tools/bmp_to_raw.rb \
				    resources/level_01/powerup_rate.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/powerup_rate.1.bmp \
		                  build/level_01/powerup_rate.1.bin

build/level_01/powerup_power.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/powerup_power.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/powerup_power.1.bmp \
		                  build/level_01/powerup_power.1.bin

build/level_01/boulder.1.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/boulder.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/boulder.1.bmp \
		                  build/level_01/boulder.1.bin

build/level_01/boulder_small.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/boulder_small.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/boulder_small.1.bmp \
		                  build/level_01/boulder_small.1.bin

build/level_01/burning_bloke.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/burning_bloke.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/burning_bloke.1.bmp \
		                  build/level_01/burning_bloke.1.bin

build/level_01/castle.1.bin : build_tools/bmp_to_raw.rb \
			      resources/level_01/castle.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/castle.1.bmp \
		                  build/level_01/castle.1.bin

build/level_01/cloud_a.1.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/cloud_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cloud_a.1.bmp \
		                  build/level_01/cloud_a.1.bin

build/level_01/cloud_b.1.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/cloud_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cloud_b.1.bmp \
		                  build/level_01/cloud_b.1.bin

build/level_01/cloud_c.1.bin : build_tools/bmp_to_raw.rb \
			       resources/level_01/cloud_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cloud_c.1.bmp \
		                  build/level_01/cloud_c.1.bin

build/level_01/cloud_a_mask.1.bin : build_tools/bmp_to_raw.rb \
			            resources/level_01/cloud_a.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/cloud_a.1.bmp \
		                       build/level_01/cloud_a_mask.1.bin

build/level_01/cloud_b_mask.1.bin : build_tools/bmp_to_raw.rb \
			            resources/level_01/cloud_b.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/cloud_b.1.bmp \
		                       build/level_01/cloud_b_mask.1.bin

build/level_01/cloud_c_mask.1.bin : build_tools/bmp_to_raw.rb \
			            resources/level_01/cloud_c.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/cloud_c.1.bmp \
		                       build/level_01/cloud_c_mask.1.bin

build/level_01/cross.1.bin : build_tools/bmp_to_raw.rb \
			     resources/level_01/cross.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cross.1.bmp \
		                  build/level_01/cross.1.bin

build/level_01/cross_crucified_bloke.1.bin : build_tools/bmp_to_raw.rb \
				             resources/level_01/cross_crucified_bloke.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cross_crucified_bloke.1.bmp \
		                  build/level_01/cross_crucified_bloke.1.bin

build/level_01/cross_impaled_bloke.1.bin : build_tools/bmp_to_raw.rb \
				           resources/level_01/cross_impaled_bloke.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/cross_impaled_bloke.1.bmp \
		                  build/level_01/cross_impaled_bloke.1.bin

build/level_01/gravecross.1.bin : build_tools/bmp_to_raw.rb \
				  resources/level_01/gravecross.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/gravecross.1.bmp \
		                  build/level_01/gravecross.1.bin

build/level_01/gravecross_mask.1.bin : build_tools/bmp_to_raw.rb \
				       resources/level_01/gravecross_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/gravecross_mask.1.bmp \
		                       build/level_01/gravecross_mask.1.bin

build/level_01/gravestone.1.bin : build_tools/bmp_to_raw.rb \
				  resources/level_01/gravestone.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/gravestone.1.bmp \
		                  build/level_01/gravestone.1.bin

build/level_01/gravestone_mask.1.bin : build_tools/bmp_to_raw.rb \
				       resources/level_01/gravestone_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/gravestone_mask.1.bmp \
		                       build/level_01/gravestone_mask.1.bin

build/level_01/moon.1.bin : build_tools/bmp_to_raw.rb \
			    resources/level_01/moon.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/moon.1.bmp \
		                  build/level_01/moon.1.bin

build/level_01/moon_mask.1.bin : build_tools/bmp_to_raw.rb \
				 resources/level_01/moon_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/moon_mask.1.bmp \
		                       build/level_01/moon_mask.1.bin

build/level_01/rock_pt1.1.bin : build_tools/bmp_to_raw.rb \
				resources/level_01/rock_pt1.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_pt1.1.bmp \
		                  build/level_01/rock_pt1.1.bin

build/level_01/rock_pt2.1.bin : build_tools/bmp_to_raw.rb \
				resources/level_01/rock_pt2.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_pt2.1.bmp \
		                  build/level_01/rock_pt2.1.bin

build/level_01/rock_pt3.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt3.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_pt3.1.bmp \
		                  build/level_01/rock_pt3.1.bin

build/level_01/rock_pt1_mask.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt1_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/rock_pt1_mask.1.bmp \
		                       build/level_01/rock_pt1_mask.1.bin

build/level_01/rock_pt2_mask.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt2_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/rock_pt2_mask.1.bmp \
		                       build/level_01/rock_pt2_mask.1.bin

build/level_01/rock_pt3_mask.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/rock_pt3_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/rock_pt3_mask.1.bmp \
		                       build/level_01/rock_pt3_mask.1.bin

build/level_01/spikey_rock_a.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/spikey_rock_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/spikey_rock_a.1.bmp \
		                  build/level_01/spikey_rock_a.1.bin

build/level_01/spikey_rock_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/spikey_rock_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/spikey_rock_b.1.bmp \
		                  build/level_01/spikey_rock_b.1.bin

build/level_01/spikey_rock_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_01/spikey_rock_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/spikey_rock_c.1.bmp \
		                  build/level_01/spikey_rock_c.1.bin

build/level_01/spikey_rock_a_mask.1.bin : build_tools/bmp_to_raw.rb \
				          resources/level_01/spikey_rock_a_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/spikey_rock_a_mask.1.bmp \
		                       build/level_01/spikey_rock_a_mask.1.bin

build/level_01/spikey_rock_b_mask.1.bin : build_tools/bmp_to_raw.rb \
				          resources/level_01/spikey_rock_b_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/spikey_rock_b_mask.1.bmp \
		                       build/level_01/spikey_rock_b_mask.1.bin

build/level_01/spikey_rock_c_mask.1.bin : build_tools/bmp_to_raw.rb \
				          resources/level_01/spikey_rock_c_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/spikey_rock_c_mask.1.bmp \
		                       build/level_01/spikey_rock_c_mask.1.bin

build/level_01/ant_attacker.1.bin : build_tools/bmp_to_raw.rb \
	                            resources/level_01/ant_attacker.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/ant_attacker.1.bmp \
		                  build/level_01/ant_attacker.1.bin

build/level_01/boni_burd.1.bin : build_tools/bmp_to_raw.rb \
	                         resources/level_01/boni_burd.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/boni_burd.1.bmp \
		                  build/level_01/boni_burd.1.bin

build/level_01/boni_burd_mask.1.bin : build_tools/bmp_to_raw.rb \
	                              resources/level_01/boni_burd_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/boni_burd_mask.1.bmp \
		                       build/level_01/boni_burd_mask.1.bin

build/level_01/eye_clopse.1.bin : build_tools/bmp_to_raw.rb \
	                          resources/level_01/eye_clopse.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/eye_clopse.1.bmp \
		                  build/level_01/eye_clopse.1.bin

build/level_01/eye_clopse_mask.1.bin : build_tools/bmp_to_raw.rb \
	                               resources/level_01/eye_clopse_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/eye_clopse_mask.1.bmp \
		                       build/level_01/eye_clopse_mask.1.bin

build/level_01/rock_chick.1.bin : build_tools/bmp_to_raw.rb \
	                          resources/level_01/rock_chick.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/rock_chick.1.bmp \
		                  build/level_01/rock_chick.1.bin

build/level_01/skeleton_crawler.1.bin : build_tools/bmp_to_raw.rb \
	                                resources/level_01/skeleton_crawler.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/skeleton_crawler.1.bmp \
		                  build/level_01/skeleton_crawler.1.bin

build/level_01/skeleton_crawler_mask.1.bin : build_tools/bmp_to_raw.rb \
	                                     resources/level_01/skeleton_crawler_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_01/skeleton_crawler_mask.1.bmp \
		                       build/level_01/skeleton_crawler_mask.1.bin

build/level_01/skull_bomber.1.bin : build_tools/bmp_to_raw.rb \
	                            resources/level_01/skull_bomber.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/skull_bomber.1.bmp \
		                  build/level_01/skull_bomber.1.bin

build/level_01/skull_gang.1.bin : build_tools/bmp_to_raw.rb \
	                          resources/level_01/skull_gang.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/skull_gang.1.bmp \
		                  build/level_01/skull_gang.1.bin

build/level_01/splice_face.1.bin : build_tools/bmp_to_raw.rb \
				   resources/level_01/splice_face.1.bmp
	build_tools/bmp_to_raw.rb resources/level_01/splice_face.1.bmp \
		                  build/level_01/splice_face.1.bin
# level_01.1.spr ------------------------------------------------------------}}}

# level_02.bin --------------------------------------------------------------{{{
build/level_02.bin : build/core.o \
                     build/level_02.o
	$(LD) $(LDFLAGS) build/level_02.o -R build/core.o -o build/level_02.out
	ruby build_tools/aout2sav.rb build/level_02.out -b -s -o build/level_02.bin

build/level_02.o : $(common) \
                   level_02.s \
		   build/level_02.0.spr \
		   build/level_02.1.spr \
		   build/level_02_tiles.spr \
		   build/chibi_lr.spr
	$(AS) -al level_02.s -o build/level_02.o | build_tools/format_list.rb

build/level_02_tiles.spr : build_tools/spr_cpc_to_uknc.rb \
	                   ../ResCPC/Level2-Tiles-CPC.SPR
	build_tools/spr_cpc_to_uknc.rb ../ResCPC/Level2-Tiles-CPC.SPR -o build/level_02_tiles.spr
# level_02.bin --------------------------------------------------------------}}}

# level_02.0.spr ------------------------------------------------------------{{{
build/level_02.0.spr : build/level_02/level_02.0.o \
		       linker_scripts/sprites.cmd
	$(LD) $(LDFLAGS) build/level_02/level_02.0.o -T linker_scripts/sprites.cmd \
		         -o build/level_02.0.spr

build/level_02/level_02.0.o : level_02.0.s \
			      build/level_02/coin.0.bin \
			      build/level_02/skull_100_a.0.bin \
			      build/level_02/skull_100_b.0.bin \
			      build/level_02/skull_100_c.0.bin \
			      build/level_02/skull_80_a.0.bin \
			      build/level_02/skull_80_b.0.bin \
			      build/level_02/skull_80_c.0.bin \
			      build/level_02/skull_60_b.0.bin \
			      build/level_02/skull_60_c.0.bin \
			      build/level_02/skull_40_b.0.bin \
			      build/level_02/skull_40_c.0.bin \
			      build/level_02/skull_20_b.0.bin \
			      build/level_02/skull_20_c.0.bin \
			      build/level_02/skull_0_a.0.bin \
			      build/level_02/skull_0_b.0.bin \
			      build/level_02/skull_0_c.0.bin \
			      build/level_02/legs_left_a.0.bin \
			      build/level_02/legs_left_b.0.bin \
			      build/level_02/legs_left_c.0.bin \
			      build/level_02/legs_right_a.0.bin \
			      build/level_02/legs_right_b.0.bin \
			      build/level_02/legs_right_c.0.bin \
			      build/level_02/hand_up.0.bin \
			      build/level_02/hand_down.0.bin \
			      build/level_02/hand_left.0.bin \
			      build/level_02/hand_right.0.bin
	$(AS) -al level_02.0.s -o build/level_02/level_02.0.o

build/level_02/coin.0.bin : build_tools/bmp_to_raw.rb \
	                    resources/level_02/coin.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/coin.0.bmp \
		                  build/level_02/coin.0.bin

build/level_02/skull_100_a.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_100_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_100_a.0.bmp \
		                  build/level_02/skull_100_a.0.bin

build/level_02/skull_100_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_100_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_100_b.0.bmp \
		                  build/level_02/skull_100_b.0.bin

build/level_02/skull_100_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_100_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_100_c.0.bmp \
		                  build/level_02/skull_100_c.0.bin

build/level_02/skull_80_a.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_80_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_80_a.0.bmp \
		                  build/level_02/skull_80_a.0.bin

build/level_02/skull_80_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_80_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_80_b.0.bmp \
		                  build/level_02/skull_80_b.0.bin

build/level_02/skull_80_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_80_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_80_c.0.bmp \
		                  build/level_02/skull_80_c.0.bin

build/level_02/skull_60_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_60_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_60_b.0.bmp \
		                  build/level_02/skull_60_b.0.bin

build/level_02/skull_60_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_60_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_60_c.0.bmp \
		                  build/level_02/skull_60_c.0.bin

build/level_02/skull_40_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_40_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_40_b.0.bmp \
		                  build/level_02/skull_40_b.0.bin

build/level_02/skull_40_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_40_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_40_c.0.bmp \
		                  build/level_02/skull_40_c.0.bin

build/level_02/skull_20_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_20_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_20_b.0.bmp \
		                  build/level_02/skull_20_b.0.bin

build/level_02/skull_20_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_20_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_20_c.0.bmp \
		                  build/level_02/skull_20_c.0.bin

build/level_02/skull_0_a.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_0_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_0_a.0.bmp \
		                  build/level_02/skull_0_a.0.bin

build/level_02/skull_0_b.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_0_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_0_b.0.bmp \
		                  build/level_02/skull_0_b.0.bin

build/level_02/skull_0_c.0.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_0_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_0_c.0.bmp \
		                  build/level_02/skull_0_c.0.bin

build/level_02/legs_left_a.0.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_left_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_left_a.0.bmp \
		                  build/level_02/legs_left_a.0.bin

build/level_02/legs_left_b.0.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_left_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_left_b.0.bmp \
		                  build/level_02/legs_left_b.0.bin

build/level_02/legs_left_c.0.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_left_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_left_c.0.bmp \
		                  build/level_02/legs_left_c.0.bin

build/level_02/legs_right_a.0.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_right_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_right_a.0.bmp \
		                  build/level_02/legs_right_a.0.bin

build/level_02/legs_right_b.0.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_right_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_right_b.0.bmp \
		                  build/level_02/legs_right_b.0.bin

build/level_02/legs_right_c.0.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_right_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_right_c.0.bmp \
		                  build/level_02/legs_right_c.0.bin

build/level_02/hand_up.0.bin : build_tools/bmp_to_raw.rb \
			       resources/level_02/hand_up.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_up.0.bmp \
		                  build/level_02/hand_up.0.bin

build/level_02/hand_down.0.bin : build_tools/bmp_to_raw.rb \
			         resources/level_02/hand_down.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_down.0.bmp \
		                  build/level_02/hand_down.0.bin

build/level_02/hand_left.0.bin : build_tools/bmp_to_raw.rb \
			         resources/level_02/hand_left.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_left.0.bmp \
		                  build/level_02/hand_left.0.bin

build/level_02/hand_right.0.bin : build_tools/bmp_to_raw.rb \
			          resources/level_02/hand_right.0.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_right.0.bmp \
		                  build/level_02/hand_right.0.bin
# level_02.0.spr ------------------------------------------------------------}}}

# level_02.1.spr ------------------------------------------------------------{{{
build/level_02.1.spr : build/level_02/level_02.1.o \
		       linker_scripts/sprites.cmd
	$(LD) $(LDFLAGS) build/level_02/level_02.1.o -T linker_scripts/sprites.cmd \
		         -o build/level_02.1.spr

build/level_02/level_02.1.o : level_02.1.s \
			      build/level_02/coin.1.bin \
			      build/level_02/skull_100_a.1.bin \
			      build/level_02/skull_100_b.1.bin \
			      build/level_02/skull_100_c.1.bin \
			      build/level_02/skull_80_a.1.bin \
			      build/level_02/skull_80_b.1.bin \
			      build/level_02/skull_80_c.1.bin \
			      build/level_02/skull_60_b.1.bin \
			      build/level_02/skull_60_c.1.bin \
			      build/level_02/skull_40_b.1.bin \
			      build/level_02/skull_40_c.1.bin \
			      build/level_02/skull_20_b.1.bin \
			      build/level_02/skull_20_c.1.bin \
			      build/level_02/skull_0_a.1.bin \
			      build/level_02/skull_0_b.1.bin \
			      build/level_02/skull_0_c.1.bin \
			      build/level_02/legs_left_a.1.bin \
			      build/level_02/legs_left_b.1.bin \
			      build/level_02/legs_left_c.1.bin \
			      build/level_02/legs_right_a.1.bin \
			      build/level_02/legs_right_b.1.bin \
			      build/level_02/legs_right_c.1.bin \
			      build/level_02/hand_up.1.bin \
			      build/level_02/hand_down.1.bin \
			      build/level_02/hand_left.1.bin \
			      build/level_02/hand_right.1.bin
	$(AS) -al level_02.1.s -o build/level_02/level_02.1.o

build/level_02/coin.1.bin : build_tools/bmp_to_raw.rb \
	                    resources/level_02/coin.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/coin.1.bmp \
		                  build/level_02/coin.1.bin

build/level_02/skull_100_a.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_100_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_100_a.1.bmp \
		                  build/level_02/skull_100_a.1.bin

build/level_02/skull_100_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_100_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_100_b.1.bmp \
		                  build/level_02/skull_100_b.1.bin

build/level_02/skull_100_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_100_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_100_c.1.bmp \
		                  build/level_02/skull_100_c.1.bin

build/level_02/skull_80_a.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_80_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_80_a.1.bmp \
		                  build/level_02/skull_80_a.1.bin

build/level_02/skull_80_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_80_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_80_b.1.bmp \
		                  build/level_02/skull_80_b.1.bin

build/level_02/skull_80_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_80_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_80_c.1.bmp \
		                  build/level_02/skull_80_c.1.bin

build/level_02/skull_60_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_60_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_60_b.1.bmp \
		                  build/level_02/skull_60_b.1.bin

build/level_02/skull_60_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_60_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_60_c.1.bmp \
		                  build/level_02/skull_60_c.1.bin

build/level_02/skull_40_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_40_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_40_b.1.bmp \
		                  build/level_02/skull_40_b.1.bin

build/level_02/skull_40_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_40_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_40_c.1.bmp \
		                  build/level_02/skull_40_c.1.bin

build/level_02/skull_20_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_20_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_20_b.1.bmp \
		                  build/level_02/skull_20_b.1.bin

build/level_02/skull_20_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_20_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_20_c.1.bmp \
		                  build/level_02/skull_20_c.1.bin

build/level_02/skull_0_a.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_0_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_0_a.1.bmp \
		                  build/level_02/skull_0_a.1.bin

build/level_02/skull_0_b.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_0_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_0_b.1.bmp \
		                  build/level_02/skull_0_b.1.bin

build/level_02/skull_0_c.1.bin : build_tools/bmp_to_raw.rb \
				     resources/level_02/skull_0_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/skull_0_c.1.bmp \
		                  build/level_02/skull_0_c.1.bin

build/level_02/legs_left_a.1.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_left_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_left_a.1.bmp \
		                  build/level_02/legs_left_a.1.bin

build/level_02/legs_left_b.1.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_left_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_left_b.1.bmp \
		                  build/level_02/legs_left_b.1.bin

build/level_02/legs_left_c.1.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_left_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_left_c.1.bmp \
		                  build/level_02/legs_left_c.1.bin

build/level_02/legs_right_a.1.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_right_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_right_a.1.bmp \
		                  build/level_02/legs_right_a.1.bin

build/level_02/legs_right_b.1.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_right_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_right_b.1.bmp \
		                  build/level_02/legs_right_b.1.bin

build/level_02/legs_right_c.1.bin : build_tools/bmp_to_raw.rb \
				            resources/level_02/legs_right_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/legs_right_c.1.bmp \
		                  build/level_02/legs_right_c.1.bin

build/level_02/hand_up.1.bin : build_tools/bmp_to_raw.rb \
			       resources/level_02/hand_up.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_up.1.bmp \
		                  build/level_02/hand_up.1.bin

build/level_02/hand_down.1.bin : build_tools/bmp_to_raw.rb \
			         resources/level_02/hand_down.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_down.1.bmp \
		                  build/level_02/hand_down.1.bin

build/level_02/hand_left.1.bin : build_tools/bmp_to_raw.rb \
			         resources/level_02/hand_left.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_left.1.bmp \
		                  build/level_02/hand_left.1.bin

build/level_02/hand_right.1.bin : build_tools/bmp_to_raw.rb \
			          resources/level_02/hand_right.1.bmp
	build_tools/bmp_to_raw.rb resources/level_02/hand_right.1.bmp \
		                  build/level_02/hand_right.1.bin
# level_02.1.spr ------------------------------------------------------------}}}

# level_03.bin --------------------------------------------------------------{{{
build/level_03.bin : build/core.o \
                     build/level_03.o
	$(LD) $(LDFLAGS) build/level_03.o -R build/core.o -o build/level_03.out
	ruby build_tools/aout2sav.rb build/level_03.out -b -s -o build/level_03.bin

build/level_03.o : $(common) \
                   level_03.s \
		   build/level_03.0.spr \
		   build/level_03.1.spr \
		   build/level_03_tiles.spr \
		   build/chibi_lr.spr
	$(AS) -al level_03.s -o build/level_03.o | build_tools/format_list.rb

build/level_03_tiles.spr : build_tools/spr_cpc_to_uknc.rb \
	                   resources/level_03_tiles.cpc.spr
	build_tools/spr_cpc_to_uknc.rb resources/level_03_tiles.cpc.spr -o build/level_03_tiles.spr
# level_02.bin --------------------------------------------------------------}}}

# level_03.0.spr ------------------------------------------------------------{{{
build/level_03.0.spr : build/level_03.0.o \
                       linker_scripts/sprites.cmd
	$(LD) $(LDFLAGS) build/level_03.0.o -T linker_scripts/sprites.cmd \
	                 -o build/level_03.0.spr

build/level_03.0.o : level_03.0.s \
	             build/level_03/biterfly.0.bin \
	             build/level_03/biterfly_mask.0.bin \
	             build/level_03/coin.0.bin \
	             build/level_03/coin_mask.0.bin \
	             build/level_03/gnat_pack.0.bin \
	             build/level_03/gnat_pack_mask.0.bin \
	             build/level_03/grass_tuft_a.0.bin \
	             build/level_03/grass_tuft_b.0.bin \
	             build/level_03/grass_tuft_big.0.bin \
	             build/level_03/grass_tuft_big_mask.0.bin \
	             build/level_03/grass_tuft_c.0.bin \
	             build/level_03/grass_tuft_d.0.bin \
	             build/level_03/kamisagi.0.bin \
	             build/level_03/kamisagi_mask.0.bin \
	             build/level_03/mukade_bachi_1.0.bin \
	             build/level_03/mukade_bachi_2.0.bin \
	             build/level_03/mukade_bachi_3.0.bin \
	             build/level_03/mukade_bachi_5.0.bin \
	             build/level_03/powerup_drone.0.bin \
	             build/level_03/powerup_drone_mask.0.bin \
	             build/level_03/powerup_power.0.bin \
	             build/level_03/powerup_rate.0.bin \
	             build/level_03/shroom_bomber.0.bin \
	             build/level_03/shroom_bomber_mask.0.bin \
	             build/level_03/zombie_capybara.0.bin \
	             build/level_03/zombie_capybara_mask.0.bin \
	             build/level_03/zombie_salaryman.0.bin \
	             build/level_03/zombie_salaryman_mask.0.bin
	$(AS) -al level_03.0.s -o build/level_03.0.o

build/level_03/biterfly.0.bin : build_tools/bmp_to_raw.rb \
                                resources/level_03/biterfly.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/biterfly.0.bmp \
	                          build/level_03/biterfly.0.bin

build/level_03/biterfly_mask.0.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/biterfly_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/biterfly_mask.0.bmp \
	                               build/level_03/biterfly_mask.0.bin

build/level_03/coin.0.bin : build_tools/bmp_to_raw.rb \
                            resources/level_03/coin.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/coin.0.bmp \
	                          build/level_03/coin.0.bin

build/level_03/coin_mask.0.bin : build_tools/bmp_to_raw.rb \
                                 resources/level_03/coin_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/coin_mask.0.bmp \
	                               build/level_03/coin_mask.0.bin

build/level_03/gnat_pack.0.bin : build_tools/bmp_to_raw.rb \
                                 resources/level_03/gnat_pack.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/gnat_pack.0.bmp \
	                          build/level_03/gnat_pack.0.bin

build/level_03/gnat_pack_mask.0.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/gnat_pack_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/gnat_pack_mask.0.bmp \
	                               build/level_03/gnat_pack_mask.0.bin

build/level_03/grass_tuft_a.0.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_a.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_a.0.bmp \
	                          build/level_03/grass_tuft_a.0.bin

build/level_03/grass_tuft_b.0.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_b.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_b.0.bmp \
	                          build/level_03/grass_tuft_b.0.bin

build/level_03/grass_tuft_big.0.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/grass_tuft_big.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_big.0.bmp \
	                          build/level_03/grass_tuft_big.0.bin

build/level_03/grass_tuft_big_mask.0.bin : build_tools/bmp_to_raw.rb \
                                           resources/level_03/grass_tuft_big_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/grass_tuft_big_mask.0.bmp \
	                               build/level_03/grass_tuft_big_mask.0.bin

build/level_03/grass_tuft_c.0.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_c.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_c.0.bmp \
	                          build/level_03/grass_tuft_c.0.bin

build/level_03/grass_tuft_d.0.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_d.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_d.0.bmp \
	                          build/level_03/grass_tuft_d.0.bin

build/level_03/kamisagi.0.bin : build_tools/bmp_to_raw.rb \
                                resources/level_03/kamisagi.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/kamisagi.0.bmp \
	                          build/level_03/kamisagi.0.bin

build/level_03/kamisagi_mask.0.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/kamisagi_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/kamisagi_mask.0.bmp \
	                               build/level_03/kamisagi_mask.0.bin

build/level_03/mukade_bachi_1.0.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_1.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_1.0.bmp \
	                          build/level_03/mukade_bachi_1.0.bin

build/level_03/mukade_bachi_2.0.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_2.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_2.0.bmp \
	                          build/level_03/mukade_bachi_2.0.bin

build/level_03/mukade_bachi_3.0.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_3.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_3.0.bmp \
	                          build/level_03/mukade_bachi_3.0.bin

build/level_03/mukade_bachi_5.0.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_5.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_5.0.bmp \
	                          build/level_03/mukade_bachi_5.0.bin

build/level_03/powerup_drone.0.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/powerup_drone.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/powerup_drone.0.bmp \
	                          build/level_03/powerup_drone.0.bin

build/level_03/powerup_drone_mask.0.bin : build_tools/bmp_to_raw.rb \
                                          resources/level_03/powerup_drone_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/powerup_drone_mask.0.bmp \
	                               build/level_03/powerup_drone_mask.0.bin

build/level_03/powerup_power.0.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/powerup_power.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/powerup_power.0.bmp \
	                          build/level_03/powerup_power.0.bin

build/level_03/powerup_rate.0.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/powerup_rate.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/powerup_rate.0.bmp \
	                          build/level_03/powerup_rate.0.bin

build/level_03/shroom_bomber.0.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/shroom_bomber.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/shroom_bomber.0.bmp \
	                          build/level_03/shroom_bomber.0.bin

build/level_03/shroom_bomber_mask.0.bin : build_tools/bmp_to_raw.rb \
                                          resources/level_03/shroom_bomber_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/shroom_bomber_mask.0.bmp \
	                               build/level_03/shroom_bomber_mask.0.bin

build/level_03/zombie_capybara.0.bin : build_tools/bmp_to_raw.rb \
                                       resources/level_03/zombie_capybara.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/zombie_capybara.0.bmp \
	                          build/level_03/zombie_capybara.0.bin

build/level_03/zombie_capybara_mask.0.bin : build_tools/bmp_to_raw.rb \
                                            resources/level_03/zombie_capybara_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/zombie_capybara_mask.0.bmp \
	                               build/level_03/zombie_capybara_mask.0.bin

build/level_03/zombie_salaryman.0.bin : build_tools/bmp_to_raw.rb \
                                        resources/level_03/zombie_salaryman.0.bmp
	build_tools/bmp_to_raw.rb resources/level_03/zombie_salaryman.0.bmp \
	                          build/level_03/zombie_salaryman.0.bin

build/level_03/zombie_salaryman_mask.0.bin : build_tools/bmp_to_raw.rb \
                                             resources/level_03/zombie_salaryman_mask.0.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/zombie_salaryman_mask.0.bmp \
	                               build/level_03/zombie_salaryman_mask.0.bin
# level_03.0.spr ------------------------------------------------------------}}}

# level_03.1.spr ------------------------------------------------------------{{{
build/level_03.1.spr : build/level_03.1.o \
                       linker_scripts/sprites.cmd
	$(LD) $(LDFLAGS) build/level_03.1.o -T linker_scripts/sprites.cmd \
	                 -o build/level_03.1.spr

build/level_03.1.o : level_03.1.s \
	             build/level_03/biterfly.1.bin \
	             build/level_03/biterfly_mask.1.bin \
	             build/level_03/coin.1.bin \
	             build/level_03/coin_mask.1.bin \
	             build/level_03/gnat_pack.1.bin \
	             build/level_03/gnat_pack_mask.1.bin \
	             build/level_03/grass_tuft_a.1.bin \
	             build/level_03/grass_tuft_b.1.bin \
	             build/level_03/grass_tuft_big.1.bin \
	             build/level_03/grass_tuft_big_mask.1.bin \
	             build/level_03/grass_tuft_c.1.bin \
	             build/level_03/grass_tuft_d.1.bin \
	             build/level_03/kamisagi.1.bin \
	             build/level_03/kamisagi_mask.1.bin \
	             build/level_03/mukade_bachi_1.1.bin \
	             build/level_03/mukade_bachi_2.1.bin \
	             build/level_03/mukade_bachi_3.1.bin \
	             build/level_03/mukade_bachi_5.1.bin \
	             build/level_03/powerup_drone.1.bin \
	             build/level_03/powerup_drone_mask.1.bin \
	             build/level_03/powerup_power.1.bin \
	             build/level_03/powerup_rate.1.bin \
	             build/level_03/shroom_bomber.1.bin \
	             build/level_03/shroom_bomber_mask.1.bin \
	             build/level_03/zombie_capybara.1.bin \
	             build/level_03/zombie_capybara_mask.1.bin \
	             build/level_03/zombie_salaryman.1.bin \
	             build/level_03/zombie_salaryman_mask.1.bin
	$(AS) -al level_03.1.s -o build/level_03.1.o

build/level_03/biterfly.1.bin : build_tools/bmp_to_raw.rb \
                                resources/level_03/biterfly.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/biterfly.1.bmp \
	                          build/level_03/biterfly.1.bin

build/level_03/biterfly_mask.1.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/biterfly_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/biterfly_mask.1.bmp \
	                               build/level_03/biterfly_mask.1.bin

build/level_03/coin.1.bin : build_tools/bmp_to_raw.rb \
                            resources/level_03/coin.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/coin.1.bmp \
	                          build/level_03/coin.1.bin

build/level_03/coin_mask.1.bin : build_tools/bmp_to_raw.rb \
                                 resources/level_03/coin_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/coin_mask.1.bmp \
	                               build/level_03/coin_mask.1.bin

build/level_03/gnat_pack.1.bin : build_tools/bmp_to_raw.rb \
                                 resources/level_03/gnat_pack.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/gnat_pack.1.bmp \
	                          build/level_03/gnat_pack.1.bin

build/level_03/gnat_pack_mask.1.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/gnat_pack_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/gnat_pack_mask.1.bmp \
	                               build/level_03/gnat_pack_mask.1.bin

build/level_03/grass_tuft_a.1.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_a.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_a.1.bmp \
	                          build/level_03/grass_tuft_a.1.bin

build/level_03/grass_tuft_b.1.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_b.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_b.1.bmp \
	                          build/level_03/grass_tuft_b.1.bin

build/level_03/grass_tuft_big.1.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/grass_tuft_big.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_big.1.bmp \
	                          build/level_03/grass_tuft_big.1.bin

build/level_03/grass_tuft_big_mask.1.bin : build_tools/bmp_to_raw.rb \
                                           resources/level_03/grass_tuft_big_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/grass_tuft_big_mask.1.bmp \
	                               build/level_03/grass_tuft_big_mask.1.bin

build/level_03/grass_tuft_c.1.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_c.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_c.1.bmp \
	                          build/level_03/grass_tuft_c.1.bin

build/level_03/grass_tuft_d.1.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/grass_tuft_d.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/grass_tuft_d.1.bmp \
	                          build/level_03/grass_tuft_d.1.bin

build/level_03/kamisagi.1.bin : build_tools/bmp_to_raw.rb \
                                resources/level_03/kamisagi.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/kamisagi.1.bmp \
	                          build/level_03/kamisagi.1.bin

build/level_03/kamisagi_mask.1.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/kamisagi_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/kamisagi_mask.1.bmp \
	                               build/level_03/kamisagi_mask.1.bin

build/level_03/mukade_bachi_1.1.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_1.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_1.1.bmp \
	                          build/level_03/mukade_bachi_1.1.bin

build/level_03/mukade_bachi_2.1.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_2.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_2.1.bmp \
	                          build/level_03/mukade_bachi_2.1.bin

build/level_03/mukade_bachi_3.1.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_3.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_3.1.bmp \
	                          build/level_03/mukade_bachi_3.1.bin

build/level_03/mukade_bachi_5.1.bin : build_tools/bmp_to_raw.rb \
                                      resources/level_03/mukade_bachi_5.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/mukade_bachi_5.1.bmp \
	                          build/level_03/mukade_bachi_5.1.bin

build/level_03/powerup_drone.1.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/powerup_drone.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/powerup_drone.1.bmp \
	                          build/level_03/powerup_drone.1.bin

build/level_03/powerup_drone_mask.1.bin : build_tools/bmp_to_raw.rb \
                                          resources/level_03/powerup_drone_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/powerup_drone_mask.1.bmp \
	                               build/level_03/powerup_drone_mask.1.bin

build/level_03/powerup_power.1.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/powerup_power.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/powerup_power.1.bmp \
	                          build/level_03/powerup_power.1.bin

build/level_03/powerup_rate.1.bin : build_tools/bmp_to_raw.rb \
                                    resources/level_03/powerup_rate.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/powerup_rate.1.bmp \
	                          build/level_03/powerup_rate.1.bin

build/level_03/shroom_bomber.1.bin : build_tools/bmp_to_raw.rb \
                                     resources/level_03/shroom_bomber.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/shroom_bomber.1.bmp \
	                          build/level_03/shroom_bomber.1.bin

build/level_03/shroom_bomber_mask.1.bin : build_tools/bmp_to_raw.rb \
                                          resources/level_03/shroom_bomber_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/shroom_bomber_mask.1.bmp \
	                               build/level_03/shroom_bomber_mask.1.bin

build/level_03/zombie_capybara.1.bin : build_tools/bmp_to_raw.rb \
                                       resources/level_03/zombie_capybara.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/zombie_capybara.1.bmp \
	                          build/level_03/zombie_capybara.1.bin

build/level_03/zombie_capybara_mask.1.bin : build_tools/bmp_to_raw.rb \
                                            resources/level_03/zombie_capybara_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/zombie_capybara_mask.1.bmp \
	                               build/level_03/zombie_capybara_mask.1.bin

build/level_03/zombie_salaryman.1.bin : build_tools/bmp_to_raw.rb \
                                        resources/level_03/zombie_salaryman.1.bmp
	build_tools/bmp_to_raw.rb resources/level_03/zombie_salaryman.1.bmp \
	                          build/level_03/zombie_salaryman.1.bin

build/level_03/zombie_salaryman_mask.1.bin : build_tools/bmp_to_raw.rb \
                                             resources/level_03/zombie_salaryman_mask.1.bmp
	build_tools/bmp_to_raw.rb -b 1 resources/level_03/zombie_salaryman_mask.1.bmp \
	                               build/level_03/zombie_salaryman_mask.1.bin
# level_03.1.spr ------------------------------------------------------------}}}
