: COMPARE-# ( compare_n ) ( c-addr1 c-addr2 u -- -1|0|1 )
	BEGIN DUP 0> WHILE
		>R
		OVER C@ OVER C@ -
		1 MIN -1 MAX
		DUP 0<> IF
			RDROP NIP NIP EXIT
		THEN
		DROP
		1+ SWAP 1+ SWAP
		R> 1-
	REPEAT
	2DROP
	0
;
: COMPARE ( compare ) ( c-addr1 u1 c-addr2 u2 -- -1|0|1 )
	ROT SWAP
	2DUP MIN
	-ROT 2>R
	COMPARE-#
	DUP IF
		RDROP RDROP
		EXIT
	THEN
	DROP
	2R> -
	1 MIN -1 MAX
;
