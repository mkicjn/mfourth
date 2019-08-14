: HIDE ( hide ) ( xt -- )
	CELL -
	DUP @ HIDDENNESS OR
	SWAP !
;
: UNHIDE ( unhide ) ( xt -- )
	CELL -
	DUP @ HIDDENNESS INVERT AND
	SWAP !
;
