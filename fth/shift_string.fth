: /STRING ( shift_string ) ( c-addr u n -- c-addr+n u-n )
	>R SWAP R@ + SWAP R> -
;
