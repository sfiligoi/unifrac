#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

for sz in 30; do 

let szfull=1000*sz
let stripes=500*sz

echo "==== Size ${sz}k"

for itr in 0 1 2 3 4 5 6 7 8 9; do

fnameb=samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
ssu -i ${fnameb}.biom -t ${fnameb}.tre -m unweighted_fp32 -o unifrac.tmp --mode partial-report

echo "==== Size: ${sz}k Iteration: ${itr} Type: unweighted fp32"
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 16-23 time ssu -m unweighted_fp32 -i ${fnameb}.biom -t ${fnameb}.tre -o unifrac.tmp --mode partial --start 0 --stop ${stripes}
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== Size: ${szfull} Iteration: ${itr} Type: unweighted fp32 time: $dt ==="

echo "==== Size: ${sz}k Iteration: ${itr} Type: weighted_normalized fp32"
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 16-23 time ssu -m weighted_normalized_fp32 -i ${fnameb}.biom -t ${fnameb}.tre -o unifrac.tmp --mode partial --start 0 --stop ${stripes}
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== Size: ${szfull} Iteration: ${itr} Type: weighted_normalized fp32 time: $dt ==="

done

done

