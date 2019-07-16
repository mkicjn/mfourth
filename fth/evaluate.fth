: EVALUATE ( evaluate ) ( i*x c-addr u -- j*x )
	SOURCE >IN @
	>R >R >R
	SOURCE! 0 >IN !
	INTERPRET
	R> R> R>
	>IN ! SOURCE!
;
