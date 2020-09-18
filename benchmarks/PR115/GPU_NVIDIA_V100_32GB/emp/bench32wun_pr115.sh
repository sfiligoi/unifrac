#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8


md5sum  /home/mcdonadt/emp.90.min25.deblur.withtax.withtree.even1k.biom 
md5sum /projects/emp/03-otus/04-deblur/emp90.5000_1000_rxbl_placement_pruned75.tog.tre



t1=`date +%s`
echo "=== Starting `date` ($t1)"
taskset -c 0-7 time /home/isfiligoi/github/unifrac/sucpp/ssu --mode partial --start 0 --stop 12573 -i /home/mcdonadt/emp.90.min25.deblur.withtax.withtree.even1k.biom  -t /projects/emp/03-otus/04-deblur/emp90.5000_1000_rxbl_placement_pruned75.tog.tre -m weighted_unnormalized_fp32 -n 1 -f -o emp.weighted_unnormalized_fp32.dev.gpu.part

t2=`date +%s`
echo "=== End `date` ($t2)"
let dt=$t2-$t1
echo "Waltime: $dt"

