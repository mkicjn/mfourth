: CASE ( case ) ( -- 0 )
	0
; IMMEDIATE

: OF ( of ) ( u -- a-addr u+1 )
	1+
	['] OVER COMPILE,
	['] = COMPILE,
	DOLIT 0BRANCH , MARK> ( POSTPONE IF )
	['] DROP COMPILE,
	SWAP
; IMMEDIATE

: ENDOF ( endof ) ( a-addr1 u -- a-addr2 u )
	SWAP
	DOLIT BRANCH , MARK> SWAP >RESOLVE ( POSTPONE ELSE )
	SWAP
; IMMEDIATE

: ENDCASE ( endcase ) ( a-addr*u u -- )
	['] DROP COMPILE,
	BEGIN
		DUP 0>
	WHILE
		SWAP
		>RESOLVE ( POSTPONE THEN )
		1-
	REPEAT
	DROP
; IMMEDIATE
