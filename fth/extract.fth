: EXTRACT ( extract ) ( c-addr u -- c-addr+1 u-1 char )
	1 /STRING
	OVER 1- C@
;
