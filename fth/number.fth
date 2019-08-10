: <# ( lt_number ) ( -- )
	PAD< >HOLD !
;
: # ( number ) ( ud1 -- ud2 )
	BASE @ UD/MOD ROT
	9 OVER < IF
		10 - 65 +
	ELSE
		48 +
	THEN
	HOLD
;
: #> ( number_gt ) ( xd -- c-addr u )
	2DROP
	>HOLD @
	PAD< OVER -
;
