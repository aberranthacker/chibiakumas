# vim: set fileformat=unix filetype=gas tabstop=8 expandtab shiftwidth=4 autoindent :

.macro .wait_ppu
    TSTB @$CCH0OS
    BPL  .-4
.endm

.macro .ppudo cmd:req,arg=0
  .if \arg != 0
    MOV  \arg, @$PPUCommandArg
  .endif
    MOV  \cmd, @$CCH0OD
.endm

.macro .ppudo_ensure cmd:req,arg=0
   .wait_ppu
   .ppudo \cmd, \arg
.endm

.macro .inform_and_hang str
   .ppudo_ensure $PPU_DebugPrintAt, $inform_and_hang_string\@
    BR   .
inform_and_hang_string\@:
   .byte 0,1
   .asciz "\str"
   .even
.endm

.macro .inform_and_hang2 str
   .ppudo_ensure $PPU_DebugPrintAt, $inform_and_hang2_string\@
    BR   .
inform_and_hang2_string\@:
   .byte 0,2
   .asciz "\str"
   .even
.endm

.macro .inform_and_hang3 str
   .ppudo_ensure $PPU_DebugPrintAt, $inform_and_hang3_string\@
    BR   .
inform_and_hang3_string\@:
   .byte 0,3
   .asciz "\str"
   .even
.endm

.macro .check_for_loading_error file_name
    BCC no_loading_error\@
   .inform_and_hang3 "\file_name loading error"

no_loading_error\@:
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

