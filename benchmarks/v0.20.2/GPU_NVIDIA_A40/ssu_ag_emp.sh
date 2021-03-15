#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum ag_emp.biom
md5sum ag_emp.tre

echo "===="
ssu -i ag_emp.biom -t ag_emp.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted AG+EMP 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -f -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 AG+EMP 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized AG+EMP 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -f -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 AG+EMP 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i ag_emp.biom -t ag_emp.tre -o unifrac.tmp --mode partial --start 0 --stop 25043
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

