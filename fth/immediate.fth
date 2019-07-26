: IMMEDIATE ( immediate ) ( -- )
	PRECEDENCE
	GET-CURRENT @ 2 CELLS +
	+! ( overflows if already immediate )
;
