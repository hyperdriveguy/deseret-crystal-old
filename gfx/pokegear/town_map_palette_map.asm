	const_def
	const PAL_TOWNMAP_BORDER    ; 0
	const PAL_TOWNMAP_CITY      ; 1
	const PAL_TOWNMAP_MTN_LOW   ; 2
	const PAL_TOWNMAP_MTN_RANGE ; 4
	const PAL_TOWNMAP_MTN_SNOW  ; 5
	const PAL_TOWNMAP_FLAT      ; 6

townmappals: MACRO
rept _NARG / 2
	dn PAL_TOWNMAP_\2, PAL_TOWNMAP_\1
	shift
	shift
endr
ENDM

; gfx/pokegear/town_map.png
	townmappals MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   BORDER,    BORDER
	townmappals CITY,      CITY,      MTN_LOW,   MTN_SNOW,  MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW

	townmappals MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   FLAT,      MTN_LOW,   BORDER,    BORDER
	townmappals MTN_LOW,   CITY,      MTN_RANGE, MTN_RANGE, MTN_RANGE, MTN_SNOW,  MTN_LOW,   MTN_LOW

	townmappals MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   MTN_LOW,   BORDER,    BORDER
	townmappals BORDER,    BORDER,    FLAT,      MTN_RANGE, MTN_RANGE, MTN_SNOW,  BORDER,    FLAT

	; pokegear graphics
	townmappals BORDER,    BORDER,    BORDER,    BORDER,    MTN_LOW,   MTN_LOW,   MTN_LOW,   BORDER
	townmappals BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER

	townmappals CITY,      CITY,      CITY,      CITY,      CITY,      CITY,      CITY,      CITY
	townmappals CITY,      CITY,      CITY,      CITY,      CITY,      CITY,      CITY,      BORDER

	townmappals CITY,      CITY,      CITY,      CITY,      CITY,      CITY,      CITY,      CITY
	townmappals BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    FLAT

	; TODO: Move pokegear graphics to the end
	townmappals FLAT,      FLAT,      FLAT,      MTN_RANGE, MTN_RANGE, MTN_RANGE, MTN_LOW,   MTN_LOW
	townmappals MTN_RANGE, BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER

	townmappals BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER
	townmappals BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER,    BORDER
