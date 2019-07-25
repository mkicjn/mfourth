: .S ( dot_s )
	DEPTH >R
	<# 62 HOLD R@ 0 #S 60 HOLD #>
	TYPE SPACE
	1
	BEGIN
		DUP R@ <=
	WHILE
		S0 OVER CELLS + @ .
		1+
	REPEAT
	RDROP DROP
;
