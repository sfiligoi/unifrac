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

md5sum unifrac_200000.biom
md5sum unifrac_200000.tre

echo "===="
ssu -i unifrac_200000.biom -t unifrac_200000.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted 100k/200k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+6250
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted -i unifrac_200000.biom -t unifrac_200000.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+6250
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted -f -i unifrac_200000.biom -t unifrac_200000.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized fp32 100k/200k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<10; i+=1)); do
  let s2=s1+10000
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_200000.biom -t unifrac_200000.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<10; i+=1)); do
  let s2=s1+10000
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_200000.biom -t unifrac_200000.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

