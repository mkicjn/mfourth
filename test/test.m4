m4_divert(-1)
m4_changequote(`<!',`!>')
m4_changequote(<!"`!>,<!'"!>)

################################################################################

m4_define("`m4_quote'","`"`$@'"'")
m4_define("`m4_expand'","`$*'")
m4_define("`m4_count'","`$#'")
m4_define("`m4_npcount'","`m4_count(m4_expand(m4_patsubst("`$@'","`[()]'",)))'")

m4_define("`m4_substlist'","`"`, *)'","`)'"'")
m4_define("`m4_addsubst'","`m4_define("`m4_substlist'",m4_quote("`$1'","`$2'",m4_substlist))'")

m4_define("`m4_dosubsts'","`m4_ifelse("`$2'","`'","`$1'","`m4_dosubsts(m4_quote(m4_patsubst(m4_quote($1),"`$2'","`$3'")),m4_shift(m4_shift(m4_shift($@))))'")'")
m4_define("`m4_unparen'","`m4_patsubst("`$@'","`(\(.*\))'","`\1'")'")m4_dnl
m4_define("`m4_remform'","`m4_patsubst("`$@'","`[ 	
]+'","`  '")'")m4_dnl
m4_define("`m4_forth2m4'","`m4_dosubsts(m4_unparen(m4_remform("`$@'")),m4_substlist)'")

m4_addsubst("` ( [^)]*) '","`'")
m4_addsubst("`: +\([^ ]+\) +( +\([^ )]+\) +) '","`m4_nonprim("`\1'",\2,('")
m4_addsubst("` ;'","`exit_code))'")
m4_addsubst("` \(-?[0-9]+\) '","`PUSH(\1),'")

m4_addsubst("` IF '","`m4_IF(('")
m4_addsubst("` ELSE '","`),('")
m4_addsubst("` THEN '","`)),'")

m4_addsubst("` BEGIN '","`m4_BEGIN(('")
m4_addsubst("` WHILE '","`),('")
m4_addsubst("` REPEAT '","`)),'")
m4_addsubst("` UNTIL '","`),UNTIL),'")
m4_addsubst("` AGAIN '","`),AGAIN),'")

################################################################################

m4_define("`m4_prim'","`m4_dnl
void $2_code();
struct {
	link_t link;
	prim_t xt[2];
} $2_defn = {
	{m4_last,"$1",m4_len("`$1'")},
	{$2_code,exit_code}
};
m4_define("`m4_last'","`&$2_defn.link'")m4_dnl
m4_addsubst("` $1 '","`$2_code,'")m4_dnl
void $2_code(cell_t *ip,cell_t *sp,cell_t *rp)m4_dnl
'")

################################################################################

m4_define("`m4_last'","`(void *)0'")
m4_define("`m4_nonprim'","`m4_dnl
struct {
	link_t link;
	prim_t xt[m4_eval(m4_npcount($*)-2)];
} $2_defn = {
	{m4_last,""`$1'"",m4_len("`$1'")},
	{m4_unparen($3)}
};m4_dnl
m4_define("`m4_last'","`&$2_defn.link'")m4_dnl
m4_addsubst("` $1 '","`docol_code,(prim_t)&$2_defn.xt,'")m4_dnl
'")
m4_define("`LIT'","`(prim_t)($1)'")
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

m4_divert(0)m4_dnl
m4_addsubst("` DROP '","`drop_code,'")m4_dnl
m4_addsubst("` DUP '","`dup_code,'")m4_dnl
m4_addsubst("` OVER '","`over_code,'")m4_dnl
m4_addsubst("` EMIT '","`emit_code,'")m4_dnl
m4_addsubst("` , '","`comma_code,'")m4_dnl
m4_define("`m4_teststring'","`: TEST1 ( test1 ) DUP BEGIN DUP EMIT WHILE DROP DROP REPEAT ;'")m4_dnl
Forth code:
m4_teststring

m4 code:
m4_forth2m4((m4_teststring))

Expanded:
m4_expand(m4_forth2m4((m4_teststring)))

Forth code:
m4_include(includetest.fth)

m4 code:
m4_forth2m4((m4_include(includetest.fth)))

Expanded:
m4_expand(m4_forth2m4((m4_include(includetest.fth))))
