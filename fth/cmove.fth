: CMOVE ( cmove ) ( c-addr1 c-addr2 u -- )
	BEGIN
		DUP 0>
	WHILE
		>R
		OVER C@ OVER C!
		1+ SWAP 1+ SWAP
		R> 1-
	REPEAT
	DROP 2DROP
;

: CMOVE> ( cmove_r ) ( c-addr1 c-addr2 u -- )
	TUCK + >R >R R@ + 2R>
	BEGIN
		DUP 0>=
	WHILE
		>R
		OVER C@ OVER C!
		1- SWAP 1- SWAP
		R> 1-
	REPEAT
	DROP 2DROP
;
