: SCAN-UNTIL ( scan_until ) ( c-addr1 u1 xt -- c-addr2 u2 )
	>R
	BEGIN
		DUP 0<= IF
			RDROP EXIT 
		THEN
		OVER C@ R@ EXECUTE IF
			RDROP EXIT
		THEN
		1 /STRING
	AGAIN
;
: SCAN-TO-CHAR ( scan_to_char ) ( c-addr1 u1 char -- c-addr2 u2 )
	>R
	BEGIN
		DUP 0<= IF
			RDROP EXIT 
		THEN
		OVER C@ R@ = IF
			RDROP EXIT
		THEN
		1 /STRING
	AGAIN
;
