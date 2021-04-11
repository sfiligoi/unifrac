#!/bin/bash
hostname
lscpu
date

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-cpu

md5sum unifrac_30000.biom
md5sum unifrac_30000.tre

echo "===="
ssu -i unifrac_30000.biom -t unifrac_30000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 15k/30k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted -i unifrac_30000.biom -t unifrac_30000.tre -o unifrac.tmp --mode partial --start 0 --stop 15000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted -f -i unifrac_30000.biom -t unifrac_30000.tre -o unifrac.tmp --mode partial --start 0 --stop 15000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 15k/30k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted_fp32 -i unifrac_30000.biom -t unifrac_30000.tre -o unifrac.tmp --mode partial --start 0 --stop 15000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted_fp32 -f -i unifrac_30000.biom -t unifrac_30000.tre -o unifrac.tmp --mode partial --start 0 --stop 15000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

