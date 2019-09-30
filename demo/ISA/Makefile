all: mul_div

EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H -g

mul_div: mul_div.c
	gcc $(EXTRA_CFLAGS) mul_div.c -o mul_div

clean:
		rm -f mul_div
