all: testloop testloop_O3 coherence blockmm blockmm_pthread value_of_i madd_sse fence mfence madd_sse_two_threads madd_sse_two_threads_chunk madd_mt madd_mt_chunk

testloop_O3: testloop.c
	gcc -O3 -g testloop.c -lpthread -o testloop_O3
	otool -tV testloop_O3 > testloop_O3.dump 


testloop: testloop.c
	gcc -O0 -g testloop.c -lpthread -o testloop 
	otool -tV testloop > testloop.dump 

coherence: coherence.c
	gcc -O0 coherence.c -lpthread -o coherence 

value_of_i: value_of_i.c
	gcc value_of_i.c -lpthread -o value_of_i

blockmm_pthread: blockmm_pthread.c
	gcc -O3 blockmm_pthread.c -lpthread -o blockmm_pthread

blockmm: blockmm.c
	gcc -O3 blockmm.c -lpthread -o blockmm 

madd_sse: madd.c 
	$(CC) -O3 $(EXTRA_CFLAGS) -DSSE madd.c -o madd_sse

madd_sse_pthread: madd_pthread.c 
	$(CC) -O3 $(EXTRA_CFLAGS) -pthread -DSSE madd_pthread.c -o madd_sse_pthread 

madd_sse_two_threads: madd_two_threads.c 
	$(CC) -O3 $(EXTRA_CFLAGS) -pthread -DSSE madd_two_threads.c -o madd_sse_two_threads

madd_sse_two_threads_chunk: madd_two_threads.c 
	$(CC) -O3 $(EXTRA_CFLAGS) -pthread -DSSE -DCHUNK madd_two_threads.c -o madd_sse_two_threads_chunk

madd_mt: madd_mt.c 
	$(CC) -O3 $(EXTRA_CFLAGS) -pthread -DSSE madd_mt.c -o madd_mt

madd_mt_chunk: madd_mt.c 
	$(CC) -O3 $(EXTRA_CFLAGS) -pthread -DSSE -DCHUNK madd_mt.c -o madd_mt_chunk 

pthread_overhead: pthread_overhead.c
	$(CC) -O3 $(EXTRA_CFLAGS) -pthread -DSSE pthread_overhead.c -o pthread_overhead

fence: fence.c 
	$(CC) -O3 $(EXTRA_CFLAGS) fence.c -o fence -lpthread

mfence: fence.c 
	$(CC) -O3 -DMFENCE $(EXTRA_CFLAGS) fence.c -o mfence -lpthread


clean:
		rm -f testloop testloop_O3 coherence blockmm blockmm_pthread *.dump *~ value_of_i madd_sse madd_sse_pthread
		rm -rf *.dSYM
