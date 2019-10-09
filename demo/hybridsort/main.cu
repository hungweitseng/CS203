#ifdef _WIN32
#  define WINDOWS_LEAN_AND_MEAN
#  define NOMINMAX
#  include <windows.h>
#endif
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include "helper_cuda.h"
#include "helper_timer.h"
#include <iostream>
#include <sys/time.h>
#include "bucketsort.cuh"
#include "mergesort.cuh"

using namespace std; 

////////////////////////////////////////////////////////////////////////////////
// Size of the testset (Bitwise shift of 1 over 22 places)
////////////////////////////////////////////////////////////////////////////////
#define SIZE	(1 << 22)
////////////////////////////////////////////////////////////////////////////////
// Number of tests to average over
////////////////////////////////////////////////////////////////////////////////
#define TEST	1
////////////////////////////////////////////////////////////////////////////////
// The timers for the different parts of the algo
////////////////////////////////////////////////////////////////////////////////
StopWatchInterface  *uploadTimer, *downloadTimer, *bucketTimer, 
			 *mergeTimer, *totalTimer, *cpuTimer; 
////////////////////////////////////////////////////////////////////////////////
// Compare method for CPU sort
////////////////////////////////////////////////////////////////////////////////
inline int compare(const void *a, const void *b) {
	if(*((float *)a) < *((float *)b)) return -1; 
	else if(*((float *)a) > *((float *)b)) return 1; 
	else return 0; 
}
////////////////////////////////////////////////////////////////////////////////
// Forward declaration
////////////////////////////////////////////////////////////////////////////////
void cudaSort(float *origList, float minimum, float maximum,
			  float *resultList, int numElements);

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////

#ifdef GPUD
#ifdef THREADED
    #ifdef DRAM 
    #define NVMED_INIT(a)	nvmed_init(6)
    #define NVMED_SEND(a,b,c,d) nvmed_host_pipeline_send(a, b, c, d, NULL)
    #define NVMED_RECV(a,b,c,d) nvmed_host_pipeline_recv(a,b,c,d)
    #else
    #define NVMED_INIT(a)	nvmed_init(6)
    #define NVMED_SEND(a,b,c,d) nvmed_send_threaded(a,b,c,d)
    #define NVMED_RECV(a,b,c,d) nvmed_recv_threaded(a,b,c,d)
    #endif
#else
#define NVMED_INIT(a)	nvmed_init(a)
#define NVMED_SEND(a,b,c,d) nvmed_send(a,b,c,d)
#define NVMED_RECV(a,b,c,d) nvmed_recv(a,b,c,d)
#endif
#endif

int
main( int argc, char** argv)
{ 

  // Create timers for each sort
    struct timeval time_start, time_end, program_start, program_end;
    gettimeofday(&program_start, NULL);	

    sdkCreateTimer(&uploadTimer);
    sdkCreateTimer(&downloadTimer);
    sdkCreateTimer(&bucketTimer);
    sdkCreateTimer(&mergeTimer);
    sdkCreateTimer(&totalTimer);
    sdkCreateTimer(&cpuTimer);
	int numElements = 0;
    // Number of elements in the test bed
    	gettimeofday(&time_start, NULL);
#ifdef READING_FROM_BINARY
        numElements = atoi(argv[2]);
#else
       	if(strcmp(argv[1],"r") ==0) {
	numElements = SIZE; 
	}
	else {
		FILE *fp;
	fp = fopen(argv[1],"r");
	if(fp == NULL) {
	      cout << "Error reading file" << endl;
	      exit(EXIT_FAILURE);
	      }
	int count = 0;
	float c;

	while(fscanf(fp,"%f",&c) != EOF) {
	 count++;
}
	fclose(fp);
	numElements = count;
}
#endif

	cout << "Sorting list of " << numElements << " floats\n";
	// Generate random data
	// Memory space the list of random floats will take up
	int mem_size = numElements * sizeof(float); 
	// Allocate enough for the input list
	float *cpu_idata = (float *)malloc(mem_size);
	// Allocate enough for the output list on the cpu side
	float *cpu_odata = (float *)malloc(mem_size);
	// Allocate enough memory for the output list on the gpu side
	float *gpu_odata = (float *)malloc(mem_size);

	float datamin = FLT_MAX; 
	float datamax = -FLT_MAX; 
	if(strcmp(argv[1],"r")==0) {

	for (int i = 0; i < numElements; i++) {
	// Generate random floats between 0 and 1 for the input data
		cpu_idata[i] = ((float) rand() / RAND_MAX); 
	//Compare data at index to data minimum, if less than current minimum, set that element as new minimum
		datamin = min(cpu_idata[i], datamin);
	//Same as above but for maximum
		datamax = max(cpu_idata[i], datamax);
	}
}	else {
	FILE *fp;
#ifdef READING_FROM_BINARY
	fp = fopen(argv[1],"rb");
	fread(cpu_idata,sizeof(float),numElements,fp);
	fclose(fp);
   	gettimeofday(&time_end, NULL);
	printf("FileInput %lf seconds\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec))/1000000.0);

    	gettimeofday(&time_start, NULL);	
	
/*	for(int i = 0; i < numElements; i++) {
	datamin = min(cpu_idata[i],datamin);
	datamax = max(cpu_idata[i],datamax);
	}
*/
	datamin = 0.0;
	datamax = 5.0;
//   	gettimeofday(&time_end, NULL);
//	printf("HGProfile: CPUFindMinMax %d m:%f M:%f\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)),datamin, datamax);
#else
	fp = fopen(argv[1],"r");
	for(int i = 0; i < numElements; i++) {
	fscanf(fp,"%f",&cpu_idata[i]);
	datamin = min(cpu_idata[i],datamin);
	datamax = max(cpu_idata[i],datamax);
	}
	fclose(fp);
   	gettimeofday(&time_end, NULL);
	printf("FileInput %lf seconds\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec))/1000000.0);
    	gettimeofday(&time_start, NULL);	
#endif
	}
#ifndef CPU
	cout << "Sorting on GPU..." << flush; 
	// GPU Sort

	for (int i = 0; i < TEST; i++) 
		cudaSort(cpu_idata, datamin, datamax, gpu_odata, numElements);		
#endif

#ifdef VERIFY
	cout << "Sorting on CPU..." << flush; 
	// CPU Sort
	sdkStartTimer(&cpuTimer); 

	memcpy(cpu_odata, cpu_idata, mem_size);
        qsort(cpu_odata, numElements, sizeof(float), compare);
	sdkStopTimer(&cpuTimer); 
	cout << "done.\n";
/*	cout << "Checking result..." << flush; 
	// Result checking
	int count = 0; 
	for(int i = 0; i < numElements; i++)
		if(cpu_odata[i] != gpu_odata[i])
		{
			printf("Sort missmatch on element %d: \n", i); 
			printf("CPU = %f : GPU = %f\n", cpu_odata[i], gpu_odata[i]); 
			count++; 
			break; 
		}
	if(count == 0) cout << "PASSED.\n";
	else cout << "FAILED.\n";*/
#endif
	// Timer report
	printf("GPU iterations: %d\n", TEST); 
#ifdef TIMER
#ifdef VERIFY
	printf("Total CPU execution time: %lf seconds\n", sdkGetTimerValue(&cpuTimer)/1000);
#endif
#ifndef CPU
	printf("Total GPU execution time: %lf seconds\n", sdkGetTimerValue(&totalTimer) /1000);
	printf("    - Upload		: %lf seconds\n", sdkGetTimerValue(&uploadTimer) /1000);
	printf("    - Download		: %lf seconds\n", sdkGetTimerValue(&downloadTimer) /1000);
	printf("    - Bucket sort	: %lf seconds\n", sdkGetTimerValue(&bucketTimer) /1000);
	printf("    - Merge sort	: %lf seconds\n", sdkGetTimerValue(&mergeTimer) /1000);
#endif
#endif

#ifdef OUTPUT
    FILE *tp;
    const char filename2[]="./hybridoutput.txt";
    tp = fopen(filename2,"w");
    for(int i = 0; i < numElements; i++) {
        fprintf(tp,"%f ",cpu_idata[i]);
    }
    
    fclose(tp);
#endif
	
	// Release memory
   	gettimeofday(&program_end, NULL);
	printf("HGProfile: Total %lf\n",((program_end.tv_sec * 1000000 + program_end.tv_usec) - (program_start.tv_sec * 1000000 + program_start.tv_usec))-sdkGetTimerValue(&cpuTimer)/1000);
    sdkDeleteTimer(&uploadTimer);
    sdkDeleteTimer(&downloadTimer);
    sdkDeleteTimer(&bucketTimer);
    sdkDeleteTimer(&mergeTimer);
    sdkDeleteTimer(&totalTimer);
    sdkDeleteTimer(&cpuTimer);
#ifndef GPUD
	free(cpu_idata); 
#endif
	free(cpu_odata); free(gpu_odata); 
#ifdef GPUD
//	nvmed_deinit();
#endif
}


void cudaSort(float *origList, float minimum, float maximum,
			  float *resultList, int numElements)
{
	// Initialization and upload data
//    struct timeval time_start, time_end;
	float *d_input  = NULL; 
	float *d_output = NULL; 
	int mem_size = (numElements + DIVISIONS * 4) * sizeof(float); 
//   	gettimeofday(&time_start, NULL);
	sdkStartTimer(&uploadTimer);
	{

		cudaMalloc((void**) &d_output, mem_size);
#ifdef GPUD
	#if TEST > 1
 	        cudaMalloc((void**) &d_input, mem_size);
		cudaMemcpy((void *) d_input, (void *)origList, numElements * sizeof(float),
				   cudaMemcpyDeviceToDevice);
//                cudaFree(origList);
	#else
                d_input=origList;
	#endif
#else
 	        cudaMalloc((void**) &d_input, mem_size);
		cudaMemcpy((void *) d_input, (void *)origList, numElements * sizeof(float),
				   cudaMemcpyHostToDevice);
#endif
		init_bucketsort(numElements);
	}
//   	gettimeofday(&time_end, NULL);
//	printf("HGProfile: cudaMemcpyHD %d\n",((time_end.tv_sec * 1000000 + time_end.tv_usec) - (time_start.tv_sec * 1000000 + time_start.tv_usec)));
	sdkStopTimer(&uploadTimer); 
    	//system("/homes/h1tseng/Gordon/PMCS/tools/powermeter/powermeter_client 0.0.0.0 \"e\" 27072");
    	//system("/homes/h1tseng/Gordon/PMCS/tools/powermeter/powermeter_client 0.0.0.0 \"b\" 27072");

	sdkStartTimer(&totalTimer); 

	// Bucketsort the list
	sdkStartTimer(&bucketTimer); 
		int *sizes = (int*) malloc(DIVISIONS * sizeof(int)); 
		int *nullElements = (int*) malloc(DIVISIONS * sizeof(int));  
		unsigned int *origOffsets = (unsigned int *) malloc((DIVISIONS + 1) * sizeof(int)); 
		bucketSort(d_input, d_output, numElements, sizes, nullElements, 
				   minimum, maximum, origOffsets); 
	sdkStopTimer(&bucketTimer); 

	// Mergesort the result
	sdkStartTimer(&mergeTimer); 
		float4 *d_origList = (float4*) d_output, 
		*d_resultList = (float4*) d_input;
		int newlistsize = 0; 
	
		for(int i = 0; i < DIVISIONS; i++)
			newlistsize += sizes[i] * 4;
		
		float4 *mergeresult = runMergeSort(	newlistsize, DIVISIONS, d_origList, d_resultList, 
			sizes, nullElements, origOffsets); //d_origList; 
		cudaThreadSynchronize(); 
	sdkStopTimer(&mergeTimer); 
	sdkStopTimer(&totalTimer); 
//	fprintf(stderr, "%p %p\n",resultList, mergeresult );
	// Download result
	sdkStartTimer(&downloadTimer); 
/*		checkCudaErrors(	cudaMemcpy((void *) resultList, 
				(void *)mergeresult, numElements * sizeof(float), cudaMemcpyDeviceToHost) );*/
	sdkStopTimer(&downloadTimer); 

	// Clean up
	finish_bucketsort(); 
//#ifdef GPUD
	cudaFree(d_input); 
//#endif
	cudaFree(d_output); 
	free(nullElements); free(sizes); 
}
