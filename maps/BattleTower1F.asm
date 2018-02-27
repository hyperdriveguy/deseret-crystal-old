	const_def 2 ; object constants
	const BATTLETOWER1F_RECEPTIONIST
	const BATTLETOWER1F_YOUNGSTER
	const BATTLETOWER1F_COOLTRAINER_F
	const BATTLETOWER1F_BUG_CATCHER
	const BATTLETOWER1F_GRANNY

BattleTower1F_MapScripts:
	db 2 ; scene scripts
	scene_script .Scene0 ; SCENE_DEFAULT
	scene_script .Scene1 ; SCENE_FINISHED

	db 0 ; callbacks

.Scene0:
	writebyte BATTLETOWERACTION_CHECKSAVEFILEISYOURS
	special BattleTowerAction
	iffalse .SkipEverything
	writebyte BATTLETOWERACTION_GET_CHALLENGE_STATE ; copybytetovar sBattleTowerChallengeState
	special BattleTowerAction
	ifequal $0, .SkipEverything
	ifequal $2, .priorityjump1
	ifequal $3, .SkipEverything
	ifequal $4, .SkipEverything
	opentext
	writetext Text_WeveBeenWaitingForYou
	waitbutton
	closetext
	priorityjump Script_ResumeBattleTowerChallenge
	end

.priorityjump1
	priorityjump BattleTower_LeftWithoutSaving
	writebyte BATTLETOWERACTION_CHALLENGECANCELED
	special BattleTowerAction
.SkipEverything:
	setscene SCENE_FINISHED
.Scene1:
	end

MapBattleTower1FSignpost0Script:
	opentext
	writetext Text_ReadBattleTowerRules
	yesorno
	iffalse .skip
	writetext Text_BattleTowerRules
	waitbutton
.skip:
	closetext
	end

ReceptionistScript_0x9e3e2:
	writebyte BATTLETOWERACTION_GET_CHALLENGE_STATE ; copybytetovar sBattleTowerChallengeState
	special BattleTowerAction
	ifequal $3, Script_BeatenAllTrainers2 ; maps/BattleTowerBattleRoom.asm
	opentext
	writetext Text_BattleTowerWelcomesYou
	buttonsound
	writebyte BATTLETOWERACTION_CHECK_EXPLANATION_READ ; if new save file: bit 1, [sBattleTowerSaveFileFlags]
	special BattleTowerAction
	ifnotequal $0, Script_Menu_ChallengeExplanationCancel
	jump Script_BattleTowerIntroductionYesNo

Script_Menu_ChallengeExplanationCancel: ; 0x9e3fc
	writetext Text_WantToGoIntoABattleRoom
	special Menu_ChallengeExplanationCancel
	ifequal 1, Script_ChooseChallenge
	ifequal 2, Script_BattleTowerExplanation
	jump Script_BattleTowerHopeToServeYouAgain

Script_ChooseChallenge: ; 0x9e40f
	writebyte BATTLETOWERACTION_RESETDATA ; ResetBattleTowerTrainerSRAM
	special BattleTowerAction
	special CheckForBattleTowerRules
	ifnotequal FALSE, Script_WaitButton
	writetext Text_SaveBeforeEnteringBattleRoom
	yesorno
	iffalse Script_Menu_ChallengeExplanationCancel
	setscene SCENE_DEFAULT
	special TryQuickSave
	iffalse Script_Menu_ChallengeExplanationCancel
	setscene SCENE_FINISHED
	writebyte BATTLETOWERACTION_SET_EXPLANATION_READ ; set 1, [sBattleTowerSaveFileFlags]
	special BattleTowerAction
	special BattleTowerRoomMenu
	ifequal $a, Script_Menu_ChallengeExplanationCancel
	writetext Text_RightThisWayToYourBattleRoom
	waitbutton
	closetext
	writebyte BATTLETOWERACTION_CHOOSEREWARD
	special BattleTowerAction
	jump Script_WalkToBattleTowerElevator

Script_ResumeBattleTowerChallenge:
	closetext
	writebyte BATTLETOWERACTION_LOADLEVELGROUP ; load choice of level group
	special BattleTowerAction
Script_WalkToBattleTowerElevator:
	musicfadeout MUSIC_NONE, 8
	setmapscene BATTLE_TOWER_BATTLE_ROOM, SCENE_DEFAULT
	setmapscene BATTLE_TOWER_ELEVATOR, SCENE_DEFAULT
	setmapscene BATTLE_TOWER_HALLWAY, SCENE_DEFAULT
	follow BATTLETOWER1F_RECEPTIONIST, PLAYER
	applymovement BATTLETOWER1F_RECEPTIONIST, MovementData_BattleTower1FWalkToElevator
	writebyte BATTLETOWERACTION_0A
	special BattleTowerAction
	warpsound
	disappear BATTLETOWER1F_RECEPTIONIST
	stopfollow
	applymovement PLAYER, MovementData_BattleTowerHallwayPlayerEntersBattleRoom
	warpcheck
	end

Script_GivePlayerHisPrize: ; 0x9e47a
	writebyte BATTLETOWERACTION_1C
	special BattleTowerAction
	writebyte BATTLETOWERACTION_GIVEREWARD
	special BattleTowerAction
	ifequal POTION, Script_YourPackIsStuffedFull
	itemtotext USE_SCRIPT_VAR, MEM_BUFFER_1
	giveitem ITEM_FROM_MEM, 5
	writetext Text_PlayerGotFive
	writebyte BATTLETOWERACTION_1D
	special BattleTowerAction
	closetext
	end

Script_YourPackIsStuffedFull: ; 0x9e498
	writetext Text_YourPackIsStuffedFull
	waitbutton
	closetext
	end

Script_BattleTowerIntroductionYesNo: ; 0x9e49e
	writetext Text_WouldYouLikeToHearAboutTheBattleTower
	yesorno
	iffalse Script_BattleTowerSkipExplanation
Script_BattleTowerExplanation: ; 0x9e4a5
	writetext Text_BattleTowerIntroduction_2
Script_BattleTowerSkipExplanation:
	writebyte BATTLETOWERACTION_SET_EXPLANATION_READ
	special BattleTowerAction
	jump Script_Menu_ChallengeExplanationCancel

Script_BattleTowerHopeToServeYouAgain:
	writetext Text_WeHopeToServeYouAgain
	waitbutton
	closetext
	end

Script_WaitButton: ; 0x9e4bb
	waitbutton
	closetext
	end

BattleTower_LeftWithoutSaving:
	opentext
	writetext Text_BattleTower_LeftWithoutSaving
	waitbutton
	jump Script_BattleTowerHopeToServeYouAgain

YoungsterScript_0x9e55d:
	faceplayer
	opentext
	writetext Text_BattleTowerYoungster
	waitbutton
	closetext
	turnobject BATTLETOWER1F_YOUNGSTER, RIGHT
	end

CooltrainerFScript_0x9e568:
	jumptextfaceplayer Text_BattleTowerCooltrainerF

BugCatcherScript_0x9e56b:
	jumptextfaceplayer Text_BattleTowerBugCatcher

GrannyScript_0x9e56e:
	jumptextfaceplayer Text_BattleTowerGranny

MovementData_BattleTower1FWalkToElevator:
	step UP
	step UP
	step UP
	step UP
	step UP
MovementData_BattleTowerHallwayPlayerEntersBattleRoom:
	step UP
	step_end

MovementData_BattleTowerElevatorExitElevator:
	step DOWN
	step_end

MovementData_BattleTowerHallwayWalkTo1020Room:
	step RIGHT
	step RIGHT
MovementData_BattleTowerHallwayWalkTo3040Room:
	step RIGHT
	step RIGHT
	step UP
	step RIGHT
	turn_head LEFT
	step_end

MovementData_BattleTowerHallwayWalkTo90100Room:
	step LEFT
	step LEFT
MovementData_BattleTowerHallwayWalkTo7080Room:
	step LEFT
	step LEFT
MovementData_BattleTowerHallwayWalkTo5060Room:
	step LEFT
	step LEFT
	step UP
	step LEFT
	turn_head RIGHT
	step_end

MovementData_BattleTowerBattleRoomPlayerWalksIn:
	step UP
	step UP
	step UP
	step UP
	turn_head RIGHT
	step_end

MovementData_BattleTowerBattleRoomOpponentWalksIn:
	slow_step DOWN
	slow_step DOWN
	slow_step DOWN
	turn_head LEFT
	step_end

MovementData_BattleTowerBattleRoomOpponentWalksOut:
	turn_head UP
	slow_step UP
	slow_step UP
	slow_step UP
	step_end

MovementData_BattleTowerBattleRoomReceptionistWalksToPlayer:
	slow_step RIGHT
	slow_step RIGHT
	slow_step UP
	slow_step UP
	step_end

MovementData_BattleTowerBattleRoomReceptionistWalksAway:
	slow_step DOWN
	slow_step DOWN
	slow_step LEFT
	slow_step LEFT
	turn_head RIGHT
	step_end

MovementData_BattleTowerBattleRoomPlayerTurnsToFaceReceptionist:
	turn_head DOWN
	step_end

MovementData_BattleTowerBattleRoomPlayerTurnsToFaceNextOpponent:
	turn_head RIGHT
	step_end

Text_BattleTowerWelcomesYou: ; 0x9e5ab
	text "BATTLE TOWER"
	line "welcomes you!"

	para "I could show you"
	line "to a BATTLE ROOM."
	done

Text_WantToGoIntoABattleRoom: ; 0x9e5ea
	text "Want to go into a"
	line "BATTLE ROOM?"
	done

Text_RightThisWayToYourBattleRoom: ; 0x9e60a
	text "Right this way to"
	line "your BATTLE ROOM."
	done

Text_BattleTowerIntroduction_2: ; 0x9e886
	text "BATTLE TOWER is a"
	line "facility made for"
	cont "#MON battles."

	para "Countless #MON"
	line "trainers gather"

	para "from all over to"
	line "hold battles in"

	para "specially designed"
	line "BATTLE ROOMS."

	para "There are many"
	line "BATTLE ROOMS in"
	cont "the BATTLE TOWER."

	para "Each ROOM holds"
	line "seven trainers."

	para "Beat them all, and"
	line "win a prize."

	para "To interrupt a"
	line "session, you must"

	para "SAVE. If not, you"
	line "won't be able to"

	para "resume your ROOM"
	line "challenge."

	para ""
	done

Text_ThanksForVisiting: ; 0x9ea49
	text "Thanks for"
	line "visiting!"
	done

Text_CongratulationsYouveBeatenAllTheTrainers: ; 0x9eaef
	text "Congratulations!"

	para "You've beaten all"
	line "the trainers!"

	para "For that, you get"
	line "this great prize!"

	para ""
	done

Text_PlayerGotFive: ; 0x9eb7e
	text "<PLAYER> got five"
	line "@"
	text_from_ram wStringBuffer4
	text "!@"
	sound_item
	text_waitbutton
	db "@"

Text_YourPackIsStuffedFull: ; 0x9eb94
	text "Oops, your PACK is"
	line "stuffed full."

	para "Please make room"
	line "and come back."
	done

Text_WeHopeToServeYouAgain: ; 0x9ec09
	text "We hope to serve"
	line "you again."
	done

Text_PleaseStepThisWay: ; 0x9ec26
	text "Please step this"
	line "way."
	done

Text_WouldYouLikeToHearAboutTheBattleTower: ; 0x9ec3d
	text "Would you like to"
	line "hear about the"
	cont "BATTLE TOWER?"
	done

Text_ReadBattleTowerRules: ; 0x9ed3c
	text "BATTLE TOWER rules"
	line "are written here."

	para "Read the rules?"
	done

Text_BattleTowerRules: ; 0x9ed72
	text "Three #MON may"
	line "enter battles."

	para "All three must be"
	line "different."

	para "The items they"
	line "hold must also be"
	cont "different."

	para "Certain #MON"
	line "may also have"

	para "level restrictions"
	line "placed on them."
	done

Text_BattleTower_LeftWithoutSaving:
	text "Excuse me!"
	line "You didn't SAVE"

	para "before exiting"
	line "the BATTLE ROOM."

	para "I'm awfully sorry,"
	line "but your challenge"

	para "will be declared"
	line "invalid."
	done

Text_YourMonWillBeHealedToFullHealth: ; 0x9ee92
	text "Your #MON will"
	line "be healed to full"
	cont "health."
	done

Text_NextUpOpponentNo: ; 0x9eebc
	text "Next up, opponent"
	line "no.@"
	text_from_ram wStringBuffer3
	text ". Ready?"
	done

Text_SaveBeforeEnteringBattleRoom: ; 0x9ef1f
	text "Before entering"
	line "the BATTLE ROOM,"

	para "your progress will"
	line "be saved."
	done

Text_SaveAndEndTheSession: ; 0x9ef5e
	text "SAVE and end the"
	line "session?"
	done

Text_CancelYourBattleRoomChallenge: ; 0x9efbf
	text "Cancel your BATTLE"
	line "ROOM challenge?"
	done

Text_WeveBeenWaitingForYou:
	text "We've been waiting"
	line "for you. This way"

	para "to a BATTLE ROOM,"
	line "please."
	done

Text_BattleTowerYoungster: ; 0x9f264
	text "Destroyed by the"
	line "first opponent in"

	para "no time at all…"
	line "I'm no good…"
	done

Text_BattleTowerCooltrainerF: ; 0x9f2a4
	text "There are lots of"
	line "BATTLE ROOMS, but"

	para "I'm going to win"
	line "them all!"
	done

Text_BattleTowerGranny: ; 0x9f2e3
	text "It's a grueling"
	line "task, not being"

	para "able to use items"
	line "in battle."

	para "Making your"
	line "#MON hold items"

	para "is the key to"
	line "winning battles."
	done

Text_BattleTowerBugCatcher: ; 0x9f35b
	text "I'm trying to see"
	line "how far I can go"

	para "using just bug"
	line "#MON."

	para "Don't let there be"
	line "any fire #MON…"
	done

BattleTower1F_MapEvents:
	db 0, 0 ; filler

	db 3 ; warp events
	warp_event  7,  9, BATTLE_TOWER_OUTSIDE, 3
	warp_event  8,  9, BATTLE_TOWER_OUTSIDE, 4
	warp_event  7,  0, BATTLE_TOWER_ELEVATOR, 1

	db 0 ; coord events

	db 1 ; bg events
	bg_event  6,  6, BGEVENT_READ, MapBattleTower1FSignpost0Script

	db 5 ; object events
	object_event  7,  6, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ReceptionistScript_0x9e3e2, -1
	object_event 14,  9, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, YoungsterScript_0x9e55d, -1
	object_event  4,  9, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CooltrainerFScript_0x9e568, -1
	object_event  1,  3, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, BugCatcherScript_0x9e56b, -1
	object_event 14,  3, SPRITE_GRANNY, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 1, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, GrannyScript_0x9e56e, -1
