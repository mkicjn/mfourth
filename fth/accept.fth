: ACCEPT ( accept ) ( c-addr max -- n )
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
