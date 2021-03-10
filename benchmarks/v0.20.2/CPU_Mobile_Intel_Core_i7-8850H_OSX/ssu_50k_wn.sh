#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date

export OMP_NUM_THREADS=6

source ../../setup_conda.source
conda activate unifrac-cpu


echo "===="
ssu -i unifrac_50000.biom -t unifrac_50000.tre -m weighted_normalized -o unifrac.tmp --mode partial-report
echo "=== weighted_normalized 25k/50k ==="

echo "=== weighted_normalized fp32 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized_fp32 -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 12500 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized_fp32 -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 12500 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

echo "=== weighted_normalized 25k/50k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 6250
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 6250 --stop 12500
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 12500 --stop 18750
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 18750 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 0 --stop 6250
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 6250 --stop 12500
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 12500 --stop 18750
rm -fr unifrac.tmp
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac.tmp --mode partial --start 18750 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="

