: : ( colon ) ( "name" -- )
	PARSE-NAME MAKE-HEADER ]
;
: :NONAME ( colon_noname ) ( -- )
	0 0 MAKE-HEADER HERE ]
;
