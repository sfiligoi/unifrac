#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=16

BIOM=/data/unifrac/x_merged.withplacement_even500.biom
TREE=/data/unifrac/archive-redbiom-070920-insertion_tree.relabelled.tre

md5sum $BIOM
md5sum $TREE

/root/unifrac/sucpp/ssu --mode partial-report -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f
t0=`date +%s`

for ((i=1; $i<19; i=$i+1)); do

let s2=4320*$i
let s1=$s2-4320

t1=`date +%s`
rm -f /root/emp3_8f.out.0
echo "=== Starting $i/36 `date` ($t1)"
taskset -c 0-15 time /root/unifrac/sucpp/ssu --mode partial --start $s1 --stop $s2  -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f -o /root/emp3_8f.out.0

t2=`date +%s`
echo "=== End $i/36 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime $i: $dt"

ls -l /root/emp3_8f.out.0

done

echo "====== Batch done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

rm -f /root/emp2_8f.out.0

