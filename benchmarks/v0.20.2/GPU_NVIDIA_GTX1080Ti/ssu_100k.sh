#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_100000.biom
md5sum unifrac_100000.tre

echo "===="
ssu -i unifrac_100000.biom -t unifrac_100000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 50k/100k ==="
rm -fr unifrac.tmp

echo "=== unweighted fp32 50k/100k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 50k/100k ==="

echo "=== weighted_normalized fp32 50k/100k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

