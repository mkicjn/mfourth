m4_include(.edit_warning)m4_dnl
#include "3lib.h"

	/* Data types */

#include <stdint.h>
#if INTPTR_MAX > 0xFFFFFFFF
typedef int64_t cell_t;
typedef uint64_t ucell_t;
#elif INTPTR_MAX > 0xFFFF
typedef int32_t cell_t;
typedef uint32_t ucell_t;
#else
typedef int16_t cell_t;
typedef uint16_t ucell_t;
#endif

typedef struct link_s {
	struct link_s *prev;
	cell_t len;
	char *name;
} link_t;

typedef void (*func_t)(cell_t *,cell_t *,cell_t *);
enum {F_IMM=0x80,F_HID=0x40};
#define NULL ((void *)0)

	/* Kernel structure */

#define push(s,v) (*(--s)=(cell_t)(v))
#define pop(s) (*(s++))

void next(cell_t *ip,cell_t *sp,cell_t *rp)
{
	(*(func_t *)ip)(ip+1,sp,rp);
}

/*see word.m4 for macro definitions*/
m4_cword(EXIT,exit)
{
	ip=(cell_t *)pop(rp);
	next(ip,sp,rp);
}
m4_cword(DOCOL,docol)
{
	push(rp,ip+1);
	next((cell_t *)*ip,sp,rp);
}
m4_cword(DOLIT,dolit)
{
	push(sp,*ip);
	next(ip+1,sp,rp);
}

	/* 3lib bindings */

m4_cword(BYE,bye)
{
	(void)ip; (void)sp; (void)rp;
	bye();
}
m4_cword(RX,rx)
{
	push(sp,rx());
	next(ip,sp,rp);
}
m4_cword(TX,tx)
{
	tx((char)pop(sp));
	next(ip,sp,rp);
}

	/* Branching */

m4_cword(BRANCH,branch)
{
	ip=(cell_t *)((cell_t)ip+(cell_t)*ip);
	next(ip,sp,rp);
}
m4_cword(0BRANCH,zbranch)
{
	if (pop(sp)==0)
		ip=(cell_t *)((cell_t)ip+(cell_t)*ip);
	else
		ip++;
	next(ip,sp,rp);
}
m4_cword(EXECUTE,execute)
{
	push(rp,ip);
	next((cell_t *)*sp,sp+1,rp);
}

	/* Register manipulation */
m4_divert(-1)/*
m4_define(`m4_upcase',`m4_translit(`$*',`[a-z]',`[A-Z]')')
m4_define(`m4_regops',`
m4_cword(m4_upcase($1)@,$1fetch)
{
	sp[-1]=(cell_t)$1;
	next(ip,sp-1,rp);
}
m4_cword(m4_upcase($1)!,$1store)
{
	$1=(cell_t *)sp[0];
	next(ip,sp+1,rp);
}')*/m4_divert(0)m4_dnl

m4_regops(ip)
m4_regops(sp)
m4_regops(rp)

	/* Stack manipulation */

m4_cword(DUP,dup)
{
	sp[-1]=sp[0];
	next(ip,sp-1,rp);
}
m4_cword(DROP,drop)
{
	next(ip,sp+1,rp);
}
m4_cword(SWAP,swap)
{
	register cell_t tmp=sp[1];
	sp[1]=sp[0];
	sp[0]=tmp;
	next(ip,sp,rp);
}
m4_cword(ROT,rot)
{
	register cell_t c=sp[2],b=sp[1],a=sp[0];
	sp[2]=b;
	sp[1]=a;
	sp[0]=c;
	next(ip,sp,rp);
}

m4_cword(NIP,nip)
{
	sp[1]=sp[0];
	next(ip,sp+1,rp);
}
m4_cword(TUCK,tuck)
{
	register cell_t b=sp[1],a=sp[0];
	sp[1]=a;
	sp[0]=b;
	sp[-1]=a;
	next(ip,sp-1,rp);
}
m4_cword(OVER,over)
{
	sp[-1]=sp[1];
	next(ip,sp-1,rp);
}
m4_cword(-ROT,unrot)
{
	register cell_t c=sp[2],b=sp[1],a=sp[0];
	sp[2]=a;
	sp[1]=c;
	sp[0]=b;
	next(ip,sp,rp);
}

	/* Arithmetic */
m4_divert(-1)/*
m4_define(`OP1',`{
	sp[0]=$2($1sp[0]$3);
	next(ip,sp,rp);
}')
m4_define(`OP2',`{
	sp[1]=$2(($3cell_t)sp[1]$1($3cell_t)sp[0]);
	next(ip,sp+1,rp);
}')*/m4_divert(0)m4_dnl

m4_cword(+,add) OP2(+)
m4_cword(-,sub) OP2(-)
m4_cword(*,mul) OP2(*)
m4_cword(/,div) OP2(/)
m4_cword(MOD,mod) OP2(%)
m4_cword(LSHIFT,lsh) OP2(<<)
m4_cword(RSHIFT,rsh) OP2(>>)
m4_cword(AND,and) OP2(&)
m4_cword(OR,or) OP2(|)
m4_cword(XOR,xor) OP2(^)

m4_cword(NEGATE,neg) OP1(-)
m4_cword(INVERT,not) OP1(~)
m4_cword(1+,inc) OP1(1+)
m4_cword(1-,dec) OP1(-1+)

m4_cword(/MOD,divmod)
{
	register cell_t a=sp[1],b=sp[0];
	sp[1]=a%b;
	sp[0]=a/b;
	next(ip,sp,rp);
}

m4_cword(=,eq) OP2(==,-)
m4_cword(<>,neq) OP2(!=,-)
m4_cword(>,gt) OP2(>,-)
m4_cword(>=,gte) OP2(>=,-)
m4_cword(<,lt) OP2(<,-)
m4_cword(<=,lte) OP2(<=,-)

m4_cword(U>,ugt) OP2(>,-,u)
m4_cword(U>=,ugte) OP2(>=,-,u)
m4_cword(U<,ult) OP2(<,-,u)
m4_cword(U<=,ulte) OP2(<=,-,u)

m4_cword(0=,zeq) OP1(!,-)
m4_cword(0<>,zneq) OP1(,-,!=0)
m4_cword(0>,zgt) OP1(,-,>0)
m4_cword(0>=,zgte) OP1(,-,>=0)
m4_cword(0<,zlt) OP1(,-,<0)
m4_cword(0<=,zlte) OP1(,-,<=0)

	/* Entry */

#define STACK_SIZE (1<<12)
#define USER_AREA_SIZE (1<<16)
cell_t stack[STACK_SIZE];
cell_t rstack[STACK_SIZE];
cell_t uarea[USER_AREA_SIZE];
#define EOS(s) &s[sizeof(s)/sizeof(*s)]

m4_forthword(`1+',oneplus,
	PL(1),P(add),P(exit)
)
m4_forthword(`',entry,
	PL(2),NP(oneplus),P(bye)
)

void _start(void)
{
	next((cell_t *)X(entry),EOS(stack),EOS(rstack));
	bye();
}
m4_include(.edit_warning)m4_dnl
