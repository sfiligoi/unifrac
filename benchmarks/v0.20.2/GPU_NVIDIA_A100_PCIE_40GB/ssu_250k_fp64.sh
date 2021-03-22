#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/.bashrc
conda activate unifrac-gpu

md5sum unifrac_250000.biom
md5sum unifrac_250000.tre

echo "===="
ssu -i unifrac_250000.biom -t unifrac_250000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted 125k/250k ==="

echo "=== unweighted 125k/250k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for ((s1=0; $s1<125000; s1+=8400)); do
  let s2=s1+8400
  if [ $s2 -gt 125000 ]; then
    s2=125000
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m unweighted -i unifrac_250000.biom -t unifrac_250000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<125000; s1+=8400)); do
  let s2=s1+8400
  if [ $s2 -gt 125000 ]; then
    s2=125000
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m unweighted -f -i unifrac_250000.biom -t unifrac_250000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted -f time: $dt ==="

echo "=== weighted_normalized 125k/250k ==="

echo "=== weighted_normalized 125k/250k ==="
rm -fr unifrac.tmp
t1=`date +%s`
for ((s1=0; $s1<125000; s1+=8400)); do
  let s2=s1+8400
  if [ $s2 -gt 125000 ]; then
    s2=125000
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m weighted_normalized -i unifrac_250000.biom -t unifrac_250000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
for ((s1=0; $s1<125000; s1+=8400)); do
  let s2=s1+8400
  if [ $s2 -gt 125000 ]; then
    s2=125000
  fi
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 8-15 time ssu -m weighted_normalized -f -i unifrac_250000.biom -t unifrac_250000.tre -o unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr unifrac.tmp
done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized -f time: $dt ==="

