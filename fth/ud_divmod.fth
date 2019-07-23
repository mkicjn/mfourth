: UD/MOD ( ud_divmod ) ( ud u -- u ud )
	>R 0 R@ UM/MOD
	R> SWAP >R
	UM/MOD R>
;
