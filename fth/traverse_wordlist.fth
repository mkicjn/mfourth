: TRAVERSE-WORDLIST ( traverse_wordlist ) ( i*x xt wid -- j*x )
	2>R
	BEGIN
		R> @ DUP
	WHILE
		R@ OVER >R
		EXECUTE 0= IF
			2RDROP EXIT
		THEN
	REPEAT
	RDROP DROP
;
