#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_40000.biom
md5sum unifrac_40000.tre

echo "===="
ssu -i unifrac_40000.biom -t unifrac_40000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time ssu -m unweighted -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time ssu -m unweighted -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
/usr/bin/time ssu -m unweighted -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time ssu -m unweighted -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time ssu -m unweighted_fp32 -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time ssu -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time ssu -m weighted_normalized -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time ssu -m weighted_normalized -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
/usr/bin/time ssu -m weighted_normalized -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 10000
rm -fr unifrac.tmp
/usr/bin/time ssu -m weighted_normalized -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 10000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 20k/40k ==="
rm -fr unifrac.tmp
t1=`date +%s`
/usr/bin/time ssu -m weighted_normalized_fp32 -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
/usr/bin/time ssu -m weighted_normalized_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac.tmp --mode partial --start 0 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

