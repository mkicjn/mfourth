: . ( dot ) ( n -- )
	DUP >R ABS
	0 <# #S R> SIGN #>
	TYPE SPACE
;
: U. ( udot ) ( u -- )
	0 <# #S #>
	TYPE SPACE
;
