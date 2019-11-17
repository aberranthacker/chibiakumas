.equiv PR7, 7 * 040 # highest priority to the processor
                    # MTPS PR7 disables interrupts
.equiv PR0, 0       # lowest priority to the processor(enable interrupts
                    # MTPS PR0 enables interrupts

# CPU: bitplanes registers
.equiv CBPADR, 0176640 # CPU bitplanes address register
.equiv CBP1DT, 0176642 # CPU bitplane 1 data register
.equiv CBP2DT, 0176643 # CPU bitplane 2 data register
.equiv CBP12D, CBP1DT  # CPU bitplanes 1 and 2 data register
                       # alias for word access

# PPU: bitplanes registers
.equiv PBPADR, 0177010 # PPU bitplanes address register
.equiv PBP0DT, 0177012 # PPU bitplane 0 data register
.equiv PBP1DT, 0177014 # PPU bitplane 1 data register
.equiv PBP2DT, 0177015 # PPU bitplane 2 data register
.equiv PBP12D, PBP1DT  # alias for word access
.equiv DTSCOL, 0177016 # PPU dots color
.equiv BP01BC, 0177020 # PPU bitplanes 0/1 background color
.equiv BP12BC, 0177022 # PPU bitplanes 1/2 background color
.equiv DTSOCT, 0177024 # PPU dots octet
.equiv PBPMSK, 0177026 # PPU bitplanes mask register

# CPU: to PPU communication channels
# terminal emulation channel
.equiv CCH0II, 060     # CPU channel 0 in   state interrupt
.equiv CCH0IS, 0177560 # CPU channel 0 in   state register
.equiv CCH0ID, 0177562 # CPU channel 0 in   data register
.equiv CCH0OI, 064     # CPU channel 0 out  state interrupt
.equiv CCH0OS, 0177564 # CPU channel 0 out  state register
.equiv CCH0OD, 0177566 # CPU channel 0 out  data register
# parallel port access channel
.equiv CCH1II, 0460    # CPU channel 1 in   state interrupt
.equiv CCH1IS, 0176660 # CPU channel 1 in   state register
.equiv CCH1ID, 0176662 # CPU channel 1 in   data register
.equiv CCH1OI, 0464    # CPU channel 1 out  state interrput
.equiv CCH1OS, 0176664 # CPU channel 1 out  state register
.equiv CCH1OD, 0176666 # CPU channel 1 out  data register
# command channel
.equiv CCH2OI, 0474    # CPU channel 2 out  state interrupt
.equiv CCH2OS, 0176674 # CPU channel 2 out  state register
.equiv CCH2OD, 0176676 # CPU channel 2 out  data register

# PPU: Programmable timer
.equiv TMRST , 0177710 # State register
.equiv TMREVN, 0310    # External event interrupt
.equiv PGTMRI, 0304    # Programmable timer interrupt
.equiv TMRBRG, 0177712 # Buffer register
.equiv TMRCST, 0177714 # Current state register

# PPU: to CPU communication channels
.equiv PCH0II, 0320    # PPU channel 0 in  data interrupt
.equiv PCH0ID, 0177060 # PPU channel 0 in  data register
.equiv PCH1II, 0330    # PPU channel 1 in  data interrupt
.equiv PCH1ID, 0177062 # PPU channel 1 in  data register
.equiv PCH2II, 0340    # PPU channel 2 in  data interrupt
.equiv PCH2ID, 0177064 # PPU channel 2 in  data register
.equiv PCHSIS, 0177066 # PPU channels 0, 1, 2 in - state register
.equiv Ch2StateIn0Int, 0b00000001 # channel 0 interrupt allowed
.equiv Ch2StateIn1Int, 0b00000010 # channel 1 interrupt allowed
.equiv Ch2StateIn2Int, 0b00000100 # channel 2 interrupt allowed
.equiv Ch2In0Ready,    0b00001000 # channel 0 ready
.equiv Ch2In1Ready,    0b00010000 # channel 1 ready
.equiv Ch2In2Ready,    0b00100000 # channel 2 ready
.equiv IntOnCPU_RESET, 0b01000000 # interrupt on RESET on CPU bus
.equiv RSTINT, 0314    # RESET on CPU bus interrupt

.equiv PCH0OI, 0324    # PPU channel 0 out  data interrupt
.equiv PCH0OD, 0177070 # PPU channel 0 out  data register
.equiv PCH1OI, 0334    # PPU channel 1 out  data interrupt
.equiv PCH1OD, 0177072 # PPU channel 1 out  data register
.equiv PCHSOS, 0177076 # PPU channels 0/1 out - state register

# PPU: keyboard
.equiv KBINT,  0300    # keyboard interrupt
.equiv KBSTAT, 0177700 # keyboard state register
.equiv KBDATA, 0177702 # keyboard data register

# SRAM module register
.equiv WNDRGS, 0176000 # windows registers
.equiv WNDRGA, 0176000 # window a register
.equiv WNDRGB, 0176001 # window b register
