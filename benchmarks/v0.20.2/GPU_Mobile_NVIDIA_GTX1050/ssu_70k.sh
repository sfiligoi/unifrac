#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

#source ../../conda_setup.sh
#conda activate unifrac-gpu

md5sum unifrac_70000.biom
md5sum unifrac_70000.tre

echo "===="
./ssu -i unifrac_70000.biom -t unifrac_70000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 35k/70k ==="

echo "=== unweighted fp32 35k/70k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 0 --stop 8750
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 8750 --stop 17500
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 17500 --stop 26250
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 26250 --stop 35000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 0 --stop 8750
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 8750 --stop 17500
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 17500 --stop 26250
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m unweighted_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 26250 --stop 35000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 35k/70k ==="

echo "=== weighted_normalized fp32 35k/70k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 0 --stop 8750
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 8750 --stop 17500
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 17500 --stop 26250
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 26250 --stop 35000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 0 --stop 8750
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 8750 --stop 17500
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 17500 --stop 26250
rm -fr unifrac.tmp
taskset -c 0-3 time ./ssu -n 4 -m weighted_normalized_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start 26250 --stop 35000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

