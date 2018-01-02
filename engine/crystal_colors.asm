MG_Mobile_Layout_FillBox: ; 49336
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .row
	ret
; 49346

LoadOW_BGPal7:: ; 49409
	ld hl, Palette_TextBG7
	ld de, UnknBGPals palette PAL_BG_TEXT
	ld bc, 1 palettes
	ld a, BANK(UnknBGPals)
	call FarCopyWRAM
	ret
; 49418

Palette_TextBG7: ; 49418
INCLUDE "data/palettes/overworld/bg_text.pal"
; 49420

INCLUDE "tilesets/special_palettes.asm"

_InitMG_Mobile_LinkTradePalMap: ; 49797
	hlcoord 0, 0, AttrMap
	lb bc, 16, 2
	ld a, $4
	call MG_Mobile_Layout_FillBox
	ld a, $3
	ldcoord_a 0, 1, AttrMap
	ldcoord_a 0, 14, AttrMap
	hlcoord 2, 0, AttrMap
	lb bc, 8, 18
	ld a, $5
	call MG_Mobile_Layout_FillBox
	hlcoord 2, 8, AttrMap
	lb bc, 8, 18
	ld a, $6
	call MG_Mobile_Layout_FillBox
	hlcoord 0, 16, AttrMap
	lb bc, 2, SCREEN_WIDTH
	ld a, $4
	call MG_Mobile_Layout_FillBox
	ld a, $3
	lb bc, 6, 1
	hlcoord 6, 1, AttrMap
	call MG_Mobile_Layout_FillBox
	ld a, $3
	lb bc, 6, 1
	hlcoord 17, 1, AttrMap
	call MG_Mobile_Layout_FillBox
	ld a, $3
	lb bc, 6, 1
	hlcoord 6, 9, AttrMap
	call MG_Mobile_Layout_FillBox
	ld a, $3
	lb bc, 6, 1
	hlcoord 17, 9, AttrMap
	call MG_Mobile_Layout_FillBox
	ld a, $2
	hlcoord 2, 16, AttrMap
	ld [hli], a
	ld a, $7
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $2
	ld [hl], a
	hlcoord 2, 17, AttrMap
	ld a, $3
	ld bc, 6
	call ByteFill
	ret
; 49811

LoadTradeRoomBGPals: ; 49811
	ld hl, TradeRoomPalette
	ld de, UnknBGPals palette PAL_BG_GREEN
	ld bc, 6 palettes
	ld a, BANK(UnknBGPals)
	call FarCopyWRAM
	farcall ApplyPals
	ret
; 49826

TradeRoomPalette: ; 49826
INCLUDE "data/palettes/trade_room.pal"
; 49856

InitMG_Mobile_LinkTradePalMap: ; 49856
	call _InitMG_Mobile_LinkTradePalMap
	ret
; 4985a
