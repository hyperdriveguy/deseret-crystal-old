SECTION "Mobile 46", ROMX

_BattleTowerRoomMenu:
	xor a
	ld [wc300], a
	ld [$c31a], a
	ld a, [rSVBK]
	push af
	ld a, $3
	ld [rSVBK], a
.loop
	call JoyTextDelay
	ld a, [wcf66]
	call BattleTowerRoomMenu_Jumptable
	call BattleTowerRoomMenu_WriteMessage
	call DelayFrame
	ld a, [wcf66]
	cp $3
	jr nz, .loop
	pop af
	ld [rSVBK], a
	ld a, [wc300]
	ld [wScriptVar], a
	jp ReturnToMapFromSubmenu

BattleTowerRoomMenu_Jumptable:
	jumptable .Jumptable, wcf66

.Jumptable:
	dw BattleTowerRoomMenu_PickLevelMessage
	dw BattleTowerRoomMenu_PlacePickLevelMenu
	dw BattleTowerRoomMenu_UpdatePickLevelMenu
	dw NULL
	dw BattleTowerRoomMenu_PartyMonTopsThisLevelMessage
	dw BattleTowerRoomMenu_WaitForMessage
	dw BattleTowerRoomMenu_DelayRestartMenu
	dw BattleTowerRoomMenu_QuitMessage
	dw BattleTowerRoomMenu_PlaceYesNoMenu
	dw BattleTowerRoomMenu_UpdateYesNoMenu
	dw BattleTowerRoomMenu_UberRestrictionMessage
	dw BattleTowerRoomMenu_WaitForMessage
	dw BattleTowerRoomMenu_DelayRestartMenu

BattleTowerRoomMenu_PickLevelMessage:
	ld hl, Text_WhatLevelDoYouWantToChallenge
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_PlacePickLevelMenu:
	ld a, [$c31a]
	and a
	ret nz
	ld hl, MenuHeader_119cf7
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	call ApplyTilemap
	hlcoord 16, 8, wAttrMap
	ld a, $40
	or [hl]
	ld [hl], a
	call WaitBGMap2
	ld a, $1
	ld [wcd4f], a
	ld a, $1
	ld [rSVBK], a
	ld a, [wStatusFlags]
	bit STATUSFLAGS_HALL_OF_FAME_F, a
	jr nz, .asm_11896b
	ld hl, Strings_Ll0ToL40 ; Address to list of strings with the choosable levels
	ld a, 5                 ; 4 levels to choose from, including 'Cancel'-option
	jr .asm_118970

.asm_11896b
	ld hl, Strings_L10ToL100 ; Address to list of strings with the choosable levels
	ld a, 11                 ; 10 levels to choose from, including 'Cancel'-option

.asm_118970
	ld [wcd4a], a
	ld a, l
	ld [wcd4b], a
	ld a, h
	ld [wcd4c], a
	ld a, $3
	ld [rSVBK], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_UpdatePickLevelMenu:
	hlcoord 13, 8
	ld de, String_119d07
	call PlaceString
	hlcoord 13, 10
	ld de, String_119d07
	call PlaceString
	ld a, [wcd4b]
	ld l, a
	ld a, [wcd4c]
	ld h, a
	ld d, $0
	ld a, [wcd4f]
	dec a
	rlca
	rlca
	rlca
	ld e, a
	add hl, de
	ld a, l
	ld e, a
	ld a, h
	ld d, a
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld bc, wStringBuffer3
.asm_1189b5
	ld a, [hli]
	cp $50
	jr z, .asm_1189c4
	cp $7f
	jr z, .asm_1189c2
	ld [bc], a
	inc bc
	jr .asm_1189b5

.asm_1189c2
	ld a, $50

.asm_1189c4
	ld [bc], a
	pop af
	ld [rSVBK], a
	hlcoord 13, 9
	call PlaceString
	ld hl, hJoyPressed
	ld a, [hl]
	and B_BUTTON
	jr nz, .b_button
	ld a, [hl]
	and A_BUTTON
	jr nz, .a_button
	ld a, [hl]
	and D_DOWN
	jr nz, .d_down
	ld a, [hl]
	and D_UP
	jr nz, .d_up
.asm_1189e5
	ret

.d_down
	ld hl, wcd4f
	dec [hl]
	jr nz, .asm_1189e5
	ld a, [wcd4a]
	ld [hl], a
	jr .asm_1189e5

.d_up
	ld a, [wcd4a]
	ld hl, wcd4f
	inc [hl]
	cp [hl]
	jr nc, .asm_1189e5
	ld a, $1
	ld [hl], a
	jr .asm_1189e5

.a_button
	call PlayClickSFX
	ld a, [wcd4f]
	ld hl, wcd4a
	cp [hl]
	jr z, .asm_118a3c
	dec a
	and $fe
	srl a
	ld [wcf65], a
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	call CloseWindow
	pop af
	ld [rSVBK], a
	call BattleTower_LevelCheck
	ret c
	call BattleTower_UbersCheck
	ret c

	ld a, [wcd4f]
	ld [w3_d800], a
	jp BattleTowerRoomMenu_IncrementJumptable

.b_button
	call PlayClickSFX

.asm_118a3c
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	call CloseWindow
	pop af
	ld [rSVBK], a
	ld a, $7
	ld [wcf66], a
	ld a, $0
	ld [wMobileInactivityTimerFrames], a
	ret


SECTION "Mobile 46 ASCII", ROMX
; A hack to use ascii above.

BattleTowerRoomMenu_UberRestrictionMessage:
	ld hl, Text_UberRestriction
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable
	jr BattleTowerRoomMenu_WaitForMessage

BattleTowerRoomMenu_PartyMonTopsThisLevelMessage:
	ld hl, Text_PartyMonTopsThisLevel
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_WaitForMessage:
	ld a, [$c31a]
	and a
	ret nz
	ld a, $80
	ld [wcd50], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_DelayRestartMenu:
    ; Loops while (--[wcd50] != 0),
    ;   to create some sort of "delay" after the message is written on the screen,
    ;   before starting the menu again.
	ld hl, wcd50
	dec [hl]
	ret nz
	ld a, $0
	ld [wcf66], a
	ret

BattleTowerRoomMenu_QuitMessage:
	ld hl, Text_CancelBattleRoomChallenge
	call BattleTowerRoomMenu_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_PlaceYesNoMenu:
	ld a, [$c31a]
	and a
	ret nz
	call BattleTowerRoomMenu_IncrementJumptable
	jp BattleTowerRoomMenu2_PlaceYesNoMenu

BattleTowerRoomMenu_UpdateYesNoMenu:
	call BattleTowerRoomMenu2_UpdateYesNoMenu
	ret c
	ld a, [wMobileInactivityTimerFrames]
	ld [wcf66], a
	ret

MenuHeader_119cf7:
	db MENU_BACKUP_TILES ; flags
	menu_coords 12, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

String_119d07:
	db "   ▼@"

Strings_L10ToL100:
	db " L:10 @@"
	db " L:20 @@"
	db " L:30 @@"
	db " L:40 @@"
	db " L:50 @@"
	db " L:60 @@"
	db " L:70 @@"
	db " L:80 @@"
	db " L:90 @@"
	db " L:100@@"
	db "CANCEL@@"

Strings_Ll0ToL40:
	db " L:10 @@"
	db " L:20 @@"
	db " L:30 @@"
	db " L:40 @@"
	db "CANCEL@@"

BattleTower_LevelCheck:
	ld a, [rSVBK]
	push af
	ld a, $1
	ld [rSVBK], a
	ld a, [wcd4f]
	ld c, 10
	call SimpleMultiply
	ld hl, wcd50
	ld [hl], a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartyMon1Level
	ld a, [wPartyCount]
.party_loop
	push af
	ld a, [de]
	push hl
	push de
	pop hl
	add hl, bc
	push hl
	pop de
	pop hl
	cp [hl]
	jr z, .equal
	jr nc, .exceeds
.equal
	pop af
	dec a
	jr nz, .party_loop
	pop af
	ld [rSVBK], a
	and a
	ret

.exceeds
	pop af
	ld a, $4
	ld [wcf66], a
	pop af
	ld [rSVBK], a
	scf
	ret

BattleTower_UbersCheck:
	ld a, [rSVBK]
	push af
	ld a, [wcd4f]
	cp 70 / 10
	jr nc, .level_70_or_more
	ld a, $1
	ld [rSVBK], a
	ld hl, wPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartySpecies
	ld a, [wPartyCount]
.loop
	push af
	ld a, [de]
	cp MEWTWO
	jr z, .uber
	cp MEW
	jr z, .uber
	cp LUGIA
	jr c, .next
	cp NUM_POKEMON + 1
	jr nc, .next
.uber
	ld a, [hl]
	cp 70
	jr c, .uber_under_70
.next
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .loop
.level_70_or_more
	pop af
	ld [rSVBK], a
	and a
	ret

.uber_under_70
	pop af
	ld a, [de]
	ld [wNamedObjectIndexBuffer], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wcd49
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld a, $a
	ld [wcf66], a
	pop af
	ld [rSVBK], a
	scf
	ret

BattleTowerRoomMenu_IncrementJumptable:
	ld hl, wcf66
	inc [hl]
	ret

BattleTowerRoomMenu2_PlaceYesNoMenu:
	ld hl, MenuHeader_11a2de
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	call ApplyTilemap
	hlcoord 16, 8
	ld de, String_11a2cf
	call PlaceString
	hlcoord 16, 10
	ld de, String_11a2d3
	call PlaceString
	hlcoord 15, 8
	ld a, $ed
	ld [hl], a
	xor a
	ld [wMobileInactivityTimerMinutes], a
	ret

BattleTowerRoomMenu2_UpdateYesNoMenu:
	ld hl, hJoyPressed
	ld a, [hl]
	and A_BUTTON
	jr nz, .a_button
	ld a, [hl]
	and B_BUTTON
	jr nz, .b_button
	ld a, [hl]
	and D_UP
	jr nz, .d_up
	ld a, [hl]
	and D_DOWN
	jr nz, .d_down
.asm_11a24c
	call Function11a9f0
	scf
	ret

.d_up
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr z, .asm_11a24c
	xor a
	ld [wMobileInactivityTimerMinutes], a
	hlcoord 15, 8
	ld a, $ed
	ld [hl], a
	hlcoord 15, 10
	ld a, $7f
	ld [hl], a
	jr .asm_11a24c

.d_down
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .asm_11a24c
	inc a
	ld [wMobileInactivityTimerMinutes], a
	hlcoord 15, 8
	ld a, $7f
	ld [hl], a
	hlcoord 15, 10
	ld a, $ed
	ld [hl], a
	jr .asm_11a24c

.a_button
	call PlayClickSFX
	ld a, [wMobileInactivityTimerMinutes]
	and a
	jr nz, .exit_no_carry
	call ExitMenu
	farcall ReloadMapPart
	ld a, [wMobileInactivityTimerFrames]
	cp $0
	jr z, .asm_11a2b4
	ld a, [wcd47]
	jr .exit_carry

.asm_11a2b4
	ld a, $3

.exit_carry
	ld [wcf66], a
	ld a, $a
	ld [wc300], a
	scf
	ret

.b_button
	call PlayClickSFX

.exit_no_carry
	call ExitMenu
	farcall ReloadMapPart
	and a
	ret

String_11a2cf:
	db "YES@"

String_11a2d3:
	db "NO@"

MenuHeader_11a2de:
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

BattleTowerRoomMenu_WriteMessage:
	jumptable .Jumptable, $c31a

.Jumptable:
	dw BattleTowerRoomMenu_WriteMessage_DoNothing
	dw Function11a90f
	dw Function11a971

Function11a90f:
	ld a, $1
	ld [rSVBK], a
	call SpeechTextBox
	ld a, $50
	ld hl, $c320
	ld bc, $008c
	call ByteFill
	ld a, [$c31b]
	ld l, a
	ld a, [$c31c]
	ld h, a
	ld de, $c320
.asm_11a92c
	ld a, [hli]
	cp $57
	jr z, .asm_11a94f
	cp $0
	jr z, .asm_11a92c
	cp $50
	jr z, .asm_11a92c
	cp $1
	jr z, .asm_11a941
	ld [de], a
	inc de
	jr .asm_11a92c

.asm_11a941
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.asm_11a945
	ld a, [bc]
	inc bc
	cp $50
	jr z, .asm_11a92c
	ld [de], a
	inc de
	jr .asm_11a945

.asm_11a94f
	xor a
	ld [$c31f], a
	ld a, LOW($c320)
	ld [$c31b], a
	ld a, HIGH($c320)
	ld [$c31c], a
	hlcoord 1, 14
	ld a, l
	ld [$c31d], a
	ld a, h
	ld [$c31e], a
	ld hl, $c31a
	inc [hl]
	ld a, $3
	ld [rSVBK], a

BattleTowerRoomMenu_WriteMessage_DoNothing:
	ret

Function11a971:
	ld hl, $c31f
	ld a, [hJoyDown]
	and a
	jr nz, .asm_11a97f
	ld a, [hl]
	and a
	jr z, .asm_11a97f
	dec [hl]
	ret

.asm_11a97f
	ld a, [wOptions]
	and $7
	ld [hl], a
	ld hl, wcd8d
	ld a, [$c31b]
	ld e, a
	ld a, [$c31c]
	ld d, a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, e
	ld [$c31b], a
	ld a, d
	ld [$c31c], a
	ld a, $50
	ld [hl], a
	ld a, [$c31d]
	ld l, a
	ld a, [$c31e]
	ld h, a
	ld de, wcd8d
	call PlaceString
	ld a, c
	ld [$c31d], a
	ld a, b
	ld [$c31e], a
	ld a, [wcd8d]
	cp $50
	jr nz, .asm_11a9bf
	xor a
	ld [$c31a], a

.asm_11a9bf
	ret

BattleTowerRoomMenu_SetMessage:
	ld a, l
	ld [$c31b], a
	ld a, h
	ld [$c31c], a
	ld a, $1
	ld [$c31a], a
	ret

Function11a9f0:
	ld a, $1
	and a
	ret

Text_PartyMonTopsThisLevel:
	text "A party #MON"
	line "tops this level."
	done

Text_UberRestriction:
	text_from_ram wcd49
	text " may go"
	line "only to BATTLE"

	para "ROOMS that are"
	line "Lv.70 or higher."
	done

Text_CancelBattleRoomChallenge:
	text "Cancel your BATTLE"
	line "ROOM challenge?"
	done

Text_WhatLevelDoYouWantToChallenge:
	text "What level do you"
	line "want to challenge?"
	done

AddMobileMonToParty:
	ld hl, wPartyCount
	ld a, [hl]
	ld e, a
	inc [hl]

	ld a, [wMobileMonSpeciesPointerBuffer]
	ld l, a
	ld a, [wMobileMonSpeciesPointerBuffer + 1]
	ld h, a
	inc hl
	ld bc, wPartySpecies
	ld d, e
.loop1
	inc bc
	dec d
	jr nz, .loop1
	ld a, e
	ld [wCurPartyMon], a
	ld a, [hl]
	ld [bc], a
	inc bc
	ld a, -1
	ld [bc], a

	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, e
	ld [wMobileMonSpeciesBuffer], a
.loop2
	add hl, bc
	dec a
	and a
	jr nz, .loop2
	ld e, l
	ld d, h
	ld a, [wMobileMonStructurePointerBuffer]
	ld l, a
	ld a, [wMobileMonStructurePointerBuffer + 1]
	ld h, a
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes

	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld a, [wMobileMonSpeciesBuffer]
.loop3
	add hl, bc
	dec a
	and a
	jr nz, .loop3
	ld e, l
	ld d, h
	ld a, [wMobileMonOTNamePointerBuffer]
	ld l, a
	ld a, [wMobileMonOTNamePointerBuffer + 1]
	ld h, a
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [de], a

	ld hl, wPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	ld a, [wMobileMonSpeciesBuffer]
.loop4
	add hl, bc
	dec a
	and a
	jr nz, .loop4
	ld e, l
	ld d, h
	ld a, [wMobileMonNicknamePointerBuffer]
	ld l, a
	ld a, [wMobileMonNicknamePointerBuffer + 1]
	ld h, a
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [de], a

	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	ld a, [wMobileMonSpeciesBuffer]
.loop5
	add hl, bc
	dec a
	and a
	jr nz, .loop5
	ld a, BANK(sPartyMail)
	call GetSRAMBank
	ld e, l
	ld d, h
	ld a, [wMobileMonMailPointerBuffer]
	ld l, a
	ld a, [wMobileMonMailPointerBuffer + 1]
	ld h, a
	ld bc, MAIL_STRUCT_LENGTH
	call CopyBytes

	call CloseSRAM
	ret
