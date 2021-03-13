#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date

export OMP_NUM_THREADS=6

source ../../setup_conda.source
conda activate unifrac-cpu


echo "===="
ssu -i emp.biom -t emp.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted EMP 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m unweighted -i emp.biom -t emp.tre -o unifrac.tmp --mode partial --start 0 --stop 12573
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m unweighted -f -i emp.biom -t emp.tre -o unifrac.tmp --mode partial --start 0 --stop 12573
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 EMP 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m unweighted_fp32 -i emp.biom -t emp.tre -o unifrac.tmp --mode partial --start 0 --stop 12573
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m unweighted_fp32 -f -i emp.biom -t emp.tre -o unifrac.tmp --mode partial --start 0 --stop 12573
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

