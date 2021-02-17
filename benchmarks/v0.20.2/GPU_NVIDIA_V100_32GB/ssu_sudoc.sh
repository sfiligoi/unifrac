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

md5sum sudoc_113k.biom
md5sum sudoc_113k.tre

echo "===="
ssu -i sudoc_113k.biom -t sudoc_113k.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted SUDoc 56k/113k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 10912
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 10912 --stop 21824
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21824 --stop 32736 
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 32736 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 10912
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 10912 --stop 21824
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21824 --stop 32736
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 32736 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 SUDoc 56k/113k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 21846
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21846 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 21846
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21846 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m unweighted_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized SUDoc 56k/113k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 10912
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 10912 --stop 21824
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21824 --stop 32736
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 32736 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 10912
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 10912 --stop 21824
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21824 --stop 32736
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 32736 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 SUDoc 56k/113k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 21846
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21846 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 0 --stop 21846
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 21846 --stop 43692
rm -fr /dev/shm/unifrac.tmp
taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start 43692 --stop 56861
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

