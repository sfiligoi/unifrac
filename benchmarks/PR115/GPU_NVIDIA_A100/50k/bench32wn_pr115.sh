#!/bin/bash -x
#SBATCH --time 24:00:00 -p gpu --exclusive

export ACC_DEVICE_NUM=0
export OMP_NUM_THREADS=6

BIOM=ag_emp_even500.biom
TREE=ag_emp.tre

md5sum $BIOM
md5sum $TREE

./ssu --mode partial-report  -i $BIOM -t $TREE -m weighted_normalized_fp32 -f

t1=`date +%s`
t0=${t1}
rm -f /dev/shm/emp2_8f.out.0
echo "=== Starting `date` ($t1)"
taskset -c 0-5 time ./ssu --mode partial --start 0 --stop 25043  -i $BIOM -t $TREE -m weighted_normalized_fp32 -n 1 -f -o /dev/shm/emp2_8f.out.0

t2=`date +%s`
echo "=== End `date` ($t2)"
let dt=$t2-$t1
echo "Waltime : $dt"

ls -l /dev/shm/emp2_8f.out.0

echo "====== All done ======"
let dt=$t2-$t0
echo "Waltime total: $dt"

rm -f /dev/shm/emp2_8f.out.0
