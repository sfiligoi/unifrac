#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/activate_unifrac_gpu.sh

md5sum full_307k.biom
md5sum full_307k.tre

echo "===="
echo "=== unweighted Full 153k/307k ==="

echo "=== unweighted fp32 Full 153k/307k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for ((s1=0; $s1<153619; s1+=4000)); do
  let s2=s1+4000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m unweighted_fp32 -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=4000)); do
  let s2=s1+4000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m unweighted_fp32 -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized Full 153k/307k ==="

echo "=== weighted_normalized fp32 Full 153k/307k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for ((s1=0; $s1<153619; s1+=4000)); do
  let s2=s1+4000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m weighted_normalized_fp32 -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=4000)); do
  let s2=s1+4000
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m weighted_normalized_fp32 -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

