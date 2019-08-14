: <# ( lt_num ) ( -- )
	PAD< >HOLD !
;
: # ( num ) ( ud1 -- ud2 )
	BASE @ UD/MOD ROT
	9 OVER < IF
		10 - 65 +
	ELSE
		48 +
	THEN
	HOLD
;
: #S ( nums ) ( ud -- 0 0 )
	BEGIN
		#
		2DUP OR 0=
	UNTIL
;
: #> ( num_gt ) ( xd -- c-addr u )
	2DROP
	>HOLD @
	PAD< OVER -
;
