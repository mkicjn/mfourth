: .NT ( dot_name ) ( nt -- )
	NAME>STRING TYPE SPACE TRUE
;
: WORDS ( words ) ( -- )
	['] .NT GET-CURRENT TRAVERSE-WORDLIST
	CR
;
