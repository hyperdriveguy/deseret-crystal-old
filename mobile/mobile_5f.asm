Special_Menu_ChallengeExplanationCancel: ; 17d224
	ld a, $4
	ld [ScriptVar], a
	ld hl, MenuDataHeader_ChallengeExplanationCancel ; English Menu

	call LoadMenuDataHeader
	call Function17d246
	call CloseWindow
	ret
; 17d246

Function17d246: ; 17d246
	call VerticalMenu
	jr c, .Exit
	ld a, [ScriptVar]
	cp $5
	jr nz, .UsewMenuCursorY
	ld a, [wMenuCursorY]
	cp $3
	ret z
	jr c, .UsewMenuCursorY
	dec a
	jr .LoadToScriptVar

.UsewMenuCursorY:
	ld a, [wMenuCursorY]

.LoadToScriptVar:
	ld [ScriptVar], a
	ret

.Exit:
	ld a, $4
	ld [ScriptVar], a
	ret
; 17d26a

MenuDataHeader_ChallengeExplanationCancel: ; 17d28f
	db $40 ; flags
	db  0,  0 ; start coords
	db  7, 14 ; end coords
	dw MenuData2_ChallengeExplanationCancel
	db 1 ; default option

MenuData2_ChallengeExplanationCancel: ; 17d297
	db $a0 ; flags
	db 3
	db "Challenge@"
	db "Explanation@"
	db "Cancel@"
; 17d2b6
