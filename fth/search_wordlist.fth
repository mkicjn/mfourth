: NAME-MATCH ( name_match ) ( c-addr u x nt -- c-addr u 0 -1 | xt -1 0 )
	>R DROP 2DUP R@ NAME>STRING
	( c-addr1 u1 c-addr1 u1 c-addr2 u2 ) ( R: nt )
	2OVER NIP OVER <> IF
		2DROP 2DROP RDROP
		FALSE TRUE EXIT
	THEN
	ICOMPARE IF ( c-addr u ) ( R: nt )
		RDROP
		FALSE TRUE
	ELSE
		2DROP
		R> NAME>XT
		TRUE FALSE
	THEN
;
: SEARCH-WORDLIST ( search_wordlist ) ( c-addr u wid -- 0 | xt +/-1 )
	>R 0 ['] NAME-MATCH R>
	TRAVERSE-WORDLIST IF
		DUP IMMEDIATE?
		IF 1 ELSE -1 THEN
	ELSE
		2DROP
		0
	THEN
;
