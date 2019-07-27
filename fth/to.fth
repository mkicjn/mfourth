: TO ( to ) ( x "name" -- )
	PARSE-NAME FIND-NAME DROP >BODY
	STATE @ IF
		( POSTPONE ) LITERAL
		['] ! COMPILE,
	ELSE
		!
	THEN
;
