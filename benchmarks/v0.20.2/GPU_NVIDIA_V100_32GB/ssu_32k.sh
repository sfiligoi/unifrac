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

md5sum unifrac_32768.biom
md5sum unifrac_32768.tre

echo "===="
ssu -i unifrac_32768.biom -t unifrac_32768.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted 16k/32k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -f -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 16k/32k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 16k/32k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 16k/32k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_32768.biom -t unifrac_32768.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 16384
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

