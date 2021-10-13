all: arithmetics arithmetics_2_A arithmetics_2_B

#arraySort

EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H
#CFLAGS = -O3

arithmetics: arithmetics.c 
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) arithmetics.c -o arithmetics

arithmetics_2_A: arithmetics_2.c 
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) arithmetics_2.c -o arithmetics_2_A

arithmetics_2_B: arithmetics_2.c 
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) arithmetics_2.c -o arithmetics_2_B

clean:
		rm -f arithmetics arithmetics_2_A arithmetics_2_B
