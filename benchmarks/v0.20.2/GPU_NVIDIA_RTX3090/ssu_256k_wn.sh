#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_262144.biom
md5sum unifrac_262144.tre

echo "===="
ssu -i unifrac_262144.biom -t unifrac_262144.tre -m weighted_normalized -o unifrac.tmp --mode partial-report
echo "=== weighted_normalized 128k/256k ==="
rm -fr unifrac.tmp

echo "=== weighted_normalized fp32 128k/256k ==="
rm -fr unifrac.tmp
t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+8192
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_262144.biom -t unifrac_262144.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2 
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
s1=0
for ((i=0; $i<16; i+=1)); do
  let s2=s1+8192
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_262144.biom -t unifrac_262144.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=$s2  
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="
