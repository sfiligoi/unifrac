#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-gpu

md5sum unifrac_40000.biom
md5sum unifrac_40000.tre

echo "===="
ssu -i unifrac_40000.biom -t unifrac_40000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== unweighted fp32 20k/40k ==="

t1=`date +%s`
taskset -c 0-3 time ssu -n 3 -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac_40k_4.p0 --mode partial --start 0 --stop 5000
taskset -c 0-3 time ssu -n 3 -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac_40k_4.p1 --mode partial --start 5000 --stop 10000
taskset -c 0-3 time ssu -n 3 -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac_40k_4.p2 --mode partial --start 10000 --stop 15000
taskset -c 0-3 time ssu -n 3 -m unweighted_fp32 -f -i unifrac_40000.biom -t unifrac_40000.tre -o unifrac_40k_4.p3 --mode partial --start 15000 --stop 20000
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== unweighted fp32 -f time: $dt ==="

