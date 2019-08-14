: WORD ( word ) ( "name" -- c-addr )
	PARSE-NAME TUCK
	PAD 1+ SWAP CMOVE
	PAD TUCK C!
;
: COUNT ( count ) ( c-addr -- c-addr u )
	1+ DUP 1- C@
;
: NUMBER ( number ) ( c-addr -- n )
	COUNT IS-NUMBER?
	0= IF UNDEFINED THEN
;
: FIND ( find ) ( c-addr -- xt )
	DUP COUNT FIND-NAME
	?DUP IF
		>R NIP R>
	ELSE
		2DROP
	THEN
;
