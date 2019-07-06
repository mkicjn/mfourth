m4_divert(-1)

	Primitive word definition

m4_define(`m4_last',`NULL')
m4_define(`m4_cs',`m4_format("\%03o%s",m4_len(`$1'),``$1'')')
m4_define(`m4_cword',`m4_dnl
void $2_code();
struct {
	link_t link;
	func_t xt[2];
} $2_defn = {
	{m4_last,m4_len(`$1'),m4_cs(`$1')},
	{$2_code,exit_code}
};
void $2_code(cell_t *ip,cell_t *sp,cell_t *rp)m4_dnl
m4_define(`m4_last',`&$2_defn.link')m4_dnl
')

	Non-primitive word definition

m4_define(`m4_argc',`$#')
m4_define(`m4_forthword',`m4_dnl
struct {
	link_t link;
	func_t xt[m4_argc(m4_shift(m4_shift($@)))];
} $2_defn = {
	{m4_last,m4_len(`$1'),m4_cs(`$1')},
	{m4_shift(m4_shift($@))}
};m4_dnl
m4_define(`m4_last',`&$2_defn.link')m4_dnl
')
m4_define(`L',`(func_t)(cell_t)$1')
m4_define(`P',`$1_code')
m4_define(`C',`($1*sizeof(cell_t))')
m4_define(`X',`$1_defn.xt')
m4_define(`NP',`P(docol),L(X($1))')
m4_define(`PL',`P(dolit),L($1)')
m4_define(`m4_upcase',`m4_translit(`$*',`[a-z]',`[A-Z]')')

	Register operations

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
}')

	Arithmetic/Comparisons

m4_define(`m4_1op',`{
	sp[0]=$2($1sp[0]$3);
	next(ip,sp,rp);
}')
m4_define(`m4_2op',`{
	sp[1]=$2(($3cell_t)sp[1]$1($3cell_t)sp[0]);
	next(ip,sp+1,rp);
}')

	Constants/Variables

m4_define(`m4_variable',`m4_dnl
m4_forthword($1,$2,
	PL(&$2_defn.xt[3]),P(exit),L($3)
)
cell_t *$2_var=(cell_t *)&$2_defn.xt[3];')
m4_define(`m4_constant',`m4_dnl
m4_forthword($1,$2,
	PL($3),P(exit)
)
cell_t $2_const=$3;')
m4_divert(0)m4_dnl
