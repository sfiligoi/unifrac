#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_150000.biom
md5sum unifrac_150000.tre

echo "===="
ssu -i unifrac_150000.biom -t unifrac_150000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 75k/150k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 18750
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 18750 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 56250
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 56250 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 18750
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 18750 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 56250
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 56250 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 75k/150k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 75k/150k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 18750
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 18750 --stop 37500 
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 56250
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 56250 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 18750
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 18750 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 56250
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 56250 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 75k/150k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 0 --stop 37500
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_150000.biom -t unifrac_150000.tre -o unifrac.tmp --mode partial --start 37500 --stop 75000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

