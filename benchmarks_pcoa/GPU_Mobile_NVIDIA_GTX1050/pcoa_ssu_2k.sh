#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

#source ../../conda_setup.sh
#conda activate unifrac-gpu

md5sum unifrac_2000.biom
md5sum unifrac_2000.tre

echo "===="
./ssu -i unifrac_2000.biom -t unifrac_2000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== unweighted fp32 1k/2k ==="

t1=`date +%s`
taskset -c 0-3 time ./ssu -n 1 -m unweighted_fp32 -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac.part --mode partial --start 0 --stop 1000
t2=`date +%s`
let dt=t2-t1
md5sum unifrac.part
rm -fr unifrac.part
echo "=== partial time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ./ssu -n 1 -m unweighted_fp32 -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac_pcoa_0.h5 --format hdf5 --pcoa 0
t2=`date +%s`
let dt=t2-t1
md5sum unifrac_pcoa_0.h5
rm -fr unifrac_pcoa_0.h5
echo "=== hdf5 pcoa=0 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ./ssu -n 1 -m unweighted_fp32 -f -i unifrac_2000.biom -t unifrac_2000.tre -o unifrac_pcoa_10.h5 --format hdf5 --pcoa 10
t2=`date +%s`
let dt=t2-t1
md5sum unifrac_pcoa_10.h5
rm -fr unifrac_pcoa_10.h5
echo "=== hdf5 pcoa=10 time: $dt ==="

