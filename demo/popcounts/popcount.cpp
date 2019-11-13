#include<iostream>
#include<assert.h>
#include <stdint.h>
#include <stdio.h>
#ifdef C
/*inline int popcount(uint64_t x) {
     int c = 0;
     int table[16] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};
//     for (uint64_t i = 0; i < 2; i++) {
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
	       c += table[(x & 0xF)];
	       x = x >> 4;
//     }
     return c;
}
*/
inline int popcount(uint64_t x) {
     int c = 0;
     int table[16] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};
     while(x) {
	       c += table[(x & 0xF)];
	       x = x >> 4;
     }
     return c;
}

#else
#ifdef B
inline int popcount(uint64_t x) {
     int c = 0;
	 while(x) //while any bits are set not sure how you are getting the value
     {
       c += x & 1;
       x = x >> 1;
       c += x & 1;
       x = x >> 1;
       c += x & 1;
       x = x >> 1;
       c += x & 1;
       x = x >> 1;
     }
     return c;
}
#else
#ifdef D
inline int popcount(uint64_t x) {
     int c = 0;
     int table[16] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};
     for (uint64_t i = 0; i < 16; i++) {
	       c += table[(x & 0xF)];
	       x = x >> 4;
     }
     return c;
}
#else
inline int popcount(uint64_t x){
	int c=0;
	while(x) //while any bits are set not sure how you are getting the value
    {
       c += x & 1;
       x = x >> 1;
    }
    return c;
}
#endif
#endif
#endif
// Simple, very fast pseudo-random number generator
uint64_t RandLFSR(uint64_t &seed) {
     uint64_t bit;
     uint64_t temp = seed;
     bit = ((temp >> 0) ^ (temp >> 1) ^ (temp >> 3) ^ (temp >> 4)) & 0x1llu;
     seed = (temp >> 1) | (bit << 63);
     return seed;
}

int identity(uint64_t x) {
     return x;
}

int main(int argc, char *argv[]) {

     uint64_t key = 0xdeadbeef;

     int count = 1000000000;
     uint64_t sum = 0;
     
     for (int i=0; i < count; i++)
     { 
	   sum += popcount (RandLFSR(key)); 
     }
     printf("Result: %lu\n", sum);
     return sum;
}
