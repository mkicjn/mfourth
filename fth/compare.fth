: COMPARE ( compare ) ( c-addr1 u1 c-addr2 u2 -- -1|0|1 )
	ROT SWAP
	2DUP MIN
	-ROT >R >R
	COMPARE-#
	DUP IF
		RDROP RDROP
		EXIT
	THEN
	DROP
	R> R> -
	1 MIN -1 MAX
;
