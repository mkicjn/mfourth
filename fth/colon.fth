: : ( colon ) ( "name" -- )
	PARSE-NAME MAKE-HEADER ]
;
: :NONAME ( colon_noname ) ( "name" -- xt )
	0 0 MAKE-HEADER HERE ]
;
