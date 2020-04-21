# vim: set fileformat=unix filetype=gas tabstop=8 expandtab shiftwidth=4 autoindent :

.macro .putstr str_addr
    TST  @$PPUCommand
    BNE  .-4
    MOV  \str_addr, @$PPUCommandArg
    MOV  $PPU_Print,@$PPUCommand
    TST  @$PPUCommand
    BNE  .-4
.endm

.macro .ppudo_ensure cmd:req,arg=0
    TST  @$PPUCommand
    BNE  .-4
  .if \arg != 0
    MOV  \arg, @$PPUCommandArg
  .endif
    MOV  \cmd, @$PPUCommand
.endm

.macro .ppudo cmd:req,arg=0
  .if \arg != 0
    MOV  \arg, @$PPUCommandArg
  .endif
    MOV  \cmd, @$PPUCommand
.endm

.macro .waitKeyThenExit
    TST  @$KeyboardScanner_KeyPresses + 2
    BEQ  .-4
    CLR  @$KeyboardScanner_KeyPresses + 2
   .ppudo_ensure $PPU_Finalize

    CLR  R0
    SOB  R0,.

    JSR  R5,PPFREE
    .word PPU_UserRamStart
    .word PPU_ModuleSizeWords

   .exit
.endm

# generic macros
.macro call addr
    JSR  PC,\addr
.endm

.macro .call cond=none, dst:req # CALL cc,nn
  .if \cond == "EQ" # equal (z)
    BNE  .+6
  .elseif \cond == "NE" # not equal (nz)
    BEQ  .+6
  .else
    .error "Unknown condition for conditional call"
  .endif
    JSR  PC,\dst
.endm

.macro .jmp cond=none, dst:req # JP cc,nn
  .if \cond == "EQ" # equal (z)
    BNE  .+6
  .elseif \cond == "NE" # not equal (nz)
    BEQ  .+6
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

.macro .cout addr
    MOV  \addr,R0
    EMT  0351
.endm

