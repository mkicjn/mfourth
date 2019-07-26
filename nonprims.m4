m4_constant("`CELL'",cell,sizeof(cell_t))
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
m4_create("`CONTEXT'",context,m4_allot(16))
	/* ^^ Initialized in _start */

m4_constant("`WORDLISTS'",wordlists,16)
m4_variable("`#ORDER'",n_order,1)
m4_variable("`STATE'",state,0)

m4_variable("`HOLD&'",hold_addr,0)

m4_import("`fth/space.fth'")
m4_import("`fth/spaces.fth'")
m4_import("`fth/cr.fth'")

m4_import("`fth/here.fth'")
m4_import("`fth/unused.fth'")
m4_import("`fth/allot.fth'")
m4_import("`fth/comma.fth'")

m4_import("`fth/source.fth'")

m4_import("`fth/shift_string.fth'")
m4_import("`fth/extract.fth'")
m4_import("`fth/type.fth'")

m4_import("`fth/accept.fth'")
m4_import("`fth/refill.fth'")

m4_import("`fth/whitespace.fth'")
m4_import("`fth/scan.fth'")
m4_import("`fth/parse.fth'")

m4_import("`fth/compare_n.fth'")
m4_import("`fth/compare.fth'")

m4_import("`fth/within.fth'")
m4_import("`fth/digit.fth'")
m4_import("`fth/to_base.fth'")
m4_import("`fth/to_sign.fth'")
m4_import("`fth/to_number.fth'")
m4_import("`fth/is_char.fth'")
m4_import("`fth/is_number.fth'")

m4_import("`fth/link_to.fth'")
m4_import("`fth/search_wordlist.fth'")

	/* ^ Initialized in _start */
m4_import("`fth/find_name.fth'")

m4_import("`fth/brackets.fth'")
m4_import("`fth/compile.fth'")
m4_import("`fth/literal.fth'")

/* Forward declarations to resolve a circular dependency */
/* TODO: Is there a better way to do this? */
m4_addsubst("` ABORT '","`docol_code,LIT(&abort_defn.xt),'")
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
	{docol_code,(prim_t)(cell_t)&s_naught_defn.xt,spstore_code,docol_code,(prim_t)(cell_t)&quit_defn.xt,exit_code}
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

m4_import("`fth/pad.fth'")
m4_import("`fth/hold.fth'")
m4_import("`fth/sign.fth'")
m4_import("`fth/ud_divmod.fth'")
m4_import("`fth/number.fth'")
m4_import("`fth/numbers.fth'")
m4_import("`fth/dot.fth'")
m4_import("`fth/query.fth'")

m4_import("`fth/mark.fth'")
m4_import("`fth/resolve.fth'")
m4_import("`fth/if.fth'")
m4_import("`fth/begin.fth'")

m4_import("`fth/char.fth'")
m4_import("`fth/bracket_char.fth'")

m4_import("`fth/comments.fth'"))

m4_import("`fth/sliteral.fth'")
m4_import("`fth/s_quote.fth'")
m4_import("`fth/dot_quote.fth'")

m4_import("`fth/depth.fth'")
m4_import("`fth/dot_s.fth'")
