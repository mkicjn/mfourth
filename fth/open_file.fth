: OPEN-FILE ( open_file ) ( c-addr u fam -- fileid ior )
	<# 0 HOLD
	DUP 4 AND IF 98 HOLD THEN
	DUP 2 AND IF 119 HOLD THEN
	DUP 1 AND IF 114 HOLD THEN DROP
	#> DROP >R
	0 HOLD HOLDS #> DROP
	R> FOPEN
;
