#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <xmmintrin.h>
#include <x86intrin.h>
#include <sys/time.h>
#include <pthread.h>
#include "myblockmm.h"
#include "baseline.h"

void blockmm(double **a, double **b, double **c, int ARRAY_SIZE, int n);
void vector_blockmm(double **a, double **b, double **c, int ARRAY_SIZE, int n);

int main(int argc, char **argv)
{
  double **a, **b, **c, **c_correct;
  int i, j, k;
  double grade=100.0;
  struct timeval time_start, time_end;
  pthread_t *thread;
  struct thread_info *tinfo;
  double baseline, improved;
  int number_of_threads = 4;
  int n=128;
  int ARRAY_SIZE=1024;
  /* initialize a, b */
  if(argc == 2)
    ARRAY_SIZE = atoi(argv[1]);
  if(argc == 3)
  {
    ARRAY_SIZE = atoi(argv[1]);
    n = atoi(argv[2]);
  }
  if(argc == 4)
  {
    ARRAY_SIZE = atoi(argv[1]);
    n = atoi(argv[2]);
    number_of_threads = atoi(argv[3]);
  }
  // Initializing matrices
  a = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    a[i] = (double *)_mm_malloc(ARRAY_SIZE*sizeof(double),256);
    for(j = 0; j < ARRAY_SIZE; j++)
      a[i][j] = i+j;
  }
  b = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    b[i] = (double *)_mm_malloc(ARRAY_SIZE*sizeof(double),256);
    for(j = 0; j < ARRAY_SIZE; j++)
      b[i][j] = i+j;
  }
  c = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    c[i] = (double *)_mm_malloc(ARRAY_SIZE*sizeof(double),256);
    for(j = 0; j < ARRAY_SIZE; j++)
      c[i][j] = 0;
  }
  c_correct = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    c_correct[i] = (double *)_mm_malloc(ARRAY_SIZE*sizeof(double),256);
    for(j = 0; j < ARRAY_SIZE; j++)
      c_correct[i][j] = 0;
  }
  // Baseline blockmm
  gettimeofday(&time_start, NULL);
  baseline_threaded_vector_blockmm(a, b, c, ARRAY_SIZE, n, number_of_threads);
  gettimeofday(&time_end, NULL);
  baseline = ((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec))/1000000.0;
  fprintf(stderr,"Naively Threaded Vectorized Block MM Takes: %lf\n",baseline);

  for(i = 0; i < ARRAY_SIZE; i++)
  {
    c[i] = (double *)_mm_malloc(ARRAY_SIZE*sizeof(double),256);
    for(j = 0; j < ARRAY_SIZE; j++)
      c[i][j] = 0;
  }
  // Calling your blockmm  
  gettimeofday(&time_start, NULL);
  my_threaded_vector_blockmm(a, b, c, n, ARRAY_SIZE, number_of_threads);
  gettimeofday(&time_end, NULL);
  improved = ((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec))/1000000.0;
  fprintf(stderr,"My Vectorized Multithreaded Block MM Takes: %lf\n",improved);
  n = 128;
  blockmm(a, b, c_correct, ARRAY_SIZE, n);
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    for(j = 0; j < ARRAY_SIZE; j++)
    {
      if(c[i][j]!=c_correct[i][j])
      {
        printf("Verification Failed!\n");
        return 1;
      }
    }
  }
  printf("Verification Passed!\n");
  fprintf(stderr,"Speedup: %lf\n",baseline/improved);
  if(20+40*baseline/improved < grade)
    grade = 20+40*baseline/improved;
  fprintf(stderr,"Score: %s\t%s\t%lf\n",name, SID, grade);
  /* Output matrix multiplication */
  return 0;
}

void blockmm(double **a, double **b, double **c, int ARRAY_SIZE, int n)
{
  int i,j,k, ii, jj, kk;
  for(i = 0; i < ARRAY_SIZE; i+=(ARRAY_SIZE/n))
  {
    for(j = 0; j < ARRAY_SIZE; j+=(ARRAY_SIZE/n))
    {
      for(k = 0; k < ARRAY_SIZE; k+=(ARRAY_SIZE/n))
      {        
          for(ii = i; ii < i+(ARRAY_SIZE/n); ii++)
            for(jj = j; jj < j+(ARRAY_SIZE/n); jj++)
              for(kk = k; kk < k+(ARRAY_SIZE/n); kk++)
                c[ii][jj] += a[ii][kk]*b[kk][jj];
      }
    }
  }  
}

