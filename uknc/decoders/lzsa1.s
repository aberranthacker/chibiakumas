# Size-optimized LZSA1 PDP-11 decoder version by Ivan Gorodetsky
# https://gitlab.com/ivagor/lzsa8080/-/blob/master/PDP11/LZSA1/lzsa1.asm
#
# usage:
#  mov #src_adr,r1
#  mov #dst_adr,r2
#  jsr pc,unlzsa1
#
# v 1.0  - 2019-10-20
# v 1.1  - 2019-10-22 (-4 bytes)
# v 1.2  - 2019-10-24 (-2 bytes)
# v 1.3  - 2020-04-24 (+4 bytes; Counter bug fixed, thanks to Nikita Zeemin for bugreport)
# v 1.4  - 2020-04-27 (-8 bytes and slightly faster)
# v 1.5  - 2020-04-27 (-4 bytes and slightly faster)
# v 1.6  - 2020-04-29 (-18 bytes, significantly faster and self-modifying code completly removed)
# v 1.61 - 2020-04-29 (-2 bytes, excess command removed)
#
# compress with <-f1 -r> options
# 124 bytes
#
#   LZSA compression algorithms are (c) 2019 Emmanuel Marty,
#   see https://github.com/emmanuel-marty/lzsa for more information
#
#   This software is provided 'as-is', without any express or implied
#   warranty.  In no event will the authors be held liable for any damages
#   arising from the use of this software.
#
#   Permission is granted to anyone to use this software for any purpose,
#   including commercial applications, and to alter it and redistribute it
#   freely, subject to the following restrictions:
#
#   1. The origin of this software must not be misrepresented; you must not
#      claim that you wrote the original software. If you use this software
#      in a product, an acknowledgment in the product documentation would be
#      appreciated but is not required.
#   2. Altered source versions must be plainly marked as such, and must not be
#      misrepresented as being the original software.
#   3. This notice may not be removed or altered from any source distribution.

unlzsa1:
                MOV  $0xFF00,R4
                CLR  R3
unlzsa1_ReadToken:
                MOVB (R1)+,R0
                MOV  R0,R5
                BIC  $0xFF8F,R0
                BEQ  unlzsa1_NoLiterals
                ASR  R0
                ASR  R0
                ASR  R0
                ASR  R0
                CMP  R0,$7
                BNE  unlzsa1_m1
                JSR  PC,unlzsa1_ReadLong
unlzsa1_m1:
                BISB R0,R3
unlzsa1_bc1:
                MOVB (R1)+,(R2)+
                SOB  R3,unlzsa1_bc1
unlzsa1_NoLiterals:
                MOVB R5,R0
                MOV  R4,R5
                BISB (R1)+,R5
                TST  R0
                BPL  unlzsa1_ShortOffset
#LongOffset:
                BIC  R4,R5
                SWAB R5
                BISB (R1)+,R5
                SWAB R5
unlzsa1_ShortOffset:
                BIC  $0xFFF0,R0
                ADD  $3,R0
                CMP  R0,$18
                BNE  unlzsa1_m2
                JSR  PC,unlzsa1_ReadLong
unlzsa1_m2:
                BISB R0,R3
                ADD  R2,R5
unlzsa1_bc2:
                MOVB (R5)+,(R2)+
                SOB  R3,unlzsa1_bc2
                BR   unlzsa1_ReadToken
unlzsa1_ReadLong:
                MOVB (R1)+,R3
                BIS  R4,R3
                ADD  R3,R0
                BCC  unlzsa1_m3

                MOV  R0,R3
                CLR  R0
                BISB (R1)+,R0
                SWAB R3
                BIC  $0xFF,R3
                BNZ  1237$

                MOVB (R1)+,R3
                BIC  R4,R3
                SWAB R3
                BISB R0,R3
                BNZ  1237$

                MOV  (SP)+,R4
unlzsa1_m3:
                CLR  R3
1237$:
                RTS  PC

