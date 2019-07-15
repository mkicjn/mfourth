: ACCEPT ( accept ) ( c-addr max -- n )
	>R 0
	BEGIN
		DUP R@ >= IF1
			NIP RDROP
			EXIT
		THEN1
		SWAP
		KEY DUP 10 = IF2
			2DROP RDROP
			EXIT
		THEN2
		OVER ! 1+ SWAP 1+
	AGAIN
;
