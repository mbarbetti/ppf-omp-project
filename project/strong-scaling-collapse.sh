#!/bin/sh

# This bash script executes ./my-mandelbrot-collapse.out in "strong 
# scaling" condition, namely keeping the input data-size constant 
# while the number of processors used (P) is increased. The expected 
# behavior is that the execution time (T) of the program decreases 
# linearly with the increasing of P (T_P = T_1 / P), and that the 
# speedup (s) increases linearly with the increasing of P (s = T_1 / T_P).

# Run with:
# source strong-scaling-collapse.sh <scheduling_type> <scheduling_chunksize>

# Author  : Matteo Barbetti (matteo.barbetti@unifi.it)
# Credits : Moreno Marzolla (moreno.marzolla@unibo.it)
# Last updated : 2022-07-20

if [ ! -f ./my-mandelbrot-collapse.out ]; then
    echo
    echo "./my-mandelbrot-collapse.out not found!"
    echo "Please compile it following the instructions reported on its source code."
    exit 1
fi

if ! [ $1 = "static" ] && ! [ $2 = "dynamic" ]; then
    echo
    echo "The scheduling strategy should be choosen in {'static', 'dynamic'}."
    exit 1
fi

if [ $2 -lt 1 ]; then
    echo
    echo "The scheduling chunksize should be greater than 0."
    exit 1
fi

echo -n -e "p\t\tx_size\t\ty_size"
for rep in `seq 20`; do
    echo -n -e "\t\tt_$rep"
done
echo ""

PROB_XSIZE=1024   # default problem x-size
PROB_YSIZE=768    # default problem y-size
CORES=`cat /proc/cpuinfo | grep processor | wc -l`   # number of cores

for p in `seq $CORES`; do
    echo -n -e "$p\t\t$PROB_XSIZE\t\t$PROB_YSIZE\t"
    for rep in `seq 20`; do
        EXEC_TIME="$( OMP_NUM_THREADS=$p OMP_SCHEDULE="$1,$2" ./my-mandelbrot-collapse.out $PROB_XSIZE $PROB_YSIZE | sed 's/Elapsed time: //' )"
        echo -n -e "\t${EXEC_TIME}"
    done
    echo ""
done
