m4_include(cmacros.m4)m4_dnl
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <errno.h>

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

	/* Static memory allocations */

#define STACK_SIZE (1<<10)
#define USER_AREA_SIZE (1<<12)
cell_t stack[STACK_SIZE];
cell_t rstack[STACK_SIZE];
cell_t uarea[USER_AREA_SIZE];
#define TIB_SIZE (1<<10)
char tib[TIB_SIZE];

	/* Kernel structure */

#define push(s,v) (*(++s)=(cell_t)(v))
#define pop(s) (*(s--))
/* s[0] is TOS, s[>0] is above stack, s[-n] is nth item */

void next(cell_t *ip,cell_t *sp,cell_t *rp)
{
	(*(prim_t *)ip)(ip+1,sp,rp);
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

	/* stdlib bindings */

m4_prim("`BYE'",bye)
{
	(void)ip; (void)sp; (void)rp;
	exit(0);
}
m4_prim("`KEY'",key)
{
	push(sp,getchar());
	next(ip,sp,rp);
}
m4_prim("`EMIT'",emit)
{
	putchar(pop(sp));
	next(ip,sp,rp);
}
m4_prim("`SEED'",seed)
{
	srand(pop(sp));
	next(ip,sp,rp);
}
m4_prim("`TIME'",time)
{
	push(sp,time(NULL));
	next(ip,sp,rp);
}
m4_prim("`RAND'",rand)
{
	push(sp,rand());
	next(ip,sp,rp);
}
m4_prim("`FOPEN'",fopen)
{ /* ( c-addr c-addr -- fileid ior ) */
	errno=0;
	sp[-1]=(cell_t)fopen((char *)sp[-1],(char *)sp[0]);
	sp[0]=errno;
	next(ip,sp,rp);
}
m4_prim("`CLOSE-FILE'",fclose)
{ /* Would be called FCLOSE for consistency but satisfies CLOSE-FILE's stack effect */
	errno=0;
	fclose((FILE *)sp[0]);
	sp[0]=errno;
	next(ip,sp,rp);
}
m4_prim("`STDIN'",stdin)
{
	push(sp,stdin);
	next(ip,sp,rp);
}
m4_prim("`STDOUT'",stdout)
{
	push(sp,stdout);
	next(ip,sp,rp);
}
m4_prim("`WRITE-FILE'",write_file)
{
	errno=0;
	fwrite((char *)sp[-2],sizeof(char),sp[-1],(FILE *)sp[0]);
	sp[-2]=errno;
	next(ip,sp-2,rp);
}
m4_prim("`READ-FILE'",read_file)
{
	errno=0;
	fread((char *)sp[-2],sizeof(char),sp[-1],(FILE *)sp[0]);
	sp[-2]=errno;
	next(ip,sp-2,rp);
}
m4_prim("`READ-LINE'",read_line)
{
	errno=0;
	fgets((char *)sp[-2],sp[-1],(FILE *)sp[0]);
	sp[-2]=errno;
	next(ip,sp-2,rp);
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
m4_prim("`GO-TO'",go_to)
{
	next(*(cell_t **)ip,sp,rp);
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
m4_prim("`?DUP'",qdup)
{
	cell_t a=sp[0];
	if (a)
		*(++sp)=a;
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
m4_prim("`CHAR+'",char_plus) m4_1op(1+)
m4_prim("`1-'",decr) m4_1op(-1+)
m4_prim("`2*'",two_mul) m4_1op(,,<<1)
m4_prim("`2/'",two_div) m4_1op(,,>>1)

m4_prim("`CHARS'",chars)
{
	next(ip,sp,rp);
}

m4_prim("`/MOD'",divmod)
{
	register cell_t a=sp[-1],b=sp[0];
	sp[-1]=a%b;
	sp[0]=a/b;
	next(ip,sp,rp);
}

m4_prim("`*/'",muldiv)
{
	register cell_t a=sp[-2],b=sp[-1],c=sp[0];
	sp[-2]=(a*b)/c;
	next(ip,sp-2,rp);
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
m4_prim("`UM/MOD'",um_divmod)
{
#if defined(__x86_64__)
	__asm__("divq %4"
		:"=d"(sp[-2]),"=a"(sp[-1])
		:"d"(sp[-1]),"a"(sp[-2]),"r"(sp[0])
		);
#else
	/* TODO: Produce the above on x86_64 without inline asm */
	udcell_t a=*(udcell_t *)&sp[-2];
	ucell_t b=sp[0];
	sp[-2]=a%b;
	sp[-1]=a/b;
#endif
	next(ip,sp-1,rp);
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

	/* Memory access */

m4_prim("`@'",fetch)
{
	sp[0]=*(cell_t *)sp[0];
	next(ip,sp,rp);
}
m4_prim("`2@'",two_fetch)
{
	cell_t *addr=(cell_t *)sp[0];
	sp[0]=addr[1];
	sp[1]=addr[0];
	next(ip,sp+1,rp);
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
m4_prim("`2!'",two_store)
{
	cell_t *addr=(cell_t *)sp[0];
	cell_t x1=sp[-2],x2=sp[-1];
	addr[0]=x2;
	addr[1]=x1;
	next(ip,sp-3,rp);
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

	/* Executable entry */

m4_constant("`TRUE'",true,~0)
m4_constant("`FALSE'",false,0)
m4_constant("`CELL'",cell_const,sizeof(cell_t))
m4_constant("`S0'",s_naught,stack)
m4_constant("`R0'",r_naught,rstack)
m4_constant("`D0'",d_naught,uarea)
m4_constant("`D1'",d_one,&uarea[USER_AREA_SIZE])
m4_variable("`DP'",dp,uarea)
m4_constant("`BL'",bl,32)
m4_constant("`TIB'",tib,tib)
m4_constant("`/TIB'",per_tib,TIB_SIZE)
m4_variable("`SOURCE&'",source_addr,tib)
m4_variable("`SOURCE#'",source_len,0)
m4_variable("`>IN'",in,0)
m4_variable("`BASE'",base,10)
m4_constant("`PRECEDENCE'",precedence,m4_hibit)
m4_variable("`FORTH-WORDLIST'",forth_wordlist,0)
	/* ^ Initialized in _start */
m4_create("`CONTEXT'",context,m4_allot(16))
	/* ^ Initialized in _start */
m4_constant("`WORDLISTS'",wordlists,16)
m4_variable("`#ORDER'",n_order,1)
m4_variable("`STATE'",state,0)
m4_variable("`HOLD&'",hold_addr,0)
m4_variable("`HANDLER'",handler,0)
m4_constant("`R/O'",r_o,2)
m4_constant("`W/O'",w_o,1)

m4_include("`words.m4'")
m4_undivert(1)

int main(int argc,char **argv)
{
	(void) argc; (void) argv;
	*forth_wordlist_ptr=LIT(m4_last);
	*context_ptr=(prim_t)forth_wordlist_ptr;
	next((cell_t *)&quit_defn.xt,stack-1,rstack-1);
	return 0;
}
