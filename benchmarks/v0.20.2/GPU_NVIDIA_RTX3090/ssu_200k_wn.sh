#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_200000.biom
md5sum unifrac_200000.tre

echo "===="
ssu -i unifrac_200000.biom -t unifrac_200000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== weighted_normalized 100k/200k ==="

echo "=== weighted_normalized fp32 100k/200k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<8; i+=1)); do
  let s2=s1+12500
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<8; i+=1)); do
  let s2=s1+12500
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

echo "=== weighted_normalized 100k/200k ==="
rm -fr unifrac.tmp

t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+6250
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized -f time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+6250
  taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_200000.biom -t unifrac_200000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized time: $dt ==="

