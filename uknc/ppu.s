
                .TITLE Chibi Akumas PPU module
                .GLOBAL start

                .include "./macros.s"
                .include "./hwdefs.s"
                .include "./core_defs.s"

                .=0x2800 # 10240

start:
        MOV  @$PCH2II, @$SysChan2InIntHandler
        MOV  $Chan2InIntHandler, @$PCH2II # install our channel 2 data in interrupt handler
1$:     WAIT
        BR   1$

Chan2InIntHandler:

FlipToFB0:
        MOV $(FB0 >> 1),R2
        BR  FlipFB
FlipToFB1:
        MOV $(FB1 >> 1),R2
        BR  FlipFB
FlipFB:
        MOV  $FBPointer,R0
        MOV  $200,R1
loop$:  BIT  $2,(R0)+
        BNE  2$
4$: # next is 4 words
        ADD  $4,R0
2$: # next is 2 words
        MOV  R2,(R0)+
        ADD  $40,R2
        SOB  R1,loop$
RETURN

# 0 data
# 2 data
# 4 address
# 6 next element

# 0 address
# 2 next element


SysChan2InIntHandler: .word

        .balign 8
ScanLinesTable:
        .space 200 * 4 * 2 # space for a 200 four-words entries

