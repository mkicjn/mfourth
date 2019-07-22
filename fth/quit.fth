: QUIT ( quit ) ( R: i*x -- )
	R0 RP!
	TIB SOURCE& !
	BEGIN
		REFILL IF
			INTERPRET
		ELSE
			BYE
		THEN
	AGAIN
;
