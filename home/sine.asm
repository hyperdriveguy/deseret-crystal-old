Sine:: ; 1b11
; a = d * sin(a * pi/32)
	ld e, a
	homecall _Sine
	ret
; 1b1e
