: PARSE-NAME ( parse_name ) ( "<whitespace>name" -- c-addr u )
	SOURCE >IN @ /STRING
	['] NOT-WHITESPACE SCAN-UNTIL
	2DUP
	['] WHITESPACE SCAN-UNTIL
	NIP -
	2DUP + SOURCE& @ - 1+ >IN !
;
: PARSE ( parse ) ( "<anychars><c>" c -- c-addr u )
	>R
	SOURCE >IN @ /STRING
	2DUP R> SCAN-TO-CHAR
	NIP -
	2DUP + SOURCE& @ - 1+ >IN !
;
