all: madd_r madd_c madd_r_O3 madd_c_O3
 
EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H -g

madd: madd.c 
	$(CC) -O0 $(EXTRA_CFLAGS) madd.c -o madd

madd_r: madd.c 
	$(CC) -O0 $(EXTRA_CFLAGS) madd.c -o madd_r

madd_c: madd.c 
	$(CC) -O0 $(EXTRA_CFLAGS) -DCOL_MAJOR madd.c -o madd_c
madd_r_O3: madd.c 
	$(CC) $(EXTRA_CFLAGS) -O3 madd.c -o madd_r_O3

madd_c_O3: madd.c 
	$(CC) $(EXTRA_CFLAGS) -O3 -DCOL_MAJOR madd.c -o madd_c_O3

clean:
		rm -f madd_r madd_c *_O3 *~
		#hotspot hotspot_omp
		