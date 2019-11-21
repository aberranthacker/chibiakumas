read "CoreDefs.asm"

;Bank C4 - Level Sprites 3+4 / Level Compiled Sprites (7B00 - alternate (boss) music)
;Bank C5 - Bootstrap Cache
;Bank C6 - 128k Special screens / Font (F000)
;Bank C7 - Level sprites (C000) / Vertical Sprites E800 / Bochan Plus sprites! (F800)

DiskMap1 equ 1
DiskMap2 equ 2
DiskMap3 equ 3
DiskMap4 equ 4

;limit Akuyou_LevelStart+&6500
org Akuyou_BootStrapStart

FileBeginBootStrap:
; The bootstrap is responsible for most loading, it will page in and start new
; levels when called handle their distribution over the system memory and do
; title screens / game over and the like

; depending on the command Control may not be returned, as this program wipes
; out the level code however if needed the level will be restarted via its
; jumpblock

; It loads into &4000, so cannot be used when the screen is page flipping

; When the bootstrap is in memory, the Bitmap font will be available at &7000
; This is for the Main menu and similar

; on the  464 it will be loaded in each time
; in the 6128 it will be always in memory
;-------------------------------------------------------------------------------
; Make Instructions:
;
; Do not compile this directly, Compile Core.asm as it compiles this as well
; Both must be compiled together, as Bootstrap points to locations in Core -
; you will get a crash otherwise!
;-------------------------------------------------------------------------------
jp Bootstrap_Launch    ; &4000
jp Bootstrap_FromBasic ; &4003
jp Bootstrap_FromHL    ; &4006
jp null                ; &400C

Bootstrap_Launch:
    ld bc,&7f8D ; Reset the firmware to OFF
    out (c),c
    ld hl,RasterColors_InitColors
    call SetColors

    ld h,0
    ld l,0

Bootstrap_FromHL:
    ; HL is used as the bootstrap command
    ; H=1 means levels
    ; H=0 means system events (Menu etc)
    ld a,h
    or a
    jr z,Bootstrap_SystemEvent
    cp 1
    jr z,Bootstrap_Level
ret

Bootstrap_SystemEvent:
    ; Bootstrap System event
    ld a,l
    cp 0
    jp z,BootsStrap_StartGame
    cp 1
    jp z,BootsStrap_ContinueScreen
    cp 2
    jp z,BootsStrap_ConfigureControls
    cp 3
    jp z,BootStrap_SaveSettings
    cp 4
    jp z,GameOverWin
    cp 5
    jp z,NewGame_EP2_1UP
    cp 6
    jp z,NewGame_EP2_2UP
    cp 7
    jp z,NewGame_EP2_2P
    cp 8
    jp z,NewGame_CheatStart
ret

Bootstrap_Level:
    ld sp,SPReset   ; we are not returning, so reset the stack
    ; Load and start a level
    ld a,l
    cp 0
    jp z,Bootstrap_Level_0Again

ifdef CompileEP1 ; {{{
    cp 1
    jp z,Bootstrap_Level_1
    cp 2
    jp z,Bootstrap_Level_2
    cp 3
    jp z,Bootstrap_Level_3
    cp 4
    jp z,Bootstrap_Level_4
    cp 5
    jp z,Bootstrap_Level_5
    cp 6
    jp z,Bootstrap_Level_6
    cp 7
    jp z,Bootstrap_Level_7
    cp 8
    jp z,Bootstrap_Level_8
    cp 9
    jp z,Bootstrap_Level_9
    cp 250
    jp z,Bootstrap_Level_EndIntro   ;Shown before the last level
    cp 251
    jp z,Bootstrap_Level_EndOutro   ; End Sequence
    cp 252
    jp z,Bootstrap_Level_Intro
    cp 255
    jp z,Bootstrap_Level_TEST
endif ; }}}
ifdef CompileEP2 ; {{{
    cp 11
    jp z,Bootstrap_Stage_11
    cp 12
    jp z,Bootstrap_Stage_12
    cp 13
    jp z,Bootstrap_Stage_13
    cp 14
    jp z,Bootstrap_Stage_14
    cp 15
    jp z,Bootstrap_Stage_15
    cp 16
    jp z,Bootstrap_Stage_16
    cp 17
    jp z,Bootstrap_Stage_17
    cp 18
    jp z,Bootstrap_Stage_18
    cp 19
    jp z,Bootstrap_Stage_19
    cp 20
    jp z,Bootstrap_Stage_20
    cp 240
    jp z,Bootstrap_Level_Ep2Intro
    cp 241
    jp z,Bootstrap_Level_Ep2EndIntro
    cp 242
    jp z,Bootstrap_Level_Ep2EndOutro
endif ; }}}

jp Bootstrap_Level_1 ;should never get here!

Bootstrap_FromBasic:
    ld l,(ix+0)
    ld h,(ix+1)
    jp Bootstrap_FromHL

;*******************************************************************************
;*                                Start Game                                   *
;*******************************************************************************
Blackout64k: ;Blackout screen on 64k, do nothing on 128
ifdef Support64k
    ifdef debug
        ret
    endif

    ifndef debug
        ld e,1
        ld hl,RasterColors_Black
        call RasterColors_NoDelay
        ld hl,RasterColors_ZeroColors
        call SetColors
    endif
endif
ret

BootsStrap_StartGame:
    read "..\AkuCPC\BootsStrap_StartGame_CPC.asm"
    jp Bootstrap_Level_0    ; Start the menu

Enable_Player_CheatMode:
    xor a
    ld (CheatMode_Plus1-1),a
    ret

;For testing the game from an intro - cheat the game to start with certain players
Cheat_BochanOnly:
    ld a,1
    ld (LivePlayers),a
    ld a,3
    ld (P2_P09),a
    xor a
    ld (P1_P09),a
ret
Cheat_ChibikoOnly:
    ld a,1
    ld (LivePlayers),a
    ld a,3
    ld (P1_P09),a
    xor a
    ld (P2_P09),a
ret
Cheat_TwoPlayer:
    ld a,2
    ld (LivePlayers),a
    ld a,3
    ld (P1_P09),a
    ld (P2_P09),a
ret

; There are two version of Level0 (Menu) - one to run from the game load up
; and one to reset things if the game has returned from gameover

;backup 4k of screen for temp use - we always use the screen for scratch area,
;but if we have spare space somewhere else, lets's use it!
LocateAndShowTextLines:
    call Akuyou_DrawText_LocateSprite
ShowTextLines:
    push hl
    push bc
    ld a,2
    call Akuyou_SpriteBank_Font
    pop bc
    pop hl
ShowTextLinesAgain:
    ld a,(bc)
    ld h,a
    dec h
    inc bc
    call Akuyou_DrawText_LocateSprite

    ld a,255
    ld i,a
    push hl
        call Akuyou_DrawText_PrintString
    pop hl
    inc bc
    inc l
    ld a,(bc)
    or a
    jr nz,ShowTextLinesAgain
ret

ifdef Debug
    DebugBuild:
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db 13, "Debug Build", "!"+&80
    db  0
endif

InitPlayer:
    ld a,3
    ld (iy+9),a
    ret

NewGame_CheatStart:
    pop hl  ;junk
    call StartANewGame
    pop hl  ;Get CheatSettings
    ld a,h
    push hl
        ld hl,Cheat_ChibikoOnly
        cp 0
        jr z,ApplyCheatPlayerCall

        ld hl,Cheat_BochanOnly
        cp 1
        jr z,ApplyCheatPlayerCall

        ld hl,Cheat_TwoPlayer
        cp 2
        jr z,ApplyCheatPlayerCall

ApplyCheatPlayerCall:
        ld (CheatPlayerCall_Plus2-2),hl
    pop hl
    ld a,l
    or a
    jr z,ApplyCheatNoCheatMode

    xor a
    call Enable_Player_CheatMode

ApplyCheatNoCheatMode:
    call null :CheatPlayerCall_Plus2

    pop hl ;level

    ld sp,SPReset
    jp Bootstrap_Level
ret

NewGame_EP2_2P:
    call StartANewGame
    ld iy,Player_Array

    ld a,2
    ld (iy-7),a ;live players

    call InitPlayer

    ld de,Akuyou_PlayerSeparator
    add iy,de
    call InitPlayer
ifdef CompileEP1
    jp Bootstrap_Level_1
endif
ifdef CompileEP2
    jr Bootstrap_Stage_11
endif

NewGame_EP2_1UP:
    call StartANewGame
    ld iy,Player_Array

    call InitPlayer
ifdef CompileEP1
    jp Bootstrap_Level_1
endif
ifdef CompileEP2
    jr Bootstrap_Stage_11
endif

NewGame_EP2_2UP:
    call StartANewGame

    ld iy,Player_Array
    ld de,Akuyou_PlayerSeparator
    add iy,de
    call InitPlayer
ifdef CompileEP1
    jp Bootstrap_Level_1
endif
ifdef CompileEP2
    jr Bootstrap_Stage_11
endif

ifdef CompileEP2 ; {{{
Bootstrap_Stage_11:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level1        ;T10-SC1.D01
    ld c,DiskMap_Level1_Disk

    call Bootstrap_LoadEP2Music_Z

    jp Bootstrap_LoadEP2Level_2PartZ;_Zpartial

Bootstrap_Stage_12:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ;Music from first part
    ld hl,DiskMap_Level1        ;T10-SC1.D01
    ld c,DiskMap_Level1_Disk
    call Bootstrap_LoadEP2Music_Z

    ;music for boss battle
    ld hl,DiskMap_MusicBoss
    ld c,DiskMap_MusicBoss_Disk
    call Bootstrap_LoadEP2AltMusic_Z

    ld a,&C0
    ld hl,DiskMap_Level2
    ld c,DiskMap_Level2_Disk

    jp Bootstrap_LoadEP2Level_4PartZ

Bootstrap_Stage_13:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level3        ;T20-SC1.D01
    ld c,DiskMap_Level3_Disk

    call Bootstrap_LoadEP2Music_Z

    jp Bootstrap_LoadEP2Level_2PartZ;_Zpartial

Bootstrap_Stage_14:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level3        ;T20-SC1.D01
    ld c,DiskMap_Level3_Disk
    call Bootstrap_LoadEP2Music_Z

    ;music for boss battle
    ld hl,DiskMap_MusicBoss
    ld c,DiskMap_MusicBoss_Disk
    call Bootstrap_LoadEP2AltMusic_Z

    ld hl,DiskMap_Level4
    ld c,DiskMap_Level4_Disk    ;T24-SC1.D01
    jp Bootstrap_LoadEP2Level_2PartZ;_Zpartial

Bootstrap_Stage_15:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level1
    ld c,2;DiskMap_Level1_Disk

    call Bootstrap_LoadEP2Music_Z


    ld hl,DiskMap_Level1 ;T10-SC1.D01
    ld c,2
    jp Bootstrap_LoadEP2Level_2PartZ

Bootstrap_Stage_16:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level1
    ld c,2
    call Bootstrap_LoadEP2Music_Z

    ;music for boss battle
    ld hl,DiskMap_MusicBoss
    ld c,DiskMap_MusicBoss_Disk
    call Bootstrap_LoadEP2AltMusic_Z

    ld hl,DiskMap_Level2
    ld c,2  ;T14-SC1.D01
    jp Bootstrap_LoadEP2Level_4PartZ;_Zpartial

Bootstrap_Stage_17:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level3
    ld c,2  ;T20-SC1.D02
    call Bootstrap_LoadEP2LoadScreen_Z

    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level3
    ld c,2  ;T20-SC1.D02
    jp Bootstrap_LoadEP2Level_2PartZ;_Zpartial

Bootstrap_Stage_18:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    ld hl,DiskMap_Level3
    ld c,2  ;T20-SC1.D02
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level4
    ld c,2  ;T24-SC1.D02

    ld a,&C4
    ld l,&C3
    ld de,&4000
    ld ix,&8000
    call LoadDiscSectorZ_WithPushes

    ld a,&C1           ;128k Part
    ld l,&C2
    ld de,LevelData128kpos
    ld ix,&E800
    call LoadDiscSectorZ_WithPushes

    push bc
    push hl
    push ix
        ;music for boss battle
        ld a,&C7
        ld hl,DiskMap_MusicBoss
        ld c,DiskMap_MusicBoss_Disk
        ld de,&6200
        ld ix,&6200+&450
        call Akuyou_LoadDiscSectorZ
    pop ix
    pop hl
    pop bc

jp Bootstrap_LoadEP2Level_1PartZ

Bootstrap_Level_Ep2EndOutro:
    ld hl,DiskMap_Intro     ;T56-SC1.D04
    ld c,DiskMap_IntroEp2_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_EndOutro ;T50-SC1.D03
    ld c,4

    jp Bootstrap_LoadEP2Level_1PartZ

Bootstrap_Level_Ep2EndIntro:
    ld hl,DiskMap_EndIntro ;"T56-SC1.D04"
    ld c,3

    call Bootstrap_LoadEP2Music_Z

    jp Bootstrap_LoadEP2Level_1PartZ

Bootstrap_Level_Ep2Intro:
    ld hl,DiskMap_Intro     ;T56-SC1.D04
    ld c,DiskMap_IntroEp2_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Intro ;"T56-SC1.D04"
    ld c,DiskMap_IntroEp2_Disk
    jp Bootstrap_LoadEP2Level_1PartZ

Bootstrap_Stage_19:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call FireMode_4D

    ld hl,DiskMap_Stage_19  ;T30-SC1.D02
    ld c,2

    call Bootstrap_LoadEP2LoadScreen_Z

    call Bootstrap_LoadEP2Music_Z

    jp Bootstrap_LoadEP2Level_4PartZ

Bootstrap_Stage_20:
    call Akuyou_RasterColors_DefaultSafe
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call FireMode_4D

    ld hl,DiskMap_Stage_20B     ;T32-SC1.D02
    ld c,DiskMap_Stage_20_Disk

    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Stage_20  ;T31-SC1.D02
    ld c,DiskMap_Stage_20_Disk

    ld a,&C4
    ld de,&4000
    ld ix,&4000+&4000
    ld l,&C3
    call LoadDiscSectorZ_WithPushes

    ;256k Banks
    ;CC CD CE CF
    ;D4 D5 D6 D7

    ld a,(CPCVer)   ;cpcver
    and 64      ;256k?
    jr z,Stage20No256k

    ld l,23             ; Show the 'Debug mode' message
    ld bc,load256k
    call ShowTextLines

    ld hl,DiskMap_Stage_20  ;T31-SC1.D02
    ld c,DiskMap_Stage_20_Disk

    ld a,&CC
    ld de,&4000
    ld l,&C4
    ld ix,&4000+&4000
    call LoadDiscSectorZ_WithPushes

    ld a,&CD
    ld de,&4000
    ld l,&C5
    call LoadDiscSectorZ_WithPushes

    ld a,&CE
    ld de,&4000
    ld l,&C6
    call LoadDiscSectorZ_WithPushes

    ld a,&CF
    ld de,&4000
    ld l,&C7
    call LoadDiscSectorZ_WithPushes

    ld a,&D4
    ld de,&4000
    ld l,&C8
    call LoadDiscSectorZ_WithPushes

    ld a,&D5
    ld de,&4000
    ld l,&C9
    call LoadDiscSectorZ_WithPushes

    ld hl,DiskMap_Stage_20B  ;T32-SC1.D02
    ld a,&D6
    ld de,&4000
    ld l,&C1
    call LoadDiscSectorZ_WithPushes

    ld a,&D7
    ld de,&4000
    ld l,&C2
    call LoadDiscSectorZ_WithPushes

    ld hl,DiskMap_Stage_20  ;T31-SC1.D02
Stage20No256k:
    jp Bootstrap_LoadEP2Level_2PartZ
endif ; }}}

LoadDiscSector_WithPushes:
        push bc
        push hl
            call Akuyou_LoadDiscSector
        pop hl
        pop bc
ret

LoadDiscSectorZ_WithPushes:
        push bc
        push hl
            call Akuyou_LoadDiscSectorZ
        pop hl
        pop bc
ret

;Compressed Loader
Bootstrap_LoadEP2LoadScreen_Z:
    ld a,&C0
    ld de,&4000
    ld ix,&4000+&4000
    ld l,&C8
        call LoadDiscSectorZ_WithPushes
        call Akuyou_RasterColors_DefaultSafe
        call Akuyou_CLS
        di
        exx
        push bc
        call &4000
        pop bc
        exx
    ret

Bootstrap_LoadEP2AltMusic_Z:
    ld a, &C4
    ld de,Akuyou_MusicPosAlt
    ld ix,Akuyou_MusicPosAlt+&450
    jp Akuyou_LoadDiscSectorZ

Bootstrap_LoadEP2Music_Z:
    ld a, Akuyou_Music_Bank
    ld de,Akuyou_MusicPos
    ld ix,Akuyou_MusicPos+&400
    ld l, &C9
    jp LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_2Part_Z:
    ld a,&C1           ;128k Part
    ld l,&C2
    ld de,LevelData128kpos
    ld ix,&E800
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_1Part_Z:
    ld a,&C0        ; Base Part
    ld l,&C1
    ld de,Akuyou_LevelStart+&1000
    ld ix,&8000
    call Akuyou_LoadDiscSectorZ

    jp GenericStartLevel

; Uncompressed - For Testing
Bootstrap_LoadEP2Music:
    ld a,&C0
    ld de,Akuyou_MusicPos
    ld ix,Akuyou_MusicPos+&400
    ld l,&C9
    jp LoadDiscSector_WithPushes

Bootstrap_LoadEP2Level_3PartAlt:
    ld a,&C4
    ld l,&C3
    ld de,&4000
    ld ix,&8000
    call LoadDiscSector_WithPushes
    jp Bootstrap_LoadEP2Level_2Part

Bootstrap_LoadEP2Level_2PartBegin:
    jr Bootstrap_LoadEP2Level_2Part

Bootstrap_LoadEP2Level_4PartBegin:
Bootstrap_LoadEP2Level_4Part:
    ld l,&C4
    ld a,LevelData128kpos_D_Bank ;&C4

    ld de,LevelData128kpos_D ;&6000
    ld ix,LevelData128kpos_D +&2000;&8000
    call LoadDiscSector_WithPushes

Bootstrap_LoadEP2Level_3Part:
    ld l,&C3
    ld a,LevelData128kpos_C_Bank ;&C4
    ld de,LevelData128kpos_C;&4000
    ld ix,LevelData128kpos_C +&2000;&6000
    call LoadDiscSector_WithPushes

Bootstrap_LoadEP2Level_2Part:
    ld l,&C2
    ld a,LevelData128kpos_Bank ;&C1        ;128k Part

    ld de,LevelData128kpos
    ld ix,LevelData128kpos+&2800
    call LoadDiscSector_WithPushes

Bootstrap_LoadEP2Level_1Part:

Bootstrap_LoadEP2Level_1PartOnly:
    ld l,&C1

    ld a,Akuyou_LevelStart_Bank ;&C0        ; Base Part

    ld de,Akuyou_LevelStart
    ld ix,Akuyou_LevelStart+&3FFF

    call LoadDiscSectorZ_WithPushes
    jp GenericStartLevel

Bootstrap_Level_NoV9K:
    ret

Bootstrap_LoadEP2Level_4PartZ:
    ld a,&C4
    ld l,&C4
    ld de,&6000
    ld ix,Akuyou_MusicPosAlt;&8000
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_3PartZ:
    ld a,&C4
    ld l,&C3
    ld de,&4000
    ld ix,&6000
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_2PartZ:
    ld a,&C1           ;128k Part
    ld l,&C2
    ld de,LevelData128kpos
    ld ix,&E800
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_1PartZ:
    ld a,&C0        ; Base Part
    ld l,&C1
    ld de,Akuyou_LevelStart
    ld ix,&8000;7FFF
    call Akuyou_LoadDiscSectorZ

GenericStartLevel:
    di
    call Akuyou_Firmware_Kill ; Backup the firmware so the Level can override it

    jp LevelData_StartLevel ; the Bootstrap will be overwritten by the screenbuffer

; Part Compressed - For Testing
Bootstrap_LoadEP2Level_4Part_Zpartial:
    ld a,&C4
    ld l,&C4
    ld de,&6000
    ld ix,&8000
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_3Part_Zpartial:
    ld a,&C4
    ld l,&C3
    ld de,&4000
    ld ix,&6000
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_2Part_Zpartial:
    ld a,&C1           ;128k Part
    ld l,&C2
    ld de,LevelData128kpos
    ld ix,&E800
    call LoadDiscSectorZ_WithPushes

Bootstrap_LoadEP2Level_1Part_Zpartial:
    ld a,&C0        ; Base Part
    ld l,&C1
    ld de,Akuyou_LevelStart
    ld ix,&8000;7FFF
    call Akuyou_LoadDiscSector

    jp GenericStartLevel

Bootstrap_Level_0Again:
    ld sp,SPReset   ; we are not returning, so reset the stack

    ei

    ld hl,RasterColors_ZeroColors
    call SetColors
    halt
    halt
    halt
    halt
    halt

    ld a,(CPCVer)
    and %10000000
    jr z,ReloadTitleCPC64k

    ld a,LevelData128kpos_C_Bank
    ld hl,DiskMap_LoadingScreen
    ld b,DiskMap_LoadingScreen_Size
    ld c,DiskMap_LoadingScreen_Disk
    ld de,&C000
    ld ix,&8000-1;-8523
    jr ReloadTitleCPC
ReloadTitleCPC64k:
    ld a,&C0
    ld hl,DiskMap_LoadingScreen
    ld b,DiskMap_LoadingScreen_Size
    ld c,DiskMap_LoadingScreen_Disk
    ld de,&C000
    ld ix,&C000+&4000-1;-8523
    jr ReloadTitleCPC
ReloadTitleCPC:
    call Akuyou_LoadDiscSectorZ

Bootstrap_Level_0: ; main menu {{{
    call StartANewGame
    call LevelReset0000

    ld hl,DiskMap_MainMenu      ;T08-SC1.D01
    ld c,DiskMap_MainMenu_Disk

    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_MainMenu      ;T08-SC1.D01
    ld c,DiskMap_MainMenu_Disk

    ;need to use Specail MSX version - no extra tilemaps
    jp Bootstrap_LoadEP2Level_1PartOnly;Bootstrap_LoadEP2Level_1Part;Z;_Zpartial
ret ; }}}

Level_1Msg: ; {{{
    ifndef CPC320
        ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
        ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5
        db 6, "After a hard night massacring"," "+&80
        db 6, "villagers and harvesting their"," "+&80
        db 6, "Blood,Chibiko is having a well"," "+&80
        db 6, "earned days sleep. Suddenly She"," "+&80
        db 6, "is awoken by A swarm of noizy,"," "+&80
        db 6, "ill concieved and badly drawn"," "+&80
        db 5, "Monsters, that are invading her"," "+&80
        db 5, "Castle and disturbing the peace!"," "+&80
        db 7, "Chibiko's not the kind of"," "+&80
        db 6, "Vampire to take that! Time to"," "+&80
        db 5, "'Rise from your grave' and give"," "+&80
        db 7, "hell to whoever sent them","!"+&80
    else
        db 2, "After a hard nights work massacrin","g"+&80
        db 2, "villagers and harvesting their bloo","d"+&80
        db 1, "Chibiko is having a well earned day'","s"+&80
        db 1, "sleep... Suddenly she is awoken by ","a"+&80
        db 4, "commotion. A swarm of noizy, stupi","d"+&80
        db 2, "ill concieved and badly drawn monster","s"+&80
        db 2, "are being drawn to her castle, and ar","e"+&80
        db 4, "seriously disturbing the peace","!"+&80
        db 4, "No self respecting vampire ca","n"+&80
        db 3, "overlook this insult! its time t","o"+&80
        db 3, "'Rise from your grave' and unleas","h"+&80
        db 6, "hell on whoever sent them","!"+&80
    endif
        db &0 ; end of Level_1MsG }}}

Bootstrap_Level_TEST: ; {{{
    ld a,CSprite_Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_LevelTest     ;T10-SC1.D01
    ld c,DiskMap_LevelTest_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_LevelTest
    ld c,DiskMap_LevelTest_Disk

    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_1: ; {{{
;Turn these on later
    ld a,CSprite_Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_Level1        ;T10-SC8.D01
    ld c,DiskMap_Level1_Disk
    call Bootstrap_LoadEP2LoadScreen_Z

    ld l,12
    ld bc,Level_1Msg
    call LocateAndShowTextLines

    ld hl,DiskMap_Level1        ;T10-SC1.D01
    ld c,DiskMap_Level1_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level1
    ld c,DiskMap_Level1_Disk
    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_2: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_Level2
    ld c,DiskMap_Level2_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level2
    ld c,DiskMap_Level2_Disk

    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
ret

Level_3Msg: ; {{{
ifndef CPC320
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5
    db  7, "The monsters climbing the"," "+&80
    db  7, "mountain seem to be coming"," "+&80
    db  6, "from the forest.Its time to"," "+&80
    db  6, "push forward, and stop the"," "+&80
    db 14, "invasion!"," "+&80
    db  5, "The animals of the forest seem"," "+&80
    db  5, "to have become mutants,zombies"," "+&80
    db  6, "& generally super-annoyin","g"+&80
    db  6, "But no matter what monster","s"+&80
    db  6, "lurks in the forest it will"," "+&80
    db  7, "be no match for Chibiko'","s"+&80
    db 11, "Black Magic!!","!"+&80
else
    db  3, "The monsters climbing the mountai","n"+&80
    db  3, "Seem to be coming from the fores","t"+&80
    db  3, "Its time to push forward, and sto","p"+&80
    db 13, "the invasion","!"+&80
    db  3, "The animals of the forest seem t","o"+&80
    db  3, "have become mutants, zombies, an","d"+&80
    db  8, "generally super-annoyin","g"+&80
    db 15, " "," "+&80
    db  3, "But no matter what zombified evi","l"+&80
    db  3, "lurks in the heart of the fores","t"+&80
    db  3, "it will be no match for Chibiko'","s"+&80
    db 13, "Black Magic!!","!"+&80
endif
    db &0 ; }}}
Bootstrap_Level_3: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_Level3        ;T10-SC8.D01
    ld c,DiskMap_Level3_Disk
    call Bootstrap_LoadEP2LoadScreen_Z

    ld l,12
    ld bc,Level_3Msg
    call LocateAndShowTextLines

    ld hl,DiskMap_Level1
    ld c,DiskMap_Level1_Disk
    call Bootstrap_LoadEP2Music_Z


    ld hl,DiskMap_Level3
    ld c,DiskMap_Level3_Disk

    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_4: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_Level2
    ld c,DiskMap_Level2_Disk

    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level4
    ld c,DiskMap_Level4_Disk

    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
ret

Level_5Msg: ; {{{
ifndef CPC320
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5
    db  5, "After defeating the zombified"," "+&80
    db  7, "merchandise cash-cow,and"," "+&80
    db  6, "narrowly avoiding buying the"," "+&80
    db  5, "plush doll,Chibiko headed down"," "+&80
    db  5, "to the river, only to find it"," "+&80
    db  5, "also full of weird stuff too!"," "+&80
    db  6, "Heading to the source will"," "+&80
    db  8, "reveal whoever sent the","m"+&80
    db  5, "and stop this annoyance once"," "+&80
    db 14, "and for all","!"+&80
else
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db 15, ""," "+&80
    db  2, "After defeating the evil zombifie","d"+&80
    db  3, "merchandise cash-cow,and narrowl","y"+&80
    db  4, "avoiding buying the plush dol","l"+&80
    db  3, "Chibiko headed down to the river",","+&80
    db  3, "only to find it also full of weir","d"+&80
    db  4, "stuff too! Heading to the sourc","e"+&80
    db  5, "will reveal whoever sent the","m"+&80
    db  3, "and stop this annoyance once an","d"+&80
    db 15, "for all","!"+&80
endif
    db &0 ; }}}

Bootstrap_Level_5: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_Level5        ;T10-SC8.D01
    ld c,DiskMap_Level5_Disk
    call Bootstrap_LoadEP2LoadScreen_Z

    ld l,12
    ld bc,Level_5Msg
    call LocateAndShowTextLines

    ld hl,DiskMap_Level5
    ld c,DiskMap_Level5_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level5
    ld c,DiskMap_Level5_Disk

    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_6: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000


    ld hl,DiskMap_Level6
    ld c,DiskMap_Level6_Disk
    call Bootstrap_LoadEP2Music_Z


    ld hl,DiskMap_Level6
    ld c,DiskMap_Level6_Disk
    jp Bootstrap_LoadEP2Level_4PartBegin
; }}}
ret

PressFireMessage:
    ld hl,&0918             ; Show the Continue message
    call Akuyou_DrawText_LocateSprite
    ld bc,PressFireMsg
    ld a,255
    ld i,a
    call Akuyou_DrawText_PrintString

    jp WaitForFire
PressFireMsg:
    db "Press Fire to Continue","!"+&80

Level_7Msg: ; {{{
ifndef CPC320
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5
    db  6, "The monsters are coming from"," "+&80
    db  6, "this cave! There's only one"," "+&80
    db  5, "entrance,So whoever is sending"," "+&80
    db  9, "them must be in there","!"+&80
    db  5, "Its difficult to see, as the"," "+&80
    db  7, "cave is are only lit by "," "+&80
    db  7, "phosphor rock and Glowing"," "+&80
    db 14, "creatures!"," "+&80
    db  6, "Victory is in your grasp","!"+&80
    db  6, "Go in there, and sort this"," "+&80
    db 14, "Shit out!"," "+&80
else
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db  3, "The monsters are coming from thi","s"+&80
    db  3, "cave! There's only one entranc","e"+&80
    db  2, "So whoever is sending them must b","e"+&80
    db 15, "in there","!"+&80
    db 15, " "," "+&80
    db  3, "Its difficult to see, as the cave","s"+&80
    db  2, "is are only lit by phosphor rock","s"+&80
    db 09, "and Glowing Creature","s"+&80
    db 15, " "," "+&80
    db  7, "Victory is in your grasp","!"+&80
    db  1, "Go in there, and 'Sort that shit out!","'"+&80
endif
    db &0 ; }}}
Bootstrap_Level_7: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite

    call LevelReset0000

    ld hl,DiskMap_Level7        ;T10-SC8.D01
    ld c,DiskMap_Level7_Disk
    call Bootstrap_LoadEP2LoadScreen_Z

    ld l,12
    ld bc,Level_7Msg
    call LocateAndShowTextLines

    ld hl,DiskMap_Level5
    ld c,DiskMap_Level5_Disk
    call Bootstrap_LoadEP2Music_Z


    ld hl,DiskMap_Level7
    ld c,DiskMap_Level7_Disk
    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
    ret
Bootstrap_Level_8: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite
    call LevelReset0000

    ld hl,DiskMap_Level5
    ld c,DiskMap_Level5_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level8
    ld c,DiskMap_Level8_Disk
    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_9: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite
    call LevelReset0000

    ld hl,DiskMap_Level6
    ld c,DiskMap_Level6_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Level9
    ld c,DiskMap_Level9_Disk
    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_Intro: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite
    call LevelReset0000

    call Bootstrap_Level_NoV9K

    ld hl,DiskMap_Intro
    ld c,2
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_Intro
    ld c,2              ;T38-SC1.D02
    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_EndIntro: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite
    call LevelReset0000

    call Bootstrap_Level_NoV9K

    ld hl,DiskMap_Level5
    ld c,DiskMap_Level5_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_EndIntro
    ld c,DiskMap_EndIntro_Disk      ;T38-SC1.D02
    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}
Bootstrap_Level_EndOutro: ; {{{
    ld a,CSprite_Loading        ;Loading
    call Akuyou_ShowCompiledSprite
    call LevelReset0000

    call Bootstrap_Level_NoV9K

    ld hl,DiskMap_Level5
    ld c,DiskMap_Level5_Disk
    call Bootstrap_LoadEP2Music_Z

    ld hl,DiskMap_EndOutro
    ld c,2              ;T38-SC1.D02

    jp Bootstrap_LoadEP2Level_2PartBegin
; }}}

; File Locations in virtual Track-Sector
; The game was originally intended to use a direct disk reader - however as I managed
; to get Firware restore working, and the popularity of C4CPC and M4 disk emulators
; it seemed a bad choice to limit compatibility like that.
; note the SIZE variables are redundant, the reader never uses them!

read "DiskMap.asm"

SetColors:
    ld a,1
    ld b,0
    ld c,b
    push hl
    call &bc38  ; set border 0 to black
    pop hl
    ld b,4
    ld c,0
RasterColors_InitBasic:
    push hl
    push bc
        ld a,c
        ld c,(hl)
        ld b,c
        call &bc32  ; set ink 0 to black
    pop bc
    pop hl
    inc c
    inc hl
    djnz RasterColors_InitBasic

    ret

;Savesettings save the Highscore, Controls etc
Bootstrap_SaveSettings:
    call &BB57 ; VDU Disable

    ld hl,FileName_Settings
    ld bc,SavedSettings_Last-SavedSettings
    ld de,SavedSettings
    call BootStrap_SaveDiskFile
    call &BB54 ; VDU enable

    ret

RasterColors_ZeroColors: defb 0,0,0
RasterColors_InitColors: defb 0,4,14,26

;Before the core is active we load files by filename, afterwards we use Track-Sector-Disk
FileName_Settings: db "SETTINGS.V02"
FileName_Core:     db "CORE    .AKU"

;*******************************************************************************
;                   Music Loader
;*******************************************************************************
;This backs up the level colors, and uses the 'safe color' pallete
;used by the continue screen to pause the level, then restore it later
BootsStrap_BasicColors:
    ld hl,(RasterColors_ColorArray1Pointer_Plus2-2);,bc
    ld (BootsStrap_RestoreColors_BC_Plus2-2),hl
    ld hl,(RasterColors_ColorArray2Pointer_Plus2-2);,de
    ld (BootsStrap_RestoreColors_DE_Plus2-2),hl
    ld hl,(RasterColors_ColorArray3Pointer_Plus2-2);,hl
    ld (BootsStrap_RestoreColors_HL_Plus2-2),hl
    ld hl,(RasterColors_ColorArray4Pointer_Plus2-2);,ix
    ld (BootsStrap_RestoreColors_IX_Plus2-2),hl
    ld hl,(RasterColors_PerFrameCallRestore_Plus2-2);,iy
    ld (BootsStrap_RestoreColors_IY_Plus2-2),hl
    ld iy,null
    push de
    push de
    push de
    pop bc
    pop hl
    pop ix
    jr BootsStrap_RestoreColors_Doset
BootsStrap_RestoreColors:
    ld bc,&0000 :BootsStrap_RestoreColors_BC_Plus2
    ld de,&0000 :BootsStrap_RestoreColors_DE_Plus2
    ld hl,&0000 :BootsStrap_RestoreColors_HL_Plus2
    ld ix,&0000 :BootsStrap_RestoreColors_IX_Plus2
    ld iy,&0000 :BootsStrap_RestoreColors_IY_Plus2
    jr BootsStrap_RestoreColors_Dosetb
BootsStrap_RestoreColors_Doset:
    ld iy,null
BootsStrap_RestoreColors_Dosetb:
    ld a,1

    jp RasterColors_SetPointers

BootsStrap_ContinueMsg:
;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db 15, "You're Dead!", " "+&80
    db 17, "(Again!)", " "+&80
    db 0
TurnOffPlusRaster:
    di
    ret

BootsStrap_ContinueScreen:
    ld de,RasterColors_Safe_ForInterrupt
    call BootsStrap_BasicColors
    call RasterColors_RestoreInterrupt

    ld a,2
    call SpriteBank_Font

    call AkuYou_Player_GetPlayerVars
    ld a,(iy+5)
    or a
    jp z,GameOver

    Call TurnOffPlusRaster
    ld a,CSprite_Continue       ;Loading
    call Akuyou_ShowCompiledSprite

    ;simpler compiled sprite for 64k
    ld a,(CPCVer)
    and 128
    jr nz,Skip64kcompiled

    ld l,1
    call Akuyou_DrawText_LocateSprite
    ld bc,BootsStrap_ContinueMsg
    call ShowTextLines

    call CompiledSpriteContinue

Skip64kcompiled:
    ld a,2
    call SpriteBank_Font

    ld hl,&0F12             ; Show the Continue message
    call Akuyou_DrawText_LocateSprite
    ld bc,txtPressButtonMsg2;txtContinueMsg
    ld a,255
    ld i,a
    call Akuyou_DrawText_PrintString

    ld l,&15                ; show how many credits are left

    call ShowContinues

    ld B,10
    ld ixl,255

Player_Dead_CountDown:
    dec B                   ; Show the countdown
    jp z,GameOver;Player_Dead_Resume ;GameOver      ;Player_Dead_Resume=continue on zero
    ld hl,&1317
    call Akuyou_DrawText_LocateSprite
    ld a,48
    add B
    push bc
        call Akuyou_DrawText_CharSprite
    pop bc

    ld a,b
    cp 8
    jr C,Player_Dead_PauseForFire
    call PauseASec
    jr Player_Dead_Pause
Player_Dead_PauseForFire:
    call PauseASecForFire

Player_Dead_Pause:
    ld a,b
    cp 8
    jr NC,Player_Dead_CountDown

    ld a, ixl   ; read the keymap
    or Keymap_AnyFire
    cp 255
    jp nz,Player_Dead_Resume

    ld a, ixh   ; read the keymap
    or Keymap_AnyFire
    cp 255
    jp nz,Player_Dead_Resumep2

    jr Player_Dead_CountDown
Player_Dead_Resumep2:
    ld iy,Player_Array2
    jr Player_Dead_ResumeB
Player_Dead_Resume:
    ld iy,Player_Array
Player_Dead_ResumeB:
    ld a,3
    ld (iy+9),a
    ld a,(SmartbombsReset)
    ld (iy+3),a

SpendCreditSelfMod2:    ld iy,Player_Array      ; All credits are (currently) stored in player 1's var!
    ld a,(iy+5)
    dec a
    ld (iy+5),a

    xor a
    ld (ShowContinueCounter_Plus1-1),a
    ;re-enable our buffered screen and bits
    di

    call BootsStrap_RestoreColors
    call RasterColors_RestoreInterrupt
    ld a,&80
    jp CLS

    ret

PauseASec:
    push bc
    ld b,60
PauseASecB:
    push bc
        call AkuYou_Player_ReadControls
    pop bc
    ei
    halt
    halt
    halt
    halt
    halt
    halt
    djnz PauseASecB

    pop bc
ret

PauseASecForFire:
    push bc
    ld b,250
    ld c,4
PauseASecForFireB:
        push bc
            call AkuYou_Player_ReadControls
        pop bc

        ld a, ixl   ; read the keymap
        or Keymap_AnyFire
        cp 255
        jp nz,PauseASecForFireDone
        ld a, ixh   ; read the keymap
        or Keymap_AnyFire
        cp 255
        jp nz,PauseASecForFireDone
    djnz PauseASecForFireB
    dec c
    ld a,c
    or a
    jp nz,PauseASecForFireB

PauseASecForFireDone
    pop bc
ret

;Insulting player messages!
ifdef CompileEP1
txtGameOver1Msg: ; {{{
    ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db  6, "The Monster Hoarde Has Drive", "n"+&80
    db  8, "Chibiko from her homelan", "d"+&80
    db  2, "She is forced to live in a cardboar", "d"+&80
    db  8, "box as a street vampire", "!"+&80
    db 10, "With Chibiko gone", ","+&80
    db 10, "Peace and harmon", "y"+&80
    db  6, "Spreads through out the land", "."+&80
    db  8, "(Boy! Did you fuck up!", ")"+&80
    db  0 ; }}}
RankText:
;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    db  3, "Your 'Chibiko Scoring System (TM)", "'"+&80
    db 15, "Rank was", "-"+&80
    db  0
RankF:
    db 17, "*****", " "+&80
    db 17, "*    ", " "+&80
    db 17, "*****", " "+&80
    db 17, "*    ", " "+&80
    db 17, "*    ", " "+&80
    db  0
ChibikoReview:
    db 12, "Chibiko says:", " "+&80
    db  0

ChibikoReviewsWin:
    defw ChibikoReviewWin
ChibikoReviewsNewScore:
    defw ChibikoReview1
    defw ChibikoReview2
    defw ChibikoReview3
    defw ChibikoReview4
ChibikoReviewsMehScore:
    defw ChibikoReview5
    defw ChibikoReview6
    defw ChibikoReview7
    defw ChibikoReview8

ifdef CPC320
    ScoreXPos equ 10
else
    ScoreXPos equ 13
endif
; ChibikoReview text messages
ifdef CompileEP1 ; {{{
ChibikoReviewWin: ; {{{
    ifdef CPC320
        db ScoreXPos, "Well, you won","!"+&80
        db ScoreXPos, "But I'm still giving you an F","!"+&80
        db ScoreXPos, " "," "+&80
        db ScoreXPos, "Try get a better score nex","t"+&80
        db ScoreXPos, "time sucker! ;-)"," "+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "Well, you won","!"+&80
        db ScoreXPos, "But I'm still giving"," "+&80
        db ScoreXPos, "you an F! "," "+&80
        db ScoreXPos, "Try get a better score"," "+&80
        db ScoreXPos, "next time sucker! ;-)"," "+&80
    endif
    db 0 ; }}}
ChibikoReview1: ; {{{
    ifdef CPC320
        db ScoreXPos, "Good Job","!"+&80
        db ScoreXPos, "Now try plugging the controlle","r"+&80
        db ScoreXPos, "in first before starting th","e"+&80
        db ScoreXPos, "game","!"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos,"Good Job","!"+&80
        db ScoreXPos,"Now try plugging the"," "+&80
        db ScoreXPos,"controller in first"," "+&80
        db ScoreXPos,"before starting the"," "+&80
        db ScoreXPos,"game!"," "+&80
    endif
    db 0 ; }}}
ChibikoReview2: ; {{{
    ifdef CPC320
        db ScoreXPos, "Amazing!!","!"+&80
        db ScoreXPos, "You survived SUCH a long tim","e"+&80
        db ScoreXPos, "by aimlessly hitting button","s"+&80
        db ScoreXPos, "at random","!"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "Amazing!!","!"+&80
        db ScoreXPos, "You survived SUCH a"," "+&80
        db ScoreXPos, "long time by aimlessly"," "+&80
        db ScoreXPos, "hitting buttons at"," "+&80
        db ScoreXPos, "random!"," "+&80
    endif
    db 0 ; }}}
ChibikoReview3: ; {{{
    ifdef CPC320
        db ScoreXPos, "Superb Performace","!"+&80
        db ScoreXPos, "Imagine how good you'll b","e"+&80
        db ScoreXPos, "when you actually learn ho","w"+&80
        db ScoreXPos, "to play","!"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "Superb Performace","!"+&80
        db ScoreXPos, "Imagine how good you'll"," "+&80
        db ScoreXPos, "be when you actually"," "+&80
        db ScoreXPos, "learn how to play","!"+&80
    endif
    db 0 ; }}}
ChibikoReview4: ; {{{
    ifdef CPC320
        db ScoreXPos, "Well Done","!"+&80
        db ScoreXPos, "I'm sure there's worse player","s"+&80
        db ScoreXPos, "out there, I mean, the worl","d"+&80
        db ScoreXPos, "population is 7 billio","n"+&80
        db ScoreXPos, "....There MUST be, right","?"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "Well Done","!"+&80
        db ScoreXPos, "I'm sure there's worse"," "+&80
        db ScoreXPos, "players out there,"," "+&80
        db ScoreXPos, "I mean, the world"," "+&80
        db ScoreXPos, "population is 7 billion"," "+&80
        db ScoreXPos, "There MUST be, right","?"+&80
    endif
    db 0 ; }}}
ChibikoReview5: ; {{{
    ifdef CPC320
    ;                 12345678901234567890123
        db ScoreXPos, "You're really something, afte","r"+&80
        db ScoreXPos, "all, It's rare to see someon","e"+&80
        db ScoreXPos, "CLINICALLY BRAINDEAD still abl","e"+&80
        db ScoreXPos, "to play computer games","!"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "You're really something"," "+&80
        db ScoreXPos, "after all, It's rare to"," "+&80
        db ScoreXPos, "see someone CLINICALLY"," "+&80
        db ScoreXPos, "BRAINDEAD still able to"," "+&80
        db ScoreXPos, "play computer games!"," "+&80
    endif
    db 0 ; }}}
ChibikoReview6: ; {{{
    ifdef CPC320
    ;                 12345678901234567890123
        db ScoreXPos, "If YOU are the result of 2"," "+&80
        db ScoreXPos, "million years of human"," "+&80
        db ScoreXPos, "evolution I'd say the species"," "+&80
        db ScoreXPos, "is seriously fucked","!"+&80

    else
    ;                 12345678901234567890123
        db ScoreXPos, "If YOU are the result"," "+&80
        db ScoreXPos, "of 2 million years of"," "+&80
        db ScoreXPos, "human evolution I'd say"," "+&80
        db ScoreXPos, "the species is"," "+&80
        db ScoreXPos, "seriously fucked","!"+&80
    endif
    db 0 ; }}}
ChibikoReview7: ; {{{
    ifdef CPC320
        db ScoreXPos, "Never mind","!"+&80
        db ScoreXPos, "Maybe you will manage to serv","e"+&80
        db ScoreXPos, "some purpose one day!?","!"+&80
        db ScoreXPos, "You DO own an organ donor"," "+&80
        db ScoreXPos, "card don't you","?"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "Never mind","!"+&80
        db ScoreXPos, "Maybe you will manage"," "+&80
        db ScoreXPos, "to serve some purpose"," "+&80
        db ScoreXPos, "one day!?!"," "+&80
        db ScoreXPos, "You DO own an organ"," "+&80
        db ScoreXPos, "donor card don't you","?"+&80
    endif
    db 0 ; }}}
ChibikoReview8: ; {{{
    ifdef CPC320
        db ScoreXPos, "I'd say the purpose of you","r"+&80
        db ScoreXPos, "existance is to defin","e"+&80
        db ScoreXPos, "utter failure so the res","t"+&80
        db ScoreXPos, "of the population can fee","l"+&80
        db ScoreXPos, "superior","!"+&80
    else
    ;                 12345678901234567890123
        db ScoreXPos, "I'd say the purpose"," "+&80
        db ScoreXPos, "of your existance is"," "+&80
        db ScoreXPos, "to define utter failure"," "+&80
        db ScoreXPos, "so the rest of the"," "+&80
        db ScoreXPos, "population can feel"," "+&80
        db ScoreXPos, "superior!"," "+&80
    endif
    db 0 ; }}}
endif ; CompileEP1 }}}
ifdef CompileEP2 ; {{{
ChibikoReviewWin:
    db 10, "Well, you won","!"+&80
    db 10, "But I'm still giving you a F","!"+&80
    db 10, "Haven't you learned yet","?"+&80
    db 10, "The only way to win is not "," "+&80
    db 10, "to play!"," "+&80
    db 0
ChibikoReview1:
    db 10, "Well done","!"+&80
    db 10, "You played the game"," "+&80
    db 10, "ALL BY YOURSELF!"," "+&80
    db 10, "Won't your mommy be proud","!"+&80
    db 0
ChibikoReview2:
    db 10, "Amazing!!","!"+&80
    db 10, "Maybe one day you'll eve","n"+&80
    db 10, "Be able to tie your shoe","e"+&80
    db 10, "without drooling all over"," "+&80
    db 10, "Yourself firs","t"+&80
    db 0
ChibikoReview3:
    db 10, "Superb Performance","!"+&80
    db 10, " "," "+&80
    db 10, "Nah! I'm humoring you",","+&80
;          123456789012345678901234567890
    db 10, "Really, you were just awful","!"+&80
    db 0
ChibikoReview4:
    db 10, "You call that playing","?"+&80
    db 10, "I've seen things on fir","e"+&80
    db 10, "Move better than that","!"+&80
    db 0
ChibikoReview5:
    db 10, "Whoa! What happened there","!"+&80
    db 10, "I'd call you a complete an","d"+&80
    db 10, "utter waste of life, bu","t"+&80
    db 10, "You'd take it as a compliment","!"+&80
    db 0
ChibikoReview6:
    db 10, "Sooo! you're as useless as "," "+&80
    db 10, "You are stupid and ugly!!"," "+&80
    db 10, "Well, at least you're","!"+&80
    db 10, "consistent","!"+&80
    db 0
ChibikoReview7:
    db 10, "Well..","."+&80
    db 10, "After seeing you in actio","n"+&80
    db 10, "I think we can rule out"," "+&80
    db 10, "'Intelligent Design' as th","e"+&80
    db 10, "source of your species","!"+&80
    db 0
ChibikoReview8:
    db 10, "That's the best you can do","?"+&80
    db 10, "I'd say you best bet is to kil","l"+&80
    db 10, "yourself and hope that","t"+&80
    db 10, "reincarnation is a thing","!"+&80
    db 0
endif ; CompileEP2 }}}

GameOverWin:
    call AkuYou_Player_GetPlayerVars
    ld a,(iy-10)
    ;Achievements (Wxx54321)    -10
    or            %10000000
    ld (iy-10),a
    pop iy

    call GameOverDoLoad

    xor a
    ld (ReviewFilter_Plus1-1),a
    ld hl,ChibikoReviewsWin
    ld (ReviewBank_Plus2-2),hl
    ld (NewScoreBank_Plus2-2),hl

    jp GameOverWinB

    ifdef CompileEP1 ; {{{
        GameoverColors1:
            defb 1
            defb 0
            defb &54,&4C,&4E,&43
        GameoverColors2:
            defb 1
            defb 0
            defb &54,&4C,&4E,&43
        GameoverColors3:
            defb 1
            defb 215
            defb &54,&5D,&5F,&4B
        GameoverColors4:
            defb 1
            defb 0
            defb &54,&5D,&5F,&4B
    endif ; }}}
    ifdef CompileEP2 ; {{{
        GameoverColors1:
            defb 1
            defb 0
            defb &54,&58,&5B,&4B
        GameoverColors2:
            defb 1
            defb 0
            defb &54,&58,&5B,&4B
        GameoverColors3:
            defb 1
            defb 48
            defb &54,&4C,&52,&4B
        GameoverColors4:
            defb 1
            defb 0
            defb &54,&4C,&52,&4B
    endif ; }}}

ifdef CompileEP2 ; {{{
    txtGameOver2aMsg: ; {{{
        ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
        ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db 1, "The Yuushas restored"," "+&80
        db 1, "Chibiko and Bochan"," "+&80
        db 3, "to humanity..."," "+&80
        db 1, " "," "+&80
        db 1, "Chibiko was sent to"," "+&80
        db 3, "Sunday School"," "+&80
        db 2, "to repent for her"," "+&80
        db 7, "Sins!"," "+&80
        db 0 ; }}}
    txtGameOver2bMsg: ; {{{
        ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
        ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db 22+2, "And Bochan was"," "+&80
        db 22+1, "Forced on an all"," "+&80
        db 22+1, "vegetable detox!"," "+&80
        db  0 ; }}}
    txtGameOver2cMsg: ; {{{
        ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
        ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
        db 15, "No Bochan,"," "+&80
        db  5, "That's a common misconception!"," "+&80
        db  1, "In fact the toaster makes an excellent"," "+&80
        db 15, "Bath toy!"," "+&80
        db  1, " "," "+&80
        db  1, "Now you take your bath, I'm going to"," "+&80
        db  1, "spend the afternoon playing with this"," "+&80
        db  6, "dangerously sharp crucifix!"," "+&80
        db  1, " "," "+&80
        db  3, "Once we're dead and cursed, we'll"," "+&80
        db  3, "get our magic powers back and be"," "+&80
        db  1, "able to get revenge for this outrage!"," "+&80
        db  0 ; }}}
endif ; }}}

GameOverDoLoad:
    call TurnOffPlusRaster
    Call Cls

    ld a,CSprite_Loading        ;
    call Akuyou_ShowCompiledSprite

    ld a,3
    ld (ReviewFilter_Plus1-1),a

    ld hl,ChibikoReviewsMehScore
    ld (ReviewBank_Plus2-2),hl
    ld hl,ChibikoReviewsNewScore
    ld (NewScoreBank_Plus2-2),hl

    di
    call Akuyou_Music_Stop

    call Firmware_Restore
    ld a,&C0            ;; bank number
    ld de,&4000     ;; load address
    ld hl,DiskMap_GameOver
    ld b,DiskMap_GameOver_Size
    ld c,DiskMap_GameOver_Disk
    ld ix,&4000+&4000
    call Akuyou_LoadDiscSectorz
    call Firmware_Kill

    ld de,RasterColors_Black_ForInterrupt
    call BootsStrap_BasicColors

    call INT_Init
    ei
    call Akuyou_Music_Play

    ld bc,GameoverColors1
    ld de,GameoverColors2
    ld hl,GameoverColors3
    ld ix,GameoverColors4
    ld iy,null
    ld a,1
    call RasterColors_SetPointers
    call RasterColors_RestoreInterrupt

    ei

    ld hl,Font_RegularSizePos;&4000
    call Akuyou_ShowSprite_SetBankAddr
ret

GameOver:
    call GameOverDoLoad

ifdef CompileEP1
    call &4000
    ld l,16
    call Akuyou_DrawText_LocateSprite
    ld bc,txtGameOver1Msg
endif

ifdef CompileEP2 ; // {{{
        ;ep 2 ver
        ld l,&2
        call Akuyou_DrawText_LocateSprite
        ld bc,txtGameOver2aMsg
        call ShowTextLines

        ld l,17
        call Akuyou_DrawText_LocateSprite
        ld bc,txtGameOver2bMsg
        call ShowTextLines

        Call WaitForFire

        ld de,RasterColors_Safe_ForInterrupt
        call BootsStrap_BasicColors
    call akuyou_cls

    call &4003

    ld l,13
    call Akuyou_DrawText_LocateSprite
    ld bc,txtGameOver2cMsg
endif ; // }}}

    call ShowTextLines
    call WaitForFire

GameOverWinB:
;see if we have a highscore
    ld de,Player_ScoreBytes+7
    ld (ShownScore_Plus2-2),de      ;Show Player 1's score, unless player 2 did better
    call HighScoreCheck
    ld de,Player_ScoreBytes2+7
    call HighScoreCheck
    jr ScoreCheckDone

HighScoreCheck:
    push de
        ld hl,HighScoreBytes+7
        ld b,8
    NewScoreNextDigit:
        ld c,(hl)
        ld a,(de)
        cp c
        jr c,NewScoreNotHigher
        jr z,NewScoreDigitEqual
        jr NewScoreHigher
    NewScoreDigitEqual:
        dec hl
        dec de
        djnz NewScoreNextDigit

NewScoreNotHigher:
    pop hl
    ret
NewScoreHigher:
pop hl
    ld (ShownScore_Plus2-2),hl
    ld de,HighScoreBytes+7
    ld bc,8
    lddr

    ld hl,ChibikoReviewsNewScore :NewScoreBank_Plus2
    ld (ReviewBank_Plus2-2),hl
ret

ScoreCheckDone:

;;;;;;;;;;;;;;;;;;;;Show Chibiko Scoring System ;;;;;;;;;;;;;;;;;;;;

ifdef CompileEP1
    ld de,RasterColors_Safe_ForInterrupt
    call BootsStrap_BasicColors
endif

ifdef CompileEP1
    call &4003
else
    call &4006
endif
    ld a,2
    call SpriteBank_Font

    ld hl,&0700             ; Show the Continue message
    call Akuyou_DrawText_LocateSprite
    ld bc,txtYourScoreMsg
    ld a,255
    ld i,a
    call Akuyou_DrawText_PrintString

    ld hl,&0A02             ; Show the Continue message
    call Akuyou_DrawText_LocateSprite
    ld bc,txtHighScoreMsg
    ld a,255
    ld i,a
    call Akuyou_DrawText_PrintString

        ld hl,&2000
        call DrawText_LocateSprite

        ld hl, Player_ScoreBytes+7  :ShownScore_Plus2
        ld bc,-7
        add hl,bc
        ld b,8
        call GameOverScore_NextDigit

        ld hl,&2002
        call DrawText_LocateSprite

        ld hl,HighScoreBytes
        ld b,8
        call GameOverScore_NextDigit

ifdef CPC320
    ld l,&07
else
    ld l,&05
endif
    call Akuyou_DrawText_LocateSprite
    ld bc,RankText
    call ShowTextLines

    call Akuyou_Music_Stop

    call Firmware_Restore
    call Bootstrap_SaveSettings

    call Firmware_Kill
    call INT_Init

    call Akuyou_Music_Play

    call RasterColors_RestoreInterrupt
    ei

    ifdef CPC320
        ld l,&0A
    else
        ld l,&09
    endif

    call Akuyou_DrawText_LocateSprite
    ld bc,RankF
    call ShowTextLines

    ;Show Highscore Message
    ifdef CPC320
        ld l,&11                ;
    else
        ld l,&0F
    endif
    call Akuyou_DrawText_LocateSprite
    ld bc,ChibikoReview
    call ShowTextLines

    ld hl,ChibikoReviewsNewScore :ReviewBank_Plus2
    ld a,r
    rrca
    rrca
    and %00000011 :ReviewFilter_Plus1
    ld b,0
    ld c,a
    add hl,bc
    add hl,bc
    ld c,(hl)
    inc hl
    ld b,(hl)

    ifdef CPC320
        ld l,&13
    else
        ld l,&11
    endif
    call Akuyou_DrawText_LocateSprite

    call ShowTextLines

    Call WaitForFire
GameOverReloadMenu:
    Call StartANewGame
    di

    ld de,RasterColors_Black_ForInterrupt
    call BootsStrap_BasicColors
    call Akuyou_RasterColors_Blackout

    call Akuyou_Music_Stop ;Put before firmware restore - corrupts BC
    call Firmware_Restore

    jp Bootstrap_Level_0Again

GameOverScore_NextDigit:
    push bc
    push hl

        ld a,(hl)
            add 48 ; Move to the correct digit (first 32 are not in font)
                   ;add 8
            ld b,-2 ; we are drawing backwards!

    call DrawText_CharSpriteDirect;DrawText_DigitSprite

    pop hl
    pop bc
    inc hl
    dec b
    jp nz,GameOverScore_NextDigit
    ret

txtYourScoreMsg: db "Your Score was", ":"+&80
txtHighScoreMsg: db "HighScore", ":"+&80

WaitForFire:
    call PauseASec

WaitForFire_Continue:
    push bc
        call AkuYou_Player_ReadControls
    pop bc
    ld a, ixl   ; read the keymap
    and ixh
    or Keymap_AnyFire
    cp 255
    jp z,WaitForFire_Continue
ret

FireMode_Normal:
    ld hl,null
    ld (FireUpHandler_Plus2-2),hl
    ld (FireDownHandler_Plus2-2),hl
    ld (FireLeftHandler_Plus2-2),hl
    ld (FireRightHandler_Plus2-2),hl
    ld hl,SetFireDir_RIGHTsave
    ld (Fire2Handler_Plus2-2),hl
    ld hl,SetFireDir_LEFTsave
    ld (Fire1Handler_Plus2-2),hl

    jr FireMode_Both
FireMode_4D:
    ld hl,SetFireDir_UP
    ld (FireUpHandler_Plus2-2),hl
    ld hl,SetFireDir_DOWN
    ld (FireDownHandler_Plus2-2),hl
    ld hl,SetFireDir_LEFT
    ld (FireLeftHandler_Plus2-2),hl
    ld hl,SetFireDir_RIGHT
    ld (FireRightHandler_Plus2-2),hl

    ld hl,SetFireDir_FireAndSaveRestore
    ld (Fire2Handler_Plus2-2),hl

    ld hl,SetFireDir_Fire
    ld (Fire1Handler_Plus2-2),hl
FireMode_Both:
    ld a,255
    ld (DroneFlipFireCurrent_Plus1-1),a
ret

templateFire1:  bit Keymap_F1,a
templateFire2:  bit Keymap_F2,a

StartANewGame:
    ;reset the core
    xor a
    ld (ShowContinueCounter_Plus1-1),a

    ld bc,&3E0D ; Split Continues ; 3E n = LD A,n
    ld de,&2ADD ; LD IX, (addr) = DD 2A dr ad
    ld a,(ContinueMode)
    or a
    jr nz,ContinueModeSet

    ld bc,&C90E ; Shared Continues ; C9 = RET
    ld de,&21FD ; LD IY, hilo   = FD 21 lo hi

ContinueModeSet:
    ld a,b
    ld (ShowContinuesSelfMod),a
    ld a,c
    ld (ContinuesScreenpos_Plus1-1),a
    ld (SpendCreditSelfMod),de
    ld (SpendCreditSelfMod2),de
    ; set our standard Left-Right Firemode

    call FireMode_Normal

    ;reset all the scores n stuff
    call AkuYou_Player_GetPlayerVars
    ld a,(iy-15)
    and %10000000
    call nz,FireMode_4D

    ld a,1
    ld (iy-7),a ;live players

    ;multiplay support
    ld hl,&003E ; 3E n = LD A, n
    ld a,(MultiplayConfig)
    bit 0,a
    jr z,StartANewGame_NoMultiplay
    ld bc,&F990
    in a,(c)    ; Test if the multiplay is really there!
    inc a
    jr z,StartANewGame_NoMultiplay
    ld hl,&78ED ; ED 78 = IN A,(C)
StartANewGame_NoMultiplay:
    ld (multiplaysupport_Plus2-2),hl ;; ../SrcCPC/Akuyou_CPC_KeyboardDriver.asm:99

    ; we can swap Fire 1 and 2 for Multiplay joysticks - as redefine doesn't work
    ld hl,(templateFire1)
    ld de,(templateFire2)

    ld a,(MultiplayConfig)
    bit 1,a
    jr z,StartANewGame_NoControlFlip
    ex hl,de
StartANewGame_NoControlFlip:
    ld (SelfModifyingFire1),hl
    ld (SelfModifyingFire1b),hl
    ld (SelfModifyingFire2),de

    call AkuYou_Player_GetPlayerVars
    call StartANewGamePlayer
    ld de,Akuyou_PlayerSeparator
    add iy,de
    call StartANewGamePlayer

    ld hl,Player_ScoreBytes
    ld b,8*2
    xor a
ScoreWipeNext:
    ld (hl),a
    inc hl
    djnz ScoreWipeNext

    call AkuYou_Player_GetPlayerVars

    ld de,&00C6 ; C6 n  == ADD A,n
    bit 6,(iy-11)
    jr nz,NoBulletSlowdown
    ld de,&2FCB ; CB 2F == SRA A
NoBulletSlowdown:
    ld (StarSlowdown_Plus2-2),de

    ld de,Stars_AddBurst_Top
    ld bc,BulletConfigHeaven_End-BulletConfigHeaven
    ld hl,BulletConfigHeaven
    ld a,2
    bit 7,(iy-11)
    jr nz,useheaven
    ld hl,BulletConfigHell
    ld a,1
useheaven:
    ld (BurstSpacing_Plus1-1),a

    ldir

    ld a,(iy-11)
    and %00000011
    jp z,Difficulty_Normal
    cp 1
    jp z,Difficulty_Easy
    cp 2
    jp z,Difficulty_Hard
ret

StartANewGamePlayer:
    ;player fire directions
    xor a
    ld (iy+2),a  ;Fire Delay
    ld (iy+4),a  ;drones
    ld (iy+8),a  ;spritenum
    ld (iy+10),a ;burst fire xfire
    ld (iy+13),a ;Points to add
    ld (iy+14),a ;player shoot power
    ld (iy+9),a  ;Player Lives (default both players to dead)
    ld a,16
    ld (iy+6),a  ;drone pos

    ld a,%00000100              :PlayerDefaultShootSpeed_Plus1
    ld (iy+11),a    ;Fire Speed

    ld a,&67
    ld (iy+15),a    ;Fire Dir

    ld a,(SmartbombsReset)
    ld (iy+3),a

    ld a,(ContinuesReset)
    ld (iy+5),a

    ;invincibility
    ld a,%00000111
    ld (iy+7),a
ret

Difficulty_Easy:
    ld a,%00100000
    jr Difficulty_Generic
Difficulty_Normal:
    ld a,%00010000
    jr Difficulty_Generic
Difficulty_Hard:
    ld a,%00001000
    jr Difficulty_Generic
Difficulty_Generic:
    ld (FireFrequencyA_Plus1-1),a
    rrca
    ld (FireFrequencyB_Plus1-1),a
    ld (FireFrequencyC_Plus1-1),a
    rrca
    ld (FireFrequencyD_Plus1-1),a
    rrca
    ld (FireFrequencyE_Plus1-1),a
ret

LevelReset0000:
    call TurnOffPlusRaster

    ; wipe our memory, to clear out any junk from old levels
    ld de,StarArrayPointer+1
    ld hl,StarArrayPointer
    ld bc,&700-1
    ld (hl),0
    ldir

; This resets anything the last level may have messed with during play so we can
; start a new level with everything back to normal
ResetCore:
    ld a,1

    call Akuyou_ShowSpriteReconfigureEnableDisable

    ld a,&69
    ld (Timer_CurrentTick_Plus1-1),a
    ld (DroneFlipCurrent_Plus1-1),a
    ld (DroneFlipFireCurrent_Plus1-1),a

    xor a
    ld (EventObjectAnimatorToAdd_Plus1-1),a
    ld (EventObjectSpriteSizeToAdd_Plus1-1),a
    ld (EventObjectProgramToAdd_Plus1-1),a
    ld (Timer_TicksOccured_Plus1-1),a
    ; ld (Sfx_Sound_Plus1-1),a ; * redundant *

    ; or a ; * what this for? * unnecessary *
    call DroneFlipFire

    ; reset reporgrammable stuff  - I AM USING EXX in these, so make sure that EX af and EXX are not used
    ; at this point!!!
    ld hl,Object_DecreaseLifeShot
    ld (ObjectShotOverride_Plus2-2),hl

    ; set stuff that happens every level
ifdef CPC320
    ld hl,&2064 ;x,y
else
    ld hl,&3264 ;x,y
endif
    ld (Player_Array),hl
    ld l,&96
    ld (Player_Array2),hl

    ld hl,domoves
    ld (ObjectDoMovesOverride_Plus2-2),hl

    ld hl,null
    ld (SmartBombSpecial_Plus2-2),hl
    ld (CustomSmartBombEnemy_Plus2-2),hl
    ld (customPlayerHitter_Plus2-2),hl
    ld (CustomShotToDeathCall_Plus2-2),hl

    xor a
    ld (Sfx_CurrentPriority_Plus1-1),a  ; clear the to-do
    ld (Sfx_Sound_Plus1-1),a            ; clear the note

    call DoMovesBackground_SetScroll

    call DoCustomRsts

    call AkuYou_Player_GetPlayerVars

    read "..\AkuCPC\Bootstrap_ReconfigureCore_CPC.asm"
    jp AkuYou_Player_GetPlayerVars

BootsStrap_ConfigureControls:
    ei
    call TurnOffPlusRaster

    ld e,1
    ld hl,RasterColors_Safe
    call RasterColors_NoDelay
call PauseASec;call KeyboardScanner_Flush ; flush the key buffer

    ld a,2
    call SpriteBank_Font

    ld b,8*2

ConfigureControls_Nextkey:
    push bc
        ld hl,KeyName
        ld a,b
        add b
        sub 2
        ld d,0
        ld e,a
        add hl,de

        ld c,(hl)   ; get the description of the key
        inc hl
        ld b,(hl)   ; get the description of the key

        push de
            ld a,255
            ld i,a    ;show 255 chars
            push bc
                call cls
                ld hl,&0D05
                ld bc,KeyMapString0

                call Akuyou_DrawText_LocateSprite
                call Akuyou_DrawText_PrintString
            pop bc
            ld hl,&0F0C
            call Akuyou_DrawText_LocateSprite
            call Akuyou_DrawText_PrintString

            call KeyboardScanner_WaitForKey
            ld b,200
ConfigureControls_Delay
            halt
            djnz ConfigureControls_Delay

        pop de
            ld hl,KeyMap2
            add hl,de
        push de
            ld (hl),a
            inc hl
            ld (hl),c

        pop de
    pop bc
    djnz ConfigureControls_Nextkey
ret

KeyName: ; {{{
    defw KeyMapString8b
    defw KeyMapString7b
    defw KeyMapString6b
    defw KeyMapString5b
    defw KeyMapString4b
    defw KeyMapString3b
    defw KeyMapString2b
    defw KeyMapString1b

    defw KeyMapString8
    defw KeyMapString7
    defw KeyMapString6
    defw KeyMapString5
    defw KeyMapString4
    defw KeyMapString3
    defw KeyMapString2
    defw KeyMapString1
; }}}

;We use - rather than space so the old text is overwritten - remember our
;spritefont has no space!
             ;      .1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
             ;      .9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
KeyMapString0: db  "Press Key For", ":"+&80
KeyMapString8: db  "--P1-Pause",    "-"+&80
KeyMapString7: db  "-P1-SBomb-",    "-"+&80
KeyMapString6: db  "-P1-FireR-",    "-"+&80
KeyMapString5: db  "-P1-FireL-",    "-"+&80
KeyMapString4: db  "-P1-Right-",    "-"+&80
KeyMapString3: db  "--P1-Left-",    "-"+&80
KeyMapString2: db  "--P1-Down-",    "-"+&80
KeyMapString1: db  "--P1-Up---",    "-"+&80

KeyMapString8b: db  "--P2-Pause",   "-"+&80
KeyMapString7b: db  "-P2-SBomb-",   "-"+&80
KeyMapString6b: db  "-P2-FireR-",   "-"+&80
KeyMapString5b: db  "-P2-FireL-",   "-"+&80
KeyMapString4b: db  "-P2-Right-",   "-"+&80
KeyMapString3b: db  "--P2-Left-",   "-"+&80
KeyMapString2b: db  "--P2-Down-",   "-"+&80
KeyMapString1b: db  "--P2-Up---",   "-"+&80

ClearC000:
    di
    ld hl,&FFFF
    ld b,256
    ld de,&0000
    call SpFill
    ei
        ld e,1
        ld hl,RasterColors_Safe
        call RasterColors_NoDelay
    ret

SpFill:
    ld (SpRestoreFill_Plus2-2),sp

SpFillContinue: ; {{{
    ld sp,hl
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    ld hl,&0000
    add hl,sp
    ld sp,&0000:SpRestoreFill_Plus2
    ei
    di
    djnz SpFillContinue
    ei
    ret
; }}}

BulletConfigHeaven: ; {{{
    ;Starbust code - we use RST 6 as an 'add command' to save memory - RST 6 calls IY
    ;See EventStreamDefinitions for details of how the 'Directions' work
    ;Stars_AddBurst_Top
    defw &FFFF;defw &0705
    defw &FFFF;defw &0F0d
    defw &FFFF;defw &1715
    defw &1F1D
    ;Stars_AddBurst_TopLeft
    defw &FFFF;defw &0301
    defw &FFFF;defw &0b09
    defw &FFFF;defw &1311
    defw &1b19
    defb 0
    ;Stars_AddBurst_Right;
    defw &2725
    defw &FFFF;defw &2f2D
    defw &FFFF;defw &3735
    defw &FFFF;defw &3f3D
    ;Stars_AddBurst_TopRight
    defw &FFFF;defw &0705
    defw &FFFF;defw &0F0d
    defw &FFFF;defw &1715
    defw &1F1D
    defb 0
    ;Stars_AddBurst_Left
    defw &FFFF;defw &0301
    defw &FFFF;defw &0b09
    defw &FFFF;defw &1311
    defw &1b19
    ;Stars_AddBurst_BottomLeft
    defw &2321
    defw &FFFF;defw &2b29
    defw &FFFF;defw &3331
    defw &FFFF;defw &3b39
    defb 0
    ;Stars_AddBurst_Bottom
    defw &2321
    defw &FFFF;defw &2b29
    defw &FFFF;defw &3331
    defw &FFFF;defw &3b39
    ;Stars_AddBurst_BottomRight
    defw &2725
    defw &FFFF;defw &2f2D
    defw &FFFF;defw &3735
    defw &FFFF;defw &3f3D
    defb 0
    ;Stars_AddBurst_Outer
    defw &FFFF;defw &3737
    defw &FFFF;defw &2727
    defw &FFFF;defw &1717
    defw &FFFF;defw &3131
    defw &FFFF;defw &2121
    defw &FFFF;defw &1111
    ;OuterBurstPatternMini
    defw &2F2F
    defw &1F1F
    defw &2929
    defw &1919
    defw &3F39
    defw &0F09
    ;Stars_AddObjectOne
    defb 0
    ;Stars_AddBurst
    defw &FFFF
    defb &FF,&FF
    ;Stars_AddBurst_Small
    defw &3632
    defw &2e2A
    defw &2622
    defw &1e1A
    defw &1612
    defb 0
    defw &1d1b
    defw &FFFF;defw &1513
    defw &FFFF;defw &0d0b
    defb 0
    defw &2726
    defw &FFFF;defw &2f2d
    defw &FFFF;defw &1f1d
    defb 0
    defw &2221
    defw &FFFF;defw &1b19
    defw &FFFF;defw &2b29

    defb 0
    defw &2d2b
    defw &FFFF;defw &3533
    defw &FFFF;defw &3d3b
    defb 0
BulletConfigHeaven_End: ; }}}
BulletConfigHell: ; {{{
    ;Stars_AddBurst_Top
    defw &0705
    defw &0F0d
    defw &1715
    defw &1F1D
    ;Stars_AddBurst_TopLeft
    defw &0301
    defw &0b09
    defw &1311
    defw &1b19
    defb 0
    ;Stars_AddBurst_Right
    defw &2725
    defw &2f2D
    defw &3735
    defw &3f3D
    ;Stars_AddBurst_TopRight
    defw &0705
    defw &0F0d
    defw &1715
    defw &1F1D
    defb 0
    ;Stars_AddBurst_Left
    defw &0301
    defw &0b09
    defw &1311
    defw &1b19
    ;Stars_AddBurst_BottomLeft
    defw &2321
    defw &2b29
    defw &3331
    defw &3b39
    defb 0
    ;Stars_AddBurst_Bottom
    defw &2321
    defw &2b29
    defw &3331
    defw &3b39
    ;Stars_AddBurst_BottomRight
    defw &2725
    defw &2f2D
    defw &3735
    defw &3f3D
    defb 0
    ;Stars_AddBurst_Outer
    defw &3737
    defw &2727
    defw &1717
    defw &3131
    defw &2121
    defw &1111
    ;OuterBurstPatternMini
    defw &2F2F
    defw &1F1F
    defw &2929
    defw &1919
    defw &3F39
    defw &0F09
    ;Stars_AddObjectOne
    defb 0
    ;Stars_AddBurst
    defw &3f08
    defb 0,0
    ;Stars_AddBurst_Small
    defw &3632
    defw &2e2A
    defw &2622
    defw &1e1A
    defw &1612
    defb 0
    ;Stars_AddBurst_TopWide
    defw &1d1b
    defw &1513
    defw &0d0b
    defb 0
    ;Stars_AddBurst_RightWide
    defw &2726
    defw &2f2d
    defw &1f1d
    defb 0
    ;Stars_AddBurst_LeftWide
    defw &2221
    defw &1b19
    defw &2b29
    defb 0
    ;Stars_AddBurst_BottomWide
    defw &2d2b
    defw &3533
    defw &3d3b
    defb 0
BulletConfigHell_End: ; }}}

;the commands we have to send to turn on a plus! {{{
PlusInitSequence:
    defb &ff,&00,&ff,&77,&b3,&51,&a8,&d4,&62,&39,&9c,&46,&2b,&15,&8a,&cd,&ee
; }}}
PlusPaletteGame: ; {{{
    defw &0000 ; colour for sprite pen 1
    defw &0555 ; colour for sprite pen 2
    defw &0AAA ; colour for sprite pen 3
    defw &0FFF ; colour for sprite pen 4
    defw &0066 ; colour for sprite pen 5
    defw &00AA ; colour for sprite pen 6
    defw &0808 ; colour for sprite pen 7
    defw &0F0F ; colour for sprite pen 8
    defw &0FAC ; colour for sprite pen 9
    defw &00F0 ; colour for sprite pen 10
    defw &06F7 ; colour for sprite pen 11
    defw &0F00 ; colour for sprite pen 12
    defw &0800 ; colour for sprite pen 13
    defw &0373 ; colour for sprite pen 14
    defw &0333 ; colour for sprite pen 15
;************************************************************************** }}}

BootStrap_EntTitlePalette:  ;The 'Normal' level palette {{{
    defb 15
    defw &0000
    defw &000F
    defw &08F8
    defw &0FFB
    defb 30
    defw &0000
    defw &003F
    defw &02F2
    defw &0EEB
    defb 45
    defw &0000
    defw &006B
    defw &00D0
    defw &0DDF
    defb 100
    defw &0000
    defw &0077
    defw &0F4F
    defw &0EEE
    defb 140
    defw &0000
    defw &0408
    defw &0b2f
    defw &0EEE
    defb 200-16-2
    defw &0000
    defw &0408
    defw &0b2f
    defw &FFFF
    defb 200-8-2
    defw &0000
    defw &0408
    defw &0b2f
    defw &FFFF
    defb 200
    defw &0000
    defw &0408
    defw &0b2f
    defw &FFFF
; }}}

;*******************************************************************************
;                   Bootstrap Disk Loader
;*******************************************************************************
.cas_out_open   equ &bc8c
.cas_out_direct equ &bc98
.cas_out_close  equ &bc8f

BootStrap_LoadDiskFile:
    ; HL - pointer to disk file
    ; DE - Destination to write to
    push de
    ld de,&C000 ; address of 2k buffer,
    ld b,12     ; 12 chars
    call cas_in_open

    pop hl
    jr nc,LoadGiveUp
    call cas_in_direct
LoadGiveUp:
    jp cas_in_close

BootStrap_SaveDiskFile:
    ifdef ReadOnly
        ret
    endif

    push bc
    push de
        ld a,255
        ld (&BE78),a ;bios_set_message

        ld b,12 ;; B = length of the filename in characters
        ld de,&C000 ; Address of Buffer
        call cas_out_open ;; firmware function to open a file for writing

    pop hl  ;ld hl,&c000;; HL = load address
    pop de  ;ld de,&4000;; DE = length
    ld bc,&0000 ; BC = execution address

    ld a,2 ; A = file type (2 = binary)

    call cas_out_direct ; write file
    call cas_out_close  ; firmware function to close a file opened for writing

    ld bc,&FA7E         ; FLOPPY MOTOR OFF
    out (c),c
ret

;Mini continue compiles sprite for 64k
CompiledSpriteContinue:
    ifdef CompileEP1
        read "ContinueCompiled64k.asm"
    endif
    ifdef CompileEP2
        read "ContinueCompiled64k_Ep2.asm"
    endif

list
lastbyte defb 0
nolist

FileEndBootStrap:
    ;file_name, address,size...} [,exec_address]
    save direct "BootStrp.AKU",Akuyou_BootStrapStart,FileEndBootStrap-Akuyou_BootStrapStart
