: FIND-NAME ( find_name ) ( c-addr u -- c-addr u 0 | xt +/-1 )
	#ORDER @ 1- >R
	BEGIN
		R@ 0>=
	WHILE
		2DUP
		CONTEXT R@ CELLS +
		SEARCH-WORDLIST DUP IF1
			2>R 2DROP 2R>
			RDROP
			EXIT
		ELSE1
			DROP
		THEN1
		R> 1- >R
	REPEAT
	RDROP
	0
;
