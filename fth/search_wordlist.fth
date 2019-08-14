: SEARCH-WORDLIST ( search_wordlist ) ( c-addr u wid -- 0 | xt +/-1 )
	@
	BEGIN ?DUP WHILE
		>R
		2DUP DUP
		R@ LINK>NAME
		ROT OVER = IF
			COMPARE 0= IF
				DROP 2DROP
				R> LINK>XT
				DUP CELL - @ IMMEDIACY AND
				IF 1 ELSE -1 THEN EXIT
			THEN
		ELSE
			2DROP 2DROP
		THEN
		R> @
	REPEAT
	2DROP 0
;
