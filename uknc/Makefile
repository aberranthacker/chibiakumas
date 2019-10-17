AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld

# --just-symbols= -R include only symbols from the file
# --print-map -M
# --strip-all -s

AKU.SAV : bootstrap.o core.o CORE.BIN PPU.BIN
	$(LD) -T linker_scripts/bootstrap.cmd -R core.o -s
	chmod -x AKU.SAV
	ruby build_tools/add_CCB.rb AKU.SAV
bootstrap.o : bootstrap.s bootstrap/start_game.s core.o hwdefs.s core_defs.s macros.s ppucmd.s
	ruby build_tools/preprocessor.rb -i bootstrap.s
	$(AS) bootstrap.s -o bootstrap.o

CORE.BIN : core.o
	$(LD) core.o -o core.out -T linker_scripts/core.cmd -s
	ruby build_tools/aout2sav.rb core.out -b -o CORE.BIN
core.o : core.s core_defs.s macros.s disk_driver.s player_driver.s
	$(AS) core.s -o core.o

PPU.BIN : ppu.o
	$(LD) ppu.o -o ppu.out -s
	ruby build_tools/aout2sav.rb ppu.out -b -o PPU.BIN
ppu.o : ppu.s macros.s hwdefs.s core_defs.s
	$(AS) ppu.s -o ppu.o

clean :
	rm -f *.o *.out *.SAV *.BIN
