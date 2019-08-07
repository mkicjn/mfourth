: CREATE-FILE ( create_file ) ( c-addr u fam -- fileid ior )
	<#
	0 HOLD 43 HOLD HOLDFAM HOLD& @
	>R
	0 HOLD HOLDS HOLD& @
	R>
	FOPEN
;
