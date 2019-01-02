nolist

CompileEP1 equ 1

buildCPC  equ 1     ;Amstrad CPC
BuildCPCv equ 1
BuildENTv equ 0     ;unsupported
BuildMSXv equ 0     ;unsupported
BuildZXSv equ 0     ;unsupported
BuildSAMv equ 0     ;unsupported
BuildTI8v equ 0     ;unsupported

BuildLang equ ''    ;english language

;DiskMap_SingleDisk equ 1

PolyPlay equ 1

;DebugSprite equ 1
;Debug_ShowLevelTime equ 1

;Monitor_Full equ 1
;Debug_Monitor equ 1
;Monitor_Pause equ 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AdvancedInterrupts equ 0 ;Enable shadow stack so stack abuse can occur during interrupts!

Support64k equ 1  ; enable code only needed by 64k
;Support128k equ 1 ; enable code only needed by 128k+ (keep enabled for 256/512k etc)
;SupportPlus equ 1
CPC320 equ 1     ;CPC Screen width=320 (otherwise 256)

chrHeart equ 122+5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ifndef BuildLevel
    Read "..\Aku\Core.asm"
endif
