// Name: 
// Student ID #:
#include <unistd.h>
#include <pthread.h>
#include <stdlib.h>
#include "mcfutil.h"
#include "helper.h"


void atomic_increment(volatile int *pw)
{
             asm("mfence\n\t"
                 "lock\n\t"
                 "incl %0\n\t"
                 "mfence":
                 "=m"(*pw): // output (%0)
                 "m"(*pw): // input (%1)
                 "cc" // clobbers
                 );
}

void atomic_decrement(volatile int *pw)
{
             asm("mfence\n\t"
                 "lock\n\t"
                 "decl %0\n\t"
                 "mfence":
                 "=m"(*pw): // output (%0)
                 "m"(*pw): // input (%1)
                 "cc" // clobbers
                 );
}

int atomic_compare_and_exchange(int requiredOldValue, volatile int* _ptr, int newValue, int sizeOfValue)
{
      int old;
      __asm volatile
      (
      "mov %3, %%eax;\n\t"
      "lock\n\t"
      "cmpxchg %4, %0\n\t"
      "mov %%eax, %1\n\t"
      :
      "=m" ( *_ptr ), "=r" ( old  ): // outputs (%0 %1)
      "m" ( *_ptr ), "r" ( requiredOldValue), "r" ( newValue ): // inputs (%2, %3, %4)
      "memory", "eax", "cc" // clobbers
      );
                                                                                          
      return old;
}

void helper_thread_sync()
{
    return;
}

void *helper_thread(void *x)
{
    return NULL;
}
