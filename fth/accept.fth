: ACCEPT ( accept ) ( c-addr max -- n )
	( should STDIN READ-LINE replace this? )
	>R 0
	BEGIN
		DUP R@ >= IF
			NIP RDROP
			EXIT
		THEN
		SWAP
		KEY DUP 10 = IF
			2DROP RDROP
			EXIT
		THEN
		OVER ! 1+ SWAP 1+
	AGAIN
;
