#!/bin/sh

# Questo script esegue il programma omp-matmul sfruttando OpenMP con
# un numero di core da 1 al numero di core disponibili sulla macchina
# (estremi inclusi). Il test con p processori viene effettuato su un
# input che ha dimensione N0 * (p^(1/3)), dove N0 e' la dimensione
# dell'input con p=1 thread OpenMP. Per come è stato implementato il
# programma parallelo, questo significa che all'aumentare del numero p
# di thread OpenMP, la dimensione del problema viene fatta crescere in
# modo che la quantità di lavoro per thread resti costante.

# Ultimo aggiornamento 2021-10-05
# Moreno Marzolla (moreno.marzolla@unibo.it)

if [ ! -f ./omp-matmul.out ]; then
    echo
    echo "Non trovo il programma ./omp-matmul.out"
    echo "Compilalo manualmente seguendo le istruzioni nel sorgente"
    exit 1
fi

echo -e "p\tt1\t\tt2\t\tt3\t\tt4\t\tt5"

N0=1024 # base problem size
CORES=`cat /proc/cpuinfo | grep processor | wc -l` # number of cores

for p in `seq $CORES`; do
    echo -n -e "$p\t"
    # Il comando bc non è in grado di valutare direttamente una radice
    # cubica, che dobbiamo quindi calcolare mediante logaritmo ed
    # esponenziale. L'espressione ($N0 * e(l($p)/3)) calcola
    # $N0*($p^(1/3))
    PROB_SIZE=`echo "$N0 * e(l($p)/3)" | bc -l -q`
    for rep in `seq 5`; do
        EXEC_TIME="$( OMP_NUM_THREADS=$p ./omp-matmul.out $PROB_SIZE | sed 's/Execution time //' )"
        echo -n -e "${EXEC_TIME}\t"
    done
    echo ""
done
