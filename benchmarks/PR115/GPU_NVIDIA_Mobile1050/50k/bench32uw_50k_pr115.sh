#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=4

BIOM=ag_emp_even500.biom
TREE=ag_emp.tre

md5sum $BIOM
md5sum $TREE

./ssu --mode partial-report -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f
t0=`date +%s`

for ((i=1; $i<8; i=$i+1)); do

let s2=3200*$i
let s1=$s2-3200

t1=`date +%s`
rm -f /tmp/emp3_8f.out.1
echo "=== Starting $i/8 `date` ($t1)"
taskset -c 0-3 time ./ssu --mode partial --start $s1 --stop $s2  -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f -o /tmp/emp3_8f.out.1

t2=`date +%s`
echo "=== End $i/8 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime $i: $dt"

ls -l /tmp/emp3_8f.out.1

done

t1=`date +%s`
rm -f /tmp/emp3_8f.out.1
echo "=== Starting $i/8 `date` ($t1)"
taskset -c 0-3 time ./ssu --mode partial --start $s2 --stop 25043  -i $BIOM -t $TREE -m unweighted_fp32 -n 1 -f -o /tmp/emp3_8f.out.1

t2=`date +%s`
echo "=== End $i/8 `date` ($t2)"
let dt=$t2-$t1
echo "Waltime $i: $dt"

ls -l /tmp/emp2_8f.out.1

echo "====== Batch done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

rm -f /tmp/emp2_8f.out.1

