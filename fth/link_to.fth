: LINK>XT ( link_to_xt ) ( link -- xt )
	3 CELLS +
;
: LINK>NAME ( link_to_name ) ( link -- c-addr u )
	CELL +
	DUP @ SWAP CELL+ @
	IMMEDIACY INVERT AND
;
