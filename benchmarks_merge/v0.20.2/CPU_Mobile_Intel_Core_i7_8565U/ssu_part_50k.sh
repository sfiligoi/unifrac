#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-gpu

md5sum unifrac_50000.biom
md5sum unifrac_50000.tre

echo "===="
ssu -i unifrac_50000.biom -t unifrac_50000.tre -m unweighted -o unifrac.tmp --mode partial-report
echo "=== unweighted fp32 time: $dt ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 4 -m unweighted_fp32 -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac_50k_2.p0 --mode partial --start 0 --stop 12500
rm -fr unifrac.tmp
taskset -c 0-3 time ssu -n 4 -m unweighted_fp32 -f -i unifrac_50000.biom -t unifrac_50000.tre -o unifrac_50k_2.p1 --mode partial --start 12500 --stop 25000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="
