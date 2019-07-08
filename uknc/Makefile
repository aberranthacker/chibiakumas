AS=~/opt/binutils-pdp11/pdp11-dec-aout/bin/as
LD=~/opt/binutils-pdp11/pdp11-dec-aout/bin/ld

# --just-symbols= -R
# --print-map -M
# --strip-all -s

AKU.SAV : bootstrap.o core.o
	$(LD) -T linker_scripts/bootstrap.cmd -R core.o -s
	chmod -x AKU.SAV
	ruby build_tools/add_CCB.rb AKU.SAV
CORE.BIN : core.o
	$(LD) core.o -o core.out -T linker_scripts/core.cmd -s
	ruby build_tools/aout2sav.rb core.out -b -o CORE.BIN
bootstrap.o : bootstrap.s bootstrap/start_game.s core.o core_defs.s macros.s
	ruby build_tools/preprocessor.rb -i bootstrap.s
	$(AS) bootstrap.s -o bootstrap.o
core.o : core.s core_defs.s macros.s
	$(AS) core.s -o core.o
clean :
	rm -f *.o *.out *.SAV *.BIN
