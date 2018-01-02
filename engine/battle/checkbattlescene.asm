CheckBattleScene: ; 4ea44
; Return carry if battle scene is turned off.

	ld a, [Options]
	bit BATTLE_SCENE, a
	jr nz, .off

	and a
	ret

.off
	scf
	ret
