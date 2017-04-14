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
	utsFinish,

	utsTotal,
};

struct u_task
{
	void* _stack;
	long _stack_size;
	task_function _func;
	long _task_state;
	void* _yield_pos;
	void* _next_rsp;
	long _jmp_flag;
	void* _resume_pos;
	void* _resume_running_pos;

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

}
void yield_task(struct u_task* tsk)
{
	asm_yield_task(tsk);
}

void resume_task(struct u_task* tsk)
{
	asm_resume_task(tsk);
}

void test_task_func(void* param)
{
	struct u_task* tsk = (struct u_task*)param;
	for(int i = 1000; i < 1100; i++)
	{
		printf("%d\n", i);
		if(i % 3 == 0)
			yield_task(tsk);
		sleep(1);
	}
}

int main ( int argc, char *argv[] )
{
	struct u_task* tsk = (struct u_task*)malloc(sizeof(struct u_task));
	memset(tsk, 0, sizeof(struct u_task));

	tsk->_stack = malloc(U_STACK_SIZE);
	tsk->_stack_size = U_STACK_SIZE;
	tsk->_func = test_task_func;

	asm_run_task(tsk);

	for(int i = 0; i < 100; i++)
	{
		printf("%d\n", i);
		if(i % 2 == 0)
			resume_task(tsk);
		sleep(1);
	}

	printf("end of the test.\n");

	free(tsk->_stack);
	free(tsk);

	return 0;
}
