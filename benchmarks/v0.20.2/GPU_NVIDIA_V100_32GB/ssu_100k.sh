#!/bin/bash
#SBATCH --time 24:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu_gpu
source ../../setup_conda.source
conda activate unifrac-gpu

md5sum unifrac_100000.biom
md5sum unifrac_100000.tre

echo "===="
ssu -i unifrac_100000.biom -t unifrac_100000.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted 50k/100k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 12500 --stop 25000 
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 37500 
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 37500 --stop 50000 
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 50k/100k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 50k/100k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 12500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 12500 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 37500
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 37500 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 50k/100k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 25000
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o /dev/shm/unifrac.tmp --mode partial --start 25000 --stop 50000
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

