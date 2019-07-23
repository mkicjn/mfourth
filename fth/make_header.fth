: MAKE-HEADER ( make_header ) ( c-addr u -- )
	HERE OVER 2>R
	HERE SWAP CMOVE
	R@ ALLOT
	ALIGN
	HERE GET-CURRENT DUP @ , !
	R> R> , ,
;
