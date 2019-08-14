: ' ( tick ) ( "name" -- xt )
	PARSE-NAME FIND-NAME
	0= IF UNDEFINED THEN
;
