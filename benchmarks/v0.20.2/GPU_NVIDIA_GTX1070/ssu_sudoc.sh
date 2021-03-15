#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ~/.bashrc
conda activate unifrac-gpu

md5sum sudoc_113k.biom
md5sum sudoc_113k.tre

echo "===="
ssu -i sudoc_113k.biom -t sudoc_113k.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted SUDoc 56k/113k ==="

echo "=== unweighted fp32 SUDoc 56k/113k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+3600
  if [ $s2 -gt 56861 ]; then
    s2=56861
  fi

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+3600
  if [ $s2 -gt 56861 ]; then
    s2=56861
  fi

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized SUDoc 56k/113k ==="

echo "=== weighted_normalized fp32 SUDoc 56k/113k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+3600
  if [ $s2 -gt 56861 ]; then
    s2=56861
  fi

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+3600
  if [ $s2 -gt 56861 ]; then
    s2=56861
  fi

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -f -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

