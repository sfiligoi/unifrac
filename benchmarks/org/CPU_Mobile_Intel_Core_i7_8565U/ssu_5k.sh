#!/bin/bash
hostname
lscpu
date

source ../../conda_setup.sh
conda activate unifrac-org

md5sum unifrac_5000.biom
md5sum unifrac_5000.tre

echo "=== unweighted 2.5k/5k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -n 4 -m unweighted -i unifrac_5000.biom -t unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 4 -m unweighted -f -i unifrac_5000.biom -t unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized 2.5k/5k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-3 time ssu -n 4 -m weighted_normalized -i unifrac_5000.biom -t unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 4 -m weighted_normalized -f -i unifrac_5000.biom -t unifrac_5000.tre -o unifrac.tmp --mode partial --start 0 --stop 2500
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="

