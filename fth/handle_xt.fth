: HANDLE-XT ( handle_xt ) ( xt +/-1 -- i*x | )
	STATE @ IF1
		0> IF2
			EXECUTE
		ELSE2
			COMPILE`,'
		THEN2
	ELSE1
		DROP
		EXECUTE
	THEN1
;
