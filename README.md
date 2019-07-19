# mfourth (WIP)
## Forth in a "fourth" of the C with m4
Not a single C function over 5 lines.

The general idea was to implement Forth using as little (ANSI) C as possible with a set of macros capable of translating
a word definition in Forth into the C struct initialization that implements it.

Admittedly, there are several ugly design compromises throughout the project, but it's quite consistent for the most part.
Most of the compromises are from m4's horrendous inability to gracefully deal with the characters ``` ` ```, ` ' `, or ` , `.

Some of these issues could probably be solved with m4_changequote, so I'll probably be looking more into that soon.

In general, my design values for this project are:

1. Simplicity of operation (i.e. reducing the amount of C code)
2. Efficiency (i.e. helping the compiler generate short assembly)
3. Standards compliance (specifically Forth 2012)
4. Portability

In particular, this project implements hybrid direct/indirect threading (as in Gforth) using continuation passing style.
I chose continuation passing partly because every C compiler I've seen (with one exception) implements tail call optimization,
but mostly because I wanted to avoid all extensions, including labels as values.

I would also consider adding TOS optimization in the future, but this is uncertain.

***Please bear in mind that this code is _NOT_ expected to be maintainable; it's mostly an exercise in "macro-mancy".***
