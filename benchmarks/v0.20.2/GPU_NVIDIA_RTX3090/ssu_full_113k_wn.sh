#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum full_307k.biom
md5sum full_307k.tre

echo "===="
ssu -i full_307k.biom -t full_307k.tre -m weighted_normalized -o unifrac.tmp --mode partial-report
echo "=== weighted_normalized Full 153k/307k ==="

echo "=== weighted_normalized fp32 Full 153k/307k ==="
rm -fr unifrac.tmp

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=6400)); do
  let s2=s1+6400
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=6400)); do
  let s2=s1+6400
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="
