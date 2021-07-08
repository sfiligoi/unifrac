#!/bin/bash
hostname
lscpu
date


source ~/setup_conda.source 
conda activate unifrac-100

md5sum ../unifrac_5000.biom
md5sum ../unifrac_5000.tre

#echo "===="
#ssu -i ../unifrac_5000.biom -t ../unifrac_5000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 2.5k/5k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -n 8 -m unweighted -i ../unifrac_5000.biom -t ../unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -n 8 -m unweighted -f -i ../unifrac_5000.biom -t ../unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized 2.5k/5k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -n 8 -m weighted_normalized -i ../unifrac_5000.biom -t ../unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -n 8 -m weighted_normalized -f -i ../unifrac_5000.biom -t ../unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="

