: INCLUDE-FILE ( include_file ) ( i*x fileid -- j*x )
	>R
	BEGIN
		PAD 256 R@
		READ-LINE THROW
	WHILE
		PAD SWAP
		EVALUATE
	REPEAT
	R> CLOSE-FILE DROP
;
: INCLUDED ( included ) ( i*x c-addr u -- j*x )
	R/O OPEN-FILE THROW
	INCLUDE-FILE
;
: REQUIRED ( required ) ( i*x c-addr u -- i*x | j*x)
	FIND-NAME IF
		DROP EXIT
	ELSE
		2DUP MAKE-HEADER
		DOLIT EXIT ,
		INCLUDED
	THEN
;
: REQUIRE ( require ) ( "filename" i*x -- i*x | j*x )
	PARSE-NAME REQUIRED
;
