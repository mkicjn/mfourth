: >CHAR ( to_char ) ( c-addr u -- u ~0 | c-addr u 0 )
	DUP 3 <> IF1
		0 EXIT
	THEN1
	>R
	DUP C@ 39 = OVER 2 + C@ 39 = AND IF2
		1+ C@
		RDROP -1
	ELSE2
		R> 0
	THEN2
;
