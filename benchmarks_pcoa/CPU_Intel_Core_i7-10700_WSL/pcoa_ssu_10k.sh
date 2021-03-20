#!/bin/bash
hostname
lscpu
date

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

source ~/setup_conda.source
conda activate unifrac-202

md5sum unifrac_10000.biom
md5sum unifrac_10000.tre

echo "===="
ssu -i unifrac_10000.biom -t unifrac_10000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== unweighted fp32 5k/10k ==="

t1=`date +%s`
taskset -c 0-7 time ssu -n 1 -m unweighted_fp32 -f -i unifrac_10000.biom -t unifrac_10000.tre -o unifrac.part --mode partial --start 0 --stop 5000
t2=`date +%s`
let dt=t2-t1
md5sum unifrac.part
rm -fr unifrac.part
echo "=== partial time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -n 1 -m unweighted_fp32 -f -i unifrac_10000.biom -t unifrac_10000.tre -o unifrac_pcoa_0.h5 --format hdf5 --pcoa 0
t2=`date +%s`
let dt=t2-t1
md5sum unifrac_pcoa_0.h5
rm -fr unifrac_pcoa_0.h5
echo "=== hdf5 pcoa=0 time: $dt ==="

t1=`date +%s`
taskset -c 0-7 time ssu -n 1 -m unweighted_fp32 -f -i unifrac_10000.biom -t unifrac_10000.tre -o unifrac_pcoa_10.h5 --format hdf5 --pcoa 10
t2=`date +%s`
let dt=t2-t1
md5sum unifrac_pcoa_10.h5
rm -fr unifrac_pcoa_10.h5
echo "=== hdf5 pcoa=10 time: $dt ==="

