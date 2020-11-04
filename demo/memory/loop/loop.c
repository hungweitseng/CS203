#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int ARRAY_SIZE = 500;
void loop(double **a, double **b, double **c, double **d);

int main(int argc, char **argv)
{
  double **a, **b, **c, **d;
  int i, j, k;
    struct timeval time_start, time_end, program_start, program_end;
  /* initialize a, b */
  if(argc >= 2)
    ARRAY_SIZE = atoi(argv[1]);
  a = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    a[i] = (double *)malloc(ARRAY_SIZE*sizeof(double));
    for(j = 0; j < ARRAY_SIZE; j++)
      a[i][j] = i+j;
  }
  b = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    b[i] = (double *)malloc(ARRAY_SIZE*sizeof(double));
    for(j = 0; j < ARRAY_SIZE; j++)
      b[i][j] = i+j+rand()+1000;
  }
  c = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    c[i] = (double *)malloc(ARRAY_SIZE*sizeof(double));
    for(j = 0; j < ARRAY_SIZE; j++)
      c[i][j] = 1+rand();
  }
  d = (double **)malloc(ARRAY_SIZE*sizeof(double *));
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    d[i] = (double *)malloc(ARRAY_SIZE*sizeof(double));
    for(j = 0; j < ARRAY_SIZE; j++)
      d[i][j] = 0;
  }
    gettimeofday(&time_start, NULL);
  loop(a,b,c,d);
    gettimeofday(&time_end, NULL);
    printf("random in d:%lf %lf seconds\n",d[rand()%ARRAY_SIZE][rand()%ARRAY_SIZE], ((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec))/1000000.0);
  /* Do matrix multiplication */
/*  for(i = 0; i < ARRAY_SIZE; i++)
  {
    for(j = 0; j < ARRAY_SIZE; j++)
    {
      for(k = 0; k < ARRAY_SIZE; k++)
      {
        c[i][j] += a[i][k]*b[k][j];
      }
    }
  }*/  
/*
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    for(j = 0; j < ARRAY_SIZE; j++)
    {
      printf("%d ",c[i][j]);
    }
    printf("\n");
  }
*/
  return 0;
}

void loop(double **a, double **b, double **c, double **d)
{
  int i,j,k;
  #ifdef A
  for(i = 0; i < ARRAY_SIZE; i++)
  {
    for(j = 0; j < ARRAY_SIZE; j++)
    {
        a[i][j] = 1/b[i][j] * c[i][j];
    }
  }
  for (i = 0; i < ARRAY_SIZE; i = i+1)
    for (j = 0; j < ARRAY_SIZE; j = j+1)
        d[i][j] = a[i][j] + c[i][j];
  #else
  for (i = 0; i < ARRAY_SIZE; i = i+1)
    for (j = 0; j < ARRAY_SIZE; j = j+1)
    {
      a[i][j] = 1/b[i][j] * c[i][j];
         d[i][j] = a[i][j] + c[i][j];
    }
  #endif
  return;
}
