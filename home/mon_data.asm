GetBaseData:: ; 3856
	push bc
	push de
	push hl
	ld a, [hROMBank]
	push af
	ld a, BANK(BaseData)
	rst Bankswitch

; Egg doesn't have BaseData
	ld a, [wCurSpecies]
	cp EGG
	jr z, .egg

; Get BaseData
	dec a
	ld bc, BASE_DATA_SIZE
	ld hl, BaseData
	call AddNTimes
	ld de, wCurBaseData
	ld bc, BASE_DATA_SIZE
	call CopyBytes
	jr .end

.egg
; Sprite dimensions
	ld b, $55 ; 5x5
	ld hl, wBasePicSize
	ld [hl], b

.end
; Replace Pokedex # with species
	ld a, [wCurSpecies]
	ld [wBaseDexNo], a

	pop af
	rst Bankswitch
	pop hl
	pop de
	pop bc
	ret
; 389c

GetCurNick:: ; 389c
	ld a, [wCurPartyMon]
	ld hl, wPartyMonNicknames

GetNick:: ; 38a2
; Get nickname a from list hl.

	push hl
	push bc

	call SkipNames
	ld de, wStringBuffer1

	push de
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	pop de

	callfar CorrectNickErrors

	pop bc
	pop hl
	ret
; 38bb
