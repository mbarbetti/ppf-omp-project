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

# Ultimo aggiornamento 2021-10-05
# Moreno Marzolla (moreno.marzolla@unibo.it)

if [ ! -f ./omp-matmul.out ]; then
    echo
    echo "Non trovo il programma ./omp-matmul.out"
    echo "Compilalo manualmente seguendo le istruzioni nel sorgente"
    exit 1
fi

echo -e "p\tt1\t\tt2\t\tt3\t\tt4\t\tt5"

PROB_SIZE=1500 # default problem size
CORES=`cat /proc/cpuinfo | grep processor | wc -l` # number of cores

for p in `seq $CORES`; do
    echo -n -e "$p\t"
    for rep in `seq 5`; do
        EXEC_TIME="$( OMP_NUM_THREADS=$p ./omp-matmul.out $PROB_SIZE | sed 's/Execution time //' )"
        echo -n -e "${EXEC_TIME}\t"
    done
    echo ""
done
