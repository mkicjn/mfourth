: CREATE ( create ) ( "name" -- )
	PARSE-NAME HEADER
	HERE 5 CELLS + ( POSTPONE ) LITERAL
	DOLIT BRANCH , CELL , ( prepare for DOES> )
	['] EXIT COMPILE,
;
