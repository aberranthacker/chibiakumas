/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

                           Compiled Sprite Viewer 

    Compiled sprites are just machine code programs to render loading/continue
etc screens we run them from here to allow the 64k override to be standardised
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

CLS:
        MOV  R0,-(SP)
        MOV  R1,-(SP)
        MOV  R2,-(SP)

        # clear the screen
        CLR  R0
        MOV  $8000>>4,R1
        MOV  @$ScreenBuffer_ActiveScreen,R2
100$: 
       .rept 1<<4
        MOV  R0,(R2)+
       .endr
        SOB  R1,100$

        MOV  (SP)+,R2
        MOV  (SP)+,R1
        MOV  (SP)+,R0
RETURN
                                                            # CLS:
                                                            #   ld a,(ScreenBuffer_ActiveScreen)
                                                            # CLSB:
                                                            #   ld h,a
                                                            #   ld d,a
                                                            #   ld e,&01
                                                            #   ld BC,&3FCF
                                                            #   xor a
                                                            #   ld l,a
                                                            #   ld (hl),a
                                                            #   ldir
                                                            # ret

                                                            # ShowCompiledSprite: ; show compiled sprite A
                                                            #     ld l,a
                                                            ##ifdef Support64k
                                                            #     ld a,(CPCVer) ; 464 can't do comiled sprites, so just CLS
                                                            #     and 128
                                                            #     jr z,cls
                                                            ##endif
                                                            #     push hl
                                                            #     call Akuyou_RasterColors_DefaultSafe
                                                            #     pop hl
                                                            # 
                                                            #     ld a,&C6 ;Compiled sprites are in bank 6
                                                            #     ld h,&40
                                                            #     call BankSwitch_C0_CallHL
                                                            # ret
