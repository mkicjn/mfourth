: HANDLE-XT ( handle_xt ) ( xt +/-1 -- i*x | )
	STATE @ IF
		0> IF
			EXECUTE
		ELSE
			COMPILE,
		THEN
	ELSE
		DROP
		EXECUTE
	THEN
;
