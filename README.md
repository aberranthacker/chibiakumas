# Chibi Akumas

This is a port of the [Chibi Akumas](http://www.chibiakumas.com/) ([github](https://github.com/akuyou/chibiakumas)) game to Soviet PDP-11
compatible microcomputer [Elektronika MS 0511](https://en.wikipedia.org/wiki/UKNC).
[-](https://guides.github.com/features/mastering-markdown/)

## TODO
  * ~~Main menu~~
  * ~~Connect the AY chip to UKNC~~
  * Intro
  * Port of the Arkos Tracker 2
  * Connect the AY to UKNC right way

## How to build the project
Since default assembler for PDP-11 [MACRO-11](https://en.wikipedia.org/wiki/MACRO-11)
has very annoying limitation - only first six characters of a symbol is recognized,
my assembler of choice is [GNU Assembler](https://sourceware.org/binutils/docs/as/index.html).

Here is a couple of articles on the subject
[Developing for a PDP-11](http://docs.cslabs.clarkson.edu/wiki/Developing_for_a_PDP-11)
and [Writing PDP11 assembly code from Linux](http://ancientbits.blogspot.com/2012/07/)

In short, you'll have to grab latest version of [binutils](http://ftpmirror.gnu.org/binutils/)
```
   cd ~/tmp
   tar xvf /path/to/binutils-version-stuff.tar.bz2
```
configure it to support PDP-11
```
   cd binutils-version-stuff
   mkdir build-pdp11-aout
   cd build-pdp11-aout
   ../configure --target=pdp11-dec-aout --prefix=~/opt/binutils-pdp11
   make
   make install
```
and thats it.
Now you are all set to run the `make` command from within `./uknc/` directory to build the project.

