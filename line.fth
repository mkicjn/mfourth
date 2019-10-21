REQUIRE term.fth

: STRING-TAIL ( str pos cnt -- str pos cnt strr cntr )
	2DUP - NEGATE 2>R
	2DUP + R> R> -ROT
;

: SLIDE-RIGHT ( str pos cnt -- str pos cnt+1 )
	STRING-TAIL >R DUP 1+ R> CMOVE>
	1+
;

: SLIDE-LEFT ( str pos cnt -- str pos cnt-1 )
	STRING-TAIL >R DUP 1- R> CMOVE
	1-
;

: REPRINT-LINE
	CSI SCP CSI CUH
	STRING-TAIL TYPE
	BL EMIT
	CSI RCP CSI CUS
;

: INSERT-CHARACTER ( str pos cnt char -- str pos+1 cnt )
	2OVER + C!
	>R 1+ R>
;

: HANDLE-PRINTABLE ( str pos cnt char -- str pos+1 cnt+1 )
	DUP EMIT >R
	REPRINT-LINE
	SLIDE-RIGHT
	R> INSERT-CHARACTER
;

: CURSOR-LEFT ( str pos cnt -- str pos' cnt )
	>R 
	1- DUP 0 MAX
	TUCK = IF CSI CUB THEN
	R>
;

: CURSOR-RIGHT ( str pos cnt -- str pos' cnt )
	>R
	1+ DUP R@ MIN
	TUCK = IF CSI CUF THEN
	R>
;

: HANDLE-BACKSPACE ( str pos cnt -- str pos-1 cnt-1 )
	OVER 0<= IF EXIT THEN
	SLIDE-LEFT
	CURSOR-LEFT
	REPRINT-LINE
;

: HANDLE-DELETE ( str pos cnt -- str pos cnt-1 )
	2DUP >= IF EXIT THEN
	SLIDE-LEFT
	REPRINT-LINE
;

: HANDLE-HOME ( str pos cnt -- str 0 cnt )
	>R
	BEGIN
		DUP 0>
	WHILE
		CSI CUB
		1-
	REPEAT
	R>
;

: HANDLE-END ( str pos cnt -- str cnt cnt )
	>R
	BEGIN
		DUP R@ <
	WHILE
		CSI CUF
		1+
	REPEAT
	R>
;

: HANDLE-CONTROL ( str pos cnt char -- str pos cnt flag )
	DUP 27 = IF \ Escape sequences, i.e. arrow keys
		DROP
		KEY DUP [CHAR] [ <> IF
			UNKEY
			FALSE EXIT
		ELSE
			DROP
		THEN
		KEY CASE
			[CHAR] 3 OF KEY DROP HANDLE-DELETE ENDOF
			[CHAR] D OF CURSOR-LEFT ENDOF
			[CHAR] C OF CURSOR-RIGHT ENDOF
			[CHAR] H OF HANDLE-HOME ENDOF
			[CHAR] F OF HANDLE-END ENDOF
		ENDCASE
		FALSE
	ELSE
		CASE \ General non-printable character handling
			4 OF TRUE ENDOF
			10 OF HANDLE-END TRUE ENDOF
			127 OF HANDLE-BACKSPACE FALSE ENDOF
			>R FALSE R>
		ENDCASE
	THEN
;

: LINE-EDIT ( c-addr u -- u )
	>R 0 0
	BEGIN ( str pos cnt ) ( R: max )
		BEGIN
			KEY DUP BL 126 WITHIN
		WHILE
			OVER R@ < IF HANDLE-PRINTABLE ELSE DROP THEN
		REPEAT
		HANDLE-CONTROL
	UNTIL ( str pos cnt ) ( R: max )
	RDROP NIP
;
