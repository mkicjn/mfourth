: FORGET ( forget ) ( "name" -- )
	' 2 CELLS -
	DUP @ DP !
	CELL - @ GET-CURRENT !
;
