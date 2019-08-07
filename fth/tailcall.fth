: TAILCALL ( tailcall ) ( "name" -- )
	'
	DOLIT GO-TO ,
	DUP ['] RECURSE = IF
		DROP GET-CURRENT @
		3 CELLS +
	THEN
	,
; IMMEDIATE
