: IS-NUMBER? ( is_number ) ( c-addr u -- n ~0 | c-addr u 0 )
	IS-CHAR? IF 2RDROP -1 EXIT THEN
	2DUP
	BASE @ >R >BASE BASE !
	>SIGN >R
	DUP 0> IF
		0 DUP 2SWAP
		>NUMBER NIP NIP IF
			DROP
			RDROP
			0
		ELSE
			NIP NIP
			R> IF NEGATE THEN
			-1
		THEN
	ELSE
		2DROP
		RDROP
		0
	THEN
	R> BASE !
;
