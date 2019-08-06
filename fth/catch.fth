: CATCH ( catch )
	SP@ >R
	HANDLER @ >R
	RP@ HANDLER !
	EXECUTE
	R> HANDLER !
	R> DROP
	0
;
