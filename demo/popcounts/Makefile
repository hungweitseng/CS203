all: popcount popcount_B popcount_C popcount_D

popcount: 
	g++ -O3 popcount.cpp -o popcount_A

popcount_B: 
	g++ -O3 -DB popcount.cpp -o popcount_B

popcount_C: 
	g++ -O3 -DC popcount.cpp -o popcount_C

popcount_D: 
	g++ -O3 -DD popcount.cpp -o popcount_D
	
dump:
	otool -tV popcount
	otool -tV popcount_inline 
	
clean:
		rm -f popcount_A popcount_B popcount_C popcount_D
		