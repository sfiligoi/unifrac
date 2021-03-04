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

let stripes1=stripes/20

md5sum samples-250000-iteration-0.biom
md5sum samples-250000-iteration-0.tre

echo "===="
ssu -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 125k/250k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 0-7 time ssu -m unweighted -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 16 17 18 19; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 0-7 time ssu -m unweighted -f -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp

done

t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

let stripes2=stripes/10

echo "=== unweighted fp32 125k/250k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9; do
let sstart=n*stripes2
let n2=n+1
let send=n2*stripes2

taskset -c 0-7 time ssu -m unweighted_fp32 -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9; do
let sstart=n*stripes2
let n2=n+1
let send=n2*stripes2

taskset -c 0-7 time ssu -m unweighted_fp32 -f -i samples-250000-iteration-0.biom -t samples-250000-iteration-0.tre -o unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

