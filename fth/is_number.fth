: IS-NUMBER? ( is_number ) ( c-addr u -- n ~0 | c-addr u 0 )
	>CHAR IF1 -1 EXIT THEN1
	2DUP
	>BASE BASE DUP @ >R !
	>SIGN >R
	0 DUP 2SWAP
	>NUMBER NIP NIP IF2
		DROP
		RDROP
		0
	ELSE2
		NIP NIP
		R> IF3 NEGATE THEN3
		-1
	THEN2
	R> BASE !
;
