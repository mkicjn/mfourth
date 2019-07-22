: , ( comma ) ( x -- )
	HERE ! CELL ALLOT
;
: C, ( charcomma ) ( char -- )
	HERE C! 1 ALLOT
;
