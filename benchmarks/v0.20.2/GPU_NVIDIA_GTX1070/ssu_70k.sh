#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_70000.biom
md5sum unifrac_70000.tre

echo "===="
ssu -i unifrac_70000.biom -t unifrac_70000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 35k/70k ==="

echo "=== unweighted fp32 35k/70k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<5; i+=1)); do
  let s2=s1+7000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<5; i+=1)); do
  let s2=s1+7000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 35k/70k ==="

echo "=== weighted_normalized fp32 35k/70k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<5; i+=1)); do
  let s2=s1+7000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<5; i+=1)); do
  let s2=s1+7000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -f -i unifrac_70000.biom -t unifrac_70000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

