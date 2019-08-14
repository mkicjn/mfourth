: COMPARE-# ( compare_n ) ( c-addr1 c-addr2 u xt -- -1|0|1 )
	>R
	BEGIN DUP 0> WHILE ( c-addr1 c-addr2 u ) ( R: xt )
		R> 2>R
		OVER C@ R@ EXECUTE
		OVER C@ R@ EXECUTE
		- 1 MIN -1 MAX
		?DUP IF
			2RDROP NIP NIP EXIT
		THEN
		1+ SWAP 1+ SWAP
		2R> >R 1-
	REPEAT
	RDROP DROP 2DROP
	0
;
: COMPARISON ( comparison ) ( c-addr1 u1 c-addr2 u2 xt -- -1|0|1 )
	>R
	ROT SWAP 2DUP MIN ( c-addr1 c-addr2 u1 u2 min[u1,u2] ) ( R: xt )
	R> 2SWAP 2>R ( c-addr1 c-addr2 min[u1,u2] xt ) ( R: u1 u2 )
	COMPARE-#
	?DUP IF
		2RDROP
	ELSE
		2R> -
		1 MIN -1 MAX
	THEN
;
: NO-OP ( noop ) ;
: CASE-SENSITIVE ( case ) ( -- xt )
	['] NO-OP
;
: TO-UPPER ( to_upper ) 32 INVERT AND ;
: TO-LOWER ( to_lower ) 32 OR ;
: CASE-INSENSITIVE ( nocase ) ( -- xt )
	['] TO-LOWER
;
: COMPARE ( compare ) ( c-addr1 u1 c-addr2 u2 -- -1|0|1 )
	CASE-SENSITIVE COMPARISON
;
: ICOMPARE ( icompare ) ( c-addr1 u1 c-addr2 u2 -- -1|0|1 )
	CASE-INSENSITIVE COMPARISON
;
