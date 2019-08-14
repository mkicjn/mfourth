: IMMEDIATE ( immediate ) ( -- )
	IMMEDIACY
	GET-CURRENT @ 2 CELLS +
	+! ( overflows if already immediate )
;
