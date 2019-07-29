: ABORT ( abort ) ( i*x -- ) ( R: j*x -- )
	CLEAR QUIT
;
: ABORT" ( abort_quote ) ( "msg<quote>" i*x -- ) ( R: j*x -- )
	( POSTPONE ) ."
	STATE @ IF
		['] CR COMPILE,
		['] ABORT COMPILE,
	ELSE
		CR
		ABORT
	THEN
; IMMEDIATE
