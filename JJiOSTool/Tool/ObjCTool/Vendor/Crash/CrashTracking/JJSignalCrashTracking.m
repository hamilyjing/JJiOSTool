//
//  JJSignalCrashTracking.cpp
//  JJObjCTool
//
//  Created by gong jian on 12-7-12.
//  Copyright (c) 2012年 Gong jian. All rights reserved.
//

#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void dump_frames(void) 
{
	void *backtraceFrames[128];
	int frameCount = backtrace(&backtraceFrames[0], 128);
	char **frameStrings = backtrace_symbols(&backtraceFrames[0], frameCount);
	
	if(frameStrings != NULL) 
    {
		int x = 0;
		for(x = 0; x < frameCount; x++) 
        {
			if(frameStrings[x] == NULL) 
            {
                break;
            }
            
            // add log below
			//NSLog(@"%s", frameStrings[x]);
		}
		free(frameStrings);
	}
}

static void sigaction_handler(int sig, siginfo_t *info,  void *ctx) 
{
//    CSILogInfo(@"=======================sig crash call stack===================");
//	CSILogDebug(@"sig:%d", sig);
    
    // 第二次进入，恢复信号的默认处理函数
	struct sigaction mySigAction;
	memset(&mySigAction, 0, sizeof(mySigAction));
    
    /*
     sa_handler和sa_sigaction只应该有一个生效，如果想采用老的信号处理机制，就应该让sa_handler指向正确的信号处理函数； 否则应该让sa_sigaction指向正确的信号处理函数，并且让字段sa_flags包含SA_SIGINFO选项。
     */
	mySigAction.sa_handler = SIG_DFL;
    
	sigemptyset(&mySigAction.sa_mask);
	
	sigaction(SIGQUIT, &mySigAction, NULL);
	sigaction(SIGILL, &mySigAction, NULL);
	sigaction(SIGTRAP, &mySigAction, NULL);
	sigaction(SIGABRT, &mySigAction, NULL);
	sigaction(SIGEMT, &mySigAction, NULL);
	sigaction(SIGFPE, &mySigAction, NULL);
	sigaction(SIGBUS, &mySigAction, NULL);
	sigaction(SIGSEGV, &mySigAction, NULL);
	sigaction(SIGSYS, &mySigAction, NULL);
	//sigaction(SIGPIPE, &mySigAction, NULL);
	sigaction(SIGALRM, &mySigAction, NULL);
	sigaction(SIGXCPU, &mySigAction, NULL);
	sigaction(SIGXFSZ, &mySigAction, NULL);
    
	dump_frames();
    
    printf("sig = %d, pid %d\n", sig, info->si_pid); 
} 

void trackSignalCrash()
{
    struct sigaction mySigAction;
	mySigAction.sa_sigaction = sigaction_handler;
    
    /*
     SA_SIGINFO，当设定了该标志位时，表示信号附带的参数能够被传递到信号处理函数中，因此，应该为sigaction结构中的 sa_sigaction指定处理函数，而不应该为sa_handler指定信号处理函数，否则，配置该标志变得毫无意义。即使为 sa_sigaction指定了信号处理函数，假如不配置SA_SIGINFO，信号处理函数同样不能得到信号传递过来的数据，在信号处理函数中对这些信 息的访问都将导致段错误（Segmentation fault）。 
     */
	mySigAction.sa_flags = SA_SIGINFO;
    
	sigemptyset(&mySigAction.sa_mask);
	sigaction(SIGQUIT, &mySigAction, NULL);
	sigaction(SIGILL, &mySigAction, NULL);
	sigaction(SIGTRAP, &mySigAction, NULL);
	sigaction(SIGABRT, &mySigAction, NULL);
	sigaction(SIGEMT, &mySigAction, NULL);
	sigaction(SIGFPE, &mySigAction, NULL);
	sigaction(SIGBUS, &mySigAction, NULL);
	sigaction(SIGSEGV, &mySigAction, NULL);
	sigaction(SIGSYS, &mySigAction, NULL);
    
    /*
     SIGPIPE信号的默认执行动作是terminate，所以client会退出。若不想客户端退出，将信号设为SIG_IGN，交给系统处理。
     */
    //signal(SIGPIPE, SIG_IGN);
	sigaction(SIGPIPE, &mySigAction, NULL);
    
	sigaction(SIGALRM, &mySigAction, NULL);
	sigaction(SIGXCPU, &mySigAction, NULL);
	sigaction(SIGXFSZ, &mySigAction, NULL);
}

/*
 Linux的信号的种类有60多种。可以用kill -l命令查看所有的信号，每个信号的含义如下：
 1) SIGHUP:当用户退出shell时，由该shell启动的所有进程将收到这个信号，默认动作为终止进程
 2）SIGINT：当用户按下了＜Ctrl+C>组合键时，用户终端向正在运行中的由该终端启动的程序发出此信号。默认动作为终止里程。
 3）SIGQUIT：当用户按下＜ctrl+\>组合键时产生该信号，用户终端向正在运行中的由该终端启动的程序发出些信号。默认动作为终止进程。
 4）SIGILL：CPU检测到某进程执行了非法指令。默认动作为终止进程并产生core文件
 5）SIGTRAP：该信号由断点指令或其他 trap指令产生。默认动作为终止里程 并产生core文件。
 6 ) SIGABRT:调用abort函数时产生该信号。默认动作为终止进程并产生core文件。
 7）SIGBUS：非法访问内存地址，包括内存对齐出错，默认动作为终止进程并产生core文件。
 8）SIGFPE：在发生致命的运算错误时发出。不仅包括浮点运算错误，还包括溢出及除数为0等所有的算法错误。默认动作为终止进程并产生core文件。
 9）SIGKILL：无条件终止进程。本信号不能被忽略，处理和阻塞。默认动作为终止进程。它向系统管理员提供了可以杀死任何进程的方法。
 10）SIGUSE1：用户定义 的信号。即程序员可以在程序中定义并使用该信号。默认动作为终止进程。
 11）SIGSEGV：指示进程进行了无数内存访问。默认动作为终止进程并产生core文件。
 12）SIGUSR2：这是另外一个用户自定义信号 ，程序员可以在程序中定义 并使用该信号。默认动作为终止进程。1
 13）SIGPIPE：Broken pipe向一个没有读端的管道写数据。默认动作为终止进程。
 14 ) SIGALRM:定时器超时，超时的时间 由系统调用alarm设置。默认动作为终止进程。
 15）SIGTERM：程序结束信号，与SIGKILL不同的是，该信号可以被阻塞和终止。通常用来要示程序正常退出。执行shell命令Kill时，缺省产生这个信号。默认动作为终止进程。
 
 16）SIGCHLD：子进程结束时，父进程会收到这个信号。默认动作为忽略这个信号。
 
 17）SIGCONT：停止进程的执行。信号不能被忽略，处理和阻塞。默认动作为终止进程。
 
 18）SIGTTIN：停止进程的运行，但该信号可以被处理和忽略。按下＜ctrl+z>组合键发出灾个信号。默认动作为暂停进程。
 
 19）SIGTSTP：停止进程的运行，可该信号可以被处理可忽略。按下＜ctrl+z>组合键时发出这个信号。默认动作为暂停进程。
 
 21）SIGTTOU:该信号类似于SIGTTIN，在后台进程要向终端输出数据时发生。默认动作为暂停进程。
 
 22）SIGURG：套接字上有紧急数据时，向当前正在运行的进程发出些信号，报告有紧急数据到达。默认动作为忽略该信号。
 
 23）SIGXFSZ：进程执行时间超过了分配给该进程的CPU时间 ，系统产生该信号并发送给该进程。默认动作为终止进程。
 
 24）SIGXFSZ：超过文件的最大长度设置。默认动作为终止进程。
 
 25）SIGVTALRM：虚拟时钟超时时产生该信号。类似于SIGALRM，但是该信号只计算该进程占用CPU的使用时间。默认动作为终止进程。
 
 26）SGIPROF：类似于SIGVTALRM，它不公包括该进程占用CPU时间还包括执行系统调用时间。默认动作为终止进程。
 
 27）SIGWINCH：窗口变化大小时发出。默认动作为忽略该信号。
 
 28）SIGIO：此信号向进程指示发出了一个异步IO事件。默认动作为忽略。
 
 29）SIGPWR：关机。默认动作为终止进程。
 
 30）SIGSYS：无效的系统调用。默认动作为终止进程并产生core文件。
 
 31）SIGRTMIN～（64）SIGRTMAX：LINUX的实时信号，它们没有固定的含义（可以由用户自定义）。所有的实时信号的默认动作都为终止进程。
 */
