GetPartyParamLocation:: ; 3917
; Get the location of parameter a from wCurPartyMon in hl
	push bc
	ld hl, wPartyMons
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wCurPartyMon]
	call GetPartyLocation
	pop bc
	ret
; 3927

GetPartyLocation:: ; 3927
; Add the length of a PartyMon struct to hl a times.
	ld bc, PARTYMON_STRUCT_LENGTH
	jp AddNTimes
; 392d
