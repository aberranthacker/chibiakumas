nolist

CompileEP1 equ 1

buildCPC equ 1     ;Amstrad CPC

ifdef BuildCPC
;   DiskMap_SingleDisk equ 1
endif

PolyPlay equ 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DebugSprite equ 1
;Debug_ShowLevelTime equ 1

;Monitor_Full  equ 1
;Debug_Monitor equ 1
;Monitor_Pause equ 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BuildLang equ ''

AdvancedInterrupts equ 1 ;Enable shadow stack so stack abuse can occur during interrupts!

print " *** CPC Build *** "
BuildCPCv   equ 1
Support64k  equ 1 ; enable code only needed by 64k
;Support128k equ 1 ; enable code only needed by 128k+ (keep enabled for 256/512k etc)
;SupportPlus equ 1
CPC320      equ 1 ;CPC Screen width=320 (otherwise 256)

chrHeart equ 122+5

print " *** English Build *** "

ifndef BuildLevel
    Read "..\AkuPDP11\core.asm"
endif
