: : ( colon ) ( "name" -- )
	PARSE-NAME MAKE-HEADER
	LATEST HIDE
	]
;
: :NONAME ( colon_noname ) ( "name" -- xt )
	0 0 MAKE-HEADER HERE ]
;
: ; ( semicolon ) ( -- )
	['] EXIT COMPILE,
	LATEST REVEAL
	( POSTPONE ) [
; IMMEDIATE
