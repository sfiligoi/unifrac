#!/bin/bash
hostname
sysctl -n machdep.cpu -N |head -20
date


source ../../setup_conda.source
conda activate unifrac-10


echo "===="
#ssu -n 6 -i unifrac_2000.biom -t unifrac_2000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 1k/2k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -n 6 -m unweighted -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -n 6 -m unweighted -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized 1k/2k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time -l ssu -n 6 -m weighted_normalized -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
/usr/bin/time -l ssu -n 6 -m weighted_normalized -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.tmp --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="

