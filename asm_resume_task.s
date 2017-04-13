	.text
	.globl	asm_resume_task
	.type	asm_resume_task, @function
asm_resume_task:
.LFB0:
	.cfi_startproc
	pushq	%rbx
	movq	%rdi, %rbx

	addq	$72, %rdi
	call	asm_load_regs
	movq	56(%rbx), %r9
	movq	%rbx, %rdi
	popq	%rbx
	orq		$2, 48(%rdi)
	movq	48(%rdi), %rcx
	leaq	8(%rax), %rsp
	jmp		*%r9		# jump to asm_yield_task: nop

	popq	%rbx
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_resume_task, .-asm_resume_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
