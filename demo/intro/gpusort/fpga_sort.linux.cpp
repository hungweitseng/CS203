#include <stdio.h>
#include <stdlib.h>
#include "mysort.h"
#include "CL/opencl.h"
#include "AOCL_Utils.h"

////////
// Setup file for you Linux users in class. All hail tux.
//
// Compile using the following command:
//   g++ ./common/src/AOCL_Utils.cpp pthread_sort.cpp fpga_sort.cpp mysort.cpp -o mysort -pthread -lm -O3 -g -I./common/inc -lOpenCL
//
// I am using Arch Linux as my OS. If you are using Ubuntu/Debian
// derived distro, please google to find the right package for your OpenCL drivers.
//
// Please use the following link to install appropriate OpenCL drivers:
//   https://wiki.archlinux.org/index.php/GPGPU
////////

using namespace aocl_utils;

// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 0;
scoped_array<cl_device_id> device; // num_devices elements
cl_context context = NULL;
scoped_array<cl_command_queue> queue; // num_devices elements
cl_program program = NULL;
scoped_array<cl_kernel> kernel; // num_devices elements
cl_int status; // error code checking

bool init_opencl();

int fpga_sort(int num_of_elements, float *data)
{
  init_opencl();

  // Allocate buffer on device and migrate data
  // device_array = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
  //   num_of_elements, data, &status);

  return 0;
}

// Initializes the OpenCL objects.
bool init_opencl() {
  printf("Initializing OpenCL\n");

  if(!setCwdToExeDir()) {
    return false;
  }

  // Query the available OpenCL device.
  device.reset(getDevices(platform, CL_DEVICE_TYPE_ALL, &num_devices));
  printf("Platform: %s\n", getPlatformName(platform).c_str());
  printf("Using %d device(s)\n", num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    printf("  %s\n", getDeviceName(device[i]).c_str());
  }

  // Create the context.
  context = clCreateContext(NULL, num_devices, device, NULL, NULL, &status);
  checkError(status, "Failed to create context");

  // Create the program for all device. Use the first device as the
  // representative device (assuming all device are of the same type).
  
  // Read the file in from source
  FILE* program_handle = fopen("fpgasort.cl", "r");
  if(program_handle == NULL) {
    perror("Couldn't find the program file");
    exit(1);
  }
  fseek(program_handle, 0, SEEK_END);
  size_t program_size = ftell(program_handle);
  rewind(program_handle);
  char *program_buffer = (char*)malloc(program_size + 1);
  program_buffer[program_size] = '\0';
  fread(program_buffer, sizeof(char), program_size, program_handle);
  fclose(program_handle);

  // Create a program from the kernel source file
  program = clCreateProgramWithSource(context, 1, (const char**)&program_buffer, &program_size, &status);
  checkError(status, "Failed to create program");

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
  checkError(status, "Failed to build program");

  // Create per-device objects.
  queue.reset(num_devices);
  kernel.reset(num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    // Command queue.
    queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
    checkError(status, "Failed to create command queue");

    // Kernel.
    const char *kernel_name = "fpgasort";
    kernel[i] = clCreateKernel(program, kernel_name, &status);
    checkError(status, "Failed to create kernel");

  }

  return true;
}

void cleanup() {
  for(unsigned i = 0; i < num_devices; ++i) {
    if(kernel && kernel[i]) {
      clReleaseKernel(kernel[i]);
    }
    if(queue && queue[i]) {
      clReleaseCommandQueue(queue[i]);
    }
  }

  if(program) {
    clReleaseProgram(program);
  }
  if(context) {
    clReleaseContext(context);
  }
}

