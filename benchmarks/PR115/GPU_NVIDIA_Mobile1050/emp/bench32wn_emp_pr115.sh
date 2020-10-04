#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4


md5sum emp.90.min25.deblur.withtax.withtree.even1k.biom 
md5sum emp90.5000_1000_rxbl_placement_pruned75.tog.tre



t1=`date +%s`
echo "=== Starting `date` ($t1)"
taskset -c 0-3 time ./ssu --mode partial --start 0 --stop 12573 -i emp.90.min25.deblur.withtax.withtree.even1k.biom  -t emp90.5000_1000_rxbl_placement_pruned75.tog.tre -m weighted_normalized_fp32 -n 2 -f -o /tmp/emp.weighted_normalized_fp32.dev.gpu.part

t2=`date +%s`
echo "=== End `date` ($t2)"
let dt=$t2-$t1
echo "Waltime: $dt"

ls -l /tmp/emp.weighted_normalized_fp32.dev.gpu.part
rm -f /tmp/emp.weighted_normalized_fp32.dev.gpu.part
