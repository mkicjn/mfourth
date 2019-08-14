: HIDE ( hide ) ( xt -- )
	CELL -
	DUP @ HIDDENNESS OR
	SWAP !
;
: REVEAL ( reveal ) ( xt -- )
	CELL -
	DUP @ HIDDENNESS INVERT AND
	SWAP !
;
