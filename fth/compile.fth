: COMPILE, ( compile ) ( xt -- )
	DUP CELL+ @ ['] EXIT = IF
		@ ,
	ELSE
		DOLIT DOCOL , ,
	THEN
;
