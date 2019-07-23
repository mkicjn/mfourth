m4_include(cmacros.m4)m4_dnl
m4_include(.edit_warning)m4_dnl
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

m4_prim("`EXIT'",exit)
{
	ip=(cell_t *)pop(rp);
	next(ip,sp,rp);
}
m4_prim("`DOCOL'",docol)
{
	push(rp,ip+1);
	next((cell_t *)*ip,sp,rp);
}
m4_prim("`DOLIT'",dolit)
{
	push(sp,*ip);
	next(ip+1,sp,rp);
}

	/* 3lib bindings */

m4_prim("`BYE'",bye)
{
	(void)ip; (void)sp; (void)rp;
	bye();
}
m4_prim("`KEY'",key)
{
	push(sp,rx());
	next(ip,sp,rp);
}
m4_prim("`EMIT'",emit)
{
	tx((char)pop(sp));
	next(ip,sp,rp);
}

	/* Branching */

m4_prim("`BRANCH'",branch)
{
	ip=(cell_t *)((cell_t)ip+(cell_t)*ip);
	next(ip,sp,rp);
}
m4_prim("`0BRANCH'",zbranch)
{
	if (pop(sp)==0)
		ip=(cell_t *)((cell_t)ip+(cell_t)*ip);
	else
		ip++;
	next(ip,sp,rp);
}
m4_prim("`EXECUTE'",execute)
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

m4_prim("`DUP'",dup)
{
	sp[1]=sp[0];
	next(ip,sp+1,rp);
}
m4_prim("`DROP'",drop)
{
	next(ip,sp-1,rp);
}
m4_prim("`SWAP'",swap)
{
	swap(cell_t,sp[0],sp[-1]);
	next(ip,sp,rp);
}
m4_prim("`ROT'",rot)
{
	swap(cell_t,sp[-2],sp[-1]);
	swap(cell_t,sp[-1],sp[0]);
	next(ip,sp,rp);
}

m4_prim("`NIP'",nip)
{
	sp[-1]=sp[0];
	next(ip,sp-1,rp);
}
m4_prim("`TUCK'",tuck)
{
	swap(cell_t,sp[0],sp[-1]);
	sp[1]=sp[-1];
	next(ip,sp+1,rp);
}
m4_prim("`OVER'",over)
{
	sp[1]=sp[-1];
	next(ip,sp+1,rp);
}
m4_prim("`-ROT'",unrot)
{
	swap(cell_t,sp[0],sp[-1]);
	swap(cell_t,sp[-1],sp[-2]);
	next(ip,sp,rp);
}

	/* Return stack manipulation */

m4_prim("`>R'",to_r)
{
	push(rp,pop(sp));
	next(ip,sp,rp);
}
m4_prim("`R>'",r_from)
{
	push(sp,pop(rp));
	next(ip,sp,rp);
}
m4_prim("`R@'",rfetch)
{
	push(sp,rp[0]);
	next(ip,sp,rp);
}
m4_prim("`RDROP'",rdrop)
{
	next(ip,sp,rp-1);
}

	/* Arithmetic */

m4_prim("`+'",add) m4_2op(+)
m4_prim("`-'",sub) m4_2op(-)
m4_prim("`*'",mul) m4_2op(*)
m4_prim("`/'",div) m4_2op(/)
m4_prim("`MOD'",mod) m4_2op(%)
m4_prim("`LSHIFT'",lsh) m4_2op(<<)
m4_prim("`RSHIFT'",rsh) m4_2op(>>)
m4_prim("`AND'",and) m4_2op(&)
m4_prim("`OR'",or) m4_2op(|)
m4_prim("`XOR'",xor) m4_2op(^)

m4_prim("`NEGATE'",negate) m4_1op(-)
m4_prim("`INVERT'",invert) m4_1op(~)
m4_prim("`1+'",incr) m4_1op(1+)
m4_prim("`1-'",decr) m4_1op(-1+)

m4_prim("`/MOD'",divmod)
{
	register cell_t a=sp[-1],b=sp[0];
	sp[-1]=a%b;
	sp[0]=a/b;
	next(ip,sp,rp);
}

m4_prim("`ABS'",abs)
{
	if (sp[0]<0)
		sp[0]=-sp[0];
	next(ip,sp,rp);
}
m4_prim("`MAX'",max)
{
	sp[-1]=sp[0]>sp[-1]?sp[0]:sp[-1];
	next(ip,sp-1,rp);
}
m4_prim("`MIN'",min)
{
	sp[-1]=sp[0]<sp[-1]?sp[0]:sp[-1];
	next(ip,sp-1,rp);
}

	/* Double-cell manipulation */

m4_prim("`2DUP'",two_dup)
{
	sp[1]=sp[-1];
	sp[2]=sp[0];
	next(ip,sp+2,rp);
}
m4_prim("`2DROP'",two_drop)
{
	next(ip,sp-2,rp);
}
m4_prim("`2SWAP'",two_swap)
{
	swap(cell_t,sp[0],sp[-2]);
	swap(cell_t,sp[-1],sp[-3]);
	next(ip,sp,rp);
}
m4_prim("`2NIP'",two_nip)
{
	sp[-3]=sp[-1];
	sp[-2]=sp[0];
	next(ip,sp,rp);
}
m4_prim("`2OVER'",two_over)
{
	sp[1]=sp[-3];
	sp[2]=sp[-2];
	next(ip,sp+2,rp);
}
m4_prim("`2>R'",two_to_r)
{
	rp[1]=sp[-1];
	rp[2]=sp[0];
	next(ip,sp-2,rp+2);
}
m4_prim("`2R>'",two_r_from)
{
	sp[1]=rp[-1];
	sp[2]=rp[0];
	next(ip,sp+2,rp-2);
}
m4_prim("`2R@'",two_rfetch)
{
	sp[1]=rp[-1];
	sp[2]=rp[0];
	next(ip,sp+2,rp);
}
m4_prim("`2RDROP'",two_rdrop)
{
	next(ip,sp,rp-2);
}
/* TODO: More double-cell words */

	/* Double/Mixed-width Arithmetic */

m4_prim("`UM*'",um_mul)
{
	ucell_t a=sp[-1],b=sp[0];
	*(udcell_t *)&sp[-1]=(udcell_t)a*b;
	next(ip,sp,rp);
}
m4_prim("`M+'",m_add)
{
	*(dcell_t *)&sp[-2]+=sp[0];
	next(ip,sp-1,rp);
}
/* TODO: More double/mixed width words */

	/* Comparisons */

m4_prim("`='",eq) m4_2op(==,-)
m4_prim("`<>'",neq) m4_2op(!=,-)
m4_prim("`>'",gt) m4_2op(>,-)
m4_prim("`>='",gte) m4_2op(>=,-)
m4_prim("`<'",lt) m4_2op(<,-)
m4_prim("`<='",lte) m4_2op(<=,-)

m4_prim("`U>'",ugt) m4_2op(>,-,u)
m4_prim("`U>='",ugte) m4_2op(>=,-,u)
m4_prim("`U<'",ult) m4_2op(<,-,u)
m4_prim("`U<='",ulte) m4_2op(<=,-,u)

m4_prim("`0='",zeq) m4_1op(!,-)
m4_prim("`0<>'",zneq) m4_1op(,-,!=0)
m4_prim("`0>'",zgt) m4_1op(,-,>0)
m4_prim("`0>='",zgte) m4_1op(,-,>=0)
m4_prim("`0<'",zlt) m4_1op(,-,<0)
m4_prim("`0<='",zlte) m4_1op(,-,<=0)

	/* Miscellaneous constants/variables */

m4_constant("`CELL'",cell,sizeof(cell_t))
m4_constant("`S0'",s_naught,stack)
m4_constant("`R0'",r_naught,rstack)

m4_constant("`D0'",d_naught,uarea)
m4_variable("`DP'",dp,uarea)

m4_constant("`BL'",bl,32)
m4_forth2c(("`: SPACE ( space ) BL EMIT ;'"))
m4_forth2c(("`: CR ( cr ) 10 EMIT ;'"))

	/* Memory access */

m4_prim("`@'",fetch)
{
	sp[0]=*(cell_t *)sp[0];
	next(ip,sp,rp);
}
m4_prim("`!'",store)
{
	*(cell_t *)sp[0]=sp[-1];
	next(ip,sp-2,rp);
}
m4_prim("`+!'",addstore)
{
	*(cell_t *)sp[0]+=sp[-1];
	next(ip,sp-2,rp);
}

m4_prim("`C@'",charfetch)
{
	sp[0]=*(char *)sp[0];
	next(ip,sp,rp);
}
m4_prim("`C!'",charstore)
{
	*(char *)sp[0]=(char)sp[-1];
	next(ip,sp-2,rp);
}

m4_prim("`CELL+'",cell_add)
{
	sp[0]+=sizeof(cell_t);
	next(ip,sp,rp);
}
m4_prim("`CELLS'",cells)
{
	sp[0]*=sizeof(cell_t);
	next(ip,sp,rp);
}

m4_import("`fth/here.fth'")
m4_import("`fth/allot.fth'")
m4_import("`fth/comma.fth'")

	/* Parsing */

#define TIB_SIZE (1<<10)
char tib[TIB_SIZE];
m4_constant("`TIB'",tib,tib)
m4_constant("`/TIB'",per_tib,TIB_SIZE)
m4_variable("`SOURCE&'",source_addr,tib)
m4_variable("`SOURCE#'",source_len,0)
m4_variable("`>IN'",in,0)

m4_import("`fth/source.fth'")

m4_import("`fth/shift_string.fth'")
m4_import("`fth/extract.fth'")
m4_import("`fth/type.fth'")

m4_import("`fth/accept.fth'")
m4_import("`fth/refill.fth'")

m4_import("`fth/skip_until.fth'")
m4_import("`fth/whitespace.fth'")
m4_import("`fth/parse_name.fth'")

m4_import("`fth/compare_n.fth'")
m4_import("`fth/compare.fth'")

m4_variable("`BASE'",base,10)
m4_import("`fth/in_range.fth'")
m4_import("`fth/digit.fth'")
m4_import("`fth/to_base.fth'")
m4_import("`fth/to_sign.fth'")
m4_import("`fth/to_number.fth'")
m4_import("`fth/is_char.fth'")
m4_import("`fth/is_number.fth'")

m4_define("`m4_imm'","`(ucell_t)1<<((sizeof(cell_t)*8)-1)'")
m4_constant("`IMMEDIACY'",immediacy,m4_imm)
m4_import("`fth/link_to.fth'")
m4_import("`fth/search_wordlist.fth'")

m4_variable("`FORTH-WORDLIST'",forth_wordlist,0)
	/* ^ Initialized in _start */
m4_create("`CONTEXT'",context,LIT(forth_wordlist_ptr),m4_allot(15))
m4_variable("`#ORDER'",n_order,1)
m4_constant("`WORDLISTS'",wordlists,16)
m4_import("`fth/find_name.fth'")

m4_variable("`STATE'",state,0)
m4_import("`fth/brackets.fth'")
m4_import("`fth/compile.fth'")
m4_import("`fth/literal.fth'")

/* Forward declarations to resolve a circular dependency */
m4_addsubst("` ABORT '","`docol_code,(prim_t)&abort_defn.xt,'")
typedef struct { link_t link; prim_t xt[6]; } abort_t;
abort_t abort_defn;
/* ^ typedef to prevent double declaration as other type */

m4_import("`fth/handle_xt.fth'")
m4_import("`fth/handle_n.fth'")
m4_import("`fth/interpret_name.fth'")
m4_import("`fth/interpret.fth'")

m4_import("`fth/evaluate.fth'")
m4_import("`fth/quit.fth'")

/*"`m4_import("`fth/abort.fth'")'"*/
abort_t abort_defn = {
	{&quit_defn.link,"ABORT",5},
	{docol_code,(prim_t)&s_naught_defn.xt,spstore_code,docol_code,(prim_t)&quit_defn.xt,exit_code}
};
m4_define("`m4_last'","`&abort_defn.link'")
/* ^ Manually set m4_last to ABORT's dictionary link */

m4_import("`fth/get_current.fth'")
m4_import("`fth/immediate.fth'")
m4_import("`fth/cmove.fth'")
m4_import("`fth/aligned.fth'")
m4_import("`fth/align.fth'")
m4_import("`fth/make_header.fth'")

m4_import("`fth/tick.fth'")
m4_import("`fth/bracket_tick.fth'")
m4_import("`fth/postpone.fth'")
m4_import("`fth/colon.fth'")
m4_import("`fth/semicolon.fth'")

m4_import("`fth/to_body.fth'")
m4_import("`fth/create.fth'")
m4_import("`fth/does.fth'")

m4_import("`fth/defer.fth'")
m4_import("`fth/is.fth'")
m4_import("`fth/action_of.fth'")

m4_import("`fth/variable.fth'")
m4_import("`fth/constant.fth'")

	/* Executable entry */

void _start(void)
{
	*forth_wordlist_ptr=LIT(m4_last);
	/* ^ TODO: Is there a better place to accomplish this? */
	next((cell_t *)&quit_defn.xt,stack,rstack);
}
m4_include(.edit_warning)m4_dnl
