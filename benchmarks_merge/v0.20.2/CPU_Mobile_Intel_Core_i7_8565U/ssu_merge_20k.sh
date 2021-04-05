#!/bin/bash
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

source ../../conda_setup.sh
conda activate unifrac-gpu

md5sum unifrac_20000.biom
md5sum unifrac_20000.tre

echo "===="
ssu -i unifrac_20000.biom -t unifrac_20000.tre -m unweighted -o unifrac.tmp --mode partial-report

echo "=== merge 10k/20k ==="
rm -f unifrac_20k.h5 
t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted_fp32 -f -i unifrac_20000.biom -t unifrac_20000.tre -o unifrac_20k.h5 --mode merge-partial --partial-pattern 'unifrac_20k_2.p*' --format hdf5 --pcoa=0
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== merge time time: $dt ==="
rm -f unifrac_20k.pcoa_10.h5 
t1=`date +%s`
taskset -c 0-3 time ssu -m unweighted_fp32 -f -i unifrac_20000.biom -t unifrac_20000.tre -o unifrac_20k.pcoa_10.h5 --mode merge-partial --partial-pattern 'unifrac_20k_2.p*' --format hdf5 --pcoa=10
t2=`date +%s`
let dt=t2-t1
rm -fr unifrac.tmp
echo "=== merge PCoA=10 time time: $dt ==="



