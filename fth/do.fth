: DO ( do )
	['] 2>R COMPILE,
	MARK<
; IMMEDIATE

: ITERATE-LOOP ( iterate_loop ) ( -- flag ) ( R: i' i -- i' i+1 )
	R>
	R> 1+ >R
	2R@ <=
	SWAP >R
;
: ITERATE-+LOOP ( iterate_plusloop ) ( n -- flag ) ( R: i' i -- i' i+n )
	R> SWAP
	DUP R> + >R
	0< IF 2R@ >= ELSE 2R@ <= THEN
	SWAP >R
;

: LOOP-LIKE ( loop_like )
	COMPILE,
	DOLIT 0BRANCH ,
	<RESOLVE
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
