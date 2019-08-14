# mfourth
## Forth in less than a "fourth" of the C with m4
*No C functions over 5 lines!*

The general idea is to implement Forth using as little (ANSI) C as possible.
To do this, I wrote a set of macros in m4 capable of translating Forth into C, in some sense.
It's essentially a two step process:
(1) A word definition in Forth is translated into m4 macro expansions, and
(2) those macros are expanded into a struct initialization in C which pre-compiles the word.

In general, my design values for this project are, in order of decreasing importance:

1. Simplicity of operation
2. Efficiency
3. Standards compliance
4. Portability

Specifically, this project implements hybrid direct/indirect threading (as in Gforth) using continuation passing style.
I chose continuation passing partly because every C compiler I've seen (with one exception) implements tail call optimization,
but mostly because I wanted to avoid all extensions, including labels as values.

I would also consider adding TOS optimization in the future, but this is uncertain.

***Please bear in mind: this code is _NOT_ expected to be easily maintainable; it's an exercise in "macro-mancy".***
