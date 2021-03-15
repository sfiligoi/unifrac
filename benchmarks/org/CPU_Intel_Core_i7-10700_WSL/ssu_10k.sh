#!/bin/bash
hostname
lscpu
date


source ~/setup_conda.source 
conda activate unifrac-100

md5sum ../unifrac_10000.biom
md5sum ../unifrac_10000.tre

#echo "===="
#ssu -i ../unifrac_10000.biom -t ../unifrac_10000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 5k/10k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -n 8 -m unweighted -i ../unifrac_10000.biom -t ../unifrac_10000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -n 8 -m unweighted -f -i ../unifrac_10000.biom -t ../unifrac_10000.tre -o unifrac.tmp --mode partial --start 0 --stop 5000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

