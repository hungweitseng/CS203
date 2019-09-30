#include <stdio.h>
#include <stdlib.h>
#include "mysort.h"
#include <fcntl.h>
#include <string.h>
#include <math.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctime>
#include <string>
#include "CL/opencl.h"
#include "AOCL_Utils.h"
using namespace aocl_utils;
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 1;
cl_device_id device; // num_devices elements
cl_context context = NULL;
cl_command_queue queue; // num_devices elements
cl_program program = NULL;
cl_kernel kernel; // num_devices elements
cl_mem buffer;

bool init_opencl();
cl_program build_program(cl_context ctx, cl_device_id dev, const char* filename);


int fpga_sort(int num_of_elements, float *data)
{
    init_opencl();
	
    return 0;
}

// Initializes the OpenCL objects.
bool init_opencl() {
  int err;
  cl_int status;

  clGetPlatformIDs(1, &platform, NULL);

  err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
  if (err != CL_SUCCESS) {
	  fprintf(stderr, "Error: Failed to create a device group!\n");
	  return EXIT_FAILURE;
  }

  context = clCreateContext(NULL, 1, &device, NULL, NULL, &status);
  checkError(status, "Failed to create context");

  program = build_program(context, device, "fpgasort.cl");

  kernel = clCreateKernel(program, "fpgasort", &err);
  checkError(err, "Failed to create kernel");
}

void cleanup() {
	clReleaseKernel(kernel);
	clReleaseMemObject(buffer);
	clReleaseCommandQueue(queue);
	clReleaseProgram(program);
	clReleaseContext(context);
}

/* Create program from a file and compile it */
cl_program build_program(cl_context ctx, cl_device_id dev, const char* filename) {

	cl_program program;
	FILE *program_handle;
	char *program_buffer, *program_log;
	size_t program_size, log_size;
	int err;

	/* Read program file and place content into buffer */
	program_handle = fopen(filename, "r");
	if (program_handle == NULL) {
		perror("Couldn't find the program file");
		exit(1);
	}
	fseek(program_handle, 0, SEEK_END);
	program_size = ftell(program_handle);
	rewind(program_handle);
	program_buffer = (char*)malloc(program_size + 1);
	program_buffer[program_size] = '\0';
	fread(program_buffer, sizeof(char), program_size, program_handle);
	fclose(program_handle);

	/* Create program from file */
	program = clCreateProgramWithSource(ctx, 1,
		(const char**)&program_buffer, &program_size, &err);
	checkError(err, "Failed to create program");
	free(program_buffer);

	/* Build program */
	err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
	checkError(err, "Failed to build program");

	return program;
}