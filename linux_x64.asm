	section .bss
cb:	resb 1

	section .text
	global bye
bye:
	mov	eax, 60
	xor	rdi, rdi
	syscall

	global tx
tx:
	mov	eax, 1
	mov	rsi, cb 
	mov	byte [rsi], dil
	mov	edi, 1
	mov	edx, 1
	syscall
	ret

	global rx
rx:
	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, cb
	mov	edx, 1
	syscall
	movzx	eax, byte [rsi]
	ret
