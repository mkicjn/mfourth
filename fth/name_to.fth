: NAME>STRING ( name_to_string ) ( link -- c-addr u )
	CELL +
	DUP @ SWAP CELL+ @
	IMMEDIACY INVERT AND
;
: NAME>XT ( name_to_xt ) ( link -- xt )
	3 CELLS +
;
