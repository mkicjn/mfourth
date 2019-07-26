: >NAME ( to_name ) ( xt -- c-addr u )
	2 CELLS -
	DUP @ SWAP CELL+ @
	PRECEDENCE INVERT AND
;
