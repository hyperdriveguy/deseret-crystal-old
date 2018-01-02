const_value set 2
	const BATTLETOWEROUTSIDE_STANDING_YOUNGSTER
	const BATTLETOWEROUTSIDE_BUENA
	const BATTLETOWEROUTSIDE_SAILOR
	const BATTLETOWEROUTSIDE_LASS

BattleTowerOutside_MapScriptHeader:
.SceneScripts:
	db 0

.MapCallbacks:
	db 2
	dbw MAPCALLBACK_TILES, .Callback1
	dbw MAPCALLBACK_OBJECTS, .Callback2

.Callback1:
	return

.Callback2:
	clearevent EVENT_BATTLE_TOWER_OUTSIDE_SAILOR
	return

BattleTowerOutsideYoungsterScript:
	jumptextfaceplayer BattleTowerOutsideYoungsterText

BattleTowerOutsideBuenaScript:
	jumptextfaceplayer BattleTowerOutsideBuenaText

BattleTowerOutsideSailorScript:
	jumptextfaceplayer BattleTowerOutsideSailorText

MapBattleTowerOutsideSignpost0Script:
	jumptext BattleTowerOutsideText_UltimateChallenge

BattleTowerOutsideYoungsterText:
	text "Wow, the BATTLE"
	line "TOWER is huge!"

	para "There must be many"
	line "kinds of #MON"
	cont "in there!"
	done

BattleTowerOutsideBuenaText:
	text "You can use only"
	line "three #MON."

	para "It's so hard to"
	line "decide which three"

	para "should go into"
	line "battle…"
	done

BattleTowerOutsideSailorText:
	text "Hehehe, I snuck"
	line "out from work."

	para "I can't bail out"
	line "until I've won!"

	para "I have to win it"
	line "all. That I must!"
	done

BattleTowerOutsideText_UltimateChallenge:
	text "BATTLE TOWER"

	para "Take the Ultimate"
	line "Trainer Challenge!"
	done

BattleTowerOutside_MapEventHeader:
	; filler
	db 0, 0

.Warps:
	db 4
	warp_def 8, 21, 3, ROUTE_40_BATTLE_TOWER_GATE
	warp_def 9, 21, 4, ROUTE_40_BATTLE_TOWER_GATE
	warp_def 8, 9, 1, BATTLE_TOWER_1F
	warp_def 9, 9, 2, BATTLE_TOWER_1F

.CoordEvents:
	db 0

.BGEvents:
	db 1
	bg_event 10, 10, BGEVENT_READ, MapBattleTowerOutsideSignpost0Script

.ObjectEvents:
	db 4
	object_event 6, 12, SPRITE_STANDING_YOUNGSTER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleTowerOutsideYoungsterScript, -1
	object_event 13, 11, SPRITE_BUENA, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, BattleTowerOutsideBuenaScript, -1
	object_event 12, 18, SPRITE_SAILOR, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, BattleTowerOutsideSailorScript, EVENT_BATTLE_TOWER_OUTSIDE_SAILOR
	object_event 12, 24, SPRITE_LASS, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
