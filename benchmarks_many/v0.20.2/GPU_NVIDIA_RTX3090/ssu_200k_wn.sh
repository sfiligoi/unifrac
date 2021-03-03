#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

sz=200

let szfull=1000*sz
let stripes=500*sz

let stripes1=stripes/8

echo "==== Size ${sz}k"

for itr in 0 1 2 3 4 5 6 7 8 9; do

fnameb=samples-${szfull}-iteration-${itr}

echo "==== Processing ${fnameb}"
md5sum ${fnameb}.biom
md5sum ${fnameb}.tre
ssu -i ${fnameb}.biom -t ${fnameb}.tre -m weighted_normalized_fp32 -o unifrac.tmp --mode partial-report

echo "==== Size: ${sz}k Iteration: ${itr} Type: weighted_normalized fp32"
rm -fr unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 16-23 time ssu -m weighted_normalized_fp32 -i ${fnameb}.biom -t ${fnameb}.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== Size: ${szfull} Iteration: ${itr} Type: weighted_normalized fp32 time: $dt ==="


done


