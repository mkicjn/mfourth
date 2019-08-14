: INTERPRET-NAME ( interpret_name ) ( i*x c-addr u -- j*x )
	FIND-NAME ?DUP IF
		HANDLE-XT
	ELSE IS-NUMBER? IF
		HANDLE-#
	ELSE
		UNDEFINED
	THEN THEN
;
