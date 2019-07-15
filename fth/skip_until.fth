: SKIP-UNTIL ( skip_until ) ( c-addr u xt -- c-addr u )
	>R
	BEGIN
		DUP 0<= IF1 RDROP EXIT THEN1
		OVER C@ R@ EXECUTE IF2 RDROP EXIT THEN2
		1 /STRING
	AGAIN
;
