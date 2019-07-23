: >NUMBER ( to_number ) ( d1 c-addr1 u1 -- d2 c-addr2 u2 )
	BEGIN
		DUP 0>
	WHILE
		EXTRACT DIGIT
		DUP 0 BASE @ 1- WITHIN 0= IF
			DROP
			-1 /STRING
			EXIT
		THEN
		>R 2SWAP
		BASE @ UM* DROP >R BASE @ UM* R> +
		R> M+
		2SWAP
	REPEAT
;
