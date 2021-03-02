#!/bin/bash
#PBS -q highmem
#PBS -l nodes=brncl-72,procs_bitmap=0000000000000000111111111111111100000000000000000000000000000000
hostname
lscpu
date

export OMP_NUM_THREADS=16

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu
source ../../setup_conda.source
conda activate unifrac

for sz in 50; do 

let szfull=1000*sz
let stripes=500*sz

let stripes1=stripes/8

echo "==== Size ${sz}k"

for itr in 0 1 2 3 4 5 6 7 8 9; do

fnameb=/home/mcdonadt/redbiom-070920/subsets/samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
ssu -i ${fnameb}.biom -t ${fnameb}.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report

echo "==== Size: ${sz}k Iteration: ${itr} Type: unweighted"
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 16-31 time ssu -m unweighted -i ${fnameb}.biom -t ${fnameb}.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== Size: ${szfull} Iteration: ${itr} Type: unweighted time: $dt ==="

done

done

echo "=========== weighted_normalized"

for sz in 50; do

let szfull=1000*sz
let stripes=500*sz

let stripes1=stripes/8

echo "==== Size ${sz}k"

for itr in 0 1 2 3 4 5 6 7 8 9; do

fnameb=/home/mcdonadt/redbiom-070920/subsets/samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
ssu -i ${fnameb}.biom -t ${fnameb}.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report

echo "==== Size: ${sz}k Iteration: ${itr} Type: weighted_normalized"
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 16-31 time ssu -m weighted_normalized -i ${fnameb}.biom -t ${fnameb}.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== Size: ${szfull} Iteration: ${itr} Type: weighted_normalized time: $dt ==="

done

done

