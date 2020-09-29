#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=4
export OMP_NUM_THREADS=8


md5sum  /data/unifrac/emp.90.min25.deblur.withtax.withtree.even1k.biom 
md5sum /data/unifrac/emp90.5000_1000_rxbl_placement_pruned75.tog.tre



t1=`date +%s`
echo "=== Starting `date` ($t1)"
taskset -c 20-27 time /root/unifrac/sucpp/ssu --mode partial --start 0 --stop 12573 -i /data/unifrac/emp.90.min25.deblur.withtax.withtree.even1k.biom  -t /data/unifrac/emp90.5000_1000_rxbl_placement_pruned75.tog.tre -m weighted_unnormalized_fp32 -n 1 -f -o /root/emp.weighted_unnormalized_fp32.dev.gpu.part

t2=`date +%s`
echo "=== End `date` ($t2)"
let dt=$t2-$t1
echo "Waltime: $dt"

ls -l /root/emp.weighted_unnormalized_fp32.dev.gpu.part
rm -f /root/emp.weighted_unnormalized_fp32.dev.gpu.part

