#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/activate_unifrac_gpu.sh

for i in 15; do
md5sum unifrac_${i}0000.biom
md5sum unifrac_${i}0000.tre

let s=${i}0000/4


echo "===="
echo "=== unweighted fp32 ==="
rm -fr unifrac.tmp
t0=`date +%s`
for n in 0 1; do
  let b=${s}*n
  let e=${s}*n+${s}

  echo "= start ${b} stop ${e}"
  t1=`date +%s`
  taskset -c 8-15 time ssu -m unweighted_fp32 -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start ${b} --stop ${e}
  t2=`date +%s`
  let dt=t2-t1
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
let dt=t2-t0
echo "=== ${i}0000 unweighted fp32 time: $dt ==="

t0=`date +%s`
for n in 0 1; do
  let b=${s}*n
  let e=${s}*n+${s}
  
  echo "= start ${b} stop ${e}"
  t1=`date +%s`
  taskset -c 8-15 time ssu -m unweighted_fp32 -f -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start ${b} --stop ${e}
  t2=`date +%s`
  let dt=t2-t1
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
let dt=t2-t0

echo "=== ${i}0000 unweighted fp32 -f time: $dt ==="


echo "=== weighted_normalized fp32 ==="
rm -fr unifrac.tmp
t0=`date +%s`
for n in 0 1; do
  let b=${s}*n
  let e=${s}*n+${s}
  
  echo "= start ${b} stop ${e}"
  t1=`date +%s`
  taskset -c 8-15 time ssu -m weighted_normalized_fp32 -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start ${b} --stop ${e}
  t2=`date +%s`
  let dt=t2-t1
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
let dt=t2-t0
echo "=== ${i}0000 weighted_normalized fp32 time: $dt ==="

t0=`date +%s`
for n in 0 1; do
  let b=${s}*n
  let e=${s}*n+${s}
  
  echo "= start ${b} stop ${e}"
  t1=`date +%s`
  taskset -c 8-15 time ssu -m weighted_normalized_fp32 -f -i unifrac_${i}0000.biom -t unifrac_${i}0000.tre -o unifrac.tmp --mode partial --start ${b} --stop ${e}
  t2=`date +%s`
  let dt=t2-t1
  ls -l unifrac.tmp
  rm -fr unifrac.tmp
done
let dt=t2-t0

echo "=== ${i}0000 weighted_normalized fp32 -f time: $dt ==="

done

