org &8000

nolist
FirstByte:
jp PicEp2Intropng
jp PicEp2IntroRedrawpng

PicEp2Intropng:
ld hl,PicEp2Intropng_rledata-1
ld de,PicEp2Intropng_rledataEnd-1
ld b,0
ld ixh,80
ld IXL,79
di
exx 
push bc
exx
jp RLE_Draw
PicEp2Intropng_rledata:

defb &F,&a8
defb &81
defb &C4
defb &41
defb &F,&66
defb &51
defb &F,&12
defb &81
defb &CA
defb &41
defb &F,&63
defb &A1
defb &F,&11
defb &C3
defb &10,&FE
defb &C9
defb &F,&5d
defb &51
defb &F,&15
defb &C2
defb &10,&FE

defb &D1
defb &CB
defb &F,&5c
defb &A1
defb &F2
defb &F,&12
defb &81
defb &C2
defb &10,&73
defb &8
defb &C4
defb &41
defb &F,&55
defb &F1
defb &3
defb &F3
defb &4
defb &A1
defb &F,&e
defb &10,&E0
defb &F2
defb &B
defb &81
defb &C3
defb &F,&56
defb &51
defb &4
defb &A1
defb &4
defb &A1
defb &F,&e
defb &10,&FC

defb &D1
defb &D
defb &81
defb &C2
defb &41
defb &F,&55
defb &A1
defb &5
defb &51
defb &3
defb &A1
defb &F,&d
defb &C1
defb &10,&F6

defb &41
defb &E
defb &81
defb &C2
defb &F,&33
defb &81
defb &C2
defb &F,&10
defb &A1
defb &5
defb &51
defb &3
defb &A1
defb &F,&c
defb &20,&E0,&F3
defb &F,&1
defb &C2
defb &41
defb &F,&32
defb &10,&EC

defb &D1
defb &F,&10
defb &51
defb &5
defb &A1
defb &3
defb &A1
defb &F,&c
defb &C3
defb &41
defb &F,&1
defb &81
defb &C2
defb &F,&32
defb &20,&E4,&72
defb &F,&e
defb &A1
defb &4
defb &10,&11

defb &A1
defb &3
defb &51
defb &F,&c
defb &C2
defb &41
defb &F,&2
defb &81
defb &C2
defb &F,&32
defb &20,&E4,&70
defb &F,&e
defb &A1
defb &2
defb &20,&77,&22

defb &A1
defb &2
defb &F1
defb &5
defb &81
defb &C3
defb &41
defb &F,&3
defb &10,&70
defb &F,&4
defb &C2
defb &41
defb &F,&31
defb &20,&E4,&70
defb &F,&f
defb &F2
defb &3
defb &52
defb &8
defb &C1
defb &F3
defb &C1
defb &41
defb &F,&1
defb &81
defb &10,&70
defb &F,&4
defb &81
defb &C2
defb &F,&31
defb &10,&E8
defb &C2
defb &F,&14
defb &A1
defb &51
defb &7
defb &10,&E8
defb &C3
defb &F1
defb &10,&70
defb &F,&0
defb &C7
defb &41
defb &F,&0
defb &C2
defb &41
defb &A
defb &31
defb &11
defb &F,&25
defb &E1
defb &C2
defb &F,&1d
defb &81
defb &C5
defb &10,&F3
defb &F,&0
defb &CB
defb &81
defb &B
defb &10,&E8

defb &D1
defb &9
defb &32
defb &91
defb &F,&25
defb &E1
defb &C2
defb &7
defb &81
defb &10,&70
defb &2
defb &81
defb &C2
defb &2
defb &81
defb &10,&70

defb &81
defb &C3
defb &10,&10

defb &81
defb &C5
defb &41
defb &C3
defb &81
defb &C2
defb &3
defb &C2
defb &42
defb &10,&80
defb &C3
defb &D1
defb &41
defb &C
defb &81
defb &CF,&1
defb &41
defb &8
defb &C1
defb &D1
defb &8
defb &21
defb &32
defb &10,&61
defb &F,&24
defb &81
defb &10,&F1

defb &41
defb &6
defb &C1
defb &10,&F3
defb &2
defb &70,&E8,&73,&80,&73,&E8,&F7,&10

defb &C1
defb &F3
defb &70,&F1,&90,&71,&E8,&70,&80,&F6

defb &41
defb &4
defb &C2
defb &E1
defb &41
defb &B
defb &81
defb &CF,&3
defb &41
defb &7
defb &C1
defb &D1
defb &8
defb &22
defb &31
defb &10,&E1
defb &F,&24
defb &81
defb &10,&F1

defb &41
defb &5
defb &10,&E8
defb &C2
defb &41
defb &2
defb &E1
defb &C2
defb &30,&80,&71,&C8
defb &C2
defb &10,&80

defb &E1
defb &C5
defb &60,&80,&71,&C0,&71,&80,&F1
defb &5
defb &81
defb &C2
defb &D1
defb &A
defb &81
defb &C3
defb &41
defb &C
defb &C4
defb &41
defb &6
defb &81
defb &10,&72
defb &7
defb &23
defb &10,&B4

defb &41
defb &F,&23
defb &81
defb &10,&F1

defb &41
defb &5
defb &10,&F4
defb &C3
defb &2
defb &81
defb &f0,&0,&F1,&80,&71,&80,&71,&80,&F2,&80,&70,&80,&71,&80,&71,&80,&71
defb &6
defb &C2
defb &D1
defb &9
defb &C4
defb &41
defb &F,&0
defb &C4
defb &6
defb &10,&72
defb &7
defb &23
defb &10,&78

defb &41
defb &F,&24
defb &E1
defb &C2
defb &5
defb &10,&F2

defb &81
defb &C2
defb &3
defb &70,&F2,&90,&71,&80,&71,&80,&72
defb &2
defb &70,&70,&80,&71,&80,&71,&80,&71
defb &6
defb &20,&E0,&72
defb &7
defb &81
defb &C3
defb &F,&3
defb &81
defb &C2
defb &41
defb &5
defb &10,&72
defb &7
defb &23
defb &10,&B4

defb &C1
defb &F,&24
defb &E1
defb &C2
defb &4
defb &81
defb &10,&F2

defb &1
defb &C2
defb &41
defb &2
defb &70,&E4,&90,&71,&80,&71,&80,&F2
defb &2
defb &70,&70,&80,&71,&80,&71,&80,&71
defb &6
defb &20,&E0,&72
defb &7
defb &E1
defb &10,&70
defb &F,&6
defb &C2
defb &41
defb &4
defb &10,&E6
defb &7
defb &23
defb &10,&68

defb &C1
defb &F,&24
defb &10,&E4

defb &C1
defb &4
defb &81
defb &30,&71,&80,&70
defb &2
defb &50,&E4,&B0,&71,&80,&71
defb &2
defb &90,&F4,&10,&70,&80,&71,&80,&71,&80,&71
defb &7
defb &C1
defb &10,&72
defb &6
defb &10,&E4

defb &C1
defb &E
defb &81
defb &C4
defb &4
defb &10,&FC

defb &41
defb &3
defb &10,&E4
defb &8
defb &21
defb &2
defb &C1
defb &10,&61
defb &F,&23
defb &10,&E4

defb &C1
defb &4
defb &81
defb &30,&71,&80,&70
defb &2
defb &50,&E8,&B0,&71,&80,&71
defb &2
defb &90,&E8,&30,&70,&80,&71,&80,&F1,&C0,&71
defb &7
defb &C2
defb &41
defb &5
defb &81
defb &10,&F2
defb &C
defb &20,&71,&80

defb &E1
defb &F2
defb &C2
defb &4
defb &C1
defb &10,&71
defb &3
defb &C1
defb &41
defb &7
defb &30,&7,&80,&52
defb &F,&24
defb &E1
defb &10,&70
defb &3
defb &81
defb &30,&71,&80,&70
defb &3
defb &C1
defb &40,&F1,&71,&80,&71
defb &3
defb &C1
defb &D1
defb &C2
defb &41
defb &30,&80,&71,&80

defb &D1
defb &C3
defb &10,&71
defb &7
defb &C2
defb &41
defb &5
defb &C1
defb &10,&71
defb &3
defb &81
defb &C2
defb &6
defb &50,&F3,&90,&F4,&FE,&70
defb &4
defb &10,&F3
defb &3
defb &C1
defb &41
defb &7
defb &30,&4A,&10,&70
defb &F,&24
defb &E1
defb &10,&70
defb &3
defb &81
defb &D1
defb &3
defb &10,&70
defb &3
defb &81
defb &40,&F1,&71,&80,&71
defb &3
defb &81
defb &E1
defb &C2
defb &41
defb &60,&80,&71,&80,&F9,&F3,&71
defb &7
defb &C2
defb &41
defb &4
defb &10,&E8

defb &C1
defb &3
defb &81
defb &C3
defb &6
defb &40,&F6,&90,&F4,&C8
defb &C2
defb &41
defb &3
defb &10,&EC

defb &41
defb &2
defb &81
defb &41
defb &7
defb &30,&82,&21,&70
defb &F,&24
defb &E1
defb &C2
defb &3
defb &81
defb &D1
defb &3
defb &10,&70
defb &3
defb &81
defb &C2
defb &30,&71,&80,&71
defb &3
defb &81
defb &D1
defb &C2
defb &41
defb &30,&80,&71,&80

defb &D1
defb &C3
defb &10,&71
defb &6
defb &81
defb &C2
defb &41
defb &4
defb &10,&F4

defb &41
defb &3
defb &10,&E8
defb &C2
defb &6
defb &40,&FC,&B0,&FC,&10
defb &C2
defb &41
defb &4
defb &A1
defb &51
defb &2
defb &81
defb &C1
defb &4
defb &81
defb &C2
defb &40,&2,&42,&30,&60
defb &F,&22
defb &81
defb &10,&F1
defb &3
defb &81
defb &D1
defb &3
defb &10,&70
defb &3
defb &C3
defb &30,&71,&80,&71
defb &3
defb &C4
defb &41
defb &30,&80,&71,&80

defb &D1
defb &C3
defb &10,&71
defb &6
defb &81
defb &C2
defb &41
defb &4
defb &10,&F6
defb &3
defb &81
defb &10,&FE

defb &41
defb &8
defb &C1
defb &40,&F7,&F8,&10,&E0

defb &41
defb &4
defb &81
defb &C1
defb &2
defb &81
defb &C1
defb &3
defb &81
defb &C3
defb &61
defb &5
defb &C3
defb &F,&21
defb &81
defb &10,&F1
defb &3
defb &81
defb &30,&71,&80,&70
defb &2
defb &50,&E8,&B0,&71,&80,&71
defb &2
defb &90,&E4,&30,&70,&80,&71,&80,&F1,&C0,&71
defb &6
defb &C3
defb &4
defb &81
defb &10,&73
defb &3
defb &C1
defb &F1
defb &A
defb &81
defb &10,&F8
defb &F2
defb &41
defb &9
defb &10,&70
defb &2
defb &C1
defb &2
defb &81
defb &C1
defb &93
defb &10,&D2
defb &3
defb &81
defb &63
defb &41
defb &F,&21
defb &10,&F2
defb &3
defb &81
defb &30,&71,&80,&70
defb &2
defb &50,&E4,&B0,&71,&80,&71
defb &2
defb &90,&F2,&10,&70,&80,&71,&80,&71,&80,&71
defb &5
defb &81
defb &E1
defb &C2
defb &4
defb &C1
defb &10,&71
defb &2
defb &10,&E8

defb &41
defb &A
defb &81
defb &C4
defb &41
defb &9
defb &10,&60
defb &2
defb &C1
defb &2
defb &C1
defb &64
defb &20,&78,&90
defb &C2
defb &93
defb &C1
defb &F,&21
defb &10,&F2
defb &3
defb &81
defb &C2
defb &20,&80,&70
defb &2
defb &70,&E4,&90,&71,&80,&71,&80,&F2
defb &2
defb &70,&70,&80,&71,&80,&71,&80,&71
defb &5
defb &C1
defb &10,&F1

defb &41
defb &4
defb &C2
defb &3
defb &10,&FC
defb &C
defb &C4
defb &41
defb &9
defb &10,&E0
defb &2
defb &20,&30,&E
defb &C5
defb &91
defb &10,&90
defb &63
defb &31
defb &10,&D2
defb &F,&27
defb &C2
defb &10,&D0

defb &D1
defb &3
defb &70,&F2,&90,&71,&80,&70,&80,&71
defb &2
defb &a0,&70,&80,&71,&80,&71,&80,&71,&40,&80,&F8
defb &C2
defb &41
defb &3
defb &10,&E0

defb &41
defb &3
defb &10,&76
defb &2
defb &C4
defb &41
defb &6
defb &C3
defb &41
defb &A
defb &C1
defb &2
defb &20,&70,&E

defb &C1
defb &2
defb &81
defb &C2
defb &20,&90,&B4

defb &31
defb &93
defb &11
defb &F,&21
defb &C1
defb &41
defb &3
defb &20,&F8,&F8

defb &C1
defb &2
defb &81
defb &f0,&0,&F2,&80,&70,&80,&70,&80,&F1,&80,&70,&80,&71,&80,&71,&80,&71

defb &81
defb &C3
defb &10,&F7
defb &C2
defb &4
defb &10,&E0
defb &4
defb &E1
defb &2
defb &81
defb &C6
defb &41
defb &B
defb &C3
defb &4
defb &C1
defb &2
defb &10,&60
defb &32
defb &41
defb &4
defb &81
defb &40,&10,&4A,&43,&40

defb &11
defb &F,&20
defb &10,&E8

defb &D1
defb &3
defb &20,&E0,&F7

defb &41
defb &2
defb &C1
defb &40,&F1,&80,&70,&C8
defb &C2
defb &10,&80

defb &E1
defb &C5
defb &70,&80,&71,&C0,&71,&80,&F1,&E8
defb &F2
defb &C3
defb &41
defb &4
defb &10,&E0
defb &6
defb &81
defb &C9
defb &41
defb &7
defb &81
defb &C5
defb &41
defb &2
defb &C1
defb &30,&10,&60,&85
defb &8
defb &30,&2C,&21,&B

defb &11
defb &F,&20
defb &10,&E4

defb &C1
defb &4
defb &C3
defb &2
defb &50,&E8,&70,&80,&70,&E4
defb &C2
defb &10,&10
defb &C6
defb &50,&90,&71,&E8,&70,&80
defb &C2
defb &41
defb &C5
defb &41
defb &5
defb &10,&70
defb &6
defb &81
defb &C2
defb &2
defb &81
defb &C6
defb &6
defb &C7
defb &41
defb &30,&80,&30,&60
defb &12
defb &2
defb &81
defb &C2
defb &4
defb &62
defb &21
defb &32
defb &21
defb &F,&20
defb &10,&E4

defb &C1
defb &4
defb &81
defb &10,&70
defb &2
defb &81
defb &C2
defb &2
defb &81
defb &10,&70

defb &81
defb &C3
defb &10,&10

defb &81
defb &C5
defb &41
defb &C3
defb &81
defb &C2
defb &2
defb &81
defb &C2
defb &10,&90
defb &C3
defb &41
defb &6
defb &10,&70
defb &6
defb &10,&E0
defb &6
defb &81
defb &C3
defb &5
defb &81
defb &C2
defb &41
defb &3
defb &C2
defb &30,&80,&30,&60
defb &12
defb &2
defb &C2
defb &91
defb &2
defb &81
defb &2
defb &11
defb &33
defb &81
defb &F,&21
defb &C1
defb &41
defb &F,&26
defb &C1
defb &F,&2
defb &C2
defb &41
defb &4
defb &81
defb &C2
defb &5
defb &C1
defb &40,&90,&30,&20,&7
defb &2
defb &62
defb &C2
defb &10,&90
defb &2
defb &20,&18,&7

defb &21
defb &F,&57
defb &81
defb &C1
defb &2
defb &81
defb &41
defb &E
defb &81
defb &D
defb &81
defb &20,&30,&30
defb &40,&20,&8F,&90,&3C
defb &92
defb &40,&80,&30,&20,&D

defb &81
defb &F,&57
defb &81
defb &51
defb &2
defb &81
defb &41
defb &4
defb &C1
defb &F,&9
defb &50,&B0,&30,&20,&C3,&B1
defb &63
defb &C1
defb &30,&80,&70,&40

defb &21
defb &32
defb &F,&57
defb &81
defb &51
defb &2
defb &C1
defb &41
defb &4
defb &81
defb &C1
defb &2
defb &C2
defb &F,&5
defb &81
defb &40,&10,&20,&87,&B2
defb &32
defb &50,&61,&C0,&61,&80,&2D

defb &91
defb &F,&57
defb &E1
defb &51
defb &2
defb &E1
defb &41
defb &5
defb &81
defb &C7
defb &9
defb &C3
defb &41
defb &2
defb &81
defb &2
defb &70,&30,&20,&86,&B1,&1E,&52,&C0
defb &62
defb &20,&10,&6

defb &31
defb &F,&57
defb &E1
defb &41
defb &2
defb &E1
defb &4
defb &CB
defb &7
defb &C6
defb &10,&C0
defb &2
defb &C1
defb &3
defb &20,&E,&F2
defb &92
defb &50,&30,&E0,&87,&30,&2

defb &31
defb &F,&56
defb &10,&E8
defb &2
defb &10,&E4
defb &4
defb &81
defb &C3
defb &4
defb &81
defb &C3
defb &F1
defb &3
defb &F1
defb &C3
defb &2
defb &C3
defb &41
defb &10,&20

defb &C1
defb &3
defb &60,&E,&F4,&D2,&10,&78,&4B
defb &C2
defb &10,&2

defb &31
defb &F,&56
defb &10,&E8
defb &2
defb &10,&E6
defb &5
defb &C2
defb &4
defb &31
defb &2
defb &10,&E0

defb &E1
defb &F3
defb &D1
defb &C2
defb &4
defb &81
defb &C3
defb &41
defb &C1
defb &4
defb &31
defb &E1
defb &C2
defb &91
defb &20,&80,&2D
defb &94
defb &20,&96,&7
defb &F,&55
defb &10,&E8
defb &2
defb &10,&72
defb &5
defb &D1
defb &51
defb &3
defb &33
defb &2
defb &C2
defb &F3
defb &C2
defb &2
defb &31
defb &3
defb &20,&E0,&D0

defb &41
defb &4
defb &31
defb &30,&74,&70,&80
defb &62
defb &2
defb &63
defb &C1
defb &10,&7
defb &F,&55
defb &10,&E8
defb &2
defb &10,&72
defb &4
defb &10,&DC

defb &51
defb &2
defb &21
defb &20,&7,&7
defb &40,&80,&F8,&F7,&70

defb &1
defb &33
defb &2
defb &20,&E0,&C0

defb &41
defb &4
defb &31
defb &10,&61

defb &C1
defb &2
defb &C1
defb &50,&25,&6,&87,&96,&7
defb &F,&55
defb &10,&EC
defb &5
defb &51
defb &2
defb &10,&FE

defb &51
defb &2
defb &21
defb &20,&3,&E
defb &2
defb &20,&E0,&F3
defb &2
defb &20,&E,&C

defb &11
defb &2
defb &C1
defb &41
defb &6
defb &31
defb &10,&E5
defb &2
defb &C2
defb &50,&1A,&7,&1E,&D2,&6
defb &F,&55
defb &10,&64
defb &4
defb &30,&66,&80,&FE

defb &51
defb &2
defb &31
defb &20,&1,&E
defb &4
defb &F1
defb &3
defb &20,&6,&8

defb &11
defb &2
defb &41
defb &7
defb &21
defb &20,&CB,&80

defb &C1
defb &92
defb &11
defb &32
defb &92
defb &20,&52,&6
defb &F,&55
defb &10,&64
defb &4
defb &20,&66,&80

defb &E1
defb &F2
defb &2
defb &71
defb &51
defb &2
defb &71
defb &51
defb &3
defb &10,&77
defb &2
defb &20,&37,&8

defb &71
defb &A
defb &22
defb &C1
defb &10,&D1
defb &62
defb &32
defb &40,&C,&1E,&52,&6
defb &F,&55
defb &10,&64
defb &4
defb &20,&77,&80
defb &F3
defb &2
defb &F1
defb &51
defb &2
defb &F1
defb &51
defb &2
defb &A1
defb &10,&77
defb &2
defb &20,&77,&88

defb &F1
defb &2
defb &41
defb &7
defb &22
defb &91
defb &20,&90,&2D
defb &93
defb &31
defb &92
defb &20,&D2,&16
defb &F,&55
defb &10,&60
defb &4
defb &52
defb &10,&80
defb &F3
defb &51
defb &10,&8C

defb &11
defb &2
defb &B1
defb &11
defb &2
defb &A1
defb &F2
defb &2
defb &20,&77,&88

defb &F1
defb &A
defb &22
defb &91
defb &70,&31,&78,&18,&1E,&D2,&E5,&1F
defb &F,&55
defb &10,&60
defb &4
defb &10,&DD
defb &2
defb &F3
defb &51
defb &10,&8

defb &11
defb &2
defb &31
defb &11
defb &2
defb &F3
defb &2
defb &20,&66,&8

defb &B1
defb &2
defb &41
defb &7
defb &22
defb &91
defb &40,&32,&B4,&6,&2D
defb &93
defb &E1
defb &10,&1C
defb &F,&55
defb &10,&E0
defb &4
defb &20,&DD,&11

defb &E1
defb &F3
defb &30,&8,&3,&E
defb &3
defb &F3
defb &40,&11,&E,&C,&1

defb &81
defb &9
defb &40,&86,&31,&60,&6
defb &62
defb &30,&E1,&E4,&C
defb &F,&55
defb &10,&E0
defb &4
defb &20,&DD,&11

defb &A1
defb &F3
defb &20,&11,&7
defb &32
defb &2
defb &A1
defb &F4
defb &1
defb &21
defb &33
defb &20,&1,&60
defb &9
defb &91
defb &20,&32,&60
defb &32
defb &20,&2D,&E1

defb &41
defb &2
defb &31
defb &F,&56
defb &C1
defb &2
defb &30,&20,&BB,&11

defb &A1
defb &F4
defb &1
defb &21
defb &32
defb &11
defb &2
defb &F5
defb &51
defb &1
defb &33
defb &2
defb &D1
defb &A
defb &91
defb &30,&74,&40,&1E
defb &62
defb &10,&E1

defb &D1
defb &2
defb &31
defb &F,&56
defb &C1
defb &2
defb &30,&20,&BB,&33

defb &A1
defb &F4
defb &51
defb &10,&8

defb &11
defb &2
defb &F3
defb &51
defb &F3
defb &2
defb &31
defb &2
defb &A1
defb &10,&70
defb &9
defb &91
defb &20,&70,&C0

defb &31
defb &92
defb &61
defb &11
defb &E2
defb &2
defb &31
defb &F,&56
defb &C1
defb &2
defb &30,&20,&77,&33

defb &A1
defb &F5
defb &51
defb &3
defb &A1
defb &F3
defb &10,&99
defb &F3
defb &51
defb &2
defb &A1
defb &D2
defb &9
defb &60,&86,&F4,&8,&4B,&78,&C3

defb &D1
defb &2
defb &31
defb &F,&56
defb &C1
defb &40,&10,&20,&EE,&66

defb &A1
defb &F2
defb &A1
defb &FB
defb &1
defb &F7
defb &E1
defb &C1
defb &9
defb &30,&96,&F8,&10

defb &31
defb &92
defb &32
defb &E1
defb &3
defb &31
defb &F,&56
defb &C1
defb &20,&10,&60

defb &1
defb &F2
defb &51
defb &A1
defb &F2
defb &1
defb &A1
defb &FA
defb &51
defb &A1
defb &F6
defb &D2
defb &8
defb &81
defb &10,&97
defb &C2
defb &40,&10,&C3,&12,&7
defb &3
defb &31
defb &F,&56
defb &81
defb &30,&10,&60,&C8
defb &F2
defb &E1
defb &F2
defb &2
defb &FA
defb &1
defb &F7
defb &E1
defb &41
defb &8
defb &E1
defb &10,&D6
defb &C3
defb &41
defb &20,&87,&3
defb &32
defb &3
defb &31
defb &F,&56
defb &81
defb &30,&30,&60,&80

defb &D1
defb &F4
defb &2
defb &A1
defb &F8
defb &10,&99
defb &F6
defb &D2
defb &41
defb &7
defb &20,&E4,&DF
defb &C4
defb &30,&6,&83,&4B

defb &C1
defb &2
defb &31
defb &F,&57
defb &C1
defb &2
defb &C1
defb &2
defb &E2
defb &F3
defb &51
defb &10,&66
defb &FF,&2
defb &E1
defb &41
defb &7
defb &81
defb &E2
defb &F2
defb &C3
defb &50,&6,&C3,&4B,&72,&4
defb &F,&57
defb &40,&70,&80,&10,&E4
defb &F3
defb &51
defb &10,&EE

defb &A1
defb &FF,&0
defb &D2
defb &8
defb &10,&F4
defb &F3
defb &D1
defb &C2
defb &50,&6,&B,&4B,&F4,&4
defb &F,&57
defb &30,&E0,&80,&10

defb &81
defb &E2
defb &F3
defb &20,&CC,&88
defb &FE
defb &10,&F2
defb &7
defb &81
defb &E2
defb &F4
defb &C2
defb &10,&2
defb &22
defb &10,&4B
defb &E2
defb &10,&4
defb &F,&57
defb &20,&E0,&80

defb &C1
defb &2
defb &D2
defb &F3
defb &10,&44
defb &3
defb &A1
defb &FB
defb &D2
defb &41
defb &7
defb &C1
defb &D1
defb &F4
defb &D2
defb &1
defb &10,&2
defb &23
defb &1
defb &20,&75,&4
defb &F,&58
defb &C1
defb &2
defb &10,&60

defb &1
defb &E3
defb &F2
defb &51
defb &6
defb &A1
defb &F4
defb &A1
defb &F4
defb &E2
defb &41
defb &A1
defb &5
defb &81
defb &E2
defb &F4
defb &E1
defb &10,&10
defb &20,&2,&2

defb &21
defb &4
defb &11
defb &F,&58
defb &C1
defb &30,&10,&60,&80
defb &D2
defb &F2
defb &51
defb &32
defb &11
defb &8
defb &F5
defb &D2
defb &1
defb &A1
defb &5
defb &10,&F4
defb &F4
defb &D2
defb &4
defb &21
defb &F,&5f
defb &D1
defb &41
defb &2
defb &C1
defb &2
defb &E3
defb &F2
defb &21
defb &32
defb &11
defb &6
defb &F6
defb &E1
defb &10,&10

defb &F1
defb &4
defb &81
defb &E2
defb &F4
defb &10,&F2
defb &F,&64
defb &D1
defb &41
defb &5
defb &81
defb &D2
defb &F2
defb &51
defb &33
defb &11
defb &4
defb &A1
defb &F5
defb &D2
defb &2
defb &F1
defb &4
defb &C1
defb &D1
defb &F4
defb &D2
defb &41
defb &F,&64
defb &D1
defb &C1
defb &6
defb &E3
defb &F2
defb &21
defb &33
defb &3
defb &A1
defb &F5
defb &E2
defb &41
defb &2
defb &F1
defb &3
defb &81
defb &E2
defb &F4
defb &E1
defb &C1
defb &F,&65
defb &F1
defb &10,&70
defb &2
defb &20,&E0,&80
defb &D2
defb &F2
defb &51
defb &33
defb &10,&1

defb &A1
defb &F5
defb &D3
defb &2
defb &A1
defb &F1
defb &3
defb &10,&F4
defb &F4
defb &D2
defb &41
defb &F,&65
defb &F1
defb &10,&F1
defb &2
defb &10,&E0
defb &2
defb &C1
defb &E2
defb &F2
defb &1
defb &32
defb &10,&1
defb &F6
defb &10,&F2

defb &41
defb &2
defb &F2
defb &2
defb &81
defb &E2
defb &F5
defb &C1
defb &F,&65
defb &A1
defb &F2
defb &C1
defb &41
defb &2
defb &C1
defb &41
defb &2
defb &C1
defb &D1
defb &F3
defb &3
defb &F5
defb &D3
defb &41
defb &3
defb &51
defb &20,&66,&C0

defb &D1
defb &F5
defb &10,&71
defb &F,&65
defb &20,&EE,&91

defb &C1
defb &2
defb &C1
defb &41
defb &3
defb &10,&F8
defb &F9
defb &E3
defb &C1
defb &3
defb &20,&33,&66

defb &81
defb &E2
defb &F4
defb &E1
defb &C1
defb &F,&66
defb &20,&EE,&11

defb &C1
defb &2
defb &81
defb &41
defb &4
defb &81
defb &C1
defb &F6
defb &D4
defb &C1
defb &4
defb &33
defb &91
defb &10,&F4
defb &F4
defb &D2
defb &41
defb &F,&66
defb &10,&EE
defb &2
defb &C1
defb &2
defb &81
defb &10,&10

defb &C1
defb &3
defb &81
defb &C2
defb &E4
defb &C3
defb &41
defb &4
defb &35
defb &C1
defb &E2
defb &F3
defb &10,&F2
defb &F,&67
defb &F2
defb &2
defb &C1
defb &2
defb &81
defb &10,&10

defb &C1
defb &6
defb &81
defb &C3
defb &41
defb &5
defb &21
defb &34
defb &20,&E,&E1

defb &D1
defb &F2
defb &D3
defb &F,&67
defb &F2
defb &2
defb &C1
defb &2
defb &81
defb &10,&10

defb &C1
defb &F,&0
defb &21
defb &33
defb &3
defb &32
defb &C1
defb &E2
defb &F1
defb &E2
defb &41
defb &F,&67
defb &10,&77
defb &2
defb &C1
defb &2
defb &C1
defb &41
defb &4
defb &21
defb &10,&61
defb &F2
defb &20,&19,&61
defb &4
defb &33
defb &4
defb &21
defb &31
defb &C2
defb &D4
defb &F,&67
defb &A1
defb &10,&77
defb &2
defb &C1
defb &2
defb &C1
defb &41
defb &3
defb &20,&E,&E1

defb &61
defb &33
defb &10,&69
defb &32
defb &1
defb &33
defb &6
defb &10,&87

defb &C1
defb &E3
defb &41
defb &F,&67
defb &A1
defb &20,&77,&80

defb &C1
defb &2
defb &C1
defb &4
defb &33
defb &C1
defb &41
defb &33
defb &10,&61
defb &35
defb &11
defb &6
defb &32
defb &C2
defb &10,&F1
defb &F,&68
defb &A1
defb &20,&77,&80

defb &C1
defb &2
defb &C1
defb &3
defb &21
defb &20,&7,&80

defb &C1
defb &3
defb &20,&60,&8
defb &33
defb &8
defb &31
defb &91
defb &C2
defb &F,&69
defb &A1
defb &F1
defb &2
defb &81
defb &41
defb &2
defb &C1
defb &2
defb &10,&E

defb &11
defb &3
defb &C1
defb &3
defb &10,&60
defb &2
defb &10,&6
defb &9
defb &21
defb &10,&E1

defb &41
defb &F,&69
defb &F2
defb &2
defb &81
defb &41
defb &4
defb &61
defb &10,&7
defb &4
defb &10,&70
defb &2
defb &10,&E0
defb &E
defb &32
defb &F,&6a
defb &F2
defb &2
defb &81
defb &41
defb &3
defb &81
defb &32
defb &5
defb &10,&E0
defb &3
defb &C1
defb &E
defb &32
defb &F,&6a
defb &F1
defb &51
defb &2
defb &81
defb &41
defb &3
defb &32
defb &7
defb &C1
defb &41
defb &2
defb &C1
defb &E
defb &32
defb &11
defb &F,&69
defb &F1
defb &51
defb &2
defb &81
defb &41
defb &2
defb &21
defb &10,&7
defb &7
defb &81
defb &C1
defb &2
defb &C1
defb &E
defb &10,&E

defb &11
defb &F,&68
defb &10,&EE

defb &51
defb &2
defb &81
defb &10,&90

defb &C1
defb &32
defb &9
defb &20,&70,&C0
defb &5
defb &21
defb &9
defb &31
defb &11
defb &F,&68
defb &10,&EE

defb &51
defb &2
defb &81
defb &41
defb &C2
defb &31
defb &11
defb &9
defb &20,&E0,&C0
defb &5
defb &31
defb &6
defb &21
defb &33
defb &11
defb &F,&68
defb &10,&EE

defb &51
defb &2
defb &81
defb &C2
defb &10,&7
defb &A
defb &81
defb &C3
defb &5
defb &31
defb &4
defb &21
defb &35
defb &11
defb &F,&68
defb &10,&EE
defb &3
defb &81
defb &C2
defb &31
defb &9
defb &31
defb &2
defb &81
defb &C2
defb &41
defb &3
defb &10,&E
defb &3
defb &21
defb &36
defb &F,&69
defb &10,&EE
defb &3
defb &81
defb &10,&78

defb &11
defb &8
defb &21
defb &31
defb &3
defb &C2
defb &41
defb &3
defb &10,&E
defb &2
defb &35
defb &F1
defb &F,&6b
defb &10,&EE
defb &3
defb &81
defb &10,&3C

defb &11
defb &8
defb &21
defb &31
defb &4
defb &81
defb &41
defb &3
defb &10,&E

defb &21
defb &32
defb &51
defb &2
defb &10,&EE
defb &F,&6b
defb &10,&EE
defb &3
defb &C1
defb &10,&1E
defb &9
defb &32
defb &4
defb &81
defb &41
defb &3
defb &10,&E

defb &11
defb &2
defb &A1
defb &2
defb &10,&EE
defb &F,&6b
defb &10,&EE
defb &3
defb &C1
defb &32
defb &9
defb &31
defb &11
defb &4
defb &81
defb &41
defb &3
defb &10,&E

defb &11
defb &2
defb &A1
defb &2
defb &10,&EE
defb &F,&6b
defb &10,&EE
defb &3
defb &C1
defb &31
defb &9
defb &10,&E

defb &11
defb &4
defb &81
defb &C1
defb &3
defb &10,&E

defb &11
defb &2
defb &A1
defb &2
defb &10,&EE
defb &F,&6b
defb &10,&EE
defb &3
defb &C1
defb &31
defb &9
defb &32
defb &6
defb &C1
defb &4
defb &32
defb &2
defb &A1
defb &2
defb &10,&EE
defb &F,&6b
defb &10,&EE
defb &3
defb &C1
defb &33
defb &7
defb &10,&7
defb &6
defb &C2
defb &41
defb &2
defb &32
defb &2
defb &A1
defb &2
defb &10,&EE
defb &F,&6b
defb &10,&EE
defb &3
defb &C1
defb &21
defb &33
defb &6
defb &10,&7
defb &4
defb &81
defb &C3
defb &41
defb &2
defb &32
defb &2
defb &A1
defb &2
defb &10,&EE
defb &F,&61
defb &81
defb &9
defb &10,&EE
defb &3
defb &C1
defb &20,&80,&1E

defb &11
defb &4
defb &21
defb &10,&7
defb &4
defb &81
defb &C2
defb &41
defb &3
defb &32
defb &11
defb &30,&88,&11,&EE
defb &F,&30
defb &81
defb &F,&c
defb &82
defb &8
defb &C1
defb &2
defb &81
defb &3
defb &81
defb &3
defb &81
defb &8
defb &41
defb &10,&EE
defb &3
defb &C1
defb &10,&80
defb &C2
defb &31
defb &4
defb &21
defb &10,&7
defb &6
defb &10,&60
defb &3
defb &21
defb &10,&7
defb &2
defb &20,&11,&EE
defb &F,&30
defb &C1
defb &F,&7
defb &41
defb &4
defb &C1
defb &91
defb &8
defb &C1
defb &2
defb &81
defb &C2
defb &1
defb &10,&60
defb &2
defb &81
defb &4
defb &C2
defb &41
defb &20,&C0,&EE

defb &51
defb &2
defb &C1
defb &30,&88,&F2,&16
defb &3
defb &31
defb &10,&6
defb &6
defb &10,&E0
defb &4
defb &32
defb &4
defb &10,&EE
defb &F,&30
defb &C1
defb &3
defb &41
defb &10,&80
defb &C
defb &20,&30,&10

defb &41
defb &2
defb &C1
defb &30,&40,&30,&60
defb &5
defb &81
defb &4
defb &20,&70,&40
defb &2
defb &10,&20

defb &81
defb &3
defb &30,&60,&48,&EE

defb &51
defb &2
defb &C1
defb &10,&80
defb &D2
defb &10,&78
defb &2
defb &20,&E,&6
defb &6
defb &10,&E0
defb &4
defb &10,&E
defb &4
defb &10,&EE
defb &F,&26
defb &41
defb &2
defb &81
defb &42
defb &4
defb &81
defb &41
defb &2
defb &41
defb &20,&80,&80
defb &20,&10,&10
defb &10,&60

defb &C1
defb &3
defb &20,&30,&30
defb &30,&70,&4,&C0

defb &91
defb &2
defb &41
defb &2
defb &20,&60,&80
defb &2
defb &C1
defb &2
defb &11
defb &10,&84
defb &2
defb &20,&20,&E0

defb &41
defb &2
defb &91
defb &20,&A4,&EE

defb &51
defb &2
defb &C1
defb &10,&10
defb &E2
defb &40,&78,&1,&7,&6
defb &2
defb &31
defb &4
defb &C1
defb &5
defb &31
defb &11
defb &3
defb &10,&EE
defb &F,&24
defb &81
defb &10,&40
defb &2
defb &61
defb &42
defb &4
defb &21
defb &41
defb &2
defb &C1
defb &30,&80,&10,&20

defb &41
defb &2
defb &C1
defb &41
defb &2
defb &81
defb &10,&30

defb &81
defb &2
defb &C1
defb &20,&48,&6

defb &C1
defb &2
defb &61
defb &30,&60,&80,&C0
defb &2
defb &30,&42,&C0,&8
defb &C2
defb &10,&41
defb &2
defb &61
defb &2
defb &61
defb &20,&E0,&CC

defb &51
defb &2
defb &81
defb &10,&10

defb &F1
defb &D2
defb &C1
defb &61
defb &32
defb &1
defb &10,&6
defb &2
defb &10,&7
defb &9
defb &21
defb &31
defb &3
defb &10,&EE
defb &F,&25
defb &30,&D0,&10,&34
defb &00,&3,&20

defb &11
defb &2
defb &91
defb &2
defb &20,&10,&20

defb &C1
defb &2
defb &81
defb &91
defb &2
defb &81
defb &2
defb &90,&E0,&83,&C0,&4B,&61,&34,&C0,&80,&C0
defb &2
defb &50,&E0,&87,&80,&29,&43
defb &2
defb &20,&30,&C3
defb &92
defb &1
defb &F2
defb &2
defb &81
defb &50,&30,&EE,&F2,&1E,&61

defb &21
defb &3
defb &10,&7
defb &A
defb &10,&7
defb &3
defb &F1
defb &F,&22
defb &41
defb &2
defb &20,&10,&70
defb &C2
defb &20,&20,&20
defb &30,&38,&1A,&40
defb &2
defb &50,&38,&24,&E0,&4B,&42
defb &22
defb &41
defb &2
defb &21
defb &10,&60
defb &2
defb &C2
defb &10,&86

defb &61
defb &2
defb &81
defb &80,&90,&80,&10,&68,&C,&80,&34,&6
defb &2
defb &62
defb &20,&4B,&43

defb &1
defb &F2
defb &3
defb &20,&B0,&FE
defb &D3
defb &C2
defb &41
defb &21
defb &3
defb &10,&E
defb &A
defb &10,&E

defb &11
defb &2
defb &F1
defb &51
defb &F,&20
defb &10,&D0
defb &2
defb &30,&30,&61,&A4

defb &61
defb &C2
defb &1
defb &81
defb &C2
defb &61
defb &10,&25
defb &2
defb &60,&34,&25,&C0,&40,&A4,&81

defb &11
defb &2
defb &21
defb &10,&C
defb &2
defb &40,&C1,&48,&61,&80
defb &92
defb &10,&38

defb &41
defb &2
defb &91
defb &40,&48,&81,&25,&3C
defb &3
defb &61
defb &20,&78,&60

defb &1
defb &F2
defb &3
defb &C2
defb &E1
defb &F3
defb &C2
defb &10,&E2

defb &31
defb &4
defb &31
defb &A
defb &21
defb &32
defb &2
defb &F1
defb &51
defb &F,&1e
defb &20,&20,&90
defb &2
defb &20,&42,&30
defb &22
defb &20,&52,&80
defb &C2
defb &10,&1A

defb &C1
defb &3
defb &60,&E1,&24,&4,&14,&80,&90

defb &11
defb &2
defb &21
defb &10,&8
defb &2
defb &30,&41,&40,&42
defb &2
defb &80,&1E,&78,&21,&24,&60,&81,&12,&38
defb &3
defb &31
defb &30,&78,&69,&88

defb &F1
defb &3
defb &C2
defb &A1
defb &F2
defb &D2
defb &41
defb &10,&A2

defb &31
defb &4
defb &31
defb &B
defb &21
defb &20,&7,&CC

defb &51
defb &F,&1e
defb &30,&20,&B0,&D0

defb &81
defb &92
defb &2
defb &13
defb &2
defb &10,&68
defb &32
defb &11
defb &3
defb &40,&82,&70,&4,&14
defb &2
defb &10,&81

defb &11
defb &2
defb &21
defb &10,&B
defb &2
defb &91
defb &43
defb &10,&42
defb &2
defb &50,&16,&25,&21,&2C,&38
defb &2
defb &20,&14,&14
defb &2
defb &50,&E,&20,&E1,&88,&77
defb &2
defb &C2
defb &1
defb &F2
defb &E2
defb &2
defb &81
defb &31
defb &4
defb &31
defb &11
defb &B
defb &21
defb &32
defb &A1
defb &51
defb &F,&1e
defb &20,&20,&20
defb &30,&10,&92,&29

defb &1
defb &CE
defb &1
defb &10,&82
defb &C4
defb &10,&90
defb &CB
defb &41
defb &20,&70,&42
defb &3
defb &11
defb &40,&7,&61,&8,&18
defb &2
defb &20,&14,&1C
defb &2
defb &50,&6,&D2,&69,&88,&77
defb &5
defb &F2
defb &D1
defb &51
defb &3
defb &31
defb &4
defb &21
defb &11
defb &C
defb &21
defb &32
defb &51
defb &F,&1b
defb &41
defb &2
defb &20,&60,&60
defb &30,&1,&16,&29
defb &C3
defb &81
defb &10,&B0
defb &C3
defb &6
defb &81
defb &61
defb &2
defb &81
defb &C2
defb &42
defb &81
defb &C2
defb &41
defb &10,&80
defb &CD
defb &11
defb &10,&84
defb &C2
defb &20,&48,&38
defb &2
defb &20,&34,&4
defb &2
defb &30,&6,&34,&E1
defb &2
defb &10,&77
defb &5
defb &F2
defb &E1
defb &41
defb &3
defb &31
defb &4
defb &21
defb &11
defb &6
defb &21
defb &31
defb &5
defb &32
defb &11
defb &F,&19
defb &41
defb &10,&C0
defb &3
defb &21
defb &20,&40,&1

defb &81
defb &C5
defb &A
defb &10,&60
defb &2
defb &10,&6
defb &F,&3
defb &81
defb &CE
defb &31
defb &C3
defb &41
defb &10,&3C
defb &C3
defb &11
defb &20,&52,&69
defb &2
defb &F2
defb &5
defb &F2
defb &D1
defb &51
defb &2
defb &32
defb &4
defb &21
defb &11
defb &5
defb &21
defb &32
defb &6
defb &31
defb &11
defb &F,&19
defb &41
defb &10,&80
defb &3
defb &21
defb &20,&52,&81
defb &C3
defb &5
defb &10,&E0
defb &3
defb &C1
defb &2
defb &10,&60
defb &2
defb &20,&24,&C0
defb &4
defb &11
defb &A
defb &81
defb &11
defb &8
defb &CF,&1
defb &11
defb &20,&61,&C1
defb &2
defb &F2
defb &5
defb &F3
defb &10,&10

defb &F1
defb &32
defb &4
defb &21
defb &11
defb &5
defb &32
defb &11
defb &6
defb &32
defb &F,&c
defb &10,&20

defb &41
defb &4
defb &C1
defb &10,&80
defb &3
defb &41
defb &10,&E0
defb &3
defb &21
defb &31
defb &C4
defb &41
defb &2
defb &C1
defb &2
defb &81
defb &C2
defb &3
defb &C2
defb &41
defb &10,&E0
defb &2
defb &10,&60

defb &1
defb &62
defb &3
defb &10,&D2
defb &8
defb &10,&38

defb &61
defb &5
defb &20,&70,&E0

defb &41
defb &C2
defb &41
defb &3
defb &21
defb &41
defb &5
defb &10,&2C
defb &C2
defb &10,&29
defb &2
defb &10,&EE

defb &51
defb &4
defb &F2
defb &D1
defb &51
defb &2
defb &21
defb &10,&7
defb &3
defb &21
defb &31
defb &4
defb &32
defb &11
defb &7
defb &21
defb &10,&7
defb &F,&b
defb &20,&20,&10

defb &41
defb &2
defb &91
defb &10,&40
defb &3
defb &41
defb &10,&2D
defb &3
defb &C5
defb &20,&80,&30

defb &41
defb &2
defb &81
defb &10,&90

defb &41
defb &5
defb &10,&E0
defb &3
defb &C1
defb &20,&84,&70
defb &2
defb &92
defb &41
defb &3
defb &10,&34
defb &2
defb &10,&21
defb &92
defb &10,&84
defb &2
defb &10,&70
defb &C2
defb &10,&C0

defb &41
defb &3
defb &10,&E1

defb &11
defb &8
defb &C3
defb &2
defb &10,&EE

defb &51
defb &2
defb &F5
defb &E1
defb &4
defb &A1
defb &4
defb &31
defb &3
defb &10,&E

defb &11
defb &9
defb &10,&7
defb &F,&2
defb &81
defb &41
defb &2
defb &41
defb &10,&40
defb &2
defb &20,&60,&52

defb &C1
defb &2
defb &61
defb &42
defb &3
defb &81
defb &20,&69,&80
defb &C3
defb &41
defb &10,&80
defb &42
defb &2
defb &40,&D0,&61,&20,&10

defb &81
defb &2
defb &82
defb &C1
defb &41
defb &2
defb &C1
defb &10,&42
defb &3
defb &21
defb &60,&78,&10,&E0,&D2,&2,&12
defb &63
defb &C2
defb &2
defb &C2
defb &1
defb &20,&E0,&E0
defb &2
defb &10,&78

defb &41
defb &2
defb &81
defb &41
defb &5
defb &C2
defb &2
defb &40,&EE,&11,&77,&CC
defb &C3
defb &9
defb &31
defb &3
defb &32
defb &4
defb &32
defb &11
defb &3
defb &32
defb &F,&2
defb &81
defb &30,&30,&A4,&84
defb &3
defb &91
defb &10,&24

defb &81
defb &2
defb &C1
defb &10,&4B
defb &4
defb &10,&83
defb &20,&70,&70
defb &30,&80,&C0,&80

defb &C1
defb &42
defb &81
defb &20,&43,&C0
defb &2
defb &81
defb &C3
defb &10,&C0

defb &41
defb &2
defb &C1
defb &10,&90
defb &C3
defb &6
defb &81
defb &20,&B4,&30
defb &C2
defb &20,&E0,&61
defb &2
defb &C2
defb &40,&90,&70,&C0,&10
defb &93
defb &2
defb &C1
defb &91
defb &6
defb &81
defb &3
defb &F1
defb &10,&99

defb &51
defb &2
defb &C4
defb &41
defb &C
defb &10,&7
defb &4
defb &34
defb &2
defb &32
defb &11
defb &5
defb &10,&60
defb &A
defb &30,&12,&42,&C0
defb &3
defb &61
defb &10,&4A

defb &C1
defb &2
defb &81
defb &10,&4B
defb &4
defb &C3
defb &42
defb &81
defb &C1
defb &2
defb &81
defb &C2
defb &40,&10,&90,&96,&40
defb &7
defb &C1
defb &41
defb &2
defb &C6
defb &61
defb &20,&2D,&70
defb &2
defb &30,&68,&38,&D2
defb &4
defb &C4
defb &10,&C0
defb &2
defb &41
defb &2
defb &81
defb &C2
defb &30,&10,&68,&18
defb &3
defb &61
defb &5
defb &F3
defb &3
defb &C4
defb &41
defb &B
defb &21
defb &31
defb &6
defb &21
defb &32
defb &20,&1,&E

defb &11
defb &5
defb &81
defb &7
defb &81
defb &3
defb &10,&20

defb &81
defb &2
defb &C1
defb &41
defb &2
defb &C1
defb &10,&4A

defb &41
defb &2
defb &81
defb &C2
defb &2
defb &C4
defb &41
defb &4
defb &C5
defb &2
defb &40,&10,&6,&60,&68
defb &33
defb &11
defb &10,&80

defb &C1
defb &2
defb &81
defb &C2
defb &10,&10

defb &81
defb &C2
defb &61
defb &91
defb &C2
defb &3
defb &10,&B0
defb &C2
defb &2
defb &10,&20
defb &C2
defb &41
defb &2
defb &41
defb &10,&80

defb &41
defb &2
defb &81
defb &5
defb &C1
defb &20,&81,&81
defb &20,&C0,&25
defb &3
defb &F2
defb &51
defb &2
defb &81
defb &C2
defb &F2
defb &51
defb &B
defb &31
defb &11
defb &8
defb &21
defb &11
defb &2
defb &32
defb &5
defb &C1
defb &7
defb &10,&42
defb &2
defb &30,&60,&C2,&48

defb &41
defb &2
defb &C1
defb &10,&E1
defb &42
defb &2
defb &10,&3C

defb &91
defb &C2
defb &1
defb &41
defb &2
defb &C1
defb &10,&90
defb &C2
defb &20,&E0,&80
defb &2
defb &20,&10,&6

defb &C1
defb &32
defb &11
defb &1
defb &C6
defb &4
defb &41
defb &6
defb &91
defb &C3
defb &3
defb &21
defb &10,&1

defb &81
defb &C2
defb &91
defb &C1
defb &3
defb &10,&20
defb &82
defb &2
defb &82
defb &41
defb &2
defb &C1
defb &20,&80,&D0
defb &62
defb &20,&C0,&D2
defb &3
defb &A1
defb &F1
defb &3
defb &C2
defb &F4
defb &2
defb &10,&E
defb &6
defb &10,&E

defb &11
defb &C
defb &21
defb &31
defb &5
defb &11
defb &8
defb &91
defb &11
defb &2
defb &11
defb &20,&84,&40

defb &11
defb &2
defb &81
defb &20,&3C,&70
defb &2
defb &32
defb &20,&E1,&10

defb &81
defb &C7
defb &3
defb &81
defb &20,&10,&70

defb &21
defb &C2
defb &11
defb &4
defb &C3
defb &D
defb &10,&82
defb &C3
defb &2
defb &91
defb &C1
defb &34
defb &41
defb &4
defb &10,&10

defb &C1
defb &3
defb &C3
defb &41
defb &30,&80,&90,&A1
defb &92
defb &2
defb &92
defb &3
defb &A1
defb &F1
defb &3
defb &20,&F8,&77
defb &C3
defb &41
defb &10,&E
defb &6
defb &10,&E
defb &D
defb &21
defb &31
defb &5
defb &C1
defb &3
defb &C1
defb &4
defb &61
defb &41
defb &2
defb &61
defb &30,&C0,&8,&70
defb &2
defb &10,&1E
defb &C2
defb &41
defb &C6
defb &81
defb &90,&70,&40,&E0,&10,&60,&80,&10,&68,&B
defb &2
defb &10,&70
defb &F,&2
defb &81
defb &C2
defb &20,&80,&78

defb &91
defb &C2
defb &41
defb &10,&70
defb &3
defb &81
defb &20,&10,&10

defb &C1
defb &82
defb &41
defb &C4
defb &1
defb &C2
defb &1
defb &61
defb &C3
defb &10,&10
defb &C2
defb &3
defb &A1
defb &F1
defb &3
defb &81
defb &F3
defb &C1
defb &E2
defb &C1
defb &10,&1C

defb &11
defb &5
defb &10,&7
defb &E
defb &50,&7,&C0,&10,&25,&90

defb &C1
defb &2
defb &41
defb &C3
defb &1
defb &C3
defb &91
defb &41
defb &C3
defb &81
defb &C5
defb &10,&90

defb &41
defb &2
defb &81
defb &C2
defb &10,&C0
defb &6
defb &20,&60,&40
defb &C2
defb &61
defb &33
defb &C6
defb &41
defb &7
defb &10,&20
defb &C6
defb &2
defb &33
defb &11
defb &C2
defb &41
defb &4
defb &C3
defb &91
defb &2
defb &C1
defb &40,&A1,&30,&E0,&E1

defb &81
defb &C2
defb &41
defb &10,&24
defb &3
defb &81
defb &41
defb &4
defb &A1
defb &F1
defb &3
defb &A1
defb &F3
defb &C2
defb &D2
defb &10,&18

defb &31
defb &5
defb &10,&7
defb &6
defb &21
defb &32
defb &11
defb &4
defb &20,&7,&80

defb &41
defb &CF,&0
defb &61
defb &C3
defb &41
defb &C2
defb &81
defb &10,&70

defb &21
defb &C3
defb &41
defb &6
defb &81
defb &2
defb &81
defb &C2
defb &1
defb &31
defb &C2
defb &61
defb &C2
defb &20,&16,&4
defb &3
defb &C4
defb &41
defb &2
defb &10,&70
defb &2
defb &10,&60

defb &1
defb &C6
defb &81
defb &10,&70
defb &A
defb &C3
defb &2
defb &61
defb &C1
defb &3
defb &81
defb &C3
defb &41
defb &3
defb &81
defb &C2
defb &41
defb &C1
defb &6
defb &A1
defb &F1
defb &3
defb &F5
defb &C2
defb &E1
defb &20,&30,&7
defb &4
defb &31
defb &6
defb &21
defb &34
defb &11
defb &3
defb &10,&7
defb &2
defb &30,&70,&E0,&D0
defb &42
defb &C2
defb &20,&10,&10
defb &20,&20,&14
defb &8
defb &10,&60
defb &2
defb &81
defb &C3
defb &42
defb &20,&C0,&87

defb &C1
defb &33
defb &C4
defb &92
defb &2
defb &10,&14

defb &C1
defb &4
defb &81
defb &C2
defb &20,&8,&70
defb &2
defb &81
defb &42
defb &4
defb &81
defb &10,&30
defb &C2
defb &A
defb &40,&D0,&E1,&C0,&D

defb &91
defb &C3
defb &91
defb &C2
defb &61
defb &32
defb &20,&B4,&B4
defb &C3
defb &41
defb &8
defb &60,&77,&BB,&77,&E0,&31,&E
defb &4
defb &31
defb &5
defb &21
defb &32
defb &91
defb &61
defb &32
defb &3
defb &31
defb &8
defb &81
defb &3
defb &81
defb &4
defb &50,&68,&70,&80,&10,&60
defb &2
defb &10,&42
defb &4
defb &10,&B0

defb &41
defb &C2
defb &61
defb &10,&81
defb &3
defb &81
defb &20,&30,&4A
defb &C3
defb &42
defb &91
defb &10,&30

defb &C1
defb &4
defb &C2
defb &21
defb &10,&E1
defb &4
defb &30,&E0,&80,&10

defb &81
defb &2
defb &C1
defb &6
defb &50,&90,&70,&80,&D2,&86
defb &62
defb &32
defb &63
defb &C2
defb &61
defb &32
defb &C4
defb &10,&90
defb &9
defb &A1
defb &20,&77,&BB
defb &F2
defb &1
defb &C2
defb &41
defb &10,&E

defb &11
defb &8
defb &21
defb &32
defb &91
defb &C2
defb &61
defb &20,&7,&8

defb &31
defb &8
defb &41
defb &3
defb &C1
defb &3
defb &81
defb &30,&C0,&25,&80

defb &11
defb &2
defb &C1
defb &2
defb &10,&60
defb &2
defb &C1
defb &3
defb &20,&87,&3C
defb &4
defb &C1
defb &83
defb &C1
defb &94
defb &41
defb &20,&3C,&40

defb &C1
defb &5
defb &20,&E0,&61
defb &4
defb &40,&E0,&81,&10,&70
defb &2
defb &C2
defb &10,&90
defb &C4
defb &41
defb &2
defb &81
defb &10,&69
defb &32
defb &92
defb &10,&C
defb &94
defb &20,&7,&E
defb &92
defb &10,&B4

defb &C1
defb &A
defb &A2
defb &51
defb &10,&77
defb &F2
defb &30,&91,&F1,&C

defb &11
defb &8
defb &33
defb &C1
defb &E2
defb &C1
defb &20,&1E,&8

defb &11
defb &8
defb &C1
defb &3
defb &41
defb &3
defb &81
defb &30,&80,&D2,&E0

defb &41
defb &2
defb &81
defb &41
defb &2
defb &41
defb &2
defb &C2
defb &4
defb &10,&60

defb &1
defb &42
defb &81
defb &C1
defb &82
defb &1
defb &C1
defb &62
defb &C2
defb &82
defb &61
defb &20,&40,&E0
defb &6
defb &10,&C2
defb &5
defb &C1
defb &20,&81,&B0
defb &C2
defb &10,&10

defb &81
defb &C2
defb &81
defb &C2
defb &41
defb &4
defb &C1
defb &62
defb &33
defb &C1
defb &41
defb &32
defb &63
defb &20,&7,&C
defb &63
defb &C2
defb &A
defb &F1
defb &20,&EE,&EE

defb &A1
defb &F2
defb &1
defb &10,&E2
defb &A
defb &21
defb &32
defb &C2
defb &D3
defb &20,&3C,&C

defb &11
defb &2
defb &C1
defb &41
defb &4
defb &81
defb &41
defb &2
defb &41
defb &10,&80
defb &C3
defb &81
defb &20,&B4,&D0

defb &11
defb &2
defb &81
defb &C1
defb &2
defb &41
defb &3
defb &C2
defb &2
defb &81
defb &C1
defb &2
defb &C1
defb &20,&90,&30

defb &C1
defb &2
defb &81
defb &93
defb &C1
defb &30,&68,&C0,&80
defb &3
defb &81
defb &2
defb &10,&6
defb &6
defb &20,&92,&80
defb &C3
defb &C
defb &C1
defb &10,&2D

defb &11
defb &32
defb &11
defb &2
defb &31
defb &92
defb &31
defb &20,&41,&8
defb &94
defb &41
defb &9
defb &10,&EC
defb &20,&EE,&EE

defb &51
defb &F2
defb &1
defb &10,&E0
defb &9
defb &21
defb &32
defb &1
defb &E5
defb &10,&78
defb &32
defb &C2
defb &10,&C0
defb &6
defb &C1
defb &2
defb &41
defb &3
defb &C1
defb &30,&80,&D2,&90

defb &41
defb &3
defb &C2
defb &42
defb &3
defb &C2
defb &1
defb &81
defb &42
defb &81
defb &40,&C0,&80,&30,&70
defb &32
defb &62
defb &C1
defb &34
defb &1
defb &10,&B0

defb &41
defb &2
defb &81
defb &2
defb &10,&60
defb &6
defb &10,&52
defb &2
defb &C3
defb &1
defb &20,&24,&60
defb &3
defb &81
defb &10,&70

defb &1
defb &62
defb &11
defb &2
defb &32
defb &11
defb &2
defb &32
defb &11
defb &20,&60,&20

defb &31
defb &62
defb &C1
defb &41
defb &9
defb &20,&EC,&DD

defb &51
defb &F2
defb &A1
defb &20,&D1,&72
defb &9
defb &32
defb &11
defb &1
defb &D6
defb &C1
defb &32
defb &C2
defb &10,&E0

defb &41
defb &5
defb &20,&60,&C0
defb &3
defb &41
defb &1
defb &82
defb &C1
defb &10,&C0
defb &4
defb &C3
defb &82
defb &1
defb &20,&A4,&10
defb &C2
defb &40,&80,&40,&80,&B0
defb &C2
defb &33
defb &C2
defb &34
defb &11
defb &10,&C0
defb &42
defb &10,&80
defb &3
defb &C1
defb &41
defb &5
defb &10,&52
defb &6
defb &20,&A4,&70
defb &3
defb &81
defb &C2
defb &10,&E0

defb &31
defb &4
defb &32
defb &11
defb &4
defb &30,&60,&70,&E
defb &92
defb &41
defb &9
defb &10,&FC

defb &51
defb &F2
defb &A1
defb &30,&77,&E0,&71
defb &9
defb &31
defb &11
defb &2
defb &E2
defb &F2
defb &E2
defb &41
defb &32
defb &30,&70,&3,&E0
defb &5
defb &41
defb &10,&80
defb &3
defb &41
defb &4
defb &10,&78

defb &41
defb &4
defb &C2
defb &41
defb &C2
defb &20,&68,&C0
defb &3
defb &41
defb &30,&C0,&80,&90
defb &C2
defb &30,&10,&4A,&34
defb &20,&E,&E
defb &10,&80
defb &42
defb &10,&80
defb &3
defb &91
defb &10,&90
defb &2
defb &20,&10,&D2
defb &7
defb &31
defb &50,&E1,&90,&80,&30,&E

defb &11
defb &4
defb &21
defb &32
defb &11
defb &4
defb &41
defb &30,&70,&8,&E1
defb &A
defb &30,&B8,&BB,&77
defb &F2
defb &10,&E8

defb &41
defb &9
defb &10,&E
defb &3
defb &81
defb &F4
defb &30,&75,&6,&48

defb &A1
defb &E2
defb &31
defb &10,&E0
defb &E
defb &10,&A4

defb &41
defb &2
defb &21
defb &31
defb &92
defb &C2
defb &91
defb &20,&B4,&70
defb &3
defb &61
defb &40,&85,&E0,&10,&1E
defb &2
defb &40,&C2,&16,&7,&C
defb &92
defb &20,&40,&E0
defb &3
defb &21
defb &10,&90
defb &2
defb &10,&10

defb &21
defb &6
defb &81
defb &20,&4,&E0
defb &2
defb &41
defb &3
defb &32
defb &4
defb &20,&20,&E

defb &11
defb &3
defb &C3
defb &41
defb &2
defb &32
defb &11
defb &9
defb &20,&70,&77
defb &F2
defb &20,&66,&F4
defb &A
defb &10,&E
defb &3
defb &A1
defb &F5
defb &41
defb &3
defb &31
defb &20,&91,&39

defb &81
defb &C2
defb &F,&3
defb &21
defb &20,&87,&D2
defb &64
defb &C1
defb &34
defb &61
defb &40,&4B,&78,&10,&7
defb &2
defb &20,&E,&8

defb &C1
defb &2
defb &21
defb &61
defb &42
defb &C1
defb &41
defb &4
defb &61
defb &C1
defb &5
defb &10,&C2
defb &5
defb &81
defb &41
defb &4
defb &81
defb &41
defb &2
defb &21
defb &10,&7
defb &4
defb &81
defb &3
defb &20,&B,&1
defb &C3
defb &41
defb &2
defb &21
defb &32
defb &9
defb &30,&F8,&22,&66
defb &2
defb &C2
defb &A
defb &32
defb &3
defb &A1
defb &F5
defb &51
defb &2
defb &30,&8F,&7A,&2B
defb &2
defb &C2
defb &30,&10,&70,&C0
defb &3
defb &C1
defb &9
defb &31
defb &C1
defb &95
defb &61
defb &32
defb &11
defb &20,&78,&C3
defb &92
defb &20,&10,&7
defb &3
defb &31
defb &10,&C

defb &41
defb &2
defb &21
defb &20,&34,&34
defb &5
defb &81
defb &91
defb &3
defb &30,&20,&C2,&90
defb &2
defb &C3
defb &2
defb &81
defb &1
defb &42
defb &81
defb &20,&18,&7
defb &5
defb &41
defb &2
defb &34
defb &20,&70,&70
defb &3
defb &21
defb &31
defb &9
defb &10,&E0

defb &61
defb &5
defb &10,&F4
defb &9
defb &21
defb &10,&7
defb &3
defb &A1
defb &F5
defb &51
defb &2
defb &91
defb &D3
defb &20,&6D,&61
defb &3
defb &41
defb &10,&60

defb &1
defb &C2
defb &2
defb &C1
defb &41
defb &2
defb &41
defb &3
defb &21
defb &10,&B

defb &C1
defb &64
defb &C1
defb &31
defb &2
defb &81
defb &10,&16
defb &32
defb &61
defb &C2
defb &21
defb &31
defb &5
defb &10,&6

defb &41
defb &2
defb &21
defb &20,&E1,&52
defb &5
defb &81
defb &10,&41
defb &2
defb &81
defb &2
defb &C2
defb &1
defb &10,&30
defb &C3
defb &3
defb &10,&70
defb &C2
defb &2
defb &10,&6

defb &81
defb &4
defb &C1
defb &3
defb &33
defb &91
defb &C3
defb &2
defb &32
defb &B
defb &E1
defb &10,&16
defb &4
defb &10,&F2
defb &9
defb &21
defb &10,&7
defb &3
defb &A1
defb &F5
defb &51
defb &2
defb &40,&EB,&98,&63,&1
defb &C2
defb &1
defb &82
defb &1
defb &81
defb &C2
defb &41
defb &10,&E0

defb &41
defb &2
defb &C1
defb &41
defb &2
defb &32
defb &1
defb &10,&C3

defb &31
defb &92
defb &61
defb &2
defb &30,&E0,&2,&E
defb &92
defb &10,&3C

defb &11
defb &5
defb &10,&6

defb &C1
defb &3
defb &93
defb &11
defb &10,&30
defb &C2
defb &20,&90,&41
defb &2
defb &20,&60,&8
defb &20,&70,&70

defb &81
defb &C2
defb &41
defb &2
defb &20,&90,&80
defb &2
defb &20,&6,&60
defb &3
defb &81
defb &3
defb &31
defb &2
defb &21
defb &37
defb &11
defb &A
defb &D1
defb &10,&1E

defb &11
defb &3
defb &10,&F4
defb &9
defb &21
defb &10,&7
defb &3
defb &A1
defb &F5
defb &51
defb &40,&8,&E5,&80,&65

defb &11
defb &2
defb &C1
defb &82
defb &30,&10,&E0,&10

defb &81
defb &C2
defb &41
defb &5
defb &12
defb &2
defb &31
defb &10,&9
defb &62
defb &30,&1,&E0,&7

defb &1
defb &32
defb &62
defb &41
defb &6
defb &20,&2,&60
defb &2
defb &81
defb &62
defb &C2
defb &41
defb &3
defb &C2
defb &3
defb &81
defb &2
defb &21
defb &30,&61,&80,&70
defb &5
defb &81
defb &4
defb &21
defb &2
defb &41
defb &3
defb &81
defb &41
defb &2
defb &31
defb &9
defb &21
defb &11
defb &8
defb &81
defb &10,&D8

defb &61
defb &32
defb &3
defb &10,&F2
defb &9
defb &32
defb &4
defb &A1
defb &F5
defb &51
defb &40,&8,&EA,&C8,&63

defb &11
defb &3
defb &10,&12

defb &C1
defb &8
defb &82
defb &3
defb &50,&6,&40,&60,&8,&4B

defb &11
defb &2
defb &C1
defb &20,&16,&8

defb &31
defb &92
defb &41
defb &5
defb &21
defb &11
defb &2
defb &C1
defb &10,&80

defb &C1
defb &95
defb &C2
defb &1
defb &C2
defb &81
defb &6
defb &30,&52,&60,&E0
defb &3
defb &81
defb &43
defb &C3
defb &21
defb &2
defb &81
defb &20,&16,&40
defb &3
defb &31
defb &A
defb &11
defb &8
defb &C1
defb &10,&C0

defb &61
defb &33
defb &20,&1,&E4

defb &41
defb &5
defb &21
defb &34
defb &4
defb &A1
defb &F5
defb &51
defb &10,&8

defb &81
defb &D3
defb &10,&61
defb &5
defb &41
defb &10,&80
defb &7
defb &82
defb &3
defb &10,&6

defb &1
defb &C4
defb &41
defb &10,&C0
defb &3
defb &C1
defb &61
defb &3
defb &32
defb &C2
defb &4
defb &10,&E
defb &3
defb &81
defb &C2
defb &10,&8

defb &31
defb &62
defb &C2
defb &3
defb &11
defb &7
defb &20,&6,&C0
defb &2
defb &10,&70
defb &3
defb &C1
defb &82
defb &C2
defb &21
defb &2
defb &21
defb &20,&1E,&C1
defb &3
defb &11
defb &9
defb &21
defb &11
defb &7
defb &20,&30,&D8

defb &C1
defb &34
defb &11
defb &10,&E0

defb &41
defb &4
defb &21
defb &35
defb &1
defb &81
defb &2
defb &A1
defb &F5
defb &51
defb &2
defb &20,&72,&BA

defb &E1
defb &3
defb &20,&70,&9
defb &2
defb &C1
defb &6
defb &C2
defb &2
defb &32
defb &2
defb &C1
defb &20,&C1,&61
defb &C2
defb &10,&10

defb &21
defb &32
defb &1
defb &81
defb &2
defb &31
defb &10,&61
defb &3
defb &C1
defb &10,&7
defb &3
defb &81
defb &C1
defb &3
defb &32
defb &11
defb &5
defb &11
defb &82
defb &6
defb &42
defb &81
defb &C4
defb &10,&E0
defb &84
defb &C2
defb &21
defb &2
defb &C1
defb &32
defb &10,&C1
defb &3
defb &11
defb &5
defb &41
defb &3
defb &21
defb &11
defb &8
defb &C1
defb &20,&90,&71

defb &21
defb &33
defb &10,&C1

defb &D1
defb &3
defb &21
defb &36
defb &1
defb &10,&90
defb &2
defb &F5
defb &51
defb &2
defb &20,&7D,&31

defb &D1
defb &3
defb &10,&70
defb &2
defb &10,&70

defb &81
defb &2
defb &81
defb &41
defb &2
defb &81
defb &2
defb &10,&E

defb &11
defb &2
defb &C1
defb &61
defb &C6
defb &1
defb &10,&42
defb &2
defb &40,&60,&8,&3,&E

defb &1
defb &32
defb &2
defb &C1
defb &1
defb &C2
defb &4
defb &21
defb &31
defb &3
defb &20,&10,&2

defb &41
defb &6
defb &91
defb &10,&40
defb &7
defb &81
defb &41
defb &3
defb &21
defb &2
defb &62
defb &1
defb &10,&4B
defb &3
defb &11
defb &2
defb &81
defb &2
defb &C1
defb &3
defb &21
defb &9
defb &C1
defb &20,&80,&F2
defb &2
defb &33
defb &81
defb &10,&38
defb &38
defb &10,&1
defb &C2
defb &2
defb &F5
defb &D1
defb &20,&30,&3E
defb &E2
defb &C1
defb &3
defb &C3
defb &41
defb &10,&C1
defb &20,&80,&80

defb &C1
defb &5
defb &10,&82
defb &32
defb &10,&80
defb &20,&E1,&E1
defb &92
defb &10,&E

defb &11
defb &4
defb &C1
defb &20,&8,&3
defb &35
defb &2
defb &41
defb &10,&C0
defb &6
defb &10,&7
defb &2
defb &41
defb &2
defb &11
defb &42
defb &5
defb &21
defb &10,&1

defb &C1
defb &2
defb &41
defb &8
defb &30,&6,&C0,&21
defb &92
defb &3
defb &31
defb &2
defb &81
defb &2
defb &C1
defb &3
defb &21
defb &4
defb &20,&10,&D0

defb &41
defb &3
defb &20,&F4,&30

defb &21
defb &32
defb &81
defb &10,&71
defb &34
defb &C1
defb &4
defb &41
defb &10,&40
defb &2
defb &F5
defb &D1
defb &20,&70,&B4
defb &D3
defb &3
defb &C3
defb &41
defb &50,&84,&D0,&90,&30,&60
defb &2
defb &10,&20
defb &33
defb &1
defb &10,&D2
defb &63
defb &C1
defb &32
defb &5
defb &81
defb &2
defb &31
defb &3
defb &30,&E,&81,&40
defb &8
defb &10,&6
defb &2
defb &41
defb &2
defb &21
defb &11
defb &6
defb &81
defb &50,&3,&E0,&1C,&1,&E0

defb &41
defb &3
defb &70,&6,&C,&10,&52,&60,&84,&30

defb &81
defb &2
defb &C1
defb &41
defb &2
defb &21
defb &4
defb &41
defb &82
defb &41
defb &2
defb &C1
defb &2
defb &E1
defb &10,&70
defb &3
defb &E1
defb &10,&70
defb &32
defb &CB
defb &1
defb &F5
defb &D1
defb &40,&70,&AC,&CB,&90

defb &41
defb &2
defb &C2
defb &4
defb &81
defb &10,&30
defb &83
defb &41
defb &10,&60
defb &2
defb &31
defb &2
defb &31
defb &95
defb &21
defb &32
defb &8
defb &31
defb &4
defb &21
defb &20,&81,&C0

defb &41
defb &7
defb &10,&6
defb &2
defb &C1
defb &3
defb &31
defb &6
defb &81
defb &21
defb &3
defb &40,&E0,&E1,&C0,&61
defb &2
defb &21
defb &2
defb &31
defb &60,&20,&25,&60,&80,&61,&60

defb &1
defb &C2
defb &2
defb &21
defb &4
defb &D2
defb &10,&6C
defb &2
defb &60,&60,&80,&71,&20,&E0,&71
defb &C4
defb &10,&1E

defb &91
defb &C2
defb &62
defb &31
defb &10,&70
defb &F5
defb &51
defb &C2
defb &30,&84,&D7,&90

defb &C1
defb &2
defb &81
defb &C2
defb &20,&10,&60
defb &3
defb &81
defb &20,&30,&60
defb &2
defb &31
defb &2
defb &32
defb &63
defb &20,&3C,&C
defb &8
defb &31
defb &4
defb &21
defb &30,&81,&C0,&90
defb &20,&80,&80
defb &2
defb &10,&6
defb &2
defb &C1
defb &3
defb &10,&2

defb &41
defb &2
defb &82
defb &1
defb &41
defb &5
defb &20,&3C,&D0
defb &32
defb &10,&70

defb &21
defb &2
defb &31
defb &40,&60,&6,&60,&80

defb &61
defb &C4
defb &61
defb &C1
defb &2
defb &21
defb &4
defb &E4
defb &70,&41,&C0,&90,&72,&20,&E0,&72
defb &C2
defb &D2
defb &50,&D3,&E1,&58,&B4,&70
defb &F5
defb &51
defb &1
defb &C2
defb &11
defb &20,&C2,&10

defb &C1
defb &2
defb &81
defb &C2
defb &60,&10,&82,&12,&90,&70,&60
defb &2
defb &21
defb &3
defb &31
defb &93
defb &20,&16,&C
defb &3
defb &81
defb &4
defb &10,&3
defb &C2
defb &30,&8,&81,&C0

defb &41
defb &82
defb &91
defb &10,&C0
defb &2
defb &10,&6
defb &2
defb &30,&60,&40,&84

defb &41
defb &5
defb &20,&60,&C0
defb &3
defb &81
defb &30,&7,&8,&E1

defb &61
defb &2
defb &31
defb &20,&60,&6

defb &81
defb &2
defb &81
defb &C3
defb &91
defb &C2
defb &20,&E1,&8
defb &4
defb &70,&17,&C4,&A1,&10,&90,&70,&30

defb &C1
defb &D2
defb &41
defb &C1
defb &E3
defb &10,&10

defb &21
defb &2
defb &21
defb &10,&25
defb &2
defb &F5
defb &71
defb &10,&3
defb &C2
defb &61
defb &3
defb &C1
defb &2
defb &C3
defb &3
defb &21
defb &10,&96

defb &C1
defb &3
defb &C2
defb &2
defb &21
defb &2
defb &41
defb &10,&E
defb &62
defb &20,&7,&1C
defb &2
defb &10,&90
defb &4
defb &50,&86,&90,&10,&41,&68

defb &41
defb &82
defb &61
defb &30,&60,&20,&6
defb &2
defb &30,&60,&40,&4

defb &41
defb &6
defb &41
defb &10,&C0

defb &41
defb &4
defb &C3
defb &10,&6

defb &81
defb &2
defb &31
defb &20,&68,&90

defb &C1
defb &2
defb &C1
defb &10,&D2
defb &62
defb &30,&78,&70,&28

defb &11
defb &4
defb &11
defb &20,&88,&A1

defb &41
defb &2
defb &C2
defb &41
defb &10,&80

defb &E1
defb &C2
defb &81
defb &C1
defb &D2
defb &F1
defb &40,&10,&2,&20,&41
defb &2
defb &F6
defb &10,&7
defb &2
defb &C2
defb &2
defb &20,&70,&C0
defb &32
defb &10,&E0
defb &2
defb &10,&29

defb &C1
defb &2
defb &81
defb &C2
defb &2
defb &21
defb &2
defb &C1
defb &40,&C,&2D,&1,&78
defb &2
defb &10,&90
defb &4
defb &a0,&86,&10,&30,&41,&E0,&D0,&84,&B4,&20,&6
defb &2
defb &20,&60,&C0
defb &2
defb &C1
defb &6
defb &41
defb &1
defb &C2
defb &7
defb &30,&B4,&80,&10

defb &41
defb &C3
defb &10,&E1

defb &81
defb &C3
defb &92
defb &C1
defb &93
defb &10,&28

defb &11
defb &2
defb &81
defb &30,&4,&80,&A1

defb &41
defb &2
defb &C1
defb &D1
defb &2
defb &C3
defb &10,&D0
defb &E2
defb &F2
defb &4
defb &30,&30,&81,&38

defb &B1
defb &F5
defb &20,&1F,&1
defb &C2
defb &2
defb &70,&60,&C0,&1,&6,&30,&49,&60
defb &6
defb &21
defb &2
defb &81
defb &41
defb &2
defb &91
defb &20,&80,&78
defb &2
defb &10,&90
defb &2
defb &b0,&10,&6,&30,&28,&41,&68,&D0,&48,&78,&20,&6
defb &3
defb &C1
defb &10,&C0
defb &2
defb &81
defb &2
defb &41
defb &3
defb &C1
defb &10,&40
defb &20,&60,&60
defb &5
defb &81
defb &C1
defb &3
defb &30,&58,&78,&70
defb &C2
defb &67
defb &C2
defb &21
defb &11
defb &2
defb &81
defb &50,&4,&8C,&21,&30,&E8
defb &2
defb &30,&3C,&61,&E0

defb &D1
defb &F3
defb &3
defb &81
defb &40,&10,&1,&38,&87
defb &F5
defb &71
defb &20,&83,&80
defb &2
defb &60,&60,&C0,&1,&C2,&20,&81

defb &11
defb &42
defb &4
defb &41
defb &10,&3
defb &82
defb &41
defb &2
defb &81
defb &20,&80,&78
defb &2
defb &20,&90,&10

defb &41
defb &2
defb &11
defb &20,&20,&38

defb &1
defb &C3
defb &92
defb &31
defb &93
defb &20,&20,&6
defb &3
defb &C1
defb &10,&C0
defb &20,&10,&10

defb &41
defb &5
defb &C1
defb &3
defb &10,&70
defb &2
defb &C2
defb &2
defb &C2
defb &10,&90
defb &C2
defb &91
defb &C2
defb &81
defb &C1
defb &98
defb &C1
defb &41
defb &4
defb &81
defb &2
defb &21
defb &92
defb &41
defb &50,&20,&E4,&90,&3C,&A1

defb &C1
defb &E2
defb &F3
defb &50,&80,&B0,&10,&1,&38
defb &32
defb &E2
defb &F3
defb &E1
defb &20,&96,&30

defb &C1
defb &82
defb &41
defb &2
defb &90,&1,&87,&10,&7,&10,&70,&80,&70,&3
defb &82
defb &C1
defb &2
defb &81
defb &1
defb &C3
defb &2
defb &10,&10

defb &61
defb &82
defb &C1
defb &10,&16
defb &82
defb &20,&18,&8

defb &C1
defb &63
defb &10,&86

defb &61
defb &C2
defb &1
defb &10,&6
defb &3
defb &C1
defb &10,&C0
defb &2
defb &10,&30
defb &42
defb &10,&40
defb &2
defb &20,&60,&80
defb &C2
defb &20,&10,&E0
defb &3
defb &C2
defb &1
defb &C1
defb &63
defb &41
defb &C2
defb &32
defb &65
defb &20,&87,&80
defb &3
defb &81
defb &2
defb &30,&8E,&F2,&20
defb &C2
defb &10,&90
defb &32
defb &41
defb &C2
defb &D1
defb &F4
defb &10,&C0

defb &1
defb &C2
defb &81
defb &C2
defb &82
defb &32
defb &91
defb &D2
defb &F1
defb &D2
defb &60,&1F,&21,&E0,&D0,&10,&9

defb &91
defb &42
defb &1
defb &91
defb &2
defb &11
defb &10,&E0
defb &2
defb &20,&70,&3

defb &81
defb &C2
defb &2
defb &C1
defb &50,&D0,&86,&90,&8,&A1
defb &2
defb &10,&16
defb &82
defb &20,&8,&C0
defb &93
defb &11
defb &10,&82
defb &92
defb &20,&10,&6
defb &3
defb &C1
defb &41
defb &3
defb &10,&30
defb &42
defb &5
defb &41
defb &10,&80
defb &C2
defb &10,&10
defb &C3
defb &3
defb &20,&B4,&C0
defb &92
defb &42
defb &81
defb &33
defb &93
defb &33
defb &10,&80

defb &41
defb &2
defb &81
defb &2
defb &30,&7,&E4,&40

defb &81
defb &D2
defb &21
defb &32
defb &1
defb &E3
defb &F3
defb &51
defb &21
defb &C4
defb &81
defb &C2
defb &10,&28

defb &61
defb &32
defb &B1
defb &E4
defb &61
defb &32
defb &1
defb &80,&60,&C0,&10,&29,&C1,&8,&70,&C

defb &21
defb &3
defb &10,&30

defb &11
defb &2
defb &61
defb &C3
defb &61
defb &C1
defb &62
defb &11
defb &30,&18,&8,&D2
defb &2
defb &10,&16
defb &82
defb &20,&8,&E1
defb &64
defb &40,&81,&D2,&10,&6
defb &3
defb &C1
defb &41
defb &3
defb &81
defb &8
defb &81
defb &6
defb &C2
defb &4
defb &C1
defb &64
defb &C2
defb &61
defb &20,&7,&8

defb &31
defb &63
defb &20,&E,&81

defb &41
defb &2
defb &C1
defb &20,&E,&2F
defb &E2
defb &10,&C0

defb &81
defb &E2
defb &1
defb &12
defb &1
defb &D2
defb &F4
defb &51
defb &10,&C2

defb &81
defb &C2
defb &61
defb &10,&E1
defb &82
defb &34
defb &D4
defb &34
defb &3
defb &81
defb &80,&30,&C1,&81,&8,&70,&4,&40,&70
defb &2
defb &11
defb &2
defb &C1
defb &92
defb &C3
defb &91
defb &80,&D2,&90,&D,&E1,&C1,&16,&A4,&8

defb &91
defb &C2
defb &92
defb &61
defb &10,&81
defb &92
defb &2
defb &10,&6
defb &3
defb &81
defb &C1
defb &2
defb &81
defb &10,&40
defb &5
defb &C1
defb &10,&80
defb &A
defb &30,&20,&D0,&E1
defb &92
defb &62
defb &10,&7
defb &2
defb &21
defb &33
defb &10,&C

defb &91
defb &C2
defb &1
defb &10,&E0
defb &72
defb &10,&7D
defb &D2
defb &10,&D0

defb &41
defb &D2
defb &61
defb &10,&25

defb &1
defb &E2
defb &F4
defb &51
defb &30,&4A,&E0,&16
defb &2
defb &10,&20

defb &61
defb &34
defb &E2
defb &61
defb &34
defb &10,&C0
defb &82
defb &40,&30,&81,&61,&80
defb &C2
defb &20,&4,&6

defb &C1
defb &3
defb &11
defb &2
defb &81
defb &66
defb &90,&60,&8,&1C,&1E,&30,&2,&E0,&10,&81
defb &62
defb &30,&3C,&80,&D2
defb &2
defb &10,&6
defb &3
defb &81
defb &C1
defb &2
defb &81
defb &42
defb &4
defb &20,&E0,&80
defb &A
defb &20,&20,&B0

defb &1
defb &62
defb &C1
defb &10,&1E

defb &11
defb &4
defb &32
defb &11
defb &40,&C,&69,&70,&E0
defb &62
defb &30,&7A,&72,&80

defb &41
defb &C2
defb &61
defb &20,&34,&C4
defb &F5
defb &51
defb &20,&4A,&38

defb &61
defb &82
defb &41
defb &10,&30

defb &91
defb &3B
defb &20,&1,&30
defb &C3
defb &41
defb &10,&C1

defb &1
defb &C3
defb &20,&10,&D
defb &82
defb &42
defb &91
defb &3
defb &81
defb &92
defb &C1
defb &92
defb &90,&34,&80,&B4,&85,&1,&2,&A4,&10,&81

defb &C1
defb &92
defb &61
defb &10,&80
defb &92
defb &2
defb &10,&6
defb &3
defb &81
defb &C1
defb &2
defb &81
defb &41
defb &4
defb &82
defb &C1
defb &10,&40
defb &8
defb &10,&20

defb &81
defb &2
defb &C3
defb &92
defb &10,&7
defb &5
defb &31
defb &3
defb &31
defb &C4
defb &10,&E0

defb &71
defb &D2
defb &71
defb &D2
defb &50,&90,&10,&78,&B4,&C8
defb &F5
defb &51
defb &3
defb &21
defb &83
defb &41
defb &C2
defb &10,&4A
defb &3B
defb &4
defb &C2
defb &81
defb &20,&D0,&C0

defb &41
defb &C3
defb &10,&B
defb &32
defb &10,&41

defb &81
defb &4
defb &64
defb &C1
defb &10,&16
defb &2
defb &62
defb &60,&78,&10,&2,&68,&38,&C1
defb &62
defb &C2
defb &20,&80,&D2
defb &2
defb &10,&6
defb &3
defb &81
defb &C1
defb &2
defb &81
defb &10,&40
defb &3
defb &82
defb &C1
defb &10,&C0
defb &3
defb &81
defb &3
defb &81
defb &30,&30,&E0,&40
defb &33
defb &61
defb &10,&70
defb &4
defb &10,&E
defb &3
defb &31
defb &10,&78
defb &C3
defb &62
defb &E1
defb &3
defb &E1
defb &10,&B0

defb &C1
defb &3
defb &92
defb &41
defb &F6
defb &51
defb &20,&9,&4

defb &81
defb &C2
defb &41
defb &1
defb &82
defb &91
defb &3A
defb &92
defb &41
defb &3
defb &C2
defb &10,&10

defb &81
defb &32
defb &81
defb &C2
defb &30,&12,&83,&96

defb &11
defb &4
defb &94
defb &41
defb &10,&6
defb &2
defb &94
defb &2
defb &21
defb &C2
defb &92
defb &21
defb &10,&1
defb &C2
defb &91
defb &C5
defb &2
defb &10,&6
defb &6
defb &10,&34
defb &42
defb &2
defb &30,&90,&70,&80
defb &2
defb &10,&E0
defb &3
defb &81
defb &C1
defb &2
defb &81
defb &C2
defb &33
defb &92
defb &41
defb &4
defb &10,&7
defb &3
defb &31
defb &C1
defb &95
defb &10,&D7
defb &3
defb &D2
defb &81
defb &C1
defb &3
defb &92
defb &41
defb &F6
defb &51
defb &10,&B

defb &81
defb &C3
defb &20,&10,&C2

defb &1
defb &63
defb &38
defb &10,&52

defb &1
defb &C2
defb &2
defb &82
defb &41
defb &2
defb &12
defb &10,&78

defb &11
defb &32
defb &91
defb &10,&C0
defb &32
defb &3
defb &63
defb &20,&30,&6
defb &2
defb &81
defb &62
defb &C1
defb &2
defb &20,&C2,&D2
defb &2
defb &10,&70

defb &1
defb &C6
defb &41
defb &10,&70
defb &6
defb &C2
defb &10,&6

defb &C1
defb &42
defb &3
defb &C1
defb &2
defb &81
defb &10,&10
defb &C2
defb &3
defb &41
defb &5
defb &21
defb &10,&3
defb &C3
defb &41
defb &3
defb &32
defb &4
defb &31
defb &C1
defb &66
defb &E1
defb &2
defb &20,&42,&B0

defb &C1
defb &3
defb &92
defb &41
defb &F6
defb &51
defb &22
defb &81
defb &C3
defb &30,&8,&87,&90
defb &92
defb &38
defb &10,&25

defb &81
defb &E2
defb &C1
defb &10,&80
defb &C2
defb &90,&40,&C,&60,&7,&68,&70,&68,&A1,&80
defb &2
defb &20,&20,&6
defb &2
defb &20,&C2,&1C
defb &2
defb &20,&86,&B0

defb &31
defb &C2
defb &42
defb &81
defb &CA
defb &20,&90,&70
defb &2
defb &61
defb &C2
defb &5
defb &30,&70,&C0,&80
defb &C2
defb &20,&90,&C0
defb &5
defb &31
defb &11
defb &2
defb &81
defb &C1
defb &4
defb &31
defb &5
defb &11
defb &C2
defb &94
defb &D1
defb &3
defb &30,&C7,&80,&70
defb &2
defb &20,&69,&98
defb &F5
defb &51
defb &22
defb &C2
defb &42
defb &30,&C,&A4,&30
defb &63
defb &37
defb &62
defb &1
defb &D3
defb &3
defb &C1
defb &30,&D0,&C,&61
defb &2
defb &81
defb &C2
defb &91
defb &2
defb &20,&12,&90

defb &31
defb &C3
defb &35
defb &C7
defb &10,&1E
defb &C2
defb &50,&10,&30,&E0,&10,&70
defb &C3
defb &32
defb &1
defb &30,&60,&78,&61
defb &6
defb &42
defb &20,&40,&80
defb &3
defb &81
defb &20,&70,&70
defb &3
defb &31
defb &8
defb &10,&E
defb &5
defb &11
defb &10,&C3
defb &64
defb &50,&36,&8,&C3,&80,&70
defb &2
defb &10,&4A
defb &C2
defb &D4
defb &50,&77,&4,&B0,&10,&6

defb &1
defb &C2
defb &41
defb &1
defb &92
defb &36
defb &93
defb &10,&C8
defb &C2
defb &20,&40,&80

defb &41
defb &3
defb &10,&61
defb &5
defb &21
defb &10,&E1
defb &3
defb &81
defb &61
defb &33
defb &2
defb &C1
defb &2
defb &31
defb &91
defb &C4
defb &21
defb &10,&1
defb &20,&60,&60
defb &8
defb &30,&30,&90,&1C

defb &C1
defb &32
defb &11
defb &7
defb &81
defb &42
defb &10,&C0
defb &6
defb &20,&E0,&C0
defb &2
defb &10,&E
defb &8
defb &10,&7
defb &5
defb &32
defb &95
defb &40,&3D,&E,&52,&80
defb &C2
defb &30,&10,&4A,&F4
defb &C4
defb &30,&72,&C,&70
defb &2
defb &11
defb &3
defb &C2
defb &10,&8
defb &63
defb &34
defb &63
defb &10,&E4

defb &41
defb &4
defb &81
defb &30,&30,&10,&E
defb &6
defb &21
defb &2
defb &C1
defb &10,&10
defb &C2
defb &1
defb &C5
defb &40,&10,&82,&70,&84
defb &C3
defb &F,&e
defb &41
defb &2
defb &C1
defb &2
defb &10,&60
defb &3
defb &81
defb &10,&90
defb &2
defb &10,&7
defb &7
defb &32
defb &1
defb &C1
defb &4
defb &21
defb &32
defb &64
defb &10,&BE

defb &E1
defb &62
defb &1
defb &21
defb &C4
defb &22
defb &61
defb &E5
defb &C2
defb &51
defb &10,&8
defb &C2
defb &41
defb &2
defb &C2
defb &1
defb &20,&60,&20
defb &93
defb &32
defb &95
defb &10,&62
defb &3
defb &81
defb &2
defb &10,&70

defb &C1
defb &A
defb &31
defb &82
defb &C1
defb &C
defb &34
defb &6
defb &81
defb &5
defb &C1
defb &3
defb &41
defb &C
defb &41
defb &3
defb &C1
defb &2
defb &41
defb &2
defb &C2
defb &2
defb &82
defb &41
defb &3
defb &10,&7
defb &6
defb &30,&E,&10,&70
defb &5
defb &31
defb &92
defb &32
defb &D3
defb &71
defb &10,&10

defb &91
defb &C4
defb &61
defb &20,&9,&F4
defb &C4
defb &10,&71
defb &2
defb &20,&E0,&80
defb &C2
defb &42
defb &2
defb &10,&60

defb &1
defb &68
defb &41
defb &D1
defb &3
defb &C2
defb &30,&12,&60,&40
defb &2
defb &30,&60,&80,&B1
defb &2
defb &20,&1,&E0
defb &F,&1
defb &81
defb &C2
defb &E
defb &81
defb &8
defb &20,&90,&80
defb &2
defb &C1
defb &2
defb &81
defb &10,&B0
defb &C2
defb &2
defb &81
defb &C2
defb &3
defb &10,&7
defb &5
defb &21
defb &10,&87
defb &2
defb &10,&60

defb &81
defb &4
defb &31
defb &20,&69,&D
defb &E2
defb &20,&78,&10
defb &C2
defb &31
defb &C2
defb &41
defb &10,&9

defb &1
defb &C2
defb &D2
defb &C1
defb &10,&72
defb &2
defb &10,&3C

defb &81
defb &C4
defb &41
defb &2
defb &20,&60,&80
defb &97
defb &11
defb &C1
defb &2
defb &C3
defb &10,&3
defb &82
defb &41
defb &2
defb &81
defb &10,&72
defb &E3
defb &C1
defb &2
defb &30,&E,&E0,&40
defb &E
defb &C3
defb &C
defb &41
defb &2
defb &C1
defb &8
defb &81
defb &41
defb &3
defb &41
defb &2
defb &81
defb &C1
defb &4
defb &81
defb &10,&30

defb &81
defb &3
defb &32
defb &11
defb &3
defb &81
defb &32
defb &41
defb &2
defb &10,&E0

defb &81
defb &5
defb &40,&E,&9,&F1,&18
defb &2
defb &C2
defb &40,&85,&70,&9,&88
defb &E3
defb &C2
defb &D1
defb &30,&80,&16,&E0
defb &42
defb &C2
defb &2
defb &81
defb &C2
defb &1
defb &67
defb &41
defb &10,&91
defb &C3
defb &1
defb &10,&3
defb &82
defb &20,&B0,&80
defb &D4
defb &10,&D5

defb &41
defb &2
defb &81
defb &20,&D0,&10

defb &81
defb &F,&c
defb &10,&E0
defb &F,&5
defb &41
defb &4
defb &81
defb &3
defb &C1
defb &10,&18
defb &34
defb &2
defb &33
defb &2
defb &C1
defb &30,&E0,&20,&D0

defb &1
defb &22
defb &11
defb &2
defb &61
defb &2
defb &21
defb &2
defb &10,&E

defb &11
defb &32
defb &21
defb &3
defb &81
defb &10,&FD
defb &D2
defb &C2
defb &30,&80,&96,&70
defb &2
defb &C2
defb &2
defb &81
defb &C2
defb &1
defb &81
defb &96
defb &A1
defb &20,&90,&34
defb &2
defb &20,&2,&60

defb &C1
defb &2
defb &E1
defb &41
defb &E3
defb &10,&D8

defb &C1
defb &2
defb &21
defb &10,&92
defb &C2
defb &41
defb &9
defb &81
defb &E
defb &41
defb &B
defb &41
defb &10,&80

defb &41
defb &9
defb &42
defb &7
defb &81
defb &10,&18
defb &38
defb &11
defb &2
defb &81
defb &C3
defb &1
defb &10,&D0

defb &41
defb &2
defb &C1
defb &30,&10,&C2,&10

defb &81
defb &C2
defb &31
defb &3
defb &31
defb &3
defb &A1
defb &E1
defb &F2
defb &E1
defb &30,&F4,&10,&B4

defb &C1
defb &3
defb &30,&90,&10,&E

defb &C1
defb &2
defb &21
defb &64
defb &41
defb &D2
defb &21
defb &20,&14,&80

defb &21
defb &2
defb &81
defb &C1
defb &42
defb &81
defb &20,&95,&91

defb &51
defb &D2
defb &2
defb &31
defb &10,&2D

defb &81
defb &C2
defb &1
defb &41
defb &F,&19
defb &41
defb &7
defb &41
defb &2
defb &C2
defb &20,&C0,&C0
defb &10,&18

defb &31
defb &3
defb &C1
defb &33
defb &20,&1,&10
defb &C3
defb &1
defb &20,&58,&90

defb &1
defb &C2
defb &1
defb &21
defb &2
defb &81
defb &C2
defb &20,&1E,&30
defb &33
defb &1
defb &A1
defb &F4
defb &D1
defb &30,&F8,&90,&D2

defb &41
defb &2
defb &C1
defb &81
defb &C2
defb &2
defb &21
defb &32
defb &10,&1
defb &93
defb &11
defb &30,&C8,&38,&16
defb &C2
defb &21
defb &3
defb &20,&70,&30
defb &E4
defb &10,&DA

defb &41
defb &2
defb &31
defb &10,&70

defb &11
defb &5
defb &C2
defb &10,&60
defb &F,&c
defb &81
defb &8
defb &81
defb &5
defb &42
defb &2
defb &10,&D0
defb &42
defb &20,&C0,&10

defb &61
defb &4
defb &81
defb &30,&C,&1,&10

defb &81
defb &C2
defb &1
defb &81
defb &C3
defb &40,&80,&30,&2,&1E
defb &C2
defb &30,&7D,&31,&7
defb &2
defb &A1
defb &F5
defb &40,&F4,&30,&C3,&80
defb &C2
defb &20,&E0,&D0

defb &41
defb &4
defb &C1
defb &41
defb &3
defb &80,&E0,&18,&3,&20,&2,&10,&70,&B0
defb &D4
defb &10,&D7
defb &3
defb &11
defb &C2
defb &2
defb &91
defb &3
defb &81
defb &C2
defb &42
defb &B
defb &10,&60
defb &F,&d
defb &C2
defb &2
defb &40,&70,&40,&68,&10

defb &61
defb &6
defb &31
defb &2
defb &C1
defb &2
defb &C2
defb &41
defb &10,&48

defb &C1
defb &3
defb &C2
defb &22
defb &10,&C3
defb &E2
defb &20,&1E,&30

defb &11
defb &3
defb &F6
defb &60,&E9,&70,&60,&C0,&90,&80
defb &C4
defb &40,&10,&E0,&90,&7
defb &4
defb &21
defb &3
defb &30,&82,&30,&60
defb &2
defb &30,&62,&C8,&42
defb &3
defb &11
defb &81
defb &C2
defb &1
defb &32
defb &4
defb &C2
defb &6
defb &40,&60,&80,&70,&E0
defb &82
defb &C3
defb &81
defb &30,&78,&30,&E0
defb &D
defb &81
defb &41
defb &6
defb &C3
defb &30,&E0,&90,&1C
defb &5
defb &31
defb &10,&20

defb &C1
defb &2
defb &81
defb &40,&61,&80,&21,&20
defb &C2
defb &20,&86,&B4
defb &D2
defb &72
defb &30,&31,&C1,&8
defb &F5
defb &71
defb &20,&C3,&F1
defb &5
defb &81
defb &2
defb &C2
defb &50,&E0,&60,&E0,&8,&43
defb &5
defb &81
defb &20,&C3,&C2

defb &81
defb &2
defb &81
defb &60,&10,&74,&E4,&53,&C0,&14
defb &C3
defb &1
defb &10,&D0
defb &33
defb &C1
defb &20,&D2,&10

defb &C1
defb &5
defb &10,&60
defb &2
defb &C2
defb &10,&20
defb &C2
defb &20,&87,&78

defb &91
defb &C4
defb &41
defb &9
defb &81
defb &20,&10,&10
defb &30,&E0,&80,&90
defb &C3
defb &61
defb &C2
defb &32
defb &5
defb &31
defb &10,&60

defb &C1
defb &83
defb &20,&D2,&80
defb &20,&30,&30
defb &10,&4A
defb &C2
defb &32
defb &E4
defb &30,&38,&80,&C
defb &F4
defb &20,&7D,&C3
defb &E2
defb &C5
defb &4
defb &31
defb &91
defb &C2
defb &41
defb &C1
defb &42
defb &32
defb &41
defb &30,&80,&10,&E0
defb &32
defb &20,&C2,&60

defb &1
defb &C2
defb &1
defb &50,&7A,&72,&52,&C0,&14
defb &20,&30,&30
defb &30,&B0,&34,&E0

defb &41
defb &32
defb &11
defb &C2
defb &5
defb &61
defb &C7
defb &61
defb &91
defb &33
defb &91
defb &C6
defb &A
defb &81
defb &50,&10,&6,&B0,&10,&B4

defb &C1
defb &92
defb &C1
defb &10,&2D
defb &5
defb &31
defb &1
defb &C2
defb &82
defb &41
defb &C2
defb &60,&90,&21,&70,&A4,&3C,&7D
defb &D5
defb &11
defb &20,&C0,&8C

defb &E1
defb &F3
defb &E1
defb &32
defb &91
defb &C2
defb &D3
defb &31
defb &10,&61
defb &2
defb &20,&6,&86

defb &C1
defb &42
defb &C1
defb &10,&8
defb &C2
defb &20,&80,&90
defb &C3
defb &91
defb &82
defb &80,&C0,&48,&60,&48,&30,&2,&E0,&14
defb &2
defb &e0,&30,&60,&A4,&30,&20,&68,&E1,&10,&E0,&C,&80,&70,&2C,&78
defb &8
defb &10,&70
defb &C2
defb &2
defb &81
defb &2
defb &81
defb &10,&3C
defb &C4
defb &32
defb &C5
defb &61
defb &C1
defb &62
defb &C1
defb &10,&69

defb &11
defb &4
defb &21
defb &10,&80
defb &C3
defb &41
defb &20,&D2,&90

defb &61
defb &C2
defb &61
defb &1
defb &63
defb &B1
defb &E3
defb &40,&6B,&3C,&60,&86

defb &D1
defb &F2
defb &D2
defb &32
defb &91
defb &10,&80
defb &C4
defb &33
defb &4
defb &32
defb &C1
defb &42
defb &10,&C
defb &C2
defb &20,&D0,&80
defb &C2
defb &40,&14,&E0,&90,&58
defb &C2
defb &10,&8
defb &2
defb &10,&82
defb &C3
defb &3
defb &C2
defb &42
defb &10,&4

defb &81
defb &42
defb &3
defb &30,&1E,&78,&87
defb &C2
defb &30,&10,&30,&E0
defb &A
defb &81
defb &2
defb &C6
defb &61
defb &C2
defb &34
defb &50,&69,&E1,&D2,&D0,&E1
defb &92
defb &20,&78,&7
defb &3
defb &21
defb &2
defb &20,&70,&70
defb &10,&B4

defb &C1
defb &93
defb &C2
defb &31
defb &C2
defb &D1
defb &91
defb &D3
defb &40,&6D,&3D,&20,&8F
defb &E4
defb &61
defb &32
defb &41
defb &3
defb &81
defb &10,&18
defb &34
defb &3
defb &21
defb &81
defb &C2
defb &2
defb &11
defb &C3
defb &2
defb &81
defb &C2
defb &60,&4,&40,&30,&38,&C0,&18
defb &2
defb &30,&82,&78,&61
defb &2
defb &10,&E0

defb &81
defb &2
defb &91
defb &10,&12

defb &41
defb &4
defb &81
defb &C3
defb &81
defb &C2
defb &10,&10

defb &41
defb &2
defb &11
defb &8
defb &41
defb &2
defb &81
defb &70,&10,&96,&78,&7,&60,&40,&E0
defb &3
defb &C3
defb &20,&80,&D2
defb &62
defb &C2
defb &32
defb &3
defb &11
defb &10,&20
defb &20,&70,&70
defb &62
defb &10,&70

defb &61
defb &C3
defb &10,&58
defb &E3
defb &61
defb &E3
defb &61
defb &30,&1C,&8,&87
defb &D4
defb &32
defb &10,&25
defb &4
defb &33
defb &11
defb &21
defb &33
defb &10,&8

defb &91
defb &C2
defb &2
defb &11
defb &81
defb &C3
defb &1
defb &C2
defb &2
defb &11
defb &50,&C0,&E0,&8,&80,&38
defb &2
defb &30,&82,&78,&43
defb &3
defb &81
defb &C1
defb &3
defb &10,&2

defb &41
defb &2
defb &91
defb &4
defb &81
defb &2
defb &81
defb &10,&30

defb &41
defb &2
defb &11
defb &8
defb &10,&70
defb &4
defb &20,&68,&87
defb &C2
defb &A
defb &20,&E0,&80
defb &92
defb &20,&B4,&B4
defb &10,&3C

defb &11
defb &2
defb &11
defb &10,&60

defb &91
defb &C2
defb &61
defb &10,&E1

defb &91
defb &C3
defb &91
defb &C3
defb &71
defb &D5
defb &20,&70,&8

defb &1
defb &33
defb &E3
defb &61
defb &33
defb &41
defb &2
defb &10,&E
defb &3
defb &34
defb &1
defb &20,&3,&E1

defb &41
defb &2
defb &11
defb &1
defb &C8
defb &21
defb &C3
defb &1
defb &10,&18
defb &2
defb &20,&78,&C0

defb &41
defb &3
defb &31
defb &4
defb &31
defb &50,&30,&60,&42,&40,&86

defb &41
defb &5
defb &20,&90,&B0

defb &41
defb &2
defb &11
defb &9
defb &C1
defb &41
defb &F,&4
defb &20,&E0,&80
defb &64
defb &20,&78,&78

defb &11
defb &2
defb &31
defb &10,&80

defb &61
defb &C2
defb &61
defb &81
defb &62
defb &C2
defb &61
defb &C3
defb &61
defb &E1
defb &B2
defb &E2
defb &C1
defb &5
defb &34
defb &D2
defb &33
defb &30,&25,&C,&1
defb &C5
defb &41
defb &4
defb &10,&C2
defb &3
defb &11
defb &20,&80,&78
defb &32
defb &91
defb &C2
defb &61
defb &10,&70

defb &81
defb &5
defb &91
defb &C3
defb &41
defb &3
defb &11
defb &4
defb &31
defb &20,&10,&E0

defb &61
defb &2
defb &41
defb &10,&87
defb &C2
defb &41
defb &4
defb &81
defb &10,&D0

defb &41
defb &3
defb &21
defb &8
defb &81
defb &8
defb &10,&E0
defb &9
defb &C3
defb &10,&90

defb &C1
defb &95
defb &10,&78

defb &31
defb &2
defb &31
defb &2
defb &C3
defb &21
defb &10,&C0
defb &92
defb &C1
defb &92
defb &C2
defb &91
defb &D2
defb &91
defb &D2
defb &11
defb &20,&C0,&10

defb &21
defb &39
defb &20,&52,&4

defb &1
defb &D5
defb &20,&91,&70
defb &2
defb &10,&6
defb &2
defb &30,&A4,&10,&68
defb &3
defb &81
defb &10,&78

defb &41
defb &2
defb &81
defb &41
defb &3
defb &10,&87
defb &C2
defb &11
defb &3
defb &30,&9,&70,&C

defb &41
defb &2
defb &C1
defb &20,&6,&30

defb &81
defb &33
defb &10,&70
defb &5
defb &41
defb &10,&30
defb &C2
defb &21
defb &F,&2
defb &10,&E0

defb &41
defb &8
defb &C1
defb &82
defb &C3
defb &63
defb &C1
defb &62
defb &C1
defb &31
defb &2
defb &31
defb &10,&80

defb &C1
defb &62
defb &21
defb &1
defb &62
defb &C1
defb &65
defb &C1
defb &E4
defb &10,&16
defb &2
defb &10,&10
defb &3A
defb &20,&21,&6
defb &E5
defb &41
defb &A1
defb &E3
defb &C1
defb &2
defb &31
defb &20,&80,&96

defb &41
defb &2
defb &21
defb &10,&E0
defb &2
defb &50,&78,&C0,&C8,&90,&70

defb &21
defb &2
defb &C1
defb &10,&7
defb &2
defb &60,&D,&61,&8,&C0,&60,&4
defb &3
defb &11
defb &21
defb &C3
defb &10,&10
defb &C2
defb &42
defb &10,&60
defb &C2
defb &10,&14
defb &F,&2
defb &C1
defb &C
defb &C4
defb &96
defb &31
defb &2
defb &31
defb &10,&41

defb &C1
defb &92
defb &61
defb &C2
defb &92
defb &C1
defb &92
defb &C1
defb &10,&61

defb &C1
defb &D2
defb &71
defb &30,&2D,&81,&10

defb &61
defb &39
defb &61
defb &2
defb &C1
defb &D5
defb &81
defb &D4
defb &70,&51,&8,&E0,&52,&80,&38,&E0

defb &41
defb &2
defb &21
defb &40,&E4,&C4,&91,&75

defb &21
defb &2
defb &C2
defb &11
defb &2
defb &30,&4A,&70,&C

defb &81
defb &C3
defb &5
defb &11
defb &62
defb &10,&87

defb &41
defb &2
defb &81
defb &44
defb &10,&80
defb &C2
defb &10,&D0
defb &F,&0
defb &41
defb &9
defb &C1
defb &10,&10

defb &81
defb &62
defb &C1
defb &65
defb &C1
defb &31
defb &2
defb &21
defb &10,&1

defb &81
defb &63
defb &C1
defb &65
defb &C1
defb &63
defb &E3
defb &61
defb &10,&F2

defb &31
defb &3
defb &91
defb &38
defb &92
defb &1
defb &81
defb &E5
defb &1
defb &E6
defb &41
defb &20,&C,&E0

defb &41
defb &2
defb &C2
defb &1
defb &10,&E0

defb &41
defb &2
defb &21
defb &40,&EA,&C8,&98,&72
defb &5
defb &11
defb &20,&60,&78

defb &C1
defb &2
defb &11
defb &7
defb &41
defb &30,&4,&4A,&1C
defb &C2
defb &2
defb &81
defb &42
defb &C1
defb &2
defb &30,&E0,&96,&70
defb &F,&8
defb &C1
defb &41
defb &C3
defb &97
defb &31
defb &11
defb &2
defb &21
defb &1
defb &C3
defb &93
defb &C1
defb &97
defb &11
defb &C1
defb &D2
defb &71
defb &D2
defb &20,&4,&8

defb &61
defb &38
defb &61
defb &10,&10

defb &81
defb &D4
defb &51
defb &D8
defb &10,&4

defb &81
defb &2
defb &C1
defb &81
defb &C2
defb &2
defb &C1
defb &10,&C0
defb &2
defb &20,&E4,&E4
defb &30,&91,&31,&70
defb &2
defb &10,&A4
defb &C3
defb &61
defb &3
defb &11
defb &2
defb &10,&70
defb &2
defb &20,&60,&24
defb &22
defb &50,&8,&81,&10,&30,&58
defb &3
defb &81
defb &30,&58,&E1,&8

defb &31
defb &F,&5
defb &C1
defb &20,&8,&81
defb &67
defb &31
defb &3
defb &21
defb &1
defb &C3
defb &69
defb &41
defb &10,&52

defb &81
defb &E2
defb &31
defb &E2
defb &20,&1C,&80

defb &91
defb &37
defb &92
defb &10,&81

defb &41
defb &E4
defb &41
defb &1
defb &E7
defb &81
defb &4
defb &C4
defb &2
defb &C1
defb &20,&E8,&10
defb &20,&EA,&EA

defb &41
defb &E2
defb &1
defb &10,&72

defb &1
defb &C2
defb &91
defb &C3
defb &61
defb &C1
defb &2
defb &11
defb &20,&60,&E0
defb &2
defb &11
defb &C2
defb &11
defb &22
defb &6
defb &20,&90,&1C
defb &5
defb &11
defb &30,&D2,&E,&6
defb &2
defb &10,&60
defb &2
defb &C3
defb &41
defb &10,&C0
defb &4
defb &20,&D0,&80

defb &1
defb &C2
defb &41
defb &C2
defb &95
defb &11
defb &3
defb &21
defb &20,&C1,&80

defb &C1
defb &98
defb &3
defb &81
defb &D2
defb &91
defb &D2
defb &20,&18,&8
defb &62
defb &36
defb &62
defb &10,&C0

defb &51
defb &D6
defb &1
defb &D6
defb &2
defb &10,&E0
defb &2
defb &C2
defb &10,&16
defb &2
defb &81
defb &D2
defb &1
defb &81
defb &D3
defb &81
defb &D2
defb &1
defb &10,&75

defb &81
defb &C2
defb &91
defb &C3
defb &61
defb &C1
defb &3
defb &20,&70,&E0
defb &2
defb &10,&C1

defb &41
defb &3
defb &D2
defb &5
defb &C1
defb &20,&18,&80

defb &11
defb &2
defb &31
defb &30,&C0,&90,&38

defb &31
defb &C6
defb &41
defb &C5
defb &41
defb &2
defb &21
defb &C5
defb &11
defb &2
defb &81
defb &65
defb &11
defb &3
defb &21
defb &11
defb &3
defb &21
defb &68
defb &1
defb &D2
defb &10,&C8

defb &31
defb &E3
defb &20,&1C,&80
defb &92
defb &35
defb &92
defb &11
defb &81
defb &E8
defb &41
defb &E7
defb &C1
defb &20,&C0,&90
defb &C2
defb &10,&3

defb &C1
defb &2
defb &E2
defb &41
defb &A1
defb &E3
defb &60,&EA,&10,&7A,&E1,&52,&2C
defb &C2
defb &41
defb &2
defb &81
defb &3
defb &C1
defb &2
defb &10,&81
defb &3
defb &31
defb &1
defb &42
defb &4
defb &C1
defb &50,&18,&48,&C1,&18,&83
defb &C2
defb &10,&10

defb &C1
defb &32
defb &91
defb &C2
defb &2
defb &C6
defb &2
defb &30,&E1,&80,&10

defb &41
defb &3
defb &C1
defb &92
defb &C1
defb &10,&7
defb &3
defb &21
defb &30,&89,&72,&C2
defb &96
defb &10,&9
defb &42
defb &10,&84
defb &D4
defb &20,&14,&8
defb &63
defb &32
defb &64
defb &1
defb &81
defb &D8
defb &1
defb &D8
defb &40,&80,&90,&70,&1

defb &41
defb &2
defb &81
defb &10,&75

defb &81
defb &D2
defb &51
defb &D2
defb &51
defb &D2
defb &21
defb &C2
defb &20,&C2,&96
defb &C2
defb &30,&18,&80,&70
defb &4
defb &10,&81
defb &3
defb &91
defb &D1
defb &52
defb &6
defb &81
defb &40,&70,&C1,&10,&6
defb &F,&0
defb &C3
defb &2
defb &21
defb &2
defb &81
defb &10,&10

defb &11
defb &3
defb &81
defb &C2
defb &61
defb &31
defb &4
defb &21
defb &31
defb &53
defb &1
defb &62
defb &C1
defb &63
defb &C1
defb &30,&18,&E5,&86
defb &E4
defb &20,&14,&20
defb &98
defb &10,&1
defb &E8
defb &1
defb &E8
defb &41
defb &40,&80,&B0,&38,&80

defb &41
defb &3
defb &E2
defb &A1
defb &E5
defb &1
defb &E2
defb &21
defb &C2
defb &10,&D2

defb &31
defb &C2
defb &32
defb &61
defb &10,&3
defb &C2
defb &41
defb &3
defb &10,&D0

defb &41
defb &2
defb &B1
defb &30,&D8,&10,&E0

defb &41
defb &3
defb &40,&61,&68,&40,&6
defb &8
defb &10,&70
defb &6
defb &10,&E0
defb &2
defb &81
defb &2
defb &81
defb &50,&30,&D8,&10,&60,&E
defb &6
defb &31
defb &E2
defb &41
defb &1
defb &C2
defb &81
defb &41
defb &4
defb &21
defb &20,&EB,&83
defb &D5
defb &31
defb &10,&60

defb &21
defb &67
defb &10,&10

defb &C1
defb &D7
defb &81
defb &D9
defb &40,&90,&B0,&3C,&81

defb &41
defb &3
defb &D7
defb &51
defb &20,&E4,&1D
defb &C2
defb &10,&D2

defb &31
defb &C3
defb &30,&C3,&12,&70
defb &2
defb &20,&30,&68

defb &31
defb &2
defb &91
defb &10,&D5
defb &2
defb &80,&78,&3,&60,&21,&28,&40,&2,&E0

defb &41
defb &2
defb &81
defb &C3
defb &4
defb &D2
defb &5
defb &21
defb &2
defb &C2
defb &21
defb &1
defb &D2
defb &3
defb &10,&6
defb &3
defb &41
defb &2
defb &90,&3,&39,&4,&80,&90,&11,&68,&31,&82
defb &E4
defb &20,&38,&60

defb &81
defb &97
defb &2
defb &E4
defb &2
defb &E5
defb &41
defb &2
defb &A1
defb &E3
defb &41
defb &2
defb &81
defb &30,&3,&81,&C0
defb &2
defb &E7
defb &1
defb &E2
defb &30,&14,&E0,&D2

defb &21
defb &C2
defb &61
defb &C2
defb &20,&16,&60
defb &2
defb &10,&30
defb &33
defb &11
defb &b0,&4,&52,&80,&D0,&A1,&70,&1,&28,&60,&2,&D0
defb &43
defb &1
defb &20,&68,&E1
defb &2
defb &20,&62,&72
defb &3
defb &C2
defb &2
defb &41
defb &10,&B0

defb &1
defb &A2
defb &3
defb &21
defb &2
defb &41
defb &40,&C0,&90,&3,&18
defb &42
defb &3
defb &41
defb &E1
defb &2
defb &21
defb &20,&C8,&86

defb &C1
defb &D4
defb &21
defb &10,&70

defb &1
defb &66
defb &41
defb &10,&80
defb &D3
defb &3
defb &81
defb &D3
defb &30,&11,&70,&80
defb &D3
defb &2
defb &81
defb &61
defb &12
defb &2
defb &C1
defb &10,&10

defb &81
defb &D6
defb &81
defb &D2
defb &10,&4
defb &2
defb &30,&1,&42,&78
defb &C2
defb &10,&16
defb &2
defb &10,&E0

defb &41
defb &4
defb &81
defb &D2
defb &21
defb &2
defb &81
defb &10,&70

defb &91
defb &C2
defb &1
defb &11
defb &3
defb &20,&24,&3

defb &C1
defb &42
defb &C1
defb &42
defb &20,&30,&45
defb &2
defb &20,&E4,&64
defb &3
defb &C1
defb &10,&92
defb &42
defb &10,&38

defb &41
defb &D2
defb &3
defb &70,&6,&40,&80,&D0,&83,&75,&60

defb &81
defb &2
defb &91
defb &40,&75,&E4,&65,&4
defb &E4
defb &30,&30,&D0,&80
defb &95
defb &1
defb &10,&90
defb &E2
defb &41
defb &4
defb &E3
defb &2
defb &10,&E0
defb &2
defb &E2
defb &C1
defb &2
defb &81
defb &30,&30,&3,&E0

defb &41
defb &2
defb &E5
defb &41
defb &E3
defb &60,&4,&E0,&16,&42,&78,&61

defb &61
defb &2
defb &82
defb &11
defb &10,&70
defb &3
defb &A2
defb &E1
defb &10,&DA

defb &41
defb &2
defb &41
defb &91
defb &7
defb &10,&38

defb &91
defb &42
defb &C1
defb &50,&10,&70,&30,&89,&32
defb &A2
defb &10,&72
defb &4
defb &10,&B0
defb &42
defb &C1
defb &2
defb &41
defb &E1
defb &3
defb &10,&6
defb &20,&80,&80
defb &20,&C0,&52
defb &E2
defb &50,&E0,&40,&8C,&1C,&C8

defb &11
defb &2
defb &11
defb &C1
defb &D4
defb &81
defb &20,&92,&10

defb &21
defb &62
defb &41
defb &20,&80,&90
defb &D2
defb &2
defb &20,&70,&80
defb &D2
defb &3
defb &C1
defb &30,&10,&E4,&60
defb &2
defb &50,&38,&3,&E0,&14,&80
defb &D7
defb &2
defb &11
defb &81
defb &C2
defb &11
defb &10,&2
defb &C2
defb &10,&61

defb &21
defb &2
defb &C1
defb &10,&14

defb &81
defb &C2
defb &4
defb &D4
defb &51
defb &1
defb &92
defb &C2
defb &41
defb &4
defb &42
defb &40,&C1,&E1,&1,&24

defb &1
defb &82
defb &2
defb &D3
defb &10,&7
defb &3
defb &81
defb &10,&92
defb &42
defb &81
defb &2
defb &D2
defb &51
defb &5
defb &81
defb &50,&80,&40,&43,&B1,&80

defb &1
defb &D2
defb &82
defb &71
defb &30,&45,&69,&4
defb &E4
defb &C2
defb &21
defb &2
defb &31
defb &7
defb &E2
defb &41
defb &10,&C0
defb &42
defb &10,&88
defb &E2
defb &11
defb &2
defb &81
defb &41
defb &2
defb &E1
defb &41
defb &3
defb &20,&16,&2
defb &C2
defb &10,&14
defb &2
defb &E7
defb &2
defb &31
defb &81
defb &C2
defb &11
defb &10,&2
defb &C2
defb &91
defb &2
defb &41
defb &30,&60,&34,&60

defb &31
defb &4
defb &E2
defb &1
defb &20,&72,&84
defb &C6
defb &20,&10,&10

defb &11
defb &C2
defb &12
defb &1
defb &20,&24,&80

defb &C1
defb &2
defb &A1
defb &80,&72,&7,&60,&C0,&90,&40,&20,&BA

defb &41
defb &E2
defb &4
defb &C1
defb &1
defb &82
defb &2
defb &41
defb &A2
defb &30,&90,&C,&40
defb &2
defb &30,&41,&69,&8

defb &81
defb &D4
defb &41
defb &20,&2,&E
defb &7
defb &C1
defb &10,&7D
defb &3
defb &C1
defb &20,&84,&7D

defb &11
defb &2
defb &81
defb &41
defb &2
defb &91
defb &40,&71,&8,&1,&2
defb &C2
defb &10,&6
defb &2
defb &D1
defb &92
defb &D3
defb &3
defb &21
defb &81
defb &C2
defb &21
defb &3
defb &C1
defb &10,&61

defb &1
defb &C2
defb &1
defb &20,&E0,&C0
defb &2
defb &10,&64
defb &D3
defb &31
defb &20,&C5,&84
defb &C2
defb &41
defb &6
defb &C1
defb &91
defb &C2
defb &11
defb &2
defb &10,&24
defb &C2
defb &21
defb &2
defb &D3
defb &20,&4,&C0

defb &41
defb &C2
defb &81
defb &50,&4,&2,&95,&75,&E4
defb &3
defb &41
defb &10,&C0

defb &81
defb &2
defb &C1
defb &30,&E4,&80,&44
defb &82
defb &80,&11,&45,&28,&C,&C8,&8F,&16,&2
defb &33
defb &2
defb &21
defb &32
defb &1
defb &E2
defb &61
defb &11
defb &3
defb &20,&8E,&7A

defb &31
defb &2
defb &81
defb &40,&8,&8F,&F2,&8
defb &2
defb &20,&82,&70

defb &31
defb &3
defb &10,&BE

defb &91
defb &E2
defb &41
defb &3
defb &21
defb &1
defb &C2
defb &1
defb &10,&1
defb &C2
defb &10,&61

defb &1
defb &C2
defb &2
defb &81
defb &C1
defb &2
defb &E5
defb &30,&10,&6,&A4

defb &81
defb &C2
defb &1
defb &C2
defb &5
defb &C2
defb &91
defb &2
defb &50,&24,&E1,&2,&6A,&88

defb &41
defb &2
defb &11
defb &C4
defb &2
defb &20,&10,&9C
defb &E2
defb &22
defb &5
defb &41
defb &81
defb &2
defb &81
defb &60,&62,&80,&C8,&12,&32,&41

defb &81
defb &4
defb &3B
defb &11
defb &32
defb &21
defb &30,&C0,&7D,&7

defb &21
defb &32
defb &91
defb &D2
defb &32
defb &10,&81

defb &1
defb &32
defb &D3
defb &10,&8
defb &2
defb &21
defb &C2
defb &61
defb &11
defb &3
defb &21
defb &32
defb &71
defb &91
defb &6
defb &81
defb &10,&70

defb &11
defb &2
defb &C1
defb &20,&61,&80

defb &C1
defb &5
defb &10,&64

defb &1
defb &D3
defb &3
defb &31
defb &10,&60
defb &3
defb &C1
defb &3
defb &81
defb &C4
defb &40,&80,&10,&20,&81
defb &2
defb &20,&3D,&C
defb &D2
defb &10,&84
defb &C4
defb &2
defb &20,&70,&35
defb &82
defb &71
defb &7
defb &81
defb &4
defb &51
defb &3
defb &32
defb &1
defb &20,&E,&45

defb &81
defb &1
PicEp2Intropng_rledataEnd: defb 0
PicEp2IntroRedrawpng:
ld (StackRestore_Plus2-2),sp
di
ld sp,&C000+0+80

LD IX,PicEp2IntroRedrawpng_DrawOrder
JP JumpToNextLine


PicEp2IntroRedrawpng_Line_0:
LD DE,&0000
jp MultiPushDeLast40


PicEp2IntroRedrawpng_Line_1:
call MultiPushDe5
call BitmapPush6
defw BitmapData+5
jp MultiPushDeLast32


PicEp2IntroRedrawpng_Line_2:
call MultiPushDe5
call BitmapPush6
defw BitmapData+11
jp MultiPushDeLast32


PicEp2IntroRedrawpng_Line_3:
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&00C0
  Push HL
LD BC,&F0FE
  Push BC
Ld D,B
Ld E,B

  PUSH DE
  PUSH DE
LD HL,&3000
  Push HL
Ld D,L
Ld E,L

jp MultiPushDeLast31


PicEp2IntroRedrawpng_Line_4:
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&00F0
  Push HL
LD BC,&FEF1
  Push BC
Ld D,L
Ld E,L

  PUSH DE
  PUSH DE
LD HL,&F000
  Push HL
Ld D,L
Ld E,L

jp MultiPushDeLast31


PicEp2IntroRedrawpng_Line_5:
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&80F0
  Push HL
LD BC,&7300
  Push BC
  PUSH DE
Ld H,&00
  Push HL
LD BC,&F010
  Push BC
jp MultiPushDeLast31


PicEp2IntroRedrawpng_Line_6:
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&E0FF
  Push HL
  PUSH DE
  PUSH DE
LD BC,&0080
  Push BC
LD HL,&F030
  Push HL
jp MultiPushDeLast31


PicEp2IntroRedrawpng_Line_7:
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&FC31
  Push HL
  PUSH DE
  PUSH DE
  PUSH DE
LD BC,&E070
  Push BC
jp MultiPushDeLast31


PicEp2IntroRedrawpng_Line_8:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&00C0
  Push HL
LD BC,&F610
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&80F0
  Push HL
jp MultiPushDeLast31


PicEp2IntroRedrawpng_Line_9:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&00E0
  Push HL
LD BC,&F300
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
Ld L,&F0
  Push HL
Ld B,&10
  Push BC
jp MultiPushDeLast30


PicEp2IntroRedrawpng_Line_10:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&00F0
  Push HL
LD BC,&7000
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
Ld L,&E0
  Push HL
Ld B,&30
  Push BC
jp MultiPushDeLast30


PicEp2IntroRedrawpng_Line_11:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&00F0
  Push HL
LD BC,&1000
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
Ld L,&E0
  Push HL
Ld B,&30
  Push BC
jp MultiPushDeLast30


PicEp2IntroRedrawpng_Line_12:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&0070
  Push HL
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
LD BC,&00C0
  Push BC
LD HL,&7000
  Push HL
jp MultiPushDeLast30


PicEp2IntroRedrawpng_Line_13:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&8070
  Push HL
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
Ld B,E
Ld C,H

  Push BC
LD HL,&F000
  Push HL
jp MultiPushDeLast30


PicEp2IntroRedrawpng_Line_14:
  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush6
defw BitmapData+17
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&F010
  Push HL
  PUSH DE
  PUSH DE
LD BC,&0C01
  Push BC
jp MultiPushDeLast27


PicEp2IntroRedrawpng_Line_15:
  PUSH DE
  PUSH DE
  PUSH DE
LD HL,&C0F0
  Push HL
Ld D,L
Ld E,L

  PUSH DE
  PUSH DE
LD BC,&2000
  Push BC
Ld D,C
Ld E,C

  PUSH DE
  PUSH DE
LD HL,&E831
  Push HL
  PUSH DE
  PUSH DE
LD BC,&0F21
  Push BC
jp MultiPushDeLast27


PicEp2IntroRedrawpng_Line_16:
  PUSH DE
  PUSH DE
LD HL,&0080
  Push HL
Call PushDE_F0F0x
call BitmapPush12
defw BitmapData+29
LD DE,&0000
jp MultiPushDeLast27


PicEp2IntroRedrawpng_Line_17:
  PUSH DE
  PUSH DE
LD HL,&00E0
  Push HL
Call PushDE_F0F0x
call BitmapPush12
defw BitmapData+41
LD DE,&0000
jp MultiPushDeLast27


PicEp2IntroRedrawpng_Line_18:
  PUSH DE
  PUSH DE
LD HL,&80F0
  Push HL
LD BC,&7000
  Push BC
  PUSH DE
  PUSH DE
Ld H,&00
  Push HL
LD BC,&F010
  Push BC
  PUSH DE
LD HL,&8072
  Push HL
  PUSH DE
call BitmapPush6
defw BitmapData+47
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_19:
  PUSH DE
  PUSH DE
LD HL,&F0F0
  Push HL
LD BC,&1000
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
  Push HL 
  PUSH DE
LD HL,&0072
  Push HL
  PUSH DE
call BitmapPush6
defw BitmapData+53
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_20:
  PUSH DE
LD HL,&0080
  Push HL
LD BC,&F030
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush6
defw BitmapData+59
  PUSH DE
call BitmapPush6
defw BitmapData+65
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_21:
  PUSH DE
LD HL,&00C8
  Push HL
LD BC,&7000
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush6
defw BitmapData+71
  PUSH DE
call BitmapPush6
defw BitmapData+77
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_22:
  PUSH DE
LD HL,&00E4
  Push HL
LD BC,&3000
  Push BC
  PUSH DE
  PUSH DE
Ld L,&80
  Push HL
LD BC,&F0F0
  Push BC
  PUSH DE
LD HL,&FC10
  Push HL
LD BC,&00E4
  Push BC
  PUSH DE
  PUSH DE
LD HL,&02C0
  Push HL
LD BC,&6100
  Push BC
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_23:
  PUSH DE
LD HL,&80F2
  Push HL
  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+89
  PUSH DE
LD BC,&0780
  Push BC
LD HL,&5200
  Push HL
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_24:
  PUSH DE
call BitmapPush6
defw BitmapData+95
  PUSH DE
call BitmapPush12
defw BitmapData+107
  PUSH DE
LD HL,&4A10
  Push HL
LD BC,&7000
  Push BC
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_25:
  PUSH DE
call BitmapPush6
defw BitmapData+113
  PUSH DE
call BitmapPush12
defw BitmapData+125
  PUSH DE
LD HL,&8221
  Push HL
LD BC,&7000
  Push BC
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_26:
  PUSH DE
call BitmapPush6
defw BitmapData+131
  PUSH DE
call BitmapPush18
defw BitmapData+149
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_27:
  PUSH DE
call BitmapPush6
defw BitmapData+155
  PUSH DE
call BitmapPush20
defw BitmapData+175
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_28:
call BitmapPush6
defw BitmapData+181
  PUSH DE
  PUSH DE
LD HL,&80F8
  Push HL
LD BC,&FF10
  Push BC
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+193
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_29:
call BitmapPush6
defw BitmapData+199
  PUSH DE
  PUSH DE
LD HL,&80F0
  Push HL
LD BC,&F010
  Push BC
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+211
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_30:
call BitmapPush6
defw BitmapData+217
  PUSH DE
  PUSH DE
LD HL,&00F0
  Push HL
LD BC,&F010
  Push BC
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+229
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_31:
call BitmapPush14
defw BitmapData+243
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+255
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_32:
LD HL,&00E0
  Push HL
  PUSH DE
call BitmapPush6
defw BitmapData+261
  PUSH DE
  PUSH DE
call BitmapPush16
defw BitmapData+277
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_33:
LD HL,&00E0
  Push HL
  PUSH DE
  Push HL 
LD DE,&F0F0
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+289
LD DE,&0000
  PUSH DE
  PUSH DE
LD BC,&2C21
  Push BC
LD HL,&0B01
  Push HL
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_34:
LD HL,&0070
  Push HL
  PUSH DE
call BitmapPush8
defw BitmapData+297
  PUSH DE
call BitmapPush16
defw BitmapData+313
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_35:
LD HL,&0070
  Push HL
  PUSH DE
LD BC,&00E0
  Push BC
  PUSH DE
call BitmapPush22
defw BitmapData+335
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_36:
LD HL,&0030
  Push HL
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush20
defw BitmapData+355
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_37:
LD HL,&8030
  Push HL
LD BC,&8010
  Push BC
  PUSH DE
  PUSH DE
  PUSH DE

Ld L,E

  Push HL
  PUSH DE
  PUSH DE
call BitmapPush14
defw BitmapData+369
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_38:
call BitmapPush6
defw BitmapData+375
call MultiPushDe6
call BitmapPush12
defw BitmapData+387
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_39:
call BitmapPush10
defw BitmapData+397
  PUSH DE
  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush12
defw BitmapData+409
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_40:
LD HL,&C811
  Push HL
LD BC,&C810
  Push BC
  PUSH DE
LD HL,&E0F0
  Push HL
Ld B,L
Ld C,L

  Push BC
  PUSH DE
  PUSH DE
call BitmapPush16
defw BitmapData+425
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_41:
call BitmapPush6
defw BitmapData+431
LD DE,&F0F0
  PUSH DE
  PUSH DE
LD HL,&3000
  Push HL
Ld B,L
Ld C,L

  Push BC
  PUSH DE
call BitmapPush14
defw BitmapData+445
LD DE,&0000
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_42:
call BitmapPush30
defw BitmapData+475
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_43:
call BitmapPush30
defw BitmapData+505
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_44:
call BitmapPush30
defw BitmapData+535
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_45:
call BitmapPush30
defw BitmapData+565
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_46:
call BitmapPush30
defw BitmapData+595
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_47:
call BitmapPush10
defw BitmapData+605
  PUSH DE
call BitmapPush6
defw BitmapData+611
  PUSH DE
call BitmapPush10
defw BitmapData+621
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_48:
call BitmapPush18
defw BitmapData+639
  PUSH DE
call BitmapPush10
defw BitmapData+649
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_49:
call BitmapPush18
defw BitmapData+667
  PUSH DE
LD HL,&0008
  Push HL
LD BC,&8690
  Push BC
LD DE,&2DA5
  PUSH DE
  PUSH DE
LD HL,&D216
  Push HL
LD DE,&0000
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_50:
call BitmapPush18
defw BitmapData+685
  PUSH DE
call BitmapPush10
defw BitmapData+695
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_51:
call BitmapPush18
defw BitmapData+713
  PUSH DE
call BitmapPush10
defw BitmapData+723
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_52:
call BitmapPush18
defw BitmapData+741
  PUSH DE
  PUSH DE
call BitmapPush8
defw BitmapData+749
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_53:
call BitmapPush18
defw BitmapData+767
  PUSH DE
  PUSH DE
call BitmapPush8
defw BitmapData+775
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_54:
call BitmapPush18
defw BitmapData+793
  PUSH DE
  PUSH DE
call BitmapPush8
defw BitmapData+801
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_55:
call BitmapPush18
defw BitmapData+819
  PUSH DE
  PUSH DE
call BitmapPush8
defw BitmapData+827
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_56:
call BitmapPush18
defw BitmapData+845
  PUSH DE
  PUSH DE
call BitmapPush8
defw BitmapData+853
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_57:
call BitmapPush8
defw BitmapData+861
DEC DE

  PUSH DE
  PUSH DE
LD HL,&33FF
  Push HL
  PUSH DE
LD BC,&FB30
  Push BC
INC DE

  PUSH DE
  PUSH DE
call BitmapPush8
defw BitmapData+869
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_58:
call BitmapPush8
defw BitmapData+877
DEC DE

  PUSH DE
  PUSH DE
LD HL,&77EE
  Push HL
  PUSH DE
call BitmapPush14
defw BitmapData+891
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_59:
call BitmapPush8
defw BitmapData+899
DEC DE

  PUSH DE
  PUSH DE
LD HL,&33FF
  Push HL
  PUSH DE
call BitmapPush14
defw BitmapData+913
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_60:
call BitmapPush8
defw BitmapData+921
DEC DE

  PUSH DE
  PUSH DE
LD HL,&99FF
  Push HL
  PUSH DE
call BitmapPush14
defw BitmapData+935
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_61:
call BitmapPush8
defw BitmapData+943
Call PushDE_FFFFx
call BitmapPush14
defw BitmapData+957
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_62:
call BitmapPush10
defw BitmapData+967
DEC DE

  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush14
defw BitmapData+981
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_63:
call BitmapPush10
defw BitmapData+991
DEC DE

  PUSH DE
  PUSH DE
  PUSH DE
call BitmapPush6
defw BitmapData+997
  PUSH DE
call BitmapPush6
defw BitmapData+1003
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_64:
call BitmapPush10
defw BitmapData+1013
DEC DE

  PUSH DE
  PUSH DE
call BitmapPush16
defw BitmapData+1029
INC DE

jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_65:
call BitmapPush8
defw BitmapData+1037
  PUSH DE
call BitmapPush8
defw BitmapData+1045
  PUSH DE
call BitmapPush10
defw BitmapData+1055
jp MultiPushDeLast25


PicEp2IntroRedrawpng_Line_66:
call BitmapPush10
defw BitmapData+1065
  PUSH DE
call BitmapPush6
defw BitmapData+1071
  PUSH DE
LD HL,&F4FF
  Push HL
LD BC,&FFF5
  Push BC
  PUSH DE
LD HL,&0200
  Push HL
jp MultiPushDeLast26


PicEp2IntroRedrawpng_Line_67:
call BitmapPush10
defw BitmapData+1081
  PUSH DE
call BitmapPush12
defw BitmapData+1093
jp MultiPushDeLast28


PicEp2IntroRedrawpng_Line_68:
call BitmapPush10
defw BitmapData+1103
  PUSH DE
call BitmapPush12
defw BitmapData+1115
jp MultiPushDeLast28


PicEp2IntroRedrawpng_Line_69:
call BitmapPush24
defw BitmapData+1139
jp MultiPushDeLast28


PicEp2IntroRedrawpng_Line_70:
call BitmapPush24
defw BitmapData+1163
jp MultiPushDeLast28


PicEp2IntroRedrawpng_Line_71:
call BitmapPush24
defw BitmapData+1187
jp MultiPushDeLast28


PicEp2IntroRedrawpng_Line_72:
ld hl,&FFB0
jp NextLineSPshift



PicEp2IntroRedrawpng_DrawOrder: 

  DEFW PicEp2IntroRedrawpng_Line_0
  DEFW PicEp2IntroRedrawpng_Line_1
  DEFW PicEp2IntroRedrawpng_Line_2
  DEFW PicEp2IntroRedrawpng_Line_3
  DEFW PicEp2IntroRedrawpng_Line_4
  DEFW PicEp2IntroRedrawpng_Line_5
  DEFW PicEp2IntroRedrawpng_Line_6
  DEFW PicEp2IntroRedrawpng_Line_7
  DEFW PicEp2IntroRedrawpng_Line_8
  DEFW PicEp2IntroRedrawpng_Line_9
  DEFW PicEp2IntroRedrawpng_Line_10
  DEFW PicEp2IntroRedrawpng_Line_11
  DEFW PicEp2IntroRedrawpng_Line_12
  DEFW PicEp2IntroRedrawpng_Line_13
  DEFW PicEp2IntroRedrawpng_Line_14
  DEFW PicEp2IntroRedrawpng_Line_15
  DEFW PicEp2IntroRedrawpng_Line_16
  DEFW PicEp2IntroRedrawpng_Line_17
  DEFW PicEp2IntroRedrawpng_Line_18
  DEFW PicEp2IntroRedrawpng_Line_19
  DEFW PicEp2IntroRedrawpng_Line_20
  DEFW PicEp2IntroRedrawpng_Line_21
  DEFW PicEp2IntroRedrawpng_Line_22
  DEFW PicEp2IntroRedrawpng_Line_23
  DEFW PicEp2IntroRedrawpng_Line_24
  DEFW PicEp2IntroRedrawpng_Line_25
  DEFW PicEp2IntroRedrawpng_Line_26
  DEFW PicEp2IntroRedrawpng_Line_27
  DEFW PicEp2IntroRedrawpng_Line_28
  DEFW PicEp2IntroRedrawpng_Line_29
  DEFW PicEp2IntroRedrawpng_Line_30
  DEFW PicEp2IntroRedrawpng_Line_31
  DEFW PicEp2IntroRedrawpng_Line_32
  DEFW PicEp2IntroRedrawpng_Line_33
  DEFW PicEp2IntroRedrawpng_Line_34
  DEFW PicEp2IntroRedrawpng_Line_35
  DEFW PicEp2IntroRedrawpng_Line_36
  DEFW PicEp2IntroRedrawpng_Line_37
  DEFW PicEp2IntroRedrawpng_Line_38
  DEFW PicEp2IntroRedrawpng_Line_39
  DEFW PicEp2IntroRedrawpng_Line_40
  DEFW PicEp2IntroRedrawpng_Line_41
  DEFW PicEp2IntroRedrawpng_Line_42
  DEFW PicEp2IntroRedrawpng_Line_43
  DEFW PicEp2IntroRedrawpng_Line_44
  DEFW PicEp2IntroRedrawpng_Line_45
  DEFW PicEp2IntroRedrawpng_Line_46
  DEFW PicEp2IntroRedrawpng_Line_47
  DEFW PicEp2IntroRedrawpng_Line_48
  DEFW PicEp2IntroRedrawpng_Line_49
  DEFW PicEp2IntroRedrawpng_Line_50
  DEFW PicEp2IntroRedrawpng_Line_51
  DEFW PicEp2IntroRedrawpng_Line_52
  DEFW PicEp2IntroRedrawpng_Line_53
  DEFW PicEp2IntroRedrawpng_Line_54
  DEFW PicEp2IntroRedrawpng_Line_55
  DEFW PicEp2IntroRedrawpng_Line_56
  DEFW PicEp2IntroRedrawpng_Line_57
  DEFW PicEp2IntroRedrawpng_Line_58
  DEFW PicEp2IntroRedrawpng_Line_59
  DEFW PicEp2IntroRedrawpng_Line_60
  DEFW PicEp2IntroRedrawpng_Line_61
  DEFW PicEp2IntroRedrawpng_Line_62
  DEFW PicEp2IntroRedrawpng_Line_63
  DEFW PicEp2IntroRedrawpng_Line_64
  DEFW PicEp2IntroRedrawpng_Line_65
  DEFW PicEp2IntroRedrawpng_Line_66
  DEFW PicEp2IntroRedrawpng_Line_67
  DEFW PicEp2IntroRedrawpng_Line_68
  DEFW PicEp2IntroRedrawpng_Line_69
  DEFW PicEp2IntroRedrawpng_Line_70
  DEFW PicEp2IntroRedrawpng_Line_71
defw looper
  DEFB 1,128
  DEFW PicEp2IntroRedrawpng_Line_72
  DEFW EndCode







;Global Code
RLE_ImageWidth equ 38
RLE_Draw:
  		ld a,ixh
		ld (ImageWidthA_Plus1-1),a
		ld (ImageWidthB_Plus2-2),a
		ld (ImageWidthC_Plus1-1),a
		ld (ImageWidthD_Plus2-2),a
		ld (ImageWidthE_Plus1-1),a
		cpl
		inc a
		ld (NegativeImageWidth_Plus2-2),a
		ld a,d
		ld (RLE_LastByteH_Plus1-1),a
		ld a,e
		ld (RLE_LastByteL_Plus1-1),a
	push hl
		ld a,IXL
		ld h,&C0
		LD L,a
		ld a,b
				ld de,&FFFF :NegativeImageWidth_Plus2
		or a
RLE_DrawGetNextLine:
		jr z,RLE_DrawGotLine
		call RLE_NextScreenLineHL
		add hl,de
		dec a
		jr RLE_DrawGetNextLine
RLE_DrawGotLine:
		ld (RLE_ScrPos_Plus2-2),hl
	;	xor a
				ld iyl,RLE_ImageWidth :ImageWidthA_Plus1
		ld a,255
		ld e,a
		;ld (Nibble_Plus1-1),a
	pop hl


RLE_MoreBytesLoop:

	inc hl
	ld a,(hl)
	ld b,a
	or a
	jp z,RLE_OneByteData
	and %00001111
	jp z,RLE_PlainBitmapData
	ld ixh,0
	ld ixl,a

	;we're doing Nibble data, Expand the data into two pixels of Mode 1 and duplicate

	ld a,b
	and %00110000
	rrca
	rrca
	ld c,a
	ld a,b
	and %11000000
	or c
	ld c,a
	rrca	;Remove these for Left->right
	rrca
	or c
	ld c,a

	ld a,ixl
	cp 15
	jp nz,RLE_NoMoreNibbleBytes
	push de
RLE_MoreNibbleBytes:
		inc hl
		ld a,(hl)
		ld d,0
		ld e,a
		add ix,de
		cp 255
		jp z,RLE_MoreNibbleBytes
	pop de

RLE_NoMoreNibbleBytes:


	ld a,e
	or a
	jp z,RLE_MoreBytesPart2Flip


	ld a,ixl
	cp 4
	call nc,RLE_ByteNibbles



	xor a
	ld d,a ;byte for screen
	push hl
	ld hl,&C050 :RLE_ScrPos_Plus2
	ld b,iyl
RLE_MoreBytes:
	ld a,c
	and %00110011
	or d
	ld d,a
	dec ix
	ld a,ixl
	or ixh
	jr z,RLE_LastByteFlip


RLE_MoreBytesPart2:
	ld a,c
	and %11001100
	or d
	ld d,a

	dec ix

		ld (hl),d
		dec hl
		dec b
		call z,RLE_NextScreenLineHL

	xor a
	ld d,a ;byte for screen

	ld a,ixl
	or ixh
	jr nz,RLE_MoreBytes

RLE_LastByte:
	ld iyl,b
	ld (RLE_ScrPos_Plus2-2),hl
	pop hl
;	ld iyl,b
	ld a,&00:RLE_LastByteH_Plus1
	cp h
	jp nz,RLE_MoreBytesLoop

	ld a,&00:RLE_LastByteL_Plus1
	cp l
	jp nz,RLE_MoreBytesLoop



ei

	exx 			;keep the firmware working!
	pop bc
	exx

	ret
RLE_LastByteFlip:
	ld a,e
	cpl
	ld e,a
	jp RLE_LastByte
RLE_MoreBytesPart2Flip:
	push hl
	ld b,iyl
	ld hl,(RLE_ScrPos_Plus2-2)
	ld a,e
	cpl
	ld e,a
	jp RLE_MoreBytesPart2

RLE_NextScreenLineHL:
	push de
				ld b,RLE_ImageWidth :ImageWidthE_Plus1
		ld de,&800+RLE_ImageWidth :ImageWidthD_Plus2
		add hl,de
	pop de
	ret nc
	push de
		ld de,&c050
		add hl,de
	pop de
	ret

RLE_NextScreenLine:
	push hl
		ld iyl,RLE_ImageWidth :ImageWidthC_Plus1
		ld hl,&800+RLE_ImageWidth :ImageWidthB_Plus2
		add hl,de
		ex hl,de
	pop hl
	ret nc
	push hl
		ld hl,&c050
		add hl,de
		ex hl,de
	pop hl
	ret

RLE_PlainBitmapData:
	push de
		ld a,(hl)
		rrca
		rrca
		rrca
		rrca
		ld b,0
		ld c,a

		cp 15
		jp nz,RLE_PlainBitmapDataNoExtras
	;More than 14 bytes, load an extra byte into the count
RLE_PlainBitmapDataHasExtras:
		inc hl
		ld a,(hl)
		or a
		jr z,RLE_PlainBitmapDataNoExtras	; no more bytes
		push hl
			ld h,0
			ld l,a
			add hl,bc
			ld b,h
			ld c,l
		pop hl

		cp 255
		jr z,RLE_PlainBitmapDataHasExtras
RLE_PlainBitmapDataNoExtras:

	
		ld de,(RLE_ScrPos_Plus2-2)
		RLE_PlainBitmapData_More:
		inc hl
		ld a,(hl)
		ld (de),a
		dec de



		dec iyl
		call z,RLE_NextScreenLine
		dec bc
		ld a,b
		or c
		jp nz,RLE_PlainBitmapData_More

		ld (RLE_ScrPos_Plus2-2),de
;ret
	pop de
	jp RLE_MoreBytesLoop

RLE_OneByteData:
	push de
		xor a 
		ld b,a
		ld c,a
RLE_OneByteDataExtras:
		inc hl
		ld a,(hl)
		push hl
			ld h,0
			ld l,a
			add hl,bc
			ld b,h
			ld c,l
		pop hl

		cp 255
		jp z,RLE_OneByteDataExtras

		inc hl
		ld a,(hl)
		ld (RLE_ThisOneByte_Plus1-1),a


		ld de,(RLE_ScrPos_Plus2-2)
RLE_OneByteData_More:
		ld a,00:RLE_ThisOneByte_Plus1
		ld (de),a
		dec de
		dec iyl
		call z,RLE_NextScreenLine




		dec bc
		ld a,b
		or c
		jp nz,RLE_OneByteData_More

		ld (RLE_ScrPos_Plus2-2),de
		;ret

	pop de
	jp RLE_MoreBytesLoop
RLE_ByteNibbles:
	di
	ld a,c
	exx
	ld b,iyl
	ld c,a
	ld d,ixh
	ld e,ixl
		ld hl,(RLE_ScrPos_Plus2-2)
RLE_ByteNibblesMore3:
		ld a,3
RLE_ByteNibblesMore:
		ld (hl),c
		dec hl 
		dec b;iyl
		call z,RLE_NextScreenLineHL

		dec de
		dec de
		cp e
		jp c,RLE_ByteNibblesMore

		ld a,d
		or a
		jp nz,RLE_ByteNibblesMore3

	ld (RLE_ScrPos_Plus2-2),hl
	ld iyl,b
	ld ixh,d
	ld ixl,e
	exx

ei
ret

EndCode:
ld sp,&0000:StackRestore_Plus2
ei
ret

MultiPushDeLast40: ld HL,NextLine
jp MultiPushDe40B 
MultiPushDe40: pop HL
jp MultiPushDe40B 
MultiPushDeLast32: ld HL,NextLine
jp MultiPushDe32B 
MultiPushDe32: pop HL
jp MultiPushDe32B 
MultiPushDeLast31: ld HL,NextLine
jp MultiPushDe31B 
MultiPushDe31: pop HL
jp MultiPushDe31B 
MultiPushDeLast30: ld HL,NextLine
jp MultiPushDe30B 
MultiPushDe30: pop HL
jp MultiPushDe30B 
MultiPushDeLast28: ld HL,NextLine
jr MultiPushDe28B 
MultiPushDe28: pop HL
jr MultiPushDe28B 
MultiPushDeLast27: ld HL,NextLine
jr MultiPushDe27B 
MultiPushDe27: pop HL
jr MultiPushDe27B 
MultiPushDeLast26: ld HL,NextLine
jr MultiPushDe26B 
MultiPushDe26: pop HL
jr MultiPushDe26B 
MultiPushDeLast25: ld HL,NextLine
jr MultiPushDe25B 
MultiPushDe25: pop HL
jr MultiPushDe25B 
MultiPushDe6: pop HL
jr MultiPushDe6B 
MultiPushDe5: pop HL
jr MultiPushDe5B 
MultiPushDe40B: Push DE
MultiPushDe39B: Push DE
MultiPushDe38B: Push DE
MultiPushDe37B: Push DE
MultiPushDe36B: Push DE
MultiPushDe35B: Push DE
MultiPushDe34B: Push DE
MultiPushDe33B: Push DE
MultiPushDe32B: Push DE
MultiPushDe31B: Push DE
MultiPushDe30B: Push DE
MultiPushDe29B: Push DE
MultiPushDe28B: Push DE
MultiPushDe27B: Push DE
MultiPushDe26B: Push DE
MultiPushDe25B: Push DE
MultiPushDe24B: Push DE
MultiPushDe23B: Push DE
MultiPushDe22B: Push DE
MultiPushDe21B: Push DE
MultiPushDe20B: Push DE
MultiPushDe19B: Push DE
MultiPushDe18B: Push DE
MultiPushDe17B: Push DE
MultiPushDe16B: Push DE
MultiPushDe15B: Push DE
MultiPushDe14B: Push DE
MultiPushDe13B: Push DE
MultiPushDe12B: Push DE
MultiPushDe11B: Push DE
MultiPushDe10B: Push DE
MultiPushDe9B: Push DE
MultiPushDe8B: Push DE
MultiPushDe7B: Push DE
MultiPushDe6B: Push DE
MultiPushDe5B: Push DE
MultiPushDe4B: Push DE
MultiPushDe3B: Push DE
MultiPushDe2B: Push DE
MultiPushDe1B: Push DE
jp (hl)

BitmapPush:
ld (BitmapPushDeRestore_Plus2-2),de
pop iy
ld l,(iy)
inc iy
ld h,(iy)
inc iy
BitmapPushRepeat:
ld d,(hl)
dec hl
ld e,(hl)
dec hl
push de
djnz BitmapPushRepeat

ld de,&0000 :BitmapPushDeRestore_Plus2

jp (iy)

BitmapPush30: ld b,&0F
jr BitmapPush
BitmapPush24: ld b,&0C
jr BitmapPush
BitmapPush22: ld b,&0B
jr BitmapPush
BitmapPush20: ld b,&0A
jr BitmapPush
BitmapPush18: ld b,&09
jr BitmapPush
BitmapPush16: ld b,&08
jr BitmapPush
BitmapPush14: ld b,&07
jr BitmapPush
BitmapPush12: ld b,&06
jr BitmapPush
BitmapPush10: ld b,&05
jr BitmapPush
BitmapPush8: ld b,&04
jr BitmapPush
BitmapPush6: ld b,&03
jr BitmapPush

finalBitmapPush30: ld b,&0F
jr finalBitmapPush

finalBitmapPush26: ld b,&0D
jr finalBitmapPush

finalBitmapPush24: ld b,&0C
jr finalBitmapPush

finalBitmapPush20: ld b,&0A
jr finalBitmapPush

finalBitmapPush16: ld b,&08
jr finalBitmapPush

finalBitmapPush14: ld b,&07
jr finalBitmapPush

finalBitmapPush12: ld b,&06
jr finalBitmapPush

finalBitmapPush10: ld b,&05
jr finalBitmapPush

finalBitmapPush8: ld b,&04
jr finalBitmapPush

finalBitmapPush6: ld b,&03
jr finalBitmapPush
finalBitmapPush:
ld (BitmapPushDeRestore_Plus2-2),de
pop iy
ld l,(iy)
inc iy
ld h,(iy)
inc iy
ld iy,nextline
jp BitmapPushRepeat
NextLinePushDe4: push de
NextLinePushDe3: push de
NextLinePushDe2: push de
NextLinePushDe1: push de

NextLine: 
ld hl,&0800+80
add hl,sp
ld sp,hl
jp nc,JumpToNextLine
ld hl,&c050
add hl,sp
ld sp,hl

JumpToNextLine: 
LD L,(IX)
INC IX
LD H,(IX)
INC IX
JP (HL)
NextLinePushHl: Push HL
jr NextLine
NextLinePushBC: Push BC
jr NextLine
NextLineSPshift:add hl,sp
ld sp,hl
jr NextLine
NextLineDecSP8:dec sp
dec sp
dec sp
dec sp
NextLineDecSP4:dec sp
dec sp
dec sp
dec sp
jr NextLine
CompiledSprite_GetNxtLinbc: defw &0000 :CompiledSprite_NextLineJumpBC_Plus2

LooperContinueAddress:defw LooperContinue
Looper:
ld b,ixh
ld c,ixl
LD a,(bc)
INC bc
ld (Looper_CountB_Plus1-1),a
LD a,(bc)
INC bc
ld (Looper_CountSize_Plus1-1),a
ld (RestoreLooperAddress_Plus2-2),bc
LooperNextStage:
	ld hl,&0000 :RestoreLooperAddress_Plus2
	ld (Looper_Address_Plus2-2),hl
	ld a,0:Looper_CountB_Plus1
	ld (Looper_Count_Plus1-1),a
	LooperRepeat:
		ld hl,&0000 :Looper_Address_Plus2
		LD c,(hl)
		INC hl
		LD b,(hl)
		INC hl
		ld (Looper_Address_Plus2-2),hl
		ld h,b
		ld l,c
		ld ix,LooperContinueAddress
		jp (hl)
   LooperContinue:
		ld a,0:Looper_Count_Plus1
		dec a
		ld (Looper_Count_Plus1-1),a
	jp nz,LooperRepeat
	ld a,0:Looper_CountSize_Plus1
	dec a
	ld (Looper_CountSize_Plus1-1),a
jp nz,LooperNextStage
ld ix,(Looper_Address_Plus2-2)
LD L,(IX)
INC IX
LD H,(IX)
INC IX
JP (HL)


BitmapData: 

defb &00,&10,&F0,&F0,&80,&00,&70,&F0,&F0,&F0
defb &F0,&E0,&00,&10,&F0,&F0,&F0,&C0,&61,&0F
defb &08,&00,&00,&00,&31,&C0,&00,&00,&00,&10
defb &E1,&0E,&08,&00,&00,&00,&31,&C0,&00,&00
defb &00,&70,&00,&10,&B4,&0A,&08,&00,&00,&10
defb &78,&0A,&08,&00,&72,&00,&00,&10,&F0,&80
defb &00,&30,&B4,&0A,&08,&00,&E6,&00,&00,&70
defb &C0,&00,&00,&30,&68,&0A,&08,&00,&00,&10
defb &C0,&00,&71,&C0,&00,&30,&F3,&FE,&80,&71
defb &00,&F0,&80,&00,&71,&C0,&00,&10,&C0,&00
defb &F3,&00,&00,&70,&FE,&F4,&90,&F3,&00,&F0
defb &E0,&00,&30,&E8,&00,&10,&80,&10,&EC,&00
defb &10,&F0,&C8,&F4,&90,&F6,&00,&F0,&E8,&00
defb &10,&F4,&60,&30,&42,&02,&F0,&80,&00,&30
defb &80,&11,&88,&00,&10,&F0,&10,&FC,&B0,&FC
defb &00,&10,&FE,&80,&00,&F6,&00,&30,&F0,&00
defb &00,&12,&F0,&E0,&00,&30,&80,&30,&80,&00
defb &10,&E0,&10,&F8,&F7,&C0,&33,&C0,&00,&73
defb &80,&00,&00,&52,&5A,&80,&00,&D2,&A5,&B4
defb &80,&30,&00,&70,&10,&E8,&00,&71,&C0,&00
defb &00,&E1,&A5,&F0,&90,&78,&5A,&5A,&C0,&30
defb &00,&60,&00,&FC,&00,&30,&C0,&00,&00,&D2
defb &1E,&5A,&90,&B4,&F0,&F0,&0E,&30,&00,&E0
defb &10,&F0,&C0,&00,&00,&10,&F0,&F0,&00,&76
defb &00,&10,&E0,&00,&01,&A5,&87,&B4,&90,&F0
defb &80,&30,&0E,&70,&00,&C0,&10,&F0,&F0,&F0
defb &80,&32,&01,&40,&43,&4A,&10,&80,&00,&10
defb &0F,&60,&00,&C0,&00,&30,&F0,&00,&85,&60
defb &10,&C0,&10,&F0,&F0,&E0,&00,&00,&00,&10
defb &00,&F0,&F0,&F0,&80,&30,&E0,&00,&02,&0F
defb &1A,&48,&00,&30,&E0,&00,&05,&60,&30,&80
defb &70,&F0,&F0,&F0,&20,&0F,&0D,&00,&80,&21
defb &F0,&00,&05,&60,&30,&80,&F0,&00,&10,&F0
defb &80,&00,&00,&F0,&E0,&00,&02,&07,&18,&00
defb &90,&F0,&5A,&00,&07,&20,&30,&90,&C0,&00
defb &00,&F0,&80,&00,&10,&F0,&20,&0D,&20,&30
defb &80,&A5,&3C,&90,&8F,&20,&30,&30,&80,&00
defb &C0,&00,&10,&80,&11,&80,&03,&0E,&40,&70
defb &80,&D2,&5A,&B1,&C3,&20,&30,&B0,&00,&30
defb &C0,&30,&80,&00,&10,&C0,&11,&80,&21,&2D
defb &80,&61,&C0,&61,&0F,&B2,&87,&20,&10,&80
defb &03,&06,&10,&5A,&C0,&52,&1E,&B1,&86,&20
defb &30,&00,&80,&10,&F0,&C0,&F0,&00,&00,&C8
defb &10,&C8,&03,&02,&30,&87,&E0,&30,&A5,&F2
defb &0E,&00,&30,&00,&C0,&F0,&03,&02,&F0,&4B
defb &78,&10,&D2,&F4,&0E,&00,&30,&20,&70,&F0
defb &00,&F0,&F3,&00,&33,&F0,&E0,&00,&00,&F0
defb &E0,&00,&00,&E4,&00,&E8,&07,&96,&A5,&A5
defb &2D,&80,&B4,&F2,&0C,&00,&30,&70,&F0,&80
defb &00,&30,&F1,&FF,&FE,&E0,&00,&0C,&00,&30
defb &C0,&00,&00,&E6,&00,&E8,&07,&D2,&5A,&00
defb &5A,&80,&70,&74,&0C,&00,&10,&D0,&E0,&00
defb &03,&00,&F0,&FF,&FC,&C0,&03,&0F,&00,&11
defb &C4,&00,&00,&72,&00,&E8,&07,&96,&87,&06
defb &25,&C0,&30,&61,&0C,&00,&10,&C0,&E0,&00
defb &0F,&0C,&70,&F7,&F8,&80,&07,&07,&08,&11
defb &DC,&00,&00,&72,&00,&E8,&06,&D2,&1E,&07
defb &1A,&F0,&00,&E5,&0C,&00,&00,&10,&C0,&01
defb &0C,&0E,&00,&F3,&E0,&00,&0E,&03,&08,&11
defb &FE,&00,&44,&00,&00,&EC,&0E,&01,&0C,&11
defb &FE,&80,&66,&00,&00,&64,&40,&01,&08,&06
defb &00,&33,&06,&52,&A5,&0F,&25,&B4,&80,&CB
defb &08,&00,&00,&13,&08,&37,&00,&77,&00,&11
defb &4C,&11,&4C,&33,&FE,&80,&66,&00,&00,&64
defb &06,&52,&1E,&0C,&0F,&5A,&D1,&C2,&08,&00
defb &40,&33,&88,&77,&00,&77,&88,&11,&CC,&11
defb &CC,&33,&FF,&80,&77,&00,&00,&64,&00,&33
defb &88,&77,&00,&FF,&88,&01,&8C,&01,&8C,&77
defb &FF,&80,&55,&00,&00,&60,&1F,&E5,&D2,&1E
defb &18,&78,&31,&86,&08,&00,&40,&23,&08,&66
defb &00,&FF,&CC,&01,&0C,&01,&08,&77,&FF,&00
defb &DD,&00,&00,&60,&1C,&E9,&A5,&2D,&06,&B4
defb &32,&86,&08,&00,&20,&01,&0C,&0E,&11,&FF
defb &CC,&00,&0E,&03,&08,&FF,&FE,&11,&DD,&00
defb &00,&E0,&0C,&E4,&E1,&5A,&06,&60,&31,&86
defb &60,&01,&0F,&0E,&33,&FF,&EE,&00,&0F,&07
defb &11,&FF,&EE,&11,&DD,&00,&00,&E0,&0C,&10
defb &E1,&2D,&0F,&60,&32,&84,&31,&00,&0F,&0C
defb &77,&FF,&FF,&00,&07,&0E,&33,&FF,&EE,&11
defb &BB,&20,&00,&C0,&0C,&31,&E1,&5A,&1E,&40
defb &74,&84,&70,&88,&03,&00,&FF,&DD,&FF,&CC
defb &01,&08,&77,&FF,&EE,&33,&BB,&20,&00,&C0
defb &0C,&32,&C9,&69,&87,&C0,&70,&84,&31,&E6
defb &00,&77,&FF,&99,&FF,&EE,&00,&11,&FF,&FF
defb &EE,&33,&77,&20,&00,&C0,&0C,&31,&C3,&78
defb &4B,&08,&F4,&86,&FF,&BB,&EE,&66,&EE,&20
defb &10,&C0,&0C,&00,&CB,&2D,&87,&10,&F8,&96
defb &EE,&33,&EE,&77,&CC,&60,&10,&C0,&0C,&00
defb &07,&12,&C3,&10,&F0,&97,&80,&00,&00,&00
defb &31,&F7,&CC,&33,&FE,&FF,&C8,&60,&10,&80
defb &0C,&00,&0F,&03,&87,&70,&F0,&D6,&C8,&00
defb &00,&00,&10,&FB,&88,&33,&FF,&FD,&80,&60
defb &30,&80,&0C,&30,&4B,&83,&06,&F0,&F0,&DF
defb &E4,&00,&00,&00,&10,&F5,&66,&77,&FF,&FA
defb &00,&C0,&30,&00,&04,&72,&4B,&C3,&06,&F0
defb &F3,&FE,&E8,&00,&00,&00,&10,&FB,&FF,&EE
defb &EE,&77,&FF,&E4,&10,&80,&70,&00,&04,&F4
defb &4B,&0B,&06,&F0,&F7,&FF,&F4,&00,&00,&00
defb &00,&F5,&FF,&88,&CC,&FF,&FE,&E8,&10,&80
defb &E0,&00,&FA,&80,&00,&00,&00,&F2,&04,&FA
defb &4B,&0A,&02,&F0,&88,&00,&44,&FF,&FD,&C4
defb &30,&80,&E0,&00,&04,&75,&02,&0A,&02,&31
defb &F7,&FF,&FD,&C0,&00,&00,&00,&71,&F7,&FF
defb &11,&FF,&FA,&C8,&60,&00,&C0,&00,&22,&72
defb &FB,&FF,&EE,&FF,&FF,&88,&04,&00,&02,&02
defb &02,&10,&FB,&FF,&FE,&E8,&00,&07,&1D,&FF
defb &F5,&80,&60,&10,&C0,&00,&22,&31,&F7,&FF
defb &FF,&00,&01,&0F,&3B,&FE,&FA,&00,&C0,&10
defb &C4,&00,&F2,&FF,&FF,&FA,&80,&00,&33,&10
defb &FB,&FF,&FF,&CC,&07,&0F,&77,&FD,&E4,&00
defb &00,&10,&C4,&00,&71,&F7,&FF,&FD,&C0,&00
defb &33,&00,&F5,&FF,&FF,&EE,&30,&FB,&FF,&FE
defb &E8,&00,&33,&00,&72,&FB,&FF,&FF,&88,&00
defb &0F,&0E,&FF,&FA,&C8,&00,&00,&30,&C4,&00
defb &10,&F5,&FF,&FF,&F4,&00,&33,&88,&31,&F5
defb &FF,&FF,&EE,&01,&0F,&1D,&FF,&F5,&80,&E0
defb &00,&70,&CC,&00,&00,&F3,&FF,&FF,&FA,&80
defb &33,&CC,&10,&F2,&FF,&FF,&FF,&01,&0F,&33
defb &FE,&F8,&00,&E0,&00,&F1,&CC,&00
DoubleByteDE:
pop iy
ld a,(iy)
inc iy
ld d,a
ld e,a
push de
push de
jp(iy)

PushDE_0000x:
Ld DE,&0000
jr PushDE_Multi
PushDE_F0F0x:
Ld DE,&F0F0
jr PushDE_Multi
PushDE_0F0Fx:
Ld DE,&0F0F
jr PushDE_Multi
PushDE_FFFFx:
Ld DE,&FFFF
PushDE_Multi
pop hl
push DE
push DE
push DE
push DE
jp (hl)

LastByte:defb 0
save direct "T59-SC2.D04",FirstByte,LastByte-FirstByte
