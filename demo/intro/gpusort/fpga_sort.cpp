#include <stdio.h>
#include <stdlib.h>
#include "mysort.h"
#include <fcntl.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctime>
#include <string>
#ifdef APPLE
#include <OpenCL/opencl.h>
//#include "scoped_array.h"
#else
#include "CL/opencl.h"
#include "AOCL_Utils.h"
using namespace aocl_utils;
#endif
#ifdef APPLE
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 1;
cl_device_id device; // num_devices elements
cl_context context = NULL;
cl_command_queue queue; // num_devices elements
cl_program program = NULL;
cl_kernel kernel; // num_devices elements
#else
// OpenCL runtime configuration
cl_platform_id platform = NULL;
unsigned num_devices = 0;
scoped_array<cl_device_id> device; // num_devices elements
cl_context context = NULL;
scoped_array<cl_command_queue> queue; // num_devices elements
cl_program program = NULL;
scoped_array<cl_kernel> kernel; // num_devices elements
#endif

#ifdef APPLE
static int LoadTextFromFile(const char *file_name, char **result_string, size_t *string_len);
#define LOCAL_MEM_SIZE = 1024;
void _checkError(int line,
								 const char *file,
								 cl_int error,
                 const char *msg,
                 ...);

#define checkError(status, ...) _checkError(__LINE__, __FILE__, status, __VA_ARGS__)
#endif
double getCurrentTimestamp();

bool init_opencl(int mode);
void cleanup();
cl_mem gpu_input, gpu_output;

int fpga_sort(int num_of_elements, float *data, int mode)
{
  int err;                            // error code returned from api calls
  cl_int status;
    init_opencl(mode);
    int size=2;
    gpu_input = clCreateBuffer(context, CL_MEM_READ_WRITE,
        num_of_elements * sizeof(float), NULL, &err);
    gpu_output = clCreateBuffer(context, CL_MEM_READ_WRITE,
        num_of_elements * sizeof(float), NULL, &status);
    err = clEnqueueWriteBuffer(queue, gpu_input, CL_FALSE,
        0, num_of_elements * sizeof(float), data, 0, NULL, NULL);
  if (err != CL_SUCCESS)
  {  
    fprintf(stderr, "Failed to transfer buffer for output C");
    exit(1);
  }
    clFinish(queue);
    cl_event kernel_event;
    double start_time = getCurrentTimestamp();
    if(mode == 1)
    {

        int stride = 0;
        for (int k = 1; k < num_of_elements; k = 2 * k)
        {
            unsigned argi = 0;
            if (stride % 2 == 0)
            {
                status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &gpu_input);
                checkError(status, "Failed to set argument %d", argi - 1);
                
                status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &gpu_output);
                checkError(status, "Failed to set argument %d", argi - 1);
            }
            else
            {
                status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &gpu_output);
                checkError(status, "Failed to set argument %d", argi - 1);
                
                status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &gpu_input);
                checkError(status, "Failed to set argument %d", argi - 1);
            }
            status = clSetKernelArg(kernel, argi++, sizeof(int), &k);
            checkError(status, "Failed to set argument %d", argi - 1);
            
            status = clSetKernelArg(kernel, argi++, sizeof(int), &num_of_elements);
            checkError(status, "Failed to set argument %d", argi - 1);
            
            int tasks = (num_of_elements + 2 * k - 1) / (2 * k);
            size_t global_work_size[1] = {tasks};
            
            status = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, &kernel_event);
            checkError(status, "Failed to launch kernel");
            
            // wait for kernel to finish
            clFinish(queue);
            stride += 1;
        }
        
        clReleaseEvent(kernel_event);
        if (stride % 2 == 0)
        {
            status = clEnqueueReadBuffer(queue, gpu_input, CL_TRUE, 0, num_of_elements * sizeof(float), data, 0, NULL, NULL);
        }
        else
        {
            status = clEnqueueReadBuffer(queue, gpu_output, CL_TRUE, 0, num_of_elements * sizeof(float), data, 0, NULL, NULL);
        }
        checkError(status, "Failed to read output data");
        
        clFinish(queue);
        if (gpu_input)
        clReleaseMemObject(gpu_input);
        if (gpu_output)
        clReleaseMemObject(gpu_output);
    }
    else
    {
//    size = num_of_elements;
    for(size = 2 ; size <= num_of_elements; size*=2)
    {
    for (int j=size>>1; j>0; j=j>>1) 
    {
    unsigned argi = 0;
    status = clSetKernelArg(kernel, argi++, sizeof(cl_mem), &gpu_input);
    checkError(status, "Failed to set argument %d", argi - 1);
    status = clSetKernelArg(kernel, argi++, sizeof(int), &j);
    checkError(status, "Failed to set argument %d", argi - 1);
    status = clSetKernelArg(kernel, argi++, sizeof(int), &size);
    checkError(status, "Failed to set argument %d", argi - 1);
    size_t global_work_size[2] = {num_of_elements,1};
    size_t local_work_size[2]  = {64,1};
//    double t_start_time = getCurrentTimestamp();

    status = clEnqueueNDRangeKernel(queue, kernel, 2, NULL,
        global_work_size, local_work_size, 0, NULL, &kernel_event);
    checkError(status, "Failed to launch kernel");
    // Wait for all kernels to finish.
    clFinish(queue);
    clWaitForEvents(num_devices, &kernel_event);
    clReleaseEvent(kernel_event);
//    fprintf(stderr,"sorting with length %d\n",size);
//    double end_time = getCurrentTimestamp();
//    double total_time = end_time - t_start_time;

  // Wall-clock time taken.
//    fprintf(stderr,"\nKernel Time: %0.3f ms\n", total_time * 1e3);
     }
    }
    status = clEnqueueReadBuffer(queue, gpu_input, CL_TRUE,
        0, num_of_elements * sizeof(float), data, 0, NULL, NULL);
    checkError(status, "Failed to read output matrix");

   clFinish(queue);
}
  double end_time = getCurrentTimestamp();
  double total_time = end_time - start_time;

  // Wall-clock time taken.
  printf("\nTime: %0.3f ms\n", total_time * 1e3);
  cleanup();
    return 0;
}

// Initializes the OpenCL objects.
bool init_opencl(int mode) {
  int err;
  cl_int status;

  printf("Initializing OpenCL\n");
#ifdef APPLE
  int gpu = 1;
  err = clGetDeviceIDs(NULL, gpu ? CL_DEVICE_TYPE_GPU : CL_DEVICE_TYPE_CPU, 1, &device, NULL);
  if (err != CL_SUCCESS)
  {
    fprintf(stderr, "Error: Failed to create a device group!\n");
    return EXIT_FAILURE;
  }
  // Create the context.
  context = clCreateContext(NULL, 1, &device, NULL, NULL, &status);
  checkError(status, "Failed to create context");
#else 
  if(!setCwdToExeDir()) {
    return false;
  }

  // Get the OpenCL platform.
  platform = findPlatform("Altera");
 if(platform == NULL) {
   printf("ERROR: Unable to find Altera OpenCL platform.\n");
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
#endif

  // Create the program for all device. Use the first device as the
  // representative device (assuming all device are of the same type).
#ifndef APPLE
  std::string binary_file = getBoardBinaryFile("fpgasort", device[0]);
  printf("Using AOCX: %s\n", binary_file.c_str());
  program = createProgramFromBinary(context, binary_file.c_str(), device, num_devices);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, "", NULL, NULL);
  checkError(status, "Failed to build program");

  //Create per-device objects.
  queue.reset(num_devices);
  kernel.reset(num_devices);
  for(unsigned i = 0; i < num_devices; ++i) {
    // Command queue.
    queue[i] = clCreateCommandQueue(context, device[i], CL_QUEUE_PROFILING_ENABLE, &status);
    checkError(status, "Failed to create command queue");

    // Kernel.
    const char *kernel_name = "bitonicsort";
    kernel[i] = clCreateKernel(program, kernel_name, &status);
    checkError(status, "Failed to create kernel");

  }
#else
  char *source = 0;
  size_t length = 0;
    if(mode == 1)
    {
        LoadTextFromFile("mergesort.cl", &source, &length);
        const char *kernel_name = "mergesort";
        program = clCreateProgramWithSource(context, 1, (const char **) & source, NULL, &err);
        
        // Build the program that was just created.
        status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
        checkError(status, "Failed to build program");
        
        queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
        kernel = clCreateKernel(program, kernel_name, &status);
    }
    else
    {
  LoadTextFromFile("bitonicsort.cl", &source, &length);
  const char *kernel_name = "bitonicsort";
  program = clCreateProgramWithSource(context, 1, (const char **) & source, NULL, &err);

  // Build the program that was just created.
  status = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
  checkError(status, "Failed to build program");

  queue = clCreateCommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &status);
  kernel = clCreateKernel(program, kernel_name, &status);
    }
#endif
  return true;
}

void cleanup() {
#ifndef APPLE
  for(unsigned i = 0; i < num_devices; ++i) {
    if(kernel && kernel[i]) {
      clReleaseKernel(kernel[i]);
    }
    if(queue && queue[i]) {
      clReleaseCommandQueue(queue[i]);
    }
  }
#else
  clReleaseKernel(kernel);
  clReleaseCommandQueue(queue);
#endif
  if(program) {
    clReleaseProgram(program);
  }
  if(context) {
    clReleaseContext(context);
  }
}
#ifdef APPLE
static int LoadTextFromFile(
    const char *file_name, char **result_string, size_t *string_len)
{
    int fd;
    unsigned file_len;
    struct stat file_status;
    int ret;
 
    *string_len = 0;
    fd = open(file_name, O_RDONLY);
    if (fd == -1)
    {
        printf("Error opening file %s\n", file_name);
        return -1;
    }
    ret = fstat(fd, &file_status);
    if (ret)
    {
        printf("Error reading status for file %s\n", file_name);
        return -1;
    }
    file_len = file_status.st_size;
 
    *result_string = (char*)calloc(file_len + 1, sizeof(char));
    ret = read(fd, *result_string, file_len);
    if (!ret)
    {
        printf("Error reading from file %s\n", file_name);
        return -1;
    }
 
    close(fd);
 
    *string_len = file_len;
    return 0;
}

// High-resolution timer.
double getCurrentTimestamp() {
#ifdef _WIN32 // Windows
  // Use the high-resolution performance counter.

  static LARGE_INTEGER ticks_per_second = {};
  if(ticks_per_second.QuadPart == 0) {
    // First call - get the frequency.
    QueryPerformanceFrequency(&ticks_per_second);
  }

  LARGE_INTEGER counter;
  QueryPerformanceCounter(&counter);

  double seconds = double(counter.QuadPart) / double(ticks_per_second.QuadPart);
  return seconds;
#else         // Linux
  timespec a;
  clock_gettime(CLOCK_MONOTONIC, &a);
  return (double(a.tv_nsec) * 1.0e-9) + double(a.tv_sec);
#endif
}

void _checkError(int line,
								 const char *file,
								 cl_int error,
                 const char *msg,
                 ...) {
	// If not successful
	if(error != CL_SUCCESS) {
		// Print line and file
    printf("ERROR: ");
    printf("\nLocation: %s:%d\n", file, line);

    // Print custom message.
    va_list vl;
    va_start(vl, msg);
    vprintf(msg, vl);
    printf("\n");
    va_end(vl);

    // Cleanup and bail.
    cleanup();
    exit(error);
    }
}
#endif
