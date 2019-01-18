
                .TITLE Chibi Akumas PPU module
                .GLOBAL start

                .include "./macros.s"
                .include "./hwdefs.s"
 
                .=0x2800
.equiv PCH2ID, 0177064 #PPU channel 2 in  data register
.equiv PCHSIS, 0177066 #PPU channels 0, 1, 2 in - state register
start:
        MOV  @$PCH2II, @$SysChan2InIntHandler
        MOV  $Chan2InIntHandler, @$PCH2II # install our channel 2 data in interrupt handler
1$:     WAIT
        BR   1$

Chan2InIntHandler:



SysChan2InIntHandler: .word

FB0ScanLinesTable: 
FB1ScanLinesTable: 
