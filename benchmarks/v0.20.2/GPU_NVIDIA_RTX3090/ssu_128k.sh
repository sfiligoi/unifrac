#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_131072.biom
md5sum unifrac_131072.tre

echo "===="
ssu -i unifrac_131072.biom -t unifrac_131072.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 64k/128k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 8192
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 8192 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 24576
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 24576 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 40960
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 40960 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 57344
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 57344 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 8192
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 8192 --stop 16384 
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 24576
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 24576 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 40960
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 40960 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 57344
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 57344 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 64k/128k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 64k/128k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 8192
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 8192 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 24576
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 24576 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 40960
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 40960 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 57344
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 57344 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 8192
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 8192 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 24576
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 24576 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 40960
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 40960 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 57344
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 57344 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 64k/128k ==="
rm -fr unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 0 --stop 16384
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 16384 --stop 32768
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 32768 --stop 49152
rm -fr unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_131072.biom -t unifrac_131072.tre -o unifrac.tmp --mode partial --start 49152 --stop 65536
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

