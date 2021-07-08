#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ~/~/activate_unifrac_gpu.sh

md5sum unifrac_200000.biom
md5sum unifrac_200000.tre

echo "===="

echo "=== unweighted fp32 100k/200k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<20; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<20; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -f -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 100k/200k ==="

echo "=== weighted_normalized fp32 100k/200k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<20; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<20; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -f -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

