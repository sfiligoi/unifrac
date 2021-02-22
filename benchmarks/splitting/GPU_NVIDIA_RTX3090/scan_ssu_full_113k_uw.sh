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

echo "=== unweighted fp32 Full 153k/307k ==="
rm -fr unifrac.tmp

t1=`date +%s`
for ((ds=640; $ds<7500; ds+=640)); do
  t1=`date +%s`
  s1=10000
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted_fp32 -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=25600
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted_fp32 -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  s1=100000
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-7 time ssu -m unweighted_fp32 -f -i full_307k.biom -t full_307k.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
  t2=`date +%s`
  let dt=t2-t1
  echo "=== unweighted fp32 -f ds: $ds time: $dt ==="
done
