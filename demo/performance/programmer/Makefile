all: madd_A madd_B madd_A_O3 madd_B_O3
 
EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H -g

madd: madd.c 
	$(CC) -O0 $(EXTRA_CFLAGS) madd.c -o madd

madd_A: madd.c 
	$(CC) -O0 $(EXTRA_CFLAGS) -DA madd.c -o madd_A

madd_B: madd.c 
	$(CC) -O0 $(EXTRA_CFLAGS)  madd.c -o madd_B
madd_A_O3: madd.c 
	$(CC) $(EXTRA_CFLAGS) -O3 -DA madd.c -o madd_A_O3

madd_B_O3: madd.c 
	$(CC) $(EXTRA_CFLAGS) -O3  madd.c -o madd_B_O3

clean:
		rm -f madd_A madd_B *_O3 *~
		#hotspot hotspot_omp
		