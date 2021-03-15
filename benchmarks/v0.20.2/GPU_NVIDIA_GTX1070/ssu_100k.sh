#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_100000.biom
md5sum unifrac_100000.tre

echo "===="
ssu -i unifrac_100000.biom -t unifrac_100000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 50k/100k ==="

echo "=== unweighted fp32 50k/100k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<10; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<10; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m unweighted_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 -f time: $dt ==="

echo "=== weighted_normalized 50k/100k ==="

echo "=== weighted_normalized fp32 50k/100k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<10; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<10; i+=1)); do
  let s2=s1+5000

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 6-9 time ssu -m weighted_normalized_fp32 -f -i unifrac_100000.biom -t unifrac_100000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

