#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date

export OMP_NUM_THREADS=6

source ../../setup_conda.source
conda activate unifrac-cpu


echo "===="
ssu -i unifrac_40000.biom -t unifrac_40000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 20k/40k ==="

echo "=== unweighted fp32 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m unweighted_fp32 -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted_fp32 -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== unweighted 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m unweighted -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 5000 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 15000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 15000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m unweighted -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 5000 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 15000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m unweighted -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 15000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized  20k/40k ==="

echo "=== weighted_normalized fp32 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized_fp32 -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

echo "=== weighted_normalized 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 5000 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 15000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 15000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 5000 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 15000
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 15000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="



