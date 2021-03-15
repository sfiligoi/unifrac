#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_50000.biom
md5sum unifrac_50000.tre

echo "===="
ssu -i unifrac_50000.biom -t unifrac_50000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 25k/50k ==="

echo "=== unweighted 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 8300
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 8300 --stop 16600
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 16600 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 8300
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 8300 --stop 16600
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 16600 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized 25k/50k ==="

echo "=== weighted_normalized 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 8300
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 8300 --stop 16600
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 16600 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 8300
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 8300 --stop 16600
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 16600 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="

