org &8000

nolist
FirstByte:
jp PicEndmessagepng

PicEndmessagepng:
ld hl,PicEndmessagepng_rledata-1
ld de,PicEndmessagepng_rledataEnd-1
ld b,0
ld ixh,80
ld IXL,79
di
exx 
push bc
exx
jp RLE_Draw
PicEndmessagepng_rledata:

defb &F,&ff,&ff,&6b
defb &C8
defb &F,&87
defb &10,&E0

defb &61
defb &35
defb &10,&E1
defb &F,&19
defb &C4
defb &41
defb &F,&5b
defb &61
defb &B1
defb &F4
defb &71
defb &32
defb &F,&17
defb &81
defb &C7
defb &F,&5a
defb &81
defb &61
defb &37
defb &F,&17
defb &81
defb &C9
defb &F,&5a
defb &C3
defb &33
defb &C1
defb &F,&17
defb &81
defb &C9
defb &41
defb &F,&5b
defb &81
defb &C4
defb &F,&16
defb &CB
defb &41
defb &F,&83
defb &C5
defb &35
defb &91
defb &C2
defb &6
defb &81
defb &C3
defb &41
defb &F,&75
defb &C5
defb &61
defb &3A
defb &C1
defb &41
defb &4
defb &81
defb &C2
defb &10,&1E
defb &C2
defb &F,&6c
defb &CA
defb &61
defb &34
defb &B1
defb &F4
defb &35
defb &41
defb &4
defb &C1
defb &61
defb &34
defb &91
defb &41
defb &F,&3e
defb &C2
defb &41
defb &F,&19
defb &81
defb &C7
defb &61
defb &37
defb &B1
defb &F8
defb &10,&1F
defb &C5
defb &36
defb &91
defb &41
defb &F,&3b
defb &C6
defb &41
defb &F,&17
defb &C3
defb &38
defb &FC
defb &71
defb &33
defb &91
defb &C2
defb &10,&1E

defb &B1
defb &F3
defb &34
defb &10,&70
defb &F,&13
defb &C2
defb &41
defb &F,&12
defb &81
defb &C7
defb &41
defb &F,&16
defb &C2
defb &61
defb &34
defb &FF,&2
defb &71
defb &32
defb &C4
defb &61
defb &31
defb &F5
defb &71
defb &33
defb &10,&E1

defb &41
defb &F,&11
defb &81
defb &C6
defb &41
defb &F,&11
defb &C4
defb &41
defb &F,&15
defb &C4
defb &10,&1E

defb &B1
defb &FF,&5
defb &38
defb &F5
defb &71
defb &34
defb &91
defb &C3
defb &F,&f
defb &81
defb &C6
defb &2
defb &C2
defb &41
defb &F,&34
defb &81
defb &C4
defb &61
defb &10,&8F
defb &FF,&6
defb &71
defb &34
defb &B1
defb &F7
defb &71
defb &36
defb &91
defb &41
defb &F,&11
defb &81
defb &C3
defb &41
defb &2
defb &C5
defb &41
defb &F,&2b
defb &81
defb &C6
defb &61
defb &35
defb &FF,&5
defb &36
defb &FA
defb &34
defb &91
defb &C2
defb &F,&4
defb &81
defb &C3
defb &41
defb &F,&0
defb &81
defb &61
defb &32
defb &C3
defb &41
defb &F,&2a
defb &C1
defb &38
defb &FF,&8
defb &71
defb &36
defb &B1
defb &F8
defb &71
defb &33
defb &C2
defb &F,&6
defb &CF,&0
defb &41
defb &4
defb &81
defb &61
defb &34
defb &91
defb &10,&70
defb &F,&28
defb &81
defb &10,&3C
defb &FF,&c
defb &38
defb &91
defb &C1
defb &33
defb &10,&EF
defb &36
defb &C3
defb &41
defb &F,&6
defb &61
defb &37
defb &C4
defb &31
defb &91
defb &C3
defb &10,&90
defb &C2
defb &36
defb &C2
defb &F,&27
defb &C2
defb &10,&9E
defb &FF,&c
defb &35
defb &91
defb &C5
defb &37
defb &C6
defb &F,&7
defb &61
defb &F3
defb &71
defb &3B
defb &91
defb &C2
defb &33
defb &B1
defb &F3
defb &71
defb &10,&C3

defb &41
defb &F,&25
defb &C2
defb &32
defb &FF,&f
defb &35
defb &91
defb &C2
defb &61
defb &36
defb &C2
defb &41
defb &F,&b
defb &61
defb &B1
defb &F7
defb &71
defb &33
defb &10,&EF
defb &38
defb &B1
defb &F3
defb &71
defb &C2
defb &F,&23
defb &81
defb &10,&78
defb &32
defb &B1
defb &FF,&f
defb &71
defb &10,&8F

defb &F1
defb &39
defb &C2
defb &41
defb &F,&d
defb &81
defb &31
defb &FE
defb &3C
defb &C1
defb &41
defb &F,&24
defb &C4
defb &31
defb &FF,&13
defb &71
defb &32
defb &B1
defb &F3
defb &10,&97
defb &C4
defb &F,&d
defb &61
defb &32
defb &B1
defb &FC
defb &71
defb &39
defb &10,&70
defb &F,&26
defb &C3
defb &10,&9E
defb &FF,&18
defb &71
defb &35
defb &91
defb &C5
defb &6
defb &C3
defb &41
defb &D
defb &C2
defb &33
defb &B1
defb &FB
defb &38
defb &C2
defb &F,&29
defb &C1
defb &10,&1E

defb &B1
defb &FF,&1b
defb &33
defb &91
defb &CE
defb &41
defb &A
defb &C4
defb &37
defb &B1
defb &FC
defb &71
defb &33
defb &91
defb &C4
defb &F,&25
defb &81
defb &C1
defb &33
defb &B1
defb &FF,&19
defb &71
defb &3F,&1
defb &91
defb &C2
defb &41
defb &2
defb &C2
defb &41
defb &3
defb &C5
defb &38
defb &F5
defb &32
defb &F7
defb &34
defb &91
defb &C3
defb &F,&0
defb &81
defb &C2
defb &F,&12
defb &C2
defb &34
defb &B1
defb &F2
defb &32
defb &F2
defb &71
defb &31
defb &F7
defb &10,&9F
defb &FF,&9
defb &71
defb &3F,&0
defb &91
defb &CF,&0
defb &3E
defb &F7
defb &71
defb &37
defb &C1
defb &D
defb &81
defb &C2
defb &F,&8
defb &81
defb &C2
defb &8
defb &81
defb &C2
defb &3C
defb &B1
defb &F6
defb &33
defb &FF,&9
defb &71
defb &10,&8F
defb &FA
defb &71
defb &37
defb &CA
defb &61
defb &36
defb &F2
defb &36
defb &B1
defb &F6
defb &71
defb &37
defb &91
defb &C9
defb &2
defb &C3
defb &41
defb &F,&7
defb &81
defb &C3
defb &8
defb &81
defb &C3
defb &61
defb &3A
defb &B1
defb &F6
defb &36
defb &FB
defb &71
defb &36
defb &FF,&1
defb &3B
defb &CD
defb &B1
defb &F2
defb &71
defb &38
defb &FA
defb &71
defb &39
defb &C2
defb &41
defb &2
defb &C1
defb &41
defb &F,&9
defb &81
defb &C5
defb &41
defb &3
defb &81
defb &C5
defb &3A
defb &F8
defb &71
defb &35
defb &F8
defb &71
defb &39
defb &FD
defb &3A
defb &B1
defb &F2
defb &33
defb &91
defb &C5
defb &61
defb &33
defb &B1
defb &FF,&3
defb &71
defb &32
defb &FA
defb &10,&43
defb &F,&11
defb &CC
defb &3B
defb &F9
defb &36
defb &B1
defb &F4
defb &39
defb &C1
defb &32
defb &B1
defb &F2
defb &32
defb &F6
defb &71
defb &37
defb &FA
defb &39
defb &FF,&3
defb &3E
defb &91
defb &C2
defb &F,&11
defb &C9
defb &3D
defb &B1
defb &F4
defb &71
defb &B1
defb &F3
defb &71
defb &37
defb &10,&EF

defb &71
defb &34
defb &91
defb &C5
defb &61
defb &37
defb &B1
defb &F2
defb &71
defb &37
defb &FF,&1a
defb &71
defb &35
defb &C9
defb &41
defb &F,&10
defb &33
defb &91
defb &C2
defb &61
defb &3F,&0
defb &F4
defb &71
defb &32
defb &F3
defb &3F,&2
defb &91
defb &C4
defb &3D
defb &B1
defb &FF,&1e
defb &71
defb &31
defb &CB
defb &F,&13
defb &3F,&0
defb &F2
defb &71
defb &33
defb &F5
defb &10,&E1

defb &61
defb &35
defb &C6
defb &36
defb &10,&78
defb &3F,&3
defb &B1
defb &FF,&19
defb &71
defb &33
defb &B1
defb &71
defb &32
defb &C4
defb &41
defb &F,&10
defb &C9
defb &3C
defb &B1
defb &FC
defb &31
defb &CF,&7
defb &61
defb &34
defb &B1
defb &F4
defb &71
defb &32
defb &FF,&1f
defb &35
defb &91
defb &C3
defb &F,&10
defb &CD
defb &3A
defb &FE
defb &10,&1F
defb &CF,&8
defb &61
defb &34
defb &FF,&28
defb &33
defb &10,&E1

defb &41
defb &8
defb &81
defb &C2
defb &41
defb &B
defb &10,&70
defb &3
defb &C5
defb &3A
defb &C2
defb &35
defb &B1
defb &FF,&2
defb &71
defb &32
defb &91
defb &CF,&8
defb &61
defb &33
defb &B1
defb &FF,&2a
defb &10,&97
defb &C5
defb &41
defb &2
defb &C5
defb &41
defb &9
defb &81
defb &C2
defb &41
defb &5
defb &C3
defb &31
defb &F6
defb &3B
defb &FF,&1
defb &34
defb &91
defb &CF,&8
defb &61
defb &33
defb &B1
defb &FF,&2a
defb &71
defb &C9
defb &61
defb &32
defb &10,&61
defb &9
defb &C1
defb &32
defb &C1
defb &7
defb &10,&78
defb &33
defb &F5
defb &71
defb &3D
defb &FC
defb &36
defb &CF,&4
defb &61
defb &36
defb &FF,&20
defb &71
defb &33
defb &F1
defb &71
defb &32
defb &B1
defb &F2
defb &10,&E1

defb &61
defb &39
defb &10,&61
defb &6
defb &81
defb &C2
defb &61
defb &32
defb &10,&E1

defb &41
defb &5
defb &20,&E0,&1E
defb &F8
defb &33
defb &F2
defb &71
defb &37
defb &FC
defb &71
defb &35
defb &91
defb &CF,&2
defb &61
defb &35
defb &B1
defb &FF,&12
defb &34
defb &B1
defb &F8
defb &3A
defb &20,&EF,&4B
defb &33
defb &B1
defb &F4
defb &10,&97

defb &41
defb &4
defb &C7
defb &10,&96

defb &C1
defb &8
defb &C2
defb &61
defb &32
defb &B1
defb &F3
defb &10,&1F
defb &F6
defb &71
defb &36
defb &B1
defb &FD
defb &35
defb &91
defb &CF,&2
defb &34
defb &FE
defb &31
defb &F2
defb &71
defb &B1
defb &FF,&0
defb &71
defb &36
defb &F5
defb &37
defb &F4
defb &32
defb &F1
defb &31
defb &C2
defb &36
defb &91
defb &C2
defb &7
defb &C7
defb &A
defb &C4
defb &36
defb &F7
defb &71
defb &35
defb &FE
defb &71
defb &35
defb &91
defb &CF,&1
defb &61
defb &33
defb &FD
defb &71
defb &32
defb &20,&7F,&8F
defb &FC
defb &3F,&3
defb &10,&3F
defb &F9
defb &91
defb &C3
defb &61
defb &10,&87
defb &C3
defb &41
defb &8
defb &10,&E0

defb &41
defb &E
defb &81
defb &C8
defb &F8
defb &35
defb &FF,&0
defb &71
defb &35
defb &91
defb &CF,&2
defb &32
defb &FD
defb &38
defb &B1
defb &F8
defb &34
defb &91
defb &C3
defb &3A
defb &B1
defb &F2
defb &31
defb &B1
defb &F9
defb &71
defb &37
defb &91
defb &C2
defb &F,&b
defb &C7
defb &F8
defb &33
defb &FF,&3
defb &37
defb &91
defb &CB
defb &36
defb &B1
defb &FC
defb &3B
defb &F5
defb &71
defb &34
defb &C6
defb &35
defb &B1
defb &F4
defb &71
defb &32
defb &B1
defb &F2
defb &10,&1F

defb &B1
defb &F7
defb &10,&97
defb &C6
defb &F,&11
defb &FF,&e
defb &71
defb &37
defb &91
defb &C4
defb &3D
defb &FB
defb &71
defb &3F,&3
defb &C6
defb &34
defb &B1
defb &F8
defb &36
defb &C2
defb &36
defb &10,&EF

defb &91
defb &C4
defb &F,&14
defb &FF,&d
defb &71
defb &3F,&b
defb &FA
defb &71
defb &3F,&2
defb &C8
defb &B1
defb &F9
defb &37
defb &91
defb &C9
defb &32
defb &C2
defb &F,&17
defb &FF,&d
defb &71
defb &3E
defb &B1
defb &F4
defb &37
defb &B1
defb &F9
defb &3F,&2
defb &C8
defb &10,&8F
defb &F6
defb &39
defb &CE
defb &F,&1
defb &C4
defb &F,&4
defb &FF,&c
defb &3D
defb &20,&6F,&8F
defb &F7
defb &33
defb &FB
defb &3F,&1
defb &91
defb &C7
defb &61
defb &10,&8F
defb &F2
defb &71
defb &3C
defb &C4
defb &5
defb &C3
defb &F,&1
defb &81
defb &C6
defb &5
defb &C5
defb &8
defb &FF,&c
defb &3C
defb &FF,&b
defb &3F,&0
defb &91
defb &C7
defb &32
defb &F3
defb &3E
defb &91
defb &C3
defb &41
defb &5
defb &C1
defb &41
defb &9
defb &10,&E0
defb &5
defb &CC
defb &61
defb &32
defb &91
defb &C3
defb &6
defb &FF,&6
defb &33
defb &F3
defb &71
defb &32
defb &91
defb &C2
defb &35
defb &FF,&11
defb &71
defb &3A
defb &91
defb &C6
defb &31
defb &F3
defb &71
defb &3F,&0
defb &91
defb &C5
defb &41
defb &B
defb &81
defb &C8
defb &32
defb &C2
defb &32
defb &C6
defb &31
defb &10,&EF
defb &32
defb &C3
defb &5
defb &FF,&3
defb &33
defb &91
defb &10,&3C

defb &B1
defb &F3
defb &91
defb &C5
defb &32
defb &B1
defb &FF,&13
defb &71
defb &3A
defb &91
defb &C3
defb &10,&1E

defb &B1
defb &F3
defb &71
defb &3F,&1
defb &C6
defb &A
defb &81
defb &C1
defb &34
defb &C3
defb &35
defb &B1
defb &10,&97
defb &C5
defb &31
defb &10,&7F
defb &33
defb &91
defb &10,&70
defb &4
defb &FF,&2
defb &71
defb &32
defb &91
defb &C3
defb &10,&8F
defb &F2
defb &32
defb &C5
defb &33
defb &B1
defb &FF,&1b
defb &36
defb &FA
defb &71
defb &3E
defb &C9
defb &41
defb &3
defb &81
defb &61
defb &32
defb &91
defb &C2
defb &10,&1E

defb &B1
defb &F6
defb &31
defb &C5
defb &61
defb &32
defb &C6
defb &41
defb &3
defb &FF,&1
defb &71
defb &32
defb &91
defb &C5
defb &31
defb &F2
defb &33
defb &C6
defb &61
defb &31
defb &FF,&2c
defb &3F,&1
defb &91
defb &C7
defb &41
defb &3
defb &C3
defb &61
defb &32
defb &F9
defb &31
defb &CF,&0
defb &3
defb &F2
defb &33
defb &FB
defb &71
defb &32
defb &91
defb &C5
defb &61
defb &35
defb &C4
defb &61
defb &33
defb &FF,&2d
defb &71
defb &3F,&5
defb &91
defb &C2
defb &4
defb &C2
defb &31
defb &B1
defb &F8
defb &33
defb &91
defb &C7
defb &41
defb &9
defb &F1
defb &37
defb &FA
defb &10,&87
defb &CC
defb &61
defb &35
defb &B1
defb &FF,&30
defb &71
defb &3A
defb &B1
defb &F4
defb &35
defb &C2
defb &1
defb &10,&68
defb &32
defb &F6
defb &36
defb &C5
defb &D
defb &38
defb &FB
defb &31
defb &CD
defb &61
defb &34
defb &FF,&32
defb &38
defb &B1
defb &F9
defb &32
defb &C5
defb &3B
defb &91
defb &C4
defb &41
defb &F,&0
defb &37
defb &B1
defb &FB
defb &71
defb &31
defb &CE
defb &33
defb &FF,&3f
defb &36
defb &91
defb &CF,&7
defb &F,&0
defb &37
defb &B1
defb &FB
defb &71
defb &32
defb &CD
defb &34
defb &B1
defb &FF,&3b
defb &71
defb &36
defb &91
defb &CF,&3
defb &61
defb &33
defb &10,&E1

defb &41
defb &D
defb &34
defb &FF,&0
defb &71
defb &32
defb &91
defb &CE
defb &34
defb &FF,&3b
defb &71
defb &10,&87
defb &CB
defb &41
defb &4
defb &81
defb &C3
defb &33
defb &B1
defb &F2
defb &10,&87
defb &C2
defb &C
defb &33
defb &FF,&0
defb &71
defb &32
defb &91
defb &CF,&2
defb &61
defb &32
defb &B1
defb &FF,&3b
defb &31
defb &C1
defb &F,&3
defb &C4
defb &61
defb &20,&EF,&97
defb &C4
defb &41
defb &9
defb &33
defb &FE
defb &71
defb &32
defb &CF,&5
defb &61
defb &33
defb &FF,&38
defb &33
defb &C4
defb &F,&3
defb &C2
defb &61
defb &32
defb &C6
defb &9
defb &32
defb &B1
defb &FE
defb &71
defb &32
defb &91
defb &CF,&5
defb &61
defb &32
defb &FF,&38
defb &71
defb &34
defb &C2
defb &41
defb &F,&1
defb &81
defb &CC
defb &8
defb &32
defb &FF,&1
defb &34
defb &91
defb &CF,&4
defb &33
defb &B1
defb &FF,&39
defb &32
defb &C2
defb &8
defb &C1
defb &7
defb &81
defb &C3
defb &35
defb &C6
defb &7
defb &34
defb &FF,&0
defb &71
defb &36
defb &CF,&1
defb &33
defb &B1
defb &FF,&38
defb &71
defb &32
defb &10,&E1

defb &41
defb &5
defb &CD
defb &61
defb &38
defb &91
defb &C3
defb &41
defb &5
defb &37
defb &B1
defb &FD
defb &38
defb &91
defb &CA
defb &61
defb &33
defb &B1
defb &FF,&38
defb &10,&1F

defb &91
defb &C5
defb &41
defb &2
defb &C9
defb &61
defb &35
defb &F4
defb &71
defb &35
defb &C3
defb &41
defb &4
defb &3B
defb &B1
defb &FB
defb &71
defb &39
defb &C4
defb &61
defb &35
defb &FF,&39
defb &32
defb &91
defb &C6
defb &2
defb &81
defb &C4
defb &61
defb &38
defb &FA
defb &33
defb &C2
defb &41
defb &4
defb &3C
defb &FD
defb &3F,&2
defb &B1
defb &FF,&39
defb &31
defb &91
defb &C6
defb &2
defb &81
defb &C4
defb &37
defb &B1
defb &FE
defb &32
defb &91
defb &C2
defb &3
defb &36
defb &B1
defb &FF,&5
defb &71
defb &3E
defb &B1
defb &FF,&37
defb &32
defb &C3
defb &41
defb &5
defb &81
defb &C4
defb &34
defb &B1
defb &FF,&4
defb &32
defb &91
defb &C2
defb &10,&10
defb &35
defb &FF,&8
defb &71
defb &3D
defb &FF,&37
defb &32
defb &C7
defb &2
defb &81
defb &C4
defb &33
defb &B1
defb &FF,&8
defb &32
defb &C2
defb &41
defb &FF,&f
defb &3E
defb &B1
defb &FF,&35
defb &71
defb &31
defb &CB
defb &61
defb &34
defb &FF,&a
defb &10,&1F
defb &C2
defb &FF,&10
defb &3F,&0
defb &FF,&35
defb &3E
defb &FF,&e
defb &32
defb &C1
defb &FF,&e
defb &71
defb &3F,&2
defb &FF,&35
defb &3B
defb &FF,&11
defb &10,&97
defb &FF,&3
defb &3F,&e
defb &B1
defb &FF,&36
defb &36
defb &B1
defb &FF,&14
defb &31
defb &FE
defb &71
defb &3F,&12
defb &FF,&3a
defb &31
defb &B1
defb &FF,&24
defb &3F,&13
defb &B1
defb &FF,&6d
defb &71
defb &3F,&12
defb &FF,&67
defb &71
defb &3F,&19
defb &FF,&4d
defb &71
defb &35
defb &B1
defb &FF,&4
defb &3F,&1a
defb &B1
defb &FF,&4b
defb &34
defb &91
defb &C2
defb &34
defb &FD
defb &3F,&1e
defb &B1
defb &FF,&49
defb &34
defb &91
defb &C6
defb &33
defb &B1
defb &FB
defb &3F,&1e
defb &FF,&4b
defb &71
defb &33
defb &C5
defb &61
defb &32
defb &FA
defb &3F,&21
defb &FF,&0
defb &32
defb &F4
defb &35
defb &B1
defb &FF,&33
defb &71
defb &36
defb &B1
defb &FA
defb &3F,&6
defb &91
defb &C4
defb &61
defb &36
defb &91
defb &C3
defb &61
defb &3A
defb &B1
defb &FD
defb &71
defb &3D
defb &B1
defb &FF,&41
defb &71
defb &3F,&4
defb &CC
defb &61
defb &33
defb &C9
defb &36
defb &B1
defb &FC
defb &3F,&2
defb &FF,&40
defb &34
defb &91
defb &C2
defb &3C
defb &CF,&c
defb &61
defb &34
defb &B1
defb &FC
defb &36
defb &B1
defb &F2
defb &71
defb &37
defb &FF,&3c
defb &36
defb &C5
defb &3B
defb &91
defb &CF,&d
defb &61
defb &34
defb &FC
defb &32
defb &B1
defb &FB
defb &71
defb &32
defb &FF,&3a
defb &3F,&8
defb &91
defb &CF,&10
defb &33
defb &FB
defb &71
defb &33
defb &B1
defb &F9
defb &34
defb &FF,&47
defb &39
defb &91
defb &CF,&11
defb &61
defb &32
defb &B1
defb &FA
defb &37
defb &F3
defb &71
defb &38
defb &FF,&46
defb &39
defb &C8
defb &41
defb &9
defb &81
defb &CE
defb &61
defb &33
defb &F9
defb &3F,&5
defb &B1
defb &FF,&43
defb &10,&1F
defb &C3
defb &61
defb &33
defb &91
defb &C7
defb &E
defb &81
defb &CC
defb &61
defb &35
defb &F6
defb &71
defb &3F,&8
defb &B1
defb &FF,&3b
defb &37
defb &CC
defb &41
defb &F,&4
defb &CA
defb &61
defb &3F,&17
defb &B1
defb &F8
defb &71
defb &32
defb &FF,&2c
defb &71
defb &C4
defb &33
defb &CA
defb &41
defb &F,&8
defb &81
defb &C8
defb &3F,&29
defb &B1
defb &FF,&23
defb &32
defb &C6
defb &31
defb &CB
defb &41
defb &F,&9
defb &81
defb &C7
defb &3F,&5
defb &F2
defb &3F,&14
defb &FF,&22
defb &71
defb &91
defb &CF,&4
defb &41
defb &F,&a
defb &81
defb &C5
defb &61
defb &3F,&3
defb &F5
defb &3D
defb &91
defb &10,&78
defb &33
defb &CE
defb &31
defb &FF,&22
defb &31
defb &CA
defb &31
defb &CA
defb &41
defb &F,&a
defb &C5
defb &61
defb &3F,&2
defb &B1
defb &F5
defb &71
defb &3C
defb &C2
defb &61
defb &32
defb &10,&70
defb &B
defb &81
defb &10,&78

defb &31
defb &FF,&20
defb &71
defb &CB
defb &36
defb &91
defb &C9
defb &F,&7
defb &C4
defb &61
defb &3F,&0
defb &FD
defb &34
defb &91
defb &C8
defb &F,&0
defb &C1
defb &10,&9E
defb &FF,&1d
defb &33
defb &C5
defb &61
defb &34
defb &C1
defb &37
defb &CE
defb &F,&1
defb &C6
defb &3C
defb &FF,&3
defb &33
defb &C7
defb &41
defb &F,&1
defb &10,&68
defb &FF,&1c
defb &34
defb &C5
defb &3D
defb &91
defb &CD
defb &41
defb &D
defb &81
defb &C9
defb &3D
defb &FB
defb &36
defb &C8
defb &F,&3
defb &C1
defb &32
defb &FF,&19
defb &71
defb &35
defb &C2
defb &33
defb &B1
defb &F2
defb &3E
defb &CD
defb &41
defb &7
defb &81
defb &CC
defb &3E
defb &B1
defb &F5
defb &38
defb &C8
defb &41
defb &F,&4
defb &C1
defb &34
defb &FF,&14
defb &71
defb &32
defb &91
defb &C2
defb &36
defb &F4
defb &71
defb &3F,&3
defb &91
defb &CF,&e
defb &61
defb &3D
defb &B1
defb &F3
defb &71
defb &37
defb &91
defb &C8
defb &F,&5
defb &10,&E0

defb &61
defb &32
defb &B1
defb &FF,&12
defb &71
defb &32
defb &91
defb &C3
defb &34
defb &B1
defb &F5
defb &71
defb &3F,&6
defb &CF,&c
defb &61
defb &38
defb &10,&E1
defb &3C
defb &91
defb &CB
defb &F,&7
defb &C2
defb &10,&1E

defb &B1
defb &FF,&11
defb &33
defb &C5
defb &34
defb &F2
defb &3F,&b
defb &91
defb &CF,&b
defb &37
defb &91
defb &C2
defb &61
defb &39
defb &91
defb &CD
defb &F,&8
defb &81
defb &10,&3C

defb &B1
defb &FF,&10
defb &71
defb &32
defb &91
defb &C6
defb &3A
defb &F2
defb &71
defb &3F,&4
defb &91
defb &CF,&a
defb &61
defb &36
defb &C4
defb &38
defb &C7
defb &3
defb &C5
defb &F,&9
defb &10,&68

defb &31
defb &FF,&11
defb &32
defb &C7
defb &61
defb &39
defb &F3
defb &34
defb &C9
defb &38
defb &91
defb &CF,&9
defb &61
defb &34
defb &C4
defb &61
defb &37
defb &91
defb &C5
defb &41
defb &F,&12
defb &10,&E0

defb &B1
defb &FF,&11
defb &71
defb &91
defb &C6
defb &61
defb &3A
defb &F3
defb &71
defb &33
defb &91
defb &CB
defb &36
defb &91
defb &CA
defb &10,&1E

defb &91
defb &CB
defb &32
defb &C6
defb &61
defb &37
defb &C6
defb &F,&14
defb &C1
defb &B1
defb &FF,&12
defb &31
defb &C4
defb &3D
defb &F4
defb &71
defb &34
defb &91
defb &CA
defb &3F,&4
defb &91
defb &CF,&3
defb &61
defb &37
defb &C4
defb &41
defb &F,&15
defb &C1
defb &31
defb &FF,&12
defb &10,&97
defb &C2
defb &3E
defb &F6
defb &71
defb &35
defb &CB
defb &3F,&5
defb &CF,&1
defb &36
defb &91
defb &C4
defb &F,&16
defb &C1
defb &31
defb &FF,&12
defb &71
defb &3F,&4
defb &B1
defb &F6
defb &35
defb &CA
defb &61
defb &3F,&5
defb &CE
defb &36
defb &C5
defb &F,&16
defb &C1
defb &31
defb &FF,&10
defb &3F,&a
defb &F6
defb &71
defb &38
defb &CA
defb &3F,&2
defb &91
defb &CB
defb &36
defb &C3
defb &F,&18
defb &C1
defb &B1
defb &FF,&9
defb &3F,&c
defb &C2
defb &36
defb &F2
defb &71
defb &38
defb &91
defb &CF,&2
defb &3F,&2
defb &C5
defb &33
defb &91
defb &C3
defb &F,&1a
defb &C1
defb &B1
defb &FF,&8
defb &71
defb &3F,&c
defb &C4
defb &3B
defb &CF,&9
defb &61
defb &3F,&0
defb &91
defb &C2
defb &34
defb &C1
defb &F,&b
defb &81
defb &C4
defb &20,&10,&E0
defb &8
defb &10,&E0

defb &B1
defb &FF,&8
defb &3F,&d
defb &C6
defb &61
defb &35
defb &91
defb &CF,&0
defb &41
defb &9
defb &81
defb &C2
defb &61
defb &3F,&5
defb &41
defb &F,&9
defb &CC
defb &6
defb &C5
defb &10,&1E
defb &FF,&4
defb &71
defb &3D
defb &C4
defb &61
defb &3A
defb &CF,&e
defb &41
defb &8
defb &81
defb &C6
defb &61
defb &37
defb &C4
defb &61
defb &34
defb &41
defb &F,&8
defb &CF,&0
defb &41
defb &2
defb &C8
defb &61
defb &35
defb &B1
defb &FC
defb &3E
defb &CD
defb &32
defb &CF,&8
defb &1
defb &81
defb &C7
defb &6
defb &C8
defb &35
defb &91
defb &C6
defb &61
defb &32
defb &91
defb &41
defb &F,&7
defb &CF,&13
defb &31
defb &FB
defb &71
defb &35
defb &C1
defb &61
defb &35
defb &91
defb &CF,&15
defb &4
defb &CF,&7
defb &33
defb &91
defb &C7
defb &10,&1E

defb &91
defb &C2
defb &F,&6
defb &81
defb &CF,&14
defb &61
defb &FB
defb &34
defb &C3
defb &35
defb &CF,&16
defb &4
defb &81
defb &C1
defb &33
defb &CF,&13
defb &F,&5
defb &81
defb &CF,&15
defb &61
defb &FA
defb &71
defb &32
defb &CF,&a
defb &33
defb &CD
defb &32
defb &C4
defb &10,&10
defb &C2
defb &34
defb &91
defb &C8
defb &61
defb &32
defb &CF,&8
defb &F,&4
defb &81
defb &CF,&16
defb &31
defb &FA
defb &31
defb &91
defb &C3
defb &41
defb &8
defb &CD
defb &F1
defb &33
defb &91
defb &CB
defb &33
defb &C8
defb &35
defb &91
defb &C4
defb &36
defb &CA
defb &41
defb &2
defb &81
defb &C8
defb &41
defb &F,&3
defb &81
defb &CF,&16
defb &10,&8F
defb &F8
defb &10,&87
defb &C3
defb &41
defb &A
defb &81
defb &CB
defb &F2
defb &71
defb &34
defb &C9
defb &61
defb &33
defb &CF,&1
defb &61
defb &37
defb &C8
defb &41
defb &5
defb &C7
defb &41
defb &F,&4
defb &CF,&15
defb &61
defb &31
defb &F7
defb &10,&1F
defb &C3
defb &F,&0
defb &CA
defb &F4
defb &34
defb &91
defb &C8
defb &33
defb &91
defb &CE
defb &61
defb &3B
defb &91
defb &10,&70
defb &9
defb &81
defb &C5
defb &F,&5
defb &CF,&15
defb &31
defb &B1
defb &F5
defb &10,&1F

defb &91
defb &C3
defb &F,&1
defb &81
defb &C9
defb &F5
defb &35
defb &C8
defb &10,&1E
defb &CF,&1
defb &61
defb &3C
defb &C1
defb &41
defb &A
defb &C3
defb &F,&6
defb &CF,&14
defb &10,&1E
defb &F6
defb &32
defb &91
defb &C3
defb &41
defb &F,&1
defb &C9
defb &F6
defb &71
defb &35
defb &CE
defb &61
defb &32
defb &91
defb &CC
defb &37
defb &91
defb &C2
defb &41
defb &8
defb &81
defb &C1
defb &F,&6
defb &CF,&15
defb &31
defb &F8
defb &71
defb &33
defb &C2
defb &41
defb &F,&1
defb &C8
defb &32
defb &F2
defb &3A
defb &91
defb &CB
defb &61
defb &33
defb &CF,&5
defb &41
defb &F,&11
defb &81
defb &CF,&15
defb &10,&9E
defb &F8
defb &34
defb &C5
defb &41
defb &D
defb &C7
defb &3F,&4
defb &C9
defb &32
defb &91
defb &CF,&3
defb &41
defb &F,&11
defb &81
defb &CF,&17
defb &32
defb &F3
defb &35
defb &C6
defb &41
defb &F,&0
defb &81
defb &C9
defb &3F,&1
defb &91
defb &CF,&10
defb &F,&10
defb &81
defb &CF,&17
defb &61
defb &10,&8F

defb &F1
defb &32
defb &C8
defb &F,&3
defb &81
defb &CC
defb &61
defb &3D
defb &CF,&1
defb &61
defb &35
defb &91
defb &CA
defb &F,&e
defb &CF,&19
defb &36
defb &91
defb &CA
defb &E
defb &81
defb &CF,&3
defb &3C
defb &CA
defb &61
defb &3C
defb &91
defb &C5
defb &41
defb &4
defb &C3
defb &F,&5
defb &CF,&17
defb &3F,&3
defb &91
defb &C4
defb &B
defb &81
defb &CF,&1
defb &20,&1E,&EF
defb &3D
defb &91
defb &C5
defb &61
defb &3F,&0
defb &91
defb &C4
defb &3
defb &81
defb &C6
defb &F,&0
defb &81
defb &CF,&16
defb &61
defb &34
defb &F2
defb &36
defb &F6
defb &20,&1F,&E1
defb &D
defb &C7
defb &91
defb &C6
defb &61
defb &34
defb &F3
defb &71
defb &3F,&0
defb &C4
defb &3F,&1
defb &C4
defb &2
defb &C7
defb &2
defb &81
defb &C4
defb &7
defb &81
defb &CF,&18
defb &10,&1E

defb &B1
defb &FF,&0
defb &32
defb &10,&70
defb &D
defb &C7
defb &3B
defb &B1
defb &F4
defb &71
defb &3F,&0
defb &91
defb &C4
defb &61
defb &3C
defb &91
defb &C4
defb &41
defb &81
defb &CF,&1
defb &41
defb &3
defb &CF,&1c
defb &31
defb &F9
defb &37
defb &91
defb &C1
defb &E
defb &C7
defb &FF,&2
defb &3F,&2
defb &91
defb &C9
defb &61
defb &35
defb &CF,&37
defb &10,&9E
defb &F5
defb &36
defb &91
defb &C6
defb &C
defb &81
defb &C7
defb &FF,&1
defb &3F,&5
defb &91
defb &CA
defb &32
defb &91
defb &CF,&38
defb &31
defb &B1
defb &F4
defb &71
defb &39
defb &C3
defb &41
defb &6
defb &81
defb &CC
defb &FF,&0
defb &71
defb &3F,&7
defb &CF,&1a
defb &1
defb &CF,&1a
defb &61
defb &32
defb &F4
defb &71
defb &3A
defb &C2
defb &2
defb &81
defb &CF,&1
defb &FF,&1
defb &71
defb &3F,&7
defb &CF,&18
defb &3
defb &81
defb &C7
defb &61
defb &3A
defb &CF,&7
defb &61
defb &39
defb &91
defb &CF,&c
defb &FF,&1
defb &3F,&9
defb &91
defb &CF,&15
defb &41
defb &20,&E0,&10
defb &C6
defb &61
defb &3E
defb &CF,&6
defb &35
defb &CF,&10
defb &FE
defb &71
defb &3F,&b
defb &CF,&15
defb &1
defb &10,&70
defb &3
defb &81
defb &C3
defb &3F,&5
defb &91
defb &CF,&25
defb &FF,&0
defb &3F,&c
defb &CF,&14
defb &81
defb &41
defb &5
defb &C1
defb &3F,&12
defb &CF,&1b
defb &FF,&0
defb &71
defb &3F,&c
defb &91
defb &CF,&12
defb &81
defb &6
defb &61
defb &3F,&10
defb &CF,&1d
defb &10,&8F
defb &FE
defb &3F,&d
defb &91
defb &CF,&11
defb &81
defb &6
defb &81
defb &3F,&c
defb &91
defb &CF,&21
defb &33
defb &FC
defb &71
defb &3F,&e
defb &91
defb &CF,&f
defb &81
defb &5
defb &81
defb &C1
defb &3F,&f
defb &91
defb &CF,&20
defb &61
defb &32
defb &FC
defb &3F,&f
defb &CF,&c
defb &31
defb &C2
defb &4
defb &81
defb &C2
defb &3F,&11
defb &C1
defb &36
defb &91
defb &CF,&19
defb &61
defb &B1
defb &FC
defb &3F,&10
defb &CF,&9
defb &61
defb &32
defb &11
defb &2
defb &81
defb &C4
defb &3F,&19
defb &91
defb &CF,&19
defb &B1
defb &FE
defb &71
defb &3F,&f
defb &10,&E1
defb &36
defb &91
defb &CA
defb &61
defb &35
defb &91
defb &C7
defb &3F,&1a
defb &91
defb &CF,&12
defb &3
defb &C3
defb &B1
defb &FE
defb &71
defb &3F,&1a
defb &C6
defb &61
defb &38
defb &C6
defb &61
defb &3A
defb &F2
defb &37
defb &B1
defb &F5
defb &3F,&4
defb &91
defb &CC
defb &61
defb &38
defb &C4
defb &61
defb &34
defb &4
defb &10,&78

defb &31
defb &FF,&2
defb &71
defb &32
defb &F4
defb &3F,&20
defb &C6
defb &62
defb &35
defb &B1
defb &FF,&8
defb &35
defb &F3
defb &71
defb &36
defb &91
defb &C8
defb &61
defb &3F,&2
defb &B1
defb &F2
defb &3
defb &C1
defb &61
defb &32
defb &FF,&11
defb &3F,&17
defb &61
defb &91
defb &C5
defb &10,&4B
defb &36
defb &FF,&8
defb &71
defb &32
defb &B1
defb &F6
defb &71
defb &35
defb &C7
defb &32
defb &91
defb &C4
defb &3B
defb &F4
defb &C4
defb &34
defb &FF,&17
defb &71
defb &3F,&f
defb &C1
defb &91
defb &C6
defb &61
defb &37
defb &FF,&10
defb &3F,&0
defb &91
defb &C1
defb &3
defb &10,&78
defb &3E
defb &10,&78
defb &33
defb &FF,&14
defb &3F,&15
defb &91
defb &C8
defb &61
defb &39
defb &FF,&c
defb &3F,&2
defb &C1
defb &5
defb &C1
defb &3D
defb &F1
defb &32
defb &B1
defb &FF,&15
defb &3F,&16
defb &91
defb &C9
defb &3A
defb &FF,&e
defb &3D
defb &10,&61
defb &5
defb &81
defb &61
defb &3B
defb &F2
defb &33
defb &FF,&19
defb &37
defb &F6
defb &71
defb &3F,&4
defb &91
defb &C9
defb &3A
defb &B1
defb &FF,&f
defb &3B
defb &91
defb &6
defb &81
defb &61
defb &3A
defb &F3
defb &C2
defb &32
defb &FF,&26
defb &3F,&4
defb &91
defb &C9
defb &39
defb &FF,&13
defb &71
defb &38
defb &C1
defb &7
defb &C1
defb &39
defb &B1
defb &F3
defb &C4
defb &36
defb &FF,&23
defb &71
defb &38
defb &B1
defb &F5
defb &71
defb &91
defb &C9
defb &B1
defb &FF,&1c
defb &38
defb &41
defb &7
defb &81
defb &3D
defb &C7
defb &61
defb &33
defb &FF,&32
defb &C7
defb &33
defb &B1
defb &FF,&1e
defb &36
defb &41
defb &7
defb &10,&68
defb &3C
defb &CA
defb &61
defb &3A
defb &FF,&28
defb &C2
defb &F1
defb &38
defb &FF,&20
defb &34
defb &C1
defb &7
defb &10,&68

defb &31
defb &FA
defb &31
defb &7
defb &CB
defb &34
defb &FF,&27
defb &10,&F8

defb &F1
defb &35
defb &10,&6F

defb &31
defb &FF,&8
defb &31
defb &FF,&9
defb &71
defb &32
defb &10,&E1

defb &41
defb &4
defb &81
defb &61
defb &FD
defb &E
defb &81
defb &C4
defb &61
defb &3A
defb &B1
defb &FF,&1e
defb &C1
defb &F2
defb &71
defb &34
defb &10,&EF

defb &31
defb &FF,&8
defb &31
defb &FF,&c
defb &32
defb &91
defb &3
defb &61
defb &FA
defb &71
defb &33
defb &F1
defb &F,&2
defb &CB
defb &36
defb &FF,&1e
defb &71
defb &34
defb &FF,&a
defb &71
defb &10,&8F
defb &FA
defb &31
defb &FF,&2
defb &91
defb &3
defb &E1
defb &FA
defb &91
defb &C3
defb &E1
defb &F,&a
defb &81
defb &C7
defb &33
defb &B1
defb &FF,&1b
defb &71
defb &33
defb &B1
defb &FF,&a
defb &71
defb &10,&BC
defb &F8
defb &71
defb &33
defb &FF,&1
defb &91
defb &3
defb &B1
defb &FA
defb &91
defb &2
defb &10,&E0
defb &F,&f
defb &81
defb &C5
defb &33
defb &FF,&19
defb &71
defb &33
defb &B1
defb &FF,&a
defb &71
defb &10,&BC
defb &F8
defb &10,&87
defb &C2
defb &31
defb &FF,&0
defb &91
defb &3
defb &B1
defb &FA
defb &C1
defb &3
defb &81
defb &F,&13
defb &81
defb &C3
defb &3A
defb &FF,&10
defb &71
defb &33
defb &FF,&b
defb &71
defb &10,&BC
defb &F7
defb &31
defb &91
defb &C3
defb &10,&9E
defb &FE
defb &11
defb &3
defb &10,&9E
defb &F8
defb &10,&D3
defb &F,&19
defb &C6
defb &61
defb &35
defb &B1
defb &FF,&f
defb &D1
defb &10,&1E

defb &C1
defb &FF,&b
defb &31
defb &10,&3C
defb &F6
defb &20,&87,&70
defb &2
defb &10,&3C

defb &B1
defb &FD
defb &91
defb &3
defb &10,&F8
defb &F9
defb &91
defb &F,&1c
defb &C7
defb &61
defb &32
defb &B1
defb &FF,&e
defb &D1
defb &10,&F4

defb &C1
defb &FF,&b
defb &91
defb &10,&78
defb &F6
defb &31
defb &C2
defb &4
defb &C1
defb &31
defb &FC
defb &71
defb &C1
defb &3
defb &10,&E0

defb &B1
defb &F7
defb &10,&97
defb &F,&1e
defb &81
defb &C6
defb &32
defb &B1
defb &FF,&c
defb &D1
defb &C2
defb &D1
defb &10,&F8
defb &FF,&a
defb &91
defb &10,&78
defb &32
defb &F3
defb &32
defb &C1
defb &6
defb &10,&BC
defb &F4
defb &71
defb &37
defb &C1
defb &4
defb &C1
defb &33
defb &F4
defb &71
defb &10,&87

defb &41
defb &F,&21
defb &C5
defb &32
defb &FF,&b
defb &91
defb &C4
defb &61
defb &FF,&7
defb &71
defb &32
defb &91
defb &C4
defb &33
defb &C2
defb &7
defb &10,&2C
defb &F2
defb &71
defb &32
defb &C3
defb &32
defb &C2
defb &41
defb &4
defb &C1
defb &61
defb &33
defb &B1
defb &F2
defb &33
defb &41
defb &F,&23
defb &C5
defb &32
defb &B1
defb &FC
defb &3B
defb &10,&E1

defb &61
defb &C3
defb &34
defb &FF,&3
defb &33
defb &C9
defb &9
defb &61
defb &32
defb &91
defb &C8
defb &41
defb &5
defb &81
defb &C3
defb &61
defb &32
defb &20,&3F,&B4

defb &41
defb &F,&25
defb &81
defb &C4
defb &61
defb &3F,&18
defb &F6
defb &71
defb &37
defb &91
defb &C4
defb &E
defb &81
defb &CA
defb &8
defb &C4
defb &61
defb &33
defb &C2
defb &41
defb &F,&28
defb &C7
defb &61
defb &34
defb &CF,&e
defb &39
defb &91
defb &C8
defb &F,&15
defb &C4
defb &61
defb &10,&87

defb &C1
defb &F,&2b
defb &81
defb &CF,&27
defb &41
defb &F,&18
defb &C6
defb &41
defb &F,&2d
defb &81
defb &CF,&25
defb &F,&1a
defb &81
defb &C4
defb &F,&2c
defb &CF,&28
defb &41
defb &F,&51
defb &81
defb &CF,&30
defb &41
defb &F,&3e
defb &CF,&43
defb &41
defb &F,&3a
defb &CF,&13
defb &3F,&a
defb &91
defb &CF,&f
defb &F,&33
defb &81
defb &CF,&f
defb &61
defb &3F,&1b
defb &CF,&7
defb &41
defb &F,&2d
defb &81
defb &CD
defb &61
defb &3F,&37
defb &91
defb &CF,&2
defb &F,&27
defb &CC
defb &3F,&41
defb &91
defb &CF,&2
defb &41
defb &F,&1f
defb &81
defb &CB
defb &3F,&12
defb &B1
defb &FF,&2
defb &71
defb &3F,&17
defb &CF,&2
defb &41
defb &F,&17
defb &CC
defb &61
defb &3F,&e
defb &B1
defb &FF,&19
defb &3F,&8
defb &CF,&5
defb &41
defb &F,&e
defb &81
defb &CD
defb &3C
defb &B1
defb &FF,&37
defb &3F,&1
defb &CF,&4
defb &F,&9
defb &CF,&1
defb &61
defb &39
defb &FF,&3f
defb &3F,&1
defb &CF,&6
defb &F,&4
defb &CE
defb &61
defb &39
defb &FF,&41
defb &3F,&4
defb &91
defb &CF,&4
defb &F,&2
defb &CB
defb &3A
defb &FF,&45
defb &71
defb &3F,&6
defb &91
defb &CF,&1
defb &41
defb &F,&0
defb &C8
defb &61
defb &3B
defb &FF,&48
defb &71
defb &3F,&7
defb &CF,&4
defb &41
defb &A
defb &C5
defb &3D
defb &FF,&4c
defb &3F,&7
defb &91
defb &CF,&6
defb &41
defb &6
defb &3F,&1
defb &FF,&50
defb &71
defb &3F,&5
defb &CF,&8
defb &41
defb &4
defb &3B
defb &FF,&59
defb &71
defb &3F,&2
defb &91
defb &CF,&b
defb &37
defb &FF,&64
defb &3C
defb &CF,&b
defb &34
defb &B1
defb &FF,&68
defb &3B
defb &CF,&a
defb &FF,&6f
defb &3A
defb &CF,&9
defb &FF,&71
defb &71
defb &39
defb &91
defb &CF,&6
defb &FF,&73
defb &71
defb &3B
defb &91
defb &CF,&2
defb &FF,&75
defb &3F,&1
defb &CC
defb &FF,&77
defb &71
defb &3F,&0
defb &91
defb &C9
defb &FF,&7a
defb &3F,&1
defb &C7
defb &FF,&7c
defb &71
defb &3D
defb &91
defb &C6
defb &FF,&80
defb &71
defb &3B
defb &91
defb &C4
defb &FF,&81
defb &71
defb &3C
defb &91
defb &C2
defb &FF,&86
defb &3B
defb &FF,&88

defb &71
defb &38
PicEndmessagepng_rledataEnd: defb 0


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
limit &BF00
LastByte:defb 1
save direct "T52-SC6.D04",FirstByte,LastByte-FirstByte
