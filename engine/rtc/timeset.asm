TIMESET_UP_ARROW   EQU "♂" ; $ef
TIMESET_DOWN_ARROW EQU "♀" ; $f5

RestartClock_GetWraparoundTime:
	push hl
	dec a
	ld e, a
	ld d, 0
	ld hl, .WrapAroundTimes
rept 4
	add hl, de
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	pop hl
	ret

.WrapAroundTimes:
	dw wBuffer4
	db 7, 4

	dw wBuffer5
	db 24, 12

	dw wBuffer6
	db 60, 15

RestartClock:
; If we're here, we had an RTC overflow.
	ld hl, .ClockTimeMayBeWrongText
	call PrintText
	jr .reset

.new_game:
	ld c, 20
	call DelayFrames
	call RotateFourPalettesLeft
	call ClearTilemap
	call ClearSprites
	xor a
	ldh [hBGMapMode], a
	call LoadStandardFont

	call RotateFourPalettesRight

.reset
	call ClearTilemap
	ld hl, wOptions
	ld a, [hl]
	push af
	set NO_TEXT_SCROLL, [hl]
	call LoadStandardMenuHeader
	ld hl, .ClockSetWithControlPadText
	call PrintText
	call .SetClock
	call ExitMenu
	pop bc
	ld hl, wOptions
	ld [hl], b
	ld c, a
	ret

.ClockTimeMayBeWrongText:
	text_far _ClockTimeMayBeWrongText
	text_end

.ClockSetWithControlPadText:
	text_far _ClockSetWithControlPadText
	text_end

.SetClock:
	ld a, 1
	ld [wBuffer1], a ; which digit
	ld [wBuffer2], a
	ld a, 8
	ld [wBuffer3], a
	call UpdateTime
	call GetWeekday
	ld [wBuffer4], a
	ldh a, [hHours]
	ld [wBuffer5], a
	ldh a, [hMinutes]
	ld [wBuffer6], a

.print_controls
	ld hl, .ClockConfirmWithAText
	call PrintText

.loop
	call .joy_loop
	jr nc, .loop
	and a
	ret nz
	call .PrintTime
	ld hl, .ClockIsThisOKText
	call PrintText
	call YesNoBox
	jr c, .print_controls
	ld a, [wBuffer4]
	ld [wStringBuffer2], a
	ld a, [wBuffer5]
	ld [wStringBuffer2 + 1], a
	ld a, [wBuffer6]
	ld [wStringBuffer2 + 2], a
	xor a
	ld [wStringBuffer2 + 3], a
	call InitTime
	call .PrintTime
	xor a
	ret

.cancel
	ld a, $1
	ret

.ClockConfirmWithAText:
	text_far _ClockConfirmWithAText
	text_end

.ClockIsThisOKText:
	text_far _ClockIsThisOKText
	text_end

.ClockHasResetText:
	text_far _ClockHasResetText
	text_end

.joy_loop
	call JoyTextDelay_ForcehJoyDown
	ld c, a
	push af
	call .PrintTime
	pop af
	bit 0, a
	jr nz, .press_A
	bit 6, a
	jr nz, .pressed_up
	bit 7, a
	jr nz, .pressed_down
	bit 5, a
	jr nz, .pressed_left
	bit 4, a
	jr nz, .pressed_right
	jr .joy_loop

.press_A
	ld a, $0
	scf
	ret

.pressed_up
	ld a, [wBuffer1]
	call RestartClock_GetWraparoundTime
	ld a, [de]
	inc a
	ld [de], a
	cp b
	jr c, .done_scroll
	ld a, $0
	ld [de], a
	jr .done_scroll

.pressed_down
	ld a, [wBuffer1]
	call RestartClock_GetWraparoundTime
	ld a, [de]
	dec a
	ld [de], a
	cp -1
	jr nz, .done_scroll
	ld a, b
	dec a
	ld [de], a
	jr .done_scroll

.pressed_left
	ld hl, wBuffer1
	dec [hl]
	jr nz, .done_scroll
	ld [hl], $3
	jr .done_scroll

.pressed_right
	ld hl, wBuffer1
	inc [hl]
	ld a, [hl]
	cp $4
	jr c, .done_scroll
	ld [hl], $1

.done_scroll
	xor a
	ret

.PrintTime:
	hlcoord 0, 5
	ld b, 5
	ld c, 18
	call Textbox
	decoord 1, 8
	ld a, [wBuffer4]
	ld b, a
	farcall PrintDayOfWeek
	ld a, [wBuffer5]
	ld b, a
	ld a, [wBuffer6]
	ld c, a
	decoord 11, 8
	farcall PrintHoursMins
	ld a, [wBuffer2]
	lb de, " ", " "
	call .PlaceChars
	ld a, [wBuffer1]
	lb de, "▲", "▼"
	call .PlaceChars
	ld a, [wBuffer1]
	ld [wBuffer2], a
	ret

.PlaceChars:
	push de
	call RestartClock_GetWraparoundTime
	ld a, [wBuffer3]
	dec a
	ld b, a
	call Coord2Tile
	pop de
	ld [hl], d
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	ld [hl], e
	ret

PrintTwoDigitNumberLeftAlign:
	push hl
	ld a, " "
	ld [hli], a
	ld [hl], a
	pop hl
	lb bc, PRINTNUM_LEFTALIGN | 1, 2
	call PrintNum
	ret

TimeSetUpArrowGFX:
INCBIN "gfx/new_game/up_arrow.1bpp"
TimeSetDownArrowGFX:
INCBIN "gfx/new_game/down_arrow.1bpp"

SetDayOfWeek:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	ld de, TimeSetUpArrowGFX
	ld hl, vTiles0 tile TIMESET_UP_ARROW
	lb bc, BANK(TimeSetUpArrowGFX), 1
	call Request1bpp
	ld de, TimeSetDownArrowGFX
	ld hl, vTiles0 tile TIMESET_DOWN_ARROW
	lb bc, BANK(TimeSetDownArrowGFX), 1
	call Request1bpp
	xor a
	ld [wTempDayOfWeek], a
.loop
	hlcoord 0, 12
	lb bc, 4, 18
	call Textbox
	call LoadStandardMenuHeader
	ld hl, .OakTimeWhatDayIsItText
	call PrintText
	hlcoord 9, 3
	ld b, 2
	ld c, 9
	call Textbox
	hlcoord 14, 3
	ld [hl], TIMESET_UP_ARROW
	hlcoord 14, 6
	ld [hl], TIMESET_DOWN_ARROW
	hlcoord 10, 5
	call .PlaceWeekdayString
	call ApplyTilemap
	ld c, 10
	call DelayFrames
.loop2
	call JoyTextDelay
	call .GetJoypadAction
	jr nc, .loop2
	call ExitMenu
	call UpdateSprites
	ld hl, .ConfirmWeekdayText
	call PrintText
	call YesNoBox
	jr c, .loop
	ld a, [wTempDayOfWeek]
	ld [wStringBuffer2], a
	call InitDayOfWeek
	call LoadStandardFont
	pop af
	ldh [hInMenu], a
	ret

.GetJoypadAction:
	ldh a, [hJoyPressed]
	and A_BUTTON
	jr z, .not_A
	scf
	ret

.not_A
	ld hl, hJoyLast
	ld a, [hl]
	and D_UP
	jr nz, .d_up
	ld a, [hl]
	and D_DOWN
	jr nz, .d_down
	call DelayFrame
	and a
	ret

.d_down
	ld hl, wTempDayOfWeek
	ld a, [hl]
	and a
	jr nz, .decrease
	ld a, SATURDAY + 1

.decrease
	dec a
	ld [hl], a
	jr .finish_dpad

.d_up
	ld hl, wTempDayOfWeek
	ld a, [hl]
	cp 6
	jr c, .increase
	ld a, SUNDAY - 1

.increase
	inc a
	ld [hl], a

.finish_dpad
	xor a
	ldh [hBGMapMode], a
	hlcoord 10, 4
	ld b, 2
	ld c, 9
	call ClearBox
	hlcoord 10, 5
	call .PlaceWeekdayString
	call WaitBGMap
	and a
	ret

.PlaceWeekdayString:
	push hl
	ld a, [wTempDayOfWeek]
	ld e, a
	ld d, 0
	ld hl, .WeekdayStrings
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	call PlaceString
	ret

.WeekdayStrings:
; entries correspond to wCurDay constants (see constants/wram_constants.asm)
	dw .Sunday
	dw .Monday
	dw .Tuesday
	dw .Wednesday
	dw .Thursday
	dw .Friday
	dw .Saturday
	dw .Sunday

.Sunday:    db " Sunday@"
.Monday:    db " Monday@"
.Tuesday:   db " Tuesday@"
.Wednesday: db "Wednesday@"
.Thursday:  db "Thursday@"
.Friday:    db " Friday@"
.Saturday:  db "Saturday@"

.OakTimeWhatDayIsItText:
	text_far _OakTimeWhatDayIsItText
	text_end

.ConfirmWeekdayText:
	text_asm
	hlcoord 1, 14
	call .PlaceWeekdayString
	ld hl, .OakTimeIsItText
	ret

.OakTimeIsItText:
	text_far _OakTimeIsItText
	text_end

InitialSetDSTFlag:
	ld a, [wDST]
	set 7, a
	ld [wDST], a
	hlcoord 1, 14
	lb bc, 3, 18
	call ClearBox
	ld hl, .Text
	call PlaceHLTextAtBC
	ret

.Text:
	text_asm
	call UpdateTime
	ldh a, [hHours]
	ld b, a
	ldh a, [hMinutes]
	ld c, a
	decoord 1, 14
	farcall PrintHoursMins
	ld hl, .DSTIsThatOKText
	ret

.DSTIsThatOKText:
	text_far _DSTIsThatOKText
	text_end

InitialClearDSTFlag:
	ld a, [wDST]
	res 7, a
	ld [wDST], a
	hlcoord 1, 14
	lb bc, 3, 18
	call ClearBox
	ld hl, .Text
	call PlaceHLTextAtBC
	ret

.Text:
	text_asm
	call UpdateTime
	ldh a, [hHours]
	ld b, a
	ldh a, [hMinutes]
	ld c, a
	decoord 1, 14
	farcall PrintHoursMins
	ld hl, .TimeAskOkayText
	ret

.TimeAskOkayText:
	text_far _TimeAskOkayText
	text_end

PrintHour:
	ld l, e
	ld h, d
	push bc
	call GetTimeOfDayString
	call PlaceString
	ld l, c
	ld h, b
	inc hl
	pop bc
	call AdjustHourForAMorPM
	ld [wDeciramBuffer], a
	ld de, wDeciramBuffer
	call PrintTwoDigitNumberLeftAlign
	ret

GetTimeOfDayString:
	ld a, c
	cp MORN_HOUR
	jr c, .nite
	cp DAY_HOUR
	jr c, .morn
	cp NITE_HOUR
	jr c, .day
.nite
	ld de, .nite_string
	ret
.morn
	ld de, .morn_string
	ret
.day
	ld de, .day_string
	ret

.nite_string: db "Nite@"
.morn_string: db "Morn@"
.day_string:  db "Day@"

AdjustHourForAMorPM:
; Convert the hour stored in c (0-23) to a 1-12 value
	ld a, c
	or a
	jr z, .midnight
	cp NOON_HOUR
	ret c
	ret z
	sub NOON_HOUR
	ret

.midnight
	ld a, NOON_HOUR
	ret
