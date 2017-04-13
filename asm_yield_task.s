	.text
	.globl	asm_yield_task
	.type	asm_yield_task, @function
asm_yield_task:
.LFB0:
	.cfi_startproc
#put code here:
	push	%rbx
	movq	%rdi, %rbx
	addq	$56, %rdi
	call	asm_save_regs
	orq		$1, 48(%rbx)
	movq	32(%rbx), %rdi
	pop		%rbx
	movq	40(%rbx), %rsp
	jmp		*%rdi
	ret
	.cfi_endproc
.LFE0:
	.size	asm_yield_task, .-asm_yield_task
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
