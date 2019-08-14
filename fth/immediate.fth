: IMMEDIATE ( immediate ) ( -- )
	IMMEDIACY
	GET-CURRENT @ 2 CELLS +
	+! ( overflows if already immediate )
;
: IMMEDIATE? ( immediate_q ) ( xt -- flag )
	CELL - @ IMMEDIACY AND 0<>
;
