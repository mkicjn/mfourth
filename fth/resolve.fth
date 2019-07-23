: RESOLVE> ( resolve_r )
	( resolve a setup to branch forward from the mark )
	HERE OVER -
	SWAP !
;
: <RESOLVE ( l_resolve )
	( resolve a setup to branch backward to the mark )
	HERE - ,
;
