m4_divert(-1)
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
m4_divert(0)m4_dnl
