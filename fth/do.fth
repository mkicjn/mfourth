: DO ( do )
	['] 2>R COMPILE,
	<MARK
; IMMEDIATE

: ITERATE ( iterate ) ( n -- flag ) ( R: i' i -- i' i+1 )
	R>
	R> 1+ >R
	2R@ <=
	SWAP >R
;
: LOOP ( loop )
	['] ITERATE COMPILE,
	['] 0BRANCH COMPILE,
	<RESOLVE
	['] 2RDROP COMPILE,
; IMMEDIATE

: +ITERATE ( plus_iterate ) ( n -- flag ) ( R: i' i -- i' i+n )
	R> SWAP
	DUP 0> IF ['] <= ELSE ['] >= THEN SWAP
	R> + >R
	2R@ ROT EXECUTE
	SWAP >R
; IMMEDIATE
: +LOOP ( plus_loop )
	['] +ITERATE COMPILE,
	['] 0BRANCH COMPILE,
	<RESOLVE
	['] 2RDROP COMPILE,
; IMMEDIATE

: I ( i ) ( -- n )
	RP@ CELL - @
;
: I' ( i_prime ) ( -- n )
	RP@ 2 CELLS - @
;
: J ( j ) ( -- n )
	RP@ 3 CELLS - @
;
: J' ( j_prime ) ( -- n )
	RP@ 4 CELLS - @
;
