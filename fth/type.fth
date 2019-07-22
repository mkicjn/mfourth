: TYPE ( type ) ( c-addr u -- )
	BEGIN
		DUP 0>
	WHILE
		EXTRACT EMIT
	REPEAT 
	2DROP
;
