all: unaligned swap

EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H -O3

unaligned: unaligned.c
	gcc $(EXTRA_CFLAGS) unaligned.c -o unaligned

swap: swap.c
	gcc $(EXTRA_CFLAGS) swap.c -o swap

clean:
		rm -f unaligned swap
