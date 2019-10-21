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
	\ Print the character and save it
	DUP EMIT >R
	\ Reprint the rest of the string
	REPRINT-LINE
	\ Insert the character into string memory
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

: HANDLE-CONTROL ( str pos cnt char -- str pos cnt flag )
	\ TODO : Add handling for delete, home, end, etc.
	DUP 27 = IF \ Escape sequences, i.e. arrow keys
		DROP
		KEY DUP [CHAR] [ <> IF
			UNKEY
			FALSE EXIT
		ELSE
			DROP
		THEN
		KEY CASE
		[CHAR] 3 OF \ Delete
			KEY DROP
			HANDLE-DELETE
			ENDOF
		[CHAR] D OF \ Left arrow
			CURSOR-LEFT
			ENDOF
		[CHAR] C OF \ Right arrow
			CURSOR-RIGHT
			ENDOF
		ENDCASE
		FALSE
	ELSE
		CASE \ General non-printable character handling
		4 OF
			TRUE ENDOF
		10 OF
			2DUP - BEGIN DUP 0< WHILE CSI CUF 1+ REPEAT
			1- ENDOF
		127 OF
			OVER 0> IF HANDLE-BACKSPACE THEN
			FALSE ENDOF
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

' STRING-TAIL HIDE
' SLIDE-RIGHT HIDE
' SLIDE-LEFT HIDE
' REPRINT-LINE HIDE
' INSERT-CHARACTER HIDE
' HANDLE-PRINTABLE HIDE
' HANDLE-BACKSPACE HIDE
' HANDLE-CONTROL HIDE
