: IS ( is ) ( i: "name" xt -- ) ( c: "name" -- )
	STATE @ IF
		' ( POSTPONE ) LITERAL
		['] DEFER! COMPILE,
	ELSE
		' DEFER!
	THEN
; IMMEDIATE
