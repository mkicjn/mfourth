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
m4_import("`fth/find_name.fth'")

m4_import("`fth/brackets.fth'")
m4_import("`fth/compile.fth'")
m4_import("`fth/literal.fth'")

/* Forward declarations to resolve a circular dependency */
m4_addsubst("` ABORT '","`docol_code,LIT(&abort_defn.xt),'")

m4_import("`fth/handle_xt.fth'")
m4_import("`fth/handle_n.fth'")
m4_import("`fth/interpret_name.fth'")
m4_import("`fth/interpret.fth'")

m4_import("`fth/evaluate.fth'")
m4_import("`fth/quit.fth'")
m4_import("`fth/clear.fth'")
m4_import("`fth/abort.fth'")

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
