: CSI 27 EMIT [CHAR] [ EMIT ; \ Control sequence introducer
: CUP [CHAR] H EMIT ; \ Cursor position
: ED [CHAR] J EMIT ; \ Erase display
: SGR [CHAR] m EMIT ; \ Set graphics rendition
: SCP [CHAR] s EMIT ; \ Save cursor position
: RCP [CHAR] u EMIT ; \ Restore cursor position

: CUU [CHAR] A EMIT ; \ Cursor up
: CUD [CHAR] B EMIT ; \ Cursor down
: CUF [CHAR] C EMIT ; \ Cursor forward
: CUB [CHAR] D EMIT ; \ Cursor backward

: CU [CHAR] ? EMIT 25 0 U.R ;
: CUS CU [CHAR] h EMIT ; \ Cursor show
: CUH CU [CHAR] l EMIT ; \ Cursor hide

: CLS
	CSI [CHAR] 2 EMIT ED
	CSI CUP
;
: AT-XY
	CSI
	1- 0 .R
	[CHAR] ; EMIT
	1- 0 .R
	CUP
;
