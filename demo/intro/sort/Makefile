all: arraySort

EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H 

arraySort: arraySort.cpp 
	g++ $(EXTRA_CFLAGS) arraySort.cpp -o arraySort

#perfstats.o: perfstats.c 
#	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) perfstats.c -c 

clean:
		rm -f arraySort 
