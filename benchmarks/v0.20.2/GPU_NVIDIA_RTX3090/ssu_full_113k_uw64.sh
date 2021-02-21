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
ssu -i full_307k.biom -t full_307k.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== unweighted Full 153k/307k ==="
rm -fr unifrac.tmp

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=4832)); do
  let s2=s1+4832
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted -f time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<153619; s1+=4832)); do
  let s2=s1+4832
  if [ $s2 -gt 153619 ]; then
    s2=153619
  fi

  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted time: $dt ==="

