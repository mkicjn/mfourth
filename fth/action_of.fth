: ACTION-OF ( action_of ) ( i: "name" -- xt ) ( c: "name" -- )
	'
	STATE @ IF
		( POSTPONE ) LITERAL
		['] DEFER@ COMPILE,
	ELSE
		DEFER@
	THEN
; IMMEDIATE
