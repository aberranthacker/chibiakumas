# vim: set fileformat=unix filetype=gas tabstop=8 expandtab shiftwidth=4 autoindent :
                .macro .exit
                    EMT 0350
                .endm

                .macro .cout addr
                    MOV \addr,R0
                    EMT 0351
                .endm

                .macro call addr
                    JSR PC,\addr
                .endm

                .macro return
                    RTS PC
                .endm

                .macro push reg
                    MOV  \reg,-(SP)
                .endm

                .macro pop reg
                    MOV  (SP)+,\reg
                .endm
