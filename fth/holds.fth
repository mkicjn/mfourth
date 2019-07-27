: HOLDS ( holds ) ( c-addr u -- )
	BEGIN
		DUP 0>
	WHILE
		1-
		2DUP +
		C@ HOLD
	REPEAT
	2DROP
;
