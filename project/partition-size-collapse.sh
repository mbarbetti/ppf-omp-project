#!/bin/sh

# This bash script executes ./my-mandelbrot-collapse.out using 
# different scheduling strategies. In particular, fixed the number 
# of threads and the scheduling type within {'static', 'dynamic'}, 
# the script tests the program time performance, varying the 
# scheduling chunksize from 2 to 256.

# Run with:
# source partition-size-collapse.sh <num_threads> <scheduling_type>

# Author : Matteo Barbetti (matteo.barbetti@unifi.it)
# Last updated : 2022-07-20

if [ ! -f ./my-mandelbrot-collapse.out ]; then
    echo
    echo "./my-mandelbrot-collapse.out not found!"
    echo "Please compile it following the instructions reported on its source code."
    exit 1
fi

CORES=`cat /proc/cpuinfo | grep processor | wc -l`   # number of cores

if [ $1 -lt 1 ] || [ $1 -gt $CORES ]; then
    echo
    echo "The number of processors should be choosen in [1,TOT_CORES]."
    exit 1
fi

if ! [ $2 = "static" ] && ! [ $2 = "dynamic" ]; then
    echo
    echo "The scheduling strategy should be choosen in {'static', 'dynamic'}."
    exit 1
fi

echo -n -e "type\t\tsize\t\tx_size\t\ty_size"
for rep in `seq 20`; do
    echo -n -e "\t\tt_$rep"
done
echo ""

PROB_XSIZE=1024   # default problem x-size
PROB_YSIZE=768    # default problem y-size

for chunksize in 1 2 4 8 16 32 64 128 256; do
    echo -n -e "$2\t\t$chunksize\t\t$PROB_XSIZE\t\t$PROB_YSIZE\t"
    for rep in `seq 20`; do
        EXEC_TIME="$( OMP_NUM_THREADS=$1 OMP_SCHEDULE="$2,$chunksize" ./my-mandelbrot-collapse.out $PROB_XSIZE $PROB_YSIZE | sed 's/Elapsed time: //' )"
        echo -n -e "\t${EXEC_TIME}"
    done
    echo ""
done
