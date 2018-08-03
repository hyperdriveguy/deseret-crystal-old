SECTION "mobile_40", ROMX

_LinkBattleSendReceiveAction:
	call .StageForSend
	ld [wd431], a
	farcall PlaceWaitingText
	jp .LinkBattle_SendReceiveAction

.StageForSend:
	ld a, [wBattlePlayerAction]
	and a ; BATTLEPLAYERACTION_USEMOVE?
	jr nz, .switch
	ld a, [wCurPlayerMove]
	ld b, BATTLEACTION_E
	cp STRUGGLE
	jr z, .struggle
	ld b, BATTLEACTION_D
	cp $ff
	jr z, .struggle
	ld a, [wCurMoveNum]
	jr .use_move

.switch
	ld a, [wCurPartyMon]
	add BATTLEACTION_SWITCH1
	jr .use_move

.struggle
	ld a, b

.use_move
	and $0f
	ret

.LinkBattle_SendReceiveAction:
	ld a, [wd431]
	ld [wPlayerLinkAction], a
	ld a, $ff
	ld [wOtherPlayerLinkAction], a
.waiting
	call LinkTransfer
	call DelayFrame
	ld a, [wOtherPlayerLinkAction]
	inc a
	jr z, .waiting

	ld b, 10
.receive
	call DelayFrame
	call LinkTransfer
	dec b
	jr nz, .receive

	ld b, 10
.acknowledge
	call DelayFrame
	call LinkDataReceived
	dec b
	jr nz, .acknowledge

	ld a, [wOtherPlayerLinkAction]
	ld [wBattleAction], a
	ret
