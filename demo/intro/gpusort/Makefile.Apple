
# This is a GNU Makefile.

# It can be used to compile an OpenCL program with
# the Altera Beta OpenCL Development Kit.
# See README.txt for more information.


# You must configure ALTERAOCLSDKROOT to point the root directory of the Altera SDK for OpenCL
# software installation.
# See doc/getting_started.txt for more information on installing and
# configuring the Altera SDK for OpenCL.


# Creating a static library
TARGET = mysort 

# Where is the Altera SDK for OpenCL software?
#ifeq ($(wildcard $(ALTERAOCLSDKROOT)),)
#$(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation)
#endif
#ifeq ($(wildcard $(ALTERAOCLSDKROOT)/host/include/CL/opencl.h),)
#$(error Set ALTERAOCLSDKROOT to the root directory of the Altera SDK for OpenCL software installation.)
#endif

# Libraries to use, objects to compile
SRCS = pthread_sort.cpp fpga_sort.cpp mysort.cpp 
SRCS_FILES = $(foreach F, $(SRCS), ./$(F))
OBJS=$(SRCS:.c=.o)
COMMON_FILES = ./common/src/AOCL_Utils.cpp
CXX_FLAGS = -pthread -lm -O3 -g

# arm cross compiler
CROSS-COMPILE = arm-linux-gnueabihf-

# OpenCL compile and link flags.
#AOCL_COMPILE_CONFIG=$(shell aocl compile-config --arm) -I./common/inc 
#AOCL_LINK_CONFIG=$(shell aocl link-config --arm) 


# Make it all!
all : 
#	$(CROSS-COMPILE)g++ $(SRCS_FILES) $(COMMON_FILES) -g -o $(TARGET)  $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG) 
#	$(CROSS-COMPILE)g++ $(SRCS_FILES) $(COMMON_FILES) $(CXX_FLAGS) -c   $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG)
#	$(CROSS-COMPILE)g++ $(SRCS_FILES) $(COMMON_FILES) $(CXX_FLAGS) -c   $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG)
#	$(CROSS-COMPILE)g++ $(CXX_FLAGS) $(OBJS) -o $(TARGET)  $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG)
	clang -framework OpenCL -DAPPLE -O3 $(EXTRA_CFLAGS) $(SRCS_FILES) -o $(TARGET)  $(AOCL_COMPILE_CONFIG) $(AOCL_LINK_CONFIG) 
 	 

#fpgasort.aocx: 
#	aoc fpgasort.cl -o fpgasort.aocx --board de1soc_sharedonly

# Standard make targets
clean :
	@rm -f *.o $(TARGET)
