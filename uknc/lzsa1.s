#Size-optimized LZSA1 PDP-11 decoder version by Ivan Gorodetsky
#
#usage:
# mov $src_adr,r1
# mov $dst_adr,r2
# jsr pc,unlzsa1
#
#v 1.0 - 2019-10-20
#v 1.1 - 2019-10-22 (-4 bytes)
#v 1.2 - 2019-10-24 (-2 bytes)
#v 1.3 - 2020-04-24 (+4 bytes; Counter bug fixed, thanks to Nikita Zeemin for bugreport)
#
#compress with <-f1 -r> options
#156 bytes
#
#  LZSA compression algorithms are (c) 2019 Emmanuel Marty,
#  see https://github.com/emmanuel-marty/lzsa for more information
#
#  This software is provided 'as-is', without any express or implied
#  warranty.  In no event will the authors be held liable for any damages
#  arising from the use of this software.
#
#  Permission is granted to anyone to use this software for any purpose,
#  including commercial applications, and to alter it and redistribute it
#  freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you must not
#     claim that you wrote the original software. If you use this software
#     in a product, an acknowledgment in the product documentation would be
#     appreciated but is not required.
#  2. Altered source versions must be plainly marked as such, and must not be
#     misrepresented as being the original software.
#  3. This notice may not be removed or altered from any source distribution.
                
        
unlzsa1:

    ReadToken:
                CLRB Counter+1
                MOVB (R1)+,R0
                MOV  R0,R5
                BIC  $0xFF8F,R0
                BEQ  NoLiterals
                ASH  $-4,R0
                CMP  $7,R0
                BNE  m1
                JSR  PC,ReadLong
        m1:
                MOVB R0,Counter+0
                MOV  Counter,R3
        100$:
                MOVB (R1)+,(R2)+
                SOB  R3,100$
    NoLiterals:
                MOVB (R1)+,Offset+0
                MOVB $0xFF,Offset+1
                MOVB R5,R0
                BPL  ShortOffset
    LongOffset:
                MOVB (R1)+,Offset+1
    ShortOffset:
                CLRB Counter+1
                BIC  $0xFFF0,R0
                ADD  $3,R0
                CMP  $18,R0
                BNE  1$
                JSR  PC,ReadLong

        1$:     MOVB R0,Counter+0
                MOV  R1,R4
                MOV  Offset,R1
                ADD  R2,R1
                MOV  Counter,R3
        100$:
                MOVB (R1)+,(R2)+
                SOB  R3,100$
                MOV  R4,R1
                BR   ReadToken
    ReadLong:
                MOVB (R1)+,R4
                BIS  $0xFF00,R4
                ADD  R4,R0
                BCC  1$
                MOVB R0,Counter+1
                MOVB (R1)+,R0
                TSTB Counter+1
                BEQ  2$

        1$:     RTS  PC

        2$:     MOVB R0,Counter+0
                MOVB (R1)+,Counter+1
                TST  Counter
                BEQ  3$
                RTS  PC

        3$:     MOV  (SP)+,R4
                RTS  PC
                                
Counter:       .word 0
Offset:        .word 0
