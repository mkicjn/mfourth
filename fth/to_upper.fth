: >UPPER ( to_upper ) ( char -- char )
	DUP 97 122 WITHIN IF
		32 -
	THEN
;
