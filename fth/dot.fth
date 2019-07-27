: . ( dot ) ( n -- )
	DUP >R ABS
	0 <# #S R> SIGN #>
	TYPE SPACE
;
: U. ( udot ) ( u -- )
	0 <# #S #>
	TYPE SPACE
;
: .R ( dotr ) ( n n -- )
	>R
	DUP >R ABS
	0 <# #S R> SIGN #>
	R> OVER - SPACES
	TYPE
;
: U.R ( udotr ) ( u n -- )
	>R 
	0 <# #S #>
	R> OVER - SPACES
	TYPE
;
