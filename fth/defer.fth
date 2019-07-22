: DEFER ( defer ) ( "name" -- )
	PARSE-NAME HEADER
	DOLIT DOCOL , ['] ABORT ,
	['] EXIT COMPILE,
;
: DEFER! ( defer_store ) ( xt1 xt2 -- )
	CELL+ !
;
: DEFER@ ( defer_fetch ) ( xt1 -- xt2 )
	CELL+ @
;
