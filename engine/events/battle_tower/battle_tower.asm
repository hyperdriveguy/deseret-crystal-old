BattleTowerRoomMenu:
; special
	call InitBattleTowerChallengeRAM
	farcall _BattleTowerRoomMenu
	ret

BattleTowerBattle:
	xor a ; FALSE
	ld [wBattleTowerBattleEnded], a
	call _BattleTowerBattle
	ret

InitBattleTowerChallengeRAM:
	xor a
	ld [wBattleTowerBattleEnded], a
	ld [wNrOfBeatenBattleTowerTrainers], a
	ld [wcf65], a
	ld [wcf66], a
	ret

_BattleTowerBattle:
.loop
	call .do_dw
	call DelayFrame
	ld a, [wBattleTowerBattleEnded]
	cp TRUE
	jr nz, .loop
	ret

.do_dw
	ld a, [wBattleTowerBattleEnded]
	ld e, a
	ld d, 0
	ld hl, .dw
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.dw
	dw RunBattleTowerTrainer
	dw SkipBattleTowerTrainer

RunBattleTowerTrainer:
	ld a, [wOptions]
	push af
	ld hl, wOptions
	set BATTLE_SHIFT, [hl] ; SET MODE

	ld a, [wInBattleTowerBattle]
	push af
	or 1
	ld [wInBattleTowerBattle], a

	xor a
	ld [wLinkMode], a
	farcall HealParty
	call ReadBTTrainerParty

	predef StartBattle

	farcall LoadPokemonData
	farcall HealParty
	ld a, [wBattleResult]
	ld [wScriptVar], a
	and a ; WIN?
	jr nz, .lost
	ld a, BANK(sNrOfBeatenBattleTowerTrainers)
	call GetSRAMBank
	ld a, [sNrOfBeatenBattleTowerTrainers]
	ld [wNrOfBeatenBattleTowerTrainers], a
	call CloseSRAM
	ld hl, wStringBuffer3
	ld a, [wNrOfBeatenBattleTowerTrainers]
	add "1"
	ld [hli], a
	ld a, "@"
	ld [hl], a

.lost
	pop af
	ld [wInBattleTowerBattle], a
	pop af
	ld [wOptions], a
	ld a, TRUE
	ld [wBattleTowerBattleEnded], a
	ret

ReadBTTrainerParty:
; Initialise the BattleTower-Trainer and his mon
	call CopyBTTrainer_FromBT_OT_TowBT_OTTemp

	ld hl, wBT_OTTempName
	ld de, wOTPlayerName
	ld bc, NAME_LENGTH - 1
	call CopyBytes
	ld a, "@"
	ld [de], a

	ld hl, wBT_OTTempTrainerClass
	ld a, [hli]
	ld [wOtherTrainerClass], a
	ld a, LOW(wOTPartyMonNicknames)
	ld [wBGMapBuffer], a
	ld a, HIGH(wOTPartyMonNicknames)
	ld [wBGMapBuffer + 1], a

	; Copy mon into Memory from the address in hl
	ld de, wOTPartyMon1Species
	ld bc, wOTPartyCount
	ld a, BATTLETOWER_PARTY_LENGTH
	ld [bc], a
	inc bc
.otpartymon_loop
	push af
	ld a, [hl]
	ld [bc], a
	inc bc
	push bc
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes
	push de
	ld a, [wBGMapBuffer]
	ld e, a
	ld a, [wBGMapBuffer + 1]
	ld d, a
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld a, e
	ld [wBGMapBuffer], a
	ld a, d
	ld [wBGMapBuffer + 1], a
	pop de
	pop bc
	pop af
	dec a
	and a
	jr nz, .otpartymon_loop
	ld a, -1
	ld [bc], a
	ret

CopyBTTrainer_FromBT_OT_TowBT_OTTemp:
; copy the BattleTower-Trainer data that lies at 'wBT_OTTrainer' to 'wBT_OTTemp'
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBT_OTTrainer)
	ldh [rSVBK], a

	ld hl, wBT_OTTrainer
	ld de, wBT_OTTemp
	ld bc, BATTLE_TOWER_STRUCT_LENGTH
	call CopyBytes

	pop af
	ldh [rSVBK], a

	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, BATTLETOWER_CHALLENGE_IN_PROGESS
	ld [sBattleTowerChallengeState], a
	ld hl, sNrOfBeatenBattleTowerTrainers
	inc [hl]
	call CloseSRAM
SkipBattleTowerTrainer:
	ret

BattleTowerAction:
	ld a, [wScriptVar]
	ld e, a
	ld d, 0
	ld hl, .dw
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.dw
	dw BattleTowerAction_CheckExplanationRead
	dw BattleTowerAction_SetExplanationRead
	dw BattleTowerAction_GetChallengeState
	dw BattleTowerAction_SetByteToQuickSaveChallenge
	dw BattleTowerAction_SetByteToCancelChallenge
	dw SaveBattleTowerLevelGroup
	dw LoadBattleTowerLevelGroup
	dw BattleTower_CheckSaveFileExistsAndIsYours
	dw Function1708b1
	dw CheckMobileEventIndex
	dw ResetBattleTowerTrainersSRAM
	dw BattleTower_GiveReward
	dw Function17071b
	dw Function170729
	dw BattleTower_RandomlyChooseReward
	dw BattleTower_SaveOptions

; Reset the save memory for BattleTower-Trainers (Counter and all 7 TrainerBytes)
ResetBattleTowerTrainersSRAM:
	ld a, BANK(sBTTrainers)
	call GetSRAMBank

	ld a, $ff
	ld hl, sBTTrainers
	ld bc, BATTLETOWER_STREAK_LENGTH
	call ByteFill

	xor a
	ld [sNrOfBeatenBattleTowerTrainers], a

	call CloseSRAM

	ret

BattleTower_GiveReward:
	ld a, BANK(sBattleTowerReward)
	call GetSRAMBank

	ld a, [sBattleTowerReward]
	call CloseSRAM
	ld [wScriptVar], a
	ld hl, wNumItems
	ld a, [hli]
	cp MAX_ITEMS
	ret c
	ld b, MAX_ITEMS
	ld a, [wScriptVar]
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr nz, .next
	ld a, [hl]
	cp 95
	ret c
.next
	inc hl
	dec b
	jr nz, .loop
	ld a, POTION
	ld [wScriptVar], a
	ret

Function17071b:
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, BATTLETOWER_WON_CHALLENGE
	ld [sBattleTowerChallengeState], a
	call CloseSRAM
	ret

Function170729:
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, BATTLETOWER_RECEIVED_REWARD
	ld [sBattleTowerChallengeState], a
	call CloseSRAM
	ret

BattleTower_SaveOptions:
	farcall SaveOptions
	ret

BattleTower_RandomlyChooseReward:
; Generate a random stat boosting item.
.loop
	call Random
	ldh a, [hRandomAdd]
	and $7
	cp 6
	jr c, .okay
	sub 6
.okay
	add HP_UP
	cp LUCKY_PUNCH
	jr z, .loop
	push af
	ld a, BANK(sBattleTowerReward)
	call GetSRAMBank
	pop af
	ld [sBattleTowerReward], a
	call CloseSRAM
	ret

BattleTowerAction_CheckExplanationRead:
	call BattleTower_CheckSaveFileExistsAndIsYours
	ld a, [wScriptVar]
	and a
	ret z

	ld a, BANK(sBattleTowerSaveFileFlags)
	call GetSRAMBank
	ld a, [sBattleTowerSaveFileFlags]
	and 2
	ld [wScriptVar], a
	call CloseSRAM
	ret

BattleTowerAction_GetChallengeState:
	ld hl, sBattleTowerChallengeState
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, [hl]
	ld [wScriptVar], a
	call CloseSRAM
	ret

BattleTowerAction_SetExplanationRead:
	ld a, BANK(sBattleTowerSaveFileFlags)
	call GetSRAMBank
	ld a, [sBattleTowerSaveFileFlags]
	or 2
	ld [sBattleTowerSaveFileFlags], a
	call CloseSRAM
	ret

BattleTowerAction_SetByteToQuickSaveChallenge:
	ld c, BATTLETOWER_SAVED_AND_LEFT
	jr asm_17079f

BattleTowerAction_SetByteToCancelChallenge:
	ld c, BATTLETOWER_NO_CHALLENGE
asm_17079f:
	ld a, BANK(sBattleTowerChallengeState)
	call GetSRAMBank
	ld a, c
	ld [sBattleTowerChallengeState], a
	call CloseSRAM
	ret

SaveBattleTowerLevelGroup:
	ld a, BANK(sBTChoiceOfLevelGroup)
	call GetSRAMBank
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBTChoiceOfLvlGroup)
	ldh [rSVBK], a
	ld a, [wBTChoiceOfLvlGroup]
	ld [sBTChoiceOfLevelGroup], a
	pop af
	ldh [rSVBK], a
	call CloseSRAM
	ret

LoadBattleTowerLevelGroup: ; Load level group choice
	ld a, BANK(sBTChoiceOfLevelGroup)
	call GetSRAMBank
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBTChoiceOfLvlGroup)
	ldh [rSVBK], a
	ld a, [sBTChoiceOfLevelGroup]
	ld [wBTChoiceOfLvlGroup], a
	pop af
	ldh [rSVBK], a
	call CloseSRAM
	ret

BattleTower_CheckSaveFileExistsAndIsYours:
	ld a, [wSaveFileExists]
	and a
	jr z, .nope
	farcall CompareLoadedAndSavedPlayerID
	jr z, .yes
	xor a ; FALSE
	jr .nope

.yes
	ld a, TRUE

.nope
	ld [wScriptVar], a
	ret

Function1708b1: ; BattleTowerAction $0a
	xor a
	ld [wMusicFade], a
	call MaxVolume
	ret

CheckMobileEventIndex: ; BattleTowerAction $0b something to do with GS Ball
	ld a, BANK(sMobileEventIndex)
	call GetSRAMBank
	ld a, [sMobileEventIndex]
	ld [wScriptVar], a
	call CloseSRAM
	ret

Function170923:
	ld a, BANK(s5_aa48) ; aka BANK(s5_aa47) and BANK(s5_aa5d)
	call GetSRAMBank
	xor a
	ld [s5_aa48], a
	ld [s5_aa47], a
	ld hl, s5_aa5d
	ld bc, MOBILE_LOGIN_PASSWORD_LENGTH
	call ByteFill
	call CloseSRAM
	ret

LoadOpponentTrainerAndPokemonWithOTSprite:
	farcall Function_LoadOpponentTrainerAndPokemons
	ldh a, [rSVBK]
	push af
	ld a, BANK(wBT_OTTrainerClass)
	ldh [rSVBK], a
	ld hl, wBT_OTTrainerClass
	ld a, [hl]
	dec a
	ld c, a
	ld b, 0
	pop af
	ldh [rSVBK], a
	ld hl, BTTrainerClassSprites
	add hl, bc
	ld a, [hl]
	ld [wBTTempOTSprite], a

; Load sprite of the opponent trainer
; because s/he is chosen randomly and appears out of nowhere
	ld a, [wScriptVar]
	dec a
	sla a
	ld e, a
	sla a
	sla a
	sla a
	ld c, a
	ld b, 0
	ld d, 0
	ld hl, wMapObjects
	add hl, bc
	inc hl
	ld a, [wBTTempOTSprite]
	ld [hl], a
	ld hl, wUsedSprites
	add hl, de
	ld [hli], a
	ldh [hUsedSpriteIndex], a
	ld a, [hl]
	ldh [hUsedSpriteTile], a
	farcall GetUsedSprite
	ret

INCLUDE "data/trainers/sprites.asm"

CheckForBattleTowerRules:
	farcall _CheckForBattleTowerRules
	jr c, .ready
	xor a ; FALSE
	jr .end

.ready
	ld a, TRUE

.end
	ld [wScriptVar], a
	ret
