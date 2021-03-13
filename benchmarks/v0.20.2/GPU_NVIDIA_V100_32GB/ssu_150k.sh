#!/bin/bash
#SBATCH --time 24:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu_gpu
source ../../setup_conda.source
conda activate unifrac-gpu

md5sum unifrac_150000.biom
md5sum unifrac_150000.tre

sz=150 

let szfull=1000*sz
let stripes=500*sz

let stripes1=stripes/6
let stripes2=stripes/4

echo "===="
ssu -i unifrac_150000.biom -t unifrac_150000.tre -m unweighted -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== unweighted 75k/150k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 0-7 time ssu -m unweighted -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 0-7 time ssu -m unweighted -f -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial  --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted -f time: $dt ==="

echo "=== unweighted fp32 75k/150k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3; do
let sstart=n*stripes2
let n2=n+1
let send=n2*stripes2

taskset -c 0-7 time ssu -m unweighted_fp32 -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== unweighted fp32 time: $dt ==="

echo "=== weighted_normalized 75k/150k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5; do
let sstart=n*stripes1
let n2=n+1
let send=n2*stripes1

taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial  --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5; do
let sstart=n*stripes1
let n2=n+1 
let send=n2*stripes1

taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized -f time: $dt ==="


echo "=== weighted_normalized fp32 75k/150k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3; do
let sstart=n*stripes2
let n2=n+1 
let send=n2*stripes2

taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3; do
let sstart=n*stripes2
let n2=n+1
let send=n2*stripes2

taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_150000.biom -t unifrac_150000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 -f time: $dt ==="

