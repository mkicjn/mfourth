: THROW ( throw )
	?DUP IF
		HANDLER @ RP!
		R> HANDLER !
		R> SWAP >R
		SP! DROP R>
	THEN
;
