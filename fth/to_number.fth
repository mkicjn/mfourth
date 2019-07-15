: >NUMBER ( to_number ) ( d1 c-addr1 u1 -- d2 c-addr2 u2 )
	BEGIN
		DUP 0>
	WHILE
		EXTRACT DIGIT
		DUP 0< OVER BASE @ >= OR IF
			DROP EXIT
		THEN
		>R 2SWAP
		BASE @ UM* DROP >R BASE @ UM* R> +
		R> M+
		2SWAP
	REPEAT
;
