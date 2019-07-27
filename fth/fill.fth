: FILL ( fill ) ( c-addr u char -- )
	SWAP >R SWAP
	BEGIN	
		R@ 0>
	WHILE
		2DUP C! 1+
		R> 1- >R
	REPEAT
	RDROP 2DROP
;
