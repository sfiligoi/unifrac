#!/bin/bash
#PBS -q highmem
#PBS -l nodes=brncl-73,procs_bitmap=1111111111111111000000000000000000000000000000000000000000000000
hostname
lscpu
date

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2019.10/benchmarks/ssu
source ../../source_condor.sh
conda activate unifrac

for sz in 10; do 

let szfull=1000*sz
let stripes=500*sz

echo "==== Size ${sz}k"

for itr in 6 7 8 9; do

fnameb=/home/mcdonadt/redbiom-070920/subsets/samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
ssu -i ${fnameb}.biom -t ${fnameb}.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report

echo "==== Size: ${sz}k Iteration: ${itr} Type: unweighted"
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-15 time ssu -n 16 -m unweighted -i ${fnameb}.biom -t ${fnameb}.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop ${stripes}
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== Size: ${szfull} Iteration: ${itr} Type: unweighted time: $dt ==="

echo "==== Size: ${sz}k Iteration: ${itr} Type: weighted_normalized"
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-15 time ssu -n 16 -m weighted_normalized -i ${fnameb}.biom -t ${fnameb}.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop ${stripes}
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== Size: ${szfull} Iteration: ${itr} Type: weighted_normalized time: $dt ==="

done

done