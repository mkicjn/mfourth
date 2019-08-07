: ' ( tick ) ( "name" -- xt )
	PARSE-NAME FIND-NAME 0= IF
		TYPE 63 EMIT CR
		ABORT
	THEN
;
