REQUIRE term.fth

: LINE-EDIT ( c-addr u -- u )
	DUP 2>R
	BEGIN
		( Capture printable characters )
		BEGIN
			KEY
			DUP 32 126 WITHIN
		WHILE
			R@ 0> IF
				DUP EMIT
				OVER C! 1+
				R> 1- >R
			THEN
		REPEAT

		( Interpret control characters )
		DUP 10 = OVER 4 = OR IF ( NL or EOF )
			DROP
			TRUE
		ELSE DUP 127 = IF ( BS )
			DROP
			1-
			CSI CUB BL EMIT CSI CUB
			R> 1+ >R
			FALSE
		THEN THEN
	UNTIL
	DROP
	2R> -
;
