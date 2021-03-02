#!/bin/bash
#SBATCH --time 48:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=2
export OMP_NUM_THREADS=8

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks_many/ssu_gpu
source ../../setup_conda.source
conda activate unifrac-gpu

for sz in 50; do 

let szfull=1000*sz
let stripes=500*sz

let stripes1=stripes/2


echo "==== Size ${sz}k"

for itr in 0 1 2 3 4 5 6 7 8 9; do

fnameb=/home/mcdonadt/redbiom-070920/subsets/samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
ssu -i ${fnameb}.biom -t ${fnameb}.tre -m weighted_normalized -o /dev/shm/unifrac.tmp --mode partial-report

echo "==== Size: ${sz}k Iteration: ${itr} Type: weighted_normalized"
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 8-15 time ssu -m weighted_normalized -i ${fnameb}.biom -t ${fnameb}.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== Size: ${szfull} Iteration: ${itr} Type: weighted_normalized time: $dt ==="

done

done
