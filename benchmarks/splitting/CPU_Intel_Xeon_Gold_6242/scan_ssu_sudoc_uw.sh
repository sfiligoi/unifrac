#!/bin/bash
hostname
lscpu
date

export OMP_NUM_THREADS=16

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu
source ../../setup_conda.source
conda activate unifrac

md5sum sudoc_113k.biom
md5sum sudoc_113k.tre

echo "===="
ssu -i sudoc_113k.biom -t sudoc_113k.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted SUDoc 56k/113k ==="

echo "=== unweighted SUDoc 56k/113k ==="
rm -fr /dev/shm/unifrac.tmp

t1=`date +%s`
for ((ds=320; $ds<2600; ds+=320)); do
  t1=`date +%s`
  s1=0
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-15 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  s1=20320
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-15 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  s1=37000
  let s2=s1+ds
  echo "`date` ssu --start $s1 --stop $s2"
  taskset -c 0-15 time ssu -m unweighted -i sudoc_113k.biom -t sudoc_113k.tre -o /dev/shm/unifrac.tmp --mode partial --start $s1 --stop $s2
  rm -fr /dev/shm/unifrac.tmp
  t2=`date +%s`
  let dt=t2-t1
  echo "=== unweighted ds: $ds time: $dt ==="
done
