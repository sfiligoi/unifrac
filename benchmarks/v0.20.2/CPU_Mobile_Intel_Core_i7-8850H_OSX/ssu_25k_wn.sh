#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date

export OMP_NUM_THREADS=6

source ../../setup_conda.source
conda activate unifrac-cpu


echo "===="
ssu -i unifrac_25000.biom -t unifrac_25000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== weighted_normalized 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized -f -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 12k/25k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -m weighted_normalized_fp32 -f -i unifrac_25000.biom -t unifrac_25000.tre -o unifrac.tmp --mode partial --start 0 --stop 12500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

