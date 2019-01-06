; ------------------------------------------------------------------------------
;*******************************************************************************
;            Super simple Disk reader
;*******************************************************************************

read "LZ48_decrunch.asm"

LoadFileName:           db "T"
LoadFileNameTrack:      db "00-SC"
LoadFileNameSector:     db "1 ."
LoadFileNameCompressed: db "D0"
LoadFileNameDisk:       db "0"

SetDiskMessage: db "Set Disk "

SetDiskMessageDisk: db  "1"+&80
;-------------------------------------------------------------------------------

cas_in_open    equ &bc77
cas_in_direct  equ &bc83
cas_in_close   equ &bc7a
txt_set_cursor equ &bb75

LoadDiscSectorZ: ;Load Compressed Disk sector
    ;DE = Destination of decompressed file
    ;IX = Temp location of Compressed data
    push af
        cp &C0
        jr z,LoadDiscSectorZver_BankOk
        ld a,(CPCVer)
        and 128
        jr nz,LoadDiscSectorZver_BankOk     ; Told to load a file into 128k memory!
        pop af
        ret
LoadDiscSectorZver_BankOk:
    pop af

    push af
        push de
            call LoadDiscSectorZver
        pop de
        ; hl  compressed data adres
        ; de  output adress of dat  
        ld hl,0000 :CompressedDataAddress_Plus2
    pop af
    di

    call BankSwitch_C0
    call LZ48_decrunch
    call BankSwitch_C0_Reset
ret

LoadDiscSectorZver:
    push af
    ld a,'Z'
    push hl
        push ix     ;Use our temp address as the destination
        pop hl
        ld (NewDestination_Plus2-2),hl
        ld hl,DiscDestRelocate
    jr LoadDiscSectorB

LoadDiscSector:       ; This was all structured assuming amsdos would be replaced with 
    ; H = Track  (41) ; a sector based disk reader however with the success of M4
    ; L = Sector (C1) ; and C4CPC - and the fact KL_WALK_ROM seems to restore the
    ; I = Disk   (00) ; A600-BF00 block so well, it was never needed
    ; B = Size - size is not used at all , no need to pass it
    ; C = disk
    ;  A  = 128 k memory bank
    ;; DE = load address 
    push af
    ld a,'D'
    push hl
    ld hl,null

LoadDiscSectorB:
    ld (DiscDestRelocateCall_Plus2-2),hl
    pop hl
    ld (LoadFileNameCompressed),a
    pop af

    ld (DiskLoadBank_Plus1-1),a ; if asked to load to a mem bank >0 on 64k do nothing

    cp &C0
    jr z,LoadDiscSector_64kOk
    ld a,(CPCVer)
    and 128
    ret z       ; Told to load a file into 128k memory!

LoadDiscSector_64kOk:
    push hl

    ld a,c
    add 48
    ld (LoadFileNameDisk),a

    ld hl,DiskRemap
    ld a,c
    add l
    ld l,a
    ld c,(hl)

    ld a,(SetDiskMessageDisk)
    sub &80+48
    cp c
    ifdef SingleDisk
        jr LoadDiscSector_NoDiskCheck   ; The disk is still in
    endif 

    jr z,LoadDiscSector_NoDiskCheck ; Disk Zero means file is assumed to be on 
    ;ALL Disks
        ld a,c
        or a
        
        jr z,DiskZero
        add 48+&80
        ld (SetDiskMessageDisk),a
        call ShowDiskMessage

LoadDiscSector_NoDiskCheck: ;Skip the disk check, just assume the disk is in

DiskZero: ;file common to all disks
    pop hl
    ; Patch the filename with Sector and track info
    push de
        ld b,h
        ld c,l
        ld a,h
        push bc
            ld a,b
            call SectorFile_Decimal
            ld hl,LoadFileNameTrack
            ld a,c
            add 48
            ld (hl),a
            inc hl
            ld a,b
            add 48
            ld (hl),a
        pop bc

        ld a,c
        sub &C0-48

        ld (LoadFileNameSector),a
    pop de
    ld hl,LoadFileName
    jr LoadDiskFileFromHL

LoadDiskFileFromHL: ; Load a file from HL memory loc
    push hl 
        call DiskDriver_Load    ; carry true if sucess
        ld h,d
        ld l,e
        
        jr nc,DiskError1
    pop hl  ; speccy only
    ret

DiskRetry2: ;not needed for speccy
    jr nc,DiskError2
    pop hl

DiskError1:
    call    ShowDiskMessage
    pop hl
    jr LoadDiskFileFromHL

DiskError2:
    call    ShowDiskMessage
    pop hl
    jr LoadDiskFileFromHL

ShowDiskMessage:        ;Show the error messages
    push bc
    push de

    ld a,CSprite_SetDisk
    call ShowCompiledSprite
    call SpriteBank_Font2
        ld hl,&160a :SetDiskMessagePos_Plus2
        ld bc,SetDiskMessage
        call DrawText_LocateAndPrintStringUnlimited

        call KeyboardScanner_WaitForKey
    ld a,CSprite_Loading
    call ShowCompiledSprite

    pop de
    pop bc
ret

SectorFile_Decimal: ; Decimal to Ascii converter
    ld c,0
SectorFile_DecimalSubTen:
    cp 10
    jr c,SectorFile_DecimalLessThanTen
    inc c
    sub 10
    jr SectorFile_DecimalSubTen
SectorFile_DecimalLessThanTen:
    ld b,a
    ret

DiscDestRelocate:
    ld hl,&0000 :NewDestination_Plus2
        or a   ;ccf
        SBC    HL, BC
    ld (CompressedDataAddress_Plus2-2),hl
ret
