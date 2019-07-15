: PARSE-NAME ( parse_name ) ( -- c-addr u )
	SOURCE >IN @ /STRING
	``m4_xt( NOT-WHITESPACE )'' SKIP-UNTIL
	2DUP
	``m4_xt( WHITESPACE )'' SKIP-UNTIL
	NIP -
	2DUP + SOURCE& @ - >IN !
;
