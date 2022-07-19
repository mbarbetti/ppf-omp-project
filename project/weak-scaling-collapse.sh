#!/bin/sh

# This bash script executes ./my-mandelbrot-collapse.out in "weak 
# scaling" condition, namely expanding the input data-size so that 
# the work is linearly increasing with the number of processors 
# used (P). In particular, the program is executed using different 
# P values from 1 to the total cores available to the machine, 
# while the picture sizes of the Mandelbrot set are expanded 
# accordingly to the formula: new_size = base_size * sqrt(P), where 
# base_size is the one used with P = 1. The expected behavior is 
# that the execution time of the program remains constant although 
# one varies P, and that the speedup is equal to 1 everywhere.

# Author  : Matteo Barbetti (matteo.barbetti@unifi.it)
# Credits : Moreno Marzolla (moreno.marzolla@unibo.it)
# Last updated : 2022-07-18

if [ ! -f ./my-mandelbrot-collapse.out ]; then
    echo
    echo "./my-mandelbrot-collapse.out not found!"
    echo "Please compile it following the instructions reported on its source code."
    exit 1
fi

echo -n -e "p\t\tx_size\t\ty_size"
for rep in `seq 20`; do
    echo -n -e "\t\tt_$rep"
done
echo ""

XSIZE0=512   # base problem x-size
YSIZE0=384   # base problem y-size
CORES=`cat /proc/cpuinfo | grep processor | wc -l`   # number of cores

for p in `seq $CORES`; do
    # the new picture sizes are computed by ./utils/compute_new_size.py
    PROB_XSIZE="$( python3 ./utils/compute_new_size.py -s $XSIZE0 -p $p | sed 's/prob size computed: //' )"
    PROB_YSIZE="$( python3 ./utils/compute_new_size.py -s $YSIZE0 -p $p | sed 's/prob size computed: //' )"
    echo -n -e "$p\t\t$PROB_XSIZE\t\t$PROB_YSIZE\t"
    for rep in `seq 20`; do
        EXEC_TIME="$( OMP_NUM_THREADS=$p OMP_SCHEDULE="static,1" ./my-mandelbrot-collapse.out $PROB_XSIZE $PROB_YSIZE | sed 's/Elapsed time: //' )"
        echo -n -e "\t${EXEC_TIME}"
    done
    echo ""
done
