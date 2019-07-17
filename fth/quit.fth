: QUIT ( quit ) ( R: i*x -- )
	R0 RP!
	TIB SOURCE& !
	BEGIN
		REFILL IF1
			INTERPRET
		ELSE1
			BYE
		THEN1
	AGAIN
;
