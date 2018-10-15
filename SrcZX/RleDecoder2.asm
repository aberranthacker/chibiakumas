write "..\BldZX\spectest.bin"




org &8000

list
FirstByte:

ld hl,PicEyeCatch_Chibikopng_rledata-1
ld de,PicEyeCatch_Chibikopng_rledataEnd-1
ld b,0*8 ; y start
ld ixh,256/8	;width
ld IXL,32-1	;Y screen pos
push ix
	di
	call RLE_Draw
pop ix
ld hl,color_rledata-1
ld de,color_rledataEnd-1
ld b,0

call RLE_Draw_Color
di
halt


read "Akuyou_Spectrum_RLE.asm"


color_rledata:
db &F,&21,&0,&8,&47,&F,&21,&0,&8,&47,&F,&21,&0,&8,&47,&F
db &21,&0,&8,&47,&F,&21,&0,&8,&47,&F,&21,&0,&8,&47,&F,&21
db &0,&8,&47,&F,&21,&0,&8,&47,&F,&21,&0,&8,&47,&F,&21,&0
db &8,&47,&F,&21,&0,&8,&47,&F,&21,&0,&8,&47,&F,&21,&0,&8
db &47,&F,&21,&0,&8,&47,&F,&21,&0,&8,&47,&F,&21,&0,&8,&47
db &F,&21,&0,&8,&43,&F,&21,&0,&3,&43,&40,&47,&43,&47,&43,&31
db &F,&22,&10,&43,&20,&47,&47,&20,&43,&43,&20,&47,&47,&31,&F,&22
db &0,&7,&43,&31,&F,&22,&70,&43,&47,&42,&47,&42,&47,&7,&31,&F
db &22,&10,&43,&0,&5,&47,&10,&7,&31,&F,&22,&20,&47,&47,&0,&4
db &7,&20,&47,&47,&F,&21,&0,&7,&3,&31,&1

color_rledataEnd:
























PicEyeCatch_Chibikopng_rledata:

db &F,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF
db &FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF,&FF
db &FF,&42,&AE,&F,&22,&C1,&FE,&31,&F,&21,&E1,&FE,&71,&F,&21,&E1
db &FE,&71,&F,&21,&10,&7E,&C,&10,&BE,&F,&21,&10,&3F,&2,&10,&F8
db &11,&2,&E1,&31,&2,&31,&10,&7C,&F,&21,&10,&1E,&2,&41,&5,&30
db &2C,&50,&B8,&F,&21,&F1,&2,&61,&31,&6,&31,&20,&60,&70,&F,&21
db &E1,&2,&C1,&2,&61,&4,&41,&20,&60,&B0,&F,&21,&F1,&2,&31,&20
db &C0,&1,&F1,&2,&81,&20,&32,&70,&F,&21,&10,&E,&C1,&5,&10,&78
db &2,&20,&3B,&B0,&F,&21,&10,&F,&41,&9,&20,&2C,&70,&F,&21,&10
db &E,&31,&4,&31,&71,&4,&21,&10,&B0,&F,&21,&10,&F,&21,&2,&31
db &20,&C0,&18,&3,&21,&10,&70,&F,&21,&20,&E,&1,&E1,&4,&21,&3
db &41,&10,&B1,&F,&21,&10,&8F,&2,&11,&4,&41,&3,&C1,&10,&71,&F
db &21,&20,&CE,&80,&A,&10,&B1,&F,&21,&50,&4F,&60,&38,&40,&E0,&4
db &10,&71,&F,&21,&50,&4E,&30,&1E,&3F,&C0,&71,&3,&10,&B2,&F,&21
db &20,&4F,&80,&71,&5,&10,&3F,&2,&10,&72,&F,&21,&20,&2E,&C0,&11
db &5,&30,&78,&2,&B2,&F,&21,&20,&2F,&70,&7,&E1,&20,&4,&72,&F
db &21,&30,&6E,&38,&1C,&2,&11,&2,&C1,&20,&9,&B4,&F,&21,&80,&2F
db &8C,&61,&C1,&80,&82,&13,&74,&F,&21,&10,&4E,&1,&A4,&31,&41,&52
db &11,&20,&7,&B4,&F,&21,&10,&4F,&1,&52,&1,&50,&B4,&80,&2A,&8
db &74,&F,&21,&60,&4E,&8,&F8,&4B,&7F,&40,&2,&10,&B4,&F,&21,&10
db &4F,&1,&F3,&10,&97,&F3,&11,&2,&10,&74,&F,&21,&10,&8E,&D1,&F2
db &31,&10,&48,&1,&F3,&20,&1,&B4,&F,&21,&80,&F,&3E,&C0,&10,&C
db &F8,&3,&74,&F,&21,&E1,&3,&60,&C3,&20,&C6,&C0,&20,&B4,&F,&21
db &F1,&3,&30,&CB,&10,&C6,&2,&20,&18,&74,&F,&21,&E1,&2,&11,&60
db &C3,&30,&D6,&C0,&4,&B4,&F,&21,&F1,&2,&11,&60,&C3,&30,&C6,&C0
db &19,&70,&F,&21,&E1,&2,&31,&60,&E7,&30,&C6,&E0,&24,&B0,&F,&21
db &F1,&2,&31,&20,&FE,&38,&E2,&30,&E0,&29,&70,&F,&21,&E1,&2,&61
db &60,&7C,&38,&FC,&F0,&6C,&B0,&F,&21,&F1,&2,&51,&10,&38,&20,&7C
db &7C,&30,&F8,&69,&70,&F,&21,&E1,&2,&A1,&2,&10,&FE,&2,&30,&FE
db &3E,&B0,&F,&21,&F1,&2,&C1,&2,&10,&EF,&2,&30,&7F,&3F,&70,&F
db &21,&E1,&2,&A1,&F2,&71,&F4,&B1,&20,&1E,&B0,&F,&21,&F1,&2,&41
db &F2,&71,&F4,&51,&20,&E,&72,&F,&21,&E1,&2,&81,&E1,&F2,&E1,&F3
db &A1,&20,&12,&B2,&F,&21,&F1,&3,&D1,&F5,&52,&3,&61,&F,&21,&61
db &3,&A1,&F5,&A2,&20,&12,&80,&F,&21,&71,&3,&20,&F4,&87,&71,&42
db &51,&20,&23,&40,&F,&21,&21,&3,&10,&E9,&F1,&3,&10,&2A,&3,&81
db &F,&21,&11,&3,&50,&52,&1F,&78,&15,&20,&F,&23,&C1,&3,&40,&92
db &7A,&3C,&2A,&F,&25,&10,&53,&2,&12,&30,&F5,&1,&25,&2,&10,&1C
db &F,&21,&30,&BF,&30,&62,&A4,&2,&20,&28,&6E,&F,&21,&30,&FE,&7C
db &9C,&11,&53,&2,&10,&52,&32,&F,&21,&C1,&F2,&71,&41,&22,&1,&81
db &22,&1,&20,&87,&1D,&F,&22,&F2,&71,&2,&10,&7C,&2,&10,&7,&F3
db &F,&23,&C1,&50,&3F,&40,&80,&B5,&2,&F2,&71,&F,&24,&10,&BF,&20
db &40,&40,&30,&62,&1,&FE,&F,&23,&81,&2,&12,&C1,&30,&20,&80,&4
db &41,&12,&81,&F,&21,&80,&1B,&A0,&89,&40,&8,&3,&1A,&60,&F,&21
db &10,&3E,&1,&42,&2,&21,&10,&80,&2,&20,&27,&B8,&F,&21,&10,&7F
db &1,&82,&9,&10,&5C,&F,&21,&E1,&FE,&21,&F,&21,&E1,&FD,&10,&57
db &F,&21,&10,&BC,&AD,&21,&F,&22,&5E,&1
PicEyeCatch_Chibikopng_rledataEnd: defb 0







limit &BF00
LastByte:defb 1