all: unaligned

EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H -g

unaligned: unaligned.c
	gcc $(EXTRA_CFLAGS) unaligned.c -o unaligned

clean:
		rm -f unaligned
