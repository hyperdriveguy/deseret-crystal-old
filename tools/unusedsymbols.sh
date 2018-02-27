#!/bin/sh
set -e

# Generate the file with ignored labels
rm -f unused_ignore.txt

# Scrape labels from a few select files
sed -n -e 's/^\(BattleTowerMons[0-9][0-9]*\):$/\1/p' data/battle_tower/parties.asm >> unused_ignore.txt
sed -n -e 's/^\(BattleTowerTrainer[0-9][0-9]*DataTable\):$/\1/p' data/battle_tower/unknown.asm >> unused_ignore.txt
sed -n -e 's/^\(IncGradGBPalTable_[0-9][0-9]\)::.*/\1/p' home/fade.asm >> unused_ignore.txt
sed -n -e 's/^\([A-Za-z]*Menu\):.*/\1/p' engine/main_menu.asm | grep -xv MainMenu >> unused_ignore.txt
sed -n -e 's/^\tmap_attributes \([A-z0-9]*\),.*/\1_MapAttributes/p' data/maps/attributes.asm >> unused_ignore.txt

# Add more labels manually
cat >> unused_ignore.txt << EOF
BattleTowerTrainerDataEnd
BoxNameInputUpper
CheckPlayerTurn
Coord2Attr
Cry_Teddiursa_branch_f3286
Cry_Teddiursa_branch_f328e
Cry_Teddiursa_branch_f3296
Cry_Teddiursa_branch_f32a2
Cry_Teddiursa_branch_f32ae
DrawHP
FemalePlayerNameArray
Function24f19
GetDamageStats
GetIcon
HDMATransfer_Wait123Scanlines
InterpretTwoOptionMenu
LeerCorreosIngleses
LeggiPostaInglese
LireLeCourrierAnglais
MalePlayerNameArray
Mobile_GetMenuSelection
NamingScreen_AdvanceCursor_CheckEndOfString
NamingScreen_LoadNextCharacter
POKEDEX_SCX
SetSeenMon
Sfx_GetEggFromDayCareMan_Ch5
Sfx_GetEggFromDayCareMan_Ch6
Sfx_GetEggFromDayCareMan_Ch7
Sfx_GetEggFromDayCareMan_Ch8
Sfx_LevelUp_Ch5
Sfx_LevelUp_Ch6
Sfx_LevelUp_Ch7
Sfx_LevelUp_Ch8
Sfx_NoSignal_branch_f26ff
Sfx_ReadText_Ch5
Sfx_Unknown5F_Ch8
Sfx_Unknown5F_branch_f270e
SwitchSpeed
WaitDMATransfer
_CalcHoursDaysSince
EOF

# Create objects with all the labels exported
# Excluding wram.o since that includes a lot of labels we aren't interested in.
objs=$(make -n -p | grep '^crystal_obj :=' | sed -e 's/^crystal_obj := //' -e 's/wram.o //')
rm -f $objs
make RGBASM='rgbasm -E' $objs

# Check if any of the ignored labels even exist anymore
python3 -u tools/unusedsymbols.py -D $objs | fgrep --line-buffered -xvf - unused_ignore.txt | tee unused_ignore_gone.txt
find unused_ignore_gone.txt -empty -delete

# Run the program to generate a list of unreferenced labels
# All the local labels (the ones contain a '.') are filtered out, as well as the labels in unused_ignore.txt
python3 -u tools/unusedsymbols.py -- $objs \
	| sed -u -e '/\..*$/d' \
	| fgrep --line-buffered -xvf unused_ignore.txt \
	| tee unused.txt

# Clean it up so a regular make won't mess up for the user
rm -f $objs

# Try to filter out any label referenced through a 'jr'
# This is a hack, and kind of sensitive to whatever files the user might have.
# Make sure to look through the unused.txt as well, since that's much more accurate.
rm -f unused_nojr.txt
for x in $(cat unused.txt); do
	if ! grep -rwh --include='*.asm' "$x" | grep '^	jr' | grep -v ' \.'; then
		echo "$x" >> unused_nojr.txt
	fi
done
