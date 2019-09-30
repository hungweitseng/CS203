#include <algorithm>
#include <ctime>
#include <iostream>
#include <climits>
/*extern "C"
{
#include "perfstats.h"
}*/

//int count_larger_than(int *data, int array_size, int threshold);

int main(int argc, char **argv)
{
    // generate data
    const unsigned array_size = 131072;
    int data[array_size];
//    int *data;
    int option = atoi(argv[1]);
//    int array_size = atoi(argv[2]);
    long long sum = 0;
//    data = (int *)malloc(sizeof(int)*array_size);
    for (unsigned i = 0; i < array_size; ++i)
        data[i] = std::rand();

    if(option)
        std::sort(data, data + array_size);
//    perfstats_init();
//    perfstats_enable();
    
    for(unsigned k = 0; k < 1000; k++){
        int threshold = std::rand();
        sum =0;
        for (unsigned i = 0; i < array_size; ++i) {
            if (data[i] >= threshold)
                sum++;
        }
    }
//    perfstats_print();
//    perfstats_deinit();
    std::cout << "sum = " << sum << std::endl;
}
