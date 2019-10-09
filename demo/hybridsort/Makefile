include make.config
CC := $(CUDA_DIR)/bin/nvcc

CC_FLAGS = -DTIMER -g -arch=sm_50
#-arch=sm_50
#-arch=sm_35 -DTIMER -g 
#-DVERIFY 

ifdef VERIFY
override VERIFY = -DVERIFY
endif

ifdef OUTPUT
override OUTPUT = -DOUTPUT
endif

ifdef TIMER
override TIMER = -DTIMER
endif

all: hybridsort_cpu   hybridsort

hybridsort: main.cu  bucketsort.cu bucketsort.cuh bucketsort_kernel.cu histogram1024_kernel.cu  mergesort.cu mergesort.cuh mergesort_kernel.cu
	$(CC) $(CC_FLAGS) -DHAVE_LINUX_PERF_EVENT_H -DREADING_FROM_BINARY $(VERIFY) $(OUTPUT) $(TIMER) $(HISTO_WG_SIZE_0) $(BUCKET_WG_SIZE_0) $(BUCKET_WG_SIZE_1) $(MERGE_WG_SIZE_0) $(MERGE_WG_SIZE_1) bucketsort.cu mergesort.cu main.cu -o hybridsort

hybridsort_cpu: main.cu  bucketsort.cu bucketsort.cuh bucketsort_kernel.cu histogram1024_kernel.cu  mergesort.cu mergesort.cuh mergesort_kernel.cu
	$(CC) $(CC_FLAGS) -DVERIFY -DCPU -DHAVE_LINUX_PERF_EVENT_H -DREADING_FROM_BINARY $(VERIFY) $(OUTPUT) $(TIMER) $(HISTO_WG_SIZE_0) $(BUCKET_WG_SIZE_0) $(BUCKET_WG_SIZE_1) $(MERGE_WG_SIZE_0) $(MERGE_WG_SIZE_1) bucketsort.cu mergesort.cu main.cu -o hybridsort_cpu

clean:
	rm	*.o hybridsort hybridsort_cpu
