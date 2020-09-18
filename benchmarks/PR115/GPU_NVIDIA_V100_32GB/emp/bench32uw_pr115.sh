#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

BIOM=/home/mcdonadt/emp.90.min25.deblur.withtax.withtree.even1k.biom
TREE=/projects/emp/03-otus/04-deblur/emp90.5000_1000_rxbl_placement_pruned75.tog.tre

md5sum $BIOM
md5sum $TREE

/panfs/panfs1.ucsd.edu/panscratch/isfiligoi/bins.master.20200914/xeon/ssu --mode partial-report  -i $BIOM -t $TREE -m unweighted_fp32 -f

t1=`date +%s`
t0=${t1}
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting `date` ($t1)"
taskset -c 0-7 time ../bins.master.20200914/gpu/ssu --mode partial --start 0 --stop 12573  -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f -o /dev/shm/emp2_8f.out.0

t2=`date +%s`
echo "=== End `date` ($t2)"
let dt=$t2-$t1
echo "Waltime : $dt"

ls -l /dev/shm/emp2_8f.out.0

echo "====== All done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

rm -f /dev/shm/emp2_8f.out.0

