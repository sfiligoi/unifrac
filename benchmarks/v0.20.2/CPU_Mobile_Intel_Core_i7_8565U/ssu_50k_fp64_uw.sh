#!/bin/bash
hostname
lscpu
date

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-cpu

md5sum unifrac_50000.biom
md5sum unifrac_50000.tre

echo "===="
ssu -i unifrac_50000.biom -t unifrac_50000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 25k/50k ==="

rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 6250
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 6250 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 12500 --stop 18750
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 18750 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -f -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 6250
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -f -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 6250 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -f -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 12500 --stop 18750
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -f -m unweighted -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 18750 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

