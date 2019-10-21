REQUIRE term.fth

: SLIDE-RIGHT ( str pos cnt -- str pos cnt+1 )
	2DUP - NEGATE 2>R ( str pos ) ( R: cnt cnt-pos )
	2DUP + DUP 1+ R> ( str pos str+pos str+pos+1 cnt-pos ) ( R: cnt )
	CMOVE> ( str pos ) ( R: cnt ) 
	R> 1+ ( str pos cnt+1 )
;

: INSERT-CHARACTER ( str pos cnt char -- str pos+1 cnt )
	2OVER + C!
	>R 1+ R>
;

: HANDLE-PRINTABLE ( str pos cnt char -- str pos+1 cnt+1 )
	\ Print the character
	>R R@ EMIT
	\ Reprint the rest of the string
	CSI SCP CSI CUH
	2DUP - NEGATE 2>R
	2DUP + R> TYPE R>
	CSI RCP CSI CUS
	\ Insert the character into string memory
	SLIDE-RIGHT
	R> INSERT-CHARACTER
;

: HANDLE-BACKSPACE
	\ TODO
;

: HANDLE-CONTROL ( str pos cnt char -- str pos cnt flag )
	DUP 27 = IF \ Escape sequences, i.e. arrow keys
		DROP
		KEY DUP [CHAR] [ <> IF
			UNKEY
			FALSE EXIT
		ELSE DROP THEN
		KEY CASE
		[CHAR] D OF \ Left arrow
			>R
			1- DUP 0 MAX TUCK = IF
				CSI CUB
			THEN
			R>
			ENDOF
		[CHAR] C OF \ Right arrow
			>R
			1+ DUP R@ MIN TUCK = IF
				CSI CUF
			THEN
			R>
			ENDOF
		ENDCASE
		FALSE EXIT
	THEN
	CASE \ General non-printable character handling
		4 OF TRUE ENDOF
		10 OF TRUE ENDOF
		127 OF HANDLE-BACKSPACE FALSE ENDOF
		>R FALSE R>
	ENDCASE
;

: LINE-EDIT ( c-addr u -- u )
	>R 0 0
	BEGIN ( str pos cnt ) ( R: max )
		BEGIN
			KEY DUP BL 126 WITHIN
		WHILE
			OVER R@ <= IF HANDLE-PRINTABLE THEN
		REPEAT
		HANDLE-CONTROL
	UNTIL ( str pos cnt ) ( R: max )
	RDROP NIP
;
