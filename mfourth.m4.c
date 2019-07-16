m4_include(.edit_warning)m4_dnl
m4_include(cmacros.m4)m4_dnl
#include "3lib.h"

	/* Data types */

#include <stdint.h>
#if INTPTR_MAX > 0xFFFFFFFF
typedef __uint128_t udcell_t;
typedef __int128_t dcell_t;
typedef int64_t cell_t;
typedef uint64_t ucell_t;
#elif INTPTR_MAX > 0xFFFF
typedef uint64_t udcell_t;
typedef int64_t dcell_t;
typedef int32_t cell_t;
typedef uint32_t ucell_t;
#else
typedef uint32_t udcell_t;
typedef int32_t dcell_t;
typedef int16_t cell_t;
typedef uint16_t ucell_t;
#endif

typedef struct link_s {
	struct link_s *prev;
	char *name;
	cell_t len;
} link_t;

typedef void (*prim_t)(cell_t *,cell_t *,cell_t *);

	/* Stacks */

#define STACK_SIZE (1<<10)
#define USER_AREA_SIZE (1<<12)
cell_t stack[STACK_SIZE];
cell_t rstack[STACK_SIZE];
cell_t uarea[USER_AREA_SIZE];

	/* Kernel structure */

#define push(s,v) (*(++s)=(cell_t)(v))
#define pop(s) (*(s--))
/* s[0] is TOS, s[+n] is above stack, s[-n] is nth item */

void next(cell_t *ip,cell_t *sp,cell_t *rp)
{
	(*(prim_t *)ip)(ip+1,sp,rp);
}

void breakpoint(cell_t *ip,cell_t *sp,cell_t *rp)
{
	next(ip,sp,rp);
}

m4_cword(`EXIT',exit)
{
	ip=(cell_t *)pop(rp);
	next(ip,sp,rp);
}
m4_cword(`DOCOL',docol)
{
	push(rp,ip+1);
	next((cell_t *)*ip,sp,rp);
}
m4_cword(`DOLIT',dolit)
{
	push(sp,*ip);
	next(ip+1,sp,rp);
}

	/* 3lib bindings */

m4_cword(`BYE',bye)
{
	(void)ip; (void)sp; (void)rp;
	bye();
}
m4_cword(`KEY',key)
{
	push(sp,rx());
	next(ip,sp,rp);
}
m4_cword(`EMIT',emit)
{
	tx((char)pop(sp));
	next(ip,sp,rp);
}

	/* Branching */

m4_cword(`BRANCH',branch)
{
	ip=(cell_t *)((cell_t)ip+(cell_t)*ip);
	next(ip,sp,rp);
}
m4_cword(`0BRANCH',zbranch)
{
	if (pop(sp)==0)
		ip=(cell_t *)((cell_t)ip+(cell_t)*ip);
	else
		ip++;
	next(ip,sp,rp);
}
m4_cword(`EXECUTE',execute)
{
	push(rp,ip);
	next((cell_t *)*sp,sp-1,rp);
}

	/* Register manipulation */

m4_regops(ip)
m4_regops(sp)
m4_regops(rp)

	/* Stack manipulation */

#define swap(type,a,b) do {type c=a; a=b; b=c;} while (0)

m4_cword(`DUP',dup)
{
	sp[1]=sp[0];
	next(ip,sp+1,rp);
}
m4_cword(`DROP',drop)
{
	next(ip,sp-1,rp);
}
m4_cword(`SWAP',swap)
{
	swap(cell_t,sp[0],sp[-1]);
	next(ip,sp,rp);
}
m4_cword(`ROT',rot)
{
	swap(cell_t,sp[-2],sp[-1]);
	swap(cell_t,sp[-1],sp[0]);
	next(ip,sp,rp);
}

m4_cword(`NIP',nip)
{
	sp[-1]=sp[0];
	next(ip,sp-1,rp);
}
m4_cword(`TUCK',tuck)
{
	swap(cell_t,sp[0],sp[-1]);
	sp[1]=sp[-1];
	next(ip,sp+1,rp);
}
m4_cword(`OVER',over)
{
	sp[1]=sp[-1];
	next(ip,sp+1,rp);
}
m4_cword(`-ROT',unrot)
{
	swap(cell_t,sp[0],sp[-1]);
	swap(cell_t,sp[-1],sp[-2]);
	next(ip,sp,rp);
}

	/* Return stack manipulation */

m4_cword(`>R',to_r)
{
	push(rp,pop(sp));
	next(ip,sp,rp);
}
m4_cword(`R>',r_from)
{
	push(sp,pop(rp));
	next(ip,sp,rp);
}
m4_cword(`R@',rfetch)
{
	push(sp,rp[0]);
	next(ip,sp,rp);
}
m4_cword(`RDROP',rdrop)
{
	next(ip,sp,rp-1);
}

	/* Arithmetic */

m4_cword(`+',add) m4_2op(+)
m4_cword(`-',sub) m4_2op(-)
m4_cword(`*',mul) m4_2op(*)
m4_cword(`/',div) m4_2op(/)
m4_cword(`MOD',mod) m4_2op(%)
m4_cword(`LSHIFT',lsh) m4_2op(<<)
m4_cword(`RSHIFT',rsh) m4_2op(>>)
m4_cword(`AND',and) m4_2op(&)
m4_cword(`OR',or) m4_2op(|)
m4_cword(`XOR',xor) m4_2op(^)

m4_cword(`NEGATE',negate) m4_1op(-)
m4_cword(`INVERT',invert) m4_1op(~)
m4_cword(`1+',incr) m4_1op(1+)
m4_cword(`1-',decr) m4_1op(-1+)

m4_cword(`/MOD',divmod)
{
	register cell_t a=sp[-1],b=sp[0];
	sp[-1]=a%b;
	sp[0]=a/b;
	next(ip,sp,rp);
}

m4_cword(`ABS',abs)
{
	if (sp[0]<0)
		sp[0]=-sp[0];
	next(ip,sp,rp);
}
m4_cword(`MAX',max)
{
	sp[-1]=sp[0]>sp[-1]?sp[0]:sp[-1];
	next(ip,sp-1,rp);
}
m4_cword(`MIN',min)
{
	sp[-1]=sp[0]<sp[-1]?sp[0]:sp[-1];
	next(ip,sp-1,rp);
}

	/* Double-cell manipulation */

m4_cword(`2DUP',two_dup)
{
	sp[1]=sp[-1];
	sp[2]=sp[0];
	next(ip,sp+2,rp);
}
m4_cword(`2DROP',two_drop)
{
	next(ip,sp-2,rp);
}
m4_cword(`2SWAP',two_swap)
{
	swap(cell_t,sp[0],sp[-2]);
	swap(cell_t,sp[-1],sp[-3]);
	next(ip,sp,rp);
}
m4_cword(`2NIP',two_nip)
{
	sp[-3]=sp[-1];
	sp[-2]=sp[0];
	next(ip,sp,rp);
}
m4_cword(`2OVER',two_over)
{
	sp[1]=sp[-3];
	sp[2]=sp[-2];
	next(ip,sp+2,rp);
}
m4_cword(`2>R',two_to_r)
{
	rp[1]=sp[-1];
	rp[2]=sp[0];
	next(ip,sp-2,rp+2);
}
/* TODO: More double-cell words */

	/* Double/Mixed-width Arithmetic */

m4_cword(`UM*',um_mul)
{
	ucell_t a=sp[-1],b=sp[0];
	*(udcell_t *)&sp[-1]=(udcell_t)a*b;
	next(ip,sp,rp);
}
m4_cword(`M+',m_add)
{
	*(dcell_t *)&sp[-2]+=sp[0];
	next(ip,sp-1,rp);
}
/* TODO: More double/mixed width words */

	/* Comparisons */

m4_cword(`=',eq) m4_2op(==,-)
m4_cword(`<>',neq) m4_2op(!=,-)
m4_cword(`>',gt) m4_2op(>,-)
m4_cword(`>=',gte) m4_2op(>=,-)
m4_cword(`<',lt) m4_2op(<,-)
m4_cword(`<=',lte) m4_2op(<=,-)

m4_cword(`U>',ugt) m4_2op(>,-,u)
m4_cword(`U>=',ugte) m4_2op(>=,-,u)
m4_cword(`U<',ult) m4_2op(<,-,u)
m4_cword(`U<=',ulte) m4_2op(<=,-,u)

m4_cword(`0=',zeq) m4_1op(!,-)
m4_cword(`0<>',zneq) m4_1op(,-,!=0)
m4_cword(`0>',zgt) m4_1op(,-,>0)
m4_cword(`0>=',zgte) m4_1op(,-,>=0)
m4_cword(`0<',zlt) m4_1op(,-,<0)
m4_cword(`0<=',zlte) m4_1op(,-,<=0)

	/* Miscellaneous constants/variables */

m4_constant(`CELL',cell,sizeof(cell_t))
m4_constant(`S0',s_naught,stack)
m4_constant(`R0',r_naught,rstack)

m4_constant(`D0',d_naught,uarea)
m4_variable(`DP',dp,uarea)

m4_constant(`BL',bl,32)
m4_forth(`: SPACE ( space ) BL EMIT ;')
m4_forth(`: CR ( cr ) 10 EMIT ;')

	/* Memory access */

m4_cword(`@',fetch)
{
	sp[0]=*(cell_t *)sp[0];
	next(ip,sp,rp);
}
m4_cword(`!',store)
{
	*(cell_t *)sp[0]=sp[-1];
	next(ip,sp-2,rp);
}
m4_cword(`+!',addstore)
{
	*(cell_t *)sp[0]+=sp[-1];
	next(ip,sp-2,rp);
}

m4_cword(`C@',charfetch)
{
	sp[0]=*(char *)sp[0];
	next(ip,sp,rp);
}
m4_cword(`C!',charstore)
{
	*(char *)sp[0]=(char)sp[-1];
	next(ip,sp-2,rp);
}

m4_cword(`CELL+',cell_add)
{
	sp[0]+=sizeof(cell_t);
	next(ip,sp,rp);
}
m4_cword(`CELLS',cells)
{
	sp[0]*=sizeof(cell_t);
	next(ip,sp,rp);
}

m4_forth(`: HERE ( here ) DP @ ;')
m4_forth(`: ALLOT ( allot ) DP +! ;')
m4_forth(`: , ( comma ) HERE ! CELL ALLOT ;')
m4_forth(`: C, ( charcomma ) HERE ! 1 ALLOT ;')

	/* Parsing */

#define TIB_SIZE (1<<10)
char tib[TIB_SIZE];
m4_constant(`TIB',tib,tib)
m4_constant(``/TIB'',per_tib,TIB_SIZE)
m4_variable(`SOURCE&',source_addr,tib)
m4_variable(``SOURCE#'',source_len,0)
m4_variable(`>IN',in,0)

m4_forth(`: SOURCE ( source ) SOURCE& @ SOURCE# @ ;')
m4_forth(`: SOURCE! ( source_store ) SOURCE# ! SOURCE& ! ;')
m4_forth(`: SOURCE-ID ( source_id ) SOURCE& @ TIB <> ;')

m4_forth(`: EXTRACT ( extract ) 1- SWAP 1+ SWAP OVER 1- C@ ;')
m4_forth(`: TYPE ( type ) BEGIN DUP 0> WHILE EXTRACT EMIT REPEAT ;')

m4_forth(m4_include(`fth/accept.fth'))
m4_forth(m4_include(`fth/refill.fth'))

m4_forth(m4_include(`fth/shift_string.fth'))
m4_forth(m4_include(`fth/skip_until.fth'))
m4_forth(m4_include(`fth/whitespace.fth'))
m4_forth(m4_include(`fth/parse_name.fth'))

m4_forth(m4_include(`fth/compare_n.fth'))
m4_forth(m4_include(`fth/compare.fth'))

m4_variable(`BASE',base,10)
m4_forth(m4_include(`fth/digit.fth'))
m4_forth(m4_include(`fth/to_base.fth'))
m4_forth(m4_include(`fth/to_sign.fth'))
m4_forth(m4_include(`fth/to_number.fth'))
m4_forth(m4_include(`fth/to_char.fth'))
m4_forth(m4_include(`fth/is_number.fth'))

	/* Testing area */

m4_dnl/* This is to fix syntax highlighting after the question mark
m4_forth(`: ENTRY ( entry ) REFILL DROP PARSE-NAME IS-NUMBER? IF EMIT THEN BYE ;')
m4_dnl*/

void _start(void)
{
	next((cell_t *)XT(entry),stack,rstack);
}
m4_include(.edit_warning)m4_dnl
