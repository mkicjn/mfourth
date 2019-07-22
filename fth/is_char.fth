: IS-CHAR? ( is_char ) ( c-addr u -- u ~0 | c-addr u 0 )
	DUP 3 <> IF
		0 EXIT
	THEN
	>R
	DUP C@ 39 = OVER 2 + C@ 39 = AND IF
		1+ C@
		RDROP -1
	ELSE
		R> 0
	THEN
;
