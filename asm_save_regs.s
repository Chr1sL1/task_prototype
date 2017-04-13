	.text
	.globl	asm_save_regs
	.type	asm_save_regs, @function
asm_save_regs:
.LFB0:
	.cfi_startproc
#put codes here:
	movq	%rax, (%rdi)
	movq	%rbx, 8(%rdi)
	movq	%rcx, 16(%rdi)
	movq	%rdx, 24(%rdi)
	movq	%rsi, 32(%rdi)
	movq	%rdi, 40(%rdi)
	movq	%rsp, 48(%rdi)
	movq	%rbp, 56(%rdi)

	movq	%r8, 72(%rdi)
	movq	%r9, 80(%rdi)
	movq	%r10, 88(%rdi)
	movq	%r11, 96(%rdi)
	movq	%r12, 104(%rdi)
	movq	%r13, 112(%rdi)
	movq	%r14, 120(%rdi)
	movq	%r15, 128(%rdi)

	ret
	.cfi_endproc
.LFE0:
	.size	asm_save_regs, .-asm_save_regs
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
