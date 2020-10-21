all: project

project: project.c myblockmm.o baseline.o
	gcc -O3 -msse4.1 -mavx project.c myblockmm.o baseline.o -o project -lpthread

myblockmm.o: myblockmm.c
	gcc -O3 -msse4.1 -mavx myblockmm.c -c -lpthread

baseline.o: baseline.c
	gcc -O3 -msse4.1 -mavx baseline.c -c -lpthread

clean:
		rm -f project *.o
