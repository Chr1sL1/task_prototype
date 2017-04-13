#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define U_STACK_SIZE	(1024 * 1024)	
//#define run_task(tsk)	(asm_run_task(tsk))
//#define yield_task(tsk)	(asm_yield_task(tsk))


struct reg_values
{
	unsigned long rax;
	unsigned long rbx;
	unsigned long rcx;
	unsigned long rdx;
	unsigned long rsi;
	unsigned long rdi;
	unsigned long rsp;
	unsigned long rbp;
	unsigned long rip;

	unsigned long r8;
	unsigned long r9;
	unsigned long r10;
	unsigned long r11;
	unsigned long r12;
	unsigned long r13;
	unsigned long r14;
	unsigned long r15;
};

typedef void (*task_function)(void*);

enum U_TASK_STATE
{
	utsInvalid,
	utsReady,
	utsRunning,
	utsWaiting,

	utsTotal,
};

struct u_task
{
	void* _stack;
	long _stack_size;
	task_function _func;
	long _task_state;
	void* _next_instruction;
	void* _ret_addr;
	long _state_flag;

	struct reg_values _saved_regs;
};

// asm functions:
void asm_run_task(struct u_task* tsk);
void asm_yield_task(struct u_task* tsk);
void asm_resume_task(struct u_task* tsk);
void asm_save_regs(struct reg_values* p);
void asm_load_regs(struct reg_values* p);

//

void init_task(struct u_task* tsk);
void run_task(struct u_task* tsk)
{
	asm_run_task(tsk);
	tsk->_task_state = utsRunning;
}
void yield_task(struct u_task* tsk)
{
	asm_yield_task(tsk);
	tsk->_task_state = utsWaiting;
}

void resume_task(struct u_task* tsk)
{
	asm_resume_task(tsk);
}

void test_task_func(void* param)
{
	struct u_task* tsk = (struct u_task*)param;
	printf("hello world.\n");
	yield_task(tsk);
	printf("resumed.\n");
}

int main ( int argc, char *argv[] )
{
	struct u_task* tsk = (struct u_task*)malloc(sizeof(struct u_task));
	memset(tsk, 0, sizeof(struct u_task));

	tsk->_stack = malloc(U_STACK_SIZE);
	tsk->_stack_size = U_STACK_SIZE;
	tsk->_func = test_task_func;

	run_task(tsk);

	for(int i = 0; i < 10; i++)
	{
		printf("%d\n", i);
		sleep(1);
	}

	printf("end of the test.\n");

	free(tsk->_stack);
	free(tsk);

	return 0;
}
