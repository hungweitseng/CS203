#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <sys/time.h>
#include "mysort.h"

int compare_function(const void *a, const void *b) {
	if(*((float *)a) < *((float *)b)) return -1; 
	else if(*((float *)a) > *((float *)b)) return 1; 
	else return 0; 
}

int
main( int argc, char** argv)
{ 

  // Create timers for each sort
    struct timeval time_start, time_end, program_start, program_end;
    int mode=0,i,num_bytes_read;
    FILE *fp;
    int mem_size,numElements;
    float *input_data,*output_data;
    gettimeofday(&program_start, NULL);	

    gettimeofday(&time_start, NULL);
    if(argc < 3)
    {
    	fprintf(stderr,"Usage: %s input_file number_of_elements mode\n",argv[0]);        
    }
    numElements = atoi(argv[2]);
    fp = fopen(argv[1],"rb");
    if(argc == 4)
        mode = atoi(argv[3]);
        
    if(fp == NULL) {
    	fprintf(stderr,"Cannot open %s\n",argv[1]);
	exit(EXIT_FAILURE);
    }
    int count = 0;
    float c;

    fprintf(stderr, "Sorting list of %d floats\n",numElements);
	// Memory space the list of random floats will take up
    mem_size = numElements * sizeof(float); 
	// Allocate enough for the input list
    input_data = (float *)malloc(mem_size);
    output_data = (float *)malloc(mem_size);
    num_bytes_read = fread(input_data,sizeof(float),numElements,fp);
    fclose(fp);
    gettimeofday(&time_end, NULL);
    fprintf(stderr,"FileInput: %ld\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
    gettimeofday(&time_start, NULL);
    memcpy(output_data, input_data, mem_size);
    gettimeofday(&time_end, NULL);
    fprintf(stderr,"memcpy: %ld\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
    switch(mode)
    {
        case 1:
            gettimeofday(&time_start, NULL);
            fpga_sort(numElements, output_data, 1);
            gettimeofday(&time_end, NULL);
            fprintf(stderr,"Sorting in quicksort: %ld\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
            break;
        case 2:
            gettimeofday(&time_start, NULL);
            fpga_sort(numElements, output_data, 2);
            gettimeofday(&time_end, NULL);
            fprintf(stderr,"Sorting in bitonic sort: %ld\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
            break;
        default:
            gettimeofday(&time_start, NULL);
            qsort(output_data, numElements, sizeof(float), compare_function);
            gettimeofday(&time_end, NULL);
            fprintf(stderr,"Sorting on single-core: %ld\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
            break;
    }
/*    for(i = 0 ; i < numElements; i++)
        printf("%f ",input_data[i]);
        printf("\n");
    for(i = 0 ; i < numElements; i++)
        printf("%f ",output_data[i]);
        printf("\n");*/
/*    fprintf(stderr,"Verifying Result\n");
            gettimeofday(&time_start, NULL);
    qsort(input_data, numElements, sizeof(float), compare_function);         
            gettimeofday(&time_end, NULL);
            fprintf(stderr,"Sorting on single-core: %ld\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
//    for(i = 0 ; i < numElements; i++)
//        printf("%f ",input_data[i]);
        printf("\n");
    for(i = 0 ; i < numElements; i++)
    {
//        printf("%f ",output_data[i]);
        if(output_data[i] != input_data[i])
        {
//            printf("\n%f v.s. %f\n",input_data[i], output_data[i]);
            break;
        }
    }
    if(i != numElements)
        fprintf(stderr,"Failed at %d\n",i);
    else
        fprintf(stderr,"Pass\n");
*/ 
    gettimeofday(&program_end, NULL);
    free(input_data); 
    free(output_data); 
}
