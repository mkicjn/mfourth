: REFILL ( refill ) ( -- flag )
	SOURCE-ID IF
		0 EXIT
	THEN 
	TIB /TIB ACCEPT
	SOURCE# !
	0 >IN !
	-1
;
