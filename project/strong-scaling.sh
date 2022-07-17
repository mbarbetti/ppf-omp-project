#!/bin/sh

# Questo script exegue il programma omp-matmul sfruttando OpenMP con
# un numero di core variabile da 1 al numero di core disponibili sulla
# macchina (estremi inclusi); ogni esecuzione considera sempre la
# stessa dimensione dell'input, quindi i tempi misurati possono essere
# usati per calcolare speedup e strong scaling efficiency. Ogni
# esecuzione viene ripetuta 5 volte; vengono stampati a video i tempi
# di esecuzione di tutte le esecuzioni.

# NB: La dimensione del problema (PROB_SIZE, cioè il numero di righe o
# colonne della matrice) può essere modificato per ottenere dei tempi
# di esecuzione adeguati alla propria macchina.  Idealmente, sarebbe
# utile che i tempi di esecuzione non fossero troppo brevi, dato che
# tempi brevi tendono ad essere molto influenzati dall'overhead di
# OpenMP.

# Autore: Matteo Barbetti (matteo.barbetti@unifi.it)
# Ultimo aggiornamento: 2022-07-17

if [ ! -f ./my-mandelbrot.out ]; then
    echo
    echo "./my-mandelbrot.out not found!"
    echo "Please compile it following the instructions reported on the source code."
    exit 1
fi

echo -e "p\tt1\t\tt2\t\tt3\t\tt4\t\tt5"

PROB_XSIZE=1024   # default problem x-size
PROB_YSIZE=768    # default problem y-size
CORES=`cat /proc/cpuinfo | grep processor | wc -l`   # number of cores

for p in `seq $CORES`; do
    echo -n -e "$p\t"
    for rep in `seq 5`; do
        EXEC_TIME="$( OMP_NUM_THREADS=$p OMP_SCHEDULE="static,1" ./my-mandelbrot.out $PROB_XSIZE $PROB_YSIZE | sed 's/Elapsed time //' )"
        echo -n -e "${EXEC_TIME}\t"
    done
    echo ""
done
