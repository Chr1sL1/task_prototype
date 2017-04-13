	.text
	.globl	asm_load_regs
	.type	asm_load_regs, @function
asm_load_regs:
.LFB0:
	.cfi_startproc
#put code from here:
	movq	(%rdi), %rax
#	movq	8(%rdi), %rbx
	movq	16(%rdi), %rcx
	movq	24(%rdi), %rdx
	movq	32(%rdi), %rsi
	movq	40(%rdi), %rdi
	movq	48(%rdi), %rax
	movq	56(%rdi), %rbp

	movq	72(%rdi), %r8
	movq	80(%rdi), %r9
	movq	88(%rdi), %r10
	movq	96(%rdi), %r11
#	movq	104(%rdi), %r12
#	movq	112(%rdi), %r13
#	movq	120(%rdi), %r14
#	movq	128(%rdi), %r15

	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_load_regs, .-asm_load_regs
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
