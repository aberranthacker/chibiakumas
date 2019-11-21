# vim: set fileformat=unix filetype=gas tabstop=8 expandtab shiftwidth=4 autoindent :

.macro .putstr str_addr
    TST  @$PPUCommand
    BNE  .-4
    MOV  \str_addr, @$PPUCommandArg
    MOV  $PPU_Print,@$PPUCommand
.endm

# generic macros
.macro call addr
    JSR  PC,\addr
.endm

.macro .call cond=none, addr:req
  .if \cond == "EQ" # equal (z)
    BNE  .+6
  .elseif \cond == "NE" # not equal (nz)
    BEQ  .+6
  .else
    .error "Unknown condition for conditional call"
  .endif
    JSR  PC,\addr
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

# RT-11 dependent macros
.macro .exit
    EMT  0350
.endm

.macro .cout addr
    MOV  \addr,R0
    EMT  0351
.endm

