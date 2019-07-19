: >BASE ( to_base ) ( c-addr1 u1 -- c-addr2 u2 u )
	OVER C@
	36 OVER = IF1
		DROP
		1 /STRING
		16 EXIT
	THEN1
	35 OVER = IF2
		DROP
		1 /STRING
		10 EXIT
	THEN2
	37 OVER = IF3
		DROP
		1 /STRING
		2 EXIT
	THEN3
	DROP BASE @
;
