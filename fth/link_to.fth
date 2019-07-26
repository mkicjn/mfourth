: LINK>NAME ( link_to_name ) ( link -- c-addr u )
	CELL+ DUP @ SWAP CELL+ @ PRECEDENCE INVERT AND
;
: LINK>XT ( link_to_xt )
	3 CELLS +
;
