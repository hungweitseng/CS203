#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    int option;
    char *buffer;
    uint64_t *data;
    int size;    
    int i,k;
    uint64_t sum=0;
    
    if(argc >= 2)
        option = atoi(argv[1]);
    if(argc >= 3)
        size = atoi(argv[2]);
    buffer = (char *)malloc(sizeof(uint64_t)*(size+1));
    if(option) // unaligned
        data = (uint64_t *)(buffer+2);
    else
        data = (uint64_t *)buffer;
    for(k=0;k<100;k++)
    for(i=0;i<size;i++)
        sum += data[i];
    fprintf(stderr, "%llu\n",sum);
    return 0;
    
}