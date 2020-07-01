# vim: set fileformat=unix filetype=gas tabstop=8 expandtab shiftwidth=4 autoindent :

.macro .wait_ppu
    TST  @$PPUCommand
    BNE  .-4
.endm

.macro .ppudo cmd:req,arg=0
  .if \arg != 0
    MOV  \arg, @$PPUCommandArg
  .endif
    MOV  \cmd, @$PPUCommand
.endm

.macro .ppudo_ensure cmd:req,arg=0
   .wait_ppu
   .ppudo \cmd, \arg
.endm

.macro .puts str_addr
   .wait_ppu
   .ppudo $PPU_Print,\str_addr
   .wait_ppu
.endm

.macro .inform_and_hang str
   .wait_ppu
   .ppudo $PPU_PrintAt, $.+14
    BR   .
   .byte 0,0
   .asciz "\str"
   .even
.endm

# generic macros
.macro call addr
    JSR  PC,\addr
.endm

.macro .call cond=none, dst:req # CALL cc,nn
  .if \cond == "EQ" # equal (z)
    BNE  .+6
  .elseif \cond == "ZE" # zero
    BNE  .+6
  .elseif \cond == "NE" # not equal (nz)
    BEQ  .+6
  .elseif \cond == "NZ" # not zero
    BEQ  .+6
  .else
    .error "Unknown condition for conditional call"
  .endif
    JSR  PC,\dst
.endm

.macro .jmp cond=none, dst:req # JP cc,nn
  .if \cond == "EQ" # equal (z)
    BNE  .+6
  .elseif \cond == "ZE" # zero
    BNE  .+6
  .elseif \cond == "NE" # not equal (nz)
    BEQ  .+6
  .elseif \cond == "NZ" # not zero
    BEQ  .+6
  .elseif \cond == "CC" # carry clear
    BCS  .+6
  .elseif \cond == "CS" # carry set
    BCC  .+6
  .else
    .error "Unknown condition for conditional jump"
  .endif
    JMP  \dst
.endm

.macro return
    RTS  PC
.endm

.macro push reg
    MOV  \reg,-(SP)
.endm

.macro pop reg
    MOV  (SP)+,\reg
.endm

.macro bze dst
    BEQ  \dst
.endm

.macro bnz dst
    BNE  \dst
.endm

# RT-11 dependent macros
.macro .exit
    EMT  0350
.endm

.macro .tty_print addr
    MOV  \addr,R0
    EMT  0351
.endm

