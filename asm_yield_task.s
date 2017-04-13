	.text
	.globl	asm_yield_task
	.type	asm_yield_task, @function
asm_yield_task:
.LFB0:
	.cfi_startproc
# must be called from usr stack
# put code here:
	pushq	%rbp
	pushq	%rbx

#create resume pos:
	movq	%rdi, %rbx
	movq	48(%rbx), %rcx

	leaq	0x0(%rip), %r8
	nop							# jump from asm_resume_task

	andq	$2, %rcx
	testq	%rcx, %rcx
	jne		.ASM_YIELD_TASK_RESUME_POS

	movq	%r8, 56(%rbx)
#
	addq	$72, %rdi

	movq	%rax, (%rdi)
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

#	movq	%rbx, 8(%rdi)
#	movq	%r12, 104(%rdi)
#	movq	%r13, 112(%rdi)
#	movq	%r14, 120(%rdi)
#	movq	%r15, 128(%rdi)

	leaq	0x0(%rip), %r8
	nop

	orq		$1, 48(%rbx)		# jump to run_task
	movq	32(%rbx), %r9
	movq	%r8, 32(%rbx)

	popq	%rbx
	popq	%rbp

	movq	40(%rbx), %rsp
	jmp		*%r9

.ASM_YIELD_TASK_RESUME_POS:
	popq	%rbx
	popq	%rbp

	ret
	.cfi_endproc
.LFE0:
	.size	asm_yield_task, .-asm_yield_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
