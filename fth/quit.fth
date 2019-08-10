: QUIT ( quit ) ( R: i*x -- )
	R0 RP!
	TIB >SOURCE !
	BEGIN
		REFILL IF
			['] INTERPRET CATCH ?DUP IF
				( TODO print error )
				ABORT
			THEN
		ELSE
			BYE
		THEN
	AGAIN
;
