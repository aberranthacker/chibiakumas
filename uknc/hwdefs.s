.equiv PR7, 7 * 040 # highest priority to the processor
                    # MTPS PR7 disables interrupts
.equiv PR0, 0       # lowest priority to the processor
                    # MTPS PR0 enables interrupts

# CPU USER mode interrupt vectors and priorities
# Vect Prty Source
#   04    1 input/output RPLY timeout
#   04    2 illegal addressing mode
#  010    2 unknown instruction/HALT mode command in USER mode
#  014    3 T-bit
#  014    - BPT instruction
#  020    - IOT instruction
#  024    4 ACLO
#  030    - EMT  instruction
#  034    - TRAP instruction
#  060      TTY out (channel 0 out)
#  064      TTY in (channel 0 in)
# 0100    6 EVNT (Vsync)
# 0370      serial (C2)
# 0374      serial (C2)
# 0380      serial (LAN)
# 0384      serial (LAN)
# 0460      channel 1 out
# 0464      channel 1 in
# 0474      channel 2 in

# CPU: bitplanes registers
.equiv CBPADR, 0176640 # CPU bitplanes address register
.equiv CBP1DT, 0176642 # CPU bitplane 1 data register
.equiv CBP2DT, 0176643 # CPU bitplane 2 data register
.equiv CBP12D, CBP1DT  # CPU bitplanes 1 and 2 data register
                       # alias for word access

# CPU: to PPU communication channels
# serial port
.equiv S2IST, 0176570
.equiv S2IDT, 0176572
.equiv S2OST, 0176574
.equiv S2ODT, 0176576
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
# terminal emulation channel
.equiv CCH0II, 060     # CPU channel 0 in   state interrupt
.equiv CCH0IS, 0177560 # CPU channel 0 in   state register
.equiv CCH0ID, 0177562 # CPU channel 0 in   data register
.equiv CCH0OI, 064     # CPU channel 0 out  state interrupt
.equiv CCH0OS, 0177564 # CPU channel 0 out  state register
.equiv CCH0OD, 0177566 # CPU channel 0 out  data register
.equiv TTYIST, CCH0IS   # TTY in state
.equiv TTYIDT, CCH0ID   # TTY in data
.equiv TTYOST, CCH0OS   # TTY out state
.equiv TTYODT, CCH0OD   # TTY out data


# SRAM module register
.equiv WNDRGS, 0176000 # windows registers
.equiv WNDRGA, 0176000 # window a register
.equiv WNDRGB, 0176001 # window b register

################################################################################
#                               PPU registers                                  #
################################################################################

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

.equiv PASWCR, 0177054 # PPU address space window control register

# PPU: to CPU communication channels
.equiv PCH0II, 0320    # PPU channel 0 in  data interrupt
.equiv PCH0ID, 0177060 # PPU channel 0 in  data register
.equiv PCH1II, 0330    # PPU channel 1 in  data interrupt
.equiv PCH1ID, 0177062 # PPU channel 1 in  data register
.equiv PCH2II, 0340    # PPU channel 2 in  data interrupt
.equiv PCH2ID, 0177064 # PPU channel 2 in  data register
.equiv PCHSIS, 0177066 # PPU channels 0, 1, 2 in - state register
.equiv Ch0StateInInt,  0b00000001 # channel 0 interrupt allowed
.equiv Ch1StateInInt,  0b00000010 # channel 1 interrupt allowed
.equiv Ch2StateInInt,  0b00000100 # channel 2 interrupt allowed
.equiv Ch0InReady,     0b00001000 # channel 0 ready
.equiv Ch1InReady,     0b00010000 # channel 1 ready
.equiv Ch2InReady,     0b00100000 # channel 2 ready
.equiv IntOnCPU_RESET, 0b01000000 # interrupt on RESET on CPU bus
.equiv PCH0OI, 0324    # PPU channel 0 out  data interrupt
.equiv PCH0OD, 0177070 # PPU channel 0 out  data register
.equiv PCH1OI, 0334    # PPU channel 1 out  data interrupt
.equiv PCH1OD, 0177072 # PPU channel 1 out  data register
.equiv PCHSOS, 0177076 # PPU channels 0/1 out - state register

.equiv RSTINT, 0314    # RESET on CPU bus interrupt

# PPU: programmable parallel interface
.equiv PAR.A,  0177100 # parallel port A data register
.equiv PAR.B,  0177101 # parallel port B data register
.equiv PAR.C,  0177102 # parallel port C data register
.equiv PARCTL, 0177103 # parallel port control byte

# PPU: floppy disk controller
.equiv FDCSTS, 0177130 # floppy disk controller state register
.equiv FDCDT,  0177132 # floppy disk controller data register

# PPU: keyboard
.equiv KBINT,  0300    # keyboard interrupt
.equiv KBSTAT, 0177700 # keyboard state register
.equiv KBDATA, 0177702 # keyboard data register

# PPU: Programmable timer
.equiv TMRST , 0177710 # State register
.equiv TMREVN, 0310    # External event interrupt
.equiv TMRINT, 0304    # Programmable timer interrupt
.equiv TMRBRG, 0177712 # Buffer register
.equiv TMRCST, 0177714 # Current state register

.equiv CTRLRG, 0177716 # system control register

