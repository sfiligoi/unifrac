#!/bin/bash -x

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=8

BIOM=/root/x_merged.withplacement_even500.biom
TREE=/root/archive-redbiom-070920-insertion_tree.relabelled.tre

md5sum $BIOM
md5sum $TREE

ssu --mode partial-report -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f
t0=`date +%s`

for ((i=1; $i<12; i=$i+1)); do

let s2=12800*$i
let s1=$s2-12800

t1=`date +%s`
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting $i/12 `date` ($t1)"
taskset -c 0-7 time ssu --mode partial --start $s1 --stop $s2  -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f -o /dev/shm/emp2_8f.out.0

t2=`date +%s`
echo "=== End $i/12 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime $i: $dt"

ls -l /dev/shm/emp2_8f.out.0

done

t1=`date +%s`
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting $i/12 `date` ($t1)"
taskset -c 0-7 time ssu --mode partial --start $s2 --stop 153619  -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f -o /dev/shm/emp2_8f.out.0

t2=`date +%s`
echo "=== End $i/12 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime $i: $dt"

ls -l /dev/shm/emp2_8f.out.0

echo "====== All done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

rm -f /dev/shm/emp2_8f.out.0

