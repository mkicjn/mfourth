: IMMEDIATE ( immediate ) ( -- )
	IMMEDIACY
	LATEST @ 2 CELLS +
	+! ( overflows if already immediate )
;
