: WITHIN ( within ) ( n min max -- flag )
	ROT TUCK
	>= -ROT
	<= AND
;
