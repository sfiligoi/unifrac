#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_50000.biom
md5sum unifrac_50000.tre

echo "===="
ssu -i unifrac_50000.biom -t unifrac_50000.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted 25k/50k ==="

echo "=== unweighted fp32 25k/50k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_50000.biom -t unifrac_50000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_50000.biom -t unifrac_50000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 25k/50k ==="

echo "=== weighted_normalized fp32 25k/50k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_50000.biom -t unifrac_50000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_50000.biom -t unifrac_50000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

