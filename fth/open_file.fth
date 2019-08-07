: OPEN-FILE ( open_file ) ( c-addr u fam -- fileid ior )
	<#
	0 HOLD HOLD-FAM HOLD& @
	>R
	0 HOLD HOLDS HOLD& @
	R>
	FOPEN
;
