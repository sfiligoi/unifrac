#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

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
for ((ds=2032; $ds<19000; ds+=2032)); do
  t1=`date +%s`
  s1=0
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=20320
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=37000
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted_fp32 -i sudoc_113k.biom -t sudoc_113k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  t2=`date +%s`
  let dt=t2-t1
  echo "=== unweighted fp32 ds: $ds time: $dt ==="
done
