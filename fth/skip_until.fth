: SKIP-UNTIL ( skip_until ) ( c-addr u xt -- c-addr u )
	>R
	BEGIN
		DUP 0<= IF RDROP EXIT THEN
		OVER C@ R@ EXECUTE IF RDROP EXIT THEN
		1 /STRING
	AGAIN
;
