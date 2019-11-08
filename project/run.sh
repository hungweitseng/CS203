#!/bin/bash
cd baseline; time ./mcf ../data/ref/input/inp.in >& /dev/zero; cd ..
cd src; time ./mcf ../data/ref/input/inp.in >& /dev/zero ; cd ..
diff ./baseline/mcf.out ./src/mcf.out