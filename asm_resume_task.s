	.text
	.globl	asm_resume_task
	.type	asm_resume_task, @function
asm_resume_task:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbx

	addq	$72, %rdi

	movq	(%rdi), %rax
	movq	16(%rdi), %rcx
	movq	24(%rdi), %rdx
	movq	32(%rdi), %rsi
	movq	40(%rdi), %rdi
	movq	48(%rdi), %rdx		# temp save %rsp in rdx
	movq	56(%rdi), %rbp

	movq	72(%rdi), %r8
	movq	80(%rdi), %r9
	movq	88(%rdi), %r10
	movq	96(%rdi), %r11

	movq	32(%rbx), %r9

	orq		$2, 48(%rbx)
	movq	48(%rbx), %rcx

	popq	%rbx
	popq	%rbp

	movq	%rdx, %rsp
	jmp		*%r9		# jump to asm_yield_task: nop

	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_resume_task, .-asm_resume_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
