CC=clang
CFLAGS=-ansi -O3 -g -nostartfiles -Wall -Wextra -Wpedantic

ASM=nasm
ASMFLAGS=-felf64

PLATFORM=linux_x64

a.out: base.o 3lib.o
	ld $^

posix: base.c posix.c
	$(CC) $(CFLAGS) $^

words.m4: fth/*.fth
	find fth/*.fth | sed "s/.*/m4_divert(0)m4_getsubsts(\"\`&'\")\"\`m4_dnl'\"\nm4_divert(1)\"\`m4_import(\"\`&'\")m4_dnl'\"/" | m4 -P cmacros.m4 - > words.m4

base.c: mfourth.m4.c cmacros.m4 words.m4 fth/*.fth
	m4 -Pd $< > $@

base.o: base.c 3lib.h
	$(CC) -c $(CFLAGS) $< -o $@

3lib.o: $(PLATFORM).asm
	$(ASM) $(ASMFLAGS) $< -o $@

.PHONY: clean
# Deletes all machine-generated intermediate files.
clean:
	rm -f base.c words.m4 *.o

.PHONY: cleaner
# Deletes all machine-generated files.
cleaner: clean
	rm -f a.out

.PHONY: cleanest
# Deletes all machine-generated files, backups, and undo files.
cleanest: cleaner
	rm -f .*~ *~ */.*~ */*~
