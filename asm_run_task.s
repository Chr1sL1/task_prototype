	.text
	.globl	asm_run_task
	.type	asm_run_task, @function
asm_run_task:
.LFB0:
	.cfi_startproc

	subq	$8, %rsp
	movq	%rdi, (%rsp)

	movq	%rsp, %r9

	movq	(%rdi), %rdx
	movq	8(%rdi), %rsi			# %rsi: stack size
	leaq	(%rdx, %rsi, 1), %rsp	# move rsp to the stack top

#run under usr stack:
	pushq	%r9			# push original rsp in usr stack
	subq	$8, %rsp
	movq	%rdi, (%rsp)

	leaq	0x0(%rip), %r8
	nop					###1

	movq	(%rsp), %rdi

	movq	48(%rdi), %rcx
	andq	$1, %rcx
	testq	%rcx, %rcx
	jne		.ASM_RUN_TASK_YIELD_OVER

	movq	%r8, 56(%rdi)
	movq	%rsp, 40(%rdi)
	call	*16(%rdi)				# call task function
.ASM_RUN_TASK_YIELD_OVER:

	movq	(%rsp), %rdi
	andq	$-2, 48(%rdi)

	addq	$8, %rsp
	popq	%rsp					# restore original rsp
#

	addq	$8, %rsp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_run_task, .-asm_run_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
