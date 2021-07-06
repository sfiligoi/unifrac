#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/activate_unifrac_gpu.sh

for i in 1 2 3 5 10; do
md5sum unifrac_${i}0000.biom
md5sum unifrac_${i}0000.tre

let s=${i}0000/2

echo "===="
echo "=== unweighted fp32 ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start 0 --stop ${s}
t2=`date +%s`
let dt=t2-t1
ls -l unifrac.tmp
rm -fr unifrac.tmp
echo "=== ${i}0000 unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start 0 --stop ${s}
t2=`date +%s`
let dt=t2-t1
ls -l unifrac.tmp
rm -fr unifrac.tmp

echo "=== ${i}0000 unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized fp32 ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start 0 --stop ${s}
t2=`date +%s`
let dt=t2-t1
ls -l unifrac.tmp
rm -fr unifrac.tmp
echo "=== ${i}0000 weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start 0 --stop ${s}
t2=`date +%s`
let dt=t2-t1
ls -l unifrac.tmp
rm -fr unifrac.tmp
echo "=== ${i}0000 weighted_normalized fp32 -f time: $dt ==="

done

