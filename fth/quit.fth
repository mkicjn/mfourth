: QUIT ( quit ) ( R: i*x -- )
	R0 RP!
	TIB SOURCE& !
	BEGIN
		REFILL DROP
		INTERPRET
	AGAIN
;
