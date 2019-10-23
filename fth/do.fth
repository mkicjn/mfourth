: DO ( do )
	['] 2>R COMPILE,
	0
	MARK<
; IMMEDIATE

: ?DO ( qdo )
	['] 2>R COMPILE,
	['] 2R@ COMPILE,
	['] <> COMPILE,
	DOLIT 0BRANCH , MARK> ( POSTPONE IF )
	1
	MARK< ( POSTPONE BEGIN )
; IMMEDIATE

: LEAVE ( leave )
	>R
	>R >R
	DOLIT BRANCH , MARK>
	R> 1+ R>
	R>
; IMMEDIATE

: ITERATE-LOOP ( iterate_loop ) ( -- flag ) ( R: i' i -- i' i+1 )
	R>
	R> 1+ >R 2R@ =
	SWAP >R
;
: ITERATE-+LOOP ( iterate_plusloop ) ( n -- flag ) ( R: i' i -- i' i+n )
	R> SWAP
	R@ + DUP R>
	R@ < SWAP R@ < XOR
	-ROT >R >R
;

: RESOLVE-LEAVES ( resolve_leaves ) ( a-addr*u u -- )
	BEGIN
		DUP 0>
	WHILE
		>R
		>RESOLVE ( POSTPONE THEN )
		R> 1-
	REPEAT
	DROP
;

: LOOP-LIKE ( loop_like ) ( a-addr*u u a-addr xt -- )
	COMPILE,
	DOLIT 0BRANCH , <RESOLVE ( POSTPONE UNTIL )
	RESOLVE-LEAVES
	['] UNLOOP COMPILE,
;

: LOOP ( loop )
	['] ITERATE-LOOP LOOP-LIKE
; IMMEDIATE
: +LOOP ( plus_loop )
	['] ITERATE-+LOOP LOOP-LIKE
; IMMEDIATE
: UNLOOP ( unloop ) ( R: i i' -- )
	2RDROP
;
