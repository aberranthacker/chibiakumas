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

; If you have spare space, enable this, if you don't disable it!
;MinimizeCore equ 1 ; Reduce size of the core at the cost of speed - works on 64k or 128k
;DualChibikoHack equ 1

; Enable these to alter functions
;SingleDisk equ 1   ; Disables Disk messages
;ReadOnly equ 1     ; Disable Disk writes - For Cartridge versions!

;Debug equ 1        ; enable debugging options
;DebugSprite equ 1  ; mark slow sprites
;Debug_ShowLevelTime equ 1

;Monitor_Full equ 1
;Debug_Monitor equ 1
;Monitor_Pause equ 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AdvancedInterrupts equ 0 ;Enable shadow stack so stack abuse can occur during interrupts!

Support64k equ 1  ; enable code only needed by 64k
CPC320     equ 1  ;CPC Screen width=320 (otherwise 256)

chrHeart equ 122+5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ifndef BuildLevel
    read "..\Aku\Core.asm"
endif
