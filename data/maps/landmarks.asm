landmark: MACRO
; x, y, name
	db \1 + 8, \2 + 16
	dw \3
ENDM

Landmarks:
; entries correspond to constants/landmark_constants.asm
	dbbw       0,   0, SpecialMapName
	landmark  52, 124, NephiCityName
	landmark  60, 116, Route1Name ; I-15
	landmark  60, 100, ProvoCityName
	landmark  62,  98, ByuName ; Brigham Young University
	landmark  62,  96, MtcName ; Missionary Training Center
	landmark  62,  97, ByuUndergroundName
	landmark  52, 100, UtahLakeName
	landmark  60,  92, OremCityName
	landmark  58,  90, GenevaSteelPlantName ; Abandoned Steel Plant
	landmark  68,  92, ProvoCanyonName ; US-189
	landmark  80,  84, TimpanogosPassName ; US-189
	landmark  92,  84, HeberCityName
	landmark 108,  84, Route6Name ; US-40
	landmark 124,  84, DuchesneCityName
	landmark 136,  76, Route87Name ; US-191
	landmark 148,  76, VernalCityName
	landmark 144,  84, ExcavationSiteName
	landmark 115, 108, Route191Name ; US-191
	landmark 108, 118, CarbonPowerPlantName
	landmark 108, 124, CarbonRoadName  ; US-191
	landmark 108, 132, PriceCityName
	landmark  88, 108, Route55Name ; US-6/US-89
	landmark  60,  76, SaltLakeValleyName ; Everything outh of Salt Lake City
	landmark  68,  76, MillcreekCanyonName
	landmark  36,  76, Route4Name ; I-80
	landmark  36,  84, TooleCityName
	landmark  24,  64, SaltFlatsName
	landmark  12,  76, WendoverCityName ; Wendover + West Wendover
	landmark  60,  68, SaltLakeCityName ; Salt Lake City
	landmark  62,  70, TempleSquareName
	landmark  52,  68, AntelopeIslandName
	landmark  48,  56, GreatSaltLakeName
	landmark  76,  68, Route2Name ; I-80
	landmark  92,  68, ParkCityName
	landmark  84,  76, ParkCitySlopesName ; Park City Mountain
	landmark  92,  76, JordanellePassName ; US-189/Jordanelle Resevoir
	landmark  60,  84, PointMountainHwyName ; I-15
	landmark  68,  84, MountTimpanogosName
	landmark  68,  80, TimpanogosCaveName
	landmark  92,  76, Route67Name ; Legacy Parkway/I-15
	landmark  60,  52, OgdenCityName
	landmark  62,  50, UnionStationName
	landmark  60,  36, Route13Name ; US-89
	landmark  68,  28, LoganCityName
	landmark  76,  28, BearLakePassName ; US-89
	landmark  84,  28, BearLakeName
	; Old Kanto Landmarks, these landmarks are unused
	landmark  52, 108, SpecialMapName
	landmark  52,  92, SpecialMapName
	landmark  52,  76, SpecialMapName
	landmark  52,  64, SpecialMapName
	landmark  52,  52, SpecialMapName
	landmark  64,  52, SpecialMapName
	landmark  76,  52, SpecialMapName
	landmark  88,  52, SpecialMapName
	landmark 100,  52, SpecialMapName
	landmark 100,  44, SpecialMapName
	landmark 108,  36, SpecialMapName
	landmark 100,  60, SpecialMapName
	landmark 108,  76, SpecialMapName
	landmark 100,  76, SpecialMapName
	landmark 100,  84, SpecialMapName
	landmark  88,  60, SpecialMapName
	landmark  88,  68, SpecialMapName
	landmark 116,  68, SpecialMapName
	landmark 116,  52, SpecialMapName
	landmark 132,  52, SpecialMapName
	landmark 132,  56, SpecialMapName
	landmark 132,  60, SpecialMapName
	landmark 132,  68, SpecialMapName
	landmark 140,  68, SpecialMapName
	landmark  76,  68, SpecialMapName
	landmark 100,  68, SpecialMapName
	landmark 116,  84, SpecialMapName
	landmark 132,  80, SpecialMapName
	landmark 124, 100, SpecialMapName
	landmark 116, 112, SpecialMapName
	landmark 104, 116, SpecialMapName
	landmark  68,  68, SpecialMapName
	landmark  68,  92, SpecialMapName
	landmark  80, 116, SpecialMapName
	landmark  92, 116, SpecialMapName
	landmark  92, 128, SpecialMapName
	landmark  76, 132, SpecialMapName
	landmark  68, 132, SpecialMapName
	landmark  52, 132, SpecialMapName
	landmark  52, 120, SpecialMapName
	landmark  36,  68, SpecialMapName
	landmark  28,  52, SpecialMapName
	landmark  28,  44, SpecialMapName
	landmark  28,  36, SpecialMapName
	landmark  28,  92, SpecialMapName
	landmark  20, 100, SpecialMapName
	landmark  12, 100, SpecialMapName
	landmark  20,  68, SpecialMapName
	landmark 140, 116, SpecialMapName

NephiCityName:        db "City of¯Nephi@"
Route1Name:           db "Route 1@"
ProvoCityName:        db "City of¯Provo@"
ByuName:              db "BYU Provo@"
MtcName:              db "Provo MTC@"
ByuUndergroundName:   db "BYU¯Underground@"
UtahLakeName:         db "Utah Lake@"
OremCityName:         db "City of¯Orem@"
GenevaSteelPlantName: db "Geneva¯SteelPlant@"
ProvoCanyonName:      db "Provo¯Canyon@"
TimpanogosPassName:   db "Timpanogos¯Pass@"
HeberCityName:        db "Heber City@"
Route6Name:           db "Route 6@"
DuchesneCityName:     db "Duchesne¯City@"
Route87Name:          db "Route 87@"
VernalCityName:       db "Vernal City@"
ExcavationSiteName:   db "Excavation¯Site@"
Route191Name:         db "Route 191@"
CarbonPowerPlantName: db "Carbon¯PowerPlant@"
CarbonRoadName:       db "Carbon Road@"
PriceCityName:        db "City of¯Price@"
Route55Name:          db "Route 55@"
SaltLakeValleyName:   db "Salt Lake¯Valley@"
MillcreekCanyonName:  db "Millcreek¯Canyon@"
Route4Name:           db "Route 4@"
TooleCityName:        db "City of¯Toole@"
SaltFlatsName:        db "Salt Flats@"
WendoverCityName:     db "City of¯Wendover@"
SaltLakeCityName:     db "Salt Lake¯City@"
TempleSquareName:     db "Temple¯Square@"
AntelopeIslandName:   db "Antelope¯Island@"
GreatSaltLakeName:    db "Great¯Salt Lake@"
Route2Name:           db "Route 2@"
ParkCityName:         db "Park City@"
ParkCitySlopesName:   db "Park City¯Slopes@"
JordanellePassName:   db "Jordanelle¯Pass@"
PointMountainHwyName: db "Utah Point@"
MountTimpanogosName:  db "Mount¯Timpanogos@"
TimpanogosCaveName:   db "Timpanogos¯Cave@"
Route67Name:          db "Route 67@"
OgdenCityName:        db "City of¯Ogden@"
UnionStationName:     db "Union¯Station@"
Route13Name:          db "Route 13@"
LoganCityName:        db "City of¯Logan@"
BearLakePassName:     db "Bear Lake¯Pass@"
BearLakeName:         db "Bear Lake@"
; Unused Names
NewBarkTownName:     db "NEW BARK¯TOWN@"
CherrygroveCityName: db "CHERRYGROVE¯CITY@"
VioletCityName:      db "VIOLET CITY@"
AzaleaTownName:      db "AZALEA TOWN@"
GoldenrodCityName:   db "GOLDENROD¯CITY@"
EcruteakCityName:    db "ECRUTEAK¯CITY@"
OlivineCityName:     db "OLIVINE¯CITY@"
CianwoodCityName:    db "CIANWOOD¯CITY@"
MahoganyTownName:    db "MAHOGANY¯TOWN@"
BlackthornCityName:  db "BLACKTHORN¯CITY@"
LakeOfRageName:      db "LAKE OF¯RAGE@"
SilverCaveName:      db "SILVER CAVE@"
SproutTowerName:     db "SPROUT¯TOWER@"
RuinsOfAlphName:     db "RUINS¯OF ALPH@"
UnionCaveName:       db "UNION CAVE@"
SlowpokeWellName:    db "SLOWPOKE¯WELL@"
RadioTowerName:      db "RADIO TOWER@"
PowerPlantName:      db "POWER PLANT@"
NationalParkName:    db "NATIONAL¯PARK@"
TinTowerName:        db "TIN TOWER@"
LighthouseName:      db "LIGHTHOUSE@"
WhirlIslandsName:    db "WHIRL¯ISLANDS@"
MtMortarName:        db "MT.MORTAR@"
DragonsDenName:      db "DRAGON'S¯DEN@"
IcePathName:         db "ICE PATH@"
PalletTownName:      db "PALLET TOWN@"
ViridianCityName:    db "VIRIDIAN¯CITY@"
PewterCityName:      db "PEWTER CITY@"
CeruleanCityName:    db "CERULEAN¯CITY@"
LavenderTownName:    db "LAVENDER¯TOWN@"
VermilionCityName:   db "VERMILION¯CITY@"
CeladonCityName:     db "CELADON¯CITY@"
SaffronCityName:     db "SAFFRON¯CITY@"
FuchsiaCityName:     db "FUCHSIA¯CITY@"
CinnabarIslandName:  db "CINNABAR¯ISLAND@"
IndigoPlateauName:   db "INDIGO¯PLATEAU@"
VictoryRoadName:     db "VICTORY¯ROAD@"
MtMoonName:          db "MT.MOON@"
RockTunnelName:      db "ROCK TUNNEL@"
LavRadioTowerName:   db "LAV¯RADIO TOWER@"
SeafoamIslandsName:  db "SEAFOAM¯ISLANDS@"
Route3Name:          db "ROUTE 3@"
Route5Name:          db "ROUTE 5@"
Route7Name:          db "ROUTE 7@"
Route8Name:          db "ROUTE 8@"
Route9Name:          db "ROUTE 9@"
Route10Name:         db "ROUTE 10@"
Route11Name:         db "ROUTE 11@"
Route12Name:         db "ROUTE 12@"
Route14Name:         db "ROUTE 14@"
Route15Name:         db "ROUTE 15@"
Route16Name:         db "ROUTE 16@"
Route17Name:         db "ROUTE 17@"
Route18Name:         db "ROUTE 18@"
Route19Name:         db "ROUTE 19@"
Route20Name:         db "ROUTE 20@"
Route21Name:         db "ROUTE 21@"
Route22Name:         db "ROUTE 22@"
Route23Name:         db "ROUTE 23@"
Route24Name:         db "ROUTE 24@"
Route25Name:         db "ROUTE 25@"
Route26Name:         db "ROUTE 26@"
Route27Name:         db "ROUTE 27@"
Route28Name:         db "ROUTE 28@"
Route29Name:         db "ROUTE 29@"
Route30Name:         db "ROUTE 30@"
Route31Name:         db "ROUTE 31@"
Route32Name:         db "ROUTE 32@"
Route33Name:         db "ROUTE 33@"
Route34Name:         db "ROUTE 34@"
Route35Name:         db "ROUTE 35@"
Route36Name:         db "ROUTE 36@"
Route37Name:         db "ROUTE 37@"
Route38Name:         db "ROUTE 38@"
Route39Name:         db "ROUTE 39@"
Route40Name:         db "ROUTE 40@"
Route41Name:         db "ROUTE 41@"
Route42Name:         db "ROUTE 42@"
Route43Name:         db "ROUTE 43@"
Route44Name:         db "ROUTE 44@"
Route45Name:         db "ROUTE 45@"
Route46Name:         db "ROUTE 46@"
DarkCaveName:        db "DARK CAVE@"
IlexForestName:      db "ILEX¯FOREST@"
BurnedTowerName:     db "BURNED¯TOWER@"
FastShipName:        db "FAST SHIP@"
DiglettsCaveName:    db "DIGLETT'S¯CAVE@"
TohjoFallsName:      db "TOHJO FALLS@"
UndergroundName:     db "UNDERGROUND@"
BattleTowerName:     db "BATTLE¯TOWER@"
SpecialMapName:      db "SPECIAL@"
