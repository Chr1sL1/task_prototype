	.text
	.globl	asm_run_task
	.type	asm_run_task, @function
asm_run_task:
.LFB0:
	.cfi_startproc
	push	%rbp
	push	%rbx
	movq	%rsp, %rbp
	movq	%rdi, %rbx

#fetch and save %rip
	movq	%rsp, 40(%rbx)
	leaq	0x0(%rip), %rdi
	movq	%rdi, 32(%rbx)
#
# check state_flag to jmp out
	movq	48(%rbx), %rsi
	andq	$1, %rsi
	testq	%rsi, %rsi
	jne		.ASM_RUN_TASK_END
#

	movq	(%rbx), %rdx
	movq	8(%rbx), %rsi			# %rsi: stack size
	leaq	(%rdx, %rsi, 1), %rsp	# move rsp to the stack top
#run under usr stack:
	push	%rbp
	pushfq
	movq	%rbx, %rdi
	call	*16(%rbx)				# call task function
	popfq
	pop		%rbp
#run under usr stack over. recover original stack:
	movq	%rbp, %rsp
.ASM_RUN_TASK_END:
	pop		%rbx
	pop		%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_run_task, .-asm_run_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
