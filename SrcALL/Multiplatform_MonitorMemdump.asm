; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Monitor - MemDump
;Version	V1.0
;Date		2018/4/9
;Content	Monitor_MemDump - Show a block of memory to screen - loads in from Defined parameters after call
;		Monitor_MemDumpDirect - shows C bytes of data from address HL

;Sample Usage

;	call Monitor_MemDump	;Dump a number of bytes from a location
;	db 24			;Bytes to dump - only do 24 bytes on a TI
;	dw ProgramOrg		;Location to dump


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





Monitor_MemDump:

	ex (sp),hl				;Get the address of the calling function by swapping with HL
	push af					
	push hl
	push bc
		ld c,(hl)			;Read in the byte after the calling function - this is the bytes to dump
		inc hl

		ld a,(hl)			;Load in next two bytes  - this is the location to dump
		inc hl
		ld h,(hl)
		ld l,a
		Call Monitor_MemDumpDirect	;Call the actual display function

ifdef Monitor_Pause
	call WaitChar				;Do a pause
endif

	pop bc					;Restore our registers
	pop hl
	pop af

	inc hl					;Skip over the 3 parameter bytes
	inc hl
	inc hl

	ex (sp),hl				;Swap HL and whatever is on the stack and return
ret


Monitor_MemDumpDirect:

		ld a,h
		call ShowHex			;Show the address as a label
		ld a,l
		call ShowHex
		ld a,':'
		call PrintChar
		call NewLine
Monitor_MemDumpAgain:
		ld a,c

		;We need to check if there is a full line of data left, and show 
		;less bytes if there is not.

	ifdef ScreenWidth16
		cp 4				;We show 4 bytes wide on the TI
		jr c,Monitor_MemDump_lessthan8
		ld a,4
	else
		cp 8				;And 8 on everything else!
		jr c,Monitor_MemDump_lessthan8
		ld a,8
	endif
	
				;Show data as HEX
Monitor_MemDump_lessthan8:
		ld b,a
		ld a,c
		sub b
		ld c,a
	push bc
	push hl
	Monitor_MemDump_HexAgain:

		ld a,(hl)			;Read in a byte
		call ShowHex			;Show it as hex		

		ld a,' '
		call PrintChar			;Print a space

		inc hl
		djnz,Monitor_MemDump_HexAgain
	pop hl
	pop bc
				;Show data as Letters
Monitor_MemDump_CharAgain:
		ld a,(hl)

	if BuildZXSv+BuildSAMv
		cp 128 				;Speccy & SamCoupe can't show characters>128
		jr nc,Monitor_MemDump_CharBad
	endif
		cp 32
		jr nc,Monitor_MemDump_CharOK

Monitor_MemDump_CharBad:
		ld a,'.'			;Show a . for unshowable characters

Monitor_MemDump_CharOK:
		call PrintChar
		inc hl
		djnz,Monitor_MemDump_CharAgain
;	ifdef ScreenWidth40
		call NewLine			;40 character screens need a newline, others do not!
;	endif
		ld a,c
		or a
		jr nz,Monitor_MemDumpAgain
ret

ShowHex:	
	push af
		and %11110000
		rrca
		rrca
		rrca
		rrca
		call PrintHexChar
	pop af
	and %00001111
PrintHexChar:
	or a	;Clear Carry Clag
	daa
	add a,&F0
	adc a,&40
	call PrintChar
ret

