: IN-RANGE? ( in_range ) ( n min max -- flag )
	ROT TUCK
	>= -ROT
	<= AND
;
