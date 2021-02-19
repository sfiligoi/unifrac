#!/bin/bash
#SBATCH --time 24:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=1
export OMP_NUM_THREADS=8

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu_gpu
source ../../setup_conda.source
conda activate unifrac-gpu

md5sum full_307k.biom
md5sum full_307k.tre

echo "===="
ssu -i full_307k.biom -t full_307k.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report

echo "=== weighted_normalized Full 153k/307k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for ((s1=0; $s1<153619; s1+=5000)); do
  let s2=s1+5000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m weighted_normalized -i full_307k.biom -t full_307k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=5000)); do
  let s2=s1+5000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m weighted_normalized -f -i full_307k.biom -t full_307k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized -f time: $dt ==="

echo "=== unweighted fp32 Full 153k/307k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for ((s1=0; $s1<153619; s1+=8000)); do
  let s2=s1+8000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m unweighted_fp32 -i full_307k.biom -t full_307k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=8000)); do
  let s2=s1+8000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m unweighted_fp32 -f -i full_307k.biom -t full_307k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 -f time: $dt ==="


