: REFILL ( refill ) ( -- flag )
	SOURCE-ID IF
		0 EXIT
	THEN 
	TIB /TIB ACCEPT
	DUP 0< IF
		DROP
		0 EXIT
	THEN
	SOURCE# !
	0 >IN !
	-1
;
