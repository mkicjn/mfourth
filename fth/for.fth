: FOR ( for )
	['] >R COMPILE,
	MARK<
; IMMEDIATE
: ITERATE-NEXT ( iterate_next )
	R>
	R> 1- DUP >R 0<
	SWAP >R
;
: NEXT ( next )
	['] ITERATE-NEXT LOOP-LIKE
; IMMEDIATE
