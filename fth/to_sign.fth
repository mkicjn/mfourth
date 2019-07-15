: >SIGN ( to_sign ) ( c-addr1 u1 -- c-addr2 u2 flag )
	OVER C@ 45 = DUP IF
		>R 1- SWAP 1+ SWAP R>
	THEN
;
