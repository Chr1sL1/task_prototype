	.text
	.globl	asm_run_task
	.type	asm_run_task, @function
asm_run_task:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	pushq	%rbx
	movq	%rdi, %rbx
	movq	%rsp, %r9

#fetch and save %rip
	leaq	0x0(%rip), %r8
	nop

	movq	48(%rbx), %rcx
	movq	%rcx, %rsi

	andq	$4, %rcx
	testq	%rcx, %rcx
	jne		.ASM_RUN_TASK_YIELD_OVER
#

# check state_flag to jmp out
	andq	$1, %rsi
	testq	%rsi, %rsi
	jne		.ASM_RUN_TASK_END
	movq	%r8, 32(%rbx)
#

	movq	(%rbx), %rdx
	movq	8(%rbx), %rsi			# %rsi: stack size
	leaq	(%rdx, %rsi, 1), %rsp	# move rsp to the stack top


#run under usr stack:
	pushq	%r9			# push original rsp in usr stack
	pushfq
	pushq	%rbp
	pushq	%rbx

	leaq	0x0(%rip), %r8
	nop

	movq	48(%rbx), %rcx
	andq	$1, %rcx
	testq	%rcx, %rcx
	jne		.ASM_RUN_TASK_YIELD_OVER

	movq	%r8, 32(%rbx)
	movq	%rbx, %rdi
	movq	%rsp, 40(%rbx)
	call	*16(%rbx)				# call task function
.ASM_RUN_TASK_YIELD_OVER:
	popq	%rbx
	popq	%rbp
	popfq
	popq	%rsp			# restore original rsp
#

.ASM_RUN_TASK_END:
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_run_task, .-asm_run_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
