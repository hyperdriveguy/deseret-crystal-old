const_value set 2
	const ROUTE40BATTLETOWERGATE_ROCKER
	const ROUTE40BATTLETOWERGATE_TWIN

Route40BattleTowerGate_MapScriptHeader:
.SceneScripts:
	db 0

.MapCallbacks:
	db 1
	dbw MAPCALLBACK_OBJECTS, .ShowSailor

.ShowSailor:
	clearevent EVENT_BATTLE_TOWER_OUTSIDE_SAILOR
	return

Route40BattleTowerGateRockerScript:
	jumptextfaceplayer Route40BattleTowerGateRockerText

Route40BattleTowerGateTwinScript:
	jumptextfaceplayer Route40BattleTowerGateTwinText

Route40BattleTowerGateRockerText:
	text "Are you going to"
	line "the BATTLE TOWER?"

	para "This is a secret,"
	line "but if you win a"

	para "whole lot, you can"
	line "win special gifts."
	done

Route40BattleTowerGateTwinText:
	text "The levels of the"
	line "#MON I want to"

	para "use are all"
	line "different."

	para "I have to go train"
	line "them now!"
	done

Route40BattleTowerGate_MapEventHeader:
	; filler
	db 0, 0

.Warps:
	db 4
	warp_def 4, 7, 1, ROUTE_40
	warp_def 5, 7, 1, ROUTE_40
	warp_def 4, 0, 1, BATTLE_TOWER_OUTSIDE
	warp_def 5, 0, 2, BATTLE_TOWER_OUTSIDE

.CoordEvents:
	db 0

.BGEvents:
	db 0

.ObjectEvents:
	db 2
	object_event 3, 3, SPRITE_ROCKER, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route40BattleTowerGateRockerScript, EVENT_BATTLE_TOWER_OUTSIDE_SAILOR
	object_event 7, 5, SPRITE_TWIN, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route40BattleTowerGateTwinScript, -1
