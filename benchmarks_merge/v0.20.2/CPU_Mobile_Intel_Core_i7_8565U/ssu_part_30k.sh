#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-gpu

md5sum unifrac_30000.biom
md5sum unifrac_30000.tre

echo "===="
ssu -i unifrac_30000.biom -t unifrac_30000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== unweighted fp32 15k/30k ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 3 -m unweighted_fp32 -f -i unifrac_30000.biom -t unifrac_30000.tre -o unifrac_30k_2.p0 --mode partial --start 0 --stop 7500
taskset -c 0-3 time ssu -n 3 -m unweighted_fp32 -f -i unifrac_30000.biom -t unifrac_30000.tre -o unifrac_30k_2.p1 --mode partial --start 7500 --stop 15000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

