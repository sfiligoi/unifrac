#!/bin/bash
#SBATCH --time 24:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-gpu

md5sum unifrac_25000.biom
md5sum unifrac_25000.tre

echo "===="
ssu -i unifrac_25000.biom -t unifrac_25000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -n 3 -m unweighted -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 3 -m unweighted -f -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -n 2 -m unweighted_fp32 -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 2 -m unweighted_fp32 -f -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -n 3 -m weighted_normalized -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 3 -m weighted_normalized -f -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -n 2 -m weighted_normalized_fp32 -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 2 -m weighted_normalized_fp32 -f -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="
