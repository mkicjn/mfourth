: ACCEPT ( accept ) ( c-addr max -- n )
	STDIN READ-LINE DROP
	0= IF NEGATE THEN
;
