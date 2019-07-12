#define TIB_SIZE (1<<10)
char tib[TIB_SIZE];
m4_constant(`TIB',tib,tib)
m4_constant(``/TIB'',per_tib,TIB_SIZE)
m4_variable(`SOURCE&',source_addr,tib);
m4_variable(``SOURCE#'',source_len,0);
m4_variable(`>IN',in,0)


m4_forthword(`SOURCE',source,
	SOURCE_ADDR,FETCH,SOURCE_LEN,FETCH,EXIT
)
m4_forthword(`SOURCE!',sourcestore,
	SOURCE_LEN,STORE,SOURCE_ADDR,STORE,EXIT
)
m4_forthword(`SOURCE-ID',source_id,
	SOURCE_ADDR,FETCH,TIB,NEQ,EXIT
)
m4_forthword(`ACCEPT',accept,
	TO_R,PUSH(0),
	m4_BEGIN_AGAIN(`
		DUP,RFETCH,GTE,m4_IF(`
			NIP,RDROP,
			EXIT
		'),
		SWAP,
		KEY,DUP,PUSH(10),EQ,m4_IF(`
			TWO_DROP,RDROP,
			EXIT
		'),
		OVER,STORE,INCR,SWAP,INCR
	')
)

m4_forthword(`REFILL',refill,
	SOURCE_ID,m4_IF(`
		PUSH(0),EXIT
	'),
	TIB,PER_TIB,ACCEPT,
	SOURCE_LEN,STORE,
	PUSH(0),IN,STORE,
	PUSH(-1),
	EXIT
)
