: COMPILE, ( compile ) ( xt -- )
	DUP CELL+ @ DOLIT EXIT = IF
		@ ,
	ELSE
		DOLIT DOCOL , ,
	THEN
;
