all: array_of_structs

EXTRA_CFLAGS = -DHAVE_LINUX_PERF_EVENT_H -g

array_of_structs: array_of_structs.c
	gcc $(EXTRA_CFLAGS) array_of_structs.c -o array_of_structs

clean:
		rm -f array_of_structs
