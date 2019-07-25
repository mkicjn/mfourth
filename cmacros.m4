m4_divert(-1)
m4_changequote(`<!',`!>')
m4_changequote(<!"`!>,<!'"!>)
	^ I chose these quotes to avoid breaking syntax highlighting in m4 or C sources.
m4_changecom("`'","`'")
	^ This is to avoid breaking things with a number sign in their name.

################################################################################

m4_define("`m4_quote'","`"`$@'"'")
m4_define("`m4_expand'","`$*'")
m4_define("`m4_count'","`$#'")
m4_define("`m4_npcount'","`m4_count(m4_expand(m4_patsubst("`$@'","`[()]'",)))'")

m4_define("`m4_substlist'","`"`^^'","`'"'")
	^ Initialize with a substitution that fails instantly to avoid mishaps when appending to it later
m4_define("`m4_addsubst'","`m4_define("`m4_substlist'",m4_quote(m4_substlist,"`$1'","`$2'"))'")

m4_define("`m4_dosubsts'","`m4_ifelse("`$2'",,
	"`m4_patsubst("`$1'","`,\([,)]\)'","`\1'")'",
	"`m4_dosubsts(m4_quote(m4_patsubst("`$1'","`$2'","`$3'")),m4_shift(m4_shift(m4_shift($@))))'")'")
m4_define("`m4_unparen'","`m4_patsubst("`$@'","`(\(.*\))'","`\1'")'")m4_dnl
m4_define("`m4_remform'","`m4_patsubst("`$@'","`[ 	
]+'","`  '")'")m4_dnl
m4_define("`m4_forth2m4'","`m4_dosubsts(m4_unparen(m4_remform("`$@'")),m4_substlist)'")
m4_define("`m4_forth2c'","`m4_expand(m4_forth2m4($@))'")
m4_define("`m4_import'","`m4_forth2c((m4_include("`$1'")))'")

m4_addsubst("`: +\([^ ]+\) +( +\([^ )]+\) +) '","`m4_nonprim("`\1'",\2,('")
m4_addsubst("` ; +IMMEDIATE'","`exit_code),m4_imm)'")
m4_addsubst("` ;'","`exit_code))'")
m4_addsubst("` ( [^)]*) '","`'")
m4_addsubst("` \(-?[0-9]+\) '","`PUSH(\1),'")

m4_define("`m4_xt'","`m4_patsubst(m4_ifelse("`$2'",,"`$1'","`$2'"),"`\(.*\)_code'","`&\1_defn.xt'")'")
m4_addsubst("` \['] +\([^ ]*\) '","`PUSH(m4_xt( \1 )),'")

m4_addsubst("` IF '","`m4_IF(('")
m4_addsubst("` ELSE '","`),('")
m4_addsubst("` THEN '","`)),'")

m4_addsubst("` BEGIN '","`m4_BEGIN(('")
m4_addsubst("` WHILE '","`),('")
m4_addsubst("` REPEAT '","`)),'")
m4_addsubst("` UNTIL '","`),UNTIL),'")
m4_addsubst("` AGAIN '","`),AGAIN),'")

m4_define("`m4_escquants'","`m4_patsubst("`$1'","`[+*\\\[?]'","`\\\&'")'")
m4_define("`m4_addsubst'","`m4_define("`m4_substlist'",m4_quote(m4_substlist,m4_unparen(m4_escquants(("`$1'"))),"`$2'"))'")
	^ Make addsubst safe for names containing regexp quantifiers

################################################################################

m4_define("`m4_cstresc'","`m4_patsubst("`$1'","`[\\"]'","`\\\&'")'")
m4_define("`m4_prim'","`m4_dnl
void $2_code();
struct {
	link_t link;
	prim_t xt[2];
} $2_defn = {
	{m4_last,"m4_cstresc("`$1'")",m4_len("`$1'")},
	{$2_code,exit_code}
};
m4_define("`m4_last'","`&$2_defn.link'")m4_dnl
m4_addsubst("` $1 '","`$2_code,'")m4_dnl
void $2_code(cell_t *ip,cell_t *sp,cell_t *rp)m4_dnl
'")

################################################################################

m4_define("`m4_last'","`(void *)0'")
m4_define("`m4_imm'","`((ucell_t)1<<((sizeof(cell_t)*8)-1))'")
m4_define("`m4_nonprim'","`m4_dnl
struct {
	link_t link;
	prim_t xt[m4_eval(m4_npcount($3))];
} $2_defn = {
	{m4_last,"m4_cstresc("`$1'")",m4_len("`$1'")m4_ifelse("`$4'",,,"`|$4'")},
	{m4_unparen($3)}
};m4_dnl
m4_define("`m4_last'","`&$2_defn.link'")m4_dnl
m4_addsubst("` $1 '","`docol_code,LIT(&$2_defn.xt),'")m4_dnl
'")
m4_define("`LIT'","`(prim_t)(cell_t)($1)'")
m4_define("`PUSH'","`dolit_code,LIT($1)'")

################################################################################

m4_define("`m4_IF'","`zbranch_code,LIT(m4_eval(m4_npcount($1)+m4_ifelse("`$2'","`'",1,3))*sizeof(cell_t)),m4_unparen($1)m4_dnl
m4_ifelse("`$2'","`'","`'","`,branch_code,LIT(m4_eval(m4_npcount($2)+1)*sizeof(cell_t)),m4_unparen($2)'")'")

m4_define("`m4_BEGIN'","`m4_ifelse(
"`$2'","`AGAIN'","`m4_unparen($1),branch_code,LIT(m4_eval(-m4_npcount($1)-1)*sizeof(cell_t))'",
"`$2'","`UNTIL'","`m4_unparen($1),zbranch_code,LIT(m4_eval(-m4_npcount($1)-1)*sizeof(cell_t))'",
"`m4_unparen($1),zbranch_code,LIT(m4_eval(m4_npcount($2)+3)*sizeof(cell_t)),m4_unparen($2),m4_dnl
branch_code,LIT(m4_eval(-m4_npcount($1,$2)-3)*sizeof(cell_t))'")'")

################################################################################

m4_define("`m4_upcase'","`m4_translit("`$*'","`[a-z]'","`[A-Z]'")'")
m4_define("`m4_regops'","`
m4_prim(m4_upcase($1)@,$1fetch)
{
	sp[1]=(cell_t)$1;
	next(ip,sp+1,rp);
}
m4_prim(m4_upcase($1)!,$1store)
{
	$1=(cell_t *)sp[0];
	next(ip,sp-1,rp);
}'")

m4_define("`m4_1op'","`{
	cell_t a=sp[0];
	sp[0]=$2($1a$3);
	next(ip,sp,rp);
}'")
m4_define("`m4_2op'","`{
	$3cell_t a=sp[-1],b=sp[0];
	sp[-1]=$2(a$1b);
	next(ip,sp-1,rp);
}'")

m4_define("`m4_allot'","`m4_ifelse(m4_eval($1>1),"`0'","`LIT(0)'","`LIT(0),m4_allot(m4_eval($1-1))'")'")
m4_define("`m4_create'","`m4_dnl
m4_nonprim("`$1'","`$2'",(PUSH(&$2_defn.xt[5]),branch_code,LIT(sizeof(cell_t)),exit_code,m4_shift(m4_shift($*))))
#define $2_ptr (&$2_defn.xt[5])
'")
m4_define("`m4_variable'","`m4_create("`$1'",$2,LIT($3))'")
m4_define("`m4_constant'","`m4_dnl
m4_nonprim("`$1'","`$2'",(PUSH($3),exit_code))
#define $2_ptr (&$2_defn.xt[1])
'")

m4_divert(0)m4_dnl
