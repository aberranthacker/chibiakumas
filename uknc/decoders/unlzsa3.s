# vim: set tabstop=4 :


# optimized LZSA3 decompressor for PDP-011 by Manwe and Ivanq
# Thanks to Ivan Gorodetsky
# Usage:
# MOV $src_adr,R1
# MOV $dst_adr,R2
# CALL Unpack

#.global Unpack


Unpack: CLR R5              # no nibbles sign
Token:  MOVB (R1)+,R3       # read token

Liter:  MOV R3,R0
        BIC $0177774,R0     # get 2 bits
        BEQ Decode
        CMP R0,$3           # literals length
        BNE Copy
            CALL Extend
Copy:   MOVB (R1)+,(R2)+    # literals length in R0
        SOB R0,Copy

Decode: PUSH R3
        ROLB R3             # get 2 bits
        ROL R0
        ROLB R3
        ROL R0
        ASL R0
        ADD R0,PC           # run subroutine
        BR oOther
        BR o9bit
        BR o13bit

o5bit:  CALL Nibble         # get nibble in R0
        ROLB R3
        ROL R0
        INC R0

Save:   MOV R0,R4           # save offset for future

Match:  POP  R0
        ASR  R0
        ASR  R0
        BIC  $0177770,R0        # get 3 bits
        CMP  R0,$7
        BNE  Clone
             CALL Extend
             TSTB R0            # match length
             BEQ Exit

Clone:  MOV  R2,R3
        SUB  R4,R3
        MOVB (R3)+,(R2)+
        INC  R0
1$:     MOVB (R3)+,(R2)+
        SOB  R0,1$
        BR   Token

o9bit:  CLR  R0
        BISB (R1)+,R0
        ROLB R3
        ROL  R0
        INC  R0
        BR   Save

o13bit: CALL Nibble         # get nibble in R0
        ROLB R3
        ROL R0
        SWAB R0
        BISB (R1)+,R0       # 8 bits
        ADD $513,R0
        BR Save

oOther: ROLB R3
        BCS Match
        BISB (R1)+,R0       # read 016 bits
        SWAB R0
        BISB (R1)+,R0
        BR Save


Nibble: COM R5
        BMI 1$
            MOV R5,R0
            CLR R5
            BR 2$
1$:     BICB (R1)+,R5       # read 2 nibbles
        MOV R5,R0
        ASR R0
        ASR R0
        ASR R0
        ASR R0
2$:     BIC $0177760,R0     # leave 4 low bits
        RETURN

Extend: PUSH R0             # save original value
        CALL Nibble         # get nibble in R0
        BNE Ext2
            BISB (R1)+,R0
            BNE Ext1
                # unnecessary for short files
                BISB (R1)+,R0   # read high byte
                SWAB R0
                BISB (R1)+,R0   # read low byte
                TST (SP)+       # skip saved R0
                RETURN
Ext1:       ADD $15,R0
Ext2:   DEC R0
        ADD (SP)+,R0        # add original value
Exit:   RETURN
