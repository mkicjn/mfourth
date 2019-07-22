: >BASE ( to_base ) ( c-addr1 u1 -- c-addr2 u2 u )
	OVER C@
	36 OVER = IF
		DROP
		1 /STRING
		16 EXIT
	THEN
	35 OVER = IF
		DROP
		1 /STRING
		10 EXIT
	THEN
	37 OVER = IF
		DROP
		1 /STRING
		2 EXIT
	THEN
	DROP BASE @
;
