: DEFER ( defer ) ( "name" -- )
	PARSE-NAME HEADER
	['] ABORT COMPILE,
	['] EXIT COMPILE,
;
: IS ( is ) ( "name" xt -- )
	' CELL+ !
;
