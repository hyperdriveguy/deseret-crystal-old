; Luigi Chiesa 2008.  No copyright.  Public Domain.
; Add a grid of guides

(define (script-fu-grid-guides InImage InHGrid InVGrid InMode InBorder)
  (gimp-image-undo-group-start InImage)
  (let* (
        (width (car (gimp-image-width InImage)))
      	(height (car (gimp-image-height InImage)))
        (divH (if (= InMode 0) (/ width InHGrid) InHGrid))
        (divV (if (= InMode 0) (/ height InVGrid) InVGrid))
        (InHGrid (if (= InMode 0) InHGrid (/ width InHGrid)))
        (InVGrid (if (= InMode 0) InVGrid (/ height InVGrid)))
        (hcount 1)
        (vcount 1)
        )
        
    (if (= InBorder TRUE)
      (begin
        (gimp-image-add-hguide InImage 0)
        (gimp-image-add-hguide InImage height)
        (gimp-image-add-vguide InImage 0)
        (gimp-image-add-vguide InImage width)
      )
    )
	
    (while (< hcount InVGrid) 
      (gimp-image-add-hguide InImage (* divV hcount))
      (set! hcount (+ hcount 1))
    )

    (while (< vcount InHGrid) 
      (gimp-image-add-vguide InImage (* divH vcount))
      (set! vcount (+ vcount 1))
    )

	(gimp-image-undo-group-end InImage)
  (gimp-displays-flush)
  )
)

(script-fu-register
  "script-fu-grid-guides"
  "<Image>/Image/Guides/Grid"
  "Add a grid of guides by specifying either the number of guides or the guide spacing"
  "Luigi Chiesa and Rob Antonishen"
  "Public Domain"
  "November 2009"
  "*"
    SF-IMAGE      "Image"   0
	SF-ADJUSTMENT	"Horizontal"	'(2 1 500 1 10 0 1)
	SF-ADJUSTMENT	"Vertical"	'(2 1 500 1 10 0 1)
	SF-OPTION       "Mode" '("Number of Divisions" "Spacing of Guides (px)")	
    SF-TOGGLE "Border guides?" FALSE
)
