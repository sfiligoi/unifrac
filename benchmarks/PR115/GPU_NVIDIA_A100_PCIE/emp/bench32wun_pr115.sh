#!/bin/bash -x

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=6


md5sum /root/emp.90.min25.deblur.withtax.withtree.even1k.biom 
md5sum /root/emp90.5000_1000_rxbl_placement_pruned75.tog.tre



t1=`date +%s`
echo "=== Starting `date` ($t1)"
taskset -c 0-5 time ssu --mode partial --start 0 --stop 12573 -i /root/emp.90.min25.deblur.withtax.withtree.even1k.biom  -t /root/emp90.5000_1000_rxbl_placement_pruned75.tog.tre -m weighted_unnormalized_fp32 -n 1 -f -o /dev/shm/emp.weighted_unnormalized_fp32.dev.gpu.part

t2=`date +%s`
echo "=== End `date` ($t2)"
let dt=$t2-$t1
echo "Waltime: $dt"
ls -l /dev/shm/emp.weighted_unnormalized_fp32.dev.gpu.part
md5sum /dev/shm/emp.weighted_unnormalized_fp32.dev.gpu.part
rm -f /dev/shm/emp.weighted_unnormalized_fp32.dev.gpu.part
