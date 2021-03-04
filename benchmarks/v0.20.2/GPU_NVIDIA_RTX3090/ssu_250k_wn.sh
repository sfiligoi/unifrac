#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

sz=250

let szfull=1000*sz
let stripes=500*sz


md5sum samples-250000-iteration-0.biom
md5sum samples-250000-iteration-0.tre

echo "===="
ssu -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -m weighted_normalized -o unifrac.tmp --mode partial-report
echo "=== weighted_normalized 125k/250k ==="

let stripes2=stripes/12

echo "=== weighted_normalized fp32 125k/250k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9 10 11; do
let sstart=n*stripes2
let n2=n+1
if [ $n -lt 11 ]; then
let send=n2*stripes2
else
send=#stripes
fi

taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9 10 11; do
let sstart=n*stripes2
let n2=n+1

if [ $n -lt 11 ]; then
let send=n2*stripes2
else
send=#stripes
fi

taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

