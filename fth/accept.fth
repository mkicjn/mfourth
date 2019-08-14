: ACCEPT ( accept ) ( c-addr max -- n )
	STDIN READ-LINE THROW
	0= IF NEGATE THEN
;
