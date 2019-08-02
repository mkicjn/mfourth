: >RESOLVE ( fw_resolve )
	( resolve a setup to branch forward from the mark )
	HERE OVER -
	SWAP !
;
: <RESOLVE ( bw_resolve )
	( resolve a setup to branch backward to the mark )
	HERE - ,
;
