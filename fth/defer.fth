: DEFER ( defer ) ( "name" -- )
	<BUILDS ['] ABORT , DOES> @ EXECUTE
;
: DEFER! ( defer_store ) ( xt1 xt2 -- )
	>BODY !
;
: DEFER@ ( defer_fetch ) ( xt1 -- xt2 )
	>BODY @
;
