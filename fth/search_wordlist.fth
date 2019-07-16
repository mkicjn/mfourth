: SEARCH-WORDLIST ( search_wordlist ) ( c-addr u wid -- 0 | xt +/-1 )
	@
	BEGIN DUP 0<> WHILE
		>R
		2DUP R@ LINK>NAME
		COMPARE 0= IF1
			2DROP DROP
			R> LINK>XT
			DUP 1- @ IMMEDIACY AND
			IF2 1 ELSE2 -1 THEN2
			EXIT
		THEN1
		R> @
	REPEAT
	2DROP DROP 0
;
