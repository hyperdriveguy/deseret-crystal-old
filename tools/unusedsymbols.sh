#!/bin/sh
set -e

# Generate the file with ignored labels
rm -f unused_ignore.txt

# Scrape labels from a few select files
sed -n -e 's/^\(BattleTowerMons[0-9][0-9]*\):$/\1/p' data/battle_tower/parties.asm >> unused_ignore.txt
sed -n -e 's/^\(BattleTowerTrainer[0-9][0-9]*DataTable\):$/\1/p' data/battle_tower/unknown.asm >> unused_ignore.txt
sed -n -e 's/^\(IncGradGBPalTable_[0-9][0-9]\)::.*/\1/p' home/fade.asm >> unused_ignore.txt
sed -n -e 's/^\([A-Za-z]*Menu\):.*/\1/p' engine/menus/main_menu.asm | grep -xv MainMenu >> unused_ignore.txt

# Add more labels manually
cat >> unused_ignore.txt << EOF
AI_TryItem.no
AI_TryItem.used_item
BattleBGEffect_1c.DMG_PlayerData
BattleTowerTrainerDataEnd
BoxNameInputUpper
BuenaPrizeItems.End
CheckDict.dakuten
CheckDict.diacritic
CheckPlayerMoveTypeMatchups.not_very_effective
CheckPlayerTurn
CheckShininess.Shiny
Coord2Attr
Decompress.Literal
Decompress.long
Decompress.negative
DrawHP
EnemyAttackDamage.physical
EngineFlagAction.check
Facings.End
FemalePlayerNameArray
FlinchTarget
FlyMap.JohtoFlyMap
ForcePlayerMonChoice.enemy_fainted_mobile_error
Function24f19
GetDamageStats
GetIcon
GetNumberedTMHM.skip_two
GetTreeScore.bad
GoldenrodUnderground_MapScripts.Sunday
HDMATransfer_Wait123Scanlines
HandleWeather.player_first
HasRockSmash.no
InitBattleAnimBuffer.milk_drink
InterpretTwoOptionMenu
LeerCorreosIngleses
LeggiPostaInglese
LireLeCourrierAnglais
MalePlayerNameArray
Mobile_GetMenuSelection
NamingScreen_AdvanceCursor_CheckEndOfString
NamingScreen_LoadNextCharacter
POKEDEX_SCX
PlayerAttackDamage.physical
PlayersPCMenuData.PlayersPCMenuList2
Pokedex_GetArea.kanto
Pokedex_LoadGFX.LoadPokedexSlowpokeLZ
Pokedex_UpdateUnownMode.done
PrintBCDDigit.nonzeroDigit
PrintBCDNumber.numberEqualsZero
RadioChannels.kanto
RestorePPEffect.pp_is_maxed_out
SetSeenMon
SmallFarFlagAction.reset
SwitchSpeed
TileAnimationPalette.color1
UpdateBGMap.bottom
WaitDMATransfer
_CalcHoursDaysSince
_PrintNum.long
_PrintNum.seven
EOF

# Create objects with all the labels exported
# Excluding wram.o since that includes a lot of labels we aren't interested in.
objs=$(make -n -p | grep '^crystal_obj :=' | sed -e 's/^crystal_obj := //' -e 's/wram.o //')
rm -f $objs
make RGBASM='rgbasm -E' $objs

# Check if any of the ignored labels even exist anymore
python3 -u tools/unusedsymbols.py -D $objs | fgrep --line-buffered -xvf - unused_ignore.txt | tee unused_ignore_gone.txt
find unused_ignore_gone.txt -empty -delete

# Check if any of the ignored labels are actually used
#python3 -u tools/unusedsymbols.py $objs | fgrep --line-buffered -xvf - unused_ignore.txt | tee unused_ignore_used.txt
#find unused_ignore_used.txt -empty -delete

# Run the program to generate a list of unreferenced labels
# All the labels in unused_ignore.txt are filtered out,
#   as well as those ending with `.anon_dw`
python3 -u tools/unusedsymbols.py -- $objs \
    | sed -u -e '/\.anon_dw$/d' \
    | fgrep --line-buffered -xvf unused_ignore.txt \
    | tee unused.txt

# Clean it up so a regular make won't mess up for the user
rm -f $objs unused_ignore.txt

##### Additional utilities to check for more unused things that a simple grep can't.
echo 'Unused item effects:'
python3 -u tools/unuseditemeffects.py | tee -a unused.txt

find unused.txt -empty -delete

##### This is the end of regular unused symbol checking.
##### From here on out it's grep-based hacks for constants.

echo 'Unused BATTLETOWERACTION:'
sed -ne 's/^\tconst \(BATTLETOWERACTION_[^ ]*\).*/\1/p' constants/battle_tower_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" maps > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done

echo 'Unused trainers:'
sed -ne '/^KRIS/,/^NUM_TRAINER_CLASSES/s/^\tconst \(.*\)/\1/p' constants/trainer_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" maps > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done

echo 'Unused SFX:'
sed -ne 's/^\tconst \(SFX_[^ ]*\).*/\1/p' constants/sfx_constants.asm \
	| while read const; do
	if ! fgrep -rw "$const" home engine data maps > /dev/null; then
		echo "$const" | tee -a unused.txt
	fi
done

echo 'Unused MUSIC:'
sed -ne 's/^\tconst \(MUSIC_[^ ]*\).*/\1/p' constants/music_constants.asm \
	| while read const; do
	if ! fgrep -rw "$const" home engine data maps > /dev/null; then
		echo "$const" | tee -a unused.txt
	fi
done

echo 'Unused SCGB:'
sed -ne 's/^\tconst \(SCGB_[^ ]*\).*/\1/p' constants/scgb_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" engine > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done

echo 'Unused SPRITE_ANIM_INDEX:'
sed -ne 's/^\tconst \(SPRITE_ANIM_INDEX_[^ ]*\).*/\1/p' constants/sprite_anim_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" engine > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused SPRITE_ANIM_SEQ:'
sed -ne 's/^\tconst \(SPRITE_ANIM_SEQ_[^ ]*\).*/\1/p' constants/sprite_anim_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" engine data/sprite_anims/sequences.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused SPRITE_ANIM_FRAMESET:'
sed -ne 's/^\tconst \(SPRITE_ANIM_FRAMESET_[^ ]*\).*/\1/p' constants/sprite_anim_constants.asm \
	| egrep -v '_(FAST|00)$' \
    | while read const; do
    if ! fgrep -rw "$const" engine data/sprite_anims/sequences.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused SPRITE_ANIM_OAMSET:'
sed -ne 's/^\tconst \(SPRITE_ANIM_OAMSET_[^ ]*\).*/\1/p' constants/sprite_anim_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" data/sprite_anims/framesets.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done

echo 'Unused SPRITEMOVEDATA:'
sed -ne 's/^\tconst \(SPRITEMOVEDATA_[^ ]*\).*/\1/p' constants/map_object_constants.asm \
    | fgrep -xv 'SPRITEMOVEDATA_00' \
    | while read const; do
    if ! fgrep -rw "$const" home engine maps > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused SPRITEMOVEFN:'
sed -ne 's/^\tconst \(SPRITEMOVEFN_[^ ]*\).*/\1/p' constants/map_object_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" data/sprites/map_objects.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused STEP_TYPE:'
sed -ne 's/^\tconst \(STEP_TYPE_[^ ]*\).*/\1/p' constants/map_object_constants.asm \
    | while read const; do
    if ! fgrep -rw "$const" engine > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused OBJECT_ACTION:'
sed -ne 's/^\tconst \(OBJECT_ACTION_[^ ]*\).*/\1/p' constants/map_object_constants.asm \
    | fgrep -xv 'OBJECT_ACTION_00' \
    | while read const; do
    if ! fgrep -rw "$const" engine data/sprites/map_objects.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done

echo 'Unused EFFECT:'
sed -ne 's/^\tconst \(EFFECT_[^ ]*\).*/\1/p' constants/move_effect_constants.asm \
    | egrep -v '_(UP|DOWN)(_2|_HIT)?$' \
    | while read const; do
    if ! fgrep -rw "$const" data/moves/moves.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done
echo 'Unused battle commands:'
sed -ne 's/^\tcommand \([^ ]*\).*/\1/p' macros/scripts/battle_commands.asm \
    | fgrep -xv 'raisesubnoanim' \
    | while read const; do
    if ! fgrep -rw "$const" data/moves/effects.asm > /dev/null; then
        echo "$const" | tee -a unused.txt
    fi
done

echo 'Unused event commands:'
sed -ne 's/^\(.*\): MACRO$/\1/p' macros/scripts/events.asm \
	| fgrep -xv 'readcoins' \
	| fgrep -xv 'givemoney' \
	| fgrep -xv 'callstd' \
	| while read const; do
	if ! fgrep -rw "$const" maps engine > /dev/null; then
		echo "$const" | tee -a unused.txt
	fi
done

echo 'Unused battle animation commands:'
sed -ne 's/^\(.*\): MACRO$/\1/p' macros/scripts/battle_anims.asm \
	| fgrep -xv 'anim_4gfx' \
	| fgrep -xv 'anim_5gfx' \
	| fgrep -xv 'anim_minimizeopp' \
	| while read const; do
	if ! fgrep -rw "$const" data/moves/animations.asm > /dev/null; then
		echo "$const" | tee -a unused.txt
	fi
done

# Check unused text commands
#sed -ne 's/^\(.*\): MACRO$/\1/p' macros/scripts/text.asm \
	#| while read const; do
	#if ! fgrep -rw "$const" data engine > /dev/null; then
		#echo "$const" | tee -a unused.txt
	#fi
#done
# TODO: Check unused special chars (in the home/text.asm:CheckDict array)
