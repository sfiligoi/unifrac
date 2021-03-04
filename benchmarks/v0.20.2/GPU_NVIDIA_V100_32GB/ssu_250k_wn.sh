#!/bin/bash
#SBATCH --time 48:00:00 -p gpu --exclusive
hostname
lscpu
date
nvidia-smi

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

cd /panfs/panfs1.ucsd.edu/panscratch/isfiligoi/anaconda3_2020.11_20.2/benchmarks/ssu_gpu
source ../../setup_conda.source
conda activate unifrac-gpu


sz=250

let szfull=1000*sz
let stripes=500*sz

let stripes1=stripes/16

md5sum unifrac_250000.biom
md5sum unifrac_250000.tre

echo "===="
ssu -i unifrac_250000.biom -t unifrac_250000.tre -m weighted_normalized -o /dev/shm/unifrac.tmp --mode partial-report
echo "=== weighted_normalized 125k/250k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
let sstart=n*stripes1
let n2=n+1

if [ $n -lt 15 ]; then
let send=n2*stripes1
else
send=$stripes
fi



taskset -c 0-7 time ssu -m weighted_normalized -i unifrac_250000.biom -t unifrac_250000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
let sstart=n*stripes1
let n2=n+1
if [ $n -lt 15 ]; then
let send=n2*stripes1
else
send=$stripes
fi


taskset -c 0-7 time ssu -m weighted_normalized -f -i unifrac_250000.biom -t unifrac_250000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done

t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized -f time: $dt ==="

let stripes2=stripes/8

echo "=== weighted_normalized fp32 125k/250k ==="
rm -fr /dev/shm/unifrac.tmp
t1=`date +%s`
for n in 0 1 2 3 4 5 6 7; do
let sstart=n*stripes2
let n2=n+1
let send=n2*stripes2

taskset -c 0-7 time ssu -m weighted_normalized_fp32 -i unifrac_250000.biom -t unifrac_250000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
echo "=== weighted_normalized fp32 time: $dt ==="

t1=`date +%s`
for n in 0 1 2 3 4 5 6 7; do
let sstart=n*stripes2
let n2=n+1
let send=n2*stripes2

taskset -c 0-7 time ssu -m weighted_normalized_fp32 -f -i unifrac_250000.biom -t unifrac_250000.tre -o /dev/shm/unifrac.tmp --mode partial --start ${sstart} --stop ${send}
rm -fr /dev/shm/unifrac.tmp

done
t2=`date +%s`
let dt=t2-t1
rm -fr /dev/shm/unifrac.tmp
echo "=== weighted_normalized fp32 -f time: $dt ==="

