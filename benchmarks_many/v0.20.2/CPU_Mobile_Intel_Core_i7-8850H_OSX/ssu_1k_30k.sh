#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date

export OMP_NUM_THREADS=6

source ../../setup_conda.source
conda activate unifrac-cpu


for sz in 1 2 5 10 20 25 30; do 

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
/usr/bin/time -l ssu -f -m unweighted_fp32 -i ${fnameb}.biom -t ${fnameb}.tre -o unifrac.tmp --mode partial --start 0 --stop ${stripes}
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== Size: ${szfull} Iteration: ${itr} Type: unweighted fp32 -f time: $dt ==="

echo "==== Size: ${sz}k Iteration: ${itr} Type: weighted_normalized fp32"
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -f -m weighted_normalized_fp32 -i ${fnameb}.biom -t ${fnameb}.tre -o unifrac.tmp --mode partial --start 0 --stop ${stripes}
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== Size: ${szfull} Iteration: ${itr} Type: weighted_normalized fp32 -f time: $dt ==="

done

done

