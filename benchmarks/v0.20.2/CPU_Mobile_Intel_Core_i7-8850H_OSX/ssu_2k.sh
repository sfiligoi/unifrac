#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date

export OMP_NUM_THREADS=6

source ../../setup_conda.source
conda activate unifrac-cpu


echo "===="
ssu -i unifrac_2000.biom -t unifrac_2000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 1k/2k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m unweighted -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted /usr/bin/time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m unweighted -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f /usr/bin/time: $dt ==="

echo "=== unweighted fp32 1k/2k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m unweighted_fp32 -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 /usr/bin/time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m unweighted_fp32 -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f /usr/bin/time: $dt ==="

echo "=== weighted_normalized 1k/2k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized /usr/bin/time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f /usr/bin/time: $dt ==="


echo "=== weighted_normalized fp32 1k/2k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 /usr/bin/time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f /usr/bin/time: $dt ==="

